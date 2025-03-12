class Api::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :process_payment]

  # GET /api/orders
  def index
    @orders = current_user.orders
    render json: @orders, status: :ok
  end

  # POST /api/orders
  def create
    @order = current_user.orders.build(order_params)
    @order.situation = :awaiting_payment

    if @order.save
      render json: {
        success: true,
        order: @order.as_json(except: [:created_at, :updated_at])
      }, status: :created
    else
      render json: {
        success: false,
        errors: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/orders/:id
  def show
    render json: @order
  end

  # PATCH /api/orders/:id
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # POST /api/orders/:id/process_payment
  def process_payment
    payment_service = PaymentProcessor.new(
      @order,
      payment_params[:payment_method],
      payment_params[:installments]
    )

    if payment_service.process
      render json: {
        success: true,
        message: 'Pagamento processado com sucesso',
        order: @order
      }
    else
      render json: {
        success: false,
        errors: payment_service.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Pedido não encontrado' }, status: :not_found
  end

  def order_params
    params.require(:orderData).permit(
      :address_id,
      orders_products_attributes: [:product_id, :quantity]
    )
  end

  def payment_params
    params.require(:payment).permit(
      :payment_method,
      :installments
    )
  end
end

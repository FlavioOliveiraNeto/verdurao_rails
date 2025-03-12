class Api::AddressesController < ApplicationController
    before_action :authenticate_user!

    # POST /addresses
    def create
      @address = Address.new(address_params)

      if @address.save
        current_user.users_addresses.create(address: @address, default: params[:default] || 0)
        render json: @address, status: :created
      else
        render json: @address.errors, status: :unprocessable_entity
      end
    end

    # GET /addresses
    def index
      @addresses = current_user.addresses
      render json: @addresses
    end

    private

    def address_params
      params.require(:address).permit(
        :zip_code, :street, :number, :complement, :neighborhood, :city, :state
      )
    end
end

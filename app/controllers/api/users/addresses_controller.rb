module Users
    class AddressesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_users_address, only: [:update, :destroy]

      # PATCH /users/addresses/:id
      def update
        if @users_address.update(users_address_params)
          render json: @users_address
        else
          render json: @users_address.errors, status: :unprocessable_entity
        end
      end

      # DELETE /users/addresses/:id
      def destroy
        @users_address.destroy
        head :no_content
      end

      private

      def set_users_address
        @users_address = current_user.users_addresses.find(params[:id])
      end

      def users_address_params
        params.require(:users_address).permit(:default)
      end
    end
end
class PurchasesController < ApplicationController
  def index
    @purchase = PurchaseForm.new
    @item = Item.find(params[:item_id])
  end

  def create
    @purchase = PurchaseForm.new(purchase_params)
    if @purchase.valid?
      @purchase.save
      redirect_to root_path
    else
      render action: :index
    end
  end

  private

  def purchase_params
    params.require(:purchase_form).permit(
      :postal,
      :prefecture_id,
      :city,
      :address,
      :building_name,
      :phone_number,
      :purchase_id
    ).merge(item_id: params[:item_id], user_id: current_user.id)
  end
end

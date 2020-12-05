class PurchasesController < ApplicationController
  before_action :find_item

  def index
    @purchase = PurchaseForm.new
  end

  def create
    @purchase = PurchaseForm.new(purchase_params)
    if @purchase.valid?
      @purchase.save!
      pay_item
      redirect_to root_path
    else
      render action: :index
    end
  end

  private

  def find_item
    @item = Item.find(params[:item_id])
  end

  def purchase_params
    params.require(:purchase_form).permit(
      :postal,
      :prefecture_id,
      :city,
      :address,
      :building_name,
      :phone_number,
      :purchase_id
    ).merge(item_id: params[:item_id], user_id: current_user.id, token: params[:token])
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card: purchase_params[:token],
      currency: 'jpy'
    )
  end
end

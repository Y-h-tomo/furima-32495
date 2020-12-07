class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_item
  before_action :move_to_root
  before_action :purchase_move

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

  def move_to_root
    redirect_to root_path if current_user == @item.user
  end

  def purchase_move
    redirect_to root_path unless Purchase.find_by(item_id: params[:item_id]).nil?
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

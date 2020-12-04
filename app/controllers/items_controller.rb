class ItemsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_item, only: %i[show edit update]
  before_action :move_to_index, only: %i[edit update]

  def index
    @item = Item.all.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :description,
      :image,
      :price,
      :category_id,
      :condition_id,
      :shipping_cost_id,
      :prefecture_id,
      :shipping_date_id
    ).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless current_user == @item.user
  end
end

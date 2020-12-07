module ItemSupport
  def item_info(item)
    fill_in 'item-name', with: item.name
    fill_in 'item-info', with: item.description
    select 'レディース', from: 'item-category'
    select '新品、未使用', from: 'item-sales-status'
    select '着払い(購入者負担)', from: 'item-shipping-fee-status'
    select '北海道', from: 'item-prefecture'
    select '1〜2日で発送', from: 'item-scheduled-delivery'
    fill_in 'item-price', with: item.price
  end

  def item_false_info
    fill_in 'item-name', with: ''
    fill_in 'item-info', with: ''
    select '--', from: 'item-category'
    select '--', from: 'item-sales-status'
    select '--', from: 'item-shipping-fee-status'
    select '--', from: 'item-prefecture'
    select '--', from: 'item-scheduled-delivery'
    fill_in 'item-price', with: ''
  end

  def item_click(item)
    # 商品をクリックする
    find_link(item.name, href: "/items/#{item.id}").click
    # 商品の詳細ページに遷移したことを確認する
    expect(current_path).to eq "/items/#{item.id}"
  end
end

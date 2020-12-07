module SignInSupport
  def sign_in(user)
    # ログインする
    visit new_user_session_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    find('input[name="commit"]').click
    # トップページへ遷移することを確認する
    expect(current_path).to eq root_path
  end
end

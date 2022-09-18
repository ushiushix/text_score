# coding: utf-8
TScore::App.controllers :profiles do

  get :show, :with => :id do
    @account = Account.find(params[:id])
    if (params[:id].to_i != current_account.id && current_account.role != 'admin') || !@account
      flash[:error] = '閲覧・編集する権限がありません'
      redirect url(:songs, :index)
    end
    render 'profiles/show'
  end
  
  get :edit, :with => :id do
    @account = Account.find(params[:id])
    if (params[:id].to_i != current_account.id && current_account.role != 'admin') || !@account
      flash[:error] = '閲覧・編集する権限がありません'
      redirect url(:songs, :index)
    end
    render 'profiles/edit'
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if (params[:id].to_i != current_account.id && current_account.role != 'admin') || !@account
      flash[:error] = '閲覧・編集する権限がありません'
      redirect url(:songs, :index)
    end
    upd = params[:account].slice(:password, :password_confirmation)
    if upd[:password] != upd[:password_confirmation] || upd.empty?
      flash[:error] = 'パスワードと確認用パスワードが一致しません。'
      render 'profiles/edit'
    end
    if @account.update(upd)
      flash[:notice] = 'プロファイルが更新されました。'
      redirect url(:profiles, :show, :id => @account.id)
    else
      render 'profiles/edit'
    end
  end
end

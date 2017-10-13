# coding: utf-8
TScore::App.controllers :profiles do

  get :show, :with => :id do
    @account = Account.find(params[:id])
    if (params[:id] != current_account.id && current_account.role != 'admin') || !@account
      flash[:error] = '閲覧・編集する権限がありません'
      redirect url(:songs, :index)
    end
    render 'profiles/show'
  end
  
  get :edit, :with => :id do
    @account = Account.find(params[:id])
    if (params[:id] != current_account.id && current_account.role != 'admin') || !@account
      flash[:error] = '閲覧・編集する権限がありません'
      redirect url(:songs, :index)
    end
    render 'profiles/edit'
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if (params[:id] != current_account.id && current_account.role != 'admin') || !@account
      flash[:error] = '閲覧・編集する権限がありません'
      redirect url(:songs, :index)
    end
    if params[:account][:password] != params[:account][:password_confirmation]
      flash[:error] = 'パスワードと確認用パスワードが一致しません。'
      render 'profiles/edit'
    end
    if @account.update_attributes(params[:account])
      flash[:notice] = 'プロファイルが更新されました。'
      redirect url(:profiles, :show, :id => @account.id)
    else
      render 'profiles/edit'
    end
  end
end

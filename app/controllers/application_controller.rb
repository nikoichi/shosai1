class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_arrays, :set_view_rate

  def after_sign_out_path_for(resource)
    '/users/sign_in' # サインアウト後のリダイレクト先URL
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:nickname, :avatar)
  end

  def set_arrays
    @fundamental_rates = [:overall_rate, :change_life_rate, :learning_rate, :sympathy_rate, :interesting_rate, :impression_rate]
    @fundamental_names = ["総合評価", "人生を変えた", "学びを得た", "共感できた", "面白い", "感動した" ]
    @generation_rates = [:under_elementary_school_age_rate, :junior_high_school_student_rate, :high_school_student_rate, :university_student_rate, :younger_20s_rate, :in_30s40s_rate, :in_50s60s_rate, :after_retirement_rate]
    @generation_names = ["〜小学生", "中学生", "高校生", "大学生", "〜20歳代", "30〜40歳代", "50歳〜", "退職後"]
  end

  #各評価の平均値の配列を取得。
  def set_rate_ave_hashs(reviews)
    @fundamental_rate_ave_values = rate_ave_values_hash(@fundamental_rates, reviews)
    @fundamental_rate_ave_stars = rate_ave_stars_hash(@fundamental_rates, reviews)
    @genetation_rate_ave_values = rate_ave_values_hash(@generation_rates, reviews)
    @generation_rate_ave_stars = rate_ave_stars_hash(@generation_rates, reviews)
  end

  #各rateに相当する位置に1.0~5.0まで0.1きざみの値が入った新しいハッシュを返す。
  def rate_ave_values_hash(rates, reviews)
    averages =[]
    rates.each do |rate|
      averages << rate_ave_value(reviews.where.not(rate.to_s => 0).average(rate)) #平均を算出する際に、0の評価を除いた。rateはシンボルなのでto_sメソッドで文字列化し、notメソッドを適用。
    end
    return averages_hash = Hash[*rates.zip(averages).flatten]
  end

  #1.0~5.0まで0.1きざみの値を返す。aveがnilの場合はnilを返す。
  def rate_ave_value(ave) #ave: 1.000~5.000
    if ave
      a = ave * 10 #a: 10.00~50.00
      b = a.round #b: 10~50 _1きざみ
      c = b / 10.0 #c: 1.0 ~5.0 _0.1きざみ
    else
      c = nil
    end
    return c
  end

  #各rateに相当する位置に10~50まで5きざみの値が入った新しいハッシュを返す。
  def rate_ave_stars_hash(rates, reviews)
    averages =[]
    rates.each do |rate|
      averages << rate_ave_star(reviews.where.not(rate.to_s => 0).average(rate))  #平均を算出する際に、0の評価を除いた。rateはシンボルなのでto_sメソッドで文字列化し、notメソッドを適用。
    end
    return averages_hash = Hash[*rates.zip(averages).flatten]
  end

  #10~50まで5きざみの値を返す。（cssの名前に合わせるため。）aveがnilの場合はnilを返す。
  def rate_ave_star(ave) #ave: 1.000~5.000
    if ave
      a = ave * 2 #a: 2.000~10.00
      b = a.round #b: 2~10 _1きざみ
      c = b * 5 # c: 10~50 _5きざみ
    else
      c = nil
    end
    return c
  end

  #すべてのアクションで@view_rateと@view_nameをセット。ランキングへのアクセスの際のみ、params[:view_fund_rate]かparams[:view_gene_rate]がセットされており、それに応じた表示となる。
  def set_view_rate
    if params[:view_fund_rate]
      @view_rate = @fundamental_rates[params[:view_fund_rate].to_i]
      @view_name = @fundamental_names[params[:view_fund_rate].to_i]
    elsif params[:view_gene_rate]
      @view_rate = @generation_rates[params[:view_gene_rate].to_i]
      @view_name = @generation_names[params[:view_gene_rate].to_i]
    else
      @view_rate = :overall_rate
      @view_name = "総合評価"
    end
  end

end

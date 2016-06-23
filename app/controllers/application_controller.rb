class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_arrays

  def after_sign_out_path_for(resource)
    '/users/sign_in' # サインアウト後のリダイレクト先URL
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:nickname, :avatar)
  end

  def set_arrays
    @fundamental_rates = review_columns = [:overall_rate, :change_life_rate, :learning_rate, :sympathy_rate, :interesting_rate, :impression_rate]
    @fundamental_names = ["総合評価", "人生を変えた", "学びを得た", "共感できた", "面白い", "感動した" ]
    @generation_rates = [:under_elementary_school_age_rate, :junior_high_school_student_rate, :high_school_student_rate, :university_student_rate, :younger_20s_rate, :in_30s40s_rate, :in_50s60s_rate, :after_retirement_rate]
    @generation_names = ["〜小学生", "中学生", "高校生", "大学生", "〜20歳代", "30〜40歳代", "50歳〜", "退職後"]
  end

  #各rateに相当する位置に1.0~5.0まで0.1きざみの値が入った新しい配列を返す。
  def rate_ave_values_array(rates, reviews)
    ary =[]
    rates.each do |rate|
      if reviews.average(rate)
        ary << rate_ave_value(reviews.average(rate))
      else
        ary << nil
      end
    end
    return ary
  end

  #1.0~5.0まで0.1きざみの値を返す。
  def rate_ave_value(ave) #ave: 1.000~5.000
    a = ave * 10 #a: 10.00~50.00
    b = a.round #b: 10~50 _1きざみ
    c = b / 10.0 #c: 1.0 ~5.0 _0.1きざみ
    return c
  end

  #各rateに相当する位置に10~50まで5きざみの値が入った新しい配列を返す。
  def rate_ave_stars_array(rates, reviews)
    ary =[]
    rates.each do |rate|
      if reviews.average(rate)
        ary << rate_ave_star(reviews.average(rate))
      else
        ary << nil
      end
    end
    return ary
  end

  #10~50まで5きざみの値を返す。（cssの名前に合わせるため。）
  def rate_ave_star(ave) #ave: 1.000~5.000
    a = ave * 2 #a: 2.000~10.00
    b = a.round #b: 2~10 _1きざみ
    c = b * 5 # c: 10~50 _5きざみ
    return c
  end

end

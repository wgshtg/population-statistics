class StatisticsController < ApplicationController
  require 'uri'
  require 'net/http'
  
  def index
    @AreaNames = [["樹林區"], ["金山區"], ["八里區"]]
    @Years = [["107", 107], ["106", 106], ["105", 105]]
    @Months = [["1月", 1], ["2月", 2], ["3月", 3]]
    @Sexs = [["男"], ["女"], ["全部"]]
    @Ages = [["10", 10], ["20", 20], ["30", 30]]
    
  end
  
  def query
    areaName = params[:AreaName]
    year = params[:Year]
    month = params[:Month]
    sex = params[:Sex]
    age_Min = params[:AgeMin].to_i
    age_Max = params[:AgeMax].to_i
    
    
    filter_arr = []
    filter_arr.push("AreaName eq #{areaName}") if areaName.present?
    filter_arr.push("Year eq #{year}") if year.present?
    filter_arr.push("Month eq #{month}") if month.present?
    filter = filter_arr.join(" and ")
    url = "http://data.ntpc.gov.tw/od/data/api/7C7797A9-95D0-4A9A-B220-E72CD65E8297?$format=json&$filter=#{filter}&$orderby=Age, Month"
    resp = Net::HTTP.get(URI(URI.escape(url)))
    json = JSON.parse(resp)
    
    max = 100
    min = 0
    
    max = ( age_Max.to_i > 100 ) ? 100 : age_Max.to_i if age_Max.is_a?(Integer)
    min = ( age_Min.to_i < 0 ) ? 0 : age_Min.to_i if age_Min.is_a?(Integer)
    
    male = {}
    female = {}
    json.each do |j|
      age = j["Age"].slice(0, j["Age"].size-1).to_i
      if age <= max && age >= min
        male.store(age, j["Male"])
        female.store(age, j["Female"])
      end
    end
    if sex === "男"
      @summary = male
      @colors = ["#3582ff"]
    elsif sex === "女"
      @summary = female
      @colors = ["#ff4fd8"]
    else
      @summary = [
            {name: "Male", data: male},
            {name: "Female", data: female}
          ]
      @colors = ["#3582ff", "#ff4fd8"]
    end
  end
end

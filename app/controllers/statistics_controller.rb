class StatisticsController < ApplicationController
  require 'uri'
  require 'net/http'
  
  def index
    @AreaNames = [["萬里區"], ["金山區"], ["板橋區"], ["汐止區"], ["深坑區"], 
                  ["石碇區"], ["瑞芳區"], ["平溪區"], ["雙溪區"], ["貢寮區"], 
                  ["新店區"], ["坪林區"], ["烏來區"], ["永和區"], ["中和區"], 
                  ["土城區"], ["三峽區"], ["樹林區"], ["鶯歌區"], ["三重區"], 
                  ["新莊區"], ["泰山區"], ["林口區"], ["蘆洲區"], ["五股區"],
                  ["八里區"], ["淡水區"], ["三芝區"], ["石門區"]
                 ]
    @Years = [ *(90 .. 100) ]
    @Months = []
    puts @Months
    @Sexs = [["男"], ["女"], ["全部"]]
    @Ages = []
    @Charts = [["Line"], ["Column"], ["Column(stacked)"], ["Bar"], ["Area"], ["Scatter"]]
    [ *(1 .. 12) ].each do |n|
      @Months.push(["#{n}月", n])
    end
    [ *(0 .. 100) ].each do |n|
      @Ages.push(["#{n}歲", n])
    end
  end
  
  def query
    areaName = params[:AreaName]
    year = params[:Year]
    month = params[:Month]
    sex = params[:Sex]
    age_Min = params[:AgeMin].to_i
    age_Max = params[:AgeMax].to_i
    @chart = params[:Chart]
    
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

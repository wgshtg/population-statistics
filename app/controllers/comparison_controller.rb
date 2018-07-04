class ComparisonController < ApplicationController
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
  
  def compare
    areaName1 = params[:AreaName1]
    year1 = params[:Year1]
    month1 = params[:Month1]
    areaName2 = params[:AreaName2]
    year2 = params[:Year2]
    month2 = params[:Month2]
    sex = params[:Sex]
    age_Min = params[:AgeMin].to_i
    age_Max = params[:AgeMax].to_i
    @chart = params[:Chart]
    
    filter_arr1 = []
    
    filter_arr1.push("AreaName eq #{areaName1}") if areaName1.present?
    filter_arr1.push("Year eq #{year1}") if year1.present?
    filter_arr1.push("Month eq #{month1}") if month1.present?
    filter = filter_arr1.join(" and ")
    
    url = "http://data.ntpc.gov.tw/od/data/api/7C7797A9-95D0-4A9A-B220-E72CD65E8297?$format=json&$filter=#{filter}&$orderby=Age, Month"
    resp1 = Net::HTTP.get(URI(URI.escape(url)))
    json1 = JSON.parse(resp1)
    
    filter_arr2 = []
    filter_arr2.push("AreaName eq #{areaName2}") if areaName2.present?
    filter_arr2.push("Year eq #{year2}") if year2.present?
    filter_arr2.push("Month eq #{month2}") if month2.present?
    filter = filter_arr2.join(" and ")
    
    url2 = "http://data.ntpc.gov.tw/od/data/api/7C7797A9-95D0-4A9A-B220-E72CD65E8297?$format=json&$filter=#{filter}&$orderby=Age, Month"
    resp2 = Net::HTTP.get(URI(URI.escape(url2)))
    json2 = JSON.parse(resp2)
    
    puts json1
    puts json2
    max = 100
    min = 0
    
    max = ( age_Max.to_i > 100 ) ? 100 : age_Max.to_i if age_Max.is_a?(Integer)
    min = ( age_Min.to_i < 0 ) ? 0 : age_Min.to_i if age_Min.is_a?(Integer)
    
    male1 = {}
    female1 = {}
    male2 = {}
    female2 = {}
    
    json1.each do |j|
      age = j["Age"].slice(0, j["Age"].size-1).to_i
      if age <= max && age >= min
        male1.store(age, j["Male"])
        female1.store(age, j["Female"])
      end
    end
    
    json2.each do |j|
      age = j["Age"].slice(0, j["Age"].size-1).to_i
      if age <= max && age >= min
        male2.store(age, j["Male"])
        female2.store(age, j["Female"])
      end
    end
    puts male1
    puts male2
    if sex === "男"
      @summary = [
          {name: areaName1, data: male1},
          {name: areaName2, data: male2}
        ]
      @colors = ["#0460f4", "#45ff02"]
    elsif sex === "女"
      @summary = [
          {name: areaName1, data: female1},
          {name: areaName2, data: female2}
        ]
      @colors = ["#ff00d8", "#ffe900"]
    else
      @summary = [
            {name: areaName1+"-Male", data: male1},
            {name: areaName1+"-Female", data: female1},
            {name: areaName2+"-Male", data: male2},
            {name: areaName2+"-Female", data: female2}
          ]
      @colors = ["#0460f4", "#ff00d8", "#45ff02", "#ffe900"]
    end
  end
end
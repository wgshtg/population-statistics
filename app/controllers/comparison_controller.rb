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
      
  end
end
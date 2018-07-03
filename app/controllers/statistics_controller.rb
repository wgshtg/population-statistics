class StatisticsController < ApplicationController
  
  def index
    @AreaNames = [["樹林區"], ["金山區"], ["八里區"]]
    @Years = [["107", 107], ["106", 106], ["105", 105]]
    @Months = [["1月", 1], ["2月", 2], ["3月", 3]]
    @Sexs = [["男"], ["女"]]
    @Ages = [["1~10", 1], ["11~20", 11], ["21~30", 21]]
    @result = {"20歲":"1137","21歲":"1393","28歲":"1351","30歲":"1398"}
    
  end
  
  def query
    @data = [{"AreaName":"樹林區","Year":"106","Month":"12","Male":"1137","Female":"1067","Age":"29歲"},
               {"AreaName":"樹林區","Year":"106","Month":"12","Male":"1393","Female":"1256","Age":"21歲"},
               {"AreaName":"樹林區","Year":"106","Month":"12","Male":"1351","Female":"1285","Age":"28歲"},
               {"AreaName":"樹林區","Year":"106","Month":"12","Male":"1398","Female":"1274","Age":"30歲"}]
    @result = {}
    @data.each do |obj|
      @result.store(obj[:Age], obj[:Male])
    end
    if !params[:AreaName].present?
      @result.store("1歲", "1111")
    end
  end
end

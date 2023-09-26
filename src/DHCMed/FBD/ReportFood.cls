/// 名称 : DHCMed.FBD.ReportFood
/// 描述 : 暴露信息
Class DHCMed.FBD.ReportFood Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.FBD.Report [ Cardinality = parent, Inverse = ChildFood ];

/// 食品名称
Property RFFoodName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 食品品牌
Property RFFoodBrand As %String(MAXLEN = 100, TRUNCATE = 1);

/// 生产厂家
Property RFManufacturer As %String(MAXLEN = 100, TRUNCATE = 1);

/// 购买地点
Property RFWhereToBuy As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进食场所
Property RFEatingPlaces As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进食日期
Property RFEatingDate As %Date;

/// 进食时间
Property RFEatingTime As %Time;

/// 进食人数
Property RFEatingNum As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他人是否发病
Property RFIsIncidence As %Boolean;

/// 是否采样
Property RFIsSampling As %Boolean;

/// add 2018-12-03 
/// 食品分类           1肉与肉制品 2蔬菜类及其制品 3水果类及其制品(包括果脯和蜜线)……
Property RFFoodType As DHCMed.SS.Dictionary;

/// 加工包装方式       1餐饮服务业 2家庭自制 3预包装 4散装(包括简易包装）5其他
Property RFPacking As DHCMed.SS.Dictionary;

/// 进食场所类型分类   1家庭 2餐饮服务业 3集体食堂 4零售市场 5农村宴席 6其他
Property RFEatingSiteCate As DHCMed.SS.Dictionary;

/// 进食场所类型
Property RFEatingSite As DHCMed.SS.Dictionary;

/// 购买场所类型分类   1家庭 2餐饮服务业 3集体食堂 4零售市场 5其他
Property RFBuySiteCate As DHCMed.SS.Dictionary;

/// 购买场所类型
Property RFBuySite As DHCMed.SS.Dictionary;

/// 进食地点类型 1境内 2境外
Property RFEatingType As DHCMed.SS.Dictionary;

/// 进食地点省
Property RFEatProvince As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进食地点市
Property RFEatCity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 进食地点县
Property RFEatCounty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 购买地点类型 1境内 2境外
Property RFBuyType As DHCMed.SS.Dictionary;

/// 购买地点省
Property RFBuyProvince As %String(MAXLEN = 100, TRUNCATE = 1);

/// 购买地点市
Property RFBuyCity As %String(MAXLEN = 100, TRUNCATE = 1);

/// 购买地点县
Property RFBuyCounty As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  取暴露信息
/// Table：       DHCMed.FBD.ReportFood
/// Input：       Id : DHCMed.FBD.ReportFood.ID
/// Return：      返回Object
/// w ##class(DHCMed.FBD.ReportFood).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.FBD.ReportFood
{
	New (aID)
	Quit:'##class(DHCMed.FBD.ReportFood).%ExistsId(aID) ""
	Set obj=##class(DHCMed.FBD.ReportFood).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  更新暴露信息
/// Table：       DHCMed.FBD.ReportFood
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.ReportFood).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set FoodName=$p(aInputStr,aSeparate,3)
	Set FoodBrand=$p(aInputStr,aSeparate,4)
	Set Manufacturer=$p(aInputStr,aSeparate,5)
	Set WhereToBuy=$p(aInputStr,aSeparate,6)
	Set EatingPlaces=$p(aInputStr,aSeparate,7)
	Set EatingDate=$p(aInputStr,aSeparate,8)
	Set EatingTime=$p(aInputStr,aSeparate,9)
	Set EatingNum=$p(aInputStr,aSeparate,10)
	Set IsIncidence=$p(aInputStr,aSeparate,11)
	Set IsSampling=$p(aInputStr,aSeparate,12)
	Set FoodType=$p(aInputStr,aSeparate,13)
	Set Packing=$p(aInputStr,aSeparate,14)
	Set EatingSiteCate=$p(aInputStr,aSeparate,15)
	Set EatingSite=$p(aInputStr,aSeparate,16)
	Set BuySiteCate=$p(aInputStr,aSeparate,17)
	Set BuySite=$p(aInputStr,aSeparate,18)
	Set EatingType=$p(aInputStr,aSeparate,19)
	Set EatProvince=$p(aInputStr,aSeparate,20)
	Set EatCity=$p(aInputStr,aSeparate,21)
	Set EatCounty=$p(aInputStr,aSeparate,22)
	Set BuyType=$p(aInputStr,aSeparate,23)
	Set BuyProvince=$p(aInputStr,aSeparate,24)
	Set BuyCity=$p(aInputStr,aSeparate,25)
	Set BuyCounty=$p(aInputStr,aSeparate,26)
	Quit:(Parref="") return
	Quit:(FoodName="")||(WhereToBuy="")||(EatingPlaces="") return
	Quit:(EatingDate="")||(EatingTime="")||(EatingNum="") return
	Quit:(IsIncidence="") return
	
	Quit:(FoodType="")||(Packing="") return
	Quit:(EatingType="")||(BuyType="") return
	Set objParref=##class(DHCMed.FBD.Report).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objFoodType=##class(DHCMed.SS.Dictionary).GetObjById(FoodType)
	Quit:'$IsObject(objFoodType) return
	Set objPacking=##class(DHCMed.SS.Dictionary).GetObjById(Packing)
	Quit:'$IsObject(objPacking) return
	/*Set objSiteCate=##class(DHCMed.SS.Dictionary).GetObjById(EatingSiteCate)
	Quit:'$IsObject(objSiteCate) return
	Set objSite=##class(DHCMed.SS.Dictionary).GetObjById(EatingSite)
	Set objBuySiteCate=##class(DHCMed.SS.Dictionary).GetObjById(BuySiteCate)
	Quit:'$IsObject(objBuySiteCate) return*/
	Set objBuySite=##class(DHCMed.SS.Dictionary).GetObjById(BuySite)
	Set objEating=##class(DHCMed.SS.Dictionary).GetObjById(EatingType)
	Quit:'$IsObject(objEating) return
	Set objBuy=##class(DHCMed.SS.Dictionary).GetObjById(BuyType)
	Quit:'$IsObject(objBuy) return
	
	Set:EatingDate'="" EatingDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(EatingDate)
	Set:EatingTime[":" EatingTime=$zth(EatingTime,1)
	Set EatingTime=+EatingTime
	
	If (ChildSub="") {
		Set obj=##class(DHCMed.FBD.ReportFood).%New()
	} Else {
		Set obj=##class(DHCMed.FBD.ReportFood).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.RFFoodName=FoodName
	Set obj.RFFoodBrand=FoodBrand
	Set obj.RFManufacturer=Manufacturer
	Set obj.RFWhereToBuy=WhereToBuy
	Set obj.RFEatingPlaces=EatingPlaces
	Set obj.RFEatingDate=EatingDate
	Set obj.RFEatingTime=EatingTime
	Set obj.RFEatingNum=EatingNum
	Set obj.RFIsIncidence=IsIncidence
	Set obj.RFIsSampling=IsSampling
	Set obj.RFFoodType=objFoodType
	Set obj.RFPacking=objPacking
	Set obj.RFEatingSiteCate=EatingSiteCate
	Set obj.RFEatingSite=EatingSite
	Set obj.RFBuySiteCate=BuySiteCate
	Set obj.RFBuySite=objBuySite
	Set obj.RFEatingType=objEating
	Set obj.RFEatProvince=EatProvince 
	Set obj.RFEatCity=EatCity     
	Set obj.RFEatCounty=EatCounty   
	Set obj.RFBuyType=objBuy
	Set obj.RFBuyProvince=BuyProvince
	Set obj.RFBuyCity=BuyCity    
	Set obj.RFBuyCounty=BuyCounty  
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhaoyu
/// CreatDate：   2014-11-19
/// Description:  删除暴露信息
/// Table：       DHCMed.FBD.ReportFood
/// Input：       Id : DHCMed.FBD.ReportFood.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.FBD.ReportFood).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.FBD.ReportFood).%DeleteId(aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RFFoodName</Value>
</Value>
<Value name="3">
<Value>RFFoodBrand</Value>
</Value>
<Value name="4">
<Value>RFManufacturer</Value>
</Value>
<Value name="5">
<Value>RFWhereToBuy</Value>
</Value>
<Value name="6">
<Value>RFEatingPlaces</Value>
</Value>
<Value name="7">
<Value>RFEatingDate</Value>
</Value>
<Value name="8">
<Value>RFEatingTime</Value>
</Value>
<Value name="9">
<Value>RFEatingNum</Value>
</Value>
<Value name="10">
<Value>RFIsIncidence</Value>
</Value>
<Value name="11">
<Value>RFIsSampling</Value>
</Value>
<Value name="12">
<Value>RFFoodType</Value>
</Value>
<Value name="13">
<Value>RFPacking</Value>
</Value>
<Value name="14">
<Value>RFEatingSiteCate</Value>
</Value>
<Value name="15">
<Value>RFEatingSite</Value>
</Value>
<Value name="16">
<Value>RFBuySiteCate</Value>
</Value>
<Value name="17">
<Value>RFBuySite</Value>
</Value>
<Value name="18">
<Value>RFEatingType</Value>
</Value>
<Value name="19">
<Value>RFEatProvince</Value>
</Value>
<Value name="20">
<Value>RFEatCity</Value>
</Value>
<Value name="21">
<Value>RFEatCounty</Value>
</Value>
<Value name="22">
<Value>RFBuyType</Value>
</Value>
<Value name="23">
<Value>RFBuyProvince</Value>
</Value>
<Value name="24">
<Value>RFBuyCity</Value>
</Value>
<Value name="25">
<Value>RFBuyCounty</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("F")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("F")</IdLocation>
<IndexLocation>^DHCMed.FBD.ReportI("RF")</IndexLocation>
<StreamLocation>^DHCMed.FBD.ReportFoodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

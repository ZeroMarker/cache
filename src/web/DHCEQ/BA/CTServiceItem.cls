Class web.DHCEQ.BA.CTServiceItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据扩展ID获取服务项目
/// w ##Class(web.DHCEQ.BA.CTServiceItem).GetServiceByExID(405,113)
ClassMethod GetServiceByExID(ExType, Item)
{
	n ServiceItemDR,RowID
	s ServiceItemDR=""
	s RowID=""
	f  s RowID=$o(^DHCEQCCode("DHCEQCServiceItem",0,"ExID",ExType,Item,RowID)) q:(RowID="")  d
	.q:$p($g(^DHCEQCCode("DHCEQCServiceItem",RowID)),"^",12)'="N"
	.s ServiceItemDR=RowID
	q ServiceItemDR
}

/// modified by zy0282 20211112
/// 增加参数：HospID,ExpStr 通过医嘱ID获取医嘱记录的费用
/// w ##Class(web.DHCEQ.BA.CTServiceItem).GetServicePriceByExID(405,113)
ClassMethod GetServicePriceByExID(ExType, ExID, OccDate, HospID As %String = "", ExpStr As %String = "")
{
	n Info
	s Info=""
	
	i ExType="DHC-LIS"
	{
		s Info=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "",HospID,ExpStr)
		s Info=$p(Info,"^",1)
	}
	elseif ExType="DHC-RIS"
	{
		s Info=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "",HospID,ExpStr)
		s Info=$p(Info,"^",1)
	}
	elseif ExType="DHC-HIS"
	{
		s Info=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "",HospID,ExpStr)
		s Info=$p(Info,"^",1)
	}
	q Info
}

/// 根据扩展类型及项目,自动生成服务项
/// w ##Class(web.DHCEQ.BA.CTServiceItem).AutoSaveServiceItem()
ClassMethod AutoSaveServiceItem(ExType, Item, OccDate)
{
	n (ExType, Item, OccDate)
	i Item="" q ""
	if ((ExType="DHC-HIS")||(ExType="DHC-LIS")||(ExType="DHC-RIS")||(ExType="DHC-LIS(B/S)"))
	{
		s RowID=""
		s ItemSubscript=$p(Item,"||",1)
		s ItemVersion=$p(Item,"||",2)
		
		s Desc=$p($G(^ARCIM(ItemSubscript,ItemVersion,1)),"^",2)
		s Code=$p($G(^ARCIM(ItemSubscript,ItemVersion,1)),"^",1)
		s UnitDR=$p($G(^ARCIM(ItemSubscript,ItemVersion,1)),"^",4)
		s ExID=Item
		
		;s Price=##class(web.UDHCJFPRICE).GetOrderPrice("", "",ExID, OccDate, "", "", "", "")
		;s Price=$p(Price,"^",1)
		s Price=..GetServicePriceByExID(ExType,ExID, OccDate)
		s Price=##Class(web.DHCEQCommon).FormatNumber(Price,"",2)
		;s ExType		
		s Remark=""
		s ImportFlag="Y"
		s MinMinutes=""
		s MinutesPerTimes=""
		s MaxMinutes=""
		s InvalidFlag="N"
		s UpdateDate=+$H
		s ExDesc=Desc
	}	
	elseif(ExType="Pacs")	//add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
	{
		set objService=##class(Service1.Service1Soap).%New()
		set objDataSet=objService.GetItemInfo(Item)
		For  Quit:'objDataSet.Next()  Do
		.if $d(objDataSet.Data("Item"))'=0 d
		..s Desc=objDataSet.Data("Item")
		..s Price=objDataSet.Data("Price")
		..s OtherInfo=objDataSet.Data("OtherInfo")
		s RowID=""
		s Code=""
		s UnitDR=""
		s ExID=Item
		s Remark=OtherInfo
		s ImportFlag="Y"
		s MinMinutes=""
		s MinutesPerTimes=""
		s MaxMinutes=""
		s InvalidFlag="N"
		s UpdateDate=+$H
		s ExDesc=Desc
	}
	/*  RIS系统中的检查项目应该和his的医嘱项一样，但是很多地方RIS系统中信息维护不全，所以还是直接从his中取
	elseif(ExType="DHC-RISNew")	//add by zy 2014-11-17 ZY STUDYITEM  RIS新系统中检查项目的Code,取其它信息
	{
		zn "PACS"
		s DataList=$g(^User.STUDYITEMD(Item))
		zn "DHC-APP"
		s Code=$LIST(DataList,3)
		s Desc=$LIST(DataList,4)
		s Price=$LIST(DataList,6)
		s RowID=""
		s Desc=Desc
		s Code=Code
		s UnitDR=""
		s Price=Price
		s ExID=Item
		s Remark=""
		s ImportFlag="Y"
		s MinMinutes=""
		s MinutesPerTimes=""
		s MaxMinutes=""
		s InvalidFlag="N"
		s UpdateDate=+$H
		s ExDesc=Desc
		s ExType="DHC-RIS"
	}
	*/
	s Val=RowID_"^"_Desc_"^"_Code_"^"_UnitDR_"^"_Price_"^"_ExType_"^"_ExID_"^"_Remark_"^"_ImportFlag_"^"_MinMinutes_"^"_MinutesPerTimes_"^"_MaxMinutes_"^"_InvalidFlag_"^"_UpdateDate_"^"_ExDesc
	q ##Class(web.DHCEQCServiceItem).SaveData("","",Val)
}

}

Class DHCWMR.Tool.InitDataByFile Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: d ##Class(DHCWMR.Tool.InitDataByFile).ImportMenusByFile("d:\menus.txt")
ClassMethod ImportMenusByFile(AFileName As %String) As %Boolean
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"file is not exist!"
	 	quit
 	}
 	
 	w !, "+++++++++++import Menus started!"
	
	s failCount = 0, okCount =0, totCount = 0
 	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s AMenuCode = $p(sRec, $c(9), 2)
 		s AMenuCaption = $p(sRec, $c(9), 3)
 		s ALinkUrl = $p(sRec, $c(9), 4)
 		s AExpression = $p(sRec, $c(9), 5)
 		s AIconClass = $p(sRec, $c(9), 6)
 		s AParentMenuCode = $p(sRec, $c(9), 7)
 		s AProductCode = $p(sRec, $c(9), 8)
 		s AShowIndex = $p(sRec, $c(9), 9)
 		s AOperList = $p(sRec, $c(9), 10)
		s isOK = ..ImportMenus(AMenuCode, AMenuCaption, ALinkUrl, AExpression, AIconClass, AParentMenuCode, AProductCode, AShowIndex, AOperList)
	
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	
	}  

	d fs.%Close()
	s fs = ""
	
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++import menus finished!"
	
	quit
}

/// Debug: w ##class(DHCWMR.Tool.InitDataByFile).ImportMenus("","","","")
ClassMethod ImportMenus(AMenuCode As %String, AMenuCaption As %String, ALinkUrl As %String, AExpression As %String, AIconClass As %String, AParentMenuCode As %String, AProductCode As %String, AShowIndex As %String, AOperList As %String) As %Boolean
{
	s AProductDr="0"
	s:(AProductCode="WMR") AProductDr="1"
	s inputStr = ""
	s inputStr = inputStr_"^"_AMenuCode
	s inputStr = inputStr_"^"_AMenuCaption
	s inputStr = inputStr_"^"_ALinkUrl
	s inputStr = inputStr_"^"_AExpression
	s inputStr = inputStr_"^"_AIconClass
	s inputStr = inputStr_"^"_AParentMenuCode
	s inputStr = inputStr_"^"_AProductDr
	s inputStr = inputStr_"^"_AShowIndex
	s inputStr = inputStr_"^"_AOperList
	s Flag = 1
	s ret = ##class(DHCWMR.MainService.MenusSrv).ImportMenus(inputStr,"^")
	s:(ret<0) Flag = 0
	q Flag
}

/// Debug: d ##Class(DHCWMR.Tool.InitDataByFile).ImportMRItemCatByFile("d:\dataitems.txt")
ClassMethod ImportMRItemCatByFile(AFileName As %String) As %Boolean
{
	s isExisted = ##class(%File).Exists(AFileName) 
	If ('isExisted)
 	{
	 	Write !,"file is not exist!"
	 	quit
 	}
 	
 	w !, "+++++++++++import MRItemCat started!"
	
	s failCount = 0, okCount =0, totCount = 0
 	
	Set fs = ##class(%FileCharacterStream).%New()
	Set fs.Filename = AFileName
	
	While 'fs.AtEnd {
		Set sRec = fs.ReadLine()
		Set sRec = $tr(sRec,$c(13),"")
		continue:(sRec = "")
		
		s ADataSource = $p(sRec, $c(9), 1)
 		s AEleCode = $p(sRec, $c(9), 2)
 		s AItemDesc = $p(sRec, $c(9), 3)
 		s AMRItemCat = $p(sRec, $c(9), 7)
 		s AMRItemSubCat = $p(sRec, $c(9), 6)
		s isOK = ..ImportMRItemCat(ADataSource, AEleCode, AItemDesc, AMRItemCat, AMRItemSubCat)
	
		s totCount = totCount + 1
		if (isOK)
		{
			s okCount = okCount + 1
		}
		else
		{
			s failCount = failCount + 1
		}
	
	}  

	d fs.%Close()
	s fs = ""
	
	w !, "+++++++++++totCount:"_totCount_", okCount:"_okCount_", failCount:"_failCount
	w !, "+++++++++++import MRItemCat finished!"
	
	quit
}

/// Debug: w ##class(DHCWMR.Tool.InitDataByFile).ImportMRItemCat("EPR","HDSD00.11.585","医疗付费方式","患者信息","医疗付费方式")
ClassMethod ImportMRItemCat(ADataSource As %String, AEleCode As %String, AItemDesc As %String, AMRItemCat As %String, AMRItemSubCat As %String) As %Boolean
{
	s Flag = 0
	s itemID = ""
	s itemID = $o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," "_ADataSource," "_AEleCode,itemID))
	if (itemID = "")
	{
		w !,"ElementCode:"_AEleCode_" 不存在!"
		q Flag
	}
	
	s objItem = ##class(DHCWMR.MQ.DataItems).%OpenId(itemID)
	s eleDesc = objItem.ElementDesc
	if (eleDesc'=AItemDesc)
	{
		w !,"ElementCode:"_AEleCode_", ElementDesc:"_AItemDesc_" 不存在!"
		q Flag
	}
	
	//存储大类和子类
	s itemCatID= ##class(DHCWMR.MQ.DataCat).Update("^"_AMRItemCat,"^")
	q:+itemCatID<1 Flag
	s itemSubCatID= ##class(DHCWMR.MQ.DataSubCat).Update(itemCatID_"^^"_AMRItemSubCat,"^")
	q:+itemSubCatID<1 Flag
	s objItemCat=##class(DHCWMR.MQ.DataCat).GetObjById(itemCatID)
	s objItemSubCat=##class(DHCWMR.MQ.DataSubCat).GetObjById(itemSubCatID)
	s objItem.MRItemCat=objItemCat
	s objItem.MRItemSubCat=objItemSubCat
	s sc = objItem.%Save()
	if ($$$ISOK(sc))
	{
		s Flag = 1
	}
	d objItem.%Close()
	q Flag
}

/// Debug: d ##class(DHCWMR.Tool.InitDataByFile).UpdateFPItemCat()
ClassMethod UpdateFPItemCat()
{
	s count = 0,succount = 0,errcount = 0
	s itemID = ""
	f {
		s itemID = $o(^DHCWMR.MQ.DataItemsD(itemID))
		q:(itemID = "")
		//s objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(itemID)
		s dataSource = $lg(^DHCWMR.MQ.DataItemsD(itemID),2,"")
		continue:(dataSource = "EPR")
		s count = count + 1
		s objItem = ##class(DHCWMR.MQ.DataItems).%OpenId(itemID)
		s itemCat = $lg(^DHCWMR.MQ.DataItemsD(itemID),7,"")
		s itemCatID = ""
		if (itemCat'="")
		{
			s:(itemCat["诊断") itemCatID=$o(^DHCWMR.MQ.DataCatI("IndexDesc"," 诊断信息",itemCatID))
			s:(itemCat["手术") itemCatID=$o(^DHCWMR.MQ.DataCatI("IndexDesc"," 手术信息",itemCatID))
		}
		s objItemCat=##class(DHCWMR.MQ.DataCat).GetObjById(itemCatID)
		s objItem.MRItemCat=objItemCat
		s sc = objItem.%Save()
		d objItem.%Close()
		if ($$$ISOK(sc))
		{
			s succount = succount + 1
		}
		else
		{
			s errcount = errcount + 1
		}
	}
	w "total:"_count_",succeed:"_succount_",error:"_errcount,!
}

}

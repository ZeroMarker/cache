/// 麻醉记录数据业务逻辑类
Class CIS.AN.BL.AnaData Extends %RegisteredObject
{

ClassMethod GetLastVitalSignData(opsId As %String, itemCode As %String) As %ListOfObjects
{
	set retObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.AnaData:FindLastVitalSignValue",opsId,itemCode)
	set ret=retObj.GetValue("DataValue")
	quit ret
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindSheetRecords","1","N")
Query FindLastVitalSignValue(opsId As %String, itemCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT Top 1 DataValue
	   from CIS_AN.AnaData 
       where ParaItem->RecordSheet->OperSchedule=:opsId
       and DataItem->ItemCategory='V'
       and EditFlag='N'
       and DataItem->Code=:itemCode
       order by StartDate Desc,StartTime Desc
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestRecord","FindSheetRecords","1","N")
Query FindLastAnaData(opsId As %String, itemCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT Top 1 DataValue,%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	   DataItem As DataItem,
	   DataItem->Code As DataItemCode,
	   DataItem->Description As DataItemDesc
	   from CIS_AN.AnaData 
       where ParaItem->RecordSheet->OperSchedule=:opsId
       and EditFlag='N'
       and DataItem->Code=:itemCode
       order by StartDate Desc,StartTime Desc
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-7
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.DrugData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaData","FindBloodDrugDatas","98")
Query FindBloodDrugDatas(opsId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT Description,
	   AnaData->DataItem->Code As Code,
	   Sum(CIS_AN_BL.AnaestRecord_CalcSumQty(AnaData))_(DoseUnit->Description) As SumQty 
	   from CIS_AN.DrugData 
       where AnaData->ParaItem->RecordSheet->OperSchedule=:opsId
       and AnaData->ParaItem->CategoryItem->DataCategory->Code='BloodTransfusion'
       and AnaData->EditFlag='N'
       group by Description,AnaData->DataItem->Code
}

/// Creator：      	陈长青
/// CreatDate：    	2017-11-7
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.DrugData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaData","FindBloodDrugDatas","98")
Query FindOutputDatas(opsId As %String, dataItemCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT Description,
	   AnaData->DataItem->Code As Code,
	   Sum(CIS_AN_BL.AnaestRecord_CalcSumQty(AnaData)) As SumQty 
	   from CIS_AN.DrugData 
       where AnaData->ParaItem->RecordSheet->OperSchedule=:opsId
       and AnaData->ParaItem->CategoryItem->DataCategory->Code='OutputItems'
       and AnaData->DataItem->Code=:dataItemCode
       and AnaData->EditFlag='N'
       group by Description,AnaData->DataItem->Code
}

ClassMethod GetAnaDataByCode(opsId As %String, itemCode As %String) As %String
{
	set splitChar="&&&"
	set retObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.AnaData:FindLastAnaData",opsId,itemCode)
	set ret=retObj.GetValue("DataValue")_splitChar_retObj.GetValue("StartDT")_splitChar_retObj.GetValue("DataItemDesc")
	quit ret
}

ClassMethod TestData(opsId As %String) As %String
{
       Quit "test"
}

ClassMethod TestDataR(opsId As %String) As %String
{
	quit "test"
}

/// w ##class(DHCAN.BLL.AnaData).GetEventTime(14193,75)
ClassMethod GetEventTime(eventParaItemId As %String, dataItemId As %String) As %String
{
	quit:eventParaItemId="" ""
	quit:dataItemId="" ""
	
	set rowId="",result=""
	for
	{
		set rowId=$o(^CIS.AN.AnaDataI("IParaItem",eventParaItemId,rowId))
		quit:rowId=""
		
		set editFlag=$lg(^CIS.AN.AnaDataD(rowId),7)
		continue:editFlag'="N"
		
		set dataItem=$lg(^CIS.AN.AnaDataD(rowId),12)
		if dataItem=dataItemId
		{
			set dateH=$lg(^CIS.AN.AnaDataD(rowId),2)
			set timeH=$lg(^CIS.AN.AnaDataD(rowId),3)
			set result=$zd(dateH,3)_" "_$zt(timeH)
			quit
		}
	}
	
	quit result
}

ClassMethod GetNewParaItemSeq(recordSheeId As %String, categoryItemId As %String) As %Integer
{
	k seqList
	set paraItemId=0,res=1
	set categoryItem=##class(CT.AN.DataCateItem).%OpenId(categoryItemId)
	set mainDataCategoryId=categoryItem.DataCategory.%Id()
	if $IsObject(categoryItem.DataCategory.MainCategory) set mainDataCategoryId=categoryItem.DataCategory.MainCategory.%Id()
	for
	{
		set paraItemId=$o(^CIS.AN.ParaItemI("ISheet",recordSheeId,paraItemId))
		quit:(paraItemId="")
		set paraItem=##class(CIS.AN.ParaItem).%OpenId(paraItemId)
		continue:(paraItem.DataCategory="")
		set paraItemDataCategoryId=paraItem.DataCategory.%Id()
		if $IsObject(paraItem.DataCategory.MainCategory) set paraItemDataCategoryId=paraItem.DataCategory.MainCategory.%Id()
		continue:(paraItemDataCategoryId'=mainDataCategoryId)
		set seqList(+paraItem.Seq)=""
	}
	set lastSeq=$o(seqList(""),-1)
	set:(lastSeq>0) res=lastSeq+1
	quit res
}

ClassMethod SaveAnaRegData(recordSheetId As %String, dataPara As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	k array
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)	
	set dataIndex=0,saveRes="S^"
	for
	{
		set dataIndex=$o(array(dataIndex))
		quit:(dataIndex="")
		k anaDataArr
		m anaDataArr=array(dataIndex)
		s paraItemId=$g(anaDataArr("ParaItem"))
		s categoryItemId=$g(anaDataArr("CategoryItem"))
		
		// 没有显示项，新创建。
		if (##class(CIS.AN.ParaItem).%ExistsId(paraItemId)=0)
		{
			set seq=..GetNewParaItemSeq(recordSheetId,categoryItemId)
			set paraItem=##class(CIS.AN.ParaItem).%New()
			set paraItem.CategoryItem=##class(CT.AN.DataCateItem).%OpenId(categoryItemId)
			set paraItem.DataCategory=paraItem.CategoryItem.DataCategory
			set paraItem.Code=paraItem.CategoryItem.DataItem.Code
			set paraItem.Description=paraItem.CategoryItem.DataItem.Description
			set paraItem.RecordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
			set paraItem.Seq=seq
			set sc=paraItem.%Save()
			set:($System.Status.IsError(sc)) saveRes="E^"_$System.Status.GetErrorText(sc)
			quit:($System.Status.IsError(sc))
			s anaDataArr("ParaItem")=paraItem.%Id()	
		}	
		
		s saveRes=##class(CIS.AN.COM.DataService).SaveData(.anaDataArr)
		quit:($p(saveRes,"^",1)'="S")
		
		set itemCategory=anaDataArr("ItemCategory")
		if (itemCategory="D")
		{
			k drugDataArr
			set drugDataArr("RowId")=$g(anaDataArr("DrugDataId"))
			set drugDataArr("DoseQty")=anaDataArr("DoseQty")
			set drugDataArr("DoseUnit")=anaDataArr("DoseUnit")
			set drugDataArr("ClassName")="CIS.AN.DrugData"
			set drugDataArr("DoseUnit")=anaDataArr("DoseUnit")
			set drugDataArr("Description")=$g(anaDataArr("DataItemDesc"))
			set drugDataArr("Continuous")=$g(anaDataArr("Continuous"))
			set drugDataArr("DataItem")=anaDataArr("DataItem")
			set drugDataArr("TCI")="N"
			set drugDataArr("AnaData")=$p(saveRes,"^",2)
			set drugDataArr("Instruction")=	$g(anaDataArr("Instruction"))
			set drugDataArr("ArcimID")=$g(anaDataArr("ArcimID"))
			set drugDataArr("Speed")=$g(anaDataArr("Speed"))
			set drugDataArr("SpeedUnit")=$g(anaDataArr("SpeedUnit"))
			set drugDataArr("Concentration")=$g(anaDataArr("Concentration"))
			set drugDataArr("ConcentrationUnit")=$g(anaDataArr("ConcentrationUnit"))
			
			s saveRes=##class(CIS.AN.COM.DataService).SaveData(.drugDataArr)
			quit:($p(saveRes,"^",1)'="S")
		}
	}
	if ($p(saveRes,"^",1)'="S")
	{
		trollback
		quit saveRes	
	}
	tcommit
	
	do ##class(CIS.AN.BL.AnaData).ClearEmptyParaItem(recordSheetId)
	
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.AnaData).ClearEmptyParaItem(1344)
ClassMethod ClearEmptyParaItem(recordSheetId As %String) As %String
{
	set paraItems = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindParaItems",recordSheetId)
	set count=0
	set paraItemCount=0
	
	for i=1:1:(paraItems.Size)
	{
		set paraItem=paraItems.GetAt(i)
		quit:paraItem=""
		
		set ParaItemId=paraItem.GetValue("RowId")
		set CategoryItem=paraItem.GetValue("CategoryItem")
		set UserDefinedItem=paraItem.GetValue("UserDefinedItem")
		set ItemCategory=paraItem.GetValue("ItemCategory")
		if (ItemCategory="D")&&((UserDefinedItem'="")||(CategoryItem'=""))
		{
			if ($$ExistData(ParaItemId)<=0)
			{
				set count=count+1
				set sc=##class(CIS.AN.ParaItem).%DeleteId(ParaItemId)
				if ($System.Status.IsError(sc)) write "E^"_$System.Status.GetErrorText(sc),!
			}
		}
	}
	quit "S^"_count
	
ExistData(iParaItemId)
    set rowId=""
    
	&sql(select top 1 RowId into :rowId from CIS_AN.AnaData
		where ParaItem=:iParaItemId
		and EditFlag="N")
	
	quit rowId
}

/// w ##class(CIS.AN.BL.AnaData).SaveAnaRegTemplate(^TMPAReg(1),^TMPAReg(2),^TMPAReg(3),^TMPAReg(4),^TMPAReg(5),^TMPAReg(6))
ClassMethod SaveAnaRegTemplate(recordSheetId As %String, tempId As %String, tempName As %String, tempDataPara As %String, deptId As %String, userId As %String) As %String
{
	s ^TMPAReg(1)=recordSheetId, ^TMPAReg(2)=tempId, ^TMPAReg(3)=tempName, ^TMPAReg(4)=tempDataPara,^TMPAReg(5)=deptId,^TMPAReg(6)=userId
	set $zt="Error"
	tstart
	set template=""
	if (##class(CF.AN.ModuleTemplate).%ExistsId(tempId)=0)
	{
		set template=##class(CF.AN.ModuleTemplate).%New()
		
	}
	else
	{
		set template=##class(CF.AN.ModuleTemplate).%OpenId(tempId)
	}
	
	set template.DeptID=deptId
	set template.Description=tempName
	set template.Type="Private"
	set template.UserID=userId
	set template.UpdateUserID=userId
	set template.UpdateDate=+$h
	set template.UpdateTime=$p($h,",",2)
	set sheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set template.DataModule=sheet.DataModule
	set sc=template.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	set templateId=template.%Id()
	
	&sql(delete from CF_AN.UserPreferedData where Template=:templateId)
	if (SQLCODE'=0)&(SQLCODE'=100)
	{
		trollback
		quit "E^"_$System.SQL.SQLCODE(SQLCODE)	
	}
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(sheet.OperSchedule.%Id())
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set theatreInDT=anaesthesia.TheatreInDT
	set theatreInDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(theatreInDT," ",1),"")
	set theatreInTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(theatreInDT," ",2),"")
	
	k array,dataArr,drugArr
	set sc=##class(CIS.AN.COM.String).ToArray(tempDataPara,.array)
	set dataIndex=0,saveRes="S^"
	for
	{
		set dataIndex=$o(array(dataIndex))
		quit:(dataIndex="")
		
		if $g(array(dataIndex,"ClassName"))="CF.AN.UserPreferedData" merge dataArr(dataIndex)=array(dataIndex)
		if $g(array(dataIndex,"ClassName"))="CF.AN.UserPreferedDrug" merge drugArr(dataIndex)=array(dataIndex)
	}
	
	set dataIndex=0,saveRes="S^"
	for
	{
		set dataIndex=$o(dataArr(dataIndex))
		quit:(dataIndex="")	
		k tempData
		m tempData=dataArr(dataIndex)
		set guid=$g(tempData("guid"))
		set tempData("Template")=templateId
		set tempData("DataModule")=sheet.DataModule.%Id()
		set startDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($g(tempData("StartDate")),"")
		set startTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($g(tempData("StartTime")),"")
		set endDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($g(tempData("EndDate")),"")
		set endTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($g(tempData("EndTime")),"")
		
		set:(endDate>0)&(endTime>0)&(startDate>0)&(startTime>0) tempData("TimeSpanMinutes")=##class(CIS.AN.COM.DateTime).CalculateDuration(startDate,startTime,endDate,endTime,"M")
		set:(theatreInDate>0)&(theatreInTime>0)&(startDate>0)&(startTime>0) tempData("GenerateTimeSpan")=##class(CIS.AN.COM.DateTime).CalculateDuration(theatreInDate,theatreInTime,startDate,startTime,"M")
		set dataCategoryId=$g(tempData("DataCategory"))
		//set categoryItem=##class(CT.AN.DataCateItem).%OpenId(categoryItemId)
		//b //ccq
		set tempData("Category")=dataCategoryId
		set tempData("CreateUserID")=userId
		set tempData("UpdateUser")=userId
		set saveRes=##class(CIS.AN.COM.DataService).SaveData(.tempData)
		quit:($p(saveRes,"^",1)'="S")
		
		set tempDataId=+$p(saveRes,"^",2)
		
		set drugIndex=0
		for
		{
			set drugIndex=$o(drugArr(drugIndex))
			quit:drugIndex=""
			
			continue:$g(drugArr(drugIndex,"dataGuid"))'=guid
			
			k drugData
			m drugData=drugArr(drugIndex)
			set drugData("UserPreferedData")=tempDataId
			set saveRes=##class(CIS.AN.COM.DataService).SaveData(.drugData)
			quit:($p(saveRes,"^",1)'="S")
		}
		
		quit:($p(saveRes,"^",1)'="S")
	}
	
	if ($p(saveRes,"^",1)'="S")
	{
		trollback
		quit saveRes	
	}
	
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.AnaData).GetPAAdmSexDesc("1")
ClassMethod GetPAAdmSexDesc(AdmRowId) As %String
{
   //q:AdmRowId=""
   set PAADM=$p($g(^PAADM(AdmRowId)),"^",1)
   set PAPMISexDR=$P($g(^PAPER(PAADM,"ALL")),"^",7)
   set SexDesc=$p($g(^CT("SEX",PAPMISexDR)),"^",2)
   q SexDesc
}

}

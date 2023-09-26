Class EPRservice.BLL.Stat.RecordStatus Extends %Persistent [ Not ProcedureBlock ]
{

ClassMethod GetMultiRecordStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiRecordStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMultiRecordStatusExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s cateIDList = ..GetCategoryIDList("0", "1")
 	q:(cateIDList="") $$$OK
 	
 	s cateIDCount = $Length(cateIDList, "^")
 	for i = 1:1:cateIDCount
 	{
	 	s cateID = $P(cateIDList,"^",i)
	 	
	 	s ccIDList = ..GetCategoryIDList(cateID, "0")
	 	continue:(ccIDList="")
	 	
	 	s ccIDCount = $Length(ccIDList, "^")
 		for j = 1:1:ccIDCount
 		{
			s ccID = $P(ccIDList, "^", j)
			s printDocIDList = ..GetCategoryIDList(ccID, "0")
			continue:(printDocIDList="")
			
			s printDocIDCount = $L(printDocIDList, "^")
			for k = 1:1:printDocIDCount
			{
				s printDocID = $p(printDocIDList, "^", k)
				
				s objEPRTplCate = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(printDocID)
				continue:(objEPRTplCate="")
				
				s printTplID = objEPRTplCate.BindPrnTemplateID
				continue:(printTplID="")||(printTplID=$c(0))
				
				s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTplID)
				continue:(objPrintTemplate="")
				
				s chartType = objPrintTemplate.ChartItemType
				continue:(chartType '= "Multiple")
				
				s type = "可重复病历"
				s name = objEPRTplCate.CategoryName
				
				s status = ..GetStatMultiStatus(AEpisodeID, printDocID)
				continue:(status = "") 
				
				s ^CacheTemp(repid, ind) = $LB(type, printDocID, name, status, createUser, createDate, createTime, signInfo)
				s ind = ind + 1
			}	
		}
	}
	
	Quit $$$OK
}

ClassMethod GetMultiRecordStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiRecordStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.BLL.Stat.RecordStatus","GetMultiRecordStatus","201764")
Query GetMultiRecordStatus(AEpisodeID As %String) As %Query(ROWSPEC = "Type:%String,PrintDocID:%String,Name:%String,Status:%String")
{
}

ClassMethod GetSingleRecordStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSingleRecordStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSingleRecordStatusExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	//b "s"
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s cateIDList = ..GetCategoryIDList("0", "1")
 	q:(cateIDList="") $$$OK
 	
 	s cateIDCount = $Length(cateIDList, "^")
 	for i = 1:1:cateIDCount
 	{
	 	s cateID = $P(cateIDList,"^",i)
	 	
	 	s ccIDList = ..GetCategoryIDList(cateID, "0")
	 	continue:(ccIDList="")
	 	
	 	s ccIDCount = $Length(ccIDList, "^")
 		for j = 1:1:ccIDCount
 		{
			s ccID = $P(ccIDList, "^", j)
			s printDocIDList = ..GetCategoryIDList(ccID, "0")
			continue:(printDocIDList="")
			
			s printDocIDCount = $L(printDocIDList, "^")
			for k = 1:1:printDocIDCount
			{
				s printDocID = $p(printDocIDList, "^", k)
				
				s objEPRTplCate = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(printDocID)
				continue:(objEPRTplCate="")
				
				s printTplID = objEPRTplCate.BindPrnTemplateID
				continue:(printTplID="")||(printTplID=$c(0))
				
				s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTplID)
				continue:(objPrintTemplate="")
				
				s chartType = objPrintTemplate.ChartItemType
				continue:(chartType '= "Single")
				
				s type = "唯一病历"
				s name = objEPRTplCate.CategoryName
				
				s (status,createUser, createDate, createTime, signInfo) = ""
				s logs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,printDocID,"1")
				continue:(logs = "")
				
				s status = logs.EPRStatus
				&sql(select StatusName into :status from EPRmeta.EPRStatus where StatusCode = :status)
				
				s createUser = logs.CreateUserID
				s:(createUser'="") createUser = $p($g(^SSU("SSUSR",createUser)),"^",2)
				s createDate = $zd(logs.CreateDate,3)
				s createTime = $zt(logs.CreateTime)
				
				s signInfo = ##Class(EPRservice.BLDigitalSignature).GetSignLog(AEpisodeID,printDocID,"1")
				
				b
				s ^CacheTemp(repid, ind) = $LB(type, printDocID, name, status, createUser, createDate, createTime, signInfo)
				s ind = ind + 1
			}	
		}
	}

	Quit $$$OK
}

ClassMethod GetSingleRecordStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSingleRecordStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.BLL.Stat.RecordStatus","GetSingleRecordStatus","201764")
Query GetSingleRecordStatus(AEpisodeID As %String) As %Query(ROWSPEC = "Type:%String,PrintDocID:%String,Name:%String,Status:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,SignInfo:%String")
{
}

ClassMethod GetMultiDetailStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiDetailStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMultiDetailStatusExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AEPRDocID As %String) As %Status
{
	//b "s"
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s type = "可重复模板"
 	s printDocID = AEPRDocID
 	
 	s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_AEpisodeID, " ML"_AEPRDocID, "")) 
	q:(ecRecordID="") $$$OK
	
				
 	s eprNum = "0"
	for {
		s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_AEPRDocID, eprNum))
		q:(eprNum="")
			
		s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_AEPRDocID, eprNum, ""))
		s logs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
		continue:(logs="")
		
		s (name, status,createUser, createDate, createTime, signInfo) = ""
				
		s status = logs.EPRStatus
		&sql(select StatusName into :status from EPRmeta.EPRStatus where StatusCode = :status)
				
		s createUser = logs.CreateUserID
		s:(createUser'="") createUser = $p($g(^SSU("SSUSR",createUser)),"^",2)
		s createDate = $zd(logs.CreateDate,3)
		s createTime = $zt(logs.CreateTime)
				
		s signInfo = ##Class(EPRservice.BLDigitalSignature).GetSignLog(AEpisodeID,printDocID,eprNum)
		
		s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_eprNum, ""))
		continue:(childSub = "")	
		s instanceDataID = ecRecordID_"||"_childSub
		s objEPRInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceDataID)
		if (objEPRInstance = "")
		{
			s name = objEPRInstance.Title
		}
		
		s ^CacheTemp(repid, ind) = $LB(type, printDocID, name, status, createUser, createDate, createTime, signInfo)
		s ind = ind + 1		
	}

	Quit $$$OK
}

ClassMethod GetMultiDetailStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiDetailStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.BLL.Stat.RecordStatus","GetMultiDetailStatus","201868","24")
Query GetMultiDetailStatus(AEpisodeID As %String, AEPRDocID As %String) As %Query(ROWSPEC = "Type:%String,PrintDocID:%String,Name:%String,Status:%String,CreateUser:%String,CreateDate:%String,CreateTime:%String,SignInfo:%String")
{
}

ClassMethod IsCategoryActived(AEPRCategoryID As %String) As %Boolean
{
	//b "s"
	s ssGroupID = $o(^DHCEPRM.EPRDOC.EPRSSGroupI("IdxCatalogSSGroup"," "_AEPRCategoryID,""))
	q:(ssGroupID="") 0
	q 1
}

/// Desc:	取 "已激活的" 第一级病历展现结构ID
/// Debug:	w ##Class(EPRservice.BLL.Stat.RecordStatus).GetCategoryIDList("0","1")
ClassMethod GetCategoryIDList(AEPRCategoryID As %String, ANeedCheckSSGroup As %Boolean) As %String
{
	
	s retStr = ""
	q:(AEPRCategoryID="") retStr
	
	s seq = ""
	for {
		s seq = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AEPRCategoryID,seq))
		q:(seq = "")
	
		s cateID = ""
		for {
			s cateID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCateogryIDAndSeq"," "_AEPRCategoryID,seq,cateID))
			q:(cateID="")
			
			//b "s"
			if (ANeedCheckSSGroup)
			{
				s isCateActive = ..IsCategoryActived(cateID)
				continue:('isCateActive)
			}
			
			if (retStr = "")
			{	s retStr = cateID}
			else
			{	s retStr = retStr_"^"_cateID}
		}
	}
	
	q retStr
}

/// Desc:	获取指定可重复病历的状态统计信息
/// Debug:	w ##Class(EPRservice.BLL.Stat.RecordStatus).GetStatMultiStatus("201764","1")
ClassMethod GetStatMultiStatus(AEpisodeID As %String, AEPRDocID As %String) As %String
{
	s arrStatus = ##Class(%ArrayOfDataTypes).%New()
	
	s eprNum = "0"
	for {
		s eprNum = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_AEPRDocID, eprNum))
		q:(eprNum="")
			
		s eprLogsID = $O(^DHCEPRI.EPRLogsI("IdxMain"," "_AEpisodeID," "_AEPRDocID, eprNum, ""))
		s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
		continue:(objEPRLogs="")
		
		s status = $zcvt(objEPRLogs.EPRStatus,"u")
		s count = +arrStatus.GetAt(status)
		d arrStatus.SetAt(count+1,status)			
	}
	
	
	s count1 = (+arrStatus.GetAt("UNFINISHED"))
	s count2 = (+arrStatus.GetAt("FINISHED"))
	s count3 = (+arrStatus.GetAt("COMMITED"))
	s count4 = (+arrStatus.GetAt("ATTENDINGCHEKED"))
	s count5 = (+arrStatus.GetAt("CHIEFCHECKED"))
	s totCount = count1 + count2 + count3 + count4 + count5
	
	q:(totCount < 1) ""
	
	s statusStr = "共:"_totCount
	s:(count1 > 0) statusStr = statusStr_" 未完成:"_(count1)
	s:(count2 > 0) statusStr = statusStr_" 完成:"_(count2)
	s:(count3 > 0) statusStr = statusStr_" 提交:"_(count3)
	s:(count4 > 0) statusStr = statusStr_" 主治医师审核:"_(count4)
	s:(count5 > 0) statusStr = statusStr_" 主任医师审核:"_(count5)
	q statusStr
}

/// w ##Class(EPRservice.BLL.Stat.RecordStatus).test1("925805")
ClassMethod test1(userId As %String)
{
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.BLL.Stat.RecordStatus:GetSingleRecordStatus")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(userId)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

Storage Default
{
<Data name="RecordStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^EPRservice.BLC16C.RecordStatusD</DataLocation>
<DefaultData>RecordStatusDefaultData</DefaultData>
<IdLocation>^EPRservice.BLC16C.RecordStatusD</IdLocation>
<IndexLocation>^EPRservice.BLC16C.RecordStatusI</IndexLocation>
<StreamLocation>^EPRservice.BLC16C.RecordStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

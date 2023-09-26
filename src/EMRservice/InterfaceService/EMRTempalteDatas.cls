/// Desc:       病历展现数据接口(港大)
/// Creator:    yejian
/// CreateDate: 2021-4-14
Class EMRservice.InterfaceService.EMRTempalteDatas Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yejian
/// CreatDate：    2021-4-12
/// Description:   病历展现数据接口
/// Input：        AStartDate AEndDate
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug: d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRTempalteDatas","GetEmrTemplateDataByDate","2020-07-18","2021-07-18")
Query GetEmrTemplateDataByDate(AStartDate As %String = "", AEndDate As %String = "") As %Query(ROWSPEC = "ID,CategoryName,TypeName,EMRTempatleName,TemplateName,Status,StartDate,StopDate,OperateDate,TypeCode,CTLocNames")
{
}

ClassMethod GetEmrTemplateDataByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s startDate = $case(AStartDate,"":"",:$zdh(AStartDate,3)) 
	s endDate = $case(AEndDate,"":"",:$zdh(AEndDate,3)) 
	
	s result = ##class(%ResultSet).%New("EMRservice.InterfaceService.EMRTempalteDatas:SelectAllDocIDs")
	d result.Execute()
	While result.Next() 
	{
	 	s ID = result.GetDataByName("ID")
	 	s OperateDate = result.GetDataByName("OperateDate")
	 	if ((OperateDate'="")&&(startDate'="")&&(endDate'="")&&((OperateDate<startDate)||(OperateDate<endDate)))
	 	{
		 	continue
	 	}
	 	s OperateDate =$case(OperateDate,"":"",:$ZDATE(OperateDate,3))
	 	s CTLocNames = ""
	 	s groupID=""
		for {
	        s groupID=$o(^DHCEMRM.DocRes.DocsInGroupI("DocIDIdx"," "_ID,groupID))
	        q:(groupID = "")
			s resRowID=""
			for {
		        s resRowID=$o(^DHCEMRM.DocRes.DocRestrictionI("GroupIDIdx",groupID,resRowID))
		        q:(resRowID = "")
				s objRestriction =##class(EMRmeta.EMRDocRestriction.DocRestriction).%OpenId(resRowID)
				q:(objRestriction="")
				if (objRestriction.RuleItemIDs["PATDEPT")
				{
					s CTLocNames =$case(CTLocNames,"":objRestriction.RuleItemDesc, :CTLocNames_"^"_objRestriction.RuleItemDesc)
				}
			}		
		}
	 	s CategoryName = result.GetDataByName("CategoryName")
	 	s TypeName = result.GetDataByName("TypeName")
	 	s EMRTempatleName = result.GetDataByName("EMRTempatleName")
	 	s TemplateName = result.GetDataByName("TemplateName")
	 	s LogID = result.GetDataByName("LogID")
	 	s Status = result.GetDataByName("Status")
	 	s StartDate = result.GetDataByName("StartDate")
	 	s StopDate = result.GetDataByName("StopDate")
	 	s TypeCode = result.GetDataByName("TypeCode")
		s StartDate = $case(StartDate,"":"",:$ZDATE(StartDate,3))
		;s HappenTime = $ZTIME(StartTime,1)
		s StopDate = $case(StopDate,"":"",:$ZDATE(StopDate,3))
		;s CreateTime = $ZTIME(CreateTime,1)

	 	s ^CacheTemp(repid,ind) = $lb(ID,CategoryName,TypeName,EMRTempatleName,TemplateName,Status,StartDate,StopDate,OperateDate,TypeCode,CTLocNames)
		s ind=ind+1
	}  	
   Quit $$$OK
}

ClassMethod GetEmrTemplateDataByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEmrTemplateDataByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEmrTemplateDataByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEmrTemplateDataByDateExecute ]
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

/// Creator：      yejian
/// CreatDate：    2021-4-12
/// Description:   病历展现数据接口
/// Input：        AStartDate AEndDate
/// Output         对输出参数的说明
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug: d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRTempalteDatas","GetUseCountByDate","2020-01-18","2021-03-18")
Query GetUseCountByDate(AStartDate As %String = "", AEndDate As %String = "") As %Query(ROWSPEC = "ID,EMRTempatleName,UseCount")
{
}

ClassMethod GetUseCountByDateExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s startDate = $case(AStartDate,"":"",:$zdh(AStartDate,3)) 
	s endDate = $case(AEndDate,"":"",:$zdh(AEndDate,3)) 
	s docidList = ##Class(%ArrayOfDataTypes).%New()
	//根据时间获取docid使用次数
	for {	
        s startDate=$o(^DHCEMRI.InstanceDataI("IdxModifyDate",startDate))
        q:(startDate = "")
		q:(startDate>endDate)	
		s strRowID = ""
		for
		{
			s strRowID = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",startDate,strRowID))
			q:(strRowID = "")
			s objECRecord =##class(EMRinstance.ECRecord).%OpenId(strRowID)
			q:(objECRecord ="")
			s strDocID = objECRecord.ChartItemID.%Id()
			s strCount = objECRecord.InstanceCount
			d objECRecord.%Close()
			s oldCount = docidList.GetAt(strDocID)
			if (oldCount="")||(oldCount<strCount)
			{
				d docidList.SetAt(strCount,strDocID)
			}
			/*
			s strRowNum = ""
			for
			{
				s strRowNum = $o(^DHCEMRI.InstanceDataI("IdxModifyDate",StartDate,strRowID,strRowNum))
				q:(strRowNum = "")
				s strInstanID = strRowID_"||"_strRowNum
			    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(strInstanID)
			    continue:(objInstance.Status'="Save")
			}
			*/
		}
	}
	s result = ##class(%ResultSet).%New("EMRservice.InterfaceService.EMRTempalteDatas:SelectDocIDs")
	d result.Execute()
	While result.Next() 
	{
	 	s ID = result.GetDataByName("ID")
	 	s EMRTempatleName = result.GetDataByName("EMRTempatleName")
	 	s UseCount = docidList.GetAt(ID)
	 	/*
	 	s OperateDate =$case(OperateDate,"":"",:$ZDATE(OperateDate,3))
	 	s CategoryName = result.GetDataByName("CategoryName")
	 	s TypeName = result.GetDataByName("TypeName")
	 	s EMRTempatleName = result.GetDataByName("EMRTempatleName")
	 	s TemplateName = result.GetDataByName("TemplateName")
	 	s LogID = result.GetDataByName("LogID")
	 	s Status = result.GetDataByName("Status")
	 	s StartDate = result.GetDataByName("StartDate")
	 	s StopDate = result.GetDataByName("StopDate")
	 	s TypeCode = result.GetDataByName("TypeCode")
		s StartDate = $case(StartDate,"":"",:$ZDATE(StartDate,3))
		;s HappenTime = $ZTIME(StartTime,1)
		s StopDate = $case(StopDate,"":"",:$ZDATE(StopDate,3))
		;s CreateTime = $ZTIME(CreateTime,1)
		*/
	 	s ^CacheTemp(repid,ind) = $lb(ID,EMRTempatleName,UseCount)
		s ind=ind+1
	}  	
   Quit $$$OK
}

ClassMethod GetUseCountByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseCountByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUseCountByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseCountByDateExecute ]
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

/// Desc:       获取DOCID数据
/// Creator:    yejian
/// CreateDate: 2021-4-14
/// debug d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRTempalteDatas","SelectAllDocIDs")
Query SelectAllDocIDs() As %SQLQuery
{
	SELECT m.ID,g.CategoryName,c.CategoryName As TypeName,m.CategoryName As EMRTempatleName, e.TemplateName,l.ID As LogID, l.Status,l.StartDate,l.StopDate,l.OperateDate,t.TypeCode
	FROM EMRmeta.EMRTemplateCategory m
	JOIN EMRmeta.EMRTemplateCategory c ON m.ParentCategoryID = c.ID
	JOIN EMRmeta.EMRTemplateCategory g ON c.ParentCategoryID = g.ID
	JOIN EMRmeta.EMRTemplate e ON m.ID=e.CategoryID
	JOIN EMRmeta.Template t ON e.BindTemplateID = t.ID
	left JOIN (SELECT max(o.ID) AS ID,o.DataID,o.Status,o.StartDate,o.StopDate,o.OperateDate FROM EMRmeta.EMRTemplateCLog o GROUP BY o.DataID) l ON m.ID = l.DataID
	WHERE m.CategoryType = 'TempCate'
}

/// Desc:       获取DOCID数据
/// Creator:    yejian
/// CreateDate: 2021-4-14
/// debug d ##class(%ResultSet).RunQuery("EMRservice.InterfaceService.EMRTempalteDatas","SelectDocIDs")
Query SelectDocIDs() As %SQLQuery
{
	SELECT m.ID,m.CategoryName As EMRTempatleName
	FROM EMRmeta.EMRTemplateCategory m
	WHERE m.CategoryType = 'TempCate'
}

}

Class DHCEPRFS.BL.BLAdmTaskCreate Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 创建打印生成病历日志
/// Input ADetails="Order^MRItemID^CategoryCode|||"
/// debug: w ##class(DHCEPRFS.BL.BLAdmTaskCreate).CreateTask("132","373","1^2^CG07|||2^6^CG07|||3^7^CG07")
ClassMethod CreateTask(APatientID As %String, AEpisodeID As %String, ADetails As %String) As %String
{
	s nowDate=$p($h,","	,1)
	s nowTime=$p($h,","	,2)
	
	TSTART
	s $zt = "OnCreateTaskErrHandler"
	s objAdmTaskCreate=##class(DHCEPRFS.INST.AdmTaskCreate).%New()

	
	s objAdmTaskCreate.PatientID=APatientID
	s objAdmTaskCreate.EpisodeID=AEpisodeID
	s objAdmTaskCreate.CreateDate=nowDate
	s objAdmTaskCreate.CreateTime=nowTime
	
	s sc=objAdmTaskCreate.%Save()
	if $$$ISERR(sc)
	{
		q "-1"	
	}
	
	s succeedFlag="true"
	s DetailsCount = $l(ADetails,"|||")
	for i=1:1:DetailsCount
	{
		s oneDetail=$p(ADetails,"|||",i)
		s objAdmTaskCreateDtl=##class(DHCEPRFS.INST.AdmTaskCreateDtl).%New()
		s objAdmTaskCreateDtl.AdmTaskCreateID=objAdmTaskCreate.%Id()
		s objAdmTaskCreateDtl.OrderNum=$p(oneDetail,"^",1)
		
		s objAdmTaskCreateDtl.MRItemID=$p(oneDetail,"^",2)
		s objMRItem=##class(DHCEPRFS.META.MRItem).%OpenId(objAdmTaskCreateDtl.MRItemID)
		s objAdmTaskCreateDtl.MRItemName=objMRItem.Name
		
		s CTItemTypeCode=$p($p(oneDetail,"^",3),"CG",2)
		s objAdmTaskCreateDtl.CTItemTypeCode=CTItemTypeCode
		s CTItemTypeID=$o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_CTItemTypeCode,""))
		if (CTItemTypeID'="")
		{
			s objCTItemType=##class(DHCEPRFS.META.CTItemType).%OpenId(CTItemTypeID)
			s objAdmTaskCreateDtl.CTItemTypeName=objCTItemType.TypeName
			s objAdmTaskCreateDtl.CTItemTypeProductSource=objCTItemType.ProductSource
		}
		s sc=objAdmTaskCreateDtl.%Save()
		if $$$ISERR(sc)
		{
			s succeedFlag="false"
			q	
		}
	}
	
	if (succeedFlag="false")
	{
		TROLLBACK
		q "-1"	
	}
	else
	{
		TCOMMIT
		q objAdmTaskCreate.%Id()
	}
OnCreateTaskErrHandler
	TROLLBACK
	q "0"
}

/// Desc: 完成打印病历生成日志
/// debug: w ##class(DHCEPRFS.BL.BLAdmTaskCreate).CompleteTask("373")
ClassMethod CompleteTask(AEpisodeID As %String) As %String
{
	s nowDate=$p($h,","	,1)
	s nowTime=$p($h,","	,2)
	s AdmTaskCreateID=""
	s AdmTaskCreateID=$o(^DHCEPRFS.INST.AdmTaskCreateI("IdxEpisodeID"," "_AEpisodeID,""),-1)
	q:(AdmTaskCreateID="") "-1"
	s objAdmTaskCreate=##class(DHCEPRFS.INST.AdmTaskCreate).%OpenId(AdmTaskCreateID)
	s objAdmTaskCreate.EndDate=nowDate
	s objAdmTaskCreate.EndTime=nowTime
	s sc=objAdmTaskCreate.%Save()
	if $$$ISERR(sc)
	{
		q "-1"	
	}
	else
	{
		q "0"
	}
}

/// Desc: 设置病历项目生成开始时间等信息
/// debug: w ##class(DHCEPRFS.BL.BLAdmTaskCreate).SetItemStart("132","373","CG07","","2","dhc.epr.centralizedprintepr.csp")
ClassMethod SetItemStart(APatientID As %String, AEpisodeID As %String, ACategoryID As %String, ACategoryDetail As %String, AMRItemID As %String, AInvokeMethod As %String, ACreateIP As %String) As %String
{
	s nowDate=$p($h,","	,1)
	s nowTime=$p($h,","	,2)
	s AdmTaskCreateID=""
	s AdmTaskCreateID=$o(^DHCEPRFS.INST.AdmTaskCreateI("IdxEpisodeID"," "_AEpisodeID,""),-1)
	q:(AdmTaskCreateID="") "-1"
	
	s AdmTaskCreateDtlID=""
	s AdmTaskCreateDtlID=$o(^DHCEPRFS.INST.AdmTaskCrDtlI("IdxCreateMRItem"," "_AdmTaskCreateID," "_AMRItemID,""))
	
	q:(AdmTaskCreateDtlID="") "-1"
	
	s objAdmTaskCreateDtl=##class(DHCEPRFS.INST.AdmTaskCreateDtl).%OpenId(AdmTaskCreateDtlID)
	
	s objAdmTaskCreateDtl.BeginActDate=nowDate
	s objAdmTaskCreateDtl.BeginActTime=nowTime
	s objAdmTaskCreateDtl.InvokeMethod=AInvokeMethod
	s objAdmTaskCreateDtl.CreateIP = ACreateIP 
	s sc=objAdmTaskCreateDtl.%Save()
	if $$$ISERR(sc)
	{
		q "-1"	
	}
	else
	{
		q "1"	
	}
}

/// Desc: 设置病历项目生成结束时间等信息
/// debug: w ##class(DHCEPRFS.BL.BLAdmTaskCreate).SetItemFinish("132","373","2")
ClassMethod SetItemFinish(APatientID As %String, AEpisodeID As %String, AMRItemID As %String) As %String
{
	
	s nowDate=$p($h,","	,1)
	s nowTime=$p($h,","	,2)
	s AdmTaskCreateID=""
	s AdmTaskCreateID=$o(^DHCEPRFS.INST.AdmTaskCreateI("IdxEpisodeID"," "_AEpisodeID,""),-1)
	q:(AdmTaskCreateID="") "-1"
	
	s AdmTaskCreateDtlID=""
	s AdmTaskCreateDtlID=$o(^DHCEPRFS.INST.AdmTaskCrDtlI("IdxCreateMRItem"," "_AdmTaskCreateID," "_AMRItemID,""))
	
	q:(AdmTaskCreateDtlID="") "-1"
	
	s objAdmTaskCreateDtl=##class(DHCEPRFS.INST.AdmTaskCreateDtl).%OpenId(AdmTaskCreateDtlID)
	
	s objAdmTaskCreateDtl.EndActDate=nowDate
	s objAdmTaskCreateDtl.EndActTime=nowTime
	
	s sc=objAdmTaskCreateDtl.%Save()
	if $$$ISERR(sc)
	{
		q "-1"	
	}
	else
	{
		q "1"	
	}
}

/// Desc: 根据就诊号查询生成日志
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLAdmTaskCreate","GetCreateLog","373")
Query GetCreateLog(AEpisodeID As %String) As %Query(ROWSPEC = "AdmTaskCreateID:%String,CreateIP:%String,CreateDate:%String,OrderNum:%String,MRItemName:%String,CTItemTypeCode:%String,CTItemTypeName:%String,CTItemTypeProductSource:%String,BeginActTime:%String,EndActTime:%String,InvokeMethod:%String")
{
}

ClassMethod GetCreateLogExecute(ByRef qHandle As %Binary, AEpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	s AdmTaskCreateID=""
	for {
		s AdmTaskCreateID=$o(^DHCEPRFS.INST.AdmTaskCreateI("IdxEpisodeID"," "_AEpisodeID,AdmTaskCreateID))
		q:(AdmTaskCreateID="")
		s objAdmTaskCreate=##class(DHCEPRFS.INST.AdmTaskCreate).%OpenId(AdmTaskCreateID)
		s OrderNum=""
		for {
			s OrderNum=$o(^DHCEPRFS.INST.AdmTaskCrDtlI("IdxCreateOrderNum"," "_AdmTaskCreateID,OrderNum))
			q:(OrderNum="")
			s AdmTaskCreateDtlID=$o(^DHCEPRFS.INST.AdmTaskCrDtlI("IdxCreateOrderNum"," "_AdmTaskCreateID,OrderNum,""))
			q:(AdmTaskCreateDtlID="")
			s objAdmTaskCreateDtl=##class(DHCEPRFS.INST.AdmTaskCreateDtl).%OpenId(AdmTaskCreateDtlID)
			
			s BeginActTime=""
			if (objAdmTaskCreateDtl.BeginActTime="")
			{
				s BeginActTime=""
			}
			else
			{
				s BeginActTime=$zt(objAdmTaskCreateDtl.BeginActTime)
			}
			
			s EndActTime=""
			if (objAdmTaskCreateDtl.EndActTime="")
			{
				s EndActTime=""
			}
			else
			{
				s EndActTime=$zt(objAdmTaskCreateDtl.EndActTime)
			}
			
			s InvokeMethodFull = objAdmTaskCreateDtl.InvokeMethod
			if ((InvokeMethodFull '= "") &&(InvokeMethodFull '= $c(0)))
			{
				//b "s"
				s WebURL = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("WebURL")
				if ($e(WebURL,$l(WebURL),$l(WebURL)) '= "/")
				{
					s WebURL = WebURL_"/"
				}
				s InvokeMethodFull = WebURL_"csp/"_InvokeMethodFull
				//xml不能有冒号，去除前面的http://
				s InvokeMethodFull = $e(InvokeMethodFull,8,$l(InvokeMethodFull))
			}
			
	    	s ^CacheTemp(repid,ind)=$lb(objAdmTaskCreateDtl.AdmTaskCreateID,objAdmTaskCreateDtl.CreateIP, $zd(objAdmTaskCreate.CreateDate,3),objAdmTaskCreateDtl.OrderNum,objAdmTaskCreateDtl.MRItemName,objAdmTaskCreateDtl.CTItemTypeCode,
	    			objAdmTaskCreateDtl.CTItemTypeName,objAdmTaskCreateDtl.CTItemTypeProductSource,BeginActTime,EndActTime,InvokeMethodFull)
	    	s ind=ind+1 	
		}
	}
	Quit $$$OK
}

ClassMethod GetCreateLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCreateLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCreateLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCreateLogExecute ]
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

}

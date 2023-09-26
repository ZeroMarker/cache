/// CTOR: QP
/// DATE: 2020-09-18
/// DESC: 任务日志
Class DHCDoc.GCPSW.BS.TaskLog Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-18
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.TaskLog).Save()
ClassMethod Save(Prj = "", LID = "", Type = "")
{
	s mRtn=0
	s CDate=+$h
	s CTime=$p($h,",",2)
	
	i LID="" {
		s a=##class(User.GCPSWTaskLog).%New()
		i Type="WS" { 
			s startDate=$p(Prj,",",1)
			s startTime=$p(Prj,",",2)
			s endDate=$p(Prj,",",3)
			s endTime=$p(Prj,",",4)
			
			s a.LStartDate=startDate
			s a.LStartTime=startTime
			s a.LEndDate=endDate
			s a.LEndTime=endTime
			
		} else {
			d a.LPrjSetObjectId(Prj)
			s a.LStartDate=+$h
			s a.LStartTime=$p($h,",",2)
		}
		
		
		s a.LType=Type
		
	} else {
		s a=##class(User.GCPSWTaskLog).%OpenId(LID)
		s a.LEndDate=+$h
		s a.LEndTime=$p($h,",",2)
		
	}
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 查询日志
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.BS.TaskLog","QryLog")
Query QryLog(InPrj = "", InSDate = "", InEDate = "") As %Query(ROWSPEC = "id,prj,prjDesc,startDate,startTime,endDate,endTime,type")
{
}

ClassMethod QryLogExecute(ByRef qHandle As %Binary, InPrj = "", InSDate = "", InEDate = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s InSDate=##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical(InSDate)
 	s InEDate=##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical(InEDate)
 	s id=""
 	f  s id=$o(^BS.DOC.GCPSW.TaskLogD(id)) q:id=""  d
 	.s prj=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",1)
 	.s prjDesc=""
 	.q:(prj="")||('$d(^CF.DOC.GCPSW.PrjD(prj)))
 	.q:(InPrj'="")&&(InPrj'=prj)
 	.s prjDesc=$p(^CF.DOC.GCPSW.PrjD(prj),"^",2)
 	.s startDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",2)
 	.s startTime=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",3)
 	.s endDate=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",4)
 	.s endTime=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",5)
 	.s type=$p(^BS.DOC.GCPSW.TaskLogD(id),"^",6)
 	.s type=..GetTaskTypeDesc(type)
 	.q:(InSDate'="")&&(startDate<InSDate)
 	.q:(InEDate'="")&&(endDate>InEDate)
	.i startTime'="" s startTime=$zt(startTime,2)
	.i endTime'="" s endTime=$zt(endTime,2)
 	.s startDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(startDate)
 	.s endDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(endDate)
 	.d output2
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output2
	Set Data=$lb(id,prj,prjDesc,startDate,startTime,endDate,endTime,type)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-09-21
/// DESC: 获取患者最近的身高和体重
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.COM.Func).GetBMI(173,60)
ClassMethod GetTaskTypeDesc(code)
{
	s mRtn=""
	i code="Task" s mRtn="系统任务"
	i code="WS" s mRtn="WS服务"
	
	Q mRtn
}

}

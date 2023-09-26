/// Description：住院Demo-LIS报告明细
/// Table：WDT.CDSS.DEMOLISReportDetail
Class web.CDSS.Demo.LISReportDetail Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2021-03-04
/// Description:获得LIS报告明细
/// Table: WDT.CDSS.DEMOLISReportDetail
/// Input: 
/// Return:返回所有术前讨论记录表内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Demo.LISReportDetail","GetList","1")
Query GetList(parref As %String) As %Query(ROWSPEC = "RowId,LabItem,LabResult,Unit,RefRange,AbnormalResult")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, parref As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	s sub = ""
	for
	{
		s sub = $o(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub))
		q:sub=""
		s RowId=parref_"||"_sub
		s LabItem = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),2)
		s LabResult = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),3)
		s Unit = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),4)
		s RefRange = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),5)
		s AbnormalResult = $lg($g(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub)),6)
		
		d OutputRow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,LabItem,LabResult,Unit,RefRange,AbnormalResult)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2021-03-04
/// Description:保存LIS报告明细
/// Table: WDT.CDSS.DEMOLISReportDetail
/// Input: 
/// others:w ##class(web.CDSS.Demo.LISReportDetail).SaveData("6","")
ClassMethod SaveData(parref, detail)
{
	s result="true"
	s sub = ""
	for
	{
		s sub = $o(^WDT.CDSS.DEMOLISReportD(parref,"ChildReport",sub))
		q:sub=""
		s RowId=parref_"||"_sub
		s arrDetail(RowId)=""
	}
	if (detail'=""){
		s len=$Length(detail,"&")
		for i=1:1:len{
			s row=$p(detail,"&",i)
			s RowId=$p(row,"$",1)
			s LabItem=$p(row,"$",2)
			s LabResult=$p(row,"$",3)
			s Unit=$p(row,"$",4)
			s RefRange=$p(row,"$",5)
			s AbnormalResult=$p(row,"$",6)
			if (RowId=""){
				s objDetail=##class(WDT.CDSS.DEMOLISReportDetail).%New(parref)
			}else{
				s objDetail=##class(WDT.CDSS.DEMOLISReportDetail).%OpenId(RowId)	
			}
			d:parref'="" objDetail.ParRefSetObjectId(parref)
			d:parref="" objDetail.ParRefSetObjectId("")
			s objDetail.LabItem=LabItem
			s objDetail.LabResult=LabResult
			s objDetail.Unit=Unit
			s objDetail.RefRange=RefRange
			s objDetail.AbnormalResult=AbnormalResult
			s scDetail=objDetail.%Save()
			d objDetail.%Close()
			If $$$ISOK(scDetail)
			{
				if ($d(arrDetail(objDetail.%Id()))){
					k arrDetail(objDetail.%Id())
				}
			}else{
				s result="false"
			}
		}
	}
	s Id=""
	for {
		s Id=$o(arrDetail(Id))	q:Id=""
		s scDel=##class(WDT.CDSS.DEMOLISReportDetail).%DeleteId(Id)
	}
	q result
}

}

Class DHCMA.VTE.DI.DIAG Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     mazhaoyan
/// CreatDate：   2019-06-25
/// Description:  查询检查报告记录
/// Table：       DHCRB_Report、DHCPACRegInfo
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.DIAG","QryDiagByEpisodeID",88,"2020-08-18","2020-08-18")
Query QryDiagByEpisodeID(aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ID:%String,aEpisodeDr:%String,ICD10:%String,DiagDesc:%String,DiagTpCode:%String,DiagTpDesc:%String,DiagDate:%String,DiagTime:%String,DiagNote:%String,DiagSource:%String") [ SqlProc ]
{
}

ClassMethod QryDiagByEpisodeIDExecute(ByRef qHandle As %Binary, aEpisodeDr As %String, aDateFrom As %String = "", aDateTo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set $ZT="AutoTaskErr"
	Quit:(aEpisodeDr="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//获取病例 指针  +"123" 转为数字
	Set MRADMDR=$p($g(^PAADM(+aEpisodeDr)),"^",61)
	Quit:MRADMDR="" $$$OK
	Quit:'$d(^MR(MRADMDR,"DIA")) $$$OK
	
	Set DiagSub=0
	For {
		Set DiagSub=$o(^MR(MRADMDR,"DIA",DiagSub))
		Quit:DiagSub=""
		Set (ICD10,ICDDesc,Note,TypeCode,TypeDesc,DiagDate,DiagTime,IsActive)=""
		Set tmpDignos = $g(^MR(MRADMDR,"DIA",DiagSub))
		Continue:tmpDignos=""
		Set DiagDate = $p(tmpDignos,"^",19)
		Set DiagTime = $p(tmpDignos,"^",20)
		//ROWSPEC = 
		//"ID:%String,aEpisodeDr:%String,ICD10:%String,DiagDesc:%String,DiagTpCode:%String,DiagTpDesc:%String,
		//DiagDate:%String,DiagTime:%String,DiagNote:%String,DiagSource:%String"
		Continue:DiagDate=""
		Continue:((aDateFrom'="")&&(DiagDate<aDateFrom))
		Continue:((aDateTo'="")&&(DiagDate>aDateTo))
		
		Set ICDID	 = $p(tmpDignos,"^",1)
		If ICDID'="" {
			Set tmpICD  = $g(^MRC("ID",ICDID))
			Set ICD10   = $p(tmpICD,"^",1)
			Set ICDDesc = $p(tmpICD,"^",2)
		}
		Set Note = $g(^MR(MRADMDR,"DIA",DiagSub,"DES",1))
		
		Set TypeCode=""
		Set xDiagType=$o(^MR(MRADMDR,"DIA",DiagSub,"TYP",0))
		If xDiagType'="" {
			Set TypeID=$g(^MR(MRADMDR,"DIA",DiagSub,"TYP",xDiagType))
			Set TypeCode=$p($g(^MRC("DTYP",+TypeID)),"^",1)
			Set TypeDesc=$p($g(^MRC("DTYP",+TypeID)),"^",2)
		}
		//主诊断标志
		//Set MainDiagFlag=$p($g(^MR(MRADMDR,"DIA",DiagSub,1)),"^",20)
		//If (MainDiagFlag="Y"){
		//	Set TypeCode="M"
		//	Set TypeDesc="主要诊断"
		//}
		if (Note'=""){
			Set ICDDesc = ICDDesc_";备注:"_Note
		}
		Set Data = $lb(DiagSub,aEpisodeDr,ICD10,ICDDesc,TypeCode,TypeDesc,DiagDate,DiagTime,Note,"诊断表")
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}

	Quit $$$OK
AutoTaskErr
	Quit $$$OK
}

ClassMethod QryDiagByEpisodeIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagByEpisodeIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDiagByEpisodeIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagByEpisodeIDExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

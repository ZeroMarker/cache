Import SQLUser

Class web.DHCMedEpidRep Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

ClassMethod GetICDDesc(ICDDr)
{
	n (ICDDr)
	s ret=""
	q:'$d(^DHCMIF(+ICDDr)) ret
	s ICD=$g(^DHCMIF(+ICDDr))
	s ICDCode=$p(ICD,"^",1)
	s Diagnose=$p(ICD,"^",2)
	s ret=ICDDr_"/"_ICDCode_"/"_Diagnose
	q ret
}

ClassMethod BuildData(repid, ind, MEPDInfo, PatInfo)
{
	n (repid,ind,MEPDInfo,PatInfo)
	
	s s=MEPDInfo
	s sPat=PatInfo
	set Data=$lb("")
	s:$p(s,"^",3)'="" $p(s,"^",3)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicReportRegion",$p(s,"^",3))
	s:$p(s,"^",4)'="" $p(s,"^",4)=##class(web.DHCMedDictoryCtl).GetByTypeCode("Career",$p(s,"^",4))
	s:$p(s,"^",6)'="" $p(s,"^",6)=..GetICDDesc($p(s,"^",6))
	s:$p(s,"^",16)'="" $p(s,"^",16)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicReportStatus",$p(s,"^",16))
	
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild) 	
 	s $li(Data,$l(s,"^")+1)=$p(sPat,$c(2),1)    //Name
 	s $li(Data,$l(s,"^")+2)=$p(sPat,$c(2),23)   //PatNo
 	Set ^CacheTemp(repid,ind)=Data
 	q
}

ClassMethod QueryReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, Dep As %String, CtLoc As %String, Status As %String, Place As %String, Disease As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

    //s:DateFrom'="" DateFrom=$zd($zdh(DateFrom,4),3)
    //s:DateTo'="" DateTo=$zd($zdh(DateTo,4),3)
    
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    
	s:DateFrom'="" DateFrom=$zd(DateFrom,3)
	s:DateTo'="" DateTo=$zd(DateTo,3)
	
	q:(DateFrom="")!(DateTo="") $$$OK
	
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s Ret=$$QueryA^DHCMedEpidemic(DateFrom,DateTo,Dep,CtLoc,Status,Place)
	zn CurrentNS
	q:+Ret<0 $$$OK
	s iCount=+Ret
	s JIndex=$p(Ret,"^",2)
	f IndexApp=0:1:iCount d
	.zn MEDDATA
	.s s=$$GetDataByIndex^DHCMedEpidemic(JIndex,IndexApp)
	.s sPat=$$GetPatInfo^DHCMedBase(+$p(s,"^",2))
	.zn CurrentNS
	.i ((Disease'="")&&($p(s,"^",8)[Disease))||(Disease="")  d
	..d ..BuildData(repid,ind,s,sPat)
	..s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportExecute ]
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

Query QueryReport(DateFrom As %String, DateTo As %String, Dep As %String, CtLoc As %String, Status As %String, Place As %String, Disease As %String) As %Query(ROWSPEC = "Rowid:%String:报告ID,PapmiDR:%String:病人ID,Area:%String:位置,Occupation:%String:职业,FamName:%String:监护人姓名,ICDDR:%String:诊断,IntimateCode:%String:密切接触,DiagnoseType:%String:诊断类型,SickDate:%String:发病日期,DiagDegree:%String:诊断级别,DiagDate:%String:诊断日期,SickKind:%String:发病性质,DeathDate:%String:死亡日期,LocDR:%String:科室,RepPlace:%String:上报位置,Status:%String:状态,RepUsrDR:%String:报告人,RepDate:%String:报告日期,RepTime:%String:报告时间,CheckUsrDR:%String:审核人,CheckDate:%String:审核日期,CheckTime:%String:审核时间,Demo:%String:备注,DelReason:%String:删除/退回原因,BeEditDR:%String,TelPhone:%String:联系电话,Address:%String:地址,Company:%String:工作单位,Name:%String:姓名,PatNo:%String:登记号")
{
}

ClassMethod GetMEPD(MEPDRowid)
{
     Set Config=##Class(websys.Configuration).%OpenId(1)
     Set MEDDATA=Config.DataNamespace
     Set LABDATA=Config.LabDataNamespace
     Set CurrentNS=$ZNSPACE
     d Config.%Close()
     zn MEDDATA
	 s ret=$$GetMEPD^DHCMedEpidemic(MEPDRowid)
	 zn CurrentNS
	 q ret
}

ClassMethod QryRepByPapmiClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByPapmiExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryRepByPapmiExecute(ByRef qHandle As %Binary, PatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	//^DHCMEPD(0,"PAPMIICD",{MEPD_Papmi_DR},{MEPD_ICD_DR},{MEPD_Rowid})
	q:+PatientID=0 $$$OK
	q:'$d(^DHCMEPD(0,"PAPMIICD",PatientID)) $$$OK
	s ICDRowid="" //Modified By LiYang 2010-07-28 处理疾病为空的草稿
	f  s ICDRowid=$o(^DHCMEPD(0,"PAPMIICD",PatientID,ICDRowid)) q:ICDRowid=""  d
	.s Rowid=0
	.f  s Rowid=$o(^DHCMEPD(0,"PAPMIICD",PatientID,ICDRowid,Rowid)) q:Rowid=""  d
	..s s=..GetMEPD(Rowid)
	..s sPat=##Class(web.DHCMedBaseCtl).GetPatInfo(+PatientID)
	..d ..BuildData(repid,ind,s,sPat)
	..s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryRepByPapmiFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByPapmiExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCMedEpidRep","QryRepByPapmi","1129")
Query QryRepByPapmi(PatientID As %String) As %Query(ROWSPEC = "Rowid:%String,PapmiDR:%String,Area:%String,Occupation:%String,FamName:%String,ICDDR:%String,IntimateCode:%String,DiagnoseType:%String,SickDate:%String,DiagDegree:%String,DiagDate:%String,SickKind:%String,DeathDate:%String,LocDR:%String,RepPlace:%String,Status:%String,RepUsrDR:%String,RepDate:%String,RepTime:%String,CheckUsrDR:%String,CheckDate:%String,CheckTime:%String,Demo:%String,DelReason:%String,BeEditDR:%String,TelPhone:%String,Address:%String,Company:%String,Name:%String,PatNo:%String")
{
}

}

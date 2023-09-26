Import SQLUser

Class web.DHCMedInjuryRep Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

/// ^MRC("ID",
ClassMethod QryInjDiagByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInjDiagByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryInjDiagByAliasExecute(ByRef qHandle As %Binary, DiagAlias) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s Rowid=0
	s DiagAlias=$$ALPHAUP^SSUTIL4(DiagAlias)
	;^MRC("ID",Rowid)
	;^MRC("ID",0,"Desc",$$ALPHAUP({MRCID_ShortDesc}),{MRCID_RowId})
	i DiagAlias="" d
	.f  s Rowid=$o(^MRC("ID",Rowid)) q:(Rowid="")  d
	..s tmp=$g(^MRC("ID",Rowid))
    ..s s=Rowid_"^"_tmp
    ..d BuildMRCData
    e  d
    .s tmpDiag=""
	.f  s tmpDiag=$o(^MRC("ID",0,"Desc",tmpDiag)) q:tmpDiag=""  d
	..q:tmpDiag'[DiagAlias		// update by lyh 2010-06-02
	..s Rowid=""
	..f  s Rowid=$o(^MRC("ID",0,"Desc",tmpDiag,Rowid)) q:(Rowid="")  d
	...s tmp=$g(^MRC("ID",Rowid))
    ...s s=Rowid_"^"_tmp
    ...d BuildMRCData
	
	Quit $$$OK
BuildMRCData
	;set Data=$lb(id,code,desc,InsDesc,ICD9CM_Code)
	set Data=$lb("")
 	f iBuild=1:1:5 d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryInjDiagByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInjDiagByAliasExecute ]
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

/// 根据别名或名称查询诊断
/// d ##Class(%ResultSet).RunQuery("web.DHCMedInjuryRep","QryInjDiagByAlias","11")
Query QryInjDiagByAlias(DiagAlias) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,InsDesc:%String,ICD9CM_Code:%String")
{
}

ClassMethod UpdateInj(Instring, InstringDtl)
{
	n (Instring,InstringDtl)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ret=""
	zn MEDDATA
	s ret=$$UpdateInj^DHCMedInjury(Instring,InstringDtl)
	zn CurrentNS
	q ret
}

ClassMethod UpdateCheckInj(MInjRowid, Status, CheckUsr, CheckDate, CheckTime, ResumeText)
{
	n (MInjRowid,Status,CheckUsr,CheckDate,CheckTime,ResumeText)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateCheckInj^DHCMedInjury(MInjRowid,Status,CheckUsr,CheckDate,CheckTime,ResumeText)
	zn CurrentNS
	q ret
}

ClassMethod QryRepByPaAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByPaAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryRepByPaAdmExecute(ByRef qHandle As %Binary, PatientID As %String, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	s PaAdmID=EpisodeID
	//^DHCMEPD(0,"PAPMIICD",{MEPD_Papmi_DR},{MEPD_ICD_DR},{MEPD_Rowid})
	q:(+PatientID=0)!(+PaAdmID=0) $$$OK
	q:'$d(^DHCMINJ(0,"PaAdm",PaAdmID)) $$$OK
	s Rowid=0
	f  s Rowid=$o(^DHCMINJ(0,"PaAdm",PaAdmID,Rowid)) q:Rowid=""  d
    .s s=..GetMINJ(Rowid)
	.s sPat=##Class(web.DHCMedBaseCtl).GetPatInfo(+PatientID)
	.d ..BuildData(repid,ind,s,sPat)
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryRepByPaAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByPaAdmExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCMedInjuryRep","QryRepByPaAdm","98782","58740")
Query QryRepByPaAdm(PatientID As %String, EpisodeID As %String) As %Query(ROWSPEC = "Rowid:%String,PaAdmDR:%String,CardNo:%String,CardStatus:%String,InjDate:%String,InjTime:%String,Diagnose:%String,RepUsr_DR:%String,RepDate:%String,RepTime:%String,CheckUsr_DR:%String,CheckDate:%String,CheckTime:%String,IsActive:%String,ResumeText:%String,Name:%String,PatNo:%String")
{
}

ClassMethod GetMINJ(Rowid)
{
     Set Config=##Class(websys.Configuration).%OpenId(1)
     Set MEDDATA=Config.DataNamespace
     Set LABDATA=Config.LabDataNamespace
     Set CurrentNS=$ZNSPACE
     d Config.%Close()
     zn MEDDATA
	 s ret=$$GetMINJ^DHCMedInjury(Rowid)
	 zn CurrentNS
	 q ret
}

ClassMethod GetMINJDtl(Rowid)
{
     Set Config=##Class(websys.Configuration).%OpenId(1)
     Set MEDDATA=Config.DataNamespace
     Set LABDATA=Config.LabDataNamespace
     Set CurrentNS=$ZNSPACE
     d Config.%Close()
     zn MEDDATA
	 s ret=$$GetInjDtl^DHCMedInjury(Rowid)
	 zn CurrentNS
	 q ret
}

ClassMethod BuildData(repid, ind, MINJInfo, PatInfo)
{
	n (repid,ind,MINJInfo,PatInfo)
	
	s s=MINJInfo
	s sPat=PatInfo
	set Data=$lb("")
	s:$p(s,"^",4)'="" $p(s,"^",4)=##class(web.DHCMedDictoryCtl).GetByTypeCode("InjCardStatus",$p(s,"^",4))
	s:$p(s,"^",7)'="" $p(s,"^",7)=..GetICDDesc($p(s,"^",7))
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild) 	
 	s $li(Data,$l(s,"^")+1)=$p(sPat,$c(2),1)    //Name
 	s $li(Data,$l(s,"^")+2)=$p(sPat,$c(2),23)   //PatNo
 	Set ^CacheTemp(repid,ind)=Data
 	q
}

ClassMethod GetICDDesc(ICDDr)
{
	n (ICDDr)
	s ret=""
	q:'$d(^MRC("ID",+ICDDr)) ret
	s ICD=$g(^MRC("ID",+ICDDr))
	s ICDCode=$p(ICD,"^",1)
	s Diagnose=$p(ICD,"^",2)
	s ret=ICDDr_"/"_ICDCode_"/"_Diagnose
	q ret
}

ClassMethod GetMInjPat(MInjRowid, Papmi)
{
	n (MInjRowid,Papmi)
	q:MInjRowid="" ""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s sMInj=$$GetMINJ^DHCMedInjury(MInjRowid)
	zn CurrentNS
	s paAdm=+$p(sMInj,"^",2)
	s sPatInfo=##class(web.DHCMedBaseCtl).GetPatInfo(Papmi)
	///报告运行状态
	s:$p(sMInj,"^",4)'="" $p(sMInj,"^",4)=$p(sMInj,"^",4)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("InjCardStatus",$p(sMInj,"^",4))
	s sICD=..GetICDDesc(+$p(sMInj,"^",7))
	
	s s=sMInj_$c(1)_sPatInfo_$c(1)_sICD
    q s
}

ClassMethod StaInjuryRepByInjReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaInjuryRepByInjReasonExecute ]
{
	s repid=$LIST(qHandle,2)
 	k ^CacheTemp(repid)
	Q $$$OK
}

ClassMethod StaInjuryRepByInjReasonExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, InjReason As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:(DateFrom="")!(DateTo="") $$$OK
	
	Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	Set:DateFrom'="" DateFrom=+DateFrom
	Set:DateTo["/" DateTo=$zdh(DateTo,4)
	Set:DateTo["-" DateTo=$zdh(DateTo,3)
	Set:DateTo'="" DateTo=+DateTo
	Quit:(DateFrom="")||(DateTo="") $$$OK
	
	s i=0
	k ^CacheTemp("StaInjuryRepByInjReason", $j)
	s DictRowId=..GetRowIdByTypeCode("SYS","InjReason")
	i InjReason="all" d
    .s InjReasonStr=##Class(web.DHCMedDictoryCtl).GetByType("InjReason","Y")
    .f i=1:1:($l(InjReasonStr,$c(1))-1) d    
	..s InjReasonVals=$p(InjReasonStr,$c(1),i)
    ..s InjReasonRowId=$p(InjReasonVals,"^",1)
    ..s ^CacheTemp("StaInjuryRepByInjReason", $j,InjReasonRowId)=""
    e  d
    .s ^CacheTemp("StaInjuryRepByInjReason", $j,InjReason)=""
	s tmpDate = DateFrom-1
    f  s tmpDate=$o(^DHCMINJ(0,"RepDate",tmpDate)) q:(tmpDate="")!(tmpDate>=DateTo)  d
    .s tmpRepRowId=""
    .f  s tmpRepRowId=$o(^DHCMINJ(0,"RepDate",tmpDate,tmpRepRowId)) q:tmpRepRowId=""  d
    ..s ^CacheTemp("StaInjuryRepByInjReason", $j,"Count")=+$g(^CacheTemp("StaInjuryRepByInjReason", $j,"Count"))+1
    ..s DtlRowId=""
    ..f  s DtlRowId=$o(^DHCMINJDtl(0,"InjDrAndDicDr",tmpRepRowId,DictRowId,DtlRowId)) q:DtlRowId=""  d
    ...s ValRowId=$p($g(^DHCMINJDtl(DtlRowId)),"^",3)
    ...i $d(^CacheTemp("StaInjuryRepByInjReason", $j,ValRowId)) d
    ....s ^CacheTemp("StaInjuryRepByInjReason", $j,ValRowId,"Count")=+$g(^CacheTemp("StaInjuryRepByInjReason", $j,ValRowId,"Count"))+1
    d BuildStaByInjReasonData
	k ^CacheTemp("StaInjuryRepByInjReason", $j)
	Quit $$$OK
BuildStaByInjReasonData
    s (Count,CountSum)=0
    s CountSum=+$g(^CacheTemp("StaInjuryRepByInjReason", $j,"Count"))
    s InjReasonRowId=0
    f  s InjReasonRowId=$o(^CacheTemp("StaInjuryRepByInjReason", $j,InjReasonRowId)) q:InjReasonRowId=""  d
    .s Data=$lb("")
    .s InjReasonDesc=$p($g(^DHCMDIC(+InjReasonRowId)),"^",2)    //伤害发生原因
    .s $li(Data,1)=InjReasonDesc
    .s Count=+$g(^CacheTemp("StaInjuryRepByInjReason", $j,InjReasonRowId,"Count"))  
    .s $li(Data,2)=Count
	.i Count=0  d
	..s $li(Data,3)=0_"%"
	.e  d
	..s $li(Data,3)=+$fn((Count*100)/(CountSum),"+",2)_"%"       //精确到小数后两位
 	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	//统计
	s Data=$lb("")        
	s $li(Data,1)="合计："
	s $li(Data,2)=CountSum
	s $li(Data,3)="100%"
 	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
}

ClassMethod StaInjuryRepByInjReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaInjuryRepByInjReasonExecute ]
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

/// d ##Class(%ResultSet).RunQuery("web.DHCMedInjuryRep","StaInjuryRepByInjReason","2009-01-01","2009-05-27","")
Query StaInjuryRepByInjReason(DateFrom As %String, DateTo As %String, InjReason As %String) As %Query(ROWSPEC = "RetInjReason:%String,RetPerson:%String,RetPer:%String")
{
}

/// 通过字典类型/字典代码获取字典项
/// Type：字典类型
/// Code：字典Code
ClassMethod GetRowIdByTypeCode(Type, Code)
{
	n (Type,Code)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$QueryByTypeCode^DHCMedDictory(Type,Code)
	zn CurrentNS
	s:s'="" s=$p(s,"^",1)	
	q s
}

}

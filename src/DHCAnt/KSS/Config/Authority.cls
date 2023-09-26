/// CTOR: QP
/// DATE: 2017-02-28
/// VERN: V4.1.3
/// DESC: 抗菌药物权限配置操作类
Class DHCAnt.KSS.Config.Authority Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: dyp
/// DESC: 科室
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","QryGetdep")
Query QryGetdep(loc As %String = "", InHosp = "") As %Query(ROWSPEC = "id:%String,text:%String,code")
{
}

ClassMethod QryGetdepExecute(ByRef qHandle As %Binary, loc As %String = "", InHosp = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s locid=""
    f  s locid=$o(^CTLOC(locid))  q:locid=""  d
    .s locdesc=$p(^CTLOC(locid),"^",2)
    .i locdesc["-"  s locdesc=$p(locdesc,"-",2)
    .s type=$p(^CTLOC(locid),"^",13)
    .s code=$p(^CTLOC(locid),"^",43)
    .q:(type'="E")&&(type'="EM")
    .s hospDr=$p(^CTLOC(locid),"^",22)
    .q:hospDr=""
    .q:(InHosp'="")&&(hospDr'=InHosp)
    .d OutputRow11
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow11
    set Data=$lb(locid,locdesc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryGetdepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetdepExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryGetdepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetdepExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// CTOR: dyp
/// DESC: 医师级别
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","QryDoctorLevl")
Query QryDoctorLevl() As %Query(ROWSPEC = "id:%String,text:%String,code")
{
}

ClassMethod QryDoctorLevlExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s ctpctid=0
    f  s ctpctid=$o(^CT("CPT",ctpctid))  q:ctpctid=""  d
    .s ctpctdesc=$p(^CT("CPT",ctpctid),"^",2)
    .s code=""
    .s bid=$o(^User.BDPAliasI("DataRef","CT_CarPrvTp",ctpctid,""))
    .i bid'="" s code=$lg(^User.BDPAliasD(bid),2)
    .d OutputRow12
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow12
    set Data=$lb(ctpctid,ctpctdesc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryDoctorLevlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDoctorLevlExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryDoctorLevlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDoctorLevlExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// CTOR: dyp
/// DESC: 抗菌药物级别
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","QryKSSLevl")
Query QryKSSLevl(InHosp = "") As %Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod QryKSSLevlExecute(ByRef qHandle As %Binary, InHosp = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    i (InHosp="") {
		Set qHandle=$lb(0,repid,0)
    	Quit $$$OK
	}
    //i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
    s poisonid=0
    f  s poisonid=$o(^PHCPO(poisonid))  q:poisonid=""  d
    .s poisondesc=$p(^PHCPO(poisonid),"^",2)
    .s poisoncode=$p(^PHCPO(poisonid),"^",1)
    .;q:poisoncode'["KSS"
    .s inControl=##class(DHCAnt.KSS.Config.PoisonSet).InControl(InHosp,poisonid)
    .q:inControl=0
    .d OutputRow13
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow13
    set Data=$lb(poisonid,poisondesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryKSSLevlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKSSLevlExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryKSSLevlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKSSLevlExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2017-06-01
/// DESC: 通过科室id,医护人员级别id获取医护人员的列表
/// IN  : 
/// OUT : text,id
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","QryDoctor","","1")
Query QryDoctor(depid As %String, ctcarptype As %String, docFlag As %String = "", InHosp = "") As %Query(ROWSPEC = "text:%String,id:%String,code")
{
}

ClassMethod QryDoctorExecute(ByRef qHandle As %Binary, depid As %String = "", ctcarptype As %String, docFlag As %String = "", InHosp = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    q:docFlag'="" $$$OK
    
    i (depid="")&&(ctcarptype'="") d
    .s docdr=""
    .f  s docdr=$o(^CTPCP(0,"CareProvType",ctcarptype,docdr)) q:docdr=""  d
    ..s CTCarPrvTpdesc=$P($g(^CTPCP(docdr,1)),"^",2)
    ..d OutputRow9
    
    i (depid="")&&(ctcarptype="") d
    .s docdr=""
    .f  s docdr=$o(^CTPCP(docdr)) q:docdr=""  d
    ..s CTCarPrvTpDR=$P($g(^CTPCP(docdr,1)),"^",4)
    ..q:CTCarPrvTpDR=""
    ..s type=$p(^CT("CPT",CTCarPrvTpDR),"^",4)
    ..q:type'="DOCTOR"
    ..s CTCarPrvTpdesc=$P($g(^CTPCP(docdr,1)),"^",2)
    ..d OutputRow9
    
    i depid'="" d
    .s dep=""
    .f  s dep=$o(^RB("RES",0,"CTLOC",dep))  q:dep=""  d
    ..q:(depid'="")&&(dep'=depid)
    ..s RowId=""
    ..f  s RowId=$o(^RB("RES",0,"CTLOC",dep,RowId))  q:RowId=""  d
    ...s docdr=$p($g(^RB("RES",RowId)),"^",2) 
    ...q:docdr=""
    ...;s docdesc=$p(^CTPCP(docdr,1),"^",2)
    ...s CTCarPrvTpDR=$P($g(^CTPCP(docdr,1)),"^",4)
	...q:(ctcarptype'="")&&(CTCarPrvTpDR'=ctcarptype)
	...s CTCarPrvTpdesc=$P($g(^CTPCP(docdr,1)),"^",2)
    ...d OutputRow9
     
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow9
 	s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(docdr)
    q:uid=""
	s docNum=$p(^SSU("SSUSR",uid),"^",1)
    s otherName=$p(^CTPCP(docdr,3),"^",28)
    s code=docNum_"-"_otherName
    s AllHosp=$p(^SSU("SSUSR",uid),"^",98)	;
    s sub=""
	f  s sub=$o(^SSU("SSUSR",uid,"OTHLL",sub)) q:sub=""  d
	.s cHosp=$p(^SSU("SSUSR",uid,"OTHLL",sub),"^",3)
	.q:cHosp=""
	.i AllHosp="" s AllHosp=cHosp
	.e  d
	..i ##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,cHosp)'=1 s AllHosp=AllHosp_","_cHosp
    q:(InHosp'="")&&(##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,InHosp)'=1)
    set Data=$lb(CTCarPrvTpdesc,docdr,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryDoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDoctorExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryDoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDoctorExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// CTOR:   QP
/// DATE:   2017-03-01
/// Table:  DHC_CarPrvTpPHPCp,DHC_CarPrvTpPHPoison
/// DESC:   查询医师级别或医师的处方权限的类型
/// INPUT:  isCkecked - 只查询主表条件，locId - 科室id，docLevel - 医师级别，docId - 医师id(医护人员表)，docNum - 工号，admType - 就诊类型，poisonId - 抗菌药物级别， isKSSAuthority - 医师处方权，isVerifyAuthority - 是否审核权限
/// OUTPUT: tppRowId  rowId       CTCPTDesc     tppPoisonDr     phcpoDesc   tppControlType  tppControlTypeDesc   tppEpisodeType     tppEpisodeTypeDesc     tppChkVerify   ctDocId  ctDocDesc     isKssAut        docAut
///         主表id   医师级别id  医师级别描述  抗菌药物级别id  抗菌药物级别  允许类型代码   允许类型描述           就诊类型            就这类型描述       是否有审核权限   医生id   医生描述  是否权限到医生   医生处方权
/// DEBUG:  d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","QryKSSAuthority","1","","","","","","","","","2","")
Query QryKSSAuthority(isCkecked As %String = "", locId As %String = "", docLevel As %String = "", docId As %String = "", docNum As %String = "", admType As %String = "", poisonId As %String = "", isKSSAuthority As %String = "", isVerifyAuthority As %String = "", InHosp = "", IsItem = "") As %Query(ROWSPEC = "id:%String,rowId:%String,CTCPTDesc:%String,tppPoisonDr:%String,phcpoDesc:%String,tppControlType:%String,tppControlTypeDesc:%String,tppEpisodeType:%String,tppEpisodeTypeDesc:%String,tppChkVerify:%String,ctDocId:%String,ctDocDesc:%String,isKssAut:%String,docAut:%String,DateFrom:%String,DateTo:%String,hospId,hospDesc")
{
}

ClassMethod QryKSSAuthorityExecute(ByRef qHandle As %Binary, isCkecked As %String = "", locId As %String = "", docLevel As %String = "", docId As %String = "", docNum As %String = "", admType As %String = "", poisonId As %String = "", isKSSAuthority As %String = "", isVerifyAuthority As %String = "", InHosp = "", IsItem = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
	Set qHandle=$lb(0,repid,0)
	i InHosp="" {
		Quit $$$OK
	}
	s IsItem=0	;##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTHTODOC",InHosp)
	s docNum=$zcvt(docNum,"U")
	s DateFrom="",DateTo=""
	s ^TEMP("DHCANT","TMP",1)=isCkecked_":"_locId_":"_docLevel_":"_docId
	s ^TEMP("DHCANT","TMP",2)=docNum_":"_admType_":"_poisonId_":"_isKSSAuthority_":"_isVerifyAuthority
	i docNum'="" q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",docNum)) $$$OK
	i isKSSAuthority=1 d	//处方权
	.d GetKSSAuthority
	e  i IsItem=1 d
	.d GetItemPosion
	e  i isCkecked=1 d
	.d GetCPTPosion
	e  i (docId'="")!(docNum'="") d	//医生或医生工号
	.i docId'="" d
	..s doctorId=docId
	..s rowId=$p(^CTPCP(doctorId,1),"^",4)
	.i docNum'="" d 
	..s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",docNum,""))
	..s doctorId=$p(^SSU("SSUSR",userId),"^",14)
	..i doctorId'="" s rowId=$p(^CTPCP(doctorId,1),"^",4)
	.q:doctorId=""
	.d GetDocPosion
	e  i locId'="" d	//科室
	.s resRowid=0
    .f  s resRowid=$o(^RB("RES",0,"CTLOC",locId,resRowid)) q:resRowid=""  d
    ..s doctorId=$P(^RB("RES",resRowid),"^",2)
    ..s rowId=$p(^CTPCP(doctorId,1),"^",4)
    ..q:(docLevel'="")&&(docLevel'=rowId)
    ..d GetDocPosion
    e  i docLevel'="" d	//医生级别
    .s rowId=docLevel
    .s doctorId="" 
 	.f  s doctorId=$o(^CTPCP(0,"CareProvType",rowId,doctorId)) q:doctorId=""  d
 	..d GetDocPosion
    
    Quit $$$OK
    
GetKSSAuthority
	s MCGID=""
	f  s MCGID=$o(^DHCAntBaseMainConfigI("MCGParentCode","NOAUTHDOC",MCGID)) q:MCGID=""  d
    .s tppRowId=MCGID
    .s hospId="",hospDesc=""
    .s MCGCode=$p(^DHCAntBaseMainConfigD(MCGID),"^",3)
    .s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
    .q:MCGactive'=1
    .s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9) 
    .q:MCGvalue'=0
    .s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    .s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7)
    .s hospId=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",14)
    .q:(InHosp'="")&&(hospId'=InHosp)
	.i hospId'="" s hospDesc=$p(^CT("HOSP",hospId),"^",2)
    .q:DateTo<+$h
    .s DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
    .s DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
    .s doctorId=$p(MCGCode,"F",2)
    .q:(docId'=doctorId)&&(docId'="")
    .s CTCPTDesc=""
    .i doctorId'="" d
    ..s ctLevelId=$p(^CTPCP(doctorId,1),"^",4)
    ..i ctLevelId'="" s CTCPTDesc=$P(^CT("CPT",ctLevelId),"^",2)
	.s tppPoisonDr="",phcpoDesc="全部",tppControlType="",tppControlTypeDesc="无处方权",tppEpisodeType="所有",tppEpisodeTypeDesc="",tppChkVerify="0",ctDocId=doctorId,ctDocDesc=$P(^CTPCP(doctorId,1),"^",2),isKssAut="1",docAut="0"
	.d output1
	q
GetItemPosion
	//tppRowId,rowId,CTCPTDesc,tppPoisonDr,phcpoDesc,tppControlType,
	//tppControlTypeDesc,tppEpisodeType,tppEpisodeTypeDesc,tppChkVerify,
	//ctDocId,ctDocDesc,isKssAut,docAut,DateFrom,DateTo,hospId,hospDesc
	k ^CF.DOC.ANT.TEMP($j)
	s rowId="" 
 	f  s rowId=$o(^CT("CPT",rowId)) q:rowId=""  d
 	.s CTCPTDesc=$P(^CT("CPT",rowId),"^",2)
 	.s chl=0   
 	.f  s chl=$o(^CT("CPT",rowId,"PHPO",chl)) q:chl=""  d
 	..s tppRowId=rowId_"||"_chl // 主表id
 	..s tppPoisonDr=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",1)
 	..s phcpoDesc=$p($g(^PHCPO(tppPoisonDr)),"^",2)
 	..q:(poisonId'="")&&(poisonId'=tppPoisonDr)	//过滤抗菌药物级别
 	..s tppControlType=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",2)
 	..s tppControlTypeDesc=..GetControlType(tppControlType)
 	..s tppEpisodeType=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",3)
 	..q:(admType'="")&&(admType'=tppEpisodeType) // 过滤就诊类型
 	..s tppEpisodeTypeDesc=..GetAdmTypeDesc(tppEpisodeType)
 	..s hospId=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",5)
 	..Q:hospId=""
 	..s hospDesc=$p(^CT("HOSP",hospId),"^",2)
 	..q:(InHosp'="")&&(hospId'=InHosp)
 	..s subchl=0
	..f  s subchl=$o(^CT("CPT",rowId,"PHPO",chl,"CP",subchl)) q:subchl=""  d
	...s ctDocId=$p(^CT("CPT",rowId,"PHPO",chl,"CP",subchl),"^",4)
	...s ctDocDesc=$P(^CTPCP(ctDocId,1),"^",2)
	...s tppChkVerify=$p(^CT("CPT",rowId,"PHPO",chl,"CP",subchl),"^",7)
 	...s tppChkVerify=$case(tppChkVerify,"Y":1,"N":0,:"")
 	...q:(isVerifyAuthority'="")&&(isVerifyAuthority'=tppChkVerify)
 	...s isKssAut=1
 	...s docAut=1	;处方权
 	...s DateFrom="",DateTo=""
	...;处理处方权
	...s MCGCode="F"_ctDocId
	...s InMCG=0
	...s MCGID=""
	...f  s MCGID=$O(^DHCAntBaseMainConfigI("MCGCode",MCGCode,MCGID)) Q:(MCGID="")||(InMCG=1)  d
	....s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	....q:MCGactive'=1
	....s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    ....s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7) 
    ....q:DateTo<+$h
	....s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	....s hospId=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",14)
	....q:(InHosp'="")&&(hospId'=InHosp)
	....q:MCGvalue'=0
	....s InMCG=1
	...i InMCG=1 d
	....q:$d(^CF.DOC.ANT.TEMP($j,ctDocId))
	....s ^CF.DOC.ANT.TEMP($j,ctDocId)=""
    ....s DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
    ....s DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
	....s tppRowId=MCGID
	....s tppPoisonDr="",phcpoDesc="全部",tppControlType="",tppControlTypeDesc="无处方权",tppEpisodeType="所有",tppEpisodeTypeDesc="",tppChkVerify="0",isKssAut="1",docAut="0"
	....d output1
	...e  d
	....d output1
	
	k ^CF.DOC.ANT.TEMP($j)
	
	q
GetCPTPosion
	s DateFrom="",DateTo=""
	s rowId="" 
 	f  s rowId=$o(^CT("CPT",rowId)) q:rowId=""  d
 	.q:'$d(^CT("CPT",rowId))
 	.q:(docLevel'="")&&(docLevel'=rowId) // 过滤医师级别
 	.s CTCPTDesc=$P(^CT("CPT",rowId),"^",2)
 	.s chl=0   
 	.f  s chl=$o(^CT("CPT",rowId,"PHPO",chl)) q:chl=""  d
 	..q:'$d(^CT("CPT",rowId,"PHPO",chl))
 	..s tppPoisonDr=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",1)
 	..s hospDesc=""
 	..s hospId=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",5)
 	..q:hospId=""
 	..q:'$d(^CT("HOSP",hospId))
 	..i hospId'="" s hospDesc=$p(^CT("HOSP",hospId),"^",2)
 	..q:(InHosp'="")&&(hospId'=InHosp)
 	..q:(poisonId'="")&&(poisonId'=tppPoisonDr) //过滤抗菌药物级别
 	..i (tppPoisonDr'="")&&($d(^PHCPO(tppPoisonDr)))  d
 	...s phcpoDesc=$p($g(^PHCPO(tppPoisonDr)),"^",2)  // 抗生素级别
 	..s tppRowId=rowId_"||"_chl // 主表id
 	..s tppControlType=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",2)
 	..i tppControlType="A" s tppControlTypeDesc="提示"
 	..i tppControlType="F" s tppControlTypeDesc="禁止"
 	..i tppControlType="P" s tppControlTypeDesc="申请单"
 	..i tppControlType="E" s tppControlTypeDesc="越级"
 	..i tppControlType="S" s tppControlTypeDesc="系统申请"
 	..s tppEpisodeType=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",3)
 	..q:(admType'="")&&(admType'=tppEpisodeType) // 过滤就诊类型
 	..i tppEpisodeType="O" s tppEpisodeTypeDesc="门诊"
 	..i tppEpisodeType="E" s tppEpisodeTypeDesc="急诊"
 	..i tppEpisodeType="I" s tppEpisodeTypeDesc="住院"
 	..s tppChkVerify=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",4)
 	..s tppChkVerify=$case(tppChkVerify,"Y":1,"N":0,:"")
 	..q:(isVerifyAuthority'="")&&(isVerifyAuthority'=tppChkVerify)
 	..s ctDocId="",ctDocDesc="",isKssAut="",docAut=""
	..d output1
	q
	
GetDocPosion
	s uid=##class(DHCAnt.KSS.Common.Method).TransCTCareToSSUser(doctorId)
    q:uid=""
    s AllHosp=$p(^SSU("SSUSR",uid),"^",98)	;
    s sub=""
	f  s sub=$o(^SSU("SSUSR",uid,"OTHLL",sub)) q:sub=""  d	//SS_UserOtherLogonLoc
	.s cHosp=$p(^SSU("SSUSR",uid,"OTHLL",sub),"^",3)
	.i AllHosp="" s AllHosp=cHosp
	.e  d
	..i ##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,cHosp)'=1 s AllHosp=AllHosp_","_cHosp
    q:(InHosp'="")&&(##class(DHCAnt.KSS.Common.Method).InArray(AllHosp,InHosp)'=1)
	s CTCPTDesc=$P(^CT("CPT",rowId),"^",2)
	s DateFrom="",DateTo=""
	;处理处方权
	s MCGCode="F"_doctorId
	s MSGHosp="",InMCG=0
	s MCGID=""
	f  s MCGID=$O(^DHCAntBaseMainConfigI("MCGCode",MCGCode,MCGID)) Q:MCGID=""  d
	.s MCGactive=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",5) 
	.q:MCGactive'=1
	.s hospId="",hospDesc=""
	.s DateFrom=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",6) 
    .s DateTo=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",7) 
    .q:DateTo<+$h
	.s MCGvalue=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",9)
	.s hospId=$p($g(^DHCAntBaseMainConfigD(MCGID)),"^",14)
	.i hospId'="" s hospDesc=$p(^CT("HOSP",hospId),"^",2)
	.q:(InHosp'="")&&(hospId'=InHosp)
	.q:MCGvalue'=0
	.i MSGHosp="" s MSGHosp=hospId
	.e  s MSGHosp=MSGHosp_","_hospId
	.s InMCG=1
    .s DateFrom=##class(websys.Conversions).DateLogicalToHtml(DateFrom)
    .s DateTo=##class(websys.Conversions).DateLogicalToHtml(DateTo)
	.s tppRowId=MCGID
	.s tppPoisonDr="",phcpoDesc="全部",tppControlType="",tppControlTypeDesc="无处方权",tppEpisodeType="所有",tppEpisodeTypeDesc="",tppChkVerify="0",ctDocId=doctorId,ctDocDesc=$P(^CTPCP(doctorId,1),"^",2),isKssAut="1",docAut="0"
	.q:(isVerifyAuthority'="")&&(isVerifyAuthority'=tppChkVerify)
	.d output1
	
	;q:(InMCG=1)&&(MSGHosp="")
	i MSGHosp'="" s MSGHosp=","_MSGHosp_","
	s DateFrom="",DateTo=""
	s chl=0
	f  s chl=$o(^CT("CPT",rowId,"PHPO",chl)) q:chl=""  d
 	.q:'$d(^CT("CPT",rowId,"PHPO",chl))
 	.s tppPoisonDr=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",1)
 	.q:(poisonId'="")&&(poisonId'=tppPoisonDr) //过滤抗菌药物级别
 	.i (tppPoisonDr'="")&&($d(^PHCPO(tppPoisonDr)))  d
 	..s phcpoDesc=$p($g(^PHCPO(tppPoisonDr)),"^",2)  // 抗生素级别
 	.s tppRowId=rowId_"||"_chl // 主表id
 	.s tppControlType=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",2)
 	.s hospDesc=""
 	.s hospId=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",5)
 	.i hospId'="" s hospDesc=$p(^CT("HOSP",hospId),"^",2)
 	.q:(InHosp'="")&&(hospId'=InHosp)
 	.s compareHospId=","_hospId_","
 	.q:(MSGHosp'="")&&(MSGHosp[compareHospId)
 	
 	.i tppControlType="A" s tppControlTypeDesc="提示"
 	.i tppControlType="F" s tppControlTypeDesc="禁止"
 	.i tppControlType="P" s tppControlTypeDesc="申请单"
 	.i tppControlType="E" s tppControlTypeDesc="越级"
 	.i tppControlType="S" s tppControlTypeDesc="系统申请"
 	.s tppEpisodeType=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",3)
 	.q:(admType'="")&&(admType'=tppEpisodeType) // 过滤就诊类型
 	.i tppEpisodeType="O" s tppEpisodeTypeDesc="门诊"
 	.i tppEpisodeType="E" s tppEpisodeTypeDesc="急诊"
 	.i tppEpisodeType="I" s tppEpisodeTypeDesc="住院"
 	.s tppChkVerify=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",4)
 	.;i '$d(^CT("CPT",rowId,"PHPO",chl,"CP")) q:(isVerifyAuthority'="")&&(isVerifyAuthority'=tppChkVerify)
 	.s tppChkVerify=$case(tppChkVerify,"Y":1,"N":0,:"")
 	.q:(isVerifyAuthority'="")&&(isVerifyAuthority'=tppChkVerify)
 	.s ctDocId=doctorId
 	.s ctDocDesc=$P(^CTPCP(doctorId,1),"^",2)
 	.i '$D(^CT(0,"CPDR",doctorId,rowId,chl)) d
 	..;s ctDocId="",ctDocDesc="",
 	..s isKssAut=0,docAut=""
 	..d output1
 	.e  d
 	..s subchl=$o(^CT(0,"CPDR",doctorId,rowId,chl,""))
 	..;s ctDocDesc=$P(^CTPCP(doctorId,1),"^",2)
 	..s hospDesc=""
 	..s hospId=$p($g(^CT("CPT",rowId,"PHPO",chl)),"^",5)
 	..i hospId'="" s hospDesc=$p(^CT("HOSP",hospId),"^",2)
 	..q:(InHosp'="")&&(hospId'=InHosp)
 	..s tppControlType=$p(^CT("CPT",rowId,"PHPO",chl,"CP",subchl),"^",8)
 	..i tppControlType="A" s tppControlTypeDesc="提示"
 	..i tppControlType="F" s tppControlTypeDesc="禁止"
 	..i tppControlType="P" s tppControlTypeDesc="申请单"
 	..i tppControlType="E" s tppControlTypeDesc="越级"
 	..i tppControlType="S" s tppControlTypeDesc="系统申请"
 	..s tppdocAut=$p(^CT("CPT",rowId,"PHPO",chl,"CP",subchl),"^",5)
 	..s docAut=$case(tppdocAut,"Y":1,"N":0,:"")
 	..q:(isKSSAuthority'="")&&(isKSSAuthority'=docAut)
 	..s tppChkVerify=$p(^CT("CPT",rowId,"PHPO",chl,"CP",subchl),"^",7)
 	..s tppChkVerify=$case(tppChkVerify,"Y":1,"N":0,:"")
 	..q:(isVerifyAuthority'="")&&(isVerifyAuthority'=tppChkVerify)
 	..s isKssAut=1
 	..s tppRowId=tppRowId_"||"_subchl
 	..d output1
    q
 
output1
	Set Data=$lb(tppRowId,rowId,CTCPTDesc,tppPoisonDr,phcpoDesc,tppControlType,tppControlTypeDesc,tppEpisodeType,tppEpisodeTypeDesc,tppChkVerify,ctDocId,ctDocDesc,isKssAut,docAut,DateFrom,DateTo,hospId,hospDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryKSSAuthorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryKSSAuthorityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryKSSAuthorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryKSSAuthorityExecute ]
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

/// CTOR:   LSJ
/// DATE:   2017-03-02
/// Table:  DHC_CarPrvTpPHPoison
/// DESC:   向权限主表插入数据
/// INPUT:  TPPParRef - 医师级别id，TPPPoisonDR - 抗生素级别id，TPPControlType - 允许类型，EpisodeType - 就诊类型，ChkVerify - 审核权限，HospId - 院区id(预留字段可以为空)
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).AddDHCCarPrvTpPHPoison(1,13,"P","I",1)
ClassMethod AddDHCCarPrvTpPHPoison(TPPParRef As %String, TPPPoisonDR As %String, TPPControlType As %String, EpisodeType As %String, ChkVerify As %String, HospId As %String = "", OperateUser = "")
{
     i TPPControlType=" " s TPPControlType=""
     s ChkVerify=$case(ChkVerify,1:"Y",0:"N",:"")
     s uniqueFlag=..CheckUnique(TPPParRef,"",TPPPoisonDR,EpisodeType,HospId)
     Q:(uniqueFlag="Y") "-202"
 TSTART     
 &SQL(insert into SQLUser.DHC_CarPrvTpPHPoison(TPP_ParRef,TPP_Poison_DR,TPP_ControlType,TPP_EpisodeType,TPP_ChkVerify,TPP_HospId) 
      values(:TPPParRef,:TPPPoisonDR,:TPPControlType,:EpisodeType,:ChkVerify,:HospId)
     )
 i SQLCODE
    {
     TROLLBACK
    q SQLCODE
    }
    s AID=%ROWID
 TCOMMIT
 s docLevel=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(TPPParRef,"doctp")
 s kss=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(TPPPoisonDR,"kss")
 s changeDesc=docLevel_"("_kss_","_EpisodeType_")"
 set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPoison"_$c(2)_AID)
 
 d ##class(web.DHCDocDataChangeLog).SaveLog("DHC_CarPrvTpPHPoison","User.DHCCarPrvTpPHPoison","抗菌药物级别权限表","User.DHCCarPrvTpPHPoison_"_AID,changeDesc,"A",NewDataJson,"",OperateUser)
 
 
 q SQLCODE
}

/// 判断是否重复
/// w ##class(DHCAnt.KSS.Config.Authority).CheckUnique(1,"",12,"I")
/// w ##class(web.DHCCarPrvTpPHPoison).CheckUnique(1,"",4,"EM")
/// TPPParRef: 医生级别id 、 qTPPRowid：主表id、 qTPPPoisonDR：管制分类ID、qTPPEpisodeType: 就诊类型
/// W ##class(DHCAnt.KSS.Config.Authority).CheckUnique("1","","7","I","3")
ClassMethod CheckUnique(TPPParRef As %String, qTPPRowid As %String, qTPPPoisonDR As %String, qTPPEpisodeType As %String, HospId = "")
{
	n (TPPParRef,qTPPRowid,qTPPPoisonDR,qTPPEpisodeType,HospId)
	s ^TEMP("QP","CheckUnique")=$LB(TPPParRef,qTPPRowid,qTPPPoisonDR,qTPPEpisodeType,HospId)
	s RowId=+TPPParRef
	q:'$d(^CT("CPT",RowId)) ""
	
	s Flag="N"
	s Child=0
	f  s Child=$o(^CT("CPT",RowId,"PHPO",Child)) q:Child=""!(Flag="Y")  d
	.q:'$d(^CT("CPT",RowId,"PHPO",Child))
	.s TPPPoisonDR=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",1)
 	.s TPPEpisodeType=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",3)
 	.s TPPHospId=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",5)
 	.q:(RowId_"||"_Child)=qTPPRowid
	.q:qTPPPoisonDR'=TPPPoisonDR
	.q:qTPPEpisodeType'=TPPEpisodeType
	.q:TPPHospId'=HospId
	.s Flag="Y"
	q Flag
}

/// CTOR:   LSJ
/// DATE:   2017-03-02
/// Table:  DHC_CarPrvTpPHPoison
/// DESC:   修改权限表配置，但是医师级别不能修改
/// INPUT:  TPProwID - DHC_CarPrvTpPHPoison表id，TPPPoisonDR - 抗生素级别id，TPPControlType - 允许类型，EpisodeType - 就诊类型，ChkVerify - 审核权限，HospId - 院区id(预留字段可以为空)
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).UpdateDHCCarPrvTpPHPoison("1||3",13,"P","I",1)
ClassMethod UpdateDHCCarPrvTpPHPoison(TPProwID As %String, TPPPoisonDR As %String, TPPControlType As %String, EpisodeType As %String, ChkVerify As %String, HospId As %String = "", OperateUser = "")
{
	//TPP_EpisodeType=:EpisodeType,TPP_Poison_DR=:TPPPoisonDR,
    i TPPControlType=" " s TPPControlType=""
    s ChkVerify=$case(ChkVerify,1:"Y",0:"N",:"")
 set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPoison"_$c(2)_TPProwID)
 TSTART
 &SQL(update SQLUser.DHC_CarPrvTpPHPoison  
        set TPP_ControlType=:TPPControlType,
            TPP_ChkVerify=:ChkVerify,
            TPP_HospId=:HospId
      where TPP_RowId=:TPProwID  
     )
 i SQLCODE
    {
     TROLLBACK
    q SQLCODE
    }
 TCOMMIT
 s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPoison"_$c(2)_TPProwID)
 s docLevel=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(+TPProwID,"doctp")
 s kss=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(TPPPoisonDR,"kss")
 s changeDesc=docLevel_"("_kss_","_EpisodeType_")"
 d ##class(web.DHCDocDataChangeLog).SaveLog("DHC_CarPrvTpPHPoison","User.DHCCarPrvTpPHPoison","抗菌药物级别权限表","User.DHCCarPrvTpPHPoison_"_TPProwID,changeDesc,"U",NewDataJson,OldDataJson,OperateUser)
 
 
 q SQLCODE
}

/// CTOR:   LSJ
/// DATE:   2017-03-02
/// Table:  DHC_CarPrvTpPHPoison
/// DESC:   修改权限表配置，但是医师级别不能修改
/// INPUT:  input串  子表id^主表id^医护人员表id^医师处方权^备注^审核权限^允许类型
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).Update("^1||3^294^1^^1^A")
ClassMethod DBUpdateAuthItem(input As %String) As %String
{
    n (input)
    Set ID=$p(input,"^",1)
    s TppRowid=$p(input,"^",2)
    S rw=+TppRowid
    s chl=$p(TppRowid,"||",2)
    s DocId=$p(input,"^",3)
    s Active=$p(input,"^",4)
    S Active=$case(Active,1:"Y",0:"N",:"")
    s ReMark=$p(input,"^",5)
    s ChkVerify=$p(input,"^",6)
    s ChkVerify=$case(ChkVerify,1:"Y",0:"N",:"")
    s ControlType=$p(input,"^",7)
    q:(($d(^CT(0,"CPDR",DocId,rw,chl)))&&(ID="")) "已经存在该医生的信息!"
    s ^TEMP("QP", "EXCEL", 4)=input
    TSTART  
    If (ID="") {
        &sql(insert into SQLUser.DHC_CarPrvTpPHPCp(TCP_ParRef,TCP_ParRef2,TCP_CarPrvDR,TCP_Active,TCP_ReMark,TCP_ChkVerify,TCP_ControlType) 
        values(:rw,:chl,:DocId,:Active,:ReMark,:ChkVerify,:ControlType))
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }
    } Else {
        &sql(update SQLUser.DHC_CarPrvTpPHPCp set TCP_CarPrvDR=:DocId,TCP_Active=:Active,TCP_ReMark=:ReMark,TCP_ChkVerify=:ChkVerify,TCP_ControlType=:ControlType
        where TCP_RowId=:ID)
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }
    }
    TCOMMIT
    q SQLCODE
}

/// CTOR:   QP
/// DATE:   2017-03-02
/// Table:  DHC_CarPrvTpPHPoison
/// DESC:   修改权限表配置，但是医师级别不能修改
/// INPUT:  input串  子表id^主表id^医护人员表id^医师处方权^备注^审核权限^允许类型
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).DBUpdateAuthItemNew("^294^1^12^A^I^1")
/// id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^" + mainId
ClassMethod DBUpdateAuthItemNew(input As %String) As %String
{
    New (input,%session)
    s ^TEMP("QP",1)=input
    s docName=$p(input,"^",2)
    s docLevel=$p(input,"^",3)
    s kssLevel=$p(input,"^",4)
    i +kssLevel=0 s kssLevel=##class(DHCAnt.KSS.Common.Method).GetPoisonIdByCode(kssLevel)
    S appType=$p(input,"^",5)
    Q:(appType="")||(appType="undefined") "-203"
    s admType=$p(input,"^",6)
    s isAudit=$p(input,"^",7)
    s itemId=$p(input,"^",8)
    s hospId=$p(input,"^",9)
    s OperateUser=$p(input,"^",10)
    i itemId="" s itemId=..GetmainID(docLevel,kssLevel,admType,hospId)
    q:itemId="" "-202"		//获取不到主表id
    
 	s ID=$p(input,"^",1)	;子表ID
    s TppRowid=itemId
    S rw=+TppRowid
    s chl=$p(TppRowid,"||",2)
    s DocId=docName
    S Active="Y"
    s ReMark=""
    s ChkVerify=$case(isAudit,1:"Y",0:"N",:"")
    s ControlType=appType
    q:(($d(^CT(0,"CPDR",DocId,rw,chl)))&&(ID="")) "-201" 	//已经存在该医生信息了
    s docdesc=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(DocId,"doc")
    s poisondesc=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(kssLevel,"kss")
    s changeDesc=docdesc_"("_poisondesc_","_admType_")"
    TSTART  
    If (ID="") {
	    s OperateType="A"
	    s OldDataJson=""
        &sql(insert into SQLUser.DHC_CarPrvTpPHPCp(TCP_ParRef,TCP_ParRef2,TCP_CarPrvDR,TCP_Active,TCP_ReMark,TCP_ChkVerify,TCP_ControlType) 
        values(:rw,:chl,:DocId,:Active,:ReMark,:ChkVerify,:ControlType))
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }
        s ID=%ROWID
        
    } Else {
	    s OperateType="U"
	    s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPCp"_$c(2)_ID)
        &sql(update SQLUser.DHC_CarPrvTpPHPCp set TCP_CarPrvDR=:DocId,TCP_Active=:Active,TCP_ReMark=:ReMark,TCP_ChkVerify=:ChkVerify,TCP_ControlType=:ControlType
        where TCP_RowId=:ID)
        i SQLCODE
        {
            TROLLBACK
            q SQLCODE
        }
    }
    TCOMMIT
    
	set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPCp"_$c(2)_ID)
	s rtn= ##class(web.DHCDocDataChangeLog).SaveLog("DHC_CarPrvTpPHPCp","User.DHCCarPrvTpPHPCp","抗菌药物医生权限表","User.DHCCarPrvTpPHPCp_"_ID,changeDesc,OperateType,NewDataJson,OldDataJson,OperateUser)
	 
    q SQLCODE
}

/// CTOR:   QP
/// DATE:   2017-07-18
/// Table:  DHC_CarPrvTpPHPoison
/// DESC:   修改权限表配置，但是医师级别不能修改
/// INPUT:  input串  子表id^主表id^医护人员表id^医师处方权^备注^审核权限^允许类型
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).DBUpdateAuthItemNew("^294^1^12^A^I^1")
/// id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^" + mainId
ClassMethod DBUpdate9DocAuth(input As %String, InHosp As %String = "") As %String
{
	n (input,InHosp,%session)
	i InHosp="" s InHosp=%session.Get("LOGON.HOSPID")
	s ^TEMP("DHCAnt","KSS",1)=input
	s rtn=0
	q:input="" rtn
	s len=$l(input,"!")
	TS
	f i=1:1:len  d
	.s docAuthInfo=$p(input,"!",i)
	.q:rtn'=0
	.s rtn=..DBUpdateAuthItem9Doc(docAuthInfo,InHosp)
	i rtn'=0 {
		TRO
		Q rtn	
	}
	TC
	q rtn
}

/// CTOR:   QP
/// DATE:   2017-03-02
/// Table:  DHC_CarPrvTpPHPoison
/// DESC:   修改权限表配置，但是医师级别不能修改
/// INPUT:  input串  子表id^主表id^医护人员表id^医师处方权^备注^审核权限^允许类型
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).DBUpdateAuthItemNew("^294^1^12^A^I^1")
/// id + "^" + docName + "^" + docLevel + "^" + kssLevel + "^" + appType + "^" + admType + "^" + isAudit + "^" + mainId
ClassMethod DBUpdateAuthItem9Doc(input As %String, InHosp = "") As %String
{
    New (input,InHosp,%session)
    s ^TEMP("QP",1)=input
    s docName=$p(input,"^",2)
    s docLevel=$p(input,"^",3)
    s kssLevel=$p(input,"^",4)
    i +kssLevel=0 s kssLevel=##class(DHCAnt.KSS.Common.Method).GetPoisonIdByCode(kssLevel)
    S appType=$p(input,"^",5)
    Q:(appType="")||(appType="undefined") "-203"
    s admType=$p(input,"^",6)
    s isAudit=$p(input,"^",7)
    s itemId=$p(input,"^",8)
    i itemId="" s itemId=..GetmainID(docLevel,kssLevel,admType,InHosp)
    q:itemId="" "-202"		//获取不到主表id
    
 	s ID=$p(input,"^",1)	;子表ID
    s TppRowid=itemId
    S rw=+TppRowid
    s chl=$p(TppRowid,"||",2)
    s DocId=docName
    S Active="Y"
    s ReMark=""
    s ChkVerify=$case(isAudit,1:"Y",0:"N",:"")
    s ControlType=appType
    q:(($d(^CT(0,"CPDR",DocId,rw,chl)))&&(ID="")) "-201" 	//已经存在该医生信息了
   	 
   	s docdesc=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(DocId,"doc")
    s poisondesc=##class(DHCAnt.KSS.Common.Method).GetCommonDesc(kssLevel,"kss")
    s changeDesc=docdesc_"("_poisondesc_")"
    
    If (ID="") {
	    s OperateType="A"
    	s OldDataJson=""
        &sql(insert into SQLUser.DHC_CarPrvTpPHPCp(TCP_ParRef,TCP_ParRef2,TCP_CarPrvDR,TCP_Active,TCP_ReMark,TCP_ChkVerify,TCP_ControlType) 
        values(:rw,:chl,:DocId,:Active,:ReMark,:ChkVerify,:ControlType))
        s ID=%ROWID
    } Else {
	    s OperateType="U"
    	s OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPCp"_$c(2)_ID)
    
        &sql(update SQLUser.DHC_CarPrvTpPHPCp set TCP_CarPrvDR=:DocId,TCP_Active=:Active,TCP_ReMark=:ReMark,TCP_ChkVerify=:ChkVerify,TCP_ControlType=:ControlType
        where TCP_RowId=:ID)
    }
    
    set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.DHCCarPrvTpPHPCp"_$c(2)_ID)
    d ##class(web.DHCDocDataChangeLog).SaveLog("DHC_CarPrvTpPHPCp","User.DHCCarPrvTpPHPCp","抗菌药物医生权限表","User.DHCCarPrvTpPHPCp_"_ID,changeDesc,OperateType,NewDataJson,OldDataJson)

    
    q SQLCODE
}

/// zsz 20170308
/// 通过医护人员级别ID，抗菌药物级别，就诊类型，获得它的主表ID
/// debug: w ##class(DHCAnt.KSS.Config.Authority).GetmainID("1","12","I")
/// debug: w ##class(DHCAnt.KSS.Config.Authority).GetmainID("3","13","O")
ClassMethod GetmainID(CTCPTID As %String, poisonID As %String, type As %String, hospId = "") As %String
{
	n (CTCPTID,poisonID,type,hospId)
	s ^TEMP("GetmainID",2)=$LB(CTCPTID,poisonID,type,hospId)
	q:$g(CTCPTID)="" ""
	q:$g(poisonID)="" ""
	q:$g(type)="" ""
	s CTCPTDr="",ID=""
	f  s CTCPTDr=$o(^CT("CPT",CTCPTDr))  q:CTCPTDr=""  d
	.i (CTCPTDr=CTCPTID)  d
	..s Child=0,PoisonRowId="",admType=""
	..f  s Child=$o(^CT("CPT",CTCPTDr,"PHPO",Child)) q:Child=""  d 
	...s PoisonRowId=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",1)
	...s admType=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",3)
	...s hosp=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",5)
	...i (PoisonRowId=poisonID)&&(admType=type)&&(hosp=hospId) s ID=CTCPTDr_"||"_Child
	q ID
}

/// CTOR:   HW
/// DATE:   2017-03-08
/// Table:  
/// DESC:   修改医师处方权
/// INPUT:  MCGRowId : DHCAnt_Base.MainConfigID		DocID : 医护人员表ID 	MCGActive : 是否无处方权 (1 : 无处方权  0 : 有处方权)
/// OUTPUT: Rtn ：-2 : 配置代码为空 -1 : 配置代码已经存在 其他 : 配置表ID 
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).DBUpdateNOAUTHDOC("")
ClassMethod DBUpdateNOAUTHDOC(MCGRowId As %String, DocID As %String, MCGActive As %String, SDate As %String = "", EDate As %String = "", HospId As %String = "") As %String
{
	n (MCGRowId,DocID,MCGActive,SDate,EDate,HospId)
    ;s MCGType="MINIPARAMATER"
    ;s MCGParentCode="NOAUTHDOC"
    s ^TEMP("QP",3)=MCGRowId_"^"_DocID_"^"_MCGActive
    s MCGCode="F"_DocID
    s MCGDesc=$P(^CTPCP(DocID,1),"^",2)
    
    i MCGRowId = "" {
	    s MCGRowId=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",HospId,MCGCode,""))
	}
	/*
    i (MCGRowId = "") {
	   s id=""
	   f  s id=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,id)) q:(id="")||(MCGRowId="")  d
	   .s hosp=$p($g(^DHCAntBaseMainConfigD(id)),"^",8)
	   .q:hosp'=HospId
	   .s MCGRowId=id
    }
	*/
    s SDate=##class(websys.Conversions).DateHtmlToLogical(SDate)
    s EDate=##class(websys.Conversions).DateHtmlToLogical(EDate)
    s Rtn=##Class(DHCAnt.KSS.Config.Function).DBUpdataMainConfig(MCGRowId,"MINIPARAMATER","NOAUTHDOC",MCGCode,MCGDesc,1,SDate,EDate,"",MCGActive,"","","","","",HospId)
    q Rtn
}

/// CTOR:   LSJ
/// DATE:   2017-03-09
/// Table:  DHC_CarPrvTpPHPCp
/// DESC:   删除子表单条记录
/// INPUT:  input串  子表id
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).DBDeleteCPTPCp("1||3||1")
ClassMethod DBDeleteCPTPCp(tcpId As %String) As %String
{
    TS
    &SQL(delete from SQLUser.DHC_CarPrvTpPHPCp where TCP_RowId=:tcpId)
    i SQLCODE{
		TRO
		q SQLCODE
	}
	TC
	q SQLCODE
}

/// CTOR:   QP
/// DATE:   2017-03-20
/// DESC:   导入Excel
/// INPUT:  医生工号	医生姓名	就诊类型	抗生素级别（KSS1）	允许类型（A）	处方权限	审核权限
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).ImportExcel("ys01^医生01^I^KSS3^F^1^DHSZHYYFY")
ClassMethod ImportExcel(excelStr As %String) As %String
{
	n (excelStr)
	s ^TEMP("QP", "EXCEL", 11)=excelStr
	s docNum=$p(excelStr,"^",1)
	s docName=$p(excelStr,"^",2)
	s admType=$p(excelStr,"^",3)
	s kssLevel=$p(excelStr,"^",4)
	s kssLevel=##class(DHCAnt.KSS.Common.Method).GetPoisonIdByCode(kssLevel)
	q:kssLevel="" "-105^找不到该管制分类"	//找不到该管制分类
	s appType=$p(excelStr,"^",5)
	s prescFlag=1	//默认为1
	s authFlag=$p(excelStr,"^",6)
	i authFlag="" s authFlag=0
	s InHospCode=$p(excelStr,"^",7)
	Q:InHospCode="" "-108^院区代码为空"		//院区代码为空
	s InHospCode=$zcvt(InHospCode,"U")
	s InHosp=$o(^CT("HOSP",0,"Code",InHospCode,""))
	Q:InHosp="" "-109^获取不到院区"			//获取不到院区
	
	s docInfo=##class(DHCAnt.KSS.Common.Method).GetDocInfoByDocNum(docNum)
	s ctCareProvTpId=$p(docInfo,"^",1),ctCareProvId=$p(docInfo,"^",2)
	q:ctCareProvTpId="" "-101^获取不到该医生的医护级别" //获取不到该医生的医护级别
	
	s mainId=..GetmainID(ctCareProvTpId, kssLevel, admType,InHosp)
	
	s ^TEMP("QP", "EXCEL", 2)=ctCareProvTpId_"^"_kssLevel_"^"_admType_": "_mainId
	q:mainId="" "-102^没有维护级别权限"	//没有维护该级别的主表
    S rw=+mainId
    s chl=$p(mainId,"||",2)
    s itemId=""
    b ;001
    i $d(^CT(0,"CPDR",ctCareProvId,rw,chl)) s itemId=mainId_"||"_$o(^CT(0,"CPDR",ctCareProvId,rw,chl,""))
	b ;002
    //子表id^主表id^医护人员表id^医师处方权^备注^审核权限^允许类型
    s docAuthStr=itemId_"^"_mainId_"^"_ctCareProvId_"^1^1^"_authFlag_"^"_appType
    s ^TEMP("QP", "EXCEL", 3)=docAuthStr
    s successFlag=..DBUpdateAuthItem(docAuthStr)
    q:successFlag'=0 "-103^插入失败"	//插入失败
    
    s MCGCode="F"_ctCareProvId
     //s MCGRowId=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
    s MCGRowId=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",InHosp,MCGCode,""))
    s docAuthSqlFlag=1
    i prescFlag=0 d		//处理医生处方权
    .s MCGDesc=$P(^CTPCP(ctCareProvId,1),"^",2)
    .s Rtn=##Class(DHCAnt.KSS.Config.Function).DBUpdataMainConfig(MCGRowId,"MINIPARAMATER","NOAUTHDOC",MCGCode,MCGDesc,1,"","","",prescFlag,"","","","","",InHosp)
    .i Rtn<0 s docAuthSqlFlag=0
    q:docAuthSqlFlag=0 "-104^维护医生无处分权失败"	//维护医生无处分权失败
    
    q 1
}

/// CTOR:   QP
/// DATE:   2017-03-20
/// DESC:   导入Excel
/// INPUT:  医生工号	医生姓名	就诊类型	抗生素级别（KSS1）	允许类型（A）	处方权限	审核权限
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).ImportExcel("039^李丽^I^KSS1^A^1^1")
ClassMethod ImportTotalExcel(excelStr As %String) As %String
{
	n (excelStr)
	q:excelStr="" "无数据！"
	s mRtn=1
	s totalLen=$l(excelStr,"!")
	f i=1:1:totalLen {
		s cInput = $p(excelStr,"!",i)
		s rtn=..ImportExcel(cInput)
		i rtn'=1 s mRtn=rtn
		q:rtn'=1 
		
	}
	
    q mRtn
}

/// CTOR: QP
/// DESC: 院区
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","QryHosp")
Query QryHosp() As %Query(ROWSPEC = "id:%String,text:%String,code")
{
}

ClassMethod QryHospExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    s id=0
  	f  s id=$o(^CT("HOSP",id)) q:id=""  d
  	.s text=$p(^CT("HOSP",id),"^",2)
    .d OutputRow22
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow22
    set Data=$lb(id,text)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod QryHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {             
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// CTOR:   QP
/// DATE:   2021-01-11
/// DESC:   导入级别权限
/// INPUT:  
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).ImportExcel("039^李丽^I^KSS1^A^1^1")
ClassMethod ImportKssAuth(excelStr As %String) As %String
{
	n (excelStr,%session)
	q:excelStr="" "无数据！"
	s mRtn=1
	s totalLen=$l(excelStr,"!")
	f i=1:1:totalLen {
		s cInput = $p(excelStr,"!",i)
		s rtn=..ImportSingleKssAuth(cInput)
		i rtn'=0 s mRtn=rtn
		q:rtn'=0
		
	}
	
    q mRtn
}

/// CTOR:   QP
/// DATE:   2021-01-11
/// DESC:   导入单条级别权限
/// INPUT:  
/// OUTPUT: SQLCODE
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).ImportSingleKssAuth("039^李丽^I^KSS1^A^1^1")
ClassMethod ImportSingleKssAuth(excelStr As %String) As %String
{
	n (excelStr,%session)
	
	s docLevel=$p(excelStr,"^",1)
	Q:docLevel="" "-101^医护级别为空！"
	s admType=$p(excelStr,"^",2)
	Q:admType="" "-102^就诊类型为空！"
	s kssLevel=$p(excelStr,"^",3)
	s kssLevel=##class(DHCAnt.KSS.Common.Method).GetPoisonIdByCode(kssLevel)
	q:kssLevel="" "-103^找不到该管制分类！"	//找不到该管制分类
	s appType=$p(excelStr,"^",4)
	Q:admType="" "-104^允许类型为空！"
	s authFlag=$p(excelStr,"^",5)
	i authFlag="" s authFlag=0
	s InHospCode=$p(excelStr,"^",6)
	Q:InHospCode="" "-105^院区代码为空！"		//院区代码为空
	s InHospCode=$zcvt(InHospCode,"U")
	s InHosp=$o(^CT("HOSP",0,"Code",InHospCode,""))
	Q:InHosp="" "-106^获取不到院区！"			//获取不到院区
	
	s docLevel=$zcvt(docLevel,"U")
	q:'$d(^CT("CPT",0,"Desc",docLevel)) "-107^获取不到该医护级别记录！"
	s docLevel=$O(^CT("CPT",0,"Desc",docLevel,""))
	q:docLevel="" "-107^获取不到该医护级别记录！"
	s mainId=..GetmainID(docLevel, kssLevel, admType,InHosp)
	i mainId="" {
		s rtn=..AddDHCCarPrvTpPHPoison(docLevel,kssLevel,appType,admType,authFlag,InHosp)
	} else {
		s rtn=..UpdateDHCCarPrvTpPHPoison(mainId,kssLevel,appType,admType,authFlag,InHosp)
	}
	Q rtn
}

/// CTOR:   QP
/// DATE:   2021-01-11
/// DESC:   获取权限描述
/// INPUT:  
/// OUTPUT: 
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).GetControlType("A")
ClassMethod GetControlType(code As %String) As %String
{
	s mRtn=""
	i code="A" s mRtn="提示"
 	i code="F" s mRtn="禁止"
 	i code="P" s mRtn="申请单"
 	i code="E" s mRtn="越级"
 	i code="S" s mRtn="系统申请"
 	
 	Q mRtn
}

/// CTOR:   QP
/// DATE:   2021-01-11
/// DESC:   获取就诊类型描述
/// INPUT:  
/// OUTPUT: 
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).GetAdmTypeDesc("O")
ClassMethod GetAdmTypeDesc(code As %String) As %String
{
	s mRtn=""
	i code="O" s mRtn="门诊"
 	i code="I" s mRtn="住院"
 	i code="E" s mRtn="急诊"
 	
 	Q mRtn
}

/// CTOR:   QP
/// DATE:   2021-08-04
/// DESC:   是否存在,若存在返回ID，否则返回空
/// INPUT:  
/// OUTPUT: 
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).HasId(1,"",5,"E",2)
ClassMethod HasId(TPPParRef As %String, qTPPRowid As %String, qTPPPoisonDR As %String, qTPPEpisodeType As %String, HospId = "")
{
	n (TPPParRef,qTPPRowid,qTPPPoisonDR,qTPPEpisodeType,HospId)
	s RowId=+TPPParRef
	q:'$d(^CT("CPT",RowId,"PHPO")) ""
	
	s Flag=""
	s Child=0
	f  s Child=$o(^CT("CPT",RowId,"PHPO",Child)) q:(Child="")||(Flag'="")  d
	.q:'$d(^CT("CPT",RowId,"PHPO",Child))
	.s TPPPoisonDR=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",1)
 	.s TPPEpisodeType=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",3)
 	.s TPPHospId=$p($g(^CT("CPT",RowId,"PHPO",Child)),"^",5)
 	.s CID=RowId_"||"_Child
 	.q:CID=qTPPRowid
	.q:qTPPPoisonDR'=TPPPoisonDR
	.q:qTPPEpisodeType'=TPPEpisodeType
	.q:TPPHospId'=HospId
	.s Flag=CID
	
	q Flag
}

/// CTOR:   QP
/// DATE:   2021-08-04
/// DESC:   保存级别权限
/// INPUT:  
/// OUTPUT: 0成功、其余失败
/// DEBUG:  w ##class(DHCAnt.KSS.Config.Authority).SaveLevelAuth(TPPParRef,TPPPoisonDR,TPPControlType,EpisodeType,ChkVerify,HospId)
ClassMethod SaveLevelAuth(TPPParRef As %String, TPPPoisonDR As %String, TPPControlType As %String, EpisodeType As %String, ChkVerify As %String, HospId As %String = "", OperateUser = "")
{
	s HasId=..HasId(TPPParRef,"",TPPPoisonDR,EpisodeType,HospId)
	s ^QP("SaveLevelAuth")=$LB(TPPParRef,TPPPoisonDR,TPPControlType,EpisodeType,ChkVerify,HospId,HasId)
	i HasId="" {
		s mRtn=..AddDHCCarPrvTpPHPoison(TPPParRef,TPPPoisonDR,TPPControlType,EpisodeType,ChkVerify,HospId,OperateUser)
	} else {
		s mRtn=..UpdateDHCCarPrvTpPHPoison(HasId, TPPPoisonDR, TPPControlType, EpisodeType, ChkVerify, HospId,OperateUser)
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-08-24
/// DESC: 导出
/// IN  : 
/// OUT : 
/// TABL: 
/// INDE: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Authority","Export","","","Other","","","","","","","","","","","","","^^^")
Query Export(isCkecked, locId, docLevel, docId, docNum, admType, poisonId, isKSSAuthority, isVerifyAuthority, InHosp, IsItem) As %Library.Query(ROWSPEC = "CTCPTDesc:%String:医护级别,ctDocDesc:%String:医生,tppEpisodeType:%String:就诊类型,phcpoDesc:%String:抗菌药物级别,tppControlTypeDesc:%String:允许类型,isKssAut:%String:是否维医生权限,tppChkVerify:%String:有无审核权限,DateFrom:%String:开始日期,DateTo:%String:截止日期,hospDesc:%String:院区")
{
}

ClassMethod ExportExecute(ByRef qHandle As %Library.Binary, isCkecked = "", locId = "", docLevel = "", docId = "", docNum = "", admType = "", poisonId = "", isKSSAuthority = "", isVerifyAuthority = "", InHosp = "", IsItem = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rsy=##class(%Library.ResultSet).%New("DHCAnt.KSS.Config.Authority:QryKSSAuthority")
	d rsy.Execute(isCkecked, locId , docLevel , docId , docNum , admType, poisonId , isKSSAuthority , isVerifyAuthority, InHosp , IsItem)
	if rsy.QueryIsValid() {
		s seqno=0
		s columns=rsy.GetColumnCount()
		while rsy.Next() {
			s (TPPCode,TPPDesc,TEndDate,TPPCreateDepartment,TPPStartUser,TPPBudget,TPPState,PPSUpdateReason,ArchivesFilesNo,PlanNamenow,ApplicationUnitnow,CPRCApproveDate,EthicsMeetDate,EMADate,PPAccount,TEthicsMeetAduitDate,CPRCApproveResult,TApproveResult,TPPStartDate)=""
			for i=1:1:columns {
				s colName = rsy.GetColumnHeader(i)
				i colName="CTCPTDesc" s CTCPTDesc=rsy.GetData(i)
				i colName="ctDocDesc" s ctDocDesc=rsy.GetData(i)
				i colName="tppEpisodeType" {
					s tppEpisodeType= $CASE(rsy.GetData(i),
						"I":"住院",
						"O":"门诊",
						"E":"急诊",
						:""
					)
				}
				i colName="phcpoDesc" s phcpoDesc=rsy.GetData(i)
				i colName="tppControlTypeDesc" s tppControlTypeDesc=rsy.GetData(i)
				i colName="isKssAut" {
					s isKssAut= $CASE(rsy.GetData(i),
						"1":"是",
						"0":"否",
						:""
					)
				}
				//i colName="docAut" s docAut=rsy.GetData(i)
				i colName="tppChkVerify" {
					s tppChkVerify= $CASE(rsy.GetData(i),
						"1":"有",
						"0":"无",
						:""
					)
					
				}
				i colName="DateFrom" s DateFrom=rsy.GetData(i)
				i colName="DateTo" s DateTo=rsy.GetData(i)
				i colName="hospDesc" s hospDesc=rsy.GetData(i)
			}
			s seqno=seqno+1
			s OutputList=$lb(CTCPTDesc,ctDocDesc,tppEpisodeType,phcpoDesc,tppControlTypeDesc,isKssAut,tppChkVerify,DateFrom,DateTo,hospDesc)
			d OutputRow1
		}
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow1
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod ExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod ExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}

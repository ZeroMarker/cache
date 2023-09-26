Import SQLUser

Class web.DHCWMRPaadmQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 8;

/// Papmi:病人基本信息表Rowid
/// AdmDate:就诊日期
/// AdmType:就诊类型串 “|”分割  例子：O|E
ClassMethod qryPaadmList(JIndex, Papmi, AdmDate, AdmType)
{
	n (JIndex,Papmi,AdmDate,AdmType)
	s Count=0
	
	q:Papmi="" Count
	
	s:AdmDate["-" AdmDate=$zdh(AdmDate,3)
	s:AdmDate["/" AdmDate=$zdh(AdmDate,4)
	s:AdmDate'="" AdmDate=+AdmDate
	
	k ^CacheTemp("WMRPaadmList",JIndex)
	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	q:'$d(^PAPERdr(Papmi,"ADM")) Count
	s tmpAdmType=""
	f  s tmpAdmType=$o(^PAPERdr(Papmi,"ADM",tmpAdmType)) q:tmpAdmType=""  d
	.q:((AdmType'="")&&(AdmType'[tmpAdmType))
	.s Paadm=0
	.f  s Paadm=$o(^PAPERdr(Papmi,"ADM",tmpAdmType,Paadm)) q:Paadm=""  d
	..s tmp=$g(^PAADM(+Paadm))
	..q:tmp=""
	..s tmpAdmDate=$p(tmp,"^",6)
	..q:((AdmDate'="")&&(AdmDate'=tmpAdmDate))
	..s ^CacheTemp("WMRPaadmList",JIndex,Paadm)=""
	..s Count=Count+1
	
	q Count
}

ClassMethod QryAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdmListExecute(ByRef qHandle As %Binary, Papmi As %String, AdmDate As %String, AdmType As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s JIndex=$j
	s ret=..qryPaadmList(JIndex,Papmi,"",AdmType)
	q:+ret<1 $$$OK
	
	s Paadm=""
	f  s Paadm=$o(^CacheTemp("WMRPaadmList",JIndex,Paadm),-1) q:+Paadm=0  d
	.s ret=$$xBuildPaadm(Paadm,Papmi)
	.q:+ret<0
	.s ind=ind+1
	
	k:Paadm="" ^CacheTemp("WMRPaadmList",JIndex)
	Quit $$$OK
	
xBuildPaadm(Paadm,Papmi)
	s (AdmNo,AdmDate,AdmTime,AdmLoc,AdmLocDesc,AdmDoc,AdmDocDesc,VisitStatus,AdmType)=""
	s tmp=$g(^PAADM(Paadm))
	q:tmp="" -1
	s AdmNo=$p(tmp,"^",81)
	s AdmDate=$zd(+$p(tmp,"^",6),3)
	s AdmTime=$zt(+$p(tmp,"^",7),2)
	s AdmLoc=$p(tmp,"^",4),AdmLocDesc=""
	s:AdmLoc'="" AdmLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
	s AdmType=$p(tmp,"^",2)
	i AdmType="I" d
	.s AdmDoc=$p(tmp,"^",9),AdmDocDesc=""
	.s:AdmDoc'="" AdmDocDesc=$p($g(^CTPCP(+AdmDoc)),"^",2)
	e  d
    .s xPaadm=" "_Paadm
    .s RegRowid=$o(^User.DHCRegistrationFeeI("ADM",xPaadm,0))
    .q:RegRowid=""
    .s xtmp=$g(^User.DHCRegistrationFeeD(RegRowid))
    .q:xtmp=""
    .s AdmDoc=$list(xtmp,14)
    .s:AdmDoc'="" AdmDocDesc=$p($g(^CTPCP(+AdmDoc,1)),"^",2)
	s VisitStatus=$p(tmp,"^",20)
	s AdmType=$p(tmp,"^",2)
	
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s VolId="",MainId=""
	i $d(^DHCWMRVOL(0,"VolAdm",Paadm)) d
	.s tmpVolId="",tmpMainId="",Active=0
	.f  s tmpVolId=$o(^DHCWMRVOL(0,"VolAdm",Paadm,tmpVolId),-1) q:(+tmpVolId=0)||(Active=1)  d
	..;^DHCWMRVOL({DHC_WMR_MainVolume.Rowid})
	..s tmpVol=$g(^DHCWMRVOL(tmpVolId))
	..q:tmpVol=""
	..s tmpPaadm=$p(tmpVol,"^",2)
	..q:tmpPaadm'=Paadm
	..s tmpVolActive=$p(tmpVol,"^",7)
	..q:tmpVolActive'="Y"
	..s tmpMainId=$p(tmpVol,"^",1)
	..s tmpMain=$g(^DHCWMRMAIN(+tmpMainId))
	..q:tmpMain=""
	..s tmpMainActive=$p(tmpMain,"^",6)
	..q:tmpMainActive'="Y"
	..s tmpPapmi=$p(tmpMain,"^",3)
	..q:tmpPapmi'=Papmi
	..s Active=1
	..s VolId=tmpVolId
	..s MainId=tmpMainId
    set Data=$lb(Paadm,AdmNo,AdmDate,AdmTime,AdmLoc,AdmLocDesc,AdmDoc,AdmDocDesc,VisitStatus,AdmType,MainId,VolId)
 	Set ^CacheTemp(repid,ind)=Data
    q 0
}

ClassMethod QryAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmListExecute ]
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

/// add by zf 2008-03-30
/// Papmi:病人基本信息表Rowid
/// AdmDate:就诊日期
/// AdmType:就诊类型串 “|”分割  例子:O|E
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRPaadmQry","QryAdmList","73","2008-05-06","O|E")
Query QryAdmList(Papmi As %String, AdmDate As %String, AdmType As %String) As %Query(ROWSPEC = "Paadm:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,AdmLoc:%String,AdmLocDesc:%String,AdmDoc:%String,AdmDocDesc:%String,VisitStatus:%String,AdmType:%String,MainId:%String,VolId:%String")
{
}

}

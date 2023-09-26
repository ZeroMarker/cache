Import Sqluser

Class web.DHCSSDOCGROUPCONFIG Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 取科室医生集
/// RB_Resource ; DHC_TransferDoc
ClassMethod QueryDoctorListExecute(ByRef qHandle As %Binary, doccode) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s:doccode'="" doccode=$$ALPHAUP^SSUTIL4(doccode)
    s ctpcpcode=""
    f  s ctpcpcode=$o(^CTPCP(0,"Code",ctpcpcode)) q:ctpcpcode=""  d
    .s ctpcpcode=$$ALPHAUP^SSUTIL4(ctpcpcode)
    .s ctpcp=""
    .f  s ctpcp=$o(^CTPCP(0,"Code",ctpcpcode,ctpcp)) q:ctpcp=""  d
    ..s ctpcttypeId=$P($G(^CTPCP(ctpcp,1)),"^",4)
    ..q:ctpcttypeId=""
	..s ctpcptype=$P($G(^CT("CPT",ctpcttypeId)),"^",4)
	..q:ctpcptype'="DOCTOR"
    ..s cede=$p(^CTPCP(ctpcp,1),"^",1)
    ..q:(doccode'="")&($$ALPHAUP^SSUTIL4(cede)'=doccode)
    ..s desc=$p(^CTPCP(ctpcp,1),"^",2)
    ..s existflag="N"
    ..i $d(^DHCTRDOCi(0,"CTPCP",ctpcp)) d
    ...s existflag="Y"
    ..d OutRowDoc
	Quit $$$OK
OutRowDoc
	set Data=$lb(cede,desc,ctpcp,existflag)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryDoctorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDoctorListExecute ]
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

Query QueryDoctorList(doccode) As %Query(ROWSPEC = "Tdoctoccode:%String,Tdoctoc:%String,Trowid:%String,Tyes:%String")
{
}

ClassMethod QueryDoctorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDoctorListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 取安全组集
/// ss_group 
ClassMethod QueryGroupListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s ssgrp=0
    f  s ssgrp=$o(^SSU("SSGRP",ssgrp)) q:ssgrp=""  d
    .s grpname=$p(^SSU("SSGRP",ssgrp),"^",1)
    .s rowid=ssgrp
    .d OutRowGroup
	Quit $$$OK
OutRowGroup
	set Data=$lb(grpname,rowid)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGroupListExecute ]
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

Query QueryGroupList() As %Query(ROWSPEC = "Tgroup:%String,Trowid:%String")
{
}

ClassMethod QueryGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 取安全组已授权集
/// DHC_SSDocGroup 
ClassMethod QueryGroupItmListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s dhcsdr=0
    f  s dhcsdr=$o(^DHCSDGRP(dhcsdr)) q:dhcsdr=""  d
    .s ssgrp=$p(^DHCSDGRP(dhcsdr),"^",1)
    .q:'$d(^SSU("SSGRP",ssgrp))
    .s grpname=$p(^SSU("SSGRP",ssgrp),"^",1)
    .s rowid=dhcsdr
    .d OutRowGroupItm
	Quit $$$OK
OutRowGroupItm
	set Data=$lb(grpname,rowid)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryGroupItmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryGroupItmListExecute ]
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

Query QueryGroupItmList() As %Query(ROWSPEC = "Tgroup:%String,Trowid:%String")
{
}

ClassMethod QueryGroupItmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryGroupItmListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 增加轮转医生安全组
ClassMethod AddSSDocGrp(grpid) As %String
{
	n (grpid)
	s exit=0
	s dhcsdr=""
	f  s dhcsdr=$o(^DHCSDGRP(dhcsdr)) q:(dhcsdr="")||(exit=1)  d
    .s ssgrp=$p(^DHCSDGRP(dhcsdr),"^",1)
    .i ssgrp= grpid d
    ..s exit=1
    q:exit=1 -2
	&sql(insert into DHC_SSDocGroup (DHCSD_Group_Dr) values (:grpid))
	Q:SQLCODE -1
	Q 0
}

/// 删除轮转医生安全组
ClassMethod DelSSDocGrp(rowid) As %String
{
	n (rowid)
	&sql(delete from DHC_SSDocGroup where  DHCSD_Rowid=:rowid)
	Q:SQLCODE -1
	Q 0
}

/// 增加轮转医生标记
ClassMethod AddSSDoc(ctpcp) As %String
{
	n (ctpcp)
	q:ctpcp="" -2
	&sql(insert into DHC_TransferDoc ( DHCTRD_CTPCP_Dr) values (:ctpcp))
	Q:SQLCODE -1
	Q 0
}

/// 删除轮转医生标记
ClassMethod DelSSDoc(ctpcp) As %String
{
	n (ctpcp)
	&sql(delete from  DHC_TransferDoc where DHCTRD_CTPCP_Dr=:ctpcp)
	Q:SQLCODE -1
	Q 0
}

/// 取轮转医生集
/// DHC_TransferDoc 
ClassMethod QuerySSTDocListExecute(ByRef qHandle As %Binary, doccode, docname, HospID = "") As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s ind=1
    Set langid=..%LanguageID()
    s:doccode'="" doccode=$$ALPHAUP^SSUTIL4(doccode)
    s:docname'="" docname=$$ALPHAUP^SSUTIL4(docname)
    s sscode="",ssname=""
    //20170828轮转医生集取 医护人员类型轮转标志
    s CTPCPRowId=""
    f   s CTPCPRowId=$o(^CTPCP(CTPCPRowId)) q:CTPCPRowId=""  d
    .q:'$d(^CTPCP(CTPCPRowId,1))
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",CTPCPRowId,HospID)="N"
    .s CTPCPActiveFlag=$p(^CTPCP(CTPCPRowId,1),"^",9)
    .q:CTPCPActiveFlag="N"
    .s CTPCPDateActiveFrom=$p(^CTPCP(CTPCPRowId,2),"^",14)
    .q:(CTPCPDateActiveFrom'="")&&(CTPCPDateActiveFrom>+$h)
    .s CTPCPDateActiveTo=$p(^CTPCP(CTPCPRowId,2),"^",15)
    .q:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<+$h)
    .s CTPCPCarPrvTpDR=$p(^CTPCP(CTPCPRowId,1),"^",4)
    .q:CTPCPCarPrvTpDR="" 
    .s CTCPTRotaryFlag=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",8)
    .q:CTCPTRotaryFlag'="Y"
    .s sscode=$p(^CTPCP(CTPCPRowId,1),"^",1)
    .q:(doccode'="")&($$ALPHAUP^SSUTIL4(sscode)'=doccode)
    .s ssname=$p(^CTPCP(CTPCPRowId,1),"^",2)
    .Set ssname= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ssname,langid)
    .q:(docname'="")&($$ALPHAUP^SSUTIL4(ssname)'[docname)
    .s ctpcp=CTPCPRowId
    .d OutRowTD
    /*s ctpcp=""
    f  s ctpcp=$o(^DHCTRDOCi(0,"CTPCP",ctpcp) ) q:ctpcp=""  d
    .s transdoc=""
    .//^DHCTRDOCi User.DHCTransferDoc
    .f  s transdoc=$o(^DHCTRDOCi(0,"CTPCP",ctpcp,transdoc) ) q:transdoc=""  d
    ..q:'$d(^CTPCP(ctpcp,1))
    ..s sscode=$p(^CTPCP(ctpcp,1),"^",1)
    ..q:(doccode'="")&(sscode'=doccode)
    ..s ^DHCTEMPZLJ=ctpcp
    ..s ssname=$p(^CTPCP(ctpcp,1),"^",2)
    ..q:(docname'="")&(ssname'[docname)
    ..d OutRowTD*/
	Quit $$$OK
OutRowTD
	set Data=$lb(sscode,ssname,ctpcp)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QuerySSTDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSTDocListExecute ]
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

Query QuerySSTDocList(doccode, docname, HospID = "") As %Query(ROWSPEC = "Tdoccode:%String,Tdocname:%String,Tctpcp:%String")
{
}

ClassMethod QuerySSTDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSTDocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 取医护人员对应的轮转标志

ClassMethod GetCareRotaryFlag(ctpcpdr As %String) As %String
{
	s CTPCPCarPrvTpDR=$p(^CTPCP(ctpcpdr,1),"^",4)
	q:CTPCPCarPrvTpDR="" ""
	s CTCPTRotaryFlag=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",8)
	q CTCPTRotaryFlag
}

/// 取本科轮转医生授权配置
/// DHC_TransferDoc 
ClassMethod QuerySSTDocConfigExecute(ByRef qHandle As %Binary, loc) As %Status
{
	i loc="" s loc=%session.Get("LOGON.CTLOCID")
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s LogonHospId=%session.Get("LOGON.HOSPID")
    Set langid=..%LanguageID()
    s ind=1
    s sscode="",ssname="",ssgroup="",ssgrpdr="",ssdocgrpdr=""
    q:loc="" $$$OK
    s i=0
    s resrowid=""
    f  s resrowid=$o(^RB("RES",0,"CTLOC",loc,resrowid)) q:resrowid=""  d
    .s ctpcp=$p(^RB("RES",resrowid),"^",2)
    .s ActiveTo=$p(^RB("RES",resrowid),"^",19)
    .q:(ActiveTo<+$h)&(ActiveTo'="")
    .q:ctpcp=""
    .//q:'$d(^DHCTRDOCi(0,"CTPCP",ctpcp))
    .s CareRotaryFlag=..GetCareRotaryFlag(ctpcp)
    .q:CareRotaryFlag'="Y"
    .s CTCPTypeId=$P($G(^CTPCP(ctpcp,1)),"^",4)
    .q:CTCPTypeId=""
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.q:CTCPType'="DOCTOR"
	.s RESRowId=$o(^RB("RES",0,"CTPCP",ctpcp,loc,""))
	.q:RESRowId=""
	.s RESDateActiveTo=$p($g(^RB("RES",RESRowId)),"^",23)
	.q:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h)
	.s RESDateActiveTo=..%ZD(RESDateActiveTo)
	.s RESDateActiveFrom=$p($g(^RB("RES",RESRowId)),"^",22)
	.s RESDateActiveFrom=..%ZD(RESDateActiveFrom)
    .s cede=$p(^CTPCP(ctpcp,1),"^",1)
    .s sscode=$P((^CTPCP(ctpcp,1)),"^",1)
    .s ssname=$P((^CTPCP(ctpcp,1)),"^",2)
    .Set ssname= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ssname,langid)
    .s ssuser=$o(^SSU("SSUSR",0,"CTPCP",ctpcp,""))
    .q:ssuser=""
    .s ssname=$p(^SSU("SSUSR",ssuser),"^",2)
    . s ssname =##class(User.SSUser).GetTranByDesc("SSUSRName",ssname,langid)
    .s ssgroup=""
    .s ssgrpdr=$p(^SSU("SSUSR",ssuser),"^",5)
    .i ssgrpdr'="" d
    ..i $d(^SSU("SSGRP",ssgrpdr)) d
    ...s ssgroup=$p(^SSU("SSGRP",ssgrpdr),"^",1)
    .s medunitstr=##class(web.DHCCTLocMedUnit).getMedUnit(loc,ctpcp)
    .s ssdocgrp=$p(medunitstr,"^",2)
    .s ssdocgrpdr=$p(medunitstr,"^",1)
    .s locdesc=$p(^CTLOC(loc),"^",2)
    .s locdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locdesc,langid)
    .s CTLocHospDr=$p(^CTLOC(loc),"^",22)
	.q:(LogonHospId'="")&&(CTLocHospDr'=LogonHospId)
	.s UserDefRBDepartmentDR=$p(^SSU("SSUSR",ssuser),"^",4)
	.i UserDefRBDepartmentDR=loc s default="是"
    .e  s default="否"
    .s rowid=""
    .i default="是" s rowid=ssuser_"||"_loc
    .e  d
    ..s othsub=0
    ..f  s othsub=$o(^SSU("SSUSR",ssuser,"OTHLL",othsub)) q:+othsub=0  d
    ...s othloc=$p(^SSU("SSUSR",ssuser,"OTHLL",othsub),"^",1)
    ...q:othloc'=loc
    ...s ssgrpdr=$p(^SSU("SSUSR",ssuser,"OTHLL",othsub),"^",2)
    ...i ssgrpdr'="" s ssgroup=$p(^SSU("SSGRP",ssgrpdr),"^",1)
    ...s rowid=ssuser_"||"_othsub
    .q:rowid="" 
    .s SSDocGoupID=""
    .s SSDocGoupID=$O(^DHCDocSSGroupConfig("RBResouce",RESRowId,""),-1)
    .s DateOutLoc=""
    .i SSDocGoupID'="" d
    ..s DateOutLoc=$P(^DHCDocSSGroupConfig(SSDocGoupID),"^",5)
    ..;i DateOutLoc'="" s DateOutLoc=..%ZD(DateOutLoc)
    ..i DateOutLoc'="" s RESDateActiveTo=..%ZD(DateOutLoc)
    .s default=##class(websys.Translation).Get("doc.transdocmanage.hui.csp",default)
    .s i=i+1
    .d OutRowSSTDoc
    /*.s othsub=0
    .f  s othsub=$o(^SSU("SSUSR",ssuser,"OTHLL",othsub)) q:+othsub=0  d
    ..s othloc=$p(^SSU("SSUSR",ssuser,"OTHLL",othsub),"^",1)
    ..//q:othloc'=loc
    ..s ssgroup=""
    ..s ssgrpdr=$p(^SSU("SSUSR",ssuser,"OTHLL",othsub),"^",2)
    ..i ssgrpdr'="" d
    ...i $d(^SSU("SSGRP",ssgrpdr)) d
    ....s ssgroup=$p(^SSU("SSGRP",ssgrpdr),"^",1)
    ..s medunitstr=##class(web.DHCCTLocMedUnit).getMedUnit(othloc,ctpcp)
    ..s ssdocgrp=$p(medunitstr,"^",2)
    ..s ssdocgrpdr=$p(medunitstr,"^",1)
    ..s locdesc=$p(^CTLOC(othloc),"^",2)
    ..s CTLocHospDr=$p(^CTLOC(othloc),"^",22)
	..q:(LogonHospId'="")&&(CTLocHospDr'=LogonHospId)
    ..s default=""
    ..s rowid=ssuser_"||"_othsub
    ..s i=i+1
    ..d OutRowSSTDoc*/
	Quit $$$OK
OutRowSSTDoc
	set Data=$lb(sscode,ssname,ssgroup,ssgrpdr,ssdocgrp,ssdocgrpdr,locdesc,default,rowid,i,RESDateActiveTo,RESDateActiveFrom,SSDocGoupID,DateOutLoc)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QuerySSTDocConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSTDocConfigExecute ]
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

Query QuerySSTDocConfig(loc) As %Query(ROWSPEC = "Tdoccode:%String,Tdocname:%String,Tssgroup:%String,Tssgroupdr:%String,Tdocgroup:%String,Tdocgroupdr:%String,Tlocdesc:%String,Tdefault:%String,Trowid:%String,Trow:%String,DateActiveTo:%String,DateActiveFrom:%String,SSDocGoupID:%String,DateOutLoc:%String ")
{
}

ClassMethod QuerySSTDocConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSTDocConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 取本科医生授权配置
/// RB_Resource
ClassMethod QuerySSDocConfigExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
	s ^temploc=loc
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:loc="" $$$OK
    //s loc="31"
    s resrowid=""
    f  s resrowid=$o(^RB("RES",0,"CTLOC",loc,resrowid)) q:resrowid=""  d
    .s ActiveTo=$p(^RB("RES",resrowid),"^",19)
    .q:(ActiveTo'>+$h)&(ActiveTo'="")
    .s ctpcp=$p(^RB("RES",resrowid),"^",2)
    .q:ctpcp=""
    .//q:$d(^DHCTRDOCi(0,"CTPCP",ctpcp))
    .s CTCPTypeId=$P($G(^CTPCP(ctpcp,1)),"^",4)
    .q:CTCPTypeId=""
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.q:CTCPType'="DOCTOR"
    .s cede=$p(^CTPCP(ctpcp,1),"^",1)
    .s sscode=$P((^CTPCP(ctpcp,1)),"^",1)
    .s ssname=$P((^CTPCP(ctpcp,1)),"^",2)
    .s ssuser=$o(^SSU("SSUSR",0,"CTPCP",ctpcp,""))
    .s ssgroup=""
    .q:ssuser=""
    .s ssgrpdr=$p(^SSU("SSUSR",ssuser),"^",5)
    .i ssgrpdr'="" d
    ..i $d(^SSU("SSGRP",ssgrpdr)) d
    ...s ssgroup=$p(^SSU("SSGRP",ssgrpdr),"^",1)
    .s medunitstr=##class(web.DHCCTLocMedUnit).getMedUnit(loc,ctpcp)
    .s ssdocgrp=$p(medunitstr,"^",2)
    .s ssdocgrpdr=$p(medunitstr,"^",1)
    .d OutRowSSDoc
	Quit $$$OK
OutRowSSDoc
	set Data=$lb(sscode,ssname,ssgroup,ssgrpdr,ssdocgrp,ssdocgrpdr,ssuser)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QuerySSDocConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySSDocConfigExecute ]
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

Query QuerySSDocConfig(loc As %String) As %Query(ROWSPEC = "Tdoccode:%String,Tdocname:%String,Tssgroup:%String,Tssgroupdr:%String,Tdocgroup:%String,Tdocgroupdr:%String,Tssuser:%String")
{
}

ClassMethod QuerySSDocConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySSDocConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 删除轮转医生科室记录
ClassMethod DelTtransDocItm(ctpcp, loc, grpdr) As %String
{
	n (ctpcp,loc,grpdr)
	TSTART
    Set $ZT="trolldel"
	s ret=..UpdRbDateTo(ctpcp,loc)  //结束日期
	i ret'=0 tro
	q:ret'=0 -1
	s ret=..DelOthloc(ctpcp,loc,grpdr) //删除其它科室
	i ret'=0 tro
	q:ret'=0 -2
    TCOMMIT
	q 0

trolldel
   Set $ZT=""
   TRo
   s ErrorMsg=$ZE
   q ErrorMsg
}

/// 增加轮转医生标记
ClassMethod AddTtransDocOtherLogonloc(ssuser, ctlocdr, grpid, medunitdr) As %String
{
	n (ssuser,ctlocdr,grpid,medunitdr)
	q:ssuser="" -1
	q:ctlocdr="" -2
	q:grpid="" -3
	q:medunitdr="" -4
	s hosptialID=$p(^CTLOC(ctlocdr),"^",22)
	q:hosptialID=-5
	s exist=0
	s othll=""
	f  s othll=$o(^SSU("SSUSR",ssuser,"OTHLL",othll)) q:othll=""  d 
	.s othctloc=$p(^SSU("SSUSR",ssuser,"OTHLL",othll),"^",1)
	.s othgrpid=$p(^SSU("SSUSR",ssuser,"OTHLL",othll),"^",2)
	.i (othctloc=ctlocdr)&(othgrpid=grpid) d
	..s exist=1
	..s $p(^SSU("SSUSR",ssuser,"OTHLL",othll),"^",1)=ctlocdr 
	..s $p(^SSU("SSUSR",ssuser,"OTHLL",othll),"^",2)=grpid 
	..s $p(^SSU("SSUSR",ssuser,"OTHLL",othll),"^",3)=hosptialID 
	q:exist=1 0
	k PLIST
	s PLIST(0)=ssuser
	s PLIST(2)=+$o(^SSU("SSUSR",ssuser),-1)+1
	s PLIST(3)=ctlocdr
	s PLIST(4)=grpid
	s PLIST(5)=hosptialID
	&sql(INSERT INTO SS_UserOtherLogonLoc VALUES PLIST())
    q:SQLCODE -6
    q %ROWID
}

/// 返回当前科室
ClassMethod GetCurLoc(id) As %String
{
	n (id)
	q:id="" ""
	q:'$d(^CTLOC(id)) ""
	q $p(^CTLOC(id),"^",2)
}

/// 取医疗单元组集
///  
ClassMethod QueryLocMedUnitExecute(ByRef qHandle As %Binary, loc) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:loc="" $$$OK
    //s loc="31" 
    s CTLocDr=loc                                                  
	s TCTCode=$p(^CTLOC(CTLocDr),"^",1)  
	s CTChildsub=0                               
	f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  q:CTChildsub=""  d  
	.s MURowid=CTLocDr_"||"_CTChildsub
	.s CTMUCode=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",1)                   
	.s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)                   
	.s tmpCTMUActiveFlag=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",3)
	.q:tmpCTMUActiveFlag'="Y"    
    .s DateForm=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",4)
	.q:(DateForm>+$h)&&(DateForm'="") 	
	.s DateTo=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",5)
	.q:(DateTo<=(+$h))&&(DateTo'="")
	.s UnitDr=CTLocDr_"||"_CTChildsub
    .d OutRowLocMedUnit
	Quit $$$OK
OutRowLocMedUnit
	set Data=$lb(CTMUDesc,UnitDr)   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryLocMedUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocMedUnitExecute ]
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

Query QueryLocMedUnit(loc) As %Query(ROWSPEC = "CTMUDesc:%String,UnitDr:%String")
{
}

ClassMethod QueryLocMedUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocMedUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 分配轮转医生至本科室 0成功 <0 失败
ClassMethod SaveTDocItm(ctpcp, currlocdr, currgrpdr, adduser As %String = "") As %String
{
	n (ctpcp,currlocdr,currgrpdr,adduser)
	s ^tempscl("SaveTDocItm")=ctpcp_","_currlocdr_","_currgrpdr
	s ret=0
	s equflag=0
	TSTART
    Set $ZT="troll"
    s schkflag=..ChkSSuserExist(ctpcp) //检查某医护人员是否在用户表存在
    i schkflag=0 d
    .s ssuser=$o( ^SSU("SSUSR",0,"CTPCP",ctpcp,""))
    .s defaultloc=$p(^SSU("SSUSR",ssuser),"^",4)
    .s ssgroup=$p(^SSU("SSUSR",ssuser),"^",5)
    .s hosptialID=$p(^CTLOC(defaultloc),"^",22)
    .i (ssgroup=currgrpdr)&(defaultloc=currlocdr) s equflag=1   
    .q:(ssgroup=currgrpdr)&(defaultloc=currlocdr) 
    .k PLIST
	.s PLIST(0)=ssuser
	.s PLIST(2)=+$o(^SSU("SSUSR",ssuser,"OTHLL",""),-1)+1
	.s PLIST(3)=defaultloc
	.s PLIST(4)=ssgroup
	.s PLIST(5)=hosptialID
	.s PLIST(6)=..%SysDate()
	.&sql(INSERT INTO SS_UserOtherLogonLoc VALUES PLIST())
	.i SQLCODE'=0 s ret=-1
	i ret'=0 tro
	q:ret'=0 -2
	s chkflag1=..ChkRbExist(currlocdr,ctpcp) //检查某医生在某科是否有排班
	s chkflag=..ChkRbExistNew(currlocdr,ctpcp)
	if (chkflag=1){
		s CurDate=..%SysDate()
		//资源排班,默认安全组,科室相同,则更新资源表开始日期 结束日期 激活标志
		&sql(update RB_Resource set RES_Active='Y',RES_AdmittingRights="Y",RES_IgnorePubHol="Y",RES_DateActiveFrom=:CurDate,RES_DateActiveTo=null,Res_DateTo=null where  RES_CTLOC_DR=:currlocdr and RES_CTPCP_DR=:ctpcp)
		i SQLCODE'=0 s ret=-3
		i ret'=0 {
			tro
			q ret
		}
	}
	//资源排班,默认安全组,科室相同则退出
	if (equflag=1)&(chkflag=1){
		if (chkflag1=1){
		    TCOMMIT
		    q "该医生已加入轮转列表!"
		}
		TCOMMIT  
		q 0   
	}
    s ret=..SaveSSuserData(ctpcp, currlocdr, currgrpdr, schkflag)  //保存用户表
    i ret'=0 tro
    q:ret'=0 -3
    if (chkflag=0){
	    s ret=..SaveRbData(currlocdr,ctpcp) //保存资源表
	    i ret'=0 tro
	    q:ret'=0 -4
    }
    s RBRowid=$O(^RB("RES",0,"CTPCP",ctpcp,currlocdr,""),-1)
    //轮转医生记录表
    k PLIST
	s PLIST(2)=ssuser
	s PLIST(3)=currlocdr
	s PLIST(4)=currgrpdr
	s PLIST(5)=..%SysDate()
	s PLIST(7)=adduser 
	s PLIST(8)=..%SysDate() 
	s PLIST(9)=..%SysTime() 
	s PLIST(13)=RBRowid
	&sql(INSERT INTO DHC_DocSSGroupConfig VALUES PLIST())
    if (chkflag1=1){
	    TCOMMIT
	    q "该医生已加入轮转列表!"
	}
    TCOMMIT
	q 0

troll
   Set $ZT=""
   TRo
   s ErrorMsg=$ZE
   q ErrorMsg
}

/// 检查医护人员在资源表中是否存在，不管记录是否有效或者记录是否已经截止
/// 0不存在 1存在
ClassMethod ChkRbExistNew(loc, ctpcp) As %String
{
  n (loc,ctpcp)
  q:loc="" 0
  q:ctpcp="" 0
  s exist=0
  s resrowid=""
  f  s resrowid=$o(^RB("RES",0,"CTLOC",loc,resrowid),-1) q:(resrowid="")||(exist=1)  d
  .s rectpcp=$p(^RB("RES",resrowid),"^",2)
  .//s ActiveFrom=$p(^RB("RES",resrowid),"^",22)
  .//s ActiveTo=$p(^RB("RES",resrowid),"^",19)
  .//i (ctpcp=rectpcp)&((ActiveTo="")||(ActiveTo>+$h)) d
  .i (ctpcp=rectpcp) d
  ..s exist=1
  q exist
}

/// 保存新安全组 0成功 <0 失败
ClassMethod SaveNewGrp(ssuser, newgrpdr) As %String
{
	n (ssuser,newgrpdr)
	s grpdr=$p(^DHCSDGRP(newgrpdr),"^",1)
	q:grpdr="" -1
	&sql(update SS_User set  SSUSR_Group=:grpdr where  SSUSR_RowId=:ssuser )
    q:SQLCODE'=0 -2
	q 0
}

/// 保存新医生组 0成功 <0 失败  
ClassMethod SaveNewDocGrp(ssuser, MedUnit) As %String
{
	n (ssuser,MedUnit)
	s ctpcp=$p(^SSU("SSUSR",ssuser),"^",14)
	q:ctpcp="" -1
	s DepID=$p(MedUnit,"||",1)
	s NewMURowid=$p(MedUnit,"||",2)
	s exist=0,ret=0
	s MUCPDateTo=..%SysDate()-1
	s equflag=0
	s MURowid=""
	f  s MURowid=$o(^CTLOC(DepID,"MU",MURowid))  q:(MURowid="")||(exist=1)  d
	.s MUCRowid=0
	.f  s MUCRowid=$o(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid))  q:(+MUCRowid=0)||(exist=1)  d
	..s MUCDocDr=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",1)
	..s DateFrom=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",5)
	..q:+DateFrom'>0
	..q:+DateFrom>+$H
	..s DateTo=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",6)
	..q:(DateTo<+$h)&(DateTo'="")
	..i ctpcp=MUCDocDr d
	...i MURowid'=NewMURowid d
	....s exist=1
	....s MPMUCPRowid=DepID_"||"_MURowid_"||"_MUCRowid
	....&sql(Update DHC_CTLoc_MedUnitCareProv set MUCP_DateTo=:MUCPDateTo where MUCP_RowId=:MPMUCPRowid)
	....i SQLCODE'=0 d
	.....s ret=-1
	...e  d
	....s equflag=1
	...
	..
	q:equflag=1 0  //新旧一样,不执行
	q:(exist=1)&(ret'=0) -2
	s RESCTPCPDR=ctpcp
	s MUCPLeaderFlag="N"
	s MUCPDateFrom=$zd(+$h,4)
	s MUCPDateTo=""
	s MUCPOPFlag="N"
	s MUCPIPFlag="N"
	s MURowid=MedUnit
	s InString=RESCTPCPDR_"^"_MUCPLeaderFlag_"^"_MUCPDateFrom_"^"_MUCPDateTo_"^"_MUCPOPFlag_"^"_MUCPIPFlag_"^"_MURowid
	s ret=##class(web.DHCCTLocMedUnitCareProv).Insert(InString)
	q:+ret'>0 -3
	q 0
}

/// 保存新安全组 0成功 <0 失败
ClassMethod SaveNewTDGrp(defaultfalg, str, newgrpdr) As %String
{
	n (defaultfalg,str,newgrpdr)
	s ssuser=$p(str,"||",1)
	s rowid=$p(str,"||",2)
	s ret=0
	i defaultfalg=1 d
	.s ret=..SaveNewGrp(ssuser,newgrpdr)
	e  d
	.s ret=..SaveNewOthGrp(str,newgrpdr)
	q:ret'=0 -1
	q
}

/// 保存新医生组
ClassMethod SaveNewTDDocGrp(str, MedUnit) As %String
{
	n (str,MedUnit)
	s ssuser=$p(str,"||",1)
    s ret=..SaveNewDocGrp(ssuser,MedUnit)
	q:ret'=0 -1
	q 0
}

/// 保存新其它科室安全组 0成功 <0 失败
ClassMethod SaveNewOthGrp(rowid, newgrpdr) As %String
{
	n (rowid,newgrpdr)
	s grpdr=$p(^DHCSDGRP(newgrpdr),"^",1)
	q:grpdr="" -1
	&sql(update SS_UserOtherLogonLoc set OTHLL_UserGroup_DR=:grpdr where OTHLL_RowId=:rowid )
	q:SQLCODE'=0 -2
	q 0
}

/// 检查某医生在某科是否有排班
/// 0不存在 1存在
ClassMethod ChkRbExist(loc, ctpcp) As %String
{
  n (loc,ctpcp)
  q:loc="" 0
  q:ctpcp="" 0
  s exist=0
  s resrowid=""
  f  s resrowid=$o(^RB("RES",0,"CTLOC",loc,resrowid),-1) q:(resrowid="")||(exist=1)  d
  .s rectpcp=$p(^RB("RES",resrowid),"^",2)
  .s ActiveFrom=$p(^RB("RES",resrowid),"^",22)
  .s ActiveTo=$p(^RB("RES",resrowid),"^",23)
  .i (ctpcp=rectpcp)&((ActiveTo="")||(ActiveTo>+$h)) d
  ..s exist=1
  q exist
}

/// 更新医护人员科室资源截止日期
/// 0成功 -1 失败
ClassMethod UpdRbDateTo(ctpcp, loc) As %String
{
  n (ctpcp,loc)
  q:loc="" -1
  q:ctpcp="" -1
  s exit=0
  s ret=0
  s resrowid=""
  f  s resrowid=$o(^RB("RES",0,"CTPCP",ctpcp,loc,resrowid),-1) q:(resrowid="")||(exit'=0)  d
  .s ActiveTo=$p(^RB("RES",resrowid),"^",19)
  .s DateTo=..%SysDate()-1
  .i ((ActiveTo="")||(ActiveTo>+$h)) d
  ..s exit=1
  ..s Nflag="N"
  ..&sql(update RB_Resource set RES_DateTo=:DateTo,RES_DateActiveTo=:DateTo,RES_AdmittingRights=:Nflag,RES_IgnorePubHol=:Nflag  where RES_RowId=:resrowid )
  ..i SQLCODE'=0 d
  ...s ret=-1
  .
  q ret
}

/// 检查某医护人员是否在用户表存在
/// -1 无数据 0 存在
ClassMethod ChkSSuserExist(ctpcp) As %String
{
	n (ctpcp)
	s ssuser=$o(^SSU("SSUSR",0,"CTPCP",ctpcp,""))
    q:ssuser="" -1
    q 0
}

/// 插入或更新用户表数据
/// flag 0 update  -1 insert
/// -1 失败  0 成功
ClassMethod SaveSSuserData(ctpcp, ctloc, grpdr, flag) As %String
{
	n (ctpcp,ctloc,grpdr,flag)
	s ret=0
	i flag=-1 d
	.s Code=$p(^CTPCP(ctpcp,1),"^",1)
	.s Desc=$p(^CTPCP(ctpcp,1),"^",2)
	.s CtLocId=ctloc
	.s UserGroupDr=grpdr
	.s CareProvId=ctpcp
	.s LanguageId=$o(^SS("LAN",""),-1)
	.K PLIST
	.s PLIST(2)=Code,PLIST(3)=Desc,PLIST(7)=CtLocId,PLIST(13)=UserGroupDr,PLIST(18)=$g(CareProvId)
	.s PLIST(4)="U&dDF1,""7k7k",PLIST(9)="Y",PLIST(17)=LanguageId,PLIST(19)="U&dDF1,""7k7k",PLIST(23)="Y",PLIST(103)=$h-1 
	.s PLIST(72)="N"
	.i $g(CareProvId)'="" s PLIST(19)=Code
	.&sql(INSERT INTO SQLUser.SS_User VALUES :PLIST())
	.i SQLCODE'=0 s ret=-1
	q:ret'=0 ret
	i flag=0 d
	.s ssuser=$o( ^SSU("SSUSR",0,"CTPCP",ctpcp,""))
	.i ssuser="" s ret=-2
	.q:ssuser=""
	.s hosptialID=$p(^CTLOC(ctloc),"^",22)
	.s datefrom=..%SysDate()
    .&sql(update SS_User set SSUSR_DateFrom=:datefrom, SSUSR_DateTo=null, SSUSR_DefaultDept_DR=:ctloc , SSUSR_Group=:grpdr,SSUSR_Hospital_DR=:hosptialID where  SSUSR_RowId=:ssuser )
    .i SQLCODE'=0 s ret=-3
	q ret
}

/// 维护医护人员资源
ClassMethod SaveRbData(CtLocId, CareProvId) As %String
{
	n (CtLocId,CareProvId)
	s Code=$p(^CTPCP(CareProvId,1),"^",1)
	s Desc=$p(^CTPCP(CareProvId,1),"^",2)
	k PLIST
	s PLIST(3)=CtLocId,PLIST(4)=CareProvId,PLIST(7)=Code,PLIST(8)=Desc,PLIST(11)=-1,PLIST(16)=999,PLIST(35)=..%SysDate()
	s PLIST(19)="Care Provider",PLIST(20)="Y",PLIST(21)="Y",PLIST(33)="Y"
	&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	q:SQLCODE'=0 -2
	q 0
}

/// 删除轮转医生其它科室记录
ClassMethod DelOthloc(ctpcp, loc, grpdr) As %String
{
	n (ctpcp,loc,grpdr)
	s ret=0
	s ssuser=$o( ^SSU("SSUSR",0,"CTPCP",ctpcp,""))
	s chl=""
	f  s chl=$o(^SSU("SSUSR",ssuser,"OTHLL",chl)) q:chl=""  d
	.s othloc=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",1)
	.s othgrp=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",2)
	.i (loc=othloc)&(grpdr=othgrp) d
	..s rowid=ssuser_"||"_chl
	..&sql(delete from  SS_UserOtherLogonLoc where  OTHLL_RowId=:rowid )
	..i SQLCODE'=0 s ret=-1
	q ret
}

/// 保存新安全组 0成功 <0 失败
ClassMethod DelTDItm(defaultfalg, str) As %String
{
	n (defaultfalg,str)
	s ^Tempscl("DelTDItm")=defaultfalg_","_str
	s ssuser=$p(str,"||",1)
	s rowid=$p(str,"||",2)
	s ret=0
	Q:('$d(^SSU("SSUSR",ssuser))) ret
	i defaultfalg=1 d
	.s ctpcp=$p(^SSU("SSUSR",ssuser),"^",14)
	.s loc=$p(^SSU("SSUSR",ssuser),"^",4)
    .s grpdr=$p(^SSU("SSUSR",ssuser),"^",5)
	e  d
	.s ctpcp=$p(^SSU("SSUSR",ssuser),"^",14)
	.q:'$d(^SSU("SSUSR",ssuser,"OTHLL",rowid))
	.s loc=$p(^SSU("SSUSR",ssuser,"OTHLL",rowid),"^",1)
	.q:loc=""
	.s grpdr=$p(^SSU("SSUSR",ssuser,"OTHLL",rowid),"^",2)
	s ret=..DelTtransDocItm(ctpcp,loc,grpdr)
	q:ret'=0 -1
	if (defaultfalg=1){
		//如果出科的是默认登录科室，则修改用户表的默认登录科室和安全组
		s OTHLLChildsub=$o(^SSU("SSUSR",ssuser,"OTHLL",""),-1)
		if (OTHLLChildsub'=""){
			s lastlocid=$p($g(^SSU("SSUSR",ssuser,"OTHLL",OTHLLChildsub)),"^",1)
			s lasGroupDR=$p($g(^SSU("SSUSR",ssuser,"OTHLL",OTHLLChildsub)),"^",2)
			if (lastlocid'="")&&(lasGroupDR'=""){
				s OTHLLRowId=ssuser_"||"_OTHLLChildsub
				&sql(delete SS_UserOtherLogonLoc where OTHLL_RowId=:OTHLLRowId)
				if (SQLCODE=0){
					s hosptialID=$p(^CTLOC(lastlocid),"^",22)
				    s datefrom=..%SysDate()
			        &sql(update SS_User set SSUSR_DateFrom=:datefrom, SSUSR_DateTo=null, SSUSR_DefaultDept_DR=:lastlocid , SSUSR_Group=:lasGroupDR,SSUSR_Hospital_DR=:hosptialID where  SSUSR_RowId=:ssuser )
				    q:SQLCODE'=0 -1
				}else{
					q -1
				}
			}
		}
	}
	q 0
}

/// 批量定义全部医生为轮转医生
ClassMethod UpdAllCTPCP() As %String
{
	
	s ctpcpcode=""
    f  s ctpcpcode=$o(^CTPCP(0,"Code",ctpcpcode)) q:ctpcpcode=""  d
    .s ctpcp=""
    .f  s ctpcp=$o(^CTPCP(0,"Code",ctpcpcode,ctpcp)) q:ctpcp=""  d
    ..s ctpcttypeId=$P($G(^CTPCP(ctpcp,1)),"^",4)
    ..q:ctpcttypeId=""
	..s ctpcptype=$P($G(^CT("CPT",ctpcttypeId)),"^",4)
	..q:ctpcptype'="DOCTOR"
	..s ctpcpdesc=$P($G(^CT("CPT",ctpcttypeId)),"^",2)
	..q:ctpcpdesc'="住院医师"
	..q:$d(^DHCTRDOCi(0,"CTPCP",ctpcp))
	..s err=..AddSSDoc(ctpcp)
	q 0
}

/// 验证某ID是否轮转医生 1 :是   0:否
ClassMethod CheckTDocFlag(ssuser) As %String
{
	n (ssuser)
	q:'$d(^SSU("SSUSR",ssuser)) 0
	s ctpcp=$p(^SSU("SSUSR",ssuser),"^",14)
	q:ctpcp="" 0
	s CTPCPCarPrvTpDR=$p(^CTPCP(ctpcp,1),"^",4)
    q:CTPCPCarPrvTpDR="" 0
    s CTCPTRotaryFlag=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",8)
    q:CTCPTRotaryFlag="Y" 1
	//q:$d(^DHCTRDOCi(0,"CTPCP",ctpcp)) 1
	q 0
}

// ^PAADMi("NotCompl",{PAADM_Type},{PAADM_DepCode_DR},{PAADM_RowID})

// 4900||110

ClassMethod CheckUnSaveOrd(defaultfalg As %String, str As %String) As %String
{
	s UserID=$p(str,"||",1)
	s rowid=$p(str,"||",2)
	i defaultfalg=1 d
	.s LocId=$p(^SSU("SSUSR",UserID),"^",4)
	e  d
	.s LocId=$p(^SSU("SSUSR",UserID,"OTHLL",rowid),"^",1)
	q:LocId="" 0
	
	s FindUnSaveOrdFlag=0
	s PAADMRowID=0
	f   s PAADMRowID=$o(^PAADMi("NotCompl","I",LocId,PAADMRowID)) q:(PAADMRowID="")||(FindUnSaveOrdFlag=1)  d
	.s OEORDRowId=$o(^OEORD(0,"Adm",PAADMRowID,""))
	.q:OEORDRowId=""
	.s OEORIChildsub=0
	.f  s OEORIChildsub=$o(^OEORD(OEORDRowId,"I",OEORIChildsub)) q:(OEORIChildsub="")||(FindUnSaveOrdFlag=1)  d
	..s OEORIItemStatDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	..q:OEORIItemStatDR=""
	..s OSTATCode=$p(^OEC("OSTAT",OEORIItemStatDR),"^",1)
	..q:OSTATCode'="I"
	..s OEORIUserAdd=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",1)
	..q:OEORIUserAdd'=UserID
	..s FindUnSaveOrdFlag=1
	f   s PAADMRowID=$o(^PAADMi("NotCompl","I",LocId,PAADMRowID)) q:(PAADMRowID="")||(FindUnSaveOrdFlag=1)  d
	.s PracticeRowID="" 
	.f  s PracticeRowID=$O(^DHCPracticeDocPrei("TypeAdm","N",PAADMRowID,PracticeRowID)) q:(PracticeRowID="")||(FindUnSaveOrdFlag=1)  d
	..s FindUnSaveOrdFlag=1
	q FindUnSaveOrdFlag
}

Query GetUserOtherLogonDep(defaultfalg As %String, str As %String) As %Query(ROWSPEC = "RowId:%String,SSUSRName:%String,CTLOCDesc:%String,SSGRPDesc:%String,HOSPDesc:%String,CTLOCDR:%String,UserGroupDR:%String,HospitalDR:%String,StartDate:%String,EndDate:%String")
{
}

ClassMethod GetUserOtherLogonDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserOtherLogonDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetUserOtherLogonDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserOtherLogonDepExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCSSDOCGROUPCONFIG","GetUserOtherLogonDep","bid","")

ClassMethod GetUserOtherLogonDepExecute(ByRef qHandle As %Binary, defaultfalg As %String, str As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^TMP("BDPSortByParams","sort","web.DHCSSDOCGROUPCONFIG")
	s ParRef=$p(str,"||",1)
	s rowid=$p(str,"||",2)
	Set langid=..%LanguageID()
	//获取医院级授权
	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s SSUSRName=$p($g(^SSU("SSUSR",ParRef)),"^",2)  
	s ChildSub =0
	for {
		s ChildSub=$o(^SSU("SSUSR",ParRef,"OTHLL",ChildSub))
		q:ChildSub="" 
		if (defaultfalg=0)&&(ChildSub=rowid){
			continue
		}
		s OTHLLRowId=ParRef_"||"_ChildSub
  		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)
  		s OTHLLHospitalDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",3)
  		s strHospitalID = "{ID:"_OTHLLHospitalDR_"}"
  		if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) {
	  		s:OTHLLUserGroupDR'="" SSGRPDesc=$p($g(^SSU("SSGRP",OTHLLUserGroupDR)),"^",1)
  			s:OTHLLUserGroupDR="" SSGRPDesc=""
       		s:SSGRPDesc'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(SSGRPDesc)
       		s:SSGRPDesc="" PINYINDesc="0"
       		d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams("web.DHCSSDOCGROUPCONFIG",PINYINDesc,OTHLLRowId)  
  		}
	}
	if (defaultfalg=0){
		s DefaultDeptDR=$P(^SSU("SSUSR",ParRef),"^",4)
		s DefaultUserGroupDR=$P(^SSU("SSUSR",ParRef),"^",5)
		s HospitalDR=$P(^SSU("SSUSR",ParRef),"^",98)
		s DateFrom=$P(^SSU("SSUSR",ParRef),"^",96)
		s DateTo=$P(^SSU("SSUSR",ParRef),"^",97)
		s (CTLOCDesc,SSGRPDesc,HOSPDesc)=""
		if (DefaultDeptDR'=""){
			s CTLOCDesc=$p($g(^CTLOC(DefaultDeptDR)),"^",2)
			i (HospitalDR=""){
				s HospitalDR=$p($g(^CTLOC(DefaultDeptDR)),"^",22)
			}
		}
		s CTLOCDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTLOCDesc,langid)
		s:DefaultUserGroupDR'="" SSGRPDesc=$p($g(^SSU("SSGRP",DefaultUserGroupDR)),"^",1)
		s SSGRPDesc=##class(User.SSGroup).GetTranByDesc("SSGRPDesc",SSGRPDesc,langid)
		s:HospitalDR'="" HOSPDesc =$p($g(^CT("HOSP",HospitalDR)),"^",2)
		s HOSPDesc=##class(User.CTHospital).GetTranByDesc("HOSPDesc",HOSPDesc,langid)
		s DateFrom=..%ZD(DateFrom)
		s DateTo=..%ZD(DateTo)
		s strHospitalID = "{ID:"_HospitalDR_"}"
  		if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) {
		
			d Build1
  		}
	}
	s IDStr=""
    s IDStr=##class(web.DHCBL.BDP.BDPSortByParams).GetSortDataId("web.DHCSSDOCGROUPCONFIG")
    for i=0:1:$l(IDStr)
    {
	    s ID=$p(IDStr,"^",i+1)
	    q:ID=""
    	s ParRef=$p($g(ID),"||",1)  
    	s ChildSub=$p($g(ID),"||",2) 
    	s OTHLLRowId=ParRef_"||"_ChildSub
		     //用户名
		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",1)
		s OTHLLUserGroupDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",2)
		s OTHLLHospitalDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",3)
	
		s OTHLLStartDate=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",4)
		s OTHLLStartDate=..%ZD(OTHLLStartDate) //转换日期格式	  
		s OTHLLEndDate=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",5)
		s OTHLLEndDate=..%ZD(OTHLLEndDate) //转换日期格式  
		
  		s (CTLOCDesc,SSGRPDesc,HOSPDesc)=""
		s:OTHLLCTLOCDR'="" CTLOCDesc=$p($g(^CTLOC(OTHLLCTLOCDR)),"^",2)
		s CTLOCDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTLOCDesc,langid)
		s:OTHLLUserGroupDR'="" SSGRPDesc=$p($g(^SSU("SSGRP",OTHLLUserGroupDR)),"^",1)
		s SSGRPDesc=##class(User.SSGroup).GetTranByDesc("SSGRPDesc",SSGRPDesc,langid)
		s:OTHLLHospitalDR'="" HOSPDesc =$p($g(^CT("HOSP",OTHLLHospitalDR)),"^",2)
		s HOSPDesc=##class(User.CTHospital).GetTranByDesc("HOSPDesc",HOSPDesc,langid)
		d Build2
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build2
	set Data=$lb(OTHLLRowId,SSUSRName,CTLOCDesc,SSGRPDesc,HOSPDesc,OTHLLCTLOCDR,OTHLLUserGroupDR,OTHLLHospitalDR,OTHLLStartDate,OTHLLEndDate)
 	set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
Build1
    set Data=$lb(ParRef,SSUSRName,CTLOCDesc,SSGRPDesc,HOSPDesc,DefaultDeptDR,DefaultUserGroupDR,HospitalDR,DateFrom,DateTo)
	set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod DelTDItmPlan(defaultfalg, str, EndDate, SSGroupID, UserID)
{
	s Enddate=..%ZDH(EndDate)
	s Date=..%SysDate() 
	s TIme=..%SysTime() 
	if ((Enddate<=..%SysDate())||(SSGroupID="")){
		s rtn=..DelTDItm(defaultfalg,str)
		if (SSGroupID'=""){
			&sql(update DHC_DocSSGroupConfig set DocSSGroup_EndDate=:Enddate 
			, DocSSGroup_CancleUserDR=:UserID,DocSSGroup_CancleDate=:Date
			, DocSSGroup_CancleTime=:TIme where RowId=:SSGroupID)
			}
	}else{
		&sql(update DHC_DocSSGroupConfig set DocSSGroup_EndDate=:Enddate 
		, DocSSGroup_CancleUserDR=:UserID,DocSSGroup_CancleDate=:Date
		, DocSSGroup_CancleTime=:TIme where RowId=:SSGroupID)
		}
	q "0"
}

/// w ##class(web.DHCSSDOCGROUPCONFIG).RollLastdayDelTDItm()
ClassMethod RollLastdayDelTDItm()
{
	
	s today = +$H
	s rowid=""
	for {
		s rowid=$O(^DHCDocSSGroupConfig("EndDate",today,rowid))
		q:rowid=""
		s str=$P(^DHCDocSSGroupConfig(rowid),"^",12)
		s ssuser=$P(^DHCDocSSGroupConfig(rowid),"^",1)
		s loc=$P(^DHCDocSSGroupConfig(rowid),"^",2)
		s UserDefRBDepartmentDR=$p(^SSU("SSUSR",ssuser),"^",4)
		i UserDefRBDepartmentDR=loc s defaultfalg=1
		e  s defaultfalg=0
		i defaultfalg="1" s str=ssuser_"||"_loc
   		e  d
    	.s othsub=0
    	.f  s othsub=$o(^SSU("SSUSR",ssuser,"OTHLL",othsub)) q:+othsub=0  d
    	..s othloc=$p(^SSU("SSUSR",ssuser,"OTHLL",othsub),"^",1)
    	..q:othloc'=loc
    	..s ssgrpdr=$p(^SSU("SSUSR",ssuser,"OTHLL",othsub),"^",2)
    	..i ssgrpdr'="" s ssgroup=$p(^SSU("SSGRP",ssgrpdr),"^",1)
    	..s str=ssuser_"||"_othsub
		s rtn=..DelTDItm(defaultfalg,str)
		}
	q 0
}

}

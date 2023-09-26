Class DHCWL.QueryFunction Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 公共科室调用   解析CTLOC ，过滤RBC_DepartmentGroup，CTLOC_Type类型
/// ycm
/// d ##class(%ResultSet).RunQuery("web.DHCWLQueryFunction","GetlocInfo","","")	
ClassMethod GetlocInfoExecute(ByRef qHandle As %Binary, CTLOCTypePara As %String = "", DEPPara As %String = "") As %Status
{
	n (qHandle,CTLOCTypePara,DEPPara)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	k ^||TEMPDHCWL($j)
 	i DEPPara'=""  d
 	.s len=$L(DEPPara,",")
 	.f i=1:1:len d
 	..s Depdr=$P(DEPPara,",",i)
 	..q:+Depdr=0
 	..s ^||TEMPDHCWL($j,"Dep",Depdr)=""
 	
 	s locId=0
 	f  s locId=$O(^CTLOC(locId)) Q:+locId=0  d
 	.s locType=$P(^CTLOC(locId),"^",13)
 	.s locDepdr=$P(^CTLOC(locId),"^",19)
 	.Q:(CTLOCTypePara'="")&&(CTLOCTypePara'=locType)
 	.Q:(+DEPPara'=0)&&(+locDepdr'=0)&&('$D(^||TEMPDHCWL($j,"Dep",locDepdr)))
 	.s locCode=$P(^CTLOC(locId),"^",1)
 	.s locDesc=$P(^CTLOC(locId),"^",2)
 	.i locDesc["-" s locDesc=$P(locDesc,"-",2)
 	.s locDepDesc=""
 	.i locDepdr'="" s locDepDesc=$P($g(^RBC("DEP",locDepdr)),"^",2)
 	.Q:locDesc["作废"
	.d GetlocInfo
 	k ^||TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetlocInfo
    s Data=$lb(locDepdr,locDepDesc,locId,locCode,locDesc,locType)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetlocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetlocInfoExecute ]
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

ClassMethod GetlocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetlocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetlocInfo(CTLOCTypePara As %String = "", DEPPara As %String = "") As %Query(ROWSPEC = "locDepdr:%String,locDepDesc:%String,locId:%String,locCode:%String,locDesc:%String,locType:%String") [ SqlProc ]
{
}

/// 公共科室调用    从DHCWorkLoad获取科室信息，解析CTLOC ，过滤RBC_DepartmentGroup，CTLOC_Type类型
/// ycm  nodeType:PatDep,PatWard,RESDEP,RECDEP
/// d ##class(%ResultSet).RunQuery("web.DHCWLQueryFunction","GetlocInfoformWL","","17,20","PatDep")	
ClassMethod GetlocInfoformWLExecute(ByRef qHandle As %Binary, CTLOCTypePara As %String = "", DEPPara As %String = "", nodeType As %String = "") As %Status
{
	n (qHandle,CTLOCTypePara,DEPPara,nodeType)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:nodeType="" $$$OK
 	q:'$D(^DHCWorkLoad(0,nodeType)) $$$OK
 	
 	k ^||TEMPDHCWL($j)
 	i DEPPara'=""  d
 	.s len=$L(DEPPara,",")
 	.f i=1:1:len d
 	..s Depdr=$P(DEPPara,",",i)
 	..q:+Depdr=0
 	..s ^||TEMPDHCWL($j,"Dep",Depdr)=""
 	
 	s locId=0
 	f  s locId=$O(^DHCWorkLoad(0,nodeType,locId)) q:locId=""  d
 	.s locType=$P(^CTLOC(locId),"^",13)
 	.s locDepdr=$P(^CTLOC(locId),"^",19)
 	.Q:(CTLOCTypePara'="")&&(CTLOCTypePara'=locType)
 	.Q:(+DEPPara'=0)&&('$D(^||TEMPDHCWL($j,"Dep",locDepdr)))
 	.s locCode=$P(^CTLOC(locId),"^",1)
 	.s locDesc=$P(^CTLOC(locId),"^",2)
 	.i locDesc["-" s locDesc=$P(locDesc,"-",2)
 	.s locDepDesc=""
 	.i locDepdr'="" s locDepDesc=$P(^RBC("DEP",locDepdr),"^",2)
 	.Q:locDesc["作废"
    .s Data=$lb(locDepdr,locDepDesc,locId,locCode,locDesc,locType)
    .s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	k ^||TEMPDHCWL($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetlocInfoformWLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetlocInfoformWLExecute ]
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

ClassMethod GetlocInfoformWLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetlocInfoformWLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetlocInfoformWL(CTLOCTypePara As %String = "", DEPPara As %String = "", nodeType As %String = "") As %Query(ROWSPEC = "locDepdr:%String,locDepDesc:%String,locId:%String,locCode:%String,locDesc:%String,locType:%String") [ SqlProc ]
{
}

/// 公共调用方法  
/// Creator：      ycm
/// CreatDate：    2015-05-04
/// Description:   根据用户工号、获取用户的登陆科室
/// Table：        SS_User,SS_UserOtherLogonLoc
/// Input：        UserCode
/// Output：       登陆科室CT_Loc
/// Return：
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLQueryFunction","GetLogonLocByCode","demo")
Query GetLogonLocByCode(UserCode As %String, CTLOCType As %String = "", CTLOCDepdr As %String = "") As %Query(ROWSPEC = "locId:%String,locCode:%String,locDesc:%String,locType:%String,DepRowid:%String,DepDesc:%String,WardId:%String") [ SqlProc ]
{
}

ClassMethod GetLogonLocByCodeExecute(ByRef qHandle As %Binary, UserCode As %String, CTLOCType As %String = "", CTLOCDepdr As %String = "") As %Status
{
	n (qHandle,UserCode,CTLOCType,CTLOCDepdr)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	k ^||TEMPDHCWL($j)

 	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
 	Q:UserCode="" $$$OK
 	Q:'$D(^SSU("SSUSR",0,"SSUSR_Initials",UserCode)) $$$OK
 	
 	s Id=0
 	f  s Id=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,Id)) Q:Id=""  d
 	.s defaultDept=$P(^SSU("SSUSR",Id),"^",4)
 	.Q:+defaultDept=0
 	.s ^||TEMPDHCWL($j,"LogonLoc",UserCode,defaultDept)=""
 	.s SubId=0
 	.f  s SubId=$O(^SSU("SSUSR",Id,"OTHLL",SubId))  Q:SubId=""  d
 	..s locId=$P(^SSU("SSUSR",Id,"OTHLL",SubId),"^",1)
 	..Q:+locId=0
 	..s ^||TEMPDHCWL($j,"LogonLoc",UserCode,locId)=""
	
	s locId=0 
	f  s locId=$O(^||TEMPDHCWL($j,"LogonLoc",UserCode,locId)) Q:locId=""  d
	.s locCode=$P(^CTLOC(locId),"^",1)
	.s locDesc=$P(^CTLOC(locId),"^",2)
	.i locDesc["-" s locDesc=$P(locDesc,"-",2)
	.s locType=$P(^CTLOC(locId),"^",13)
	.s DepRowid=$P(^CTLOC(locId),"^",19)
	.s DepDesc=""
	.i DepRowid'="" s DepDesc=$P(^RBC("DEP",DepRowid),"^",2)
	.Q:(CTLOCType'="")&&(CTLOCType'=locType)
	.Q:(+CTLOCDepdr'=0)&&(CTLOCDepdr'=DepRowid)
	.s WardId=$O(^PAWARD(0,"WARD_LocationDR",locId,""))
	.s ^CacheTemp(repid,ind)=$lb(locId,locCode,locDesc,locType,DepRowid,DepDesc,WardId)
	.s ind=ind+1
	
	k ^||TEMPDHCWL($j)
	Quit $$$OK
}

ClassMethod GetLogonLocByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogonLocByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLogonLocByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogonLocByCodeExecute ]
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

/// 医嘱数量
ClassMethod GetOrdTarNum(mArcItmDr, mDate) As %String
{
	n (mArcItmDr,mDate)
	s mReturn=0
	q:$G(mArcItmDr)="" +$G(mReturn)
	q:'$d(^DHCOLT(0,"ARTTA",mArcItmDr)) +$G(mReturn)
	
	s mTarDr=0
	f  s mTarDr=$o(^DHCOLT(0,"ARTTA",mArcItmDr,mTarDr)) q:$G(mTarDr)=""  d 
	.;s mOrdDate=mDate
	.;s mOrdDate=$o(^DHCOLT(0,"ARTTA",mArcItmDr,mTarDr,mOrdDate),-1)
	.;q:$G(mOrdDate)=""
	.s mOrdDate=0
	.f  s mOrdDate=$o(^DHCOLT(0,"ARTTA",mArcItmDr,mTarDr,mOrdDate)) q:$G(mOrdDate)=""  d
	..s mOLTDr=0
	..f  s mOLTDr=$o(^DHCOLT(0,"ARTTA",mArcItmDr,mTarDr,mOrdDate,mOLTDr)) q:$G(mOLTDr)=""  d
	...s mCount=$P($G(^DHCOLT(mOLTDr)),"^",3)
	...s mEndDate=$P($G(^DHCOLT(mOLTDr)),"^",5)
	...s mSDate=$P($G(^DHCOLT(mOLTDr)),"^",4)
	...q:$G(mSDate)>$G(mDate)
	...q:($g(mDate)>$G(mEndDate))&($g(mEndDate)'="")
	...s mReturn=$G(mReturn)+$G(mCount)
	...
	s ^TEMPWorkLoadQuery($j,$zn,"ArcCount",mDate,mArcItmDr)=+$G(mReturn)
	q $G(mReturn)
}

/// 医嘱数量
ClassMethod GetOrdNums(mWlId, indexType = "") As %String
{
	n (mWlId,indexType)
 	s statResult=0
 	s mOrdDate=$p($g(^DHCWorkLoad(mWlId)),"^",5)
 	s mArcItmDr=$p($g(^DHCWorkLoad(mWlId)),"^",2)
 	s mOeordDr=$p($g(^DHCWorkLoad(mWlId)),"^",21)
 	s tarItem=$p($g(^DHCWorkLoad(mWlId)),"^",22)
 	q:(+$g(mOrdDate)=0)!(+$g(mOeordDr)=0) +$g(statResult)
 	q:'$d(^DHCWorkLoad(0,"DateOEORI",mOrdDate,mOeordDr)) +$g(statResult)
 	q:$d(^TEMPWorkLoadQuery($j,$zn,"OrdNums",mOrdDate,mOeordDr)) +$g(statResult)
	s mOrdFee=0
	s mOrdCount=0
 	s mId=0
 	f  s mId=$o(^DHCWorkLoad(0,"DateOEORI",mOrdDate,mOeordDr,mId)) q:$g(mId)=""  d
 	.s mWlPrice=$p($g(^DHCWorkLoad(mId)),"^",16)
 	.s mWlCount=$p($g(^DHCWorkLoad(mId)),"^",15)
 	.s mFlagDate=$p($g(^DHCWorkLoad(mId)),"^",27)
 	.q:($G(indexType)="FlagDate")&&(($G(mFlagDate)>mEDate)!($G(mFlagDate)<mSDate))	///	20130426 ch add
 	.;w !
 	.s mOrdCount=$G(mOrdCount)+$G(mWlCount)
 	.;w !,"mOrdCount= "_mOrdCount
	i $d(^TEMPWorkLoadQuery($j,$zn,"ArcCount",mOrdDate,mArcItmDr)) d
	.s mArcCount=$G(^TEMPWorkLoadQuery($j,$zn,"ArcCount",mOrdDate,mArcItmDr))
	e  d
	.s mArcCount=..GetOrdTarNum(mArcItmDr,mOrdDate)
	s mWlOrdCount=0
	i +$G(mArcCount)'=0 s mWlOrdCount=$fn($G(mOrdCount)/$G(mArcCount),"",2)
	s ^TEMPWorkLoadQuery($j,$zn,"OrdNums",mOrdDate,mOeordDr)=+$G(mWlOrdCount)
 	s statResult=$g(^TEMPWorkLoadQuery($j,$zn,"OrdNums",mOrdDate,mOeordDr))
 	q +statResult
}

ClassMethod GetPatDiagnos(AdmRowid As %String, DiagType As %String) As %String
{
 /// 通过PA_Adm.PAADM_RowID获得满足条件的第一个诊断情况
 /// DIS出院诊断,M主诊断,PRE预期诊断,C008入院诊断
 n (AdmRowid,DiagType)
 q:$g(AdmRowid)="" ""
 q:'$d(^PAADM(AdmRowid)) ""
 s AdmMainDr=$p(^PAADM(AdmRowid),"^",61)
 q:$g(AdmMainDr)="" ""
 q:'$d(^MR(AdmMainDr,"DIA")) ""
 s MRDiagsub=0 f  s MRDiagsub=$o(^MR(AdmMainDr,"DIA",MRDiagsub)) q:(MRDiagsub="")  d
 .s TypeSub=0  f  s TypeSub=$o(^MR(AdmMainDr,"DIA",MRDiagsub,"TYP",TypeSub)) q:TypeSub=""  d
 ..s TypeDiagDr=$p(^MR(AdmMainDr,"DIA",MRDiagsub,"TYP",TypeSub),"^",1)
 ..q:TypeDiagDr=""
 ..s TypeDCode=$p(^MRC("DTYP",TypeDiagDr),"^")
 ..q:(DiagType'="")&&(TypeDCode'=DiagType)
 ..s mrdiaIcdCode=$p(^MR(AdmMainDr,"DIA",MRDiagsub),"^",1)
 ..s docId=$p(^MR(AdmMainDr,"DIA",MRDiagsub),"^",4)
 ..s reMark=$g(^MR(AdmMainDr,"DIA",MRDiagsub,"DES",1))
 ..i mrdiaIcdCode'=""  d
 ...i $d(^MRC("ID",mrdiaIcdCode))  d
 ....s mrcidDesc1=$p($g(^MRC("ID",mrdiaIcdCode)),"^",2)
 ....s mrcidCode1=$p($g(^MRC("ID",mrdiaIcdCode)),"^",4)
 ....i $g(mrcidDesc)'="" s mrcidDesc=mrcidDesc_" "_mrcidDesc1
 ....else  s mrcidDesc=mrcidDesc1
 ..i $g(mrcidDesc)="" s mrcidDesc=reMark
 q $g(mrcidDesc)
}

}

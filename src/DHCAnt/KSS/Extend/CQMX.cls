/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 抗菌药物碳青霉烯抗菌药物业务控制类
Class DHCAnt.KSS.Extend.CQMX Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 保存CQMX信息
/// IN  :  
/// OUT : 0成功
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.CQMX).SaveCQMX()
ClassMethod SaveCQMX(inPara As %String, SP As %String = "") As %String
{
	n (inPara,SP)
	if SP="" s SP=$C(1)
	s MainDiagDr=	$p(inPara,SP,1)
	s Instruc=		$p(inPara,SP,2)
	s IsConsult=	$p(inPara,SP,3)
	s IsEmergency=	$p(inPara,SP,4)
	s IsLab=		$p(inPara,SP,5)
	s Locid=		$p(inPara,SP,6)
	s Arcim=		$p(inPara,SP,7)
	s Patid=		$p(inPara,SP,8)
	s PrescDoc=		$p(inPara,SP,9)
	s IPNo=			$p(inPara,SP,10)
	s Admid=		$p(inPara,SP,11)
	i Patid="" s Patid=$p(^PAADM(Admid),"^",1)
	s Type=..IsCqmxOrTgc(Arcim)
	Q:Type=0 "-102"	//前台控制出错
	s mRtn=0
	TS
	s SaveOBJ=##class(User.DHCAntCQMXMode).%New()
	
	d SaveOBJ.AdmidSetObjectId(Admid)
	d SaveOBJ.MainDiagnosisDrSetObjectId(MainDiagDr)
	d SaveOBJ.InstrucDrSetObjectId(Instruc)
	d SaveOBJ.ArcimDrSetObjectId(Arcim)
	d SaveOBJ.LocidSetObjectId(Locid)
	d SaveOBJ.PatMasDrSetObjectId(Patid)
	d SaveOBJ.PrescDocSetObjectId(PrescDoc)
	
	s SaveOBJ.IsConsult=IsConsult
	s SaveOBJ.IsLab=IsLab
	s SaveOBJ.IsEmergency=IsEmergency
	s SaveOBJ.Type=Type
	s SaveOBJ.PrescDate=+$h
	s SaveOBJ.PrescTime=$p($h,",",2)
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		TRO
		Quit "-101"
	}
	s mRtn=SaveOBJ.%Id()
	d SaveOBJ.%Close()
	TC
	
 	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 更新使用目的指针
/// IN  :  
/// OUT : 0成功
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.Extend.CQMX).ChangeUseAimDR()
ClassMethod ChangeUseAimDR(CQMXId As %String, AimDr As %String, ApplyDr As %String) As %String
{
	n (CQMXId,AimDr,ApplyDr)
	s mRtn=0
	TS 
	&SQL(UPDATE SQLUser.DHCAnt_CQMXMode 
		SET CQMX_AimDr=:AimDr,CQMX_ApplyDr=:ApplyDr WHERE CQMX_RowId=:CQMXId
	)
	i SQLCODE {
		TRO
		q "-102"
	}
	TC
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 查询用法
/// IN  :  
/// OUT : 
/// NOTE:  
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Extend.CQMX","QryUse","")
Query QryUse(code As %String = "") As %Query(ROWSPEC = "id,desc,code1")
{
}

ClassMethod QryUseExecute(ByRef qHandle As %Binary, code As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	
 	s code=$$ALPHAUP^SSUTIL4(code)
 	Set InstrRowid=0
 	For  Set InstrRowid=$o(^PHCIN(InstrRowid)) Quit:InstrRowid=""  do
 	.Set code1=$$ALPHAUP^SSUTIL4($p(^PHCIN(InstrRowid),"^",1))
 	.Set desc=$$ALPHAUP^SSUTIL4($p(^PHCIN(InstrRowid),"^",2))
 	.Quit:(code1'[code)&&(desc'[code)
   	.Do output1
   	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(InstrRowid,desc,code1)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryUseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryUseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryUseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryUseExecute ]
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

ClassMethod LookUpWithAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWithAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 查询主要诊断
/// IN  :  
/// OUT : 
/// NOTE:  
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Extend.CQMX","LookUpWithAlias","tnb")
Query LookUpWithAlias(desc As %String = "", loc As %String = "", ver1 As %String = "", EpisodeID As %String = "", ICDType As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,Rowid:%String,code:%String")
{
}

ClassMethod LookUpWithAliasExecute(ByRef qHandle As %Binary, desc As %String = "", loc As %String = "", ver1 As %String = "", EpisodeID As %String = "", ICDType As %String = "") As %Status
{
	s ^guorongyong("ICDType")=desc_"^"_loc_"^"_ver1_"^EpisodeID="_EpisodeID_"^"_ICDType
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if desc="" {
		//Set qHandle=$lb(0,repid,0)
		//Quit $$$OK	
	}
 s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
 s HospitalCode=$P(Hospital,"^",1)
	s desc1="",rowid="",code="",PAADMType=""
	i EpisodeID'="" d
	.s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	if (HospitalCode'="SDWFYY") {
		;&sql(DECLARE EmpCur1 CURSOR FOR SELECT MRCID_Desc,MRCID_RowId, MRCID_Code FROM SQLUser.MRC_ICDDx WHERE (%ALPHAUP MRCID_Code %STARTSWITH %ALPHAUP :val) ORDER BY MRCID_Code)	
		&SQL(DECLARE EmpCur1 CURSOR FOR 
		     SELECT ALIAS_ParRef->MRCID_Desc,ALIAS_ParRef->MRCID_RowId,ALIAS_ParRef->MRCID_Code 
		     INTO :desc1,:rowid,:code FROM SQLUser.MRC_ICDAlias 
		     WHERE (%ALPHAUP ALIAS_Text %STARTSWITH %ALPHAUP :desc) or (%ALPHAUP ALIAS_ParRef->MRCID_Desc %STARTSWITH %ALPHAUP :desc)
		     Group by ALIAS_ParRef->MRCID_RowId)
		&sql(OPEN EmpCur1)
		for  &SQL(FETCH EmpCur1) QUIT:SQLCODE  do
		.s childsub=0 f  s childsub=$O(^MRC("ID",rowid,"ALIAS",childsub)) Q:childsub=""  d
		..s alias=^MRC("ID",rowid,"ALIAS",childsub)
		..s BillFlag3=$P($G(^MRC("ID",rowid)),"^",15)
		..s desc1=desc1_" | "_alias
		.Q:(PAADMType="I")&&($e(code,1,1)="M")
		. i ICDType="1" d
		.. i BillFlag3="Y" d OutputRow1
		. e  d
		.. i BillFlag3'="Y" d OutputRow1 	
		&sql(CLOSE EmpCur1)
	}else {
		s Rowid=0 f  s Rowid=$o(^MRC("ID",Rowid)) q:Rowid=""  d
		.s BillFlag3=$P($G(^MRC("ID",Rowid)),"^",15)
		.Q:(ICDType'="1")&&(BillFlag3="Y")
		.Q:(ICDType="1")&&(BillFlag3'="Y")
		.s desc=$ZCONVERT(desc,"U")
		.s desc1=$p(^MRC("ID",Rowid),"^",2)
		.s desc1=$ZCONVERT(desc1,"U")
		.s code=$p(^MRC("ID",Rowid),"^",1)
		.s rowid=Rowid
		.i desc1[(desc) Do OutputRow1
		.e  d
		..s AliasRowid=0 f  s AliasRowid=$o(^MRC("ID",Rowid,"ALIAS",AliasRowid)) q:AliasRowid=""  d
		...s Alias=^MRC("ID",Rowid,"ALIAS",AliasRowid)
		...s Alias=$ZCONVERT(Alias,"U")
		...i Alias[desc Do OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(desc1,rowid,code)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables1
	Set Data=$lb(desc1,rowid,code)
	Quit
}

ClassMethod LookUpWithAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWithAliasExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 获取病历号
/// IN  : 
/// EXEC: w ##class(DHCAnt.KSS.Extend.CQMX).GetIPNo("61")
ClassMethod GetIPNo(PatientId As %String = "") As %String
{
	n (PatientId)
	s ^TEMP("QP1",1)=PatientId
	s mRtn=""
	q:PatientId="" mRtn
	s TempId=""
	f  s TempId=$o(^DHCWMRMAIN(0,"PAPMI",PatientId,TempId)) q:TempId=""  d
	.s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+TempId)
	.;s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(sTempMainRowid)
	.q:sTempMain=""
	.s sTempMrType=$p(sTempMain,"^",2)
	.s mRtn=$p(sTempMain,"^",3)
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 获取病历号
/// IN  : 
/// EXEC: w ##class(DHCAnt.KSS.Extend.CQMX).GetIPNoNew("67")
ClassMethod GetIPNoNew(admid As %String = "") As %String
{
	n (admid)
	s mRtn=##class(Nur.CommonInterface.Patient).getMedicareNo(admid)
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 是否TGC或CQMX
/// IN  : mode为1表示之前的老模式
/// OUT : 0 /1 /2 1代表CQMX 2代表TGC 0 : none 
/// EXEC: w ##class(DHCAnt.KSS.Extend.CQMX).IsCqmxOrTgc("1565||1")
ClassMethod IsCqmxOrTgc(arcim As %String, mode As %String = "") As %String
{
	n (arcim,mode)
	s mRtn=0
	Q:arcim="" mRtn
	if (mode=""){
		Q:'$d(^CF.ANT.ItmMastI("ARCIM",arcim)) mRtn
		s itmdr=$o(^CF.ANT.ItmMastI("ARCIM",arcim,""))
		q:itmdr="" mRtn
		s isCqmx=$p(^CF.ANT.ItmMastD(itmdr),"^",2)
		s isTgc=$p(^CF.ANT.ItmMastD(itmdr),"^",3)
		i isCqmx="Y" s mRtn=1
		i isTgc="Y" s mRtn=2
	} else {
		s CQMX=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("CQMX")
		s TGC=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("TGC")
		s cqmxFlag=##class(DHCAnt.KSS.Common.Method).InArray(CQMX,arcim)
		s tgcFlag=##class(DHCAnt.KSS.Common.Method).InArray(TGC,arcim)
		i cqmxFlag=1 s mRtn=1
		i tgcFlag=1 s mRtn=2
	}
	
	Quit mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 是否弹出碳青霉烯业务申请单
/// IN  : 
/// OUT : 0/1
/// EXEC: w ##class(DHCAnt.KSS.Extend.CQMX).IsFillCqmx("2||1")
ClassMethod IsFillCqmx(arcim As %String, InHosp) As %String
{
	n (arcim,InHosp)
	s SCQMX=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SCQMX",InHosp)
	q:SCQMX'=1 0
	s IsCqmxOrTgc=..IsCqmxOrTgc(arcim)
	q:IsCqmxOrTgc=0 0
	
	Quit 1
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 获取基本信息
/// IN  : 
/// EXEC: w ##class(DHCAnt.KSS.Extend.CQMX).GetBaseInfo("67",95)
ClassMethod GetBaseInfo(admid As %String = "", locid As %String = "") As %String
{
	n (admid,locid)
	s ^TEMP("DHCQP")=admid_"^"_locid
	s patid=$p($G(^PAADM(admid)),"^",1)
	s patName=$P(^PAPER(patid,"ALL"),"^",1)
	s locName=$p(^CTLOC(locid),"^",2)
	i locName["-" s locName=$p(locName,"-",2)
	s prescDate=$zd(+$h,3)
	s ipno=..GetIPNoNew(admid)
	
	q patName_"^"_locName_"^"_prescDate_"^"_ipno
}

/// QP
/// 得到查询权限
/// 	0:无权限，1：本科权限，2：全院权限
/// w ##class(DHCAnt.Dao.CQMX).setQryQuth()
ClassMethod GetQryQuth(groupId)
{
	n (groupId)
	;s mRtn=0
	;i (groupId="659")||(groupId="740") s mRtn=1
	s mRtn=1
	i (groupId="1")||(groupId="457") s mRtn=2
	Quit mRtn
}

/// CTOR: QP
/// DATE: 2019-05-08
/// DESC: 碳青霉烯类以及替加环素类抗菌药物使用情况统计 
/// IN  : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCAnt.Dao.CQMX","QryCqmxTgc","","")
Query QryCqmxTgc(sDate As %String, eDate As %String, groupId As %String = "", locId As %String = "") As %Query(ROWSPEC = "locName,antName,genAntName,patName,patNo,mainDiag,drugUse,isConsult,isLab,isEmergency,prescDoc,prescDate,auditPrescDoc") [ SqlProc ]
{
}

ClassMethod QryCqmxTgcExecute(ByRef qHandle As %Binary, sDate As %String, eDate As %String, groupId As %String = "", locId As %String = "") As %Status
{
	n (qHandle,sDate,eDate,groupId,locId)
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	s authFlag=..GetQryQuth(groupId)
	if ((sDate="")||(eDate="")||(groupId="")||(authFlag=0)) {  
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sDate=$zdh(sDate,3)
	s eDate=$zdh(eDate,3)
	f cDate=sDate:1:eDate d
	.s rowid=""
	.f  s rowid=$o(^BS.ANT.DHCAntCQMXModeI("prescDate",cDate,rowid)) q:rowid=""  d
	..s admid=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),1)
	..s locid=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),2)
	..q:(authFlag=1)&&(locid'=locId)
	..s (locName,antName,genAntName,patName,patNo,mainDiag,drugUse,isConsult,isLab,isEmergency,prescDoc,prescDate,auditPrescDoc)=""
	..i locid'="" d 
	...s locName=$p(^CTLOC(locid),"^",2)						//科室
	...i locName["-" s locName=$p(locName,"-",2)
	..s arcim=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),3)
	..s arcimOrd=+arcim,arcimSub=$p(arcim,"||",2)
	..i arcim'="" d 
	...s antName=$P(^ARCIM(arcimOrd,arcimSub,1),"^",2)		//商品名
	...s genericDr=$p(^ARCIM(arcimOrd,arcimSub,8),"^",20)
	...i genericDr'="" s genAntName=$p(^PHCGE("GE",genericDr),"^",2)			//通用名
	..s patid=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),4)
	..i patid'="" s patName=$p(^PAPER(patid,"ALL"),"^",1)	//患者姓名
	..s diagnosisDr=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),13)
	..i diagnosisDr'="" s mainDiag=$lg(^MRC("ID",diagnosisDr),2)			//诊断
	..s useid=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),5)
	..i useid'="" s drugUse=$p(^PHCIN(useid),"^",2)			//用法
	..s isConsult=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),6)
	..i isConsult=1 s isConsult="是"
	..e  s isConsult="否"
	..s isLab=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),8)
	..i isLab=1 s isLab="是"
	..e  s isLab="否"
	..s isEmergency=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),7)
	..i isEmergency=1 s isEmergency="是"
	..e  s isEmergency="否"
	..s prescDoc=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),9)
	..i prescDoc'="" s prescDoc=$p(^SSU("SSUSR",prescDoc),"^",2)	//处方医生
	..s prescDate=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),10)
	..i prescDate'="" s prescDate=$zd(prescDate,3)			//处方日期
	..s patNo=..GetIPNo(patid)		//病历号
	..s type=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),12)
	..s aimId=$lg(^BS.ANT.DHCAntCQMXModeD(rowid),14)
	..q:'$D(^DAUP("DAUP",aimId))
	..s oeori=$p(^DAUP("DAUP",aimId),"^",3)
	..q:oeori=""
	..s DSPRowid=$o(^DHCOEDISQTY(0,"OEORI",oeori,0))
    ..s DSPUser=$P(^DHCOEDISQTY(DSPRowid),"^",10)
    ..s:DSPUser'="" auditPrescDoc=$p(^SSU("SSUSR",DSPUser),"^",2)
	
	..d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
     set Data=$lb(locName,antName,genAntName,patName,patNo,mainDiag,drugUse,isConsult,isLab,isEmergency,prescDoc,prescDate,auditPrescDoc)
	 Set ^CacheTemp(repid,index)=Data
	 Set index=index+1
	 quit
 Quit
}

ClassMethod QryCqmxTgcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCqmxTgcExecute ]
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

ClassMethod QryCqmxTgcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCqmxTgcExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

}

Import sqluser

/// Descript: 物资信息审核
/// Creater:	lihui
/// CreateDate:	20190304
Class web.DHCSTMHUI.MatAudit Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 取物资审核信息
/// Author: lihui
/// Date: 20190314 
/// Update:20200705
/// Table : DHC_WorkAuditLog,DHC_AuditLog,DHC_AuditLog_INCI
/// Return:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.MatAudit","GetMatAuditInfo",^litmp("GetMatAuditInfo"))
Query GetMatAuditInfo(Params As %String) As Query(ROWSPEC = "RowId,Incid,ChangeType,LastauditFlag,LastDWALFlag,LastDWALDate,LastDWALTime,LastDWALUser,LastDWALLevel,update,uptime,upusername,AudIncicode,AudIncidesc,AudSpec,AudIncsc,AudBaseUOM,AudPuom,AudNotUseFlag,Manf,Brand,VendorId,VendorName,RegisterNo,RegisterNoExpDate,HighPrice,chargeflag,Implantation,Model,Supervision,Origin,regCertDateOfIssue,RegItmDesc,RegCertNoFull,INCIBarCode,Mtdr,MT,Abbrev,ChargeType,Sterile,SterCat,ReportingDays,ProlocDesc,ImportFlag,QualityLevel,ComFrom,Remark,MaxSp:%Float,InHosFlag,PbRp:%Float,PBLdesc,PbCarrier,BAflag,PBLevel,EndDate,ExpireLen,PrcFile,PrcFileD,BC,StandardCode,NotUseReason,InsuCat,HighRiskFlag,PackUom,PackUomFactor,PackPicPath,MaxPurAmt:%Float,DistribFlag,Pbno,ChangeRate,MatQuality,ReqModeLimited,NoLocReq,SpeFlag,SterileDateLen,MedEqptCat,ZeroStk,SpecFlag,BidDate,FirstReqDept,InsuPay,InsuPrice,MatCatOfficial,MatCatClinical,MatCatSpecial,ChangeTypeid,RefuseReason")
{
}

ClassMethod GetMatAuditInfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 $$$OK
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s AuditFlag=PJObj.%Get("AuditFlag")
	s tmpinciCode=PJObj.%Get("InciCode")
	s tmpinciDesc=PJObj.%Get("InciDesc")
	s tmpStkGrpType=PJObj.%Get("StkGrp")
	s tmpstkCatId=PJObj.%Get("StkCat")
	s TypeFlag=PJObj.%Get("TypeFlag")
	s Locid=PJObj.%Get("gLocId")
	s Userid=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	
	s type="Basic"
	;s MaxLevel=$o(^DMALM(0,"typelevel",type,""),-1) ;最大审核级别
	s MaxLevel=..GetMaxAuditLevel(type)
	q:+MaxLevel=0 $$$OK  ;没有审核权限维护
	
	s CurLevel=..GetAuditLevel(type,Userid)
	;q:CurLevel<1 $$$OK  ;维护的级别最低为1
	i ((StartDate'="")&&(EndDate'="")) d
	.i StartDate["-" s StartDate=$zdh(StartDate,3)
	.i EndDate["-" s EndDate=$zdh(EndDate,3)
	.i StartDate["/" s StartDate=$zdh(StartDate,4)
	.i EndDate["/" s EndDate=$zdh(EndDate,4)
	.i ((CurLevel>1)||(AuditFlag="Y")) d
	..s Pid=..AuditLevelMoreOneByDate(StartDate,EndDate,AuditFlag,CurLevel,type)
	.e  d  ;未审核级别为1
	..s Pid=..UnAuditLevelOneByDate(StartDate,EndDate,AuditFlag,CurLevel,type)
	e  d
	.i ((CurLevel>1)||(AuditFlag="Y")) d  ;已审核或者级别大于1
	..s Pid=..AuditLevelMoreOne(AuditFlag,CurLevel,type)
	.e  d  ;未审核级别为1
	..s Pid=..UnAuditLevelOne(AuditFlag,CurLevel,type)

	s ScgStr=""
	&sql(declare ScgCursor cursor for
		SELECT DMAL_SCG_DR FROM DHC_MatAuditLevel WHERE DMAL_Loc_Dr=:Locid AND DMAL_SSuser_Dr=:Userid AND DMAL_SSGroup=:GroupId
		AND DMAL_ActiveFlag='Y'
	)
	&sql(open ScgCursor)
	f  &sql(fetch ScgCursor into :ScgId) q:SQLCODE  d
	.i ScgStr="" s ScgStr=ScgId
	.e  s ScgStr=ScgStr_"^"_ScgId
	&sql(close ScgCursor)
	
	;s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(Userid,..sssCode(),Locid,tmpStkGrpType)
	
	s Rowid=""
	f  s Rowid=$o(^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid,Rowid)) q:Rowid=""  d
	.s MALGRowId=Rowid
	.i ((CurLevel>1)||(AuditFlag="Y")) s MALGRowId=$p(Rowid,"||",2)
	.s LastSub=$o(^DHCMALG(MALGRowId,"INCI",""),-1)
	.q:LastSub=""
	.s Incid=$p(^DHCMALG(MALGRowId,"INCI",LastSub),"^",1)
	.q:Incid=""
	.s update=$p(^DHCMALG(MALGRowId),"^",1)
	.s update=$s(update'="":$zd(update,3),1:"")
	.s uptime=$p(^DHCMALG(MALGRowId),"^",2)
	.s uptime=$s(uptime'="":$zt(uptime,3),1:"")
	.s upuserid=$p(^DHCMALG(MALGRowId),"^",3)
	.s upusername=$s(upuserid'="":$p(^SSU("SSUSR",upuserid),"^",2),1:"")
	.s logsub=""
	.f  s logsub=$o(^DHCMALG(MALGRowId,"INCI",logsub)) q:logsub=""  d
	..s MALGinfo=^DHCMALG(MALGRowId,"INCI",logsub)
	..s MALGitmRowId=MALGRowId_"||"_logsub
	..s tmpAuditFlag=$p(MALGinfo,"^",22)
	..;q:(tmpAuditFlag'=AuditFlag)
	..s Incid=$p(MALGinfo,"^",1)
	..q:Incid=""
	..q:'$d(^INCI(Incid))
	..q:'$d(^INCI(Incid,1))
	..q:'$d(^INCI(Incid,2))
	..s Incicode=$p(^INCI(Incid,1),"^",1)
	..q:(tmpinciCode'="")&&(tmpinciCode'=Incicode)
	..s Incidesc=$p(^INCI(Incid,1),"^",2)
	..q:(tmpinciDesc'="")&&(tmpinciDesc'[Incidesc)
	..s stkcatid=$p(^INCI(Incid,2),"^",2)
	..q:(tmpstkCatId'="")&&(tmpstkCatId'=stkcatid)
	..s stkgroupid=$p(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Incid),"^",5)
	..q:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_stkgroupid_"^"))
	..s DWALPoint=Incid_"||"_MALGRowId
	..s LastDWALRowId=$o(^DHCDWAL(0,"TypePoint",type,DWALPoint,""),-1) ;最新一次审核记录
	..s (ChangeType,LastDWALDate,LastDWALTime,LastDWALUser,LastDWALFlag,LastauditFlag,RefuseReason)=""
	..s LastDWALLevel=0
	..i LastDWALRowId'="" d
	...s DHCDWALinfo=^DHCDWAL(LastDWALRowId)
	...s LastDWALDate=$p(DHCDWALinfo,"^",1)
	...s:LastDWALDate'="" LastDWALDate=..DL2H(LastDWALDate)
	...s LastDWALTime=$p(DHCDWALinfo,"^",2)
	...s:LastDWALTime'="" LastDWALTime=$zt(LastDWALTime,1)
	...s LastDWALUserId=$p(DHCDWALinfo,"^",5)
	...s LastDWALUser=$s(LastDWALUserId'="":$p(^SSU("SSUSR",LastDWALUserId),"^",2),1:"")
	...s LastDWALLevel=$p(DHCDWALinfo,"^",4)
	...s LastauditFlag=$p(DHCDWALinfo,"^",7)
	...s:LastauditFlag="Y" LastDWALFlag="审核通过"
	...s:LastauditFlag="N" LastDWALFlag="审核不通过"
	...s RefuseReason=$p(DHCDWALinfo,"^",8)
	..q:(AuditFlag="N")&&(LastDWALLevel=CurLevel)
	..q:(AuditFlag="N")&&(LastDWALLevel=MaxLevel) ;已审核完成
	..q:(AuditFlag="N")&&(LastauditFlag="N")
	..s:AuditFlag="N" LastDWALFlag="未审核",LastauditFlag="N"
	..s AudIncicode=$p(MALGinfo,"^",3)
	..s AudIncidesc=$p(MALGinfo,"^",4)
	..s AudSpec=$p(MALGinfo,"^",13)
	..s AudIncscdr=$p(MALGinfo,"^",5)
	..s AudIncsc=$s(AudIncscdr'="":$p(^INC("SC",AudIncscdr),"^",2),1:"")
	..s AudBaseUOMDR=$p(MALGinfo,"^",7)
	..s AudBaseUOM=$s(AudBaseUOMDR'="":$p(^CT("UOM",AudBaseUOMDR),"^",2),1:"")
	..s AudPuomdr=$p(MALGinfo,"^",8)
	..s AudPuom=$s(AudPuomdr'="":$p(^CT("UOM",AudPuomdr),"^",2),1:"")
	..s AudNotUseFlag=$p(MALGinfo,"^",6)
	..s ChangeTypeid=$p(MALGinfo,"^",2)
	..q:(TypeFlag=0)&&(ChangeTypeid'=0)
	..q:(TypeFlag=1)&&(ChangeTypeid'=1)
	..q:(TypeFlag=2)&&(ChangeTypeid'=2)
	..i ChangeTypeid=0 s ChangeType="修改前"
	..i ChangeTypeid=1 s ChangeType="修改后"
	..i ChangeTypeid=2 s ChangeType="新增加"
	..s INFOPbManfDR=$p(MALGinfo,"^",12)
	..s Manf=$s(INFOPbManfDR'="":$p(^PHMNF(INFOPbManfDR),"^",2),1:"")
	..s brand=$p(MALGinfo,"^",15)
	..s vendor=$p(MALGinfo,"^",11)
	..s vendorName=$s(vendor'="":$p(^APC("APCVM",vendor),"^",3),1:"")
	..s registerNo=$p(MALGinfo,"^",20)
	..s registerNoExpDate=$p(MALGinfo,"^",21)
	..s:registerNoExpDate'="" registerNoExpDate=..DL2H(registerNoExpDate)
	..s highpriceflag=$p(MALGinfo,"^",9)
	..s chargeflag=$p(MALGinfo,"^",53)
	..s implantationmat=$p(MALGinfo,"^",24)
	..s model=$p(MALGinfo,"^",14)
	..s Supervision=$p(MALGinfo,"^",70)
	..s OriginDr=$p(MALGinfo,"^",18)
	..s Origin=$s(OriginDr'="":$p(^DHCSTORI(OriginDr),"^",2),1:"")
	..s regCertDateOfIssue=""
	..s regItmDesc=""
	..s regCertNoFull=""
	..s INCIBarCode=$p(MALGinfo,"^",26)
	..s Mtdr=$p(MALGinfo,"^",10)
	..s MT=$s(Mtdr'="":$p(^DHCINMT(Mtdr),"^",2),1:"")
	..s Abbrev=$p(MALGinfo,"^",16)
	..s ChargeTypedr=$p(MALGinfo,"^",17)
	..s ChargeType=$s(ChargeTypedr'="":$p(^DHCItmChgType(ChargeTypedr),"^",2),1:"")
	..s Sterile=$p(MALGinfo,"^",68)  ; 
	..s SterCatDR=$p(MALGinfo,"^",67)
	..s SterCat=$s(SterCatDR'="":$p(^INC("SCAT",SterCatDR),"^",1),1:"")
	..s ReportingDays=$p(MALGinfo,"^",61)
	..s CTLOCDR=$p(MALGinfo,"^",56)
	..s ProlocDesc=$s(CTLOCDR'="":$p(^CTLOC(CTLOCDR),"^",2),1:"")
	..s ImportFlag=$p(MALGinfo,"^",25)
	..s QualityLeveldr=$p(MALGinfo,"^",57)
	..s QualityLevel=$s(QualityLeveldr'="":$p(^DHCITMQL(QualityLeveldr),"^",2),1:"")
	..s ComFrom=$p(MALGinfo,"^",38)
	..s Remark=$p(MALGinfo,"^",60)
	..s MaxSp=$p(MALGinfo,"^",36)
	..s InHosFlag=$p(MALGinfo,"^",27)
	..s PbRp=$p(MALGinfo,"^",52)
	..s PBLDR=$p(MALGinfo,"^",48)
	..s PBLdesc=$s(PBLDR'="":$p(^DHCPBLIST(PBLDR),"^",2),1:"")
	..s PbCarrierDR=$p(MALGinfo,"^",47)
	..s PbCarrier=$s(PbCarrierDR'="":$p(^DHCCARR(PbCarrierDR),"^",2),1:"")
	..s BAflag=$p(MALGinfo,"^",63)
	..s PBLevel=$p(MALGinfo,"^",49)
	..s EndDate=$p(MALGinfo,"^",71)
	..s:EndDate'="" EndDate=..DL2H(EndDate)
	..s ExpireLen=$p(MALGinfo,"^",59)
	..s PrcFile=$p(MALGinfo,"^",54)
	..s PrcFileD=$p(MALGinfo,"^",55)
	..s:PrcFileD'="" PrcFileD=..DL2H(PrcFileD)
	..s BCDr=$p(MALGinfo,"^",41)
	..s BC=$s(BCDr'="":$p(^DHCSTBC(BCDr),"^",2),1:"")
	..s StandardCode=$p(MALGinfo,"^",66)
	..s NotUseReasonDr=$p(MALGinfo,"^",42)
	..s NotUseReason=$s(NotUseReasonDr'="":$p(^DHCNUR(NotUseReasonDr),"^",1),1:"")
	..s InsuCatDR=$p(MALGinfo,"^",28)
	..s InsuCat=$s(InsuCatDR'="":$p(^DHCITMIC(InsuCatDR),"^",2),1:"")
	..s HighRiskFlag=$p(MALGinfo,"^",23)
	..s PackUomdr=$p(MALGinfo,"^",45)
	..s PackUom=$s(PackUomdr'="":$p(^CT("UOM",PackUomdr),"^",2),1:"")
	..s PackUomFactor=$p(MALGinfo,"^",46)
	..s PackPicPath=$p(MALGinfo,"^",44)
	..s MaxPurAmt=$p(MALGinfo,"^",35)
	..s DistribFlag=$p(MALGinfo,"^",50)
	..s Pbno=$p(MALGinfo,"^",51)
	..s ChangeRate=$p(MALGinfo,"^",39)
	..s MatQuality=$p(MALGinfo,"^",34)
	..s ReqModeLimited=$p(MALGinfo,"^",62)
	..s NoLocReq=$p(MALGinfo,"^",40)
	..s SpeFlag=$p(MALGinfo,"^",65)
	..s SterileDateLen=$p(MALGinfo,"^",69)   
	..s MedEqptCatDR=$p(MALGinfo,"^",37)
	..s MedEqptCat=$s(MedEqptCatDR'="":$p(^DHCMECAT(MedEqptCatDR),"^",2),1:"")
	..s ZeroStk=$p(MALGinfo,"^",72)
	..s SpecFlag=$p(MALGinfo,"^",64)
	..s BidDate=$p(MALGinfo,"^",43)
	..s:BidDate'="" BidDate=..DL2H(BidDate)
	..s FirstReqDeptDr=$p(MALGinfo,"^",58) 
	..s FirstReqDept=$s(FirstReqDeptDr'="":$p(^CTLOC(FirstReqDeptDr),"^",2),1:"")
	..s InsuPay=$p(MALGinfo,"^",29)
	..s InsuPrice=$p(MALGinfo,"^",30)
	..s MatCatOfficialDR=$p(MALGinfo,"^",32)
	..s MatCatOfficial=$s(MatCatOfficialDR'="":$p(^DHCMCO(MatCatOfficialDR),"^",2),1:"")
	..s MatCatClinicalDR=$p(MALGinfo,"^",31)
	..s MatCatClinical=$s(MatCatClinicalDR'="":$p(^DHCMCC(MatCatClinicalDR),"^",2),1:"")
	..s MatCatSpecialDR=$p(MALGinfo,"^",33)
	..s MatCatSpecial=$s(MatCatSpecialDR'="":$p(^DHCMCS(MatCatSpecialDR),"^",2),1:"")
	..
	..d OutPutRow
	k ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid)
	Quit $$$OK
OutPutRow
	s Data=$lb(MALGitmRowId,Incid,ChangeType,LastauditFlag,LastDWALFlag,LastDWALDate,LastDWALTime,LastDWALUser,LastDWALLevel,update,uptime,upusername,AudIncicode,AudIncidesc,AudSpec,AudIncsc,AudBaseUOM,AudPuom,AudNotUseFlag,Manf,
			brand,vendor,vendorName,registerNo,registerNoExpDate,highpriceflag,chargeflag,implantationmat,model,Supervision,Origin,regCertDateOfIssue,regItmDesc,regCertNoFull,INCIBarCode,Mtdr,MT,Abbrev,ChargeType,Sterile,
			SterCat,ReportingDays,ProlocDesc,ImportFlag,QualityLevel,ComFrom,Remark,MaxSp,InHosFlag,PbRp,PBLdesc,PbCarrier,BAflag,PBLevel,EndDate,ExpireLen,PrcFile,PrcFileD,BC,StandardCode,
			NotUseReason,InsuCat,HighRiskFlag,PackUom,PackUomFactor,PackPicPath,MaxPurAmt,DistribFlag,Pbno,ChangeRate,MatQuality,ReqModeLimited,NoLocReq,SpeFlag,SterileDateLen,MedEqptCat,ZeroStk,SpecFlag,BidDate,FirstReqDept,
			InsuPay,InsuPrice,MatCatOfficial,MatCatClinical,MatCatSpecial,ChangeTypeid,RefuseReason)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取审核人审核级别
/// 20190314 lihui
/// DHC_MatAuditLevel
/// return: 审核级别
ClassMethod GetAuditLevel(type As %String, Userid As %String) As %String
{
	n (type,Userid)
	q:((type="")||(Userid="")) 0
	s DMALrowid=$o(^DMALM(0,"TypeUser",type,Userid,""))
	s level=0
	i DMALrowid'="" d
	.s level=$p(^DMALM(DMALrowid),"^",2)
	.s ActiveFlag=$p(^DMALM(DMALrowid),"^",3)
	.i ActiveFlag'="Y" s level=0
	q +level
}

/// 获取最大审核级别
/// DHC_MatAuditLevel
/// return: 审核级别
/// w ##class(web.DHCSTMHUI.MatAudit).GetMaxAuditLevel("Basic")
ClassMethod GetMaxAuditLevel(type As %String) As %String
{
	n (type)
	q:type="" 0
	s maxlevel=0
	s level=""
	f  s level=$o(^DMALM(0,"typelevel",type,level),-1) q:(level="")||(maxlevel>0)  d
	.s DMALrowid=""
	.f  s DMALrowid=$o(^DMALM(0,"typelevel",type,level,DMALrowid)) q:(DMALrowid="")||(maxlevel>0)  d
	..s ActiveFlag=$p(^DMALM(DMALrowid),"^",3)
	..i ActiveFlag="Y" s maxlevel=level
	q maxlevel
}

/// Descript:   根据日期获取审核级别大于1的记录
/// Creater:    lihui
/// CreateDate: 20190314
/// Table: DHC_WorkAuditLog
/// Input:	
/// Output:
/// Return:	 Pid
ClassMethod AuditLevelMoreOneByDate(StartDate As %String, EndDate As %String, AuditFlag As %String, CurLevel As %String, type As %String) As %Library.String [ Private ]
{
	n (StartDate,EndDate,AuditFlag,CurLevel,type)
	s Pid=..NewPid()
	k ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid)
	
	f date=StartDate:1:EndDate  d
	.s DWALRowId=""
	.f  s DWALRowId=$o(^DHCDWAL(0,"TypeDate",type,date,DWALRowId)) q:DWALRowId=""  d
	..q:'$d(^DHCDWAL(DWALRowId))
	..s level=$p(^DHCDWAL(DWALRowId),"^",4)
	..s DWALFlag=$p(^DHCDWAL(DWALRowId),"^",7)
	..q:((AuditFlag'="Y")&&((level'=(CurLevel-1))||((level=(CurLevel-1))&&(DWALFlag'="Y"))))
	..q:((AuditFlag="Y")&&(CurLevel'=level))
	..s point=$p(^DHCDWAL(DWALRowId),"^",6)
	..s ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid,point)=""

	q Pid
}

/// Descript:   根据日期获取未审核级别为1的记录
/// Creater:    lihui
/// CreateDate: 20190314
/// Table: DHC_AuditLog
/// Input:	
/// Output:
/// Return:	 Pid
ClassMethod UnAuditLevelOneByDate(StartDate As %String, EndDate As %String, AuditFlag As %String, CurLevel As %String, type As %String) As %Library.String [ Private ]
{
	n (StartDate,EndDate,AuditFlag,CurLevel,type)
 	s Pid=..NewPid()
	k ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid)
	f date=StartDate:1:EndDate  d
	.s MALGRowId=""
	.f  s MALGRowId=$o(^DHCMALG(0,"Date",date,MALGRowId)) q:MALGRowId=""  d
	..q:'$d(^DHCMALG(MALGRowId))
	..s chl=$O(^DHCMALG(MALGRowId,"INCI",0))
	..s DHCMALGInfo=^DHCMALG(MALGRowId,"INCI",chl)
	..s inci=$P(DHCMALGInfo,"^",1)
	..s point=inci_"||"_MALGRowId
	..s DWALid=$O(^DHCDWAL(0,"TypePoint",type,point,""))
	..q:DWALid'=""
	..s ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid,MALGRowId)=""
	.
	q Pid
}

/// Descript:   无日期获取级别大于1的记录
/// Creater:    lihui
/// CreateDate: 20190314
/// Table: DHC_WorkAuditLog
/// Input:	
/// Output:
/// Return:	 Pid
ClassMethod AuditLevelMoreOne(AuditFlag As %String, CurLevel As %String, type As %String) As %Library.String [ Private ]
{
	n (AuditFlag,CurLevel,type)
	s Pid=..NewPid()
	k ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid)
	s DWALRowId=0
	f  s DWALRowId=$o(^DHCDWAL(DWALRowId)) q:DWALRowId=""  d
	.q:'$d(^DHCDWAL(DWALRowId))
	.s DWALType=$p(^DHCDWAL(DWALRowId),"^",3)
	.q:DWALType'=type
	.s level=$p(^DHCDWAL(DWALRowId),"^",4)
	.s DWALFlag=$p(^DHCDWAL(DWALRowId),"^",7)
	.q:((AuditFlag'="Y")&&(((level=(CurLevel-1))&&(DWALFlag'="Y"))||(level'=(CurLevel-1))))
	.q:((AuditFlag="Y")&&(CurLevel'=level))
	.s point=$p(^DHCDWAL(DWALRowId),"^",6)
	.s ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid,point)=""

	q Pid
}

/// Descript:   无日期获取未审核级别为1的记录
/// Creater:    lihui
/// CreateDate: 20190314
/// Table: DHC_AuditLog
/// Input:	
/// Output:
/// Return:	 Pid
ClassMethod UnAuditLevelOne(AuditFlag As %String, CurLevel As %String, type As %String) As %Library.String [ Private ]
{
	n (AuditFlag,CurLevel,type)
	s Pid=..NewPid()
	k ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid)
	s MALGRowId=0
	f  s MALGRowId=$o(^DHCMALG(MALGRowId)) q:MALGRowId=""  d
	.q:'$d(^DHCMALG(MALGRowId))
	.s chl=$O(^DHCMALG(MALGRowId,"INCI",0))
	.s DHCMALGInfo=^DHCMALG(MALGRowId,"INCI",chl)
	.s inci=$P(DHCMALGInfo,"^",1)
	.s point=inci_"||"_MALGRowId
	.s DWALid=$O(^DHCDWAL(0,"TypePoint",type,point,""))
	.q:DWALid'=""
	.s ^TMPDHCSTMHUIAUDITinfo("AuditMatInfo",Pid,MALGRowId)=""
	q Pid
}

/// Descript:   保存新增修改日志主表信息
/// Creater:    lihui
/// CreateDate: 20190516
/// Table: DHC_AuditLog
/// Input:	rowid
/// w ##class(web.DHCSTMHUI.MatAudit).AddLogMain(1)
ClassMethod AddLogMain(user As %String, BIncid As %String, IncData) As %String
{
	 n (user,BIncid,IncData)
	 q:user="" -1
	 s flag="N"
	 i BIncid'="" d
	 .s flag=..IfAddInciLog(BIncid,0,IncData)
	 q:(BIncid'="")&&(flag'="Y") 0
	 s date=+$h
	 s time=+$p($h,",",2)
	 &sql(INSERT INTO DHC_AuditLog (MALG_Date, MALG_Time, MALG_User_Dr) VALUES(:date,:time,:user))
	 q:SQLCODE -2
	 q +%ROWID
}

/// Descript:   保存新增修改日志明细信息
/// Creater:    lihui
/// CreateDate: 20190516
/// Table: DHC_AuditLog,DHC_AuditLog_INCI
/// input:日志主表ID,库存id修改前^库存项ID修改后;AU标志(2新增,0更新前,1更新后)
/// w ##class(web.DHCSTMHUI.MatAudit).AddMatLog(10,2772_"^"_2772)
ClassMethod AddMatLog(DHCLog As %String, IncRowidStr As %String, IncData = "") As %String
{
	N (DHCLog,IncRowidStr,IncData,%session)
	q:DHCLog="" -1
	s Ret=0
	s paramStr=..sssParamStr()
	s user=$p(paramStr,"^",3)
 	s mlog=DHCLog
 	s BIncId=$p(IncRowidStr,"^",1)  //B改前,A改后
 	s AIncId=$p(IncRowidStr,"^",2)
 	s IncActionFlag=""
 	i BIncId="" s IncActionFlag="2"
 	q:(IncActionFlag=2)&&(AIncId="") 0  ;新增ID没有过滤
 	i BIncId'="" d
 	.s IncActionFlag=0  ;修改前
 	.i AIncId'="" s IncActionFlag=1  ;修改后
 	i AIncId="" s AIncId=BIncId  //不论修改前后,id是不变的
 	s flag="N"
 	i IncActionFlag=0 d
 	.s flag=..IfAddInciLog(BIncId,0,IncData) 
 	q:(IncActionFlag=0)&&(flag'="Y") 1  ;没有变化则不产生记录
 	i AIncId'="" d 
 	.s Ret=..AddInciLog(user,mlog,AIncId,IncActionFlag)
 	q:+Ret<0 -2
 	q 0
}

/// Descript:   是否需要审核的物资属性
/// Creater:    lihui
/// CreateDate: 20190516
/// input: 物资属性字段
/// return:Y需要审核：否则不需要审核
ClassMethod CheckInciParam(Param As %String) As %String
{
	 n (Param)
	 s audflag=##class(web.DHCSTMHUI.InciParamRecord).CheckInciParamAudit(Param)
	 q audflag
}

/// Descript:   保存新增修改日志明细信息
/// Creater:    lihui
/// CreateDate: 20190516
/// Table: DHC_AuditLog,DHC_AuditLog_INCI
/// input:用户ID,日志主表ID,库存id,AU标志(2新增,0更新前,1更新后)
/// w ##class(web.DHCSTMHUI.MatAudit).AddInciLog(1,2,2767,0)
ClassMethod AddInciLog(user As %String, mrowid As %String, CurrRowid As %String, type As %String) As %String
{
	 ; type : 0   - Before Update
	 ; type : 1   - After Update
	 ; type : 2   - New Add
	 n (user, mrowid, CurrRowid, type)
	 q:CurrRowid="" -1
	 q:'$d(^INCI(CurrRowid,1)) -2
	 q:'$d(^INCI(CurrRowid,2)) -2
	 q:'$d(^INCI(CurrRowid,3)) -2
	 s inciinfo1=^INCI(CurrRowid,1)
	 s inciinfo2=^INCI(CurrRowid,2)
	 s inciinfo3=^INCI(CurrRowid,3)
	 s (INCICode,INCIDesc,INCICTUOMDR,INCICTUOMPurchDR,INCIINCSCDR,INCINotUseFlag,INCIBatchReq,INCIExpReq)=""
	 s (INCISterile,INCISterCatDR,INCIBarCode,INCIReportingDays,INCICTLOCDR)=""
	 s INCICode=$P(inciinfo1,"^",1)
	 s:(..CheckInciParam("INCIDesc")="Y") INCIDesc=$P(inciinfo1,"^",2)
	 s:(..CheckInciParam("INCICTUOMDR")="Y") INCICTUOMDR=$P(inciinfo1,"^",10)
	 s:(..CheckInciParam("INCICTUOMPurchDR")="Y") INCICTUOMPurchDR=$P(inciinfo3,"^",6)
	 s:(..CheckInciParam("INCIINCSCDR")="Y") INCIINCSCDR=$P(inciinfo2,"^",2)
	 s:(..CheckInciParam("INCINotUseFlag")="Y") INCINotUseFlag=$P(inciinfo2,"^",9)
	 s:(..CheckInciParam("INCIBatchReq")="Y") INCIBatchReq=$P(inciinfo2,"^",10)
	 s:(..CheckInciParam("INCIExpReq")="Y") INCIExpReq=$P(inciinfo2,"^",11)
	 s:(..CheckInciParam("INCISterile")="Y") INCISterile=$P(inciinfo2,"^",12)
	 s:(..CheckInciParam("INCISterCatDR")="Y") INCISterCatDR=$P(inciinfo2,"^",14)
	 s:(..CheckInciParam("INCIBarCode")="Y") INCIBarCode=$P(inciinfo3,"^",9)
	 s:(..CheckInciParam("INCIReportingDays")="Y") INCIReportingDays=$P(inciinfo3,"^",11)
	 s:(..CheckInciParam("INCICTLOCDR")="Y") INCICTLOCDR=$P(inciinfo2,"^",1)
	 
	 
	 s info=$o(^DHCITMINFO(0,"INCI",CurrRowid,""),-1)
	 q:info="" -3
	 q:'$d(^DHCITMINFO(info)) -3
	 s addioninfo=^DHCITMINFO(info)
	 s (INFOSpec,INFOHighPrice,INFOMTDR,INFOPbVendorDR,INFOPbManfDR,INFOImportFlag,INFOQualityLevel,INFOComFrom,INFORemark,INFOMaxSp)=""
	 s (INFOInHosFlag,INFOPbRp,INFOPBLDR,INFOPbCarrierDR,INFOBAflag,INFOPBLevel,INFOEndDate,INFOExpireLen,INFOPrcFile,INFOPrcFileD,INFOBCDr)=""
	 s (INFOStandardCode,INFONotUseReasonDr,INFOInsuCatDR,INFOHighRiskFlag,INFOPackUom,INFOPackUomFactor,INFOPackPicPath,INFOMaxPurAmt,INFODistribFlag,INFOChargeFlag)=""
	 s (INFOBrand,INFOModel,INFOAbbrev,INFOSupervision,INFOImplantationMat,INFOPbno,INFOChangeRate,INFOMatQuality,INFOReqModeLimited,INFONoLocReq,INFOSpeFlag)=""
	 s (INFOSterileDateLen,INFOMedEqptCatDR,INFOZeroStk,INFOChargeType,INFOSpecFlag,INFOTransDate,INFOBidDate,INFOFirstReqDept,INFOOrigin,INFOInsuPay,INFOInsuPrice)=""
	 s (INFOMatCatOfficialDR,INFOMatCatClinicalDR,INFOMatCatSpecialDR,INFOMatRegCertDR)=""
	 s:(..CheckInciParam("INFOSpec")="Y") INFOSpec=$P(addioninfo,"^",27)
	 s:(..CheckInciParam("INFOHighPrice")="Y") INFOHighPrice=$P(addioninfo,"^",12)
	 s:(..CheckInciParam("INFOMTDR")="Y") INFOMTDR=$P(addioninfo,"^",15)
	 s:(..CheckInciParam("INFOPbVendorDR")="Y") INFOPbVendorDR=$P(addioninfo,"^",24)
	 s:(..CheckInciParam("INFOPbManfDR")="Y") INFOPbManfDR=$P(addioninfo,"^",25)
	 s:(..CheckInciParam("INFOImportFlag")="Y") INFOImportFlag=$P(addioninfo,"^",2)
	 s:(..CheckInciParam("INFOQualityLevel")="Y") INFOQualityLevel=$P(addioninfo,"^",3)
	 s:(..CheckInciParam("INFOComFrom")="Y") INFOComFrom=$P(addioninfo,"^",9)
	 s:(..CheckInciParam("INFORemark")="Y") INFORemark=$P(addioninfo,"^",10)
	 s:(..CheckInciParam("INFOMaxSp")="Y") INFOMaxSp=$P(addioninfo,"^",16)
	 s:(..CheckInciParam("INFOInHosFlag")="Y") INFOInHosFlag=$P(addioninfo,"^",21)
	 s:(..CheckInciParam("INFOPbRp")="Y") INFOPbRp=$P(addioninfo,"^",22)
	 s:(..CheckInciParam("INFOPBLDR")="Y") INFOPBLDR=$P(addioninfo,"^",23)
	 s:(..CheckInciParam("INFOPbCarrierDR")="Y") INFOPbCarrierDR=$P(addioninfo,"^",26)
	 s:(..CheckInciParam("INFOBAflag")="Y") INFOBAflag=$P(addioninfo,"^",29)
	 s:(..CheckInciParam("INFOPBLevel")="Y") INFOPBLevel=$P(addioninfo,"^",30)
	 s:(..CheckInciParam("INFOEndDate")="Y") INFOEndDate=$P(addioninfo,"^",31)
	 s:(..CheckInciParam("INFOExpireLen")="Y") INFOExpireLen=$P(addioninfo,"^",32)
	 s:(..CheckInciParam("INFOPrcFile")="Y") INFOPrcFile=$P(addioninfo,"^",33)
	 s:(..CheckInciParam("INFOPrcFileD")="Y") INFOPrcFileD=$P(addioninfo,"^",34)
	 s:(..CheckInciParam("INFOBCDr")="Y") INFOBCDr=$P(addioninfo,"^",36)
	 s:(..CheckInciParam("INFOStandardCode")="Y") INFOStandardCode=$P(addioninfo,"^",44)
	 s:(..CheckInciParam("INFONotUseReasonDr")="Y") INFONotUseReasonDr=$P(addioninfo,"^",47)
	 s:(..CheckInciParam("INFOInsuCatDR")="Y") INFOInsuCatDR=$P(addioninfo,"^",49)
	 s:(..CheckInciParam("INFOHighRiskFlag")="Y") INFOHighRiskFlag=$P(addioninfo,"^",50)
	 s:(..CheckInciParam("INFOPackUom")="Y") INFOPackUom=$P(addioninfo,"^",51)
	 s:(..CheckInciParam("INFOPackUomFactor")="Y") INFOPackUomFactor=$P(addioninfo,"^",52)
	 s:(..CheckInciParam("INFOPackPicPath")="Y") INFOPackPicPath=$P(addioninfo,"^",53)
	 s:(..CheckInciParam("INFOMaxPurAmt")="Y") INFOMaxPurAmt=$P(addioninfo,"^",54)
	 s:(..CheckInciParam("INFODistribFlag")="Y") INFODistribFlag=$P(addioninfo,"^",55)
	 s:(..CheckInciParam("INFOChargeFlag")="Y") INFOChargeFlag=$P(addioninfo,"^",57)
	s:(..CheckInciParam("INFOBrand")="Y") INFOBrand=$P(addioninfo,"^",58)
	s:(..CheckInciParam("INFOModel")="Y") INFOModel=$P(addioninfo,"^",59)
	s:(..CheckInciParam("INFOAbbrev")="Y") INFOAbbrev=$P(addioninfo,"^",60)
	s:(..CheckInciParam("INFOSupervision")="Y") INFOSupervision=$P(addioninfo,"^",61)
	s:(..CheckInciParam("INFOImplantationMat")="Y") INFOImplantationMat=$P(addioninfo,"^",62)
	s:(..CheckInciParam("INFOPbno")="Y") INFOPbno=$P(addioninfo,"^",63)
	s:(..CheckInciParam("INFOChangeRate")="Y") INFOChangeRate=$P(addioninfo,"^",64)
	s:(..CheckInciParam("INFOMatQuality")="Y") INFOMatQuality=$P(addioninfo,"^",71)
	s:(..CheckInciParam("INFOReqModeLimited")="Y") INFOReqModeLimited=$P(addioninfo,"^",73)
	s:(..CheckInciParam("INFONoLocReq")="Y") INFONoLocReq=$P(addioninfo,"^",74)
	s:(..CheckInciParam("INFOSpeFlag")="Y") INFOSpeFlag=$P(addioninfo,"^",76)
	s:(..CheckInciParam("INFOSterileDateLen")="Y") INFOSterileDateLen=$P(addioninfo,"^",79)
	s:(..CheckInciParam("INFOMedEqptCatDR")="Y") INFOMedEqptCatDR=$P(addioninfo,"^",80)
	s:(..CheckInciParam("INFOZeroStk")="Y") INFOZeroStk=$P(addioninfo,"^",81)
	s:(..CheckInciParam("INFOChargeType")="Y") INFOChargeType=$P(addioninfo,"^",82)
	s:(..CheckInciParam("INFOSpecFlag")="Y") INFOSpecFlag=$P(addioninfo,"^",96)
	s:(..CheckInciParam("INFOTransDate")="Y") INFOTransDate=$P(addioninfo,"^",97)
	s:(..CheckInciParam("INFOBidDate")="Y") INFOBidDate=$P(addioninfo,"^",98)
	s:(..CheckInciParam("INFOFirstReqDept")="Y") INFOFirstReqDept=$P(addioninfo,"^",99)
	s:(..CheckInciParam("INFOOrigin")="Y") INFOOrigin=$P(addioninfo,"^",100)
	s:(..CheckInciParam("INFOInsuPay")="Y") INFOInsuPay=$P(addioninfo,"^",101)
	s:(..CheckInciParam("INFOInsuPrice")="Y") INFOInsuPrice=$P(addioninfo,"^",102)
	s:(..CheckInciParam("INFOMatCatOfficialDR")="Y") INFOMatCatOfficialDR=$P(addioninfo,"^",107)
	s:(..CheckInciParam("INFOMatCatClinicalDR")="Y") INFOMatCatClinicalDR=$P(addioninfo,"^",108)
	s:(..CheckInciParam("INFOMatCatSpecialDR")="Y") INFOMatCatSpecialDR=$P(addioninfo,"^",109)
	 
	s:..CheckInciParam("INFOMatRegCertDR")="Y" INFOMatRegCertDR=$p(^DHCITMINFO(info,1),"^",18)
	
	 i mrowid="" d
	 .s tmpCurrRowid=""
	 .i type=0 s tmpCurrRowid=CurrRowid  ;修改前才传库存项ID  修改操作才判断需要审核的属性值是否存在修改
	 .s mrowid=..AddLogMain(user,tmpCurrRowid)
	 .s mrowid=+mrowid
	 q:mrowid<0 -4
 
	 s ch=0,AuditFlag="N"
	 s ch=$o(^DHCMALG(mrowid,"INCI",""),-1)
	 s ch=ch+1
	 &sql(INSERT INTO DHC_AuditLog_INCI 
	 	(MALG_INCI_Parref, MALG_INCI_ChildSub,MALG_INCI_Dr, MALG_INCI_Code, MALG_INCI_Desc, MALG_INCI_Spec,MALG_ChangeType,MALG_INCI_AuditFlag,MALG_INCI_BuomDr, MALG_INCI_PuomDr,
	 	MALG_INCI_INCSCdr,MALG_INCI_NotUseFlag,MALG_INCI_HighPrice,MALG_INCI_MTDR,MALG_INCI_PbVendor,MALG_INCI_PbManf,MALG_INCI_Model,MALG_INCI_Brand,MALG_INCI_Abbrev,MALG_INCI_ChargeType,
	 	MALG_INCI_ChargeFlag,MALG_INCI_Origin,MALG_INCI_TransDate,MALG_INCI_Sterile,MALG_INCI_SterCatDR,MALG_INCI_BarCode,MALG_INCI_ReportingDays,MALG_INCI_CTLOCDR,
	 	MALG_INCI_ImportFlag,MALG_INCI_QualityLevel,MALG_INCI_ComFrom,MALG_INCI_Remark,MALG_INCI_MaxSp,MALG_INCI_InHosFlag,MALG_INCI_PbRp,MALG_INCI_PBLDR,MALG_INCI_PbCarrierDR,MALG_INCI_BAflag,
	 	MALG_INCI_PBLevel,MALG_INCI_EndDate,MALG_INCI_ExpireLen,MALG_INCI_PrcFile,MALG_INCI_PrcFileD,MALG_INCI_BCDr,MALG_INCI_StandardCode,MALG_INCI_NotUseReasonDr,MALG_INCI_InsuCatDR,MALG_INCI_HighRiskFlag,
	 	MALG_INCI_PackUom,MALG_INCI_PackUomFactor,MALG_INCI_PackPicPath,MALG_INCI_MaxPurAmt,MALG_INCI_DistribFlag,MALG_INCI_Supervision,MALG_INCI_ImplantationMat,MALG_INCI_Pbno,MALG_INCI_ChangeRate,MALG_INCI_MatQuality,
	 	MALG_INCI_ReqModeLimited,MALG_INCI_NoLocReq,MALG_INCI_SpeFlag,MALG_INCI_SterileDateLen,MALG_INCI_MedEqptCatDR,MALG_INCI_ZeroStk,MALG_INCI_SpecFlag,MALG_INCI_BidDate,MALG_INCI_FirstReqDept,MALG_INCI_InsuPay,
	 	MALG_INCI_InsuPrice,MALG_INCI_MatCatOfficialDR,MALG_INCI_MatCatClinicalDR,MALG_INCI_MatCatSpecialDR,MALG_INCI_RegNo) 
	 	VALUES
	 	(:mrowid,:ch,:CurrRowid,:INCICode,:INCIDesc,:INFOSpec,:type,:AuditFlag,:INCICTUOMDR,:INCICTUOMPurchDR,
	 	:INCIINCSCDR,:INCINotUseFlag,:INFOHighPrice,:INFOMTDR,:INFOPbVendorDR,:INFOPbManfDR,:INFOModel,:INFOBrand,:INFOAbbrev,:INFOChargeType,
	 	:INFOChargeFlag,:INFOOrigin,:INFOTransDate,:INCISterile,:INCISterCatDR,:INCIBarCode,:INCIReportingDays,:INCICTLOCDR,
	 	:INFOImportFlag,:INFOQualityLevel,:INFOComFrom,:INFORemark,:INFOMaxSp,:INFOInHosFlag,:INFOPbRp,:INFOPBLDR,:INFOPbCarrierDR,:INFOBAflag,
	 	:INFOPBLevel,:INFOEndDate,:INFOExpireLen,:INFOPrcFile,:INFOPrcFileD,:INFOBCDr,:INFOStandardCode,:INFONotUseReasonDr,:INFOInsuCatDR,:INFOHighRiskFlag,
	 	:INFOPackUom,:INFOPackUomFactor,:INFOPackPicPath,:INFOMaxPurAmt,:INFODistribFlag,:INFOSupervision,:INFOImplantationMat,:INFOPbno,:INFOChangeRate,:INFOMatQuality,
	 	:INFOReqModeLimited,:INFONoLocReq,:INFOSpeFlag,:INFOSterileDateLen,:INFOMedEqptCatDR,:INFOZeroStk,:INFOSpecFlag,:INFOBidDate,:INFOFirstReqDept,:INFOInsuPay,
	 	:INFOInsuPrice,:INFOMatCatOfficialDR,:INFOMatCatClinicalDR,:INFOMatCatSpecialDR,:INFOMatRegCertDR))
	 q:SQLCODE'=0 -5
	 q %ROWID
}

/// Descript:   审核
/// Creater:    lihui
/// CreateDate: 20200706
/// w ##class(web.DHCSTMHUI.MatAudit).jsAudit("48478@1||1^48478@1||2")
ClassMethod jsAudit(Params As %String) As %Library.String
{
    n (Params,%session)
    s $ZT=..sssError()
    s RtnObj=##class(RtnObj).%New()
    s RtnObj=..AuditStr(Params)
    q RtnObj.Json()
}

/// Descript:   审核
/// Creater:    lihui
/// CreateDate: 20190519
/// Update: 20200705
/// Table: DHC_AuditLog,DHC_AuditLog_INCI,DHC_WorkAuditLog
/// Input		
/// Output
/// w ##class(web.DHCSTMHUI.MatAudit).AuditStr("2772@10||1^2772@10||2")
ClassMethod AuditStr(Params As %String) As %String
{
	n (%session,Params)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s IdStr=PJObj.%Get("RowIdStr")
	s User=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	
	if (User="") d RtnObj.Err(-1,"","用户不能为空","",0)
	q:RtnObj.success'=0 RtnObj
	s type="Basic"
	s level=..GetAuditLevel(type,User)
	if (level<1) d RtnObj.Err(-2,"","您无审核权限！","",0)
	q:RtnObj.success'=0 RtnObj
	
	s date=+$h
	s time=$p($h,",",2)
	s len=$l(IdStr,"^")
	tstart
	f i=1:1:len  q:RtnObj.success'=0  d
	.s str=$p(IdStr,"^",i)
	.s inci=$p(str,"@",1)
	.q:+inci'>0
	.s InciDesc=$p(^INCI(inci,1),"^",2)
	.s LoginciId=$p(str,"@",2) ;修改日志明细ID
	.s LogId=+LoginciId  ;修改日志ID
	.q:+LogId'>0
	.s Notuseflag=$p($g(^INCI(inci,2)),"^",9)
	.s tmpNotuseflag="N"
	.i $d(^DHCMALG(LogId,"INCI")) d
	..s sub=$o(^DHCMALG(LogId,"INCI",""),-1)
	..s tmpNotuseflag=$p(^DHCMALG(LogId,"INCI",sub),"^",6)
	.s point=inci_"||"_LogId
	.s auditlev=0
	.s auditid=$o(^DHCDWAL(0,"TypePoint",type,point,""),-1) //修改新增信息最新审核状态
	.i auditid'="" s auditlev=+$p($g(^DHCDWAL(auditid)),"^",4)      
	.if (auditlev'<level) d RtnObj.Err(-3,"",InciDesc_" 您已经审核！","",0)
	.q:RtnObj.success'=0
	.s lastaudlevel=..IfLastLevelAudit(point,User)
	.if (lastaudlevel'="Y") d RtnObj.Err(-4,"",InciDesc_" 您上一级未审核！","",0)
	.q:RtnObj.success'=0
	.;s maxlev=$o(^DMALM(0,"typelevel",type,""),-1)
	.s maxlev=..GetMaxAuditLevel(type)
	.//当此次为最后一条审核记录时,且为最大级别,更新可用状态
	.s AuditFlag="Y"
	.i (maxlev=level) d
	..&SQL(UPDATE DHC_AuditLog_INCI SET MALG_INCI_AuditFlag=:AuditFlag WHERE MALG_INCI_Parref=:LogId)
	..i SQLCODE'=0  d RtnObj.Err(-5,"",InciDesc_" 更新审核状态失败！")
	.q:RtnObj.success'=0
	.i (maxlev=level)&&('$d(^DHCMALG(0,"INCIAUDIT",inci,"N",LogId)))  d
	..if tmpNotuseflag="" s tmpNotuseflag="N"
	..s $p(^INCI(inci,2),"^",9)=tmpNotuseflag  //最大权限时置可用状态
	..;最后审核完成则同步商品信息
	..d ##class(web.DHCSTMHUI.ServiceForSCI).getHopInc(inci)
	..d ##class(web.DHCSTMHUI.ServiceForECS).updateHosInv(inci,HospId)
	..d ##class(web.DHCSTMHUI.ServiceForLis).SynInciInfo(inci,HospId)
	.;判断是否需要插入记录,以免重复插入,审核级别+point+type确定唯一记录
	.s tmpauditid="",distinct=""
	.f  s tmpauditid=$o(^DHCDWAL(0,"TypePoint",type,point,tmpauditid)) q:tmpauditid=""  d
	..s tmplevel=$p($g(^DHCDWAL(tmpauditid)),"^",4)
	..s tmpdate=$p($g(^DHCDWAL(tmpauditid)),"^",1)
	..s LastAuditId=$o(^DHCDWAL(0,"TypePoint",type,point,""),-1)
	..s LastAuditdate=$p($g(^DHCDWAL(LastAuditId)),"^",1)
	..i (tmplevel=level)&&(tmpdate=LastAuditdate) s distinct="1"
	..q:distinct'=""
	.q:distinct'=""
	.&sql(INSERT INTO DHC_WorkAuditLog (DWAL_Date, DWAL_Time, DWAL_Type, DWAL_Point, DWAL_User_Dr, DWAL_Level, DWAL_Flag)
			VALUES(:date, :time, :type, :point,:User,:level,:AuditFlag)) 
	.i SQLCODE d RtnObj.Err(-7,"",InciDesc_" 插入审核记录失败！") 

	i RtnObj.success'=0  tro  q RtnObj
	tcommit
	q RtnObj
}

/// Descript:   拒绝
/// Creater:    lihui
/// CreateDate: 20200706
/// w ##class(web.DHCSTMHUI.MatAudit).jsAuditNo()
ClassMethod jsAuditNo(Params As %String) As %Library.String
{
    n (Params,%session)
    s $ZT=..sssError()
    s RtnObj=##class(RtnObj).%New()
    s RtnObj=..AuditNoStr(Params)
    q RtnObj.Json()
}

/// Descript:   拒绝
/// Creater:    lihui
/// CreateDate: 20190520
/// Update: 20200705
/// Table: DHC_AuditLog,DHC_AuditLog_INCI,DHC_WorkAuditLog
/// Input		
/// Output
/// w ##class(web.DHCSTMHUI.MatAudit).AuditNoStr("2777@12||1^2777@12||2")
ClassMethod AuditNoStr(Params As %String) As %String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s IdStr=PJObj.%Get("RowIdStr")
	s User=PJObj.%Get("gUserId")
	
	if (User="") d RtnObj.Err(-1,"","用户不能为空","",0)
	q:RtnObj.success'=0 RtnObj
	s type="Basic"
	s level=..GetAuditLevel(type,User)
	if (level<1) d RtnObj.Err(-2,"","您无审核权限！","",0)
	q:RtnObj.success'=0 RtnObj
	s date=+$h
	s time=$p($h,",",2)
	s len=$l(IdStr,"^")
	s ret=0
	tstart
	f i=1:1:len  q:RtnObj.success'=0  d
	.s str=$p(IdStr,"^",i)
	.s inci=$p(str,"@",1)
	.q:+inci'>0
	.s InciDesc=$p(^INCI(inci,1),"^",2)
	.s LoginciId=$p(str,"@",2) ;修改日志明细ID
	.s LogId=+LoginciId  ;修改日志ID
	.s RefuseReason=$p(str,"@",3) ;拒绝理由
	.s Notuseflag=$p($g(^INCI(inci,2)),"^",9)
	.s tmpNotuseflag="N"
	.i $d(^DHCMALG(LogId,"INCI")) d
	..s sub=$o(^DHCMALG(LogId,"INCI",""),-1)
	..s tmpNotuseflag=$p(^DHCMALG(LogId,"INCI",sub),"^",6)
	.s point=inci_"||"_LogId
	.s auditlev=0
	.s auditid=$o(^DHCDWAL(0,"TypePoint",type,point,""),-1) //修改新增信息最新审核状态
	.i auditid'="" s auditlev=+$p($g(^DHCDWAL(auditid)),"^",4)
	.if (auditlev'<level) d RtnObj.Err(-3,"",InciDesc_" 您已经审核！","",0)
	.q:RtnObj.success'=0
	.s lastaudlevel=..IfLastLevelAudit(point,User)
	.if (lastaudlevel'="Y") d RtnObj.Err(-4,"",InciDesc_" 上一级未审核！","",0)
	.q:RtnObj.success'=0
	.;s maxlev=$o(^DMALM(0,"typelevel",type,""),-1)
	.s maxlev=..GetMaxAuditLevel(type)
	.//当此次为最后一条审核记录时,且为最大级别,更新是否可用的状态
	.s AuditFlag="N"
	.&SQL(UPDATE DHC_AuditLog_INCI SET MALG_INCI_AuditFlag=:AuditFlag WHERE MALG_INCI_Parref=:LogId)
	.i SQLCODE'=0  d RtnObj.Err(-5,"",InciDesc_" 更新审核状态失败！")
	.q:RtnObj.success'=0
	.;还原修改记录
	.s ret=..RecoveryInfoByDHCLog(str)
	.i ret'=0  d RtnObj.Err(-6,"",InciDesc_" 还原修改记录失败！")
	.q:RtnObj.success'=0
	.;判断是否需要插入记录,以免重复插入,审核级别+point+type确定唯一记录
	.s tmpauditid="",distinct=""
	.f  s tmpauditid=$o(^DHCDWAL(0,"TypePoint",type,point,tmpauditid)) q:tmpauditid=""  d
	..s tmplevel=$p($g(^DHCDWAL(tmpauditid)),"^",4)
	..i tmplevel=level s distinct="1"
	..i RefuseReason'="" d
	...&sql(UPDATE DHC_WorkAuditLog SET DWAL_RefuseReason=:RefuseReason WHERE DWAL_RowId=:tmpauditid)
	..q:distinct'=""
	.q:distinct'=""
	.&sql(INSERT INTO DHC_WorkAuditLog (DWAL_Date, DWAL_Time, DWAL_Type, DWAL_Point, DWAL_User_Dr, DWAL_Level, DWAL_Flag)
    VALUES(:date, :time, :type, :point,:User,:level,:AuditFlag)) 
    .i SQLCODE d RtnObj.Err(-6,"",InciDesc_" 插入审核记录失败！") 
    .s auditid=$p($g(%ROWID),$c(1))
    .i RefuseReason'="" d
    ..&sql(UPDATE DHC_WorkAuditLog SET DWAL_RefuseReason=:RefuseReason WHERE DWAL_RowId=:auditid)
    .
    .;审核不通过都改为不可用
    .s tmpNotuseflag="Y"
    .s $p(^INCI(inci,2),"^",9)=tmpNotuseflag
    .
    i RtnObj.success'=0  tro  q RtnObj 
    tcommit
	q RtnObj
}

/// Descript:   审核不通过还原修改信息
/// Creater:    lihui
/// CreateDate: 20190520
/// Table: DHC_AuditLog,DHC_AuditLog_INCI,DHC_WorkAuditLog,INC_Itm,DHC_ItmAddionInfo
/// Input: 库存项ID,修改日志明细ID	
/// Output
/// w ##class(web.DHCSTMHUI.MatAudit).RecoveryInfoByDHCLog()
ClassMethod RecoveryInfoByDHCLog(InfoStr As %String) As %String
{
	n (InfoStr)
	q:InfoStr="" -1
	s inci=$p(InfoStr,"@",1)
	q:inci="" -2
	s LogitmId=$p(InfoStr,"@",2)
	q:LogitmId="" -3
	s LogId=+LogitmId
	s chl=$p(LogitmId,"||",2)
	s inciinfo1=$g(^INCI(inci,1))
	s inciinfo2=$g(^INCI(inci,2))
	s inciinfo3=$g(^INCI(inci,3))
	s info=$o(^DHCITMINFO(0,"INCI",inci,""),-1)
	s addioninfo=$g(^DHCITMINFO(info))
	s ret=0
	i $d(^DHCMALG(LogId,"INCI",chl)) d
	.q:$p(^DHCMALG(LogId,"INCI",chl),"^",2)'=0  ;非修改前记录过滤
	.s Bincinfo=^DHCMALG(LogId,"INCI",chl)
	.s INCICode=$P(inciinfo1,"^",1),INCIDesc=$P(inciinfo1,"^",2),INCICTUOMDR=$P(inciinfo1,"^",10),INCICTUOMPurchDR=$P(inciinfo3,"^",6),INCIINCSCDR=$P(inciinfo2,"^",2)
	.s INCINotUseFlag=$P(inciinfo2,"^",9),INCISterile=$P(inciinfo2,"^",12),INCISterCatDR=$P(inciinfo2,"^",14),INCIBarCode=$P(inciinfo3,"^",9),INCIReportingDays=$P(inciinfo3,"^",11)
	.s INCICTLOCDR=$P(inciinfo2,"^",1)
	.s:(..CheckInciParam("INCICode")="Y") INCICode=$p(Bincinfo,"^",3)
	.s:(..CheckInciParam("INCIDesc")="Y") INCIDesc=$p(Bincinfo,"^",4)
	.s:(..CheckInciParam("INCICTUOMDR")="Y") INCICTUOMDR=$p(Bincinfo,"^",7)
	.s:(..CheckInciParam("INCICTUOMPurchDR")="Y") INCICTUOMPurchDR=$p(Bincinfo,"^",8)
	.s:(..CheckInciParam("INCIINCSCDR")="Y") INCIINCSCDR=$p(Bincinfo,"^",5)
	.s:(..CheckInciParam("INCINotUseFlag")="Y") INCINotUseFlag=$p(Bincinfo,"^",6)
	.s:(..CheckInciParam("INCISterile")="Y") INCISterile=$P(Bincinfo,"^",68)
	.s:(..CheckInciParam("INCISterCatDR")="Y") INCISterCatDR=$P(Bincinfo,"^",67)
	.s:(..CheckInciParam("INCIBarCode")="Y") INCIBarCode=$P(Bincinfo,"^",26)
	.s:(..CheckInciParam("INCIReportingDays")="Y") INCIReportingDays=$P(Bincinfo,"^",61)
	.s:(..CheckInciParam("INCICTLOCDR")="Y") INCICTLOCDR=$P(Bincinfo,"^",56)
	.
	.s INFOSpec=$P(addioninfo,"^",27),INFOHighPrice=$P(addioninfo,"^",12),INFOMTDR=$P(addioninfo,"^",15),INFOPbVendorDR=$P(addioninfo,"^",24),INFOPbManfDR=$P(addioninfo,"^",25)
	.s INFOImportFlag=$P(addioninfo,"^",2),INFOQualityLevel=$P(addioninfo,"^",3),INFOComFrom=$P(addioninfo,"^",9),INFORemark=$P(addioninfo,"^",10),INFOMaxSp=$P(addioninfo,"^",16)
	.s INFOInHosFlag=$P(addioninfo,"^",21),INFOPbRp=$P(addioninfo,"^",22),INFOPBLDR=$P(addioninfo,"^",23),INFOPbCarrierDR=$P(addioninfo,"^",26),INFOBAflag=$P(addioninfo,"^",29)
	.s INFOPBLevel=$P(addioninfo,"^",30),INFOEndDate=$P(addioninfo,"^",31),INFOExpireLen=$P(addioninfo,"^",32),INFOPrcFile=$P(addioninfo,"^",33),INFOPrcFileD=$P(addioninfo,"^",34)
	.s INFOBCDr=$P(addioninfo,"^",36),INFOStandardCode=$P(addioninfo,"^",44),INFONotUseReasonDr=$P(addioninfo,"^",47),INFOInsuCatDR=$P(addioninfo,"^",49),INFOHighRiskFlag=$P(addioninfo,"^",50)
	.s INFOPackUom=$P(addioninfo,"^",51),INFOPackUomFactor=$P(addioninfo,"^",52),INFOPackPicPath=$P(addioninfo,"^",53),INFOMaxPurAmt=$P(addioninfo,"^",54),INFODistribFlag=$P(addioninfo,"^",55)
	.s INFOChargeFlag=$P(addioninfo,"^",57),INFOBrand=$P(addioninfo,"^",58),INFOModel=$P(addioninfo,"^",59),INFOAbbrev=$P(addioninfo,"^",60),INFOSupervision=$P(addioninfo,"^",61)
	.s INFOImplantationMat=$P(addioninfo,"^",62),INFOPbno=$P(addioninfo,"^",63),INFOChangeRate=$P(addioninfo,"^",64),INFOMatQuality=$P(addioninfo,"^",71),INFOReqModeLimited=$P(addioninfo,"^",73)
	.s INFONoLocReq=$P(addioninfo,"^",74),INFOSpeFlag=$P(addioninfo,"^",76),INFOSterileDateLen=$P(addioninfo,"^",79),INFOMedEqptCatDR=$P(addioninfo,"^",80),INFOZeroStk=$P(addioninfo,"^",81)
	.s INFOChargeType=$P(addioninfo,"^",82),INFOSpecFlag=$P(addioninfo,"^",96),INFOTransDate=$P(addioninfo,"^",97),INFOBidDate=$P(addioninfo,"^",98),INFOFirstReqDept=$P(addioninfo,"^",99)
	.s INFOOrigin=$P(addioninfo,"^",100),INFOInsuPay=$P(addioninfo,"^",101),INFOInsuPrice=$P(addioninfo,"^",102),INFOMatCatOfficialDR=$P(addioninfo,"^",107),INFOMatCatClinicalDR=$P(addioninfo,"^",108)
	.s INFOMatCatSpecialDR=$P(addioninfo,"^",109)
	.s INFOMatRegCertDR=$p(^DHCITMINFO(info,1),"^",18)
	.s:(..CheckInciParam("INFOSpec")="Y") INFOSpec=$p(Bincinfo,"^",13)
	.s:(..CheckInciParam("INFOHighPrice")="Y") INFOHighPrice=$p(Bincinfo,"^",9)
	.s:(..CheckInciParam("INFOMTDR")="Y") INFOMTDR=$p(Bincinfo,"^",10)
	.s:(..CheckInciParam("INFOPbVendorDR")="Y") INFOPbVendorDR=$p(Bincinfo,"^",11)
	.s:(..CheckInciParam("INFOPbManfDR")="Y") INFOPbManfDR=$p(Bincinfo,"^",12)
	.s:(..CheckInciParam("INFOImportFlag")="Y") INFOImportFlag=$P(Bincinfo,"^",25)
	.s:(..CheckInciParam("INFOQualityLevel")="Y") INFOQualityLevel=$P(Bincinfo,"^",57)
	.s:(..CheckInciParam("INFOComFrom")="Y") INFOComFrom=$P(Bincinfo,"^",38)
	.s:(..CheckInciParam("INFORemark")="Y") INFORemark=$P(Bincinfo,"^",60)
	.s:(..CheckInciParam("INFOMaxSp")="Y") INFOMaxSp=$P(Bincinfo,"^",36)
	.s:(..CheckInciParam("INFOInHosFlag")="Y") INFOInHosFlag=$P(Bincinfo,"^",27)
	.s:(..CheckInciParam("INFOPbRp")="Y") INFOPbRp=$P(Bincinfo,"^",52)
	.s:(..CheckInciParam("INFOPBLDR")="Y") INFOPBLDR=$P(Bincinfo,"^",48)
	.s:(..CheckInciParam("INFOPbCarrierDR")="Y") INFOPbCarrierDR=$P(Bincinfo,"^",47)
	.s:(..CheckInciParam("INFOBAflag")="Y") INFOBAflag=$P(Bincinfo,"^",63)
	.s:(..CheckInciParam("INFOPBLevel")="Y") INFOPBLevel=$P(Bincinfo,"^",49)
	.s:(..CheckInciParam("INFOEndDate")="Y") INFOEndDate=$P(Bincinfo,"^",71)
	.s:(..CheckInciParam("INFOExpireLen")="Y") INFOExpireLen=$P(Bincinfo,"^",59)
	.s:(..CheckInciParam("INFOPrcFile")="Y") INFOPrcFile=$P(Bincinfo,"^",54)
	.s:(..CheckInciParam("INFOPrcFileD")="Y") INFOPrcFileD=$P(Bincinfo,"^",55)
	.s:(..CheckInciParam("INFOBCDr")="Y") INFOBCDr=$P(Bincinfo,"^",41)
	.s:(..CheckInciParam("INFOStandardCode")="Y") INFOStandardCode=$P(Bincinfo,"^",66)
	.s:(..CheckInciParam("INFONotUseReasonDr")="Y") INFONotUseReasonDr=$P(Bincinfo,"^",42)
	.s:(..CheckInciParam("INFOInsuCatDR")="Y") INFOInsuCatDR=$P(Bincinfo,"^",28)
	.s:(..CheckInciParam("INFOHighRiskFlag")="Y") INFOHighRiskFlag=$P(Bincinfo,"^",23)
	.s:(..CheckInciParam("INFOPackUom")="Y") INFOPackUom=$P(Bincinfo,"^",45)
	.s:(..CheckInciParam("INFOPackUomFactor")="Y") INFOPackUomFactor=$P(Bincinfo,"^",46)
	.s:(..CheckInciParam("INFOPackPicPath")="Y") INFOPackPicPath=$P(Bincinfo,"^",44)
	.s:(..CheckInciParam("INFOMaxPurAmt")="Y") INFOMaxPurAmt=$P(Bincinfo,"^",35)
	.s:(..CheckInciParam("INFODistribFlag")="Y") INFODistribFlag=$P(Bincinfo,"^",50)
	.s:(..CheckInciParam("INFOChargeFlag")="Y") INFOChargeFlag=$P(Bincinfo,"^",53)
	.s:(..CheckInciParam("INFOBrand")="Y") INFOBrand=$P(Bincinfo,"^",15)
	.s:(..CheckInciParam("INFOModel")="Y") INFOModel=$P(Bincinfo,"^",14)
	.s:(..CheckInciParam("INFOAbbrev")="Y") INFOAbbrev=$P(Bincinfo,"^",16)
	.s:(..CheckInciParam("INFOSupervision")="Y") INFOSupervision=$P(Bincinfo,"^",70)
	.s:(..CheckInciParam("INFOImplantationMat")="Y") INFOImplantationMat=$P(Bincinfo,"^",24)
	.s:(..CheckInciParam("INFOPbno")="Y") INFOPbno=$P(Bincinfo,"^",51)
	.s:(..CheckInciParam("INFOChangeRate")="Y") INFOChangeRate=$P(Bincinfo,"^",39)
	.s:(..CheckInciParam("INFOMatQuality")="Y") INFOMatQuality=$P(Bincinfo,"^",34)
	.s:(..CheckInciParam("INFOReqModeLimited")="Y") INFOReqModeLimited=$P(Bincinfo,"^",62)
	.s:(..CheckInciParam("INFONoLocReq")="Y") INFONoLocReq=$P(Bincinfo,"^",40)
	.s:(..CheckInciParam("INFOSpeFlag")="Y") INFOSpeFlag=$P(Bincinfo,"^",65)
	.s:(..CheckInciParam("INFOSterileDateLen")="Y") INFOSterileDateLen=$P(Bincinfo,"^",69)
	.s:(..CheckInciParam("INFOMedEqptCatDR")="Y") INFOMedEqptCatDR=$P(Bincinfo,"^",37)
	.s:(..CheckInciParam("INFOZeroStk")="Y") INFOZeroStk=$P(Bincinfo,"^",72)
	.s:(..CheckInciParam("INFOChargeType")="Y") INFOChargeType=$P(Bincinfo,"^",17)
	.s:(..CheckInciParam("INFOSpecFlag")="Y") INFOSpecFlag=$P(Bincinfo,"^",64)
	.s:(..CheckInciParam("INFOTransDate")="Y") INFOTransDate=$P(Bincinfo,"^",19)
	.s:(..CheckInciParam("INFOBidDate")="Y") INFOBidDate=$P(Bincinfo,"^",43)
	.s:(..CheckInciParam("INFOFirstReqDept")="Y") INFOFirstReqDept=$P(Bincinfo,"^",58)
	.s:(..CheckInciParam("INFOOrigin")="Y") INFOOrigin=$P(Bincinfo,"^",18)
	.s:(..CheckInciParam("INFOInsuPay")="Y") INFOInsuPay=$P(Bincinfo,"^",29)
	.s:(..CheckInciParam("INFOInsuPrice")="Y") INFOInsuPrice=$P(Bincinfo,"^",30)
	.s:(..CheckInciParam("INFOMatCatOfficialDR")="Y") INFOMatCatOfficialDR=$P(Bincinfo,"^",32)
	.s:(..CheckInciParam("INFOMatCatClinicalDR")="Y") INFOMatCatClinicalDR=$P(Bincinfo,"^",31)
	.s:(..CheckInciParam("INFOMatCatSpecialDR")="Y") INFOMatCatSpecialDR=$P(Bincinfo,"^",33)
	.s:(..CheckInciParam("INFOMatRegCertDR")="Y") INFOMatRegCertDR=$P(Bincinfo,"^",20)
	.
	.i info'="" d
	..&SQL(UPDATE DHC_ItmAddionInfo SET INFO_Spec=:INFOSpec,INFO_HighPrice=:INFOHighPrice,INFO_MT_DR=:INFOMTDR,INFO_PbVendor_DR=:INFOPbVendorDR,INFO_PbManf_DR=:INFOPbManfDR,INFO_ImportFlag=:INFOImportFlag,INFO_QualityLevel=:INFOQualityLevel,INFO_ComFrom=:INFOComFrom,INFO_Remark=:INFORemark,INFO_MaxSp=:INFOMaxSp,
		INFO_InHos_Flag=:INFOInHosFlag,INFO_PbRp=:INFOPbRp,INFO_PbCarrier_DR=:INFOPbCarrierDR,INFO_BA_flag=:INFOBAflag,INFO_PBLevel=:INFOPBLevel,INFO_EndDate=:INFOEndDate,INFO_ExpireLen=:INFOExpireLen,INFO_PrcFile=:INFOPrcFile,INFO_PrcFileD=:INFOPrcFileD,INFO_BC_Dr=:INFOBCDr,
		INFO_StandardCode=:INFOStandardCode,INFO_NotUseReason_Dr=:INFONotUseReasonDr,INFO_InsuCat_DR=:INFOInsuCatDR,INFO_HighRiskFlag=:INFOHighRiskFlag,INFO_PackUom=:INFOPackUom,INFO_PackUomFactor=:INFOPackUomFactor,INFO_PackPicPath=:INFOPackPicPath,INFO_MaxPurAmt=:INFOMaxPurAmt,INFO_DistribFlag=:INFODistribFlag,INFO_ChargeFlag=:INFOChargeFlag,
		INFO_Brand=:INFOBrand,INFO_Model=:INFOModel,INFO_Abbrev=:INFOAbbrev,INFO_Supervision=:INFOSupervision,INFO_ImplantationMat=:INFOImplantationMat,INFO_Pbno=:INFOPbno,INFO_ChangeRate=:INFOChangeRate,INFO_MatQuality=:INFOMatQuality,INFO_ReqModeLimited=:INFOReqModeLimited,INFO_NoLocReq=:INFONoLocReq,
		INFO_SpeFlag=:INFOSpeFlag,INFO_SterileDateLen=:INFOSterileDateLen,INFO_MedEqptCat_DR=:INFOMedEqptCatDR,INFO_ZeroStk=:INFOZeroStk,INFO_ChargeType=:INFOChargeType,INFO_SpecFlag=:INFOSpecFlag,INFO_TransDate=:INFOTransDate,INFO_BidDate=:INFOBidDate,INFO_FirstReqDept=:INFOFirstReqDept,INFO_Origin=:INFOOrigin,
		INFO_InsuPay=:INFOInsuPay,INFO_InsuPrice=:INFOInsuPrice,INFO_MatCatOfficial_DR=:INFOMatCatOfficialDR,INFO_MatCatClinical_DR=:INFOMatCatClinicalDR,INFO_MatCatSpecial_DR=:INFOMatCatSpecialDR,INFO_MatRegCert_DR=:INFOMatRegCertDR 
		   WHERE INFO_RowId=:info)
	..i SQLCODE  s ret=-4
	.q:ret'=0
	.&SQL(UPDATE INC_Itm SET INCI_Code=:INCICode,Inci_Desc=:INCIDesc,INCI_CTUOM_DR=:INCICTUOMDR, INCI_CTUOM_Purch_DR=:INCICTUOMPurchDR, INCI_INCSC_DR=:INCIINCSCDR,INCI_NotUseFlag=:INCINotUseFlag,INCI_Sterile=:INCISterile,INCI_SterCat_DR=:INCISterCatDR,INCI_BarCode=:INCIBarCode,INCI_ReportingDays=:INCIReportingDays,
		INCI_CTLOC_DR=:INCICTLOCDR
		 WHERE INCI_RowId=:inci )
	.i SQLCODE  s ret=-4
	.
 	q:ret'=0 ret 	 
 	
	q ret
}

/// Descript:   判断是否有未完成的待审核记录
/// Creater:    lihui
/// CreateDate: 20190612
/// Table: DHC_AuditLog,DHC_AuditLog_INCI,DHC_WorkAuditLog,INC_Itm,DHC_ItmAddionInfo
/// Input: 库存项ID
/// Output Y:存在待审核记录，N：无待审核记录
/// w ##class(web.DHCSTMHUI.MatAudit).IfAuditOver(3166)
ClassMethod IfAuditOver(Inci As %String) As %String
{
	n (Inci)
	q:Inci="" "N"
	s Flag="N",Type="Basic"
	s Mainlogid=$o(^DHCMALG(0,"INCIAUDIT",Inci,"N",""),-1)
	q:Mainlogid="" Flag
	s pointor=Inci_"||"_Mainlogid
	s DWALRowId=$o(^DHCDWAL(0,"TypePoint",Type,pointor,""),-1)
	
	s AuditLevel=0,AuditFlag=""
	i DWALRowId'="" d
	.s AuditLevel=$p(^DHCDWAL(DWALRowId),"^",4)		;当前审核级别
	.s AuditFlag=$p(^DHCDWAL(DWALRowId),"^",7)		;当前审核状态
	q:AuditFlag="N" Flag
	
	s MaxAuditLevel=0
	s TmpLevel=""
	f  s TmpLevel=$o(^DMALM(0,"typelevel",Type,TmpLevel),-1) q:(TmpLevel="")!(MaxAuditLevel'=0)  d
	.s AuditLevelId=$$GetAuditLevel()
	.q:AuditLevelId=""
	.s LevelInfo=^DMALM(AuditLevelId)
	.s ActiveFlag=$p(LevelInfo,"^",3)
	.q:ActiveFlag="N"
	.s MaxAuditLevel=TmpLevel
	i AuditLevel'=MaxAuditLevel s Flag="Y"
	q Flag
GetAuditLevel()
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci,..sssCode(),0)	;顶层类组
	s ScgId=$p(ScgInfo,"^",5)
	s AuditLevelId=""
	s TmpId=""
	f  s TmpId=$o(^DMALM(0,"typelevel",Type,TmpLevel,TmpId)) q:(TmpId="")||(AuditLevelId'="")  d
	.s LevelScgId=$p(^DMALM(TmpId),"^",7)
	.q:(LevelScgId'="")&&(LevelScgId'=ScgId)
	.s AuditLevelId=TmpId
	q AuditLevelId
}

/// Descript:   判断当前审核级别上一级是否已经审核
/// Creater:    lihui
/// CreateDate: 20190614
/// Table: DHC_AuditLog,DHC_AuditLog_INCI,DHC_WorkAuditLog,INC_Itm,DHC_ItmAddionInfo
/// Input: 库存项ID
/// Output Y:已审核，N：未审核
/// w ##class(web.DHCSTMHUI.MatAudit).IfLastLevelAudit("3166||13",4642)
ClassMethod IfLastLevelAudit(point As %String, Userid As %String) As %String
{
	n (point,Userid,%session)
	q:point="" "Y"
	q:Userid="" "N"
	s flag="N",type="Basic"
	s CurLevel=..GetAuditLevel(type,Userid)
	s LastLevel=CurLevel-1
	q:LastLevel=0 "Y"
	s DWALRowId=$o(^DHCDWAL(0,"TYPEPOINTLEVEL",type,point,LastLevel,""),-1)
	i DWALRowId'="" s flag="Y"
	
	q flag
}

/// Descript:   判断需要审核的属性是否修改 是否需要增加审核记录
/// Creater:    lihui
/// CreateDate: 20190516
/// Table: DHC_AuditLog,DHC_AuditLog_INCI
/// input:库存id,AU标志(2新增,0更新前,1更新后)
/// w ##class(web.DHCSTMHUI.MatAudit).IfAddInciLog("4459",0,"{""BUom"":""2"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""PUom"":""2"",""StkGrp"":""1"",""StkCat"":""1"",""BatchNoReq"":""R"",""ExpDateReq"":""R"",""BookCat"":"""",""Supervision"":"""",""MarkType"":"""",""ChargeType"":"""",""RiskCategory"":"""",""Manf"":""1171"",""PbVendor"":"""",""Pb"":"""",""PbLevel"":"""",""PbCarrier"":"""",""Origin"":"""",""ImpFlag"":"""",""SterileCat"":"""",""QualityLev"":"""",""ConsumableLevel"":"""",""PackUom"":"""",""ChargeFlag"":"""",""RegCertExpDateExtended"":"""",""HighPrice"":"""",""HighRiskFlag"":"""",""BaFlag"":"""",""PackCharge"":"""",""ImplantationMat"":"""",""NoLocReq"":"""",""InHosFlag"":"""",""MatFlag"":"""",""BatchCodeFlag"":"""",""ZeroStk"":"""",""NotUseFlag"":""Y"",""Official"":"""",""NotUseReason"":"""",""ReqType"":"""",""SupplyLoc"":"""",""FirstReqLoc"":"""",""Inci"":""4459"",""AspStatus"":""Yes"",""Asp"":""4440"",""UseFlag"":""0"",""RegNoId"":"""",""InciCode"":""cs004"",""InciDesc"":""测试004"",""Spec"":""234"",""Model  "":""阿斯蒂芬"",""Brand"":""水电费"",""Abbrev"":""阿斯蒂芬"",""StanderCode"":"""",""XieHeCode"":"""",""Remarks"":"""",""RpPUom"":""0"",""SpPUom"":""0"",""PreExeDate"":""2020-11-19"",""PrcFile"":"""",""PrcDate"":"""",""RegCertNo"":"""",""RegCertExpDate"":"""",""RegCertDate"":"""",""RegItmDesc"":"""",""insProLicText"":"""",""insProLicIssuedDept"":"""",""insProLicDateFrom"":"""",""insProLicDateTo"":"""",""firstProdLicText"":"""",""firstProdLicIssuedDept"":"""",""firstProdLicDateFrom"":"""",""firstProdLicDateTo"":"""",""insBusLicText"":"""",""insBusLicIssuedDept"":"""",""insBusLicDateFrom"":"""",""insBusLicDateTo"":"""",""secondBusLicText"":"""",""secondBusLicIssuedDept"":"""",""secondBusLicDateFrom"":"""",""secondBusLicDateTo"":"""",""PbRp"":"""",""PbDate"":"""",""ComFrom"":"""",""BarCode"":""玩儿"",""ExpireLen"":"""",""MaxSp"":"""",""SterileDateLen"":"""",""QualityNo"":  """",""Quality"":"""",""PackUomFac"":"""",""AliasStr"":""cs004"",""StoreCond"":"""",""Application"":"""",""MaterinalFunction"":"""",""InciEndDate"":""""}")
ClassMethod IfAddInciLog(CurrRowid As %String, type As %String, Updata As %String) As %String
{
	 n (CurrRowid, type,Updata)
	 s Flag="N"
	 q:(type'=0) "Y"
	 q:Updata="" "Y"
	 q:'$d(^INCI(CurrRowid,1)) Flag
	 q:'$d(^INCI(CurrRowid,2)) Flag
	 q:'$d(^INCI(CurrRowid,3)) Flag
	 s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	 s Sc=PJObj.%FromJSON(Updata)
	 i Sc'=0 s Flag="N" q Flag
	 
	 
	 s inciinfo1=^INCI(CurrRowid,1)
	 s inciinfo2=^INCI(CurrRowid,2)
	 s inciinfo3=^INCI(CurrRowid,3)
	 s (INCICode,INCIDesc,INCICTUOMDR,INCICTUOMPurchDR,INCIINCSCDR,INCINotUseFlag,INCIBatchReq,INCIExpReq)=""
	 s (INCISterile,INCISterCatDR,INCIBarCode,INCIReportingDays,INCICTLOCDR)=""
	 
	 i (..CheckInciParam("INCICode")="Y") d
	 .s INCICode=$P(inciinfo1,"^",1)
	 .i INCICode'=PJObj.%Get("InciCode") s Flag="Y" 
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCIDesc")="Y") d
	 .s INCIDesc=$P(inciinfo1,"^",2)
	 .i INCIDesc'=PJObj.%Get("InciDesc") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCICTUOMDR")="Y") d
	 .s INCICTUOMDR=$P(inciinfo1,"^",10)
	 .i INCICTUOMDR'=PJObj.%Get("BUom") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCICTUOMPurchDR")="Y") d
	 .s INCICTUOMPurchDR=$P(inciinfo3,"^",6)
	 .i INCICTUOMPurchDR'=PJObj.%Get("PUom") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCIINCSCDR")="Y") d
	 .s INCIINCSCDR=$P(inciinfo2,"^",2)
	 .i INCIINCSCDR'=PJObj.%Get("StkCat") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCINotUseFlag")="Y") d
	 .s INCINotUseFlag=$P(inciinfo2,"^",9)
	 .s:INCINotUseFlag="" INCINotUseFlag="N"
	 .i INCINotUseFlag'=PJObj.%Get("NotUseFlag") s Flag="Y" 
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCIBatchReq")="Y") d
	 .s INCIBatchReq=$P(inciinfo2,"^",10)
	 .i INCIBatchReq'=PJObj.%Get("BatchNoReq") s Flag="Y" 
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INCIExpReq")="Y") d
	 .s INCIExpReq=$P(inciinfo2,"^",11)
	 .i INCIExpReq'=PJObj.%Get("ExpDateReq") s Flag="Y"
	 q:Flag="Y" Flag

	 i (..CheckInciParam("INCISterile")="Y") d
	 .s INCISterile=$P(inciinfo2,"^",12)  ;消毒项标志

	 i (..CheckInciParam("INCISterCatDR")="Y") d
	 .s INCISterCatDR=$P(inciinfo2,"^",14)
	 .i INCISterCatDR'=PJObj.%Get("SterileCat") s Flag="Y"
	 q:Flag="Y" Flag

	 i (..CheckInciParam("INCIBarCode")="Y") d
	 .s INCIBarCode=$P(inciinfo3,"^",9)
	 .i INCIBarCode'=PJObj.%Get("BarCode") s Flag="Y"
	 q:Flag="Y" Flag

	 i (..CheckInciParam("INCIReportingDays")="Y") d
	 .s INCIReportingDays=$P(inciinfo3,"^",11)
	 .i INCIReportingDays'=PJObj.%Get("XieHeCode") s Flag="Y"
	 q:Flag="Y" Flag

	 i (..CheckInciParam("INCICTLOCDR")="Y") d
	 .s INCICTLOCDR=$P(inciinfo2,"^",1)
	 .i INCICTLOCDR'=PJObj.%Get("SupplyLoc") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s info=$o(^DHCITMINFO(0,"INCI",CurrRowid,""),-1)
	 q:info="" Flag
	 q:'$d(^DHCITMINFO(info)) Flag
	 
	 s addioninfo=^DHCITMINFO(info)
	 s (INFOSpec,INFOHighPrice,INFOMTDR,INFOPbVendorDR,INFOPbManfDR,INFOImportFlag,INFOQualityLevel,INFOComFrom,INFORemark,INFOMaxSp)=""
	 s (INFOInHosFlag,INFOPbRp,INFOPBLDR,INFOPbCarrierDR,INFOBAflag,INFOPBLevel,INFOEndDate,INFOExpireLen,INFOPrcFile,INFOPrcFileD,INFOBCDr)=""
	 s (INFOStandardCode,INFONotUseReasonDr,INFOInsuCatDR,INFOHighRiskFlag,INFOPackUom,INFOPackUomFactor,INFOPackPicPath,INFOMaxPurAmt,INFODistribFlag,INFOChargeFlag)=""
	 s (INFOBrand,INFOModel,INFOAbbrev,INFOSupervision,INFOImplantationMat,INFOPbno,INFOChangeRate,INFOMatQuality,INFOReqModeLimited,INFONoLocReq,INFOSpeFlag)=""
	 s (INFOSterileDateLen,INFOMedEqptCatDR,INFOZeroStk,INFOChargeType,INFOSpecFlag,INFOTransDate,INFOBidDate,INFOFirstReqDept,INFOOrigin,INFOInsuPay,INFOInsuPrice)=""
	 s (INFOMatCatOfficialDR,INFOMatCatClinicalDR,INFOMatCatSpecialDR,INFOMatRegCertDR)=""
	 
	 i (..CheckInciParam("INFOSpec")="Y") d 
	 .s INFOSpec=$P(addioninfo,"^",27)
	 .i INFOSpec'=PJObj.%Get("Spec") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOHighPrice")="Y") d 
	 .s INFOHighPrice=$P(addioninfo,"^",12)
	 .s:INFOHighPrice="" INFOHighPrice="N"
	 .i INFOHighPrice'=PJObj.%Get("HighPrice") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOMTDR")="Y") d 
	 .s INFOMTDR=$P(addioninfo,"^",15)
	 .i INFOMTDR'=PJObj.%Get("MarkType") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPbVendorDR")="Y") d 
	 .s INFOPbVendorDR=$P(addioninfo,"^",24)
	 .i INFOPbVendorDR'=PJObj.%Get("PbVendor") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPbManfDR")="Y") d 
	 .s INFOPbManfDR=$P(addioninfo,"^",25)
	 .i INFOPbManfDR'=PJObj.%Get("Manf") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOImportFlag")="Y") d 
	 .s INFOImportFlag=$P(addioninfo,"^",2)
	 .s:INFOImportFlag="" INFOImportFlag="N"
	 .i INFOImportFlag'=PJObj.%Get("ImpFlag") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOQualityLevel")="Y") d 
	 .s INFOQualityLevel=$P(addioninfo,"^",3)
	 .i INFOQualityLevel'=PJObj.%Get("QualityLev") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOComFrom")="Y") d 
	 .s INFOComFrom=$P(addioninfo,"^",9)
	 .i INFOComFrom'=PJObj.%Get("ComFrom") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFORemark")="Y") d 
	 .s INFORemark=$P(addioninfo,"^",10)
	 .i INFORemark'=PJObj.%Get("Remarks") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOMaxSp")="Y") d 
	 .s INFOMaxSp=$P(addioninfo,"^",16)
	 .i INFOMaxSp'=PJObj.%Get("MaxSp") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOInHosFlag")="Y") d 
	 .s INFOInHosFlag=$P(addioninfo,"^",21)
	 .s:INFOInHosFlag="" INFOInHosFlag="N"
	 .i INFOInHosFlag'=PJObj.%Get("InHosFlag") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPbRp")="Y") d 
	 .s INFOPbRp=$P(addioninfo,"^",22)
	 .i INFOPbRp'=PJObj.%Get("PbRp") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPBLDR")="Y") d 
	 .s INFOPBLDR=$P(addioninfo,"^",23)
	 .i INFOPBLDR'=PJObj.%Get("Pb") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPbCarrierDR")="Y") d 
	 .s INFOPbCarrierDR=$P(addioninfo,"^",26)
	 .i INFOPbCarrierDR'=PJObj.%Get("PbCarrier") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOBAflag")="Y") d 
	 .s INFOBAflag=$P(addioninfo,"^",29)
	 .s:INFOBAflag="" INFOBAflag="N"
	 .i INFOBAflag'=PJObj.%Get("BaFlag") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPBLevel")="Y") d 
	 .s INFOPBLevel=$P(addioninfo,"^",30)
	 .i INFOPBLevel'=PJObj.%Get("PbLevel") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s:(..CheckInciParam("INFOEndDate")="Y") INFOEndDate=$P(addioninfo,"^",31)  ;截止日期
	 
	 i (..CheckInciParam("INFOExpireLen")="Y") d 
	 .s INFOExpireLen=$P(addioninfo,"^",32)
	 .i INFOExpireLen'=PJObj.%Get("ExpireLen") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPrcFile")="Y") d 
	 .s INFOPrcFile=$P(addioninfo,"^",33)
	 .i INFOPrcFile'=PJObj.%Get("PrcFile") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPrcFileD")="Y") d 
	 .s INFOPrcFileD=$P(addioninfo,"^",34)
	 .s PrcDate=PJObj.%Get("PrcDate")
	 .s:PrcDate'="" PrcDate=..DH2L(PrcDate)
	 .i INFOPrcFileD'=PrcDate s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOBCDr")="Y") d 
	 .s INFOBCDr=$P(addioninfo,"^",36)
	 .i INFOBCDr'=PJObj.%Get("BookCat") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOStandardCode")="Y") d 
	 .s INFOStandardCode=$P(addioninfo,"^",44)
	 .i INFOStandardCode'=PJObj.%Get("StanderCode") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFONotUseReasonDr")="Y") d 
	 .s INFONotUseReasonDr=$P(addioninfo,"^",47)
	 .i INFOStandardCode'=PJObj.%Get("StanderCode") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOInsuCatDR")="Y") d 
	 .s INFOInsuCatDR=$P(addioninfo,"^",49)
	 .i INFOInsuCatDR'=PJObj.%Get("InsuCat") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOHighRiskFlag")="Y") d 
	 .s INFOHighRiskFlag=$P(addioninfo,"^",50)
	 .s:INFOHighRiskFlag="" INFOHighRiskFlag="N"
	 .i INFOHighRiskFlag'=PJObj.%Get("HighRiskFlag") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPackUom")="Y") d 
	 .s INFOPackUom=$P(addioninfo,"^",51)
	 .i INFOPackUom'=PJObj.%Get("PackUom") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOPackUomFactor")="Y") d 
	 .s INFOPackUomFactor=$P(addioninfo,"^",52)
	 .i INFOPackUomFactor'=PJObj.%Get("PackUomFac") s Flag="Y"
	 q:Flag="Y" Flag
	
	 s:(..CheckInciParam("INFOPackPicPath")="Y") INFOPackPicPath=$P(addioninfo,"^",53) ;外包装图片路径
	 
	 s:(..CheckInciParam("INFOMaxPurAmt")="Y") INFOMaxPurAmt=$P(addioninfo,"^",54) ;月采购金额上限
	 
	 s:(..CheckInciParam("INFODistribFlag")="Y") INFODistribFlag=$P(addioninfo,"^",55) ;分配标志
	 
	 i (..CheckInciParam("INFOChargeFlag")="Y") d 
	 .s INFOChargeFlag=$P(addioninfo,"^",57)
	 .s:INFOChargeFlag="" INFOChargeFlag="N"
	 .i INFOChargeFlag'=PJObj.%Get("ChargeFlag") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOBrand")="Y") d 
	 .s INFOBrand=$P(addioninfo,"^",58)
	 .i INFOBrand'=PJObj.%Get("Brand") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOModel")="Y") d 
	 .s INFOModel=$P(addioninfo,"^",59)
	 .i INFOModel'=PJObj.%Get("Model") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOAbbrev")="Y") d 
	 .s INFOAbbrev=$P(addioninfo,"^",60)
	 .i INFOAbbrev'=PJObj.%Get("Abbrev") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOSupervision")="Y") d 
	 .s INFOSupervision=$P(addioninfo,"^",61)
	 .i INFOSupervision'=PJObj.%Get("Supervision") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOImplantationMat")="Y") d 
	 .s INFOImplantationMat=$P(addioninfo,"^",62)
	 .i INFOImplantationMat'=PJObj.%Get("ImplantationMat") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s:(..CheckInciParam("INFOPbno")="Y") INFOPbno=$P(addioninfo,"^",63) 
	 
	 s:(..CheckInciParam("INFOChangeRate")="Y") INFOChangeRate=$P(addioninfo,"^",64) ;招标转换比
	 
	 i (..CheckInciParam("INFOMatQuality")="Y") d 
	 .s INFOMatQuality=$P(addioninfo,"^",71)
	 .i INFOMatQuality'=PJObj.%Get("Quality") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOReqModeLimited")="Y") d 
	 .s INFOReqModeLimited=$P(addioninfo,"^",73)
	 .i INFOReqModeLimited'=PJObj.%Get("ReqType") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFONoLocReq")="Y") d 
	 .s INFONoLocReq=$P(addioninfo,"^",74)
	 .i INFONoLocReq'=PJObj.%Get("NoLocReq") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s:(..CheckInciParam("INFOSpeFlag")="Y") INFOSpeFlag=$P(addioninfo,"^",76) ;特殊标志
	 
	 i (..CheckInciParam("INFOSterileDateLen")="Y") d 
	 .s INFOSterileDateLen=$P(addioninfo,"^",79)
	 .s SterileDateLen=PJObj.%Get("SterileDateLen")
	 .s:SterileDateLen'="" SterileDateLen=..DH2L(SterileDateLen)
	 .i INFOSterileDateLen'=SterileDateLen s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOMedEqptCatDR")="Y") d 
	 .s INFOMedEqptCatDR=$P(addioninfo,"^",80)
	 .i INFOMedEqptCatDR'=PJObj.%Get("MedEqptCat") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOZeroStk")="Y") d 
	 .s INFOZeroStk=$P(addioninfo,"^",81)
	 .s:INFOZeroStk="" INFOZeroStk="N"
	 .i INFOZeroStk'=PJObj.%Get("ZeroStk") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOChargeType")="Y") d 
	 .s INFOChargeType=$P(addioninfo,"^",82)
	 .i INFOChargeType'=PJObj.%Get("ChargeType") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s:(..CheckInciParam("INFOSpecFlag")="Y") INFOSpecFlag=$P(addioninfo,"^",96) ;具体规格是否允许录入
	 
	 s:(..CheckInciParam("INFOTransDate")="Y") INFOTransDate=$P(addioninfo,"^",97) ;到货日期
	 
	 i (..CheckInciParam("INFOBidDate")="Y") d 
	 .s INFOBidDate=$P(addioninfo,"^",98) 
	 .s PbDate=PJObj.%Get("PbDate")
	 .s:PbDate'="" PbDate=..DH2L(PbDate)
	 .i INFOBidDate'=PbDate s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOFirstReqDept")="Y") d 
	 .s INFOFirstReqDept=$P(addioninfo,"^",99)
	 .i INFOFirstReqDept'=PJObj.%Get("FirstReqLoc") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 i (..CheckInciParam("INFOOrigin")="Y") d
	 .s INFOOrigin=$P(addioninfo,"^",100)
	 .i INFOOrigin'=PJObj.%Get("Origin") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s:(..CheckInciParam("INFOInsuPay")="Y") INFOInsuPay=$P(addioninfo,"^",101)  ;是否医保支付
	 
	 s:(..CheckInciParam("INFOInsuPrice")="Y") INFOInsuPrice=$P(addioninfo,"^",102) ;医保支付价格
	 
	 i (..CheckInciParam("INFOMatCatOfficialDR")="Y") d
	 .s INFOMatCatOfficialDR=$P(addioninfo,"^",107)
	 .i INFOMatCatOfficialDR'=PJObj.%Get("Official") s Flag="Y"
	 q:Flag="Y" Flag
	 
	 s:(..CheckInciParam("INFOMatCatClinicalDR")="Y") INFOMatCatClinicalDR=$P(addioninfo,"^",108) ;官方分类
	 
	 s:(..CheckInciParam("INFOMatCatSpecialDR")="Y") INFOMatCatSpecialDR=$P(addioninfo,"^",109) ;特殊分类
	 
	 i (..CheckInciParam("INFOMatRegCertDR")="Y") d
	 .s INFOMatRegCertDR=$p(^DHCITMINFO(info,1),"^",18)
	 .s RegCertNo=PJObj.%Get("RegCertNo")
	 .s RegCertId=$s(RegCertNo'="":$o(^DHCMRCT(0,"NO",RegCertNo,""),-1),1:"")
	 .i INFOMatRegCertDR'=RegCertId s Flag="Y"
	 q:Flag="Y" Flag
	 
	 q Flag
}

}

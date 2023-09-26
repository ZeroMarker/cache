/// ClassName:    DtPortal.Common.PaadmService
/// Description:  就诊相关服务
/// Creator：     zhufei
/// CreatDate:    2014-07-24
Class DtPortal.Common.PaadmService Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     zhufei  //程鹏修改
/// CreatDate：   2014-07-23
/// Description:  查询在院病人就诊列表
/// Table：       PA_Adm
/// Input：       aQueryUnit  ：查询单位 P:本医生  PG:本主诊组 loc:科室 ward:病区  
///               aUserID    : 用户ID
///               aLocID     : 科室ID(类型为"loc"时为CT_LOC表iD   类型为"ward"时为pac_ward表ID)
/// 				  ifConf     :  false 不走在床过滤的配置
/// Return：      就诊号字符串  "^"分隔
/// w ##Class(DtPortal.Common.PaadmService).GetIPPaadmList("P","6402",1)
ClassMethod GetIPPaadmList(aQueryUnit As %String, aUserID As %String, aLocID As %String, ifConf As %String = "true") As %String
{
	Set $ZT="GetIPPaadmList"
	Set return=""
	Quit:aQueryUnit="" return
	Set UserID=aUserID
	Set LocID=aLocID
	Set DocID=$p($g(^SSU("SSUSR",+UserID)),"^",14)
	set warID=""
	Set AdmType="I"
	//是否包含不在床的患者  1-包含   其他-不包含
	s IfContainWaitPat=##Class(DtPortal.Common.PublicService).getValueByCode("IFCONTAINWAITPAT")
	If aQueryUnit="P" {        //本医生病人
		Quit:DocID="" return
	} ElseIf aQueryUnit="PG" {  //本医疗组病人
		Set MUDocList=##class(DtPortal.Common.PublicService).GetMUDocList(DocID)
		Quit:MUDocList="" return
	} ElseIf aQueryUnit="loc" {  //科室病人
		Quit:aLocID="" return
		Set LocID=aLocID
		Set AdmType=""
		s locType=##class(DtPortal.Common.PublicService).getDeptType(LocID)
		if (locType["I"){
			 set AdmType="I"
		}elseif(locType["E"){
			 set AdmType="E"
		}elseif(locType["O"){
			 set AdmType="O"
		}
		Quit:AdmType="" return
			
	}ElseIf aQueryUnit="ward" {  //病区病人
		Quit:aLocID="" return
		set warID=aLocID
	}
	 Else {
		Quit return
	}

	
	
	//查询科室用在院患者科室索引
	if aQueryUnit="loc"
	{	
		Set xDate=0
		For {
			Set xDate=$o(^PAADMi("AdmTypeCurrLoc",AdmType,LocID,xDate))
			Quit:xDate=""
			Set xTime=""
			For {
				Set xTime=$o(^PAADMi("AdmTypeCurrLoc",AdmType,LocID,xDate,xTime))
				Quit:xTime=""
				
				Set xPaadm=""
				For {
					Set xPaadm=$o(^PAADMi("AdmTypeCurrLoc",AdmType,LocID,xDate,xTime,xPaadm))
					Quit:xPaadm=""

					Continue:$p($g(^PAADM(+xPaadm)),"^",20)'="A"   //就诊状态过滤
					
					if ((ifConf'="false")&&(IfContainWaitPat'="1")){ //非1只取在床的患者
						s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(xPaadm)
						continue:patInBed'=1   //过滤不在床位
					}
					
					Set:return'="" return=return_"^"_xPaadm
					Set:return="" return=xPaadm
				}
			}
		}
		
	//查询病区用在院患者病区索引	
	}elseif aQueryUnit="ward"
	{
		
	
		Set xRoomID=""
		
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",warID,xRoomID))
			Quit:xRoomID=""
			
			
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",warID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Continue:$p($g(^PAADM(+xPaadm)),"^",2)'="I"   //就诊类型过滤
				Continue:$p($g(^PAADM(+xPaadm)),"^",20)'="A"   //就诊状态过滤
				if ((ifConf'="false")&&(IfContainWaitPat'="1")){ //非1只取在床的患者
					s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(xPaadm)
					continue:patInBed'=1   //过滤不在床位
				}
				
				
				Set:return'="" return=return_"^"_xPaadm
				Set:return="" return=xPaadm
			}
			
		}
		
		
		
	//查询医生,主诊组用在院患者索引	
	}else
	{		
		
		
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi("AdmTypeCurr",AdmType,xPaadm))
			Quit:xPaadm=""
			
			Continue:$p($g(^PAADM(+xPaadm)),"^",2)'="I"   //就诊类型过滤
			Continue:$p($g(^PAADM(+xPaadm)),"^",20)'="A"   //就诊状态过滤
			
			Set AdmDocID=$p($g(^PAADM(xPaadm)),"^",9)     //主管医生
			Continue:(aQueryUnit="P")&&(AdmDocID'=DocID)
			Set AdmDocID="^"_AdmDocID_"^"
			Continue:(aQueryUnit="PG")&&(MUDocList'[AdmDocID)
			
			if ((ifConf'="false")&&(IfContainWaitPat'="1")){ //非1只取在床的患者
				s patInBed=##Class(DtPortal.Common.PaadmService).IFPatInBed(xPaadm)
				continue:patInBed'=1   //过滤不在床位
			}
			
			Set:return'="" return=return_"^"_xPaadm
			Set:return="" return=xPaadm
		}
		
		
		
			
		
	}


	Quit return
	
GetIPPaadmList
	w !,$ze
	q -1
}

/// Creator： 白明哲
/// CreatDate： 2014-7-9
/// Description: 根据就诊Id,取诊断-----用于Portal公共服务-修改门诊病人取全部诊断
/// Input：		Adm : 就诊Id
/// Type: 取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
/// Return： 	 
/// 
/// Debug：w ##class(DtPortal.Common.PaadmService).GetMainDiagnosis(769)
ClassMethod GetMainDiagnosis(PAAdm As %String) As %String
{
	Set $ZT="GetMainDiagnosis"
	q ##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(PAAdm)
	/*
	s DiagnoseDesc=""
	q:PAAdm="" ""
	set paadmType=$P($g(^PAADM(PAAdm)),"^",2)
	if (paadmType="I"){
		s DiagnoseDesc=..GetAdmDiagnosis(PAAdm,"M")   //主诊断
		i DiagnoseDesc="" s DiagnoseDesc=..GetAdmDiagnosis(PAAdm,"C008")   //入院诊断
		i DiagnoseDesc=""  s DiagnoseDesc=..GetAdmDiagnosis(PAAdm,"PRE")   //初步诊断
		i DiagnoseDesc=""  s DiagnoseDesc=..GetAdmDiagnosis(PAAdm,"")   //初步诊断
	} else {
		s DiagnoseDesc=..GetAdmDiagnosis(PAAdm,"")
	}
 	*/
	
	q DiagnoseDesc
GetMainDiagnosis
	q -1
}

/// Creator： 赵忠原
/// CreatDate： 2014-7-9
/// Description: 根据就诊Id,取诊断-----用于Portal公共服务
/// Input：		Adm : 就诊Id
/// Type: 诊断类型（DIS：出院诊断，M：主诊断，PRE：初步诊断，C008：入院诊断，空值：全部诊断）
/// Return： 	 
///              DiagStr 诊断串（以","分割）
/// Debug：w ##class(DtPortal.Common.PaadmService).GetAdmDiagnosis(578,"M")
ClassMethod GetAdmDiagnosis(Adm As %String, Type As %String = "") As %String
{
	
 Set $ZT="GetAdmDiagnosis"	 
 if $g(Adm)="" q ""
 s MRAdm=$p($g(^PAADM(Adm)),"^",61)
 if $g(MRAdm)="" q ""
 Set DiagStr=""
 Set Diag=0
 For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:(Diag="")  Do
 .Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
 .s DiagTypeID=$o(^MR(MRAdm,"DIA",Diag,"TYP",0))
 .s TypeID="",TypeDesc=""
 .i DiagTypeID'="" s TypeID=$p($g(^MR(MRAdm,"DIA",Diag,"TYP",DiagTypeID)),"^",1)
 .i TypeID'="" s TypeDesc=$p($g(^MRC("DTYP",TypeID)),"^",2)
 .q:((Type="C008")&&(TypeDesc'="入院诊断"))
 .q:((Type="DIS")&&(TypeDesc'="出院诊断"))
 .q:((Type="M")&&(TypeDesc'="主诊断"))
 .q:((Type="PRE")&&(TypeDesc'="初步诊断"))
 .if DiagID'="" Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
 .else  Set DiagDesc=$g(^MR(MRAdm,"DIA",Diag,"DES",1))
 .;If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"-",2)
 .If $P($g(^MR(MRAdm,"DIA",Diag,1)),"^",20)="Y" s DiagDesc=DiagDesc_"(主)"   //有主诊断标记加“主”--bmz20160310
 .If DiagStr="" Set DiagStr=DiagDesc
 .Else  Set DiagStr=DiagStr_","_DiagDesc	
 quit DiagStr
 
GetAdmDiagnosis
	q -1
}

/// Creator： 白明哲
/// CreatDate： 2014-7-9
/// Description: 得到患者当天某些医嘱是否存在，存在返回１，不存在返回０
/// Input：	EpisodeID、ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// Return： 	 
/// Debug：w ##class(DtPortal.Common.PaadmService).IfOrddailyExist("","")
ClassMethod IfOrddailyExist(EpisodeID, ArcimCodes) As %String
{
 
 s num=$l(ArcimCodes,"^")
 s ret=0
 for i=1:1:num d
 .q:ret=1
 .s code=$p(ArcimCodes,"^",i)
 .q:code=""
 .s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 .q:rowidm=""
 .s rowid=rowidm_"||"_"1"
 .;w !,rowid
 .s ret=..GetCareType(EpisodeID, rowid)
 q ret
}

// StrArcRowIds　医嘱需要查的医嘱的rowid串，　如"130||1^132||1^567||1"

ClassMethod GetCareType(AdmNo, StrArcRowIds) As %String
{
 
 s AdmNo=$g(AdmNo)
 s StrArcRowIds=$g(StrArcRowIds) 
 set retno=0
 q:AdmNo="" 0
 q:StrArcRowIds="" 0
 set ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" 0
 s num=$l(StrArcRowIds,"^")
 s flag=0
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) q:(ordSttTime="")!(retno=1)  d
 .s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(retno=1)  d
 ..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retno=1)  d
 ...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ...q:ordStatusId=""
 ...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ...q:(ordStat'="V")&(ordStat'="E") 
 ...q:StrArcRowIds'=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ...s retno=1
 q retno
}

/// Creator： 白明哲
/// CreatDate： 2014-7-9
/// Description: 通过护理级别医嘱代码取出当日病人是否有护理级别----bmz
/// Input：	EpisodeID、ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// Return： 	 
/// Debug：w ##class(DtPortal.Common.PaadmService).GetNurseLevelDesc("","")
/// ArcimCodes  医嘱的代码的组合,如:"c001^003"
/// ArcimCodes=HL0002^HL0003^HL0004^HL0005^HL0006^HL0007^HL0008^HL0009^HL0010^HL0011
ClassMethod IfNurseLevelExist(EpisodeID, ArcimCodes) As %String
{
 ;s ^bmz("IfNurseLevelExist")=EpisodeID
 s num=$l(ArcimCodes,"^")
 s ret=0
 s ret1=""
 for i=1:1:num d
 .q:ret=1
 .s code=$p(ArcimCodes,"^",i)
 .q:code=""
 .s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 .q:rowidm=""
 .s rowid=rowidm_"||"_"1"
 .;w !,rowid
 .s ArcimDesc=""
 .s ArcimDesc=$p(^ARCIM(rowidm,"1","1"),"^",2)
 .s ret=..GetNurseLevelDesc(EpisodeID, rowid,ArcimDesc)
 .;b ;2
 .i ret'=""  s ret1=ret
 q ret1
}

ClassMethod GetNurseLevelDesc(AdmNo, StrArcRowIds, ArcimDesc) As %String
{
 //
 ;s ^bmz("GetNurseLevelDesc")=AdmNo_"#"_StrArcRowIds_"#"_ArcimDesc
 s AdmNo=$g(AdmNo)
 s StrArcRowIds=$g(StrArcRowIds) 
 set retDesc=""
 q:AdmNo="" ""
 q:StrArcRowIds="" ""
 set ord=$o(^OEORD(0,"Adm",AdmNo,""))
 q:ord="" ""
 s num=$l(StrArcRowIds,"^")
 s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) q:(ordSttTime="")!(retDesc=ArcimDesc)  d
 .s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(retDesc=ArcimDesc)  d
 ..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retDesc=ArcimDesc)  d
 ...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ...q:ordStatusId=""
 ...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ...q:(ordStat'="V")&(ordStat'="E")
 ...q:StrArcRowIds'=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ...s retDesc=ArcimDesc
 q retDesc
}

/// Creator： 赵忠原
/// CreatDate： 2014-8-7
/// Description: 根就诊ID取病人基本信息
/// Input：	PAAdm : 就诊ID
/// Return： 	床号^姓名^性别^年龄^病案号^费用类别^登记号^病人基本信息ID(PatientID)^科室描述^病区描述^主管医生姓名^主管护士姓名
/// 				床号 1;姓名 2;性别 3 ;年龄 4;病案号 5 ;费用类别 6;登记号 7;病人基本信息ID 8 ;科室 9;病区 10;主管医生 11;主管护士 12
/// Debug：d ##class(DtPortal.Common.PaadmService).GetPatInfo(190)
ClassMethod GetPatInfo(PAAdm As %String) As %String
{
	Set $ZT="GetPatInfo"
	s BedNo="",Name="",Sex="",Age="",MedicareNo="",AdmReason="",regNo="",PatientID="",locDesc="",wardDesc="",docDesc="",nurseDescs=""
	if PAAdm="" q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason_"^"_regNo_"^"_PatientID_"^"_locDesc_"^"_wardDesc_"^"_docDesc_"^"_nurseDescs
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" s BedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	
	
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	set MedicareNo=##class(DtPortal.Common.PaadmService).getMedicareNo(PAAdm)
	Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	if Sex'="" Set Sex=$P($g(^CT("SEX",Sex)),"^",2)
	set Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,PAAdm) //统一调用计费组的年龄接口
	s AdmReasonDr=$P($g(^PAADM(PAAdm)),"^",73)
	Set AdmReasonDr=$P($g(^PAADM(PAAdm,1)),"^",7)
	If AdmReasonDr'="" Set AdmReason=$P($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	//取病人登记号
	Set regNo=$P(^PAPER(PatientID,"PAT",1),"^",1)

	set locID=$P($g(^PAADM(PAAdm)),"^",4)
	set:locID'="" locDesc=$p(^CTLOC(locID),"^",2)
	set:locDesc["-" locDesc=$p(locDesc,"-",2)
	
	set wardID=$P($g(^PAADM(PAAdm)),"^",70)
	set:wardID'="" wardDesc=$p(^PAWARD(wardID),"^",2)
	set:wardDesc["-" wardDesc=$p(wardDesc,"-",2)
	
	s admDocID=$p($g(^PAADM(PAAdm)),"^",9)  //主管医生Id
	i admDocID'="" s docDesc=$p(^CTPCP(admDocID,1),"^",2)  //主管医生
	  //主管护士
	s admNurseID="",nurseDesc1="",nurseDesc2="",DHCPAAdmID="",nurseDescs=""
	
	s DHCPAAdmID=$o(^DHCPAAdm(0,"PAAdm",PAAdm,""))  //主管护士Id
	i DHCPAAdmID'=""  {
		s admNurseID=$p($g(^DHCPAAdm(DHCPAAdmID)),"^",2) 
		i +admNurseID'=0 s nurseDesc1=$p($g(^CTPCP(admNurseID,1)),"^",2)  //主管护士1
		s admNurseID2=$p($g(^DHCPAAdm(DHCPAAdmID)),"^",20) 
		i +admNurseID2'=0 s nurseDesc2=$p($g(^CTPCP(admNurseID2,1)),"^",2)  //主管护士2
	}
	set nurseDescs=nurseDesc1
	set:((nurseDescs'="")&&(nurseDesc2'="")) nurseDescs=nurseDescs_";"_nurseDesc2
	set:nurseDescs="" nurseDescs=nurseDesc2

	q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason_"^"_regNo_"^"_PatientID_"^"_locDesc_"^"_wardDesc_"^"_docDesc_"^"_nurseDescs
	
GetPatInfo
	q "-1"
}

/// Creator:      bmz
/// CreateDate:   2019.8.9
/// Description:  获取病案号
/// Input:
/// Return:
/// Other: ##class(DtPortal.Common.PaadmService).getMedicareNo(1056)
ClassMethod getMedicareNo(episodeID)
{
	s medicareNo=""
	q:episodeID="" medicareNo
	s admType=$p(^PAADM(episodeID),"^",2)
    s errmsg=""
	Set medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(episodeID,admType,.errmsg)	//调用病案接口取病案号
	q medicareNo
}

/// Creator： 赵忠原
/// CreatDate： 2014-7-11--bmz修改根据院区获取配置20220106
/// Description: 根据就诊取生命体征
/// Input：		PAAdm：就诊ID
/// Return：	VitalSign：生命体征(Temperature_"^"_Pulse_"^"_Breathe_"^"_Diastolic_"^"_Systolic_"^"_肛温:::体温_"^"_脉搏_"^"_呼吸_"^"_收缩压_"^"_舒张压_"^"_肛温)
/// w ##class(DtPortal.Common.PaadmService).GetVitalSignByAdm(3)			  
ClassMethod GetVitalSignByAdm(PAAdm)
{
	Set $ZT="GetVitalSignByAdm"
	q:PAAdm="" ""
	s mradm=$p($g(^PAADM(+PAAdm)),"^",61)
	q:mradm="" ""	
	
	
	s currLocId=$p($g(^PAADM(PAAdm)),"^",4)
	s hospID=""
	if (currLocId'=""){
		s hospID=$p($g(^CTLOC(currLocId)),"^",22)
	}
	
	s Temperature="",Temperature2=""
	s Breathe=""
	s Pulse=""
	s Diastolic=""
	s Systolic=""
	//注意 P-脉搏  r-呼吸  用旧的方式（下面注释了的）要注意修改下！！！
	/*
	s TItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("体温"),0))
	s RItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("呼吸"),0))
	s PItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("脉搏"),0))
	s DBPItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("收缩压"),0))
	s SBPItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("舒张压"),0))
	*/
	//新版体温单
	/*
	s TItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("腋温（℃）"),0))
	s RItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("呼吸（次分）"),0))
	s PItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("脉搏（次分）"),0))
	s DBPItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("收缩压（MMHG）"),0))
	s SBPItem=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("舒张压（MMHG）"),0))
	
	s TItem2=$o(^MRC("OBITM",0,"Desc",$$ALPHAUP^SSUTIL4("肛温（℃）"),0))
	*/
	
	//新版体温单---使用Code
	
	s tempCode=##Class(DtPortal.Common.PublicService).getValueByCode("TEMPERATURECODE")
	q:tempCode="" ""
	
	
	if ((hospID="")||'$d(^MRC("OBITM",0,"HOSPCode"))){
		s OBSItemDR=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(tempCode),0))  //bmz20180223--取Portal配置
		q:OBSItemDR="" ""
		s TItem=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(tempCode),0))
		s PItem=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("pulse"),0))
		s RItem=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("breath"),0))
		s DBPItem=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("sysPressure"),0))
		s SBPItem=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("diaPressure"),0))
		
		s TItem2=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("rectemperature"),0))
	}else{
		s OBSItemDR=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4(tempCode),0))  //bmz20180223--取Portal配置
		q:OBSItemDR="" ""
		s TItem=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4(tempCode),0))
		s PItem=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4("pulse"),0))
		s RItem=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4("breath"),0))
		s DBPItem=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4("sysPressure"),0))
		s SBPItem=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4("diaPressure"),0))
		
		s TItem2=$o(^MRC("OBITM",0,"HOSPCode",hospID,$$ALPHAUP^SSUTIL4("rectemperature"),0))
	}
	
	
	
	
	
	s OBSDate=""
	f  s OBSDate=$o(^MR(mradm,"OBS",0,"Date",OBSDate),-1) q:OBSDate=""  d
	.i TItem'="" d
	..s Childsub=""
	..f  s Childsub=$o(^MR(mradm,"OBS",0,"Date",OBSDate,TItem,Childsub),-1) q:((Childsub="")||(Temperature'=""))  d
	...s Temperature=$p($g(^MR(mradm,"OBS",Childsub)),"^",2)
	.i TItem2'="" d
	..s Childsub=""
	..f  s Childsub=$o(^MR(mradm,"OBS",0,"Date",OBSDate,TItem2,Childsub),-1) q:((Childsub="")||(Temperature2'=""))  d
	...s Temperature2=$p($g(^MR(mradm,"OBS",Childsub)),"^",2)
    .i PItem'="" d
	..s Childsub=""
	..f  s Childsub=$o(^MR(mradm,"OBS",0,"Date",OBSDate,PItem,Childsub),-1) q:((Childsub="")||(Pulse'=""))  d
	...s Pulse=$p($g(^MR(mradm,"OBS",Childsub)),"^",2)
	.i RItem'="" d
	..s Childsub=""
	..f  s Childsub=$o(^MR(mradm,"OBS",0,"Date",OBSDate,RItem,Childsub),-1) q:((Childsub="")||(Breathe'=""))  d
	...s Breathe=$p($g(^MR(mradm,"OBS",Childsub)),"^",2)
	.i DBPItem'="" d
	..s Childsub=""
	..f  s Childsub=$o(^MR(mradm,"OBS",0,"Date",OBSDate,DBPItem,Childsub),-1) q:((Childsub="")||(Diastolic'=""))  d
	...s Diastolic=$p($g(^MR(mradm,"OBS",Childsub)),"^",2)
	.i SBPItem'="" d
	..s Childsub=""
	..f  s Childsub=$o(^MR(mradm,"OBS",0,"Date",OBSDate,SBPItem,Childsub),-1) q:((Childsub="")||(Systolic'=""))  d
	...s Systolic=$p($g(^MR(mradm,"OBS",Childsub)),"^",2)
	s VitalSign=Temperature_"^"_Pulse_"^"_Breathe_"^"_Diastolic_"^"_Systolic_"^"_Temperature2
	q VitalSign
GetVitalSignByAdm
	q -1
}

/// Creator： 
/// CreatDate： 
/// Description: 取科主任的默认科室ID
/// Input：  userCode         
/// Return：DDLocID
/// w ##class(DtPortal.Common.PaadmService).getDDLocIDByUserCode("601")
ClassMethod getDDLocIDByUserCode(UserCode) As %String
{
	
	q ""  //不获取默认登录科室
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	q:UserId="" ""
	set DDLocID=""
	
	/*
	set sub=0
	for
	{
		set sub=$o(^SSU("SSUSR",UserId,"OTHLL",sub))
		q:sub=""
		set CTLocDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",1) 
		set CTGroupDr=$p($g(^SSU("SSUSR",UserId,"OTHLL",sub)),"^",2) 
		set GroupDesc=$p($g(^SSU("SSGRP",CTGroupDr)),"^",1) 
		set:GroupDesc="住院医师（主任）" DDLocID=CTLocDr	
	}    */
	//修改成取医生默认登录科室

	
	s DDLocID=$p($g(^SSU("SSUSR",UserId)),"^",4) //增加默认登陆位置
	s HOSID=$p($g(^CTLOC(DDLocID)),"^",15)
	;W HOSID,!
	q DDLocID
}

/// Creator： bmz
/// CreatDate： 20160419
/// Description: 根据就诊Id,取出院诊断-----用于Portal公共服务
/// Input：		PAAdm : 就诊Id
/// Type: 取出院诊断
/// Return： 	 
/// 
/// Debug：w ##class(DtPortal.Common.PaadmService).GetDisDiagnosis(2028)
ClassMethod GetDisDiagnosis(PAAdm As %String) As %String
{
 	s DisDiagnosis=""
 	q:PAAdm="" ""
 	s disConf=##Class(DtPortal.Common.PublicService).getValueByCode("DISDIAGNOSIS")
 	if (disConf=1){
	 	//取诊断录入界面诊断
	  	s DisDiagnosis=##class(DtPortal.Common.PaadmService).GetAdmDiagnosis(PAAdm,"DIS")
	}elseif(disConf=2){
		//取电子病历病案首页的出院主诊断
		s result=##Class(EMRservice.BIEMRService).GetDataByGlossary(PAAdm,"HDSD00.11.024")
		if (result.Count()>0){
			s key=result.Previous()
			s DisDiagnosis=result.GetAt(key)
		}	
	}else{
		//取诊断录入界面诊断
	  	s DisDiagnosis=##class(DtPortal.Common.PaadmService).GetAdmDiagnosis(PAAdm,"DIS")
	}
	
	
	q DisDiagnosis
}

/// Creator：     chengpeng
/// CreatDate：   2016-04-25
/// Description:  查询医生的登录的科室和安全组
/// Table：       User.CTLOC
/// Input：       inputStr     ：科室首字母或者汉字
/// Return：      科室ID，科室描述
/// d ##Class(%ResultSet).RunQuery("DtPortal.Common.PaadmService","FindLogonStr","YS01")
Query FindLogonStr(UserCode As %String) As DtPortal.Query(ROWSPEC = "DefaultLocID:%String,DefaultGrpID:%String,DefaultHospID:%String,DefaultLoc:%String,DefaultGrp:%String,DefaultHosp:%String")
{
}

ClassMethod FindLogonStrExecute(ByRef qHandle As %Binary, UserCode As %String) As %Status
{
    Set repid=$I(^||CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	if UserCode="" Quit $$$OK
	s UserID=""
	s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,0))
	if UserID="" Quit $$$OK
	
   
	s objUser = ##class(User.SSUser).%OpenId(UserID)
	
	s DefaultLoc=objUser.SSUSRDefaultDeptDR.CTLOCDesc
	s DefaultLocID = objUser.SSUSRDefaultDeptDR.%Id()
	s DefaultGrp = $s($IsObject(objUser.SSUSRGroup):objUser.SSUSRGroup.SSGRPDesc,1:"")
	s DefaultGrpID = objUser.SSUSRGroup.%Id()
	s DefaultHospID = "",DefaultHosp=""
	s:objUser.SSUSRHospitalDR'="" DefaultHospID=objUser.SSUSRHospitalDR.%Id()
	s:DefaultHospID="" DefaultHospID=$p(^CTLOC(DefaultLocID),"^",22)
	s:DefaultHospID'="" DefaultHosp = $p(^CT("HOSP",DefaultHospID),"^",2)
	s:DefaultLoc["-" DefaultLoc=$p(DefaultLoc,"-",2)
	
	Set Data=$lb(DefaultLocID,DefaultGrpID,DefaultHospID,DefaultLoc,DefaultGrp,DefaultHosp)
	Set ^||CacheTemp(repid,ind)=Data
	Set ind=ind+1
		
	s myCount = objUser.ChildSSUserOtherLogonLoc.Count()
	f myIdx=1:1:myCount{
		set DefaultLocID=""
		set DefaultGrpID=""
		s objUserLoc = objUser.ChildSSUserOtherLogonLoc.GetAt(myIdx)
		
		//增加开始日期，截止日期的过滤
		s StartDate=objUserLoc.OTHLLStartDate
		s EndDate=objUserLoc.OTHLLEndDate
		continue:(StartDate'="")&&(StartDate>+$h)
		continue:(EndDate'="")&&(EndDate<+$h)
		
		s DefaultLocID = objUserLoc.OTHLLCTLOCDR.%Id()
		s:objUserLoc.OTHLLCTLOCDR'="" DefaultLoc = objUserLoc.OTHLLCTLOCDR.CTLOCDesc
		s:objUserLoc.OTHLLUserGroupDR'="" DefaultGrpID = objUserLoc.OTHLLUserGroupDR.%Id()
		s DefaultGrp = $s($IsObject(objUserLoc.OTHLLUserGroupDR):objUserLoc.OTHLLUserGroupDR.SSGRPDesc, 1:"")
		
		set DefaultHospID="",DefaultHosp=""
		if objUserLoc.OTHLLHospitalDR'=""{
			set DefaultHospID = objUserLoc.OTHLLHospitalDR.%Id()	
		}
		set:DefaultHospID="" DefaultHospID=$p(^CTLOC(DefaultLocID),"^",22)
		s:DefaultHospID'="" DefaultHosp = $p(^CT("HOSP",DefaultHospID),"^",2)
		
		s objUserLoc=""
		s:DefaultLoc["-" DefaultLoc=$p(DefaultLoc,"-",2)
		i myIdx
		Set Data=$lb(DefaultLocID,DefaultGrpID,DefaultHospID,DefaultLoc,DefaultGrp,DefaultHosp)
		Set ^||CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
    Quit $$$OK
}

/// Creator：    bmz
/// CreatDate：   2017-07-14
/// Description:  查询用户有权限的科室
/// Input：       UserCode 	   ：用户工号
///               
///               NH00.00.01
/// Return：      用户有权限的科室
/// d ##class(%ResultSet).RunQuery("DtPortal.Common.PaadmService","findWardOrLocInfoByRole","NurseHead",2156)
Query findWardOrLocInfoByRole(roleCodeStr As %String, userCode As %String) As DtPortal.Query(ROWSPEC = "desc:%String,id:%String,roleCode:%String,wardLocID,groupID,hospitalID,hospitalDesc,wardLocCode:%String,wardLocName:%String,groupDesc")
{
}

ClassMethod findWardOrLocInfoByRoleExecute(ByRef qHandle As %Binary, roleCodeStr As %String, userCode As %String) As %Status
{

	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:(userCode="")||(roleCodeStr="") $$$OK
	
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",userCode,0))
	q:userId="" $$$OK
	s wardLocID="",groupID="",hospitalID="",hospitalDesc=""
	//判断是否护士长类型的，取所有的登录病区
	if (roleCodeStr["NurseHead"){
		s roleCode="NurseHead"
		k ^||TempFindWardOrLocInfoByRole
		set groupStr=##Class(DtPortal.Configure.RoleGroup).getGroupStr("NurseHead")
		set groupStr="^"_groupStr_"^"
		s defaultWardId="",defaultWardDesc=""
		s defaultDept=$p($g(^SSU("SSUSR",userId)),"^",4) //增加默认登陆位置
		Quit:defaultDept="" $$$OK
		s WardLocType=$P(^CTLOC(defaultDept),"^",13)  //非W不取
		Set defaultWardId=$o(^PAWARD(0,"WARD_LocationDR",defaultDept,""))
		s wardId=defaultWardId
		s desc="",id=""
		i wardId'="" d
		.s wardDesc=$p(^PAWARD(wardId),"^",2)
		.i wardDesc'="" d
		..i wardDesc["-" s desc=$p(wardDesc,"-",2)
		..e  s desc=wardDesc
		.s:wardId'="" id=wardId
		.s wardLocID=defaultDept
		
		s groupID=$p($g(^SSU("SSUSR",userId)),"^",5)
		s groupDesc=$p($g(^SSU("SSGRP",groupID)),"^",1)  //取安全组描述
		
		Set hospitalID=$P($g(^CTLOC(defaultDept)),"^",22)
		set ifEX=""
		If hospitalID'="" Set hospitalDesc=$P($g(^CT("HOSP",hospitalID)),"^",2)
		set groupID1="^"_groupID_"^"
		set wardLocCode=$p(^PAWARD(wardId),"^",1)
		set wardLocName=desc
		if (WardLocType="W")&(id'="")&(groupStr[groupID1)
		{
			S ifEX="1"
			s Data=$lb(desc,id,roleCode,wardLocID,groupID,hospitalID,hospitalDesc,wardLocCode,wardLocName,groupDesc)
	 		s ^||CacheTemp(repid,ind)=Data	
	 		s ind=ind+1
		}
		//取其他登录病区
		s sub=0  //从0后面开始取
		f  s sub=$o(^SSU("SSUSR",userId,"OTHLL",sub)) q:sub=""  d
		.s CTLocDr=$p($g(^SSU("SSUSR",userId,"OTHLL",sub)),"^",1)
		.q:+CTLocDr=0
		.s WardLocType=$P(^CTLOC(CTLocDr),"^",13) 
		.q:WardLocType'="W"
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",CTLocDr,""))
		.q:wardId=""
		.q:(ifEX="1")&&(defaultWardId=wardId)
		.s groupId=$p($g(^SSU("SSUSR",userId,"OTHLL",sub)),"^",2)  //不按安全组过滤
		.s groupDesc=$p($g(^SSU("SSGRP",groupId)),"^",1)  //取安全组描述
		.s groupID1="^"_groupId_"^"
		.q:groupStr'[groupID1
		.s:wardId'="" ^||TempFindWardOrLocInfoByRole(wardId,groupId)=CTLocDr
		s id=""
		for
		{
			s id=$o(^||TempFindWardOrLocInfoByRole(id))
			q:id=""
			s groupID=""
			for
			{
				s groupID=$o(^||TempFindWardOrLocInfoByRole(id,groupID))
				q:groupID=""
				s wardLocID=^||TempFindWardOrLocInfoByRole(id,groupID)
				
				Set hospitalID=$P($g(^CTLOC(wardLocID)),"^",22)
				If hospitalID'="" Set hospitalDesc=$P($g(^CT("HOSP",hospitalID)),"^",2)
				
				s wardDesc=$p(^PAWARD(id),"^",2)
				i wardDesc'="" d
				i wardDesc["-" s desc=$p(wardDesc,"-",2)
				e  s desc=wardDesc
				set wardLocCode=$p(^PAWARD(id),"^",1)
				set wardLocName=wardDesc
				s groupDesc=$p($g(^SSU("SSGRP",groupID)),"^",1)  //取安全组描述
				s Data=$lb(desc,id,roleCode,wardLocID,groupID,hospitalID,hospitalDesc,wardLocCode,wardLocName,groupDesc)
	 			s ^||CacheTemp(repid,ind)=Data	
	 			s ind=ind+1
			
			}
			
		}
	
		k ^||TempFindWardOrLocInfoByRole
	}
	//取科主任的科室信息
	if (roleCodeStr["DirectorDoctor"){
		s roleCode="DirectorDoctor"
		set isDake=0
		set type=""
		set LocGroupIDStr="^"
		set locGropID=""
		for
		{
			set locGropID=$o(^DtPortal.Configure.LocGroupI("HEAD","IndexDocHead",userId,locGropID))
			quit:locGropID=""
		
			set locGropObj=##class(DtPortal.Configure.LocGroup).GetObjById(locGropID)
			continue:'$IsObject(locGropObj)
			
			set locGropDesc=locGropObj.LocGroupDesc
			set locGropDesc=locGropDesc_"(大科)"
			set rowID=locGropID
		
			 set locIdStr1=##class(DtPortal.DD.DD00PublicService).getDDloc(rowID,"I")
			 set locIdStr2=##class(DtPortal.DD.DD00PublicService).getDDloc(rowID,"O")
			 set wardLocID=locIdStr1_"#"_locIdStr2
			 set locCodeStr1=##class(DtPortal.DD.DD00PublicService).getDDlocCode(rowID,"I")
			 set locCodeStr2=##class(DtPortal.DD.DD00PublicService).getDDlocCode(rowID,"O")
			 set locNameStr1=##class(DtPortal.DD.DD00PublicService).getDDlocName(rowID,"I")
			 set locNameStr2=##class(DtPortal.DD.DD00PublicService).getDDlocName(rowID,"O")
			 set wardLocCode=locCodeStr1_"#"_locCodeStr2
			 set wardLocName=locNameStr1_"#"_locNameStr2
			
			//set type="locGrop"
			//set isDake=1
			//set LocGroupIDStr=LocGroupIDStr_locGropID_"^"
		
	
			;set LocIDStr=""
			//set locSubID=""
			//for
			//{
				//set locSubID=$o(^DtPortal.Configure.LocGroupD(locGropID,"Log",locSubID))
				//quit:locSubID=""
		
				//set rowID=locGropID_"||"_locSubID
				//set locGropSubObj=##class(DtPortal.Configure.LocGroupSub).GetObjById(rowID)
				//continue:'$IsObject(locGropSubObj)
			
				;set type=locGropSubObj.LocGroupType
				;continue:type'="I"
				;set LocID=locGropSubObj.LocGroupLocID.%Id()
				;set:LocIDStr'="" LocIDStr= LocIDStr_"^"_LocID
				;SET:LocIDStr="" LocIDStr=LocID
				;set LocDesc=locGropSubObj.LocGroupLocID.CTLOCDesc
				;set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
				;set type="loc"
				//set LocGroupIDStr=LocGroupIDStr_rowID_"^"
			
		
			;}
			;set rowID=LocIDStr
			Set Data=$lb(locGropDesc,rowID,roleCode,wardLocID,groupID,hospitalID,hospitalDesc,wardLocCode,wardLocName,1)
				Set ^||CacheTemp(repid,ind)=Data
				Set ind=ind+1
		}
	
		set locGropID=""
		for
		{
			set locGropID=$o(^DtPortal.Configure.LocGroupI("SUBHEAD","IndexDocHead",userId,locGropID))
			quit:locGropID=""
		
			set locSubID=""
			for
			{
				set locSubID=$o(^DtPortal.Configure.LocGroupI("SUBHEAD","IndexDocHead",userId,locGropID,locSubID))
				quit:locSubID=""
		
				set rowID=locGropID_"||"_locSubID
				set locGropSubObj=##class(DtPortal.Configure.LocGroupSub).GetObjById(rowID)
				continue:'$IsObject(locGropSubObj)
				 set locIdStr1=##class(DtPortal.DD.DD00PublicService).getDDloc(rowID,"I")
				set locIdStr2=##class(DtPortal.DD.DD00PublicService).getDDloc(rowID,"O")
				set wardLocID=locIdStr1_"#"_locIdStr2
				set locCodeStr1=##class(DtPortal.DD.DD00PublicService).getDDlocCode(rowID,"I")
			  	set locCodeStr2=##class(DtPortal.DD.DD00PublicService).getDDlocCode(rowID,"O")
				set wardLocCode=locCodeStr1_"#"_locCodeStr2
				set locNameStr1=##class(DtPortal.DD.DD00PublicService).getDDlocName(rowID,"I")
				set locNameStr2=##class(DtPortal.DD.DD00PublicService).getDDlocName(rowID,"O")
			    set wardLocName=locNameStr1_"#"_locNameStr2
				set LocID=locGropSubObj.LocGroupLocID.%Id()
				;SET rowID=LocID
				set LocDesc=locGropSubObj.LocGroupLocID.CTLOCDesc
				set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
				
				//set type="loc"
				//set rowStr="^"_rowID_"^"
				//continue:LocGroupIDStr[rowStr
			
				Set Data=$lb(LocDesc,rowID,roleCode,wardLocID,groupID,hospitalID,hospitalDesc,wardLocCode,wardLocName,1)
				Set ^||CacheTemp(repid,ind)=Data
				Set ind=ind+1
				}		
			}

  	
	}
	q $$$OK
}

// 获取在院患者入院天数---bmz20170809

// w ##class(DtPortal.Common.PaadmService).getInDayByInPat(12)

ClassMethod getInDayByInPat(EpisodeID)
{
	Set $ZT="getInDayByInPat"
	s inDay=0
	
	//预住院直接返回0
	s paadmVisType=$p($g(^PAADM(+EpisodeID)),"^",20)
	i paadmVisType="P" q inDay
	
	s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
	s inDate=$p(inDateTimeStr,"^",1)   //入院日期
	i +inDate=0 q 0
	s outDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(EpisodeID)
	s outDate=$p(outDateTimeStr,"^",1)   //出院日期
	
	if (+outDate=0) {    //没有出院时间，及病人未开出院医嘱
		s inDay=+$h-inDate   //当天时间-入院时间
	}else{
		if (outDate>+$h) {
			s inDay=+$h-inDate    //用最小的减
		} else{
			s inDay=outDate-inDate    //有配置的出院时间-入院时间
		}
	}
	if (inDay=0&&+outDate'=0){   //当天入当天出院的情况
			s inDay=1
		}
	q inDay
	
getInDayByInPat
	q -1
}

// 获取出院患者入院天数---bmz20170809

// w ##class(DtPortal.Common.PaadmService).getInDayByOutPat(12)

ClassMethod getInDayByOutPat(EpisodeID)
{
	s inDay=0
	Set $ZT="getInDayByOutPat"
	s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(EpisodeID)
	s inDate=$p(inDateTimeStr,"^",1)   //入院日期
	i +inDate=0 q 0
	s outDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(EpisodeID)
	s outDate=$p(outDateTimeStr,"^",1)   //出院日期
	i +outDate=0 q 0
	
	s inDay=outDate-inDate    //有配置的出院时间-入院时间
	if (inDay=0){   //当天入当天出院的情况
		s inDay=1
	}
	
	q inDay
	
getInDayByOutPat
	q -1
}

// 获取死亡患者死亡小结---zl 20170904

// w ##class(DtPortal.Common.PaadmService).getDeadPatSummary(306)

ClassMethod getDeadPatSummary(EpisodeID)
{
	//调用电子病历的接口，获取死亡小结的数据
	s obj=##Class(DtPortal.Doctor.EMRInfoService).GetPortalDeathSummaryInfo(EpisodeID)
	s Summary=""
	i (obj'="")&&(obj.data'="") do
	.s Summary="入院情况："_obj.data.GetAt("HDSD00.14.080")_"。"
 	.s Summary=Summary_$c(10)_$c(13)_"入院日期："_$p(obj.data.GetAt("HDSD00.14.081")," ",1)_"。"
 	.s Summary=Summary_$c(10)_$c(13)_"入院诊断："_obj.data.GetAt("HDSD00.14.082")_"。"
 	.s Summary=Summary_$c(10)_$c(13)_"死亡日期："_$p(obj.data.GetAt("HDSD00.14.104")," ",1)_"。"
 	.s Summary=Summary_$c(10)_$c(13)_"死亡诊断："_obj.data.GetAt("HDSD00.14.107")_"。"
	i $G(Summary)="" s Summary=""
 	q $g(Summary)
}

/// 取全院某天有某医嘱的病人数(通过医嘱配置中的code取出病人总数)
/// Creator： 程鹏
/// CreatDate： 2017-11-22
/// Description: 查询某类医嘱总例数
/// Input：  Date、OrderCode----demo中配置的医嘱Code         
/// Return： 数组集合 有某类医嘱的总人数
/// d ##class(DtPortal.Common.PaadmService).GetArcData("2017-11-22","SIWANG")
ClassMethod GetArcData(Date, OrderCode) As %String
{
	
	k ^||TEMPPortalArcData($j)
	set:Date["-" Date=$zdh(Date,3)
	set:Date["/" Date=$zdh(Date,1)
	set OrderCode=$$ALPHAUP^SSUTIL4(OrderCode)
	set ArcimIDs=##Class(DtPortal.Configure.arcim).getArcImID(OrderCode,1)  //医嘱ID串
	for index=1:1:$l(ArcimIDs,"^")
	{
	
		set rowid=$p(ArcimIDs,"^",index)
		quit:rowid=""
		set ordID=""
		for
		{
			set ordID=$o(^OEORDi(0,"DateARCIM",Date,rowid,ordID))
			quit:ordID=""
		
			set Paadm=$p(^OEORD(+ordID),"^",1)
			Continue:$p($g(^PAADM(+Paadm)),"^",2)'="I"   //就诊类型过滤
			Continue:$p($g(^PAADM(+Paadm)),"^",20)'="A"   //就诊状态过滤
			set LocID=$p(^PAADM(Paadm),"^",4)
			set wardID=$p(^PAADM(Paadm),"^",70)
			continue:wardID="" 
			set OrdSub=""
			for
			{
				set OrdSub=$o(^OEORDi(0,"DateARCIM",Date,rowid,ordID,OrdSub))
				quit:OrdSub=""
			
				set OreSub=""
				for
				{
					set OreSub=$o(^OEORDi(0,"DateARCIM",Date,rowid,ordID,OrdSub,OreSub))
					quit:OreSub=""
				
					set ordStatusId=$p($g(^OEORD(ordID,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 					set ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 					continue:(ordStat'="V")&(ordStat'="E") 
				    
				 
				    if '$d(^||TEMPPortalArcData($j,wardID,Paadm))
				    {
					  set ^||TEMPPortalArcData($j)=+$g(^||TEMPPortalArcData($j))+1
					  set ^||TEMPPortalArcData($j,wardID)=$g(^||TEMPPortalArcData($j,wardID))+1
					  set ^||TEMPPortalArcData($j,wardID,Paadm)=""			  		  
					}

				    			
					
				}
			}
		
		}
	}
	
	q ""
}

// 获取入院日期

// w ##class(DtPortal.Common.PaadmService).GetAdminDateTime()

ClassMethod GetAdminDateTime(EpisodeID)
{
	Set $ZT="GetAdminDateTime"
	s date=$p($g(^PAADM(EpisodeID,"DHC")),"^",31)
	s timePIn=$p($g(^PAADM(EpisodeID,"DHC")),"^",32)
	
	//老版本没有入院时间配置，取就诊表中的入院时间
	//s date=$P($g(^PAADM(EpisodeID)),"^",6)
	//s timePIn=$P($g(^PAADM(EpisodeID)),"^",7)
	
	q date_"^"_timePIn
GetAdminDateTime
	q -1
}

// 获取出院日期

// w ##class(DtPortal.Common.PaadmService).GetDischargeDateTime(79)

ClassMethod GetDischargeDateTime(EpisodeID)
{
	Set $ZT="GetDischargeDateTime"
	s datePDis=$p($g(^PAADM(EpisodeID,"DHC")),"^",29)
	s timePDis=$p($g(^PAADM(EpisodeID,"DHC")),"^",30)
	if (datePDis=""){
		s datePDis=$P($g(^PAADM(EpisodeID)),"^",17)
		s timePDis=$P($g(^PAADM(EpisodeID)),"^",18)
	}
	q datePDis_"^"_timePDis
GetDischargeDateTime
	q -1
}

/// 判断患者某天是否有某类医嘱
/// 可传多类医嘱,同事判断多个
/// Creator： 程鹏
/// CreatDate： 2018-11-02
/// Description: 判断患者某天是否有某类医嘱
/// Input：  Paadm		患者就诊号
/// Input：  ArcimIDs	医嘱ID串(一类医嘱如:全部护理(1||2^1||3^1||4);多类医嘱中间用*分割,如全部护理,病危(1||2^1||3^1||4*3||3))
/// Input：  date       日期,如果传空取当天
/// Return： 	-1 程序出错  "" 没有该医嘱  一级护理(医嘱描述) 有该医嘱
/// w ##class(DtPortal.Common.PaadmService).IsHaveArc("453","11362||1*11363||1")
ClassMethod IsHaveArc(Paadm, ArcimIDs, Date = "") As %String
{

	set return=""
	Set $ZT="IsHaveArc"
		
	set ArcimIDs=$tr(ArcimIDs,"*","^*^")
	set ArcimIDs="^"_ArcimIDs_"^"
	set:Date["-" Date=$zdh(Date,3)
	set:Date["/" Date=$zdh(Date,1)
	set:Date="" Date=+$h
	set ord=$o(^OEORD(0,"Adm",Paadm,""))
	set ArcimIDStrTemp=""
	q:ord="" ""
	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,Date,ordSttTime)) q:ordSttTime=""  d
	.s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,Date,ordSttTime,OrdSub)) q:OrdSub=""  d
	..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,Date,ordSttTime,OrdSub,OreSub)) q:OreSub=""   d
	...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
	...q:ordStatusId=""
	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
	...q:(ordStat'="V")&(ordStat'="E")
	...s ArcimIDTemp=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
	...set arcDesc=$p(^ARCIM($p(ArcimIDTemp,"||",1),$p(ArcimIDTemp,"||",2),1),"^",2)
	...q:$LF($LISTFROMSTRING(ArcimIDStrTemp,"^"),ArcimIDTemp)   //判断重复
	...s ArcimID="^"_ArcimIDTemp_"^"
	...q:ArcimIDs'[ArcimID
	...s ArcimIDStrTemp=ArcimIDTemp_"^"_ArcimIDStrTemp
	...s:return'="" return=return_"/"_arcDesc
	...s:return="" return=arcDesc
	
	q return
	
IsHaveArc
    w !,$ze
 	q -1
}

/// Creator： 程鹏
/// CreatDate： 2018-10-10
/// Description: 获取当天是否有某类医嘱(判断多个)
/// Input：	episodeId
/// Input：	ArcCode  用^分隔
/// Return：1^0^1^1  按照入参ArcCode顺序依次返回，如果有该医嘱，返回1，没有返回0
/// Debug：w ##class(DtPortal.Common.PaadmService).getArcNums("4","")
ClassMethod getArcNums(episodeId As %String, arcimIDs As %String) As %String
{
	
	k ^||TMPPortalgetArcNums
	set ord=$o(^OEORD(0,"Adm",episodeId,""))
 	quit:ord="" 0
 	set ordSttTime="" 
 	for
 	{
	 	set ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) 
	 	quit:ordSttTime=""
	 	
	 	set OrdSub=0
	 	for
	 	{
		 	set OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) 
		 	quit:OrdSub=""
		 	
		 	set OreSub=0
		 	for
		 	{
			 	set OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) 
			 	quit:OreSub=""
			 	
			 	set ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 				set ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 				continue:(ordStat'="V")&(ordStat'="E") 
 				set ArcRowId=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 				set ArcRowIdsS="^"_ArcRowId_"^"
 				
 				for index=1:1:$l(arcimIDs,"*")
 				{
	 				set arcimIDs2=$p(arcimIDs,"*",index)
	 				set arcimIDs2="^"_arcimIDs2_"^"
	 				continue:("^"_arcimIDs2_"^")'[ArcRowIdsS
	 				set ^||TMPPortalgetArcNums("arcimNum",index)=1
	 			}
			}
		}
	}  
	
	set retStr=""
 	set index=0
 	for index=1:1:$l(arcimIDs,"*")
 	{
	 	set num=+$g(^||TMPPortalgetArcNums("arcimNum",index))
	 	set:retStr'="" retStr=retStr_"^"_num
	 	set:retStr="" retStr=num
	}
 
	k ^||TMPPortalgetArcNums
	q retStr
}

/// Creator： 程鹏
/// CreatDate： 2018-11-05
/// Description: 判断患者当前是否欠费,根据床位图标识判断,取床位图数据
/// Input：  Paadm		患者就诊号ARREARSFLAG
/// Return： -1^^ 程序出错 0^10000^900 不欠费  1^10000^-500 总费用^余额
/// w ##class(DtPortal.Common.PaadmService).IsArrears(2)
ClassMethod IsArrears(Paadm) As %String
{

	set return="0^^"
	Set $ZT="IsArrears"
	
	//旧版取欠费图标
	//欠费取数规则取配置,值为预警,或者完全控制
	//set ARREARSFLAG=##Class(DtPortal.Common.PublicService).getValueByCode("ARREARSFLAG")
	//取床位图标志,预警或者完全控制,返回1欠费,返回0 不欠费
	//s stats=##class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(Paadm,"A",ARREARSFLAG)	
	
	//取新版欠费图标
	s stats= ##class(web.DHCSETIMAGE).IFArrea(Paadm)
	
	//取床位图信息
	set DepositFeeInfo=##class(web.DHCNurIpComm).NurPatInfo(Paadm)
	set TotalCost=$p(DepositFeeInfo,"^",7)
	set Balance=$p(DepositFeeInfo,"^",20)
	
	set return=stats_"^"_TotalCost_"^"_Balance
	
	q return
IsArrears
	q "-1^^"
}

/// Creator： 程鹏
/// CreatDate： 2018-11-07
/// Description: 获取打开电子病历首页所需要的参数
/// Input：  Paadm			患者就诊号
/// Return： EMRDocID^EMRInstanceID^locID^PatientID^EpisodeID  病历目录展现结构ID^病历实例数据ID^病人科室Id^病人基本信息id^就诊id
/// 备注:	 打开电子病历需要6个参数,除了这五个还需要UserID,需要自己获取返回前台
/// w ##class(DtPortal.Common.PaadmService).GetEMRParameter(2)
ClassMethod GetEMRParameter(Paadm) As %String
{

	set return="^^^^^"
	Set $ZT="GetEMRParameter"
	
	q:+Paadm=0 return
	
	//兼容性判断--为了兼容旧版本，新标准版目前有改变--20211230
	s key=""
	if ($d(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_Paadm)))
	{
		s key=" "
	}
	
	Set BreakFlag="",EMIDocID="",EMIInstanceID="",curlocID="",curPatientID="",curEpisodeID=""
	
	Set EMRDocID=""
	For
	{
		Set EMRDocID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",key_Paadm,EMRDocID))
		Quit:((EMRDocID="")||(BreakFlag="1")) 
		
		Set ECRecordID=""
		For
		{
			Set ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",key_Paadm,EMRDocID,ECRecordID))
			Quit:((ECRecordID="")||(BreakFlag="1"))
		
			Set ListNo=""
			For
			{
				Set ListNo=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo))
				Quit:((ListNo="")||(BreakFlag="1"))
				Set Rowid=""
				For
				{
					Set Rowid=$o(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordID,ListNo,Rowid))
					Quit:Rowid=""
					
					Set InstanceID=ECRecordID_"||"_Rowid
					Set objInstance=##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
					If (objInstance.Status="Save")
					{
						Set BreakFlag="1"
						Set objEcrecord=##Class(EMRinstance.ECRecord).%OpenId(ECRecordID)
						Set curPatientID=objEcrecord.PatientID
						Set curEpisodeID=objEcrecord.EpisodeID
						if ($IsObject(curEpisodeID)){
							s curEpisodeID=curEpisodeID.%Id()
						}
						Set EMIDocID=objEcrecord.ChartItemID
						if ($IsObject(EMIDocID)){
							s EMIDocID=EMIDocID.%Id()
						}
						Set EMIInstanceID=InstanceID
					}
					Quit:objInstance.Status="Save"
				}
				
			}
		}
	}
	set curlocID=$p($g(^PAADM(Paadm)),"^",4)
	set:curEpisodeID="" curEpisodeID=Paadm
	set:curPatientID="" curPatientID=$P($g(^PAADM(Paadm)),"^",1)
	set return=EMIDocID_"^"_EMIInstanceID_"^"_curlocID_"^"_curPatientID_"^"_curEpisodeID
	q return
GetEMRParameter
	q "^^^^^"
}

/// Creator：     bmz
/// CreatDate：   2018-12-12
/// Description:  获取等待区患者串
/// Input：       wardId-病区ID 
/// return        episodeID串，用"^"分割
///    
/// w ##Class(DtPortal.Common.PaadmService).getWaitingPatByWard("10")
ClassMethod getWaitingPatByWard(wardId) As %String
{
	q:wardId="" ""
	s episodeIDStr=""

	s sub=0
	f  s sub=$o(^PAWARDA(wardId,"WADM",sub)) q:sub=""  d
	.s data=$g(^PAWARDA(wardId,"WADM",sub))		
	.s episodeID=$p(data,"^",1)
	.s visitStatus=$p(^PAADM(episodeID),"^",20)
	.q:visitStatus'="A"	
	.i episodeIDStr="" s episodeIDStr=episodeID
	.e  s episodeIDStr=episodeIDStr_"^"_episodeID
	q episodeIDStr
}

/// Creator：     bmz
/// CreatDate：   2018-12-27
/// Description:  获取患者病历首页是否完成
/// Input：       就诊ID
/// return        完成   未完成   ""
///    
/// w ##Class(DtPortal.Common.PaadmService).getEMRIfFinish("10")
ClassMethod getEMRIfFinish(Paadm) As %String
{
	q:Paadm="" ""
	//病案首页展现ID取配置
	set HOMEPAGE=##Class(DtPortal.Common.PublicService).getValueByCode("HOMEPAGE")
	//取项目电子病历首页病历展现结构id
	s IfFinish=""
	s rs=##class(%ResultSet).%New("DtPortal.Doctor.EMRInfoService:GetEMRHDSD0011")
	d rs.Execute(Paadm,HOMEPAGE)
	f  Quit:'rs.Next()  d
	.f i=1:1:rs.GetColumnCount() d
	..s IfFinish=rs.%GetData(i)
	d rs.Close()
	s HomePage=""
	i IfFinish'="" s HomePage="完成"
	e  s HomePage="未完成"
	q HomePage
}

/// Creator：    程鹏
/// CreatDate：  2019-01-07
/// Description: 判断患者当前是否死亡上报
/// Input：  Paadm		患者就诊号
/// Return： -1^^ 程序出错; "" 未上报;  3^64961^50400^霍乱 已上报(返回上报信息 死亡报告ID^死亡日期^死亡时间^死亡原因)
/// w ##class(DtPortal.Common.PaadmService).IsDTHReport(282)
ClassMethod IsDTHReport(Paadm) As %String
{

	set return=""
	Set $ZT="IsDTHReport"
	
	//取是否上报死亡报卡
	set PatientID=$p($g(^PAADM(Paadm)),"^",1)
	quit:PatientID="" return
	s reportObj=##Class(DHCMed.DTH.Report).GetObjByPatientID(PatientID)
	quit:((reportObj="")||('$IsObject(reportObj))) return
	s description=reportObj.RepStatusDR.Description

	quit:((description="删除")||(description="作废")||(description="草稿")) return
   	set ID=reportObj.%Id()					//死亡报告ID
   	set DthDate=reportObj.DeathDate			//死亡日期
    set DthTime=reportObj.DeathTime			//死亡时间
   	set AReason=reportObj.AReason			//死亡原因
   	
   	set reportStr=##Class(DHCMed.DTHService.ReportInterface).GetDataByReportId(ID,"","","","")
   	set reson=$list(reportStr,51)
   	
   	set return=ID_"^"_DthDate_"^"_DthTime_"^"_reson
	
	q return
IsDTHReport
	q "-1"
}

/// Creator：     bmz
/// CreatDate：   2018-01-18
/// Description:  住院监控获取病区就诊ID串
/// Input：       就诊ID
/// return        
///    
/// w ##Class(DtPortal.Common.PaadmService).getAdmIDStrByWardID("10")
ClassMethod getAdmIDStrByWardID(wardID) As %String
{
	q ##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",wardID)
}

/// Creator： 白明哲
/// CreatDate： 2019-03-25
/// Description:根据用户、科室（病区）串查询返回对应的安全组
/// Input： 无 
/// Return： 
/// 服务代码：C00.00.12
/// w ##class(DtPortal.Common.PaadmService).GetGroupIDByUserDep("hs01","","NurseHead")
ClassMethod GetGroupIDByUserDep(userCode As %String = "", idStr As %String = "", type As %String = "") As DtPortal.OutPut
{
	#Dim ret As DtPortal.OutPut
	Set ret = ##class(DtPortal.OutPut).%New()
	Set ret.status = 1
	Set ret.errMSG = ""
	Set ret.data = ""
	if ((userCode="")||(idStr="")||(type="")){
		Set ret.status = -1
		Set ret.errMSG = "参数不能为空"
		goto returnGroupInfo
	}
	set userId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	if (userId=""){
		Set ret.status = -1
		Set ret.errMSG = "用户不存在"
		goto returnGroupInfo
	}	
	
	k ^||TempGroupInfo($j)
	if ((type="NurseHead")||(type="Nurse")||(type="EmergencyNH")){
		set groupStr=##Class(DtPortal.Configure.RoleGroup).getGroupStr(type)
		s defaultDept=$p($g(^SSU("SSUSR",userId)),"^",4) //增加默认登陆位置
		if (defaultDept'=""){
			Set defaultWardId=$o(^PAWARD(0,"WARD_LocationDR",defaultDept,""))
			s groupID=$p($g(^SSU("SSUSR",userId)),"^",5)
			if ((defaultWardId'="")&&(groupID'="")&&($LF($LISTFROMSTRING(groupStr,"^"),groupID))){
				s ^||TempGroupInfo($j,defaultWardId)=groupID
			}
		} 
		
		//取其他登录病区
		s sub=0  //从0后面开始取
		f  s sub=$o(^SSU("SSUSR",userId,"OTHLL",sub)) q:sub=""  d
		.s CTLocDr=$p($g(^SSU("SSUSR",userId,"OTHLL",sub)),"^",1)
		.q:+CTLocDr=0
		.s wardId=$o(^PAWARD(0,"WARD_LocationDR",CTLocDr,""))
		.q:wardId=""
		.s groupId=$p($g(^SSU("SSUSR",userId,"OTHLL",sub)),"^",2)
		.q:groupId=""
		.q:'$LF($LISTFROMSTRING(groupStr,"^"),groupId)
		.s ^||TempGroupInfo($j,wardId)=groupId
		
	}
	
	s idLength=$l(idStr,"^")
	s groupStr=""
	for index=1:1:idLength{
		s id=$p(idStr,"^",index)
		s $p(groupStr,"^",index)=$g(^||TempGroupInfo($j,id))
	}
	Set ret.status = 1
	Set ret.data = groupStr
	goto returnGroupInfo
	
	
		
returnGroupInfo
		
		Quit ret
}

/// Creator：     bmz
/// CreatDate：   2019-12-20
/// Description:  判断患者当前是否在床
/// Input：       wardId-病区ID 
/// return        1-在床   0-不在床或其他
///    
/// w ##Class(DtPortal.Common.PaadmService).IFPatInBed("96")
ClassMethod IFPatInBed(episodeID) As %String
{
	s flag=0
	q:episodeID="" flag
	
	s currBedId=$P($g(^PAADM(episodeID)),"^",73)
	q:currBedId="" flag
	;根据床位查找到患者--反向再验证
	s currId=$o(^PAWARDA($p(currBedId,"||",1),"BED",$p(currBedId,"||",2),"ADM",0))  
	q:currId="" flag
	s episodeIDBed=$p($g(^PAWARDA($p(currBedId,"||",1),"BED",$p(currBedId,"||",2),"ADM",currId)),"^",1)
	if (episodeID=episodeIDBed){
		s flag=1
	}
	q flag
}

/// Creator：     bmz
/// CreatDate：   2020-10-15
/// Description:  获取急诊患者所在分区
/// Input：       就诊ID
/// return        红区、橙区、黄区、绿区、""
///    
/// w ##Class(DtPortal.Common.PaadmService).GetEPatZone("96")
ClassMethod GetEPatZone(episodeID) As %String
{
	s ret=""
	q:episodeID="" ret
	s PAAdmPriority=""
	s Priority=$P($g(^PAADM(episodeID)),"^",33)
	i Priority'="" s PAAdmPriority=$p($g(^CT("ACU",Priority)),"^",1)
	q:PAAdmPriority="" ret
	s Area=PAAdmPriority
	s ret=$s(Area="1级":"红区",Area="2级":"橙区",Area="3级":"黄区",Area="4级":"绿区",Area="5级":"绿区",1:"")
	
	q ret
}

/// Creator：     bmz
/// CreatDate：   2021-1-19
/// Description:  就诊号排序输出
/// Input：       就诊ID串（"^"分隔）、sortType(1-按床号、2-按就诊时间)、type（0-正序、1-倒序）
/// return        排序后的就诊ID串，"^"分隔
///    
/// w ##Class(DtPortal.Common.PaadmService).GetSortAdmIdStr("6^26^27^31^35^36^40^44^47^69^80^88^90^91^127^128^146^148^149^150","1",0)
ClassMethod GetSortAdmIdStr(admIdStr, sortType, isDesc) As %String
{
	s ret=""
	k ^||tempSortAdmIdStr("GetSortAdmIdStr")
	s retNull=""	//没有排序标识的最后拼后面
	for admIndex=1:1:$L(admIdStr,"^")
	{
		set admId=$p(admIdStr,"^",admIndex)
		continue:admId=""
		if (sortType="1"){
			s bedCode=""
			Set bedId=$P($g(^PAADM(admId)),"^",73)
			if bedId'="" s bedCode=$P($g(^PAWARD(+bedId,"BED",$P(bedId,"||",2))),"^",1)
			
			if (bedCode=""){
				i retNull="" s retNull=admId
				e  s retNull=retNull_"^"_admId
			}else{
				s bedCode=" "_bedCode
				s ^||tempSortAdmIdStr("GetSortAdmIdStr",bedCode,admId)=""
			}
			
		}elseif(sortType="2"){
			s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(admId)
			s InDate=$p(inDateTimeStr,"^",1)
			if (InDate=""){
				s InDate=$ZD($P($g(^PAADM(admId)),"^",6),3)
			}
			
			if (InDate=""){
				i retNull="" s retNull=admId
				e  s retNull=retNull_"^"_admId
			}else{
				s ^||tempSortAdmIdStr("GetSortAdmIdStr",InDate,admId)=""
			}
		}

	}
	s sortValue=""
	for{
		if (isDesc=1){
			set sortValue=$o(^||tempSortAdmIdStr("GetSortAdmIdStr",sortValue),-1) 
		}else{
			set sortValue=$o(^||tempSortAdmIdStr("GetSortAdmIdStr",sortValue)) 
		}
		
		q:sortValue=""
		s admIdTemp=""
		for{
			s admIdTemp=$o(^||tempSortAdmIdStr("GetSortAdmIdStr",sortValue,admIdTemp)) 
			q:admIdTemp=""
			if ret="" {
				s ret=admIdTemp
			}else{
				s ret=ret_"^"_admIdTemp
			}
		}
	}  
	if ret="" s ret=admIdStr
	
	if (retNull'=""){
		s ret=ret_"^"_retNull
	}
	
	q ret
}

}

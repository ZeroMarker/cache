Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-05-11
/// Descript: 	急诊预检分诊公共类
Class web.DHCEMPatCheckLevCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("EMPatCheckLevCom"))
}

/// Descript: 	卡类型
/// W ##Class(web.DHCEMPatCheckLevCom).CardTypeDefineListBroker()
ClassMethod CardTypeDefineListBroker(HospID) As %String
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s SessionStr=""
	s del=""""
	s myTypeID=0
	s myDataFlag=0
	s myPEObj=##class(web.DHCBL.Configure.PatEnroll).DHCGetDataObjectBySession(SessionStr)
	if ($IsObject(myPEObj)){
		s myDataFlag=1
	}
	w "["
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.q:##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_CardTypeDef",myTypeID,HospID)'="Y"
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myval=myTypeID
	.s myval=myval_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.s myFindFlag=1
	.i +myDataFlag  d
	..s myFindFlag=myPEObj.FindCardTypeByDR(myTypeID)
	.q:(+myFindFlag=0)
	.s myIdx=myIdx+1
	.s mydes=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCCardTypeDef","CTDDesc","",mydes)
	.;s mydes=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OTHER","OTHER","EN","居民身份证")
	.i myIdx=1 d
	..w "{"_del_"text"_del_":"_del_mydes_del_","_del_"value"_del_":"_del_myval_del_"}"
	.e  d
	..w ",{"_del_"text"_del_":"_del_mydes_del_","_del_"value"_del_":"_del_myval_del_"}"
	.
	w "]"
	Q ""
}

/// Descript: 	默认卡类型
/// W ##Class(web.DHCEMPatCheckLevCom).GetDefaultCardType()
ClassMethod GetDefaultCardType() As %String
{
	s myTypeID=0
	s mySelFlag=0
	s myIdx=0
	f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")||(mySelFlag=1)  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.q:myDefault'="Y"
	.
	.s myval=myTypeID_"^"_$g(^DHCCARDTYPEDef(myTypeID))
	
	q myval
}

/// Descript: 	获取卡类型定义
/// w ##Class(web.DHCEMPatCheckLevCom).GetEmPatCardTypeDefine()
ClassMethod GetEmPatCardTypeDefine(CardTypeID As %String) As %String
{
	n (CardTypeID)
	q:CardTypeID="" ""
	s mydes=$p(^DHCCARDTYPEDef(CardTypeID),"^", 2)
	s myActiveFlag=$p(^DHCCARDTYPEDef(CardTypeID),"^", 11)		;CTD_ActiveFlag
	q:(myActiveFlag'="IE") ""
	s myDateTo=+$p(^DHCCARDTYPEDef(CardTypeID),"^", 10)		;CTD_DateTo
	q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	s myval=CardTypeID_"^"_$g(^DHCCARDTYPEDef(CardTypeID))
	q myval
}

/// Descritp:性别
/// W ##Class(web.DHCEMPatCheckLevCom).jsonCTSex()
ClassMethod jsonCTSex() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTSEX_RowId as CTSexDr,CTSEX_Desc as CTSexDesc,CTSEX_DateFrom as DateFrom,CTSEX_DateTo As DateTo,CTSEX_Activity as Activity FROM CT_SEX"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s SexDr = result.Data("CTSexDr")
		s SexDesc = result.Data("CTSexDesc")
		s DateFrom = result.Data("DateFrom")
		s DateTo = result.Data("DateTo")
		s Activity=result.Data("Activity") //hxy 2023-02-06 st
		continue:(Activity'="Y") //ed
		s SexDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",SexDesc)
		continue:(DateFrom'="")&&(+$h<DateFrom)
		continue:(DateTo'="")&&(+$h>DateTo)
		s tmp=SexDr_"^"_SexDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:职称
ClassMethod jsonCarPrvTp(Alise As %String = "") As %String
{
	N (Alise)
	s Alise=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId as CTCPTDr,CTCPT_Desc as CTCPTDesc FROM CT_CarPrvTp"
	s:Alise'="" sqlStr=sqlStr_" where CTCPT_Desc="_""""_Alise_""""
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s CTCPTDr = result.Data("CTCPTDr")
		s CTCPTDesc = result.Data("CTCPTDesc")
		s tmp=CTCPTDr_"^"_CTCPTDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:民族
ClassMethod jsonCTNation() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTNAT_RowId as NatDr,CTNAT_Desc as NatDesc,CTNAT_Activity as Activity FROM CT_Nation"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s NatDr = result.Data("NatDr")
		s NatDesc = result.Data("NatDesc")
		s Activity=result.Data("Activity") //hxy 2023-02-07 st
		continue:(Activity'="Y") //ed
		s NatDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTNation","CTNATDesc","",NatDesc)
		s:NatDesc["-" NatDesc=$p(NatDesc,"-",2)
		s tmp=NatDr_"^"_NatDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:国籍
ClassMethod jsonCTCountry() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCOU_DateActiveFrom as formDate,CTCOU_DateActiveTo as toDate,CTCOU_RowId as CouDr,CTCOU_Desc as CouDesc FROM CT_Country where CTCOU_Active='Y' "
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s CouDr = result.Data("CouDr")
		s CouDesc = result.Data("CouDesc")
		s:CouDesc["-" CouDesc=$p(CouDesc,"-",2)
		s CouDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCountry","CTCOUDesc","",CouDesc)
		s tmp=CouDr_"^"_CouDesc
		s formDate = +result.Data("formDate")
		s toDate = +result.Data("toDate")
		
		continue:((formDate'=0)&&(formDate>+$h))
		continue:((toDate'=0)&&(toDate<+$h))
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// 获取病人登记号长度
ClassMethod GetPatRegNoLen() As %String
{
	 s PatLen=$p(^CF("PATCF",1,3),"^",5)
	 q PatLen
}

/// 
/// w ##Class(web.DHCEMPatCheckLevCom).CheckPatNo(0000000022)
ClassMethod CheckPatNo(EmPatNo) As %String
{
	n (EmPatNo)
	i EmPatNo="" q -1
	
	s PAPMIDR=$o(^PAPERi("PAPMI_PatNo",EmPatNo,""),-1)
	q:+PAPMIDR=0 -1
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDR,""),-1)
	q:+CardNoID=0 0
	s cardstatus=$p(^DHCCARD("CF",CardNoID),"^",10)
	q:cardstatus'["N" -1	
	q 0
}

/// 根据卡号取登记号
/// w ##class(web.DHCEMPatCheckLevCom).GetPmiNoFrCardNo()
ClassMethod GetPmiNoFrCardNo(cardno, typeID = "") As %String
{
	n (cardno,typeID)
	i cardno="" q -1
	s cardrow="",retpatno="",flag=0
	f  s cardrow=$o(^DHCCARDi("CF",0,"CardNo",cardno,cardrow),-1) q:cardrow=""  d
	.s cardstatus="",pmi=""
	.s cardstatus=$p(^DHCCARD("CF",cardrow),"^",10)
	.s cardTypeID=$p(^DHCCARD("CF",cardrow),"^",16)
	.q:(typeID'="")&&(typeID'=cardTypeID)
	.i cardstatus="" s cardstatus="N"
	.s:cardstatus'["N" flag=1
	.q:cardstatus'["N"
	.s pmi=+$p(^DHCCARD("CF",cardrow),"^",4)
	.s retpatno=$p(^PAPER(pmi,"PAT",1),"^",2)
	
	q:(flag'=0)&&(retpatno="") -1

	q retpatno
}

/// Descript: 年龄 Copy ##Class(web.DHCEMPatCheckLevCom).GetAge(PatientID)
ClassMethod GetAge(papmidr As %String) As %String
{
	//根据患者rowid取出年龄
	n (papmidr)
	q:papmidr="" ""
	s argBirthday=$p($g(^PAPER(papmidr,"ALL")),"^",6)
	q:(+argBirthday=0) ""
	q:(+papmidr=0) ""
	s argAdmDate=$p($h,",",1)
	s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
	.s ageYears=$p(tmpAge,"|",12)
	.s ageMonths=$p(tmpAge,"|",13)
	.s ageDays=$p(tmpAge,"|",14)
	.
	.i ageYears>3 d
	..s age=ageYears_"岁"
	.
	.i (ageYears>0)&(ageYears'>3) d
	..s age=ageYears_"岁"
	..i ageMonths'=0 s age=age_ageMonths_"月"
	.
	.i (ageYears=0)&(ageMonths'=0) d
	..s age=ageMonths_"月"
	..i ageDays'=0 s age=age_ageDays_"天"
	.
	.i (ageYears=0)&(ageMonths=0) d
	..s age=ageDays_"天"
	e  d
	.s age=""
	q age
}

/// Descritp:性别
/// W ##Class(web.DHCEMPatCheckLevCom).SexToId()
ClassMethod SexToId(desc) As %String
{
	n (desc)
	q:desc="" 0
	s id=$o(^CT("SEX",0,"Desc",desc,""))
	q +id
}

ClassMethod GetPatIDByDva(dva As %String) As %String
{
	n (dva)
	Q:+dva=0 0
	//s ret=$o(^PAPERi("DVA",dva,""))
	s ret=$o(^PAPERi("PAPMI_ICPPBC",dva_"Z",""))
	q:+ret=0 0
	s myPAID=$p(^PAPER(ret,"ALL"),"^",9)
	q:+myPAID=0 0
	s type=$p($g(^PAPER(ret,"PAT",3)),"^",7)
	q:+type'=1 0
	q +ret
}

/// W ##Class(web.DHCEMPatCheckLevCom).GetPatLevByAdm(557,1,2)
ClassMethod GetPatLevByAdm(adm As %String, PatientID As %String, LgHospID = "", LgCtLocID = "", LgUserID = "", LgGroupID = "") As %String
{
	n (adm,PatientID,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	
	//s INSERTDOC=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","INSERTDOC",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	//s PATTYPE=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","PATTYPE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s NurseLevel=0,EmPCLvID=0
	//登记队列，不插挂号记录
	//i (INSERTDOC'=1)&&(PATTYPE'=1) d    ///注释修改:有就诊就按就诊ID取,没就诊按照病人ID取; 2017-08-17 bianshuai
	i adm="" d
	.s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)
	.s:+EmRegID'=0 EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)
	.s:+EmPCLvID'=0 NurseLevel=+$p(^DHCEMPCL(EmPCLvID),"^",7) 
	e  d
	.s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+adm,""),-1)
	.s:+EmPCLvID'=0 NurseLevel=+$p(^DHCEMPCL(EmPCLvID),"^",7) 
	
	//q $CASE(NurseLevel, 1:"Ⅰ(危重)",2:"Ⅱ(严重)",3:"Ⅲ(紧急)",4:"Ⅳ(不紧急)",:"")
	//q $CASE(NurseLevel, 1:"1级(危重)",2:"2级(严重)",3:"3级(紧急)",4:"4级(不紧急)",:"")
	q ..GetNurCheckDesc(NurseLevel)
}

/// 通过就诊ID获取分诊ID
/// W ##Class(web.DHCEMPatCheckLevCom).GetPatLevByAdm(557,1,2)
ClassMethod GetPatLevIdByAdm(adm As %String, PatientID As %String, LgHospID = "", LgCtLocID = "", LgUserID = "", LgGroupID = "") As %String
{
	n (adm,PatientID,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	
	s INSERTDOC=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","INSERTDOC",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s PATTYPE=+##Class(web.DHCEMComPar).GetAppPropValue("DHCEM","PATTYPE",LgHospID,LgCtLocID,LgUserID,LgGroupID)
	s NurseLevel=0,EmPCLvID=0
	//登记队列，不插挂号记录
	i (INSERTDOC'=1)&&(PATTYPE'=1) d
	.s EmRegID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,""),-1)
	.s:+EmRegID'=0 EmPCLvID=$o(^DHCEMPCL(0,"EmPatReg",PatientID,EmRegID,""),-1)
	e  d
	.s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+adm,""),-1)
	q EmPCLvID
}

/// Descript:  获取His系统维护日期格式
/// W ##Class(web.DHCEMPatCheckLevCom).GetSysDateToHtml("1988-03-08")
ClassMethod GetSysDateToHtml(HtDate As %String) As %String
{
	n (HtDate)
	Q:HtDate="" ""
	/// 转换输入日期格式为系统存储格式
	s HtDate=##Class(web.DHCEMCommonUtil).DateHtmlToLogical(HtDate)
	Q:HtDate="" ""
	/// Demo配置的日期格式
	s HtDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(HtDate)
	Q HtDate
}

/// Description: 获取护士分级描述(用到了护士站的表)
/// Creator:     QQA
/// CreateDate:  2017-03-17
/// Input:  	 1、2
/// w ##class(web.DHCEMPatCheckLevCom).GetNurCheckDesc(1)
ClassMethod GetNurCheckDesc(NurCheck As %String)
{
	n (NurCheck)
	q:+NurCheck="0" ""
	s NurCheck=NurCheck_"级"	
	s EmLvID=$o(^CT("ACU",0,"Code",$$ALPHAUP^SSUTIL4(NurCheck),""))
	Q:EmLvID="" NurCheck
	s NurCheckDesc=NurCheck_"("
	s NurCheckDesc = NurCheckDesc_$p(^CT("ACU",EmLvID),"^",2)
	s NurCheckDesc = NurCheckDesc_")"
	q NurCheckDesc
}

/// Description: 获取病人当前分级描述
/// Creator:     bianshuai
/// CreateDate:  2020-03-16
/// w ##class(web.DHCEMPatCheckLevCom).GetPatPriority(1)
ClassMethod GetPatPriority(EpisodeID As %String, isTakDescFlag As %String) As %String
{
	n (EpisodeID, isTakDescFlag, %session)
	s PriID=$P($g(^PAADM(EpisodeID)),"^",33)   /// 级别
	Q:PriID="" ""
	s PriCode=$p($g(^CT("ACU",PriID)),"^",1)   /// 级别代码
	s PriDesc=$p($g(^CT("ACU",PriID)),"^",2)   /// 级别描述
	s PriCode=$s(PriCode="1级":"Ⅰ级",PriCode="2级":"Ⅱ级",PriCode="3级":"Ⅲ级",PriCode="4级":"Ⅳa级",PriCode="5级":"Ⅳb级",1:PriCode)
	s PriCode=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp",PriCode)
	s PriDesc=##class(web.DHCEMCommonUtil).GetTrans("dhcem.gua.guarantee.csp",PriDesc)
	i isTakDescFlag="Y" s PriCode=PriCode_"("_PriDesc_")"
	Q PriCode
}

/// Description: 根据证件号获取病人ID
/// Creator:     bianshuai
/// CreateDate:  2017-08-26
/// Input:  	 PatIdentNo - 证件号
/// w ##Class(web.DHCEMPatCheckLevCom).GetPatientID(1)
ClassMethod GetPatientID(PatIdentNo As %String) As %String
{
	n (PatIdentNo)
	Q:+PatIdentNo=0 ""
	s Ret=""
	s PatientID="" 
	f  s PatientID = $o(^PAPERi("DVA",$$ALPHAUP^SSUTIL4(PatIdentNo),PatientID)) q:PatientID=""  d
	.s:Ret'="" Ret=Ret_"^"_PatientID
	.s:Ret="" Ret=PatientID
	
	Q Ret
}

/// Description: 根据证件号获取病人ID
/// Creator:     bianshuai
/// CreateDate:  2017-08-26
/// Input:  	 PatIdentNo - 证件号
/// w ##Class(web.DHCEMPatCheckLevCom).GetPatientID(1)
ClassMethod GetPatientList(PatIdentNo, LgHospID) As %String
{
	n (PatIdentNo,LgHospID)
	Q:+PatIdentNo=0 ""
	s Count=0
	s Title="PatNo^PatName^PatSex^PatAge^PatientID"
	
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal()
	s PatientID="" 
	f  s PatientID = $o(^PAPERi("DVA",$$ALPHAUP^SSUTIL4(PatIdentNo),PatientID)) q:PatientID=""  d
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	.s PatSex=""
	.s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	.i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	.s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,"",LgHospID)  /// 年龄
	.s ItmData = PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatientID
	.s Count = Count+1
	.i Count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(Title,ItmData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(Title,ItmData)
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
	Q ""
}

/// Descritp: 民族
/// W ##Class(web.DHCEMPatCheckLevCom).NationToId()
ClassMethod NationToId(Nation) As %String
{
	n (Nation)
	Q:Nation="" ""
	s ID=$o(^CT("NAT",0,"Desc",$$ALPHAUP^SSUTIL4(Nation_"族"),""))
	Q ID
}

/// Descritp: 根据卡号取病人的卡类型定义
/// W ##Class(web.DHCEMPatCheckLevCom).GetPatCardType()
ClassMethod GetPatCardType(CardNo As %String) As %String
{
	n (CardNo)
	Q:CardNo="" ""
	s CFRowId="",CardTypeID=""
    f  s CFRowId=$O(^DHCCARDi("CF",0,"CardNo",CardNo,CFRowId)) Q:(CFRowId="")  d
	.s ActiveFlag=$P(^DHCCARD("CF",CFRowId),"^",10)
	.Q:ActiveFlag'="N" 
	.s PapmiRowId=$P(^DHCCARD("CF",CFRowId),"^",4)
	.Q:PapmiRowId=""
	.s CardTypeID=$p($g(^DHCCARD("CF",CFRowId)),"^",16)  /// 卡类型
	Q CardTypeID
}

/// Descritp: 取群伤登记事件类型下拉
/// Createtor: lvpeng
/// CreateDate: 18-1-22
/// Table: DHC_EmGroupHurt
/// w ##class(web.DHCEMPatCheckLevCom).GetGroupHurtType()
ClassMethod GetGroupHurtType(HospID) As %String
{
	n (HospID,%session)
	s result = ##class(%Library.ResultSet).%New()
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmGroupHurt",HospID) //hxy 2020-05-26
	s sqlStr = "SELECT GHU_RowId as GHUID,GHU_Desc as GHUDesc,GHU_ActiveFlag as GHUFlag,GHU_Type as GHUType FROM DHC_EmGroupHurt WHERE GHU_RowId <>0 AND GHU_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s NatDr = result.Data("GHUID")
		s NatDesc = result.Data("GHUDesc")
		s Flag = result.Data("GHUFlag")
		s GHUType=result.Data("GHUType") //hxy 2019-11-27
		continue:GHUType'="" //hxy 2019-11-27
		continue:Flag'="Y"
		s:NatDesc["-" NatDesc=$p(NatDesc,"-",2)
		s NatDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCEmGroupHurt","GHUDesc","",NatDesc)
		s tmp=NatDr_"^"_NatDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:医疗组
/// W ##Class(web.DHCEMPatCheckLevCom).jsonCTMedUnit("229")
ClassMethod jsonCTMedUnit(LocID)
{
	n (LocID,%session)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT MU_RowId, CTMU_Desc, CTMU_DateFrom, CTMU_DateTo FROM DHC_CTLoc_MedUnit where CTMU_ActiveFlag='Y' And CTMU_CTLOC_ParRef ='"_LocID_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("MU_RowId")
		s Desc = result.Data("CTMU_Desc")
		s Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCCTLocMedUnit","CTMUDesc","",Desc)
		s tmp=ID_"^"_Desc
		s FromDate = +result.Data("CTMU_DateFrom")
		s ToDate = +result.Data("CTMU_DateTo")
		Continue:((FromDate'=0)&&(FromDate>+$H))
		Continue:((ToDate'=0)&&(ToDate<+$H))
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Descritp:医疗组
/// W ##Class(web.DHCEMPatCheckLevCom).GetSocialList()
ClassMethod GetSocialList(HospDr = "")
{
	w "["
	s Count=0
	s SocialID=0
	f  s SocialID = $o(^CT("SS",SocialID)) q:SocialID=""  d
	.q:(HospDr'="")&(##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_SocialStatus",SocialID,HospDr)'="Y") ;hxy 2020-06-30
	.s SocialDesc = $p(^CT("SS",SocialID),"^",2)
	.s SocialDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSocialStatus","SSDesc","",SocialDesc)
	.s Count=Count+1
	.s Tmp = SocialID_"^"_SocialDesc
	.I Count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

/// Descritp:证件类型
/// W ##Class(web.DHCEMPatCheckLevCom).GetCertTypelList()
ClassMethod GetCertTypelList(CardType = "")
{
	n (CardType,%session)
	w "["
	s Count=0,TypeList=""
	if (CardType'="")
	{
		&SQL(select CTD_CredTypeListStr into:TypeList from DHC_CardTypeDef Where CTD_RowID=:CardType)
		for Len=1:1:$l(TypeList,","){
            s CredTypeID=$p(TypeList,",",Len)
            Continue:CredTypeID=""
            s CredType=$p($g(^PAC("CARD",CredTypeID)),"^",2)
            s CredType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCCredType","CRTDesc","",CredType)
            s Count=Count+1
			s Tmp = CredTypeID_"^"_CredType
			I Count=1 d
			.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
			e  d
			.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
        }
	}
	
	s CredTypeID=""
	F  s CredTypeID=$o(^PAC("CARD",CredTypeID)) Q:(CredTypeID="")!(TypeList'="")  D
	.s CredType=$p(^PAC("CARD",CredTypeID),"^",2)
	.s CredType=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.DHCCredType","CRTDesc","",CredType)
	.Q:$p($g(^PAC("CARD",CredTypeID,"DHC")),"^",1)'="Y"        /// 证件类型是否激活 bianshuai 2019-10-18
	.s Count=Count+1
	.s Tmp = CredTypeID_"^"_CredType
	.I Count=1 d
	..W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",Tmp)
	
	w "]"
	q ""
}

/// Descritp:	病区科室
/// W ##Class(web.DHCEMPatCheckLevCom).jsonGetEmLoc("")
ClassMethod jsonGetEmLoc(HospID As %String) As %String
{
	n (HospID,%session)
	s LocType=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTLOC_ROWID as LocDr,CTLOC_DESC as LocDesc,CTLOC_Hospital_DR as lochosp, "
	s sqlStr = sqlStr_"CTLOC_DateActiveFrom as DateFrom,CTLOC_DateActiveTo as DateTo FROM CT_LOC Where CTLOC_Type = 'EM'"

	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s DateFrom = result.Data("DateFrom")
		Continue:DateFrom>+$H
		s lochosp= result.Data("lochosp")
		s DateTo = result.Data("DateTo")
		i DateTo'="" Continue:DateTo<+$H
		s LocDr = result.Data("LocDr")
		s hosp=$p(^CTLOC(LocDr),"^",22)
		Continue:hosp'=HospID
		s WardID=$o(^PAWARD(0,"WARD_LocationDR",LocDr,0))
		Continue:+WardID=0
		Continue:'+$o(^PAWARD(WardID,"ROOM",0))
		Continue:'+$o(^PAWARD(WardID,"BED",0))
		s LocDesc = result.Data("LocDesc")
		s LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc) //hxy 2022-12-15
		s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		s tmp=LocDr_"^"_LocDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

}

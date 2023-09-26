/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 药物临床试验严重不良事件报告业务类
Class DHCDoc.GCP.SAE.BS Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 保存SAE
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).Save()
ClassMethod Save(BaseParamJson As %String, DiseaseJson As %String) As %String
{
	k BaseParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BaseParamJson,.BaseParamArr)
	k DiseaseJsonArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(DiseaseJson,.DiseaseJsonArr)
	s ID=BaseParamArr("ID")
	s AEReportDate=##class(websys.Conversions).DateHtmlToLogical(BaseParamArr("AEReportDate"))
	s AEDeadDate=##class(websys.Conversions).DateHtmlToLogical(BaseParamArr("AEDeadDate"))
	s AEHappenDate=##class(websys.Conversions).DateHtmlToLogical(BaseParamArr("AEHappenDate"))
	s AEKnowDate=##class(websys.Conversions).DateHtmlToLogical(BaseParamArr("AEKnowDate"))
	s AEBirthday=##class(websys.Conversions).DateHtmlToLogical(BaseParamArr("AEBirthday"))
	
	s CurrentDate=+$h,CurrentTime=$p($h,",",2)
	TS
	i ID = "" {
		s SaveOBJ = ##class(User.DHCDocPilotSAE).%New()
		d SaveOBJ.AEAddLocSetObjectId(BaseParamArr("AEAddLoc"))
		d SaveOBJ.AEUserSetObjectId(BaseParamArr("AEUser"))
		s SaveOBJ.AEAddDate=CurrentDate
		s SaveOBJ.AEAddTime=CurrentTime
		s SaveOBJ.AEStatus=BaseParamArr("AEStatus")
	} else  {
		s SaveOBJ = ##class(User.DHCDocPilotSAE).%OpenId(ID)	
	}
	S SaveOBJ.AEReportType=BaseParamArr("AEReportType")
	S SaveOBJ.AEReportDate=AEReportDate
	S SaveOBJ.AEMajorName=BaseParamArr("AEMajorName")
	S SaveOBJ.AEMajorTel=BaseParamArr("AEMajorTel")
	S SaveOBJ.AEFilCompanyName=BaseParamArr("AEFilCompanyName")
	S SaveOBJ.AEFilCompanyTel=BaseParamArr("AEFilCompanyTel")
	S SaveOBJ.AEDrugNameZN=BaseParamArr("AEDrugNameZN")
	S SaveOBJ.AEDrugNameEN=BaseParamArr("AEDrugNameEN")
	S SaveOBJ.AEDrugCategory=BaseParamArr("AEDrugCategory")
	S SaveOBJ.AEDrugCategoryOther=BaseParamArr("AEDrugCategoryOther")
	S SaveOBJ.AERegisterCategory=BaseParamArr("AERegisterCategory")
	S SaveOBJ.AEDrugForm=BaseParamArr("AEDrugForm")
	S SaveOBJ.AEStage=BaseParamArr("AEStage")
	S SaveOBJ.AEStudyCategory=BaseParamArr("AEStudyCategory")
	S SaveOBJ.AEIndication=BaseParamArr("AEIndication")
	S SaveOBJ.AEPatientSpell=BaseParamArr("AEPatientSpell")
	S SaveOBJ.AEBirthday=AEBirthday
	S SaveOBJ.AESex=BaseParamArr("AESex")
	S SaveOBJ.AEHeight=BaseParamArr("AEHeight")
	S SaveOBJ.AEWeight=BaseParamArr("AEWeight")
	S SaveOBJ.AEHasTreat=BaseParamArr("AEHasTreat")
	S SaveOBJ.AEDiagnosis=BaseParamArr("AEDiagnosis")
	S SaveOBJ.AESituation=BaseParamArr("AESituation")
	S SaveOBJ.AEDeadDate=AEDeadDate
	S SaveOBJ.AESituationOther=BaseParamArr("AESituationOther")
	S SaveOBJ.AEHappenDate=AEHappenDate
	S SaveOBJ.AEKnowDate=AEKnowDate
	S SaveOBJ.AEMeasures=BaseParamArr("AEMeasures")
	S SaveOBJ.AETurnOver=BaseParamArr("AETurnOver")
	S SaveOBJ.AEHasSequela=BaseParamArr("AEHasSequela")
	S SaveOBJ.AERelation=BaseParamArr("AERelation")
	S SaveOBJ.AEReportZN=BaseParamArr("AEReportZN")
	S SaveOBJ.AEReportEN=BaseParamArr("AEReportEN")
	S SaveOBJ.AEDetail=BaseParamArr("AEDetail")
	S SaveOBJ.AEUserPost=BaseParamArr("AEUserPost")
	S SaveOBJ.AEISO=BaseParamArr("AEISO")
	S SaveOBJ.AECode=BaseParamArr("AECode")
	S SaveOBJ.AEReportCompany=BaseParamArr("AEReportCompany")
		
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		TRO
		Quit "-1^保存失败！"
	}
	s MID=SaveOBJ.%Id()
	s mRtn=..SavePat(MID,.DiseaseJsonArr)
	i mRtn'=0 {
		TRO
		Quit "-1^保存疾病信息失败！"
	}
	I ID="" {
		S AddUser=BaseParamArr("AEUser"),AuditLoc="",AuditGroup="",AuditUser="",Status=BaseParamArr("AEStatus")
		S InPara=AddUser_"^"_AuditLoc_"^"_AuditGroup_"^"_AuditUser_"^"_Status
		S Note=""
		s mRtn=..SaveStatus(MID,InPara,Note)
		i mRtn'=0 {
			TRO
			Quit "-1^保存状态失败！"
		}	
	}
	TC
	
	q MID_"^保存成功！"
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 保存Pat
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).SavePat()
ClassMethod SavePat(MID As %String, ByRef DiseaseJsonArr) As %String
{
	s Count="",Err=0
	s Err=..DelPat(MID)
	Q:Err'=0 Err
	for {
		s Count=$O(DiseaseJsonArr(Count))
		q:(Count="")
		m CArr=DiseaseJsonArr(Count)
		s SaveOBJ = ##class(User.DHCDocPilotSAEPat).%New(MID)
		d SaveOBJ.PParRefSetObjectId(MID)
		s SaveOBJ.PDisease=CArr("PDisease")
		S SaveOBJ.PDrug=CArr("PDrug")
		S SaveOBJ.PUseInfo=CArr("PUseInfo")
		s sc = SaveOBJ.%Save()
		If $$$ISERR(sc) {
			s Err="-102"
			Q
		}
	}
	
	Q Err
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 删除Pat
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).DelPat()
ClassMethod DelPat(MID As %String) As %String
{
	s mRtn=0
	Q:MID="" mRtn
	&SQL(DELETE FROM SQLUser.DHCDocPilotSAEPat WHERE P_ParRef=:MID)
	I ((SQLCODE=100)||(SQLCODE=0)) {
	} else {
		s mRtn=SQLCODE
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 保存Status
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).SavePat()
ClassMethod SaveStatus(MID As %String, InPara As %String, Note As %String) As %String
{
	Q:MID="" 0
	s AddUser=$p(InPara,"^",1)
	s AuditLoc=$p(InPara,"^",2)
	s AuditGroup=$p(InPara,"^",3)
	s AuditUser=$p(InPara,"^",4)
	s Status=$p(InPara,"^",5)
	s CurrentDate=+$h,CurrentTime=$p($h,",",2)
	s SaveOBJ = ##class(User.DHCDocPilotSAEStatus).%New(MID)
	d SaveOBJ.SParRefSetObjectId(MID)
	d SaveOBJ.SAddUserSetObjectId(AddUser)
	S SaveOBJ.SStatus=Status
	S SaveOBJ.SAddDate=CurrentDate
	S SaveOBJ.SAddTime=CurrentTime
	S SaveOBJ.SNote=Note
	i Status'="A" {
		S SaveOBJ.SAuditDate=CurrentDate
		S SaveOBJ.SAuditTime=CurrentTime
		D SaveOBJ.SAuditGroupSetObjectId(AuditGroup)
		D SaveOBJ.SAuditLocSetObjectId(AuditLoc)
		D SaveOBJ.SAuditUserSetObjectId(AuditUser)
	}
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		Q "-103"
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2022-02-28
/// DESC: 查询SAE
/// IN  : InType(A申请列表)、(U审核列表)
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.SAE.BS","QrySAE","A","12175","","","","","29")
Query QrySAE(InType = "", InUser = "", StartDate = "", EndDate = "", InReportType = "", InStatus = "", InGroupID = "", InHosp = "") As %Library.Query(ROWSPEC = "rowid,AEReportType,AEReportDate,AEUser,AEAddLoc,AEStatus,AEStatusCode,AEPatientSpell,AESex,AEDrugNameZN,AEDrugNameEN,AEAuditDate,AEAuditUser,AENote,AEStage")
{
}

ClassMethod QrySAEExecute(ByRef qHandle As %Library.Binary, InType = "", InUser = "", StartDate = "", EndDate = "", InReportType = "", InStatus = "", InGroupID = "", InHosp = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	S ^TEMP("wawxn")=$lb(InType,InUser,StartDate,EndDate,InReportType,InStatus,InGroupID)
	;s EnableGroupID="29"
	s langid=..%LanguageID()
	if (InType="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i EndDate'="" {
		s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	} else {
		s EndDate=+$H
	}
	i StartDate'="" {
		s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
		i EndDate<StartDate {
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}
	
	i InType="A" {
		i StartDate'="" {
			for date=StartDate:1:EndDate {
				s rowid=""
				f  s rowid=$o(^User.DHCDocPilotSAEI("ReportDate",date,rowid)) q:rowid=""  d
				.s AEUser=$lg(^User.DHCDocPilotSAED(rowid),37)
				.q:AEUser'=InUser
				.d OuputRow1
			}
		} else {
			s rowid=""
			f  s rowid=$o(^User.DHCDocPilotSAEI("AddUser",InUser,rowid)) q:rowid=""  d
			.d OuputRow1
		}
	} else {
		i StartDate'="" {
			for date=StartDate:1:EndDate {
				s rowid=""
				f  s rowid=$o(^User.DHCDocPilotSAEI("ReportDate",date,rowid)) q:rowid=""  d
				.d OuputRow1
			}
		} else {
			s rowid=""
			f  s rowid=$o(^User.DHCDocPilotSAED(rowid)) q:rowid=""  d
			.d OuputRow1
		}
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OuputRow1
	s AEReportType=$lg(^User.DHCDocPilotSAED(rowid),2)
	q:(InReportType'="")&&(InReportType'[AEReportType)
	s AEReportType=..GetDicDesc("AEReportType",AEReportType)
	i InType="U" s AEReportType=##class(websys.Translation).Get("gcp.bs.sae.audit.csp",AEReportType)
	e  s AEReportType=##class(websys.Translation).Get("gcp.bs.sae.csp",AEReportType)
	s AEReportDate=$lg(^User.DHCDocPilotSAED(rowid),3)
	s AEReportDate=##class(websys.Conversions).DateLogicalToHtml(AEReportDate)
	s AEUser=$lg(^User.DHCDocPilotSAED(rowid),37)
	s AEUser=$P(^SSU("SSUSR",AEUser),"^",2)
	s AEUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AEUser,langid)
	s AEStatusCode=$lg(^User.DHCDocPilotSAED(rowid),43)
	q:(InStatus'="")&&(InStatus'[AEStatusCode)
	q:(InType="U")&&(AEStatusCode="N")
	;q:(InType="U")&&(EnableGroupID'[InGroupID)
	s AEStatus=..GetDicDesc("AEStatus",AEStatusCode)
	i InType="U" s AEStatus=##class(websys.Translation).Get("gcp.bs.sae.audit.csp",AEStatus)
	e  s AEStatus=##class(websys.Translation).Get("gcp.bs.sae.csp",AEStatus)
	s AEPatientSpell=$lg(^User.DHCDocPilotSAED(rowid),18)
	s AESex=$lg(^User.DHCDocPilotSAED(rowid),20)
	s AESex=..GetDicDesc("AESex",AESex)
	s AESex= ##class(User.CTSex).GetTranByDesc("CTSEXDesc",AESex,langid)
	s AEDrugNameZN=$lg(^User.DHCDocPilotSAED(rowid),9)
	s AEDrugNameEN=$lg(^User.DHCDocPilotSAED(rowid),10)
	s AEAuditUser=$lg(^User.DHCDocPilotSAED(rowid),46)
	i AEAuditUser'="" s AEAuditUser=$P(^SSU("SSUSR",AEAuditUser),"^",2)
	s AEAuditDate=$lg(^User.DHCDocPilotSAED(rowid),44)
	s AEAuditTime=$lg(^User.DHCDocPilotSAED(rowid),45)
	s AEAddLoc=$lg(^User.DHCDocPilotSAED(rowid),47)
	s AEAddHosp=$p(^CTLOC(AEAddLoc),"^",22)
	q:(InHosp'="")&&(InHosp'=AEAddHosp)
	s AEAddLoc=$p(^CTLOC(AEAddLoc),"^",2)
	s AEAddLoc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AEAddLoc,langid)
	i AEAuditTime'="" s AEAuditTime=$zt(AEAuditTime,2)
	i AEAuditDate'="" {
		s AEAuditDate=##class(websys.Conversions).DateLogicalToHtml(AEAuditDate)
		s AEAuditDate=AEAuditDate_" "_AEAuditTime
	}
	s AEStage=$lg(^User.DHCDocPilotSAED(rowid),15)
	s AEStage=..GetDicDesc("AEStage",AEStage)
	s AENote=$lg(^User.DHCDocPilotSAED(rowid),48)
	
	
	set Data=$lb(rowid,AEReportType,AEReportDate,AEUser,AEAddLoc,AEStatus,AEStatusCode,AEPatientSpell,AESex,AEDrugNameZN,AEDrugNameEN,AEAuditDate,AEAuditUser,AENote,AEStage)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QrySAEFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QrySAEExecute ]
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

ClassMethod QrySAEClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QrySAEFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 获取报告类型描述
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).GetDicDesc("AEReportType")
ClassMethod GetDicDesc(InType = "", Code = "") As %String
{
	s mRtn=""
	Q:(InType="")||(Code="") mRtn
	
	i InType="AEReportType" {
		i Code="F" s mRtn="首次报告"
		i Code="V" s mRtn="随访报告"
		i Code="S" s mRtn="总结报告"
		
	}
	i InType="AEStatus" {
		i Code="N" s mRtn="新建"
		i Code="A" s mRtn="申请"
		i Code="R" s mRtn="拒绝"
		i Code="U" s mRtn="同意"
	}
	i InType="AESex" {
		i Code="1" s mRtn="男"
		i Code="2" s mRtn="女"	
	}
	i InType="AEStage" {
		i Code="1" s mRtn="Ⅰ期"
		i Code="2" s mRtn="Ⅱ期"	
		i Code="3" s mRtn="Ⅲ期"
		i Code="4" s mRtn="Ⅳ期"	
	}
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-03-01
/// DESC: 获取报告数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).InitData(3)
ClassMethod InitData(MID) As %String
{
	//D ##class(PHA.COM.Json).TableToJson("DHCDocPilotSAE", "3")
	s langid=..%LanguageID()
	s OpenOBJ = ##class(User.DHCDocPilotSAE).%OpenId(MID)
	s dynObj = {}
	s myobj=##class(%Dictionary.CompiledClass).%OpenId("User.DHCDocPilotSAE")
	s myCount = myobj.Properties.Count()
	For i = 1:1:myCount {
		s myproperty=myobj.Properties.GetAt(i)
		s myName=myproperty.Name
		s myType=myproperty.Type
		s myDesc=myproperty.Description 
		continue:(myName["%")||(myName["Child")	
		s myValue=$ZOBJPROPERTY(OpenOBJ, myName)
		i $ISObject(myValue) {
			s myValue=myValue.%Id()
		}
		i myType="%Library.Date" {
			s myValue=##class(websys.Conversions).DateLogicalToHtml(myValue)
		}
		i myName="AEUser" {
			s myValue=$P(^SSU("SSUSR",myValue),"^",2)
			s myValue= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",myValue,langid)
		}
		do dynObj.%Set(myName,myValue)
	}
	/*
	s DiseaseObj={},DiseaseLen=0
	s id=""
	f  s id=$o(^User.DHCDocPilotSAED(MID,"ChildPat",id)) q:id=""  d
	.s PDisease=$lg(^User.DHCDocPilotSAED(MID,"ChildPat",id),2)
	.s PDrug=$lg(^User.DHCDocPilotSAED(MID,"ChildPat",id),3)
	.s PUseInfo=$lg(^User.DHCDocPilotSAED(MID,"ChildPat",id),4)
	.s DiseaseLen=DiseaseLen+1
	.d DiseaseObj.%Set("PDisease"_DiseaseLen,PDisease)
	.d DiseaseObj.%Set("PDrug"_DiseaseLen,PDrug)
	.d DiseaseObj.%Set("PUseInfo"_DiseaseLen,PUseInfo)
	i DiseaseLen'=0 do dynObj.%Set("DiseaseObj",DiseaseObj)
	do dynObj.%Set("DiseaseLen",DiseaseLen)
	*/
	
	Q dynObj.%ToJSON()
}

/// CTOR: QP
/// DATE: 2022-03-01
/// DESC: 获取报告数据
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).InitData(3)
ClassMethod InitAuditProcess(MID) As %String
{
	s mRtn="["
	s id=""
	s langid=..%LanguageID()
	f  s id=$o(^User.DHCDocPilotSAED(MID,"ChildStatus",id)) q:id=""  d
	.s SStatus=$lg(^User.DHCDocPilotSAED(MID,"ChildStatus",id),2)
	.s SStatus=..GetDicDesc("AEStatus",SStatus)
	.s SStatus=##class(websys.Translation).Get("gcp.bs.sae.audit.process.csp",SStatus)
	.s SAddUser=$lg(^User.DHCDocPilotSAED(MID,"ChildStatus",id),7)
	.s SAddDate=$lg(^User.DHCDocPilotSAED(MID,"ChildStatus",id),8)
	.s SAddTime=$lg(^User.DHCDocPilotSAED(MID,"ChildStatus",id),9)
	.s SNote=$lg(^User.DHCDocPilotSAED(MID,"ChildStatus",id),10)
	.s SNote=..FilterValue(SNote)
	.s SAddDate=##class(websys.Conversions).DateLogicalToHtml(SAddDate)
	.s SAddTime=$zt(SAddTime,1)
	.s SAddUser=$P(^SSU("SSUSR",SAddUser),"^",2)
	.s SAddDate=SAddDate_" "_SAddTime
	.s SAddUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",SAddUser,langid)
	.s EXName=##class(websys.Translation).Get("gcp.bs.sae.audit.process.csp","操作人")
	.s context="<div class='cntt'>"_EXName_"："_SAddUser_"</div><span class='cntt'>"_SAddDate_"</span><div style='margin-left:82px;'>"_SNote_"</div>"
	.s record="{""title"":"""_SStatus_""",""context"":"""_context_"""}"
	.i mRtn="[" s mRtn=mRtn_record
	.e  s mRtn=mRtn_","_record
	
	s mRtn=mRtn_"]"
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 获取默认日期
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).GetDefaultDate()
ClassMethod GetDefaultDate() As %String
{
	q ##class(websys.Conversions).DateLogicalToHtml(+$H)
}

/// QP
/// DATE: 2016-08-14
ClassMethod FilterValue(value) As %String
{
	s value=..ReplaceStr(value,",","，")
	s value=..ReplaceStr(value,$C(10),"")
	q value
}

/// QP
/// DATE: 2016-08-14
ClassMethod ReplaceStr(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// CTOR: QP
/// DATE: 2022-03-22
/// DESC: 获取页面默认值
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).GetDefaultValue(17355,2)
ClassMethod GetDefaultValue(InUser, InHsop = "") As %String
{
	s dynObj={
		"DefaultDate":"",
		"MaxDate":"",
		"AEUserPost": "",
		"AEUser": "",
		"AEReportCompany":""
	}
	s langid=..%LanguageID()
	do dynObj.%Set("DefaultDate",(..GetDefaultDate()))
	s MaxDate=##class(websys.Conversions).DateLogicalToHtml(+$H+1)
	do dynObj.%Set("MaxDate",MaxDate)
	s docid=$p(^SSU("SSUSR",InUser),"^",14)
	s AEUser=$p(^SSU("SSUSR",InUser),"^",2)
	s AEUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AEUser,langid)
	do dynObj.%Set("AEUser",AEUser)
	i InHsop'="" {
		s HospName=$p(^CT("HOSP",InHsop),"^",2)
		s HospName=##class(User.CTHospital).GetTranByDesc("HOSPDesc",HospName,langid)
		do dynObj.%Set("AEReportCompany",HospName)
	}
	i docid'="" {
		s CarPrvTPDR=$P(^CTPCP(docid,1),"^",4)
		i CarPrvTPDR'="" {
			s AEUserPost=$p(^CT("CPT",CarPrvTPDR),"^",2)
			s AEUserPost= ##class(User.CTCarPrvTp).GetTranByDesc("CTCPTDesc",AEUserPost,langid)	
			do dynObj.%Set("AEUserPost",AEUserPost)
		}
	}
	Q dynObj.%ToJSON()
}

/// CTOR: QP
/// DATE: 2022-02-28
/// DESC: 查询SAEPat
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.SAE.BS","QrySAEPat","4")
Query QrySAEPat(MID = "") As %Library.Query(ROWSPEC = "id,PDisease,PDrug,PUseInfo")
{
}

ClassMethod QrySAEPatExecute(ByRef qHandle As %Library.Binary, MID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	if (MID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s id=""
	f  s id=$o(^User.DHCDocPilotSAED(MID,"ChildPat",id)) q:id=""  d
	.s PDisease=$lg(^User.DHCDocPilotSAED(MID,"ChildPat",id),2)
	.s PDrug=$lg(^User.DHCDocPilotSAED(MID,"ChildPat",id),3)
	.s PUseInfo=$lg(^User.DHCDocPilotSAED(MID,"ChildPat",id),4)
	.d OuputRow2
	
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OuputRow2
	set Data=$lb(id,PDisease,PDrug,PUseInfo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QrySAEPatFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QrySAEPatExecute ]
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

ClassMethod QrySAEPatClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QrySAEPatFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2022-03-02
/// DESC: 变更申请状态
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).GetDicDesc("AEReportType")
ClassMethod ChangeApply(MID, InPara, Note) As %String
{
	Q:MID="" -101
	S User=$p(InPara,"^",1)
	S Loc=$p(InPara,"^",2)
	S GroupID=$p(InPara,"^",3)
	S Status=$p(InPara,"^",4)
	s CurrentDate=+$h,CurrentTime=$p($h,",",2)
	;状态信息
	S AuditLoc=""
	S AuditGroup=""
	S AuditUser=""
	S AddUser=User
	i "R,U"[Status {
		S AuditLoc=Loc
		S AuditGroup=GroupID
		S AuditUser=User
		S AuditDate=CurrentDate
		S AuditTime=CurrentTime
		S AuditUser=User
	}
	
	TS
	I 
	&SQL(
		UPDATE SQLUser.DHCDocPilotSAE 
		SET AE_Status=:Status,
		AE_Note=:Note,
		AE_AuditDate=:AuditDate,
		AE_AuditTime=:AuditTime,
		AE_AuditUser=:AuditUser
		WHERE ID=:MID
	)
	I SQLCODE'=0 {
		TRO
		Q -102	
	}
	;保存状态信息

	S InPara=AddUser_"^"_AuditLoc_"^"_AuditGroup_"^"_AuditUser_"^"_Status
	s mRtn=..SaveStatus(MID,InPara,Note)
	i mRtn'=0 {
		TRO
		Quit -103
	}	
	TC
	
	Q 0
}

/// CTOR: QP
/// DATE: 2022-04-19
/// DESC: 是否为报告人
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.SAE.BS).GetDicDesc("AEReportType")
ClassMethod IsAddUser(MID, InUser) As %String
{
	Q:MID="" 0
	s AEUser=$lg(^User.DHCDocPilotSAED(MID),37)
	Q:AEUser=InUser 1
	Q 0
}

}

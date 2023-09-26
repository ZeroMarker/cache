/// 名称: DHCMed.DTHService.LodopReportSrv
/// 描述: 死亡证报卡Lodop打印相关服务
/// 编写者：chenrui
/// 编写日期: 2022-05-16
Class DHCMed.DTHService.LodopReportSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2022-05-16
/// Description:  打印核对信息(患者基本信息)
/// Table：       DHCMed.DTH.Report
/// Input：       报告ID
/// Return：       	
/// w ##Class(DHCMed.DTHService.LodopReportSrv).DTHBaseInfoPrint(1)
ClassMethod DTHBaseInfoPrint(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	Set (PapmiNo,MrNo,Name,Sex,Age,Nation,CardTypeID,CardType,Identify,Birthday,MaritalID,Marital,EducationID,Education,OccupationID,Occupation,Company,RegAddress,CurrAddress,FamName,FamTel,FamAddr,DeathDateTime,DeathPlaceID,DeathPlace,RepDocName,examUserName,FamIdentify) = ""
	
	Set BaseInfoArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.DTHService.ReportSrv","DMReportPrint",aReportID)	
	For ind=1:1:BaseInfoArray.Count(){
		Set BaseInfo=BaseInfoArray.GetAt(ind)
		Set PapmiNo		= BaseInfo.GetAt("PapmiNo")
		Set MrNo		= BaseInfo.GetAt("MrNo")
		Set Name		= BaseInfo.GetAt("Name")
		Set Sex			= BaseInfo.GetAt("Sex")
		Set Age			= BaseInfo.GetAt("Age")
		Set Nation		= BaseInfo.GetAt("Nation")
		Set CardTypeID	= BaseInfo.GetAt("CardType")
		Set CardType 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(CardTypeID)_"号码"
		Set Identify	= BaseInfo.GetAt("Identify")
		Set Birthday	= BaseInfo.GetAt("Birthday")
		Set MaritalID	= BaseInfo.GetAt("Marital")
		Set Marital 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(MaritalID)
		Set EducationID	= BaseInfo.GetAt("Education")
		Set Education 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(EducationID)
		Set OccupationID= BaseInfo.GetAt("Occupation")
		Set Occupation 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(OccupationID)
		Set Company		= BaseInfo.GetAt("Company")
		Set RegAddress	= BaseInfo.GetAt("RegAddress")
		Set CurrAddress	= BaseInfo.GetAt("CurrAddress")
		Set FamName		= BaseInfo.GetAt("FamName")
		Set FamTel		= BaseInfo.GetAt("FamTel")
		Set FamAddr		= BaseInfo.GetAt("FamAddr")
		Set DeathDateTime=BaseInfo.GetAt("DeathDateTime")
		Set DeathPlaceID= BaseInfo.GetAt("DeathPlace")
		Set DeathPlace 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(DeathPlaceID)
		Set RepDocName	= BaseInfo.GetAt("RepDocName")
		Set examUserName= BaseInfo.GetAt("examUserName")
		Set FamIdentify	= BaseInfo.GetAt("FamIdentify")
	}
	Set return = PapmiNo_"^"_MrNo_"^"_Name_"^"_Sex_"^"_Age_"^"_Nation_"^"_CardTypeID_"^"_CardType_"^"_Identify_"^"_Birthday_"^"_MaritalID_"^"_Marital_"^"_EducationID_"^"_Education_"^"_OccupationID_"^"_Occupation_"^"_Company_"^"_RegAddress_"^"_CurrAddress_"^"_FamName_"^"_FamTel_"^"_FamAddr_"^"_DeathDateTime_"^"_DeathPlaceID_"^"_DeathPlace_"^"_RepDocName_"^"_examUserName_"^"_FamIdentify
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-05-17
/// Description:  打印三联
/// Table：       DHCMed.DTH.Report
/// Input：       报告ID
/// Return： 
/// 新版三联打印
/// w ##Class(DHCMed.DTHService.LodopReportSrv).DTHRepThreePrint(,1)
ClassMethod DTHRepThreePrint(aReportID As %String, aPrintIDs As %String = "", aFlagIDs As %String = "") As %String
{
	Set (switchPrint,OnePrintCode,TwoPrintCode,ThreePrintCode,AddPrintCode)=""
	Set OnePrint = $p(aPrintIDs,"^",1)
	Set TwoPrint = $p(aPrintIDs,"^",2)
	Set ThreePrint = $p(aPrintIDs,"^",3)
	Set AddPrint =$p(aFlagIDs,"^",1)   //补打
	if (OnePrint'=""){
		s objOnePrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+OnePrint)
		if $IsObject(objOnePrint) {
			s OnePrintCode = objOnePrint.Code
		}
	}
	if (TwoPrint'=""){
		s objTwoPrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+TwoPrint)
		if $IsObject(objTwoPrint) {
			s TwoPrintCode = objTwoPrint.Code
		}
	}
	if (ThreePrint'=""){
		s objThreePrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+ThreePrint)
		if $IsObject(objThreePrint) {
			s ThreePrintCode = objThreePrint.Code
		}
	}
	if (AddPrint'=""){
		s objAddPrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+AddPrint)
		if $IsObject(objAddPrint) {
			s AddPrintCode = objAddPrint.Code
		} else {
			if (AddPrint="Yes") {
				s AddPrintCode=1
			}
		}
	}
	if (aPrintIDs="") {
		s switchPrint="123"
	} else {
		s switchPrint = OnePrintCode_TwoPrintCode_ThreePrintCode
	}
	Set ThreeInfoArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.DTHService.ReportSrv","DMReportPrint",aReportID)	
	For ind=1:1: ThreeInfoArray.Count(){
		Set ThreeInfo	= ThreeInfoArray.GetAt(ind)
		s PaperNo		= ThreeInfo.GetAt("PaperNo")
		s:PaperNo'="" PaperNo="No."_PaperNo
		s DeathNo		= ThreeInfo.GetAt("DeathNo")
		s Name			= ThreeInfo.GetAt("Name")
		s Sex			= ThreeInfo.GetAt("Sex")
		s Age			= ThreeInfo.GetAt("Age")
		s Nation		= ThreeInfo.GetAt("Nation")
		s CardTypeID	= ThreeInfo.GetAt("CardType")
		s CardType		= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(CardTypeID)
		s Identify		= ThreeInfo.GetAt("Identify")
		s Identify		= Identify
		s Birthday		= ThreeInfo.GetAt("Birthday")
		s DeathDateTime	= ThreeInfo.GetAt("DeathDateTime")
		s DeathPlaceID	= ThreeInfo.GetAt("DeathPlace")
		s DeathPlace 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(DeathPlaceID)
		s Company		= ThreeInfo.GetAt("Company")
		s RegAddress	= ThreeInfo.GetAt("RegAddress")
		s FamName		= ThreeInfo.GetAt("FamName")
		s FamTel		= ThreeInfo.GetAt("FamTel")
		s FamAddr		= ThreeInfo.GetAt("FamAddr")
		s AReason		= ThreeInfo.GetAt("AReason")
		s BReason		= ThreeInfo.GetAt("BReason")
		s CReason		= ThreeInfo.GetAt("CReason")
		s DReason		= ThreeInfo.GetAt("DReason")
		s BaseReason	= ThreeInfo.GetAt("BaseReason")
		s Country		= ThreeInfo.GetAt("Country")
		s RepDocName	= ThreeInfo.GetAt("RepDocName")
		//打印电子签名（判断报告是否进行CA认证）
		Set IsSign=##Class(DHCMed.CA.SignVerify).GetRepIsSign("DTH","DTH",aReportID,"S")
		Set:IsSign=1 RepDocName=""
		if ((BaseReason="")&&(DReason'="")){
			Set BaseReason = DReason
		}
		if ((BaseReason="")&&(DReason="")&&(CReason'="")){
			Set BaseReason = CReason
		}
		if ((BaseReason="")&&(DReason="")&&(CReason="")&&(BReason'="")){
			Set BaseReason = BReason
		}
		if ((BaseReason="")&&(DReason="")&&(CReason="")&&(BReason="")&&(AReason'="")){
			Set BaseReason = AReason
		}
		//行政区 县/区
		Set MEPDCountyCode= ThreeInfo.GetAt("MEPDCountyCode")
		
		Set SwitchPrint = ##Class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("DTH-SwitchPrint","")  //配置项的选择打印
		Set (PaperNoOne,MEPDCountyCodeOne,DeathNoOne,NameOne,SexOne,NationOne,CountryOne,AgeOne,CardTypeOne,IdentifyOne,RegAddressOne,BirthdayOne,DeathDateTimeOne,DeathPlaceOne,BaseReasonOne,FamNameOne,FamTelOne,FamAddrOne,RepDocNameOne) = ""
		Set (PaperNoTwo,MEPDCountyCodeTwo,DeathNoTwo,NameTwo,SexTwo,NationTwo,CountryTwo,AgeTwo,CardTypeTwo,IdentifyTwo,RegAddressTwo,BirthdayTwo,DeathDateTimeTwo,DeathPlaceTwo,BaseReasonTwo,FamNameTwo,FamTelTwo,FamAddrTwo,RepDocNameTwo) = ""
		Set (PaperNoThr,MEPDCountyCodeThr,DeathNoThr,NameThr,SexThr,NationThr,CountryThr,AgeThr,CardTypeThr,IdentifyThr,RegAddressThr,BirthdayThr,DeathDateTimeThr,DeathPlaceThr,BaseReasonThr,FamNameThr,FamTelThr,FamAddrThr,RepDocNameThr) = ""
		if (SwitchPrint=1){
			if (switchPrint["1") { 
				Set PaperNoOne			= PaperNo
				Set MEPDCountyCodeOne	= MEPDCountyCode
				Set DeathNoOne			= DeathNo
				Set NameOne				= Name
				Set SexOne				= Sex
				Set NationOne			= Nation
				Set CountryOne			= Country
				Set AgeOne				= Age
				Set CardTypeOne			= CardType
				Set IdentifyOne			= Identify
				Set RegAddressOne		= RegAddress
				Set BirthdayOne			= Birthday
				Set DeathDateTimeOne	= DeathDateTime
				Set DeathPlaceOne		= DeathPlace
				Set BaseReasonOne		= BaseReason
				Set FamNameOne			= FamName
				Set FamTelOne			= FamTel
				Set FamAddrOne			= FamAddr
				Set RepDocNameOne		= RepDocName
			}
			if (switchPrint["2") { 
				Set PaperNoTwo			= PaperNo
				Set MEPDCountyCodeTwo	= MEPDCountyCode
				Set DeathNoTwo			= DeathNo
				Set NameTwo				= Name
				Set SexTwo				= Sex
				Set NationTwo			= Nation
				Set CountryTwo			= Country
				Set AgeTwo				= Age
				Set CardTypeTwo			= CardType
				Set IdentifyTwo			= Identify
				Set RegAddressTwo		= RegAddress
				Set BirthdayTwo			= Birthday
				Set DeathDateTimeTwo	= DeathDateTime
				Set DeathPlaceTwo		= DeathPlace
				Set BaseReasonTwo		= BaseReason
				Set FamNameTwo			= FamName
				Set FamTelTwo			= FamTel
				Set FamAddrTwo			= FamAddr
				Set RepDocNameTwo		= RepDocName
			}
			if (switchPrint["3") { 
				Set PaperNoThr			= PaperNo
				Set MEPDCountyCodeThr	= MEPDCountyCode
				Set DeathNoThr			= DeathNo
				Set NameThr				= Name
				Set SexThr				= Sex
				Set NationThr			= Nation
				Set CountryThr			= Country
				Set AgeThr				= Age
				Set CardTypeThr			= CardType
				Set IdentifyThr			= Identify
				Set RegAddressThr		= RegAddress
				Set BirthdayThr			= Birthday
				Set DeathDateTimeThr	= DeathDateTime
				Set DeathPlaceThr		= DeathPlace
				Set BaseReasonThr		= BaseReason
				Set FamNameThr			= FamName
				Set FamTelThr			= FamTel
				Set FamAddrThr			= FamAddr
				Set RepDocNameThr		= RepDocName
			}
		}else{
			Set PaperNoOne			= PaperNo
			Set MEPDCountyCodeOne	= MEPDCountyCode
			Set DeathNoOne			= DeathNo
			Set NameOne				= Name
			Set SexOne				= Sex
			Set NationOne			= Nation
			Set CountryOne			= Country
			Set AgeOne				= Age
			Set CardTypeOne			= CardType
			Set IdentifyOne			= Identify
			Set RegAddressOne		= RegAddress
			Set BirthdayOne			= Birthday
			Set DeathDateTimeOne	= DeathDateTime
			Set DeathPlaceOne		= DeathPlace
			Set BaseReasonOne		= BaseReason
			Set FamNameOne			= FamName
			Set FamTelOne			= FamTel
			Set FamAddrOne			= FamAddr
			Set RepDocNameOne		= RepDocName
			Set PaperNoTwo			= PaperNo
			Set MEPDCountyCodeTwo	= MEPDCountyCode
			Set DeathNoTwo			= DeathNo
			Set NameTwo				= Name
			Set SexTwo				= Sex
			Set NationTwo			= Nation
			Set CountryTwo			= Country
			Set AgeTwo				= Age
			Set CardTypeTwo			= CardType
			Set IdentifyTwo			= Identify
			Set RegAddressTwo		= RegAddress
			Set BirthdayTwo			= Birthday
			Set DeathDateTimeTwo	= DeathDateTime
			Set DeathPlaceTwo		= DeathPlace
			Set BaseReasonTwo		= BaseReason
			Set FamNameTwo			= FamName
			Set FamTelTwo			= FamTel
			Set FamAddrTwo			= FamAddr
			Set RepDocNameTwo		= RepDocName
			Set PaperNoThr			= PaperNo
			Set MEPDCountyCodeThr	= MEPDCountyCode
			Set DeathNoThr			= DeathNo
			Set NameThr				= Name
			Set SexThr				= Sex
			Set NationThr			= Nation
			Set CountryThr			= Country
			Set AgeThr				= Age
			Set CardTypeThr			= CardType
			Set IdentifyThr			= Identify
			Set RegAddressThr		= RegAddress
			Set BirthdayThr			= Birthday
			Set DeathDateTimeThr	= DeathDateTime
			Set DeathPlaceThr		= DeathPlace
			Set BaseReasonThr		= BaseReason
			Set FamNameThr			= FamName
			Set FamTelThr			= FamTel
			Set FamAddrThr			= FamAddr
			Set RepDocNameThr		= RepDocName
		}
		Set return = PaperNoOne_"^"_MEPDCountyCodeOne_"^"_DeathNoOne_"^"_NameOne_"^"_SexOne_"^"_NationOne_"^"_CountryOne_"^"_AgeOne_"^"_CardTypeOne_"^"_IdentifyOne_"^"_RegAddressOne_"^"_BirthdayOne_"^"_DeathDateTimeOne_"^"_DeathPlaceOne_"^"_BaseReasonOne_"^"_FamNameOne_"^"_FamTelOne_"^"_FamAddrOne_"^"_RepDocNameOne_"^"_PaperNoTwo_"^"_MEPDCountyCodeTwo_"^"_DeathNoTwo_"^"_NameTwo_"^"_SexTwo_"^"_NationTwo_"^"_CountryTwo_"^"_AgeTwo_"^"_CardTypeTwo_"^"_IdentifyTwo_"^"_RegAddressTwo_"^"_BirthdayTwo_"^"_DeathDateTimeTwo_"^"_DeathPlaceTwo_"^"_BaseReasonTwo_"^"_FamNameTwo_"^"_FamTelTwo_"^"_FamAddrTwo_"^"_RepDocNameTwo_"^"_PaperNoThr_"^"_MEPDCountyCodeThr_"^"_DeathNoThr_"^"_NameThr_"^"_SexThr_"^"_NationThr_"^"_CountryThr_"^"_AgeThr_"^"_CardTypeThr_"^"_IdentifyThr_"^"_RegAddressThr_"^"_BirthdayThr_"^"_DeathDateTimeThr_"^"_DeathPlaceThr_"^"_BaseReasonThr_"^"_FamNameThr_"^"_FamTelThr_"^"_FamAddrThr_"^"_RepDocNameThr_"^"_AddPrintCode	
	
	}
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-05-18
/// Description:  打印核对信息(首联)
/// Table：       DHCMed.DTH.Report
/// Input：       报告ID
/// Return：       	
/// w ##Class(DHCMed.DTHService.LodopReportSrv).DTHFirstInfoPrint(1)
ClassMethod DTHFirstInfoPrint(aReportID As %String, aFlagIDs As %String = "") As %String
{
	new (aReportID,aFlagIDs) 
	Set return = ""
	Quit:aReportID="" return
	Set (PaperNo,RegAddress,MEPDCountyCode,DeathNo,Name,Sex,Nation,Country,CardType,Identify,Age,Marital,Birthday,Education,Occupation,DeathDateTime,DeathPlace,Pregnancies,Company,RegAddress,CurrAddress,FamName,FamTel,FamAddr,AReason,AInterval,BReason,BInterval,CReason,CInterval,DReason,DInterval,OtherDiagnose,OtherDiagnoseInterval,DiagnoseUnit,DiagnoseBasis,RepDocName,MrNo,RepDate,BaseReason,BaseReasonICD,ExamMedical,ExamName,ExamRelation,ExamTel,ExamAddress,ExamDeathReason,examUserName,ExamDate,CardTypeID,MaritalID,EducationID,OccupationID,DeathPlaceID,AIntervalID,BIntervalID,CIntervalID,DIntervalID,DiagnoseUnitID,DiagnoseBasisID,ExamRelationID,AddPrintCode) = ""
	Set AddPrint =$p(aFlagIDs,"^",1)   //补打
	if (AddPrint'=""){
		s objAddPrint = ##Class(DHCMed.SS.Dictionary).GetObjById(+AddPrint)
		if $IsObject(objAddPrint) {
			s AddPrintCode = objAddPrint.Code
		} else {
			if (AddPrint="Yes") {
				s AddPrintCode=1
			}
		}
	}
	
	Set FirstInfoArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.DTHService.ReportSrv","DMReportPrint",aReportID)	
	For ind=1:1:FirstInfoArray.Count(){
		Set FirstInfo=FirstInfoArray.GetAt(ind)
		Set PaperNo		= FirstInfo.GetAt("PaperNo")
		Set:PaperNo'="" PaperNo="No."_PaperNo
		Set RegAddress	= FirstInfo.GetAt("RegAddress")
		//行政区 县/区
		Set MEPDCountyCode= FirstInfo.GetAt("MEPDCountyCode")
		Set DeathNo		= FirstInfo.GetAt("DeathNo")
		Set Name		= FirstInfo.GetAt("Name")
		Set Sex			= FirstInfo.GetAt("Sex")
		Set Nation		= FirstInfo.GetAt("Nation")
		Set Country		= FirstInfo.GetAt("Country")
		Set CardTypeID	= FirstInfo.GetAt("CardType")
		Set CardType 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(CardTypeID)_"号码"
		
		Set Identify	= FirstInfo.GetAt("Identify")
		Set Age			= FirstInfo.GetAt("Age")
		Set MaritalID	= FirstInfo.GetAt("Marital")
		Set Marital 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(MaritalID)
		Set Birthday	= FirstInfo.GetAt("Birthday")
		Set EducationID	= FirstInfo.GetAt("Education")
		Set Education 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(EducationID)
		Set OccupationID= FirstInfo.GetAt("Occupation")
		Set Occupation 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(OccupationID)
		Set DeathDateTime=FirstInfo.GetAt("DeathDateTime")
		Set DeathPlaceID= FirstInfo.GetAt("DeathPlace")
		Set DeathPlace 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(DeathPlaceID)
		Set Pregnancies	= FirstInfo.GetAt("Pregnancies")
		Set Company		= FirstInfo.GetAt("Company")
		Set CurrAddress	= FirstInfo.GetAt("CurrAddress")
		Set FamName		= FirstInfo.GetAt("FamName")
		Set FamTel		= FirstInfo.GetAt("FamTel")
		Set FamAddr		= FirstInfo.GetAt("FamAddr")
		Set AReason		= FirstInfo.GetAt("AReason")
		Set BReason		= FirstInfo.GetAt("BReason")
		Set CReason		= FirstInfo.GetAt("CReason")
		Set DReason		= FirstInfo.GetAt("DReason")
		Set AIntervalID	= FirstInfo.GetAt("AInterval")  //AIntervalID 具体时间间隔^时间间隔ID
		
		Set AInterval 	= $p(AIntervalID,"^",1)_##Class(DHCMed.DTHService.ReportSrv).GetDescById($p(AIntervalID,"^",2))
		Set BIntervalID	= FirstInfo.GetAt("BInterval")
		Set BInterval 	= $p(BIntervalID,"^",1)_##Class(DHCMed.DTHService.ReportSrv).GetDescById($p(BIntervalID,"^",2))
		Set CIntervalID	= FirstInfo.GetAt("CInterval")
		Set CInterval 	= $p(CIntervalID,"^",1)_##Class(DHCMed.DTHService.ReportSrv).GetDescById($p(CIntervalID,"^",2))
		Set DIntervalID	= FirstInfo.GetAt("DInterval")
		Set DInterval 	= $p(DIntervalID,"^",1)_##Class(DHCMed.DTHService.ReportSrv).GetDescById($p(DIntervalID,"^",2))
		Set OtherDiagnose= FirstInfo.GetAt("OtherDiagnose")
		Set OtherDiagnoseICD = FirstInfo.GetAt("OtherDiagnoseICD")
		Set OtherDiagnoseFP  = FirstInfo.GetAt("OtherDiagnoseFP")
		Set:OtherDiagnoseFP'="" OtherDiagnose=OtherDiagnoseFP
		Set OtherDiagnoseFPICD= FirstInfo.GetAt("OtherDiagnoseFPICD")
		Set OtherDiagnoseInterval = $p(OtherDiagnoseInterval,"^",1)_##Class(DHCMed.DTHService.ReportSrv).GetDescById($p(OtherDiagnoseInterval,"^",2))
		Set DiagnoseUnitID	= FirstInfo.GetAt("DiagnoseUnit")
		Set DiagnoseUnit 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(DiagnoseUnitID)
		Set DiagnoseBasisID	= FirstInfo.GetAt("DiagnoseBasis")
		Set DiagnoseBasis 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(DiagnoseBasisID)
		Set RepDocName		= FirstInfo.GetAt("RepDocName")
		Set PapmiNo			= FirstInfo.GetAt("PapmiNo")
		Set RepDate			= FirstInfo.GetAt("RepDate")
		Set MrNo			= FirstInfo.GetAt("MrNo")
		Set BaseReason		= FirstInfo.GetAt("BaseReason")
		Set BaseReasonICD	= FirstInfo.GetAt("BaseReasonICD")
		Set ExamMedical		= FirstInfo.GetAt("ExamMedical") //死者生前病史及症状体症：
		Set ExamName		= FirstInfo.GetAt("ExamName") 	//被调查者姓名
		Set ExamDate		= FirstInfo.GetAt("ExamDate")	//调查日期
		Set ExamRelationID	= FirstInfo.GetAt("ExamRelation")	//与死者关系
		Set ExamRelation 	= ##Class(DHCMed.DTHService.ReportSrv).GetDescById(ExamRelationID)
		Set ExamAddress		= FirstInfo.GetAt("ExamAddress")	//联系地址或工作单位
		Set ExamTel			= FirstInfo.GetAt("ExamTel")	//联系电话
		Set ExamDeathReason	= FirstInfo.GetAt("ExamDeathReason")	//死因推断
		Set examUserName	= FirstInfo.GetAt("examUserName")	//调查者签名
		
	}
	Set return = PaperNo_"^"_RegAddress_"^"_MEPDCountyCode_"^"_DeathNo_"^"_Name_"^"_Sex_"^"_Nation_"^"_Country_"^"_CardType_"^"_Identify_"^"_Age_"^"_Marital_"^"_Birthday_"^"_Education_"^"_Occupation_"^"_DeathDateTime_"^"_DeathPlace_"^"_Pregnancies_"^"_Company_"^"_RegAddress_"^"_CurrAddress_"^"_FamName_"^"_FamTel_"^"_FamAddr_"^"_AReason_"^"_AInterval_"^"_BReason_"^"_BInterval_"^"_CReason_"^"_CInterval_"^"_DReason_"^"_DInterval_"^"_OtherDiagnose_"^"_OtherDiagnoseInterval_"^"_DiagnoseUnit_"^"_DiagnoseBasis_"^"_RepDocName_"^"_MrNo_"^"_RepDate_"^"_BaseReason_"^"_BaseReasonICD_"^"_ExamMedical_"^"_ExamName_"^"_ExamRelation_"^"_ExamTel_"^"_ExamAddress_"^"_ExamDeathReason_"^"_examUserName_"^"_ExamDate_"^"_AddPrintCode
	quit return
}

/// 打印儿童死亡报告卡
/// w ##Class(DHCMed.DTHService.LodopReportSrv).PrintDTHChildReport("1")
ClassMethod PrintDTHChildReport(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	Quit:aReportID="" return
	Set (RepYear,IsRepair,CardNo,CurrVillage,CurrRoad,MomName,FatherName,ChildName,TelPhone,Register,Sex,Birthday,Weight,WeightType,Height,BirthPlace,DeathDate,DeadYear,DeadMonth,DeadDay,DeadTime,AReason,BReason,CReason,DReason,BaseReason,ClassifyNo,ICD10,DeadPlace,BFTreat,DiagLevel,NotTreat,NotTreatTxt,DeadDiagList,RepUnit,RepUser,RepDate) = ""
	Set RepInfo = ##class(DHCMed.DTHService.ReportChildSrv).GetReportString(aReportID,"")
	Set ChildInfo = $p(RepInfo,$c(1),1)
	Set DeathInfo = $p(RepInfo,$c(1),2)
	Set RepYear 	= $p($p(ChildInfo,"^",31),"-",1)
	Set IsRepair 	= $p(ChildInfo,"^",35)
	Set CardNo 		= $p(ChildInfo,"^",34)
	Set CurrVillage = $p(ChildInfo,"^",39)
	Set CurrRoad 	= $p(ChildInfo,"^",40)
	Set ChildName 	= $p(ChildInfo,"^",5)
	Set FatherName 	= $p(ChildInfo,"^",6)
	Set MomName 	= $p(ChildInfo,"^",7)
	Set TelPhone 	= $p(ChildInfo,"^",8)
	Set Register 	= $$GetCode($p(ChildInfo,"^",11))
	Set Sex 		= $$GetCode($p(ChildInfo,"^",9))
	Set Birthday 	= $p(ChildInfo,"^",10)
	Set:Birthday'="" Birthday = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	Set Weight 		= $p(ChildInfo,"^",12)
	Set WeightType 	= $$GetCode($p(ChildInfo,"^",13))
	Set Height 		= $p(ChildInfo,"^",14)
	Set BirthPlace 	= $$GetCode($p(ChildInfo,"^",15))
	Set DeathDate 	= $p(ChildInfo,"^",16)
	Set:DeathDate'="" DeathDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate)
	Set DeadYear 	= $p(ChildInfo,"^",17)
	Set DeadMonth 	= $p(ChildInfo,"^",18)
	Set DeadDay 	= $p(ChildInfo,"^",19)
	Set DeadTime 	= $p(ChildInfo,"^",36)
	Set AReason 	= $p(DeathInfo,"^",5)
	Set BReason 	= $p(DeathInfo,"^",6)
	Set CReason 	= $p(DeathInfo,"^",7)
	Set DReason 	= $p(DeathInfo,"^",8)
	Set BaseReason 	= $p(DeathInfo,"^",9)
	Set ClassifyNo 	= $$GetCode($p(ChildInfo,"^",26))
	Set ICD10 		= $p(ChildInfo,"^",27)
	Set DeadPlace 	= $$GetCode($p(ChildInfo,"^",20))
	Set BFTreat 	= $$GetCode($p(ChildInfo,"^",21))
	Set DiagLevel 	= $$GetCode($p(ChildInfo,"^",22))
	Set NotTreat 	= $$GetCode($p(ChildInfo,"^",23))
	Set NotTreatTxt = $p(ChildInfo,"^",24)
	Set DeadDiagList= $$GetCode($p(ChildInfo,"^",25))
	Set RepUnit		= $p(ChildInfo,"^",38)
	Set RepUser	 	= $p(ChildInfo,"^",30)
	Set RepDate 	= $p(ChildInfo,"^",31)
	Set return = RepYear_"^"_IsRepair_"^"_CardNo_"^"_CurrVillage_"^"_CurrRoad_"^"_MomName_"^"_FatherName_"^"_ChildName_"^"_TelPhone_"^"_Register_"^"_Sex_"^"_Birthday_"^"_Weight_"^"_WeightType_"^"_Height_"^"_BirthPlace_"^"_DeathDate_"^"_DeadYear_"^"_DeadMonth_"^"_DeadDay_"^"_DeadTime_"^"_AReason_"^"_BReason_"^"_CReason_"^"_DReason_"^"_BaseReason_"^"_ClassifyNo_"^"_ICD10_"^"_DeadPlace_"^"_BFTreat_"^"_DiagLevel_"^"_NotTreat_"^"_NotTreatTxt_"^"_DeadDiagList_"^"_RepUnit_"^"_RepUser_"^"_RepDate
	
	quit return
	
GetCode(txt)
	Quit $p(txt,$c(2),2)
}

/// 打印孕产妇死亡报告卡
/// w ##Class(DHCMed.DTHService.LodopReportSrv).PrintDTHMomReport("1")
ClassMethod PrintDTHMomReport(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	Quit:aReportID="" return
	Set (PatName,CardNo,ConPlace,TempPlace,RegType,IsPlan,Age,Nation,Education,FamilIncome,ConType,Gravidity,Parity,ArtDra,LastMenDate,DeliveryDate,DeliveryTime,DeathDate,DeathTime,DeliveryPosition,DeathPosition,DeliveryWay,IsNewWay,Deliveryer,IsPreCheck,Frequency,PreTime,AReason,BReason,CReason,DReason,DiagnoseBasis,ProResult,ProReaSon,CountryResult,CountryReason,Hosptail,RepUser,RepDate) = ""
	Set RepInfo = ##class(DHCMed.DTHService.ReportMaternalSrv).GetReportString(aReportID,"")
	Set MomInfo = $p(RepInfo,$c(1),1)
	Set DeathInfo = $p(RepInfo,$c(1),2)
	
	Set CardNo 			= $p(MomInfo,"^",5)
	Set PatName  		= $p(MomInfo,"^",6)
	Set ConProvince		= $p($p(MomInfo,"^",7),$c(2),3)
	Set ConCity			= $p($p(MomInfo,"^",8),$c(2),3)
	Set ConCounty		= $p($p(MomInfo,"^",9),$c(2),3)
	Set ConPlace		= ConProvince_ConCity_ConCounty
	Set TempProvince	= $p($p(MomInfo,"^",12),$c(2),3)
	Set TempCity		= $p($p(MomInfo,"^",13),$c(2),3)
	Set TempCounty		= $p($p(MomInfo,"^",14),$c(2),3)
	Set TempPlace		= TempProvince_TempCity_TempCounty
	Set RegType			= $p($p(MomInfo,"^",17),$c(2),2)_"."_$p($p(MomInfo,"^",17),$c(2),3)
	Set IsPlan			= $p($p(MomInfo,"^",18),$c(2),2)_"."_$p($p(MomInfo,"^",18),$c(2),3)
	Set Age  			= $p(MomInfo,"^",19)
	Set Nation			= $p($p(MomInfo,"^",20),$c(2),2)_"."_$p($p(MomInfo,"^",20),$c(2),3)
	Set Education		= $p($p(MomInfo,"^",21),$c(2),2)_"."_$p($p(MomInfo,"^",21),$c(2),3)
	Set FamilIncome		= $p($p(MomInfo,"^",22),$c(2),2)_"."_$p($p(MomInfo,"^",22),$c(2),3)
	Set ConType			= $p($p(MomInfo,"^",23),$c(2),2)_"."_$p($p(MomInfo,"^",23),$c(2),3)
	Set Gravidity  		= $p(MomInfo,"^",24)
	Set Parity  		= $p(MomInfo,"^",25)
	Set ArtDra  		= $p(MomInfo,"^",26)
	Set LastMenDate  	= $p(MomInfo,"^",27)
	Set DeliveryDate  	= $p(MomInfo,"^",28)
	Set DeliveryTime  	= $p(MomInfo,"^",29)
	Set DeathDate  		= $p(MomInfo,"^",30)
	Set DeathTime	  	= $p(MomInfo,"^",31)
	Set DeliveryPosition= $p($p(MomInfo,"^",32),$c(2),2)_"."_$p($p(MomInfo,"^",32),$c(2),3)
	Set DeathPosition	= $p($p(MomInfo,"^",33),$c(2),2)_"."_$p($p(MomInfo,"^",33),$c(2),3)
	Set DeliveryWay		= $p($p(MomInfo,"^",34),$c(2),2)_"."_$p($p(MomInfo,"^",34),$c(2),3)
	Set IsNewWay		= $p($p(MomInfo,"^",35),$c(2),2)_"."_$p($p(MomInfo,"^",35),$c(2),3)
	Set Deliveryer		= $p($p(MomInfo,"^",36),$c(2),2)_"."_$p($p(MomInfo,"^",36),$c(2),3)
	Set IsPreCheck		= $p($p(MomInfo,"^",37),$c(2),2)_"."_$p($p(MomInfo,"^",37),$c(2),3)
	Set Frequency	  	= $p(MomInfo,"^",38)
	Set PreTime		  	= $p(MomInfo,"^",39)
	Set AReason	  		= $p(DeathInfo,"^",3)
	Set BReason		  	= $p(DeathInfo,"^",4)
	Set CReason	  		= $p(DeathInfo,"^",5)
	Set DReason	  		= $p(DeathInfo,"^",6)
	Set DiagnoseBasis	= $p($p(MomInfo,"^",40),$c(2),2)_"."_$p($p(MomInfo,"^",40),$c(2),3)
	Set ProResult		= $p($p(MomInfo,"^",41),$c(2),2)_"."_$p($p(MomInfo,"^",41),$c(2),3)
	Set ProReaSon		= $p($p(MomInfo,"^",42),$c(2),2)_"."_$p($p(MomInfo,"^",42),$c(2),3)
	Set CountryResult	= $p($p(MomInfo,"^",43),$c(2),2)_"."_$p($p(MomInfo,"^",43),$c(2),3)
	Set CountryReason	= $p($p(MomInfo,"^",44),$c(2),2)_"."_$p($p(MomInfo,"^",44),$c(2),3)
	Set RepLocDR		= $p(MomInfo,"^",46)
	Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocDR)
	Set:'$IsObject(objLoc) objLoc=##class(DHCMed.Base.Ctloc).%New()
	Set objHos=##class(DHCMed.Base.Hospital).GetObjById(objLoc.HospitalDr)
	Set:'$IsObject(objHos) objHos=##class(DHCMed.Base.Hospital).%New()
	Set Hosptail=objHos.Descs
	Set RepUser			= $p(MomInfo,"^",47)
	Set RepDate			= $p(MomInfo,"^",48)
	
	Set return = PatName_"^"_CardNo_"^"_ConPlace_"^"_TempPlace_"^"_RegType_"^"_IsPlan_"^"_Age_"^"_Nation_"^"_Education_"^"_FamilIncome_"^"_ConType_"^"_Gravidity_"^"_Parity_"^"_ArtDra_"^"_LastMenDate_"^"_DeliveryDate_"^"_DeliveryTime_"^"_DeathDate_"^"_DeathTime_"^"_DeliveryPosition_"^"_DeathPosition_"^"_DeliveryWay_"^"_IsNewWay_"^"_Deliveryer_"^"_IsPreCheck_"^"_Frequency_"^"_PreTime_"^"_AReason_"^"_BReason_"^"_CReason_"^"_DReason_"^"_DiagnoseBasis_"^"_ProResult_"^"_ProReaSon_"^"_CountryResult_"^"_CountryReason_"^"_Hosptail_"^"_RepUser_"^"_RepDate
	
	quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取传染病报卡字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：
/// zw ##Class(DHCMed.DTHService.LodopReportSrv).GetMomRepDicList()
ClassMethod GetMomRepDicList() As %List
{
	Set return = ""
	
	Set RegTypeList 		= ..GetDictionary("DTMRegType")
	Set IsPlanList 			= ..GetDictionary("DTMIsPlan")
	Set EducationList 		= ..GetDictionary("DTMEducation")
	Set FamilIncomeList 	= ..GetDictionary("DTMFamilIncome")
	Set ConTypeList 		= ..GetDictionary("DTMConType")
	Set DeliveryPositionList= ..GetDictionary("DTMDeliveryPosition")
	Set DeathPositionList	= ..GetDictionary("DTMDeathPosition")
	Set DeliveryWayList 	= ..GetDictionary("DTMDeliveryWay")
	Set IsNewWayList 		= ..GetDictionary("DTMIsNewWay")
	Set DeliveryerList 		= ..GetDictionary("DTMDeliveryer")
	Set IsPreCheckList 		= ..GetDictionary("DTMIsPreCheck")
	Set DiagnoseBasisList	= ..GetDictionary("DTMDiagnoseBasis")
	Set ProResultList 		= ..GetDictionary("DTMProResult")
	Set CountryReasonList	= ..GetDictionary("DTMCountryReason")
	Set NationList			= ..GetDictionary("DTMNation")
	
	
	Set DicData = $LB(RegTypeList,IsPlanList,EducationList,FamilIncomeList,ConTypeList,DeliveryPositionList,DeathPositionList,DeliveryWayList,IsNewWayList,DeliveryerList,IsPreCheckList,DiagnoseBasisList,ProResultList,CountryReasonList,NationList) 
	Set return = DicData
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：        
/// zw ##Class(DHCMed.DTHService.LodopReportSrv).GetDictionary("DTMRegType")
ClassMethod GetDictionary(aTypeCode As %String) As %List
{
	New (aTypeCode)
	Set return = ""
	Quit:aTypeCode="" return
	
	Set $ZT="GetActiveDicRowIDStrErr"

	Set aSeparate = ","
	Set aTypeCode = $ZCVT(aTypeCode,"U")
	Set DicRowID = 0
	For {
		Set DicRowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_aTypeCode,DicRowID))
		Quit:DicRowID=""
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicRowID)
		Continue:'$IsObject(objDic)
		
		Set Code = objDic.Code
		// 仅加载标记为有效的基础字典数据
		Set Active = objDic.Active
		Continue:Active'=1
		Set Description = Code_"."_objDic.Description
		Set return = return_aSeparate_Description
	}
	Set:return'="" return=$Extract(return,2,$Length(return))
	Set return=$LFS(return,",")
	Quit return
	
GetActiveDicRowIDStrErr
	Set return = -1
	Quit return
}

}

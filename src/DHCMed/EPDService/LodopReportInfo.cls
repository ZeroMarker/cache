/// 名称: DHCMed.EPDService.LodopReportInfo
/// 描述: 传染病报卡Lodop打印相关服务
/// 编写者：chenrui
/// 编写日期: 2022-02-25
Class DHCMed.EPDService.LodopReportInfo Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取传染病报卡信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       报告ID
/// Return：        
/// w ##Class(DHCMed.EPDService.LodopReportInfo).GetReportInfo("43")
ClassMethod GetReportInfo(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Set RepNo=objRep.MEPDText2          			 //卡片编号	
	
	Set PatientID=objRep.MEPDPapmiDR                //PatientID
	Set EpisodeID=objRep.MEPDText1                  //EpisodeID
	Set RepDate=objRep.MEPDRepDate                  //报告日期
	Set RepTime=objRep.MEPDRepTime                  //报告时间
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set PapmiNo=objPatient.PapmiNo              //登记号
		Set PatName=objPatient.PatientName      //姓名
		Set PatSex=objPatient.Sex               //性别
		//统一调用年龄计算方法
		//upadte by pylian 2016-02-18 修改入院时间取值方式
		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmitTime=$p(AdmDateTime,"^",2)
		Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,RepDate,RepTime)  // 打印取年龄，以报告日期报告时间为准
		Set AgeUnit = ..GetAgeUnit(PatientAge)
		Set:PatientAge'="" PatientAge = +PatientAge
		//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
		Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(AdmDate)
		Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,2)
   		Set Birthday = objPatient.Birthday
		Set PersonalID=objPatient.PersonalID        //身份证号
	}	
	Set:PersonalID="" PersonalID = objRep.MEPDText5
	if (objRep.MEPDMepdDR'=""){
		Set CardType="1" //订正报告
	}else{
		Set CardType="0"
	}
	Set FamName=objRep.MEPDFamName                  //家长姓名
	Set Company = objRep.MEPDCompany
	Set TelPhone = objRep.MEPDTelPhone
	// 病人所属区域
	Set Area=objRep.MEPDArea
	Set AreaDesc=""
	Set objArea=##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicReportRegion",Area,"")
	If $IsObject(objArea){
		Set AreaDesc=objArea.Description
	}
	Set PatAdress = objRep.MEPDAddress
	Set Occupation=objRep.MEPDOccupation
	Set:Occupation'="" Occupation=..GetDescByTypeCode("Career",Occupation) // 职业
	
	Set MEPDDiagDegree=objRep.MEPDDiagDegree
	Set:MEPDDiagDegree'="" MEPDDiagDegree=..GetDescByTypeCode("EpidemicDiagnoseDegree",MEPDDiagDegree) // 诊断分类
	Set MEPDSickKind=objRep.MEPDSickKind
	Set:MEPDSickKind'="" MEPDSickKind=..GetDescByTypeCode("EpidemicSickQuality",MEPDSickKind) // 发病程度
	Set MEPDSeverity=objRep.MEPDSeverity
	Set:MEPDSeverity'="" MEPDSeverity=..GetDescByTypeCode("EpidemicSeverity",MEPDSeverity) // 临床严重程度
		
	Set SickDate = objRep.MEPDSickDate
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate) // 发病日期
	Set:SickDate["/" SickDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(SickDate)
	Set DiagDate = objRep.MEPDDiagDate
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate) // 诊断日期
	Set:DiagDate["/" DiagDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(DiagDate)
	Set DiagDateTime = objRep.MEPDDiagDateTime
		
	Set MEPDIsInEPD=objRep.MEPDIsInEPD
	Set:MEPDIsInEPD'="" MEPDIsInEPD=..GetDescByTypeCode("EPDIsCheck",MEPDIsInEPD) // 临床严重程度
	Set MEPDContr = objRep.MEPDContr
	Set DeathDate = objRep.MEPDDeathDate
	Set:DeathDate'="" DeathDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DeathDate) // 死亡日期
	Set:DeathDate["/" DeathDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(DeathDate)
		
	Set RepDisease=objRep.MEPDICDDR.MIFDisease	//传染病诊断名称
	Set RepKindID = objRep.MEPDICDDR.MIFKind
	Set RepKind=""
	Set objLastRep=""
	Set objRepKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",RepKindID,"")
	If $IsObject(objRepKind){
		Set RepKind=objRepKind.Description
	}
	Set:RepKind="AFP" RepDisease=RepKind
	Set Disease=""
	If (objRep.MEPDStatus = 3)&(objRep.MEPDMepdDR'= ""){
		Set objLastRep =##class(DHCMed.EPD.Epidemic).GetObjById(objRep.MEPDMepdDR)  
		Quit:'$IsObject(objLastRep) 	
	}
	If (objRep.MEPDStatus = "3")&($IsObject(objLastRep)) { //修订报告 
        Set Disease =  objLastRep.MEPDICDDR.MIFDisease
	}
	Set MEPDDelReason = objRep.MEPDDelReason        // 退卡原因
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set RepUserName=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name // 填卡医生
	}
		
	Set RepDate= objRep.MEPDRepDate
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate) // 填卡日期
	Set:RepDate["/" RepDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(RepDate)
	
	Set RepLoc = objRep.MEPDLocDR
	Set LocTelephone=""
	Set HospID=$p($g(^CTLOC(RepLoc)),"^",22)
	Set HospDesc=""
	Set:HospID'="" HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	Set RepLocDesc=""
	Set LocTelephone = ""
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLocDesc=objRepLoc.Descs
		Set LocTelephone = objRepLoc.Telephone  //联系电话
	}
	Set:HospDesc'="" RepLocDesc=HospDesc   // 报告单位
	Set MEPDDemo = 	objRep.MEPDDemo
	
	Set return = RepNo_"^"_CardType_"^"_PatName_"^"_FamName_"^"_PersonalID_"^"_PatSex_"^"_Birthday_"^"_PatientAge_"^"_AgeUnit_"^"_Company	//1-10
	Set return = return_"^"_TelPhone_"^"_AreaDesc_"^"_PatAdress_"^"_Occupation_"^"_MEPDDiagDegree_"^"_MEPDSickKind_"^"_MEPDSeverity_"^"_SickDate_"^"_DiagDate_"^"_DiagDateTime	//11-20
	Set return = return_"^"_MEPDIsInEPD_"^"_MEPDContr_"^"_DeathDate_"^"_RepDisease_"^"_Disease_"^"_MEPDDelReason_"^"_RepLocDesc_"^"_LocTelephone_"^"_RepUserName_"^"_RepDate	//21-30
	Set return = return_"^"_MEPDDemo
	
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取传染病报卡字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetRepDicList()
ClassMethod GetRepDicList() As %List
{
	Set rentun = ""
	
	Set AgeList = ..GetDictionary("TBPatAge")
	Set AreaList = ..GetDictionary("EpidemicReportRegion")
	Set SexList = ..GetDictionary("EPDPetSex")
	Set CareerList = ..GetDictionary("Career")
	Set DiagnoseDegreeList = ..GetDictionary("EpidemicDiagnoseDegree")
	Set EpidemicSickQualityList = ..GetDictionary("EpidemicSickQuality")
	Set EpidemicSeverityList = ..GetDictionary("EpidemicSeverity")
	Set EPDIsCheckList = ..GetDictionary("EPDIsCheck")
	Set EpidemicReviseReasonList = ..GetDictionary("EpidemicReviseReason")
	
	Set EPDDicData = $LB(AgeList,AreaList,SexList,CareerList,DiagnoseDegreeList,EpidemicSickQualityList,EpidemicSeverityList,EPDIsCheckList,EpidemicReviseReasonList) 
	Set rentun = EPDDicData
	Quit rentun
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：        
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetDictionary("EpidemicReportRegion")
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
		
		// 仅加载标记为有效的基础字典数据
		Set Active = objDic.Active
		Continue:Active'=1
		Set Description = objDic.Description
		Set return = return_aSeparate_Description
	}
	Set:return'="" return=$Extract(return,2,$Length(return))
	Set return=$LFS(return,",")
	Quit return
	
GetActiveDicRowIDStrErr
	Set return = -1
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取年龄单位
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：        
/// w ##Class(DHCMed.EPDService.LodopReportInfo).GetAgeUnit("20岁")
ClassMethod GetAgeUnit(PatAge As %String) As %String
{
	new (PatAge)
	Set return = ""
	If (PatAge["岁"){
		Set return = "岁"
	}
	ElseIf (PatAge["月"){
		Set return = "月"
	}
	ElseIf ((PatAge'["月")&&(PatAge["天")) {
		Set return = "天"
	}
	Else {
		Set return = "天"
	}		
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2016-04-18
/// Description:  根据基础字典类别,基础字典项目名称获取基础字典记录
/// Table：       DHCMed.SS.Dictionary
/// Input：       type：   类型
///               code： 代码
/// Return：      返回obj
/// w ##class(DHCMed.EPDService.LodopReportInfo).GetDescByTypeCode("Career","9")
ClassMethod GetDescByTypeCode(argTypeCode As %String, argCode As %String, argIsActive As %String = 1) As %String
{
	New (argTypeCode,argCode,argIsActive)
	Set return=""
	Quit:(argTypeCode="")||(argCode="") return

    Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(argTypeCode,argCode,argIsActive)
	Quit:'$IsObject(objDic) return
    Set return=objDic.Description
    Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-03-09
/// Description:  获取传染病附卡HIV信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aEpisodeID就诊ID
/// Return：        
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetHIVReportInfo("40")
ClassMethod GetHIVReportInfo(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID) // 传染病报告信息
	Quit:'$IsObject(objRep) return
	Set PatientID = objRep.MEPDPapmiDR
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID) // 病人信息
	Quit:'$IsObject(objPatient) return
	Set Paadm = objRep.MEPDText1
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)	// 病人就诊信息
	
	Set (RepNo,PatientName,MEPDFamName,Nation,HIVMarriage,HIVEducation,MEPDAddress,HIVDiaTypeOne,HIVDiaTypeTwo,HIVDiaTypeThr,HIVDiaTypeFour,HIVDiaTypeFiv,HIVSexPeriod,HIVSexPeriodTwo,HIVSexPeriodThr,HIVSexPeriodFour,HIVSexPeriodFiv,HIVTrachomaInfList,HIVDrugHistory,HIVInjection,HIVUnmarHistory,HIVUnmarried,HIVFixedCom,HIVMSMHistory,HIVMSM,HIVBloodDona,HIVBloodTran,HIVExposure,HIVOperation,HIVQtResume,OtherHIVQtResume,HIVUnknown,HIVStdHistory,HIVPobSourceList,HIVPosSource,HIVSimSourceList,HIVSimSource,HIVTestResult,HIVResultDate,HIVTestCompany,HIVDigSureDate,RepLocDesc,LocTelephone,RepUserName,RepDate,HIVResume) = ""
	
	/*  报告基本信息   */
	Set RepNo			= objRep.MEPDText2          			 // 卡片编号	
	Set PatientName 	= objPatient.PatientName				 // 患者姓名
	Set MEPDFamName 	= objRep.MEPDFamName					 // 患儿家长姓名
	Set Nation 			= objPatient.Nation						 // 民族
	Set RepLoc 			= objRep.MEPDLocDR    					 // 科室
	
	Set RepLocDesc=""
	Set LocTelephone = ""
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLocDesc=objRepLoc.Descs // 填报科室
		Set LocTelephone = objRepLoc.Telephone	// 科室电话
	}	
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set RepUserName=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name  		// 填报人
	}	
	Set RepDate= objRep.MEPDRepDate    			// 填报日期
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set:RepDate["/" RepDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(RepDate)
	
	/* HIV附卡信息 */		
	s HIVInfoArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.EPDService.EpidemicSubSrv","QryEpidemicSubInfo",aReportID)	
	
	Set SubData = ""
	For ind=1:1:HIVInfoArray.Count(){
		Set HIVInfo=HIVInfoArray.GetAt(ind)
		Set ItemCode  = HIVInfo.GetAt("ItemCode")
		Set ItemValue = HIVInfo.GetAt("ItemValue")
		Set SubData(ItemCode) = ItemValue
	}
	
	Set HIVMarriage 		= SubData("cboHIVMarriage")	    // 婚姻状况
	Set HIVEducation 		= SubData("cboHIVEducation")	// 文化程度
	Set HIVDiaTypeList 		= SubData("chkHIVDiaTypeList")	// 疾病名称列	
	For indexDiaType=1:1:$l(HIVDiaTypeList,","){
		Set Value = $p(HIVDiaTypeList,",",indexDiaType)
		If (Value="艾滋病病毒感染"){
			 Set HIVDiaTypeOne = 1
		}
		If (Value="艾滋病"){
			Set HIVDiaTypeTwo = 1
		}
		If (Value="淋病"){
			Set HIVDiaTypeThr = 1
		}
		If (Value="尖锐湿疣"){
			Set HIVDiaTypeFour = 1
		}
		If (Value="生殖器疱疹"){
			Set HIVDiaTypeFiv = 1
		}	
	}
	Set HIVSexPeriodList 	= SubData("radHIVSexPeriodList")	// 梅毒分期	
	For indexSexPeriod=1:1:$l(HIVSexPeriodList,","){
		Set ItemValue = $p(HIVSexPeriodList,",",indexSexPeriod)
		If (ItemValue["一期"){
			 Set HIVSexPeriod = "Ⅰ期"
		}
		If (ItemValue["二期"){
		 	Set HIVSexPeriod = "Ⅱ期"
		}
		If (ItemValue["三期"){
		 	Set HIVSexPeriod = "Ⅲ期"
		}
		If (ItemValue["胎传"){
		 	Set HIVSexPeriod = "胎传"
			}
		If (ItemValue["隐性"){
		 	Set HIVSexPeriod = "隐性"
		}
	}	
	
	Set HIVTrachomaInfList 	= SubData("radHIVTrachomaInfList")	// 生殖道沙眼衣原体感染
	Set HIVDrugHistory 		= SubData("chk-HIVDrugHistory")		// 注射毒品史
	Set HIVInjection 		= SubData("num-HIVInjection")		// 共用过注射器人数
	Set HIVUnmarHistory 	= SubData("chk-HIVUnmarHistory")	// 非婚异性性接触史
	Set HIVUnmarried 		= SubData("num-HIVUnmarried")		// 非婚性行为人数   
	Set HIVFixedCom 		= SubData("chk-HIVFixedCom")		// 配偶/固定性伴阳性    
	Set HIVMSMHistory 		= SubData("chk-HIVMSMHistory")		// 男男性行为史    
	Set HIVMSM		 		= SubData("num-HIVMSM")				// 同性性行为人数 
	Set HIVBloodDona 		= SubData("chk-HIVBloodDona")		// 献血(浆)史    
	Set HIVBloodTran 		= SubData("chk-HIVBloodTran")		// 输血/血制品史    
	Set HIVMotherPose 		= SubData("chk-HIVMotherPose")		// 母亲阳性
	Set HIVExposure 		= SubData("chk-HIVExposure")		// 职业暴露史
	Set HIVOperation 		= SubData("chk-HIVOperation")		// 手术史  
	
	Set HIVQtResume 		= SubData("chk-HIVQtResume")		// 接触史其他    
	Set OtherHIVQtResume 	= SubData("txt-HIVQtResume")		// 其他详细说明
	Set HIVUnknown 			= SubData("chk-HIVUnknown")			// 接触史不详   
	Set HIVStdHistory 		= SubData("cboHIVStdHistory")		// 性病史	
	Set HIVPobSourceList 	= SubData("radHIVPobSourceList")	// 最可能的感染途径
	
	Set HIVPosSource 		= SubData("txtHIVPosSource")		// 最可能的感染途径其他说明    
	Set HIVSimSourceList 	= SubData("radHIVSimSourceList")	// 检测样本来源		
	Set HIVSimSource 		= SubData("txtHIVSimSource")		// 检测样本来源其他说明    
	Set HIVTestResult 		= SubData("cboHIVTestResult")		// 实验室检测结论		
	Set HIVResultDate 		= SubData("dtHIVResultDate")		// 确认(替代策略)检测阳性日期 
	Set:HIVResultDate'="" HIVResultDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HIVResultDate)
	Set:HIVResultDate["/" HIVResultDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(HIVResultDate)
	   
	Set HIVTestCompany 		= SubData("txtHIVTestCompany")		// 确认(替代策略)检测单位    
	Set HIVDigSureDate 		= SubData("dtHIVDigSureDate")		// 艾滋病确诊日期  
	Set:HIVDigSureDate'="" HIVDigSureDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(HIVDigSureDate) 
	Set:HIVDigSureDate["/" HIVDigSureDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(HIVDigSureDate)
	Set HIVResume 			= SubData("txt-HIVResume")			// 备注 
	Set MEPDAddress 		= SubData("txtHIVDomicileAddress")	// 户籍地址
	
	Set Data =RepNo_"^"_PatientName_"^"_MEPDFamName_"^"_Nation_"^"_HIVMarriage_"^"_HIVEducation_"^"_MEPDAddress_"^"_HIVDiaTypeOne_"^"_HIVDiaTypeTwo_"^"_HIVDiaTypeThr_"^"_HIVDiaTypeFour_"^"_HIVDiaTypeFiv_"^"_HIVSexPeriod_"^"_HIVSexPeriodTwo_"^"_HIVSexPeriodThr_"^"_HIVSexPeriodFour_"^"_HIVSexPeriodFiv_"^"_HIVTrachomaInfList_"^"_HIVDrugHistory_"^"_HIVInjection_"^"_HIVUnmarHistory_"^"_HIVUnmarried_"^"_HIVFixedCom_"^"_HIVMSMHistory_"^"_HIVMSM_"^"_HIVBloodDona_"^"_HIVBloodTran_"^"_HIVExposure_"^"_HIVOperation_"^"_HIVQtResume_"^"_OtherHIVQtResume_"^"_HIVUnknown_"^"_HIVStdHistory_"^"_HIVPobSourceList_"^"_HIVPosSource_"^"_HIVSimSourceList_"^"_HIVSimSource_"^"_HIVTestResult_"^"_HIVResultDate_"^"_HIVTestCompany_"^"_HIVDigSureDate_"^"_RepLocDesc_"^"_LocTelephone_"^"_RepUserName_"^"_RepDate_"^"_HIVResume_"^"_HIVMotherPose
	Set return = Data
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取传染病报卡字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetHIVRepDicList()
ClassMethod GetHIVRepDicList() As %List
{
	Set return = ""
	
	Set MaritalList 	= ..GetDictionary("EpidemicMaritalStatus")
	Set EducationList 	= ..GetDictionary("EpidemicEducation")
	Set EpdSex2PeriodList 	= ..GetDictionary("EpdSex2Period")
	Set EpdSex2PeriodList = ..GetEpdSex2PeriodList(EpdSex2PeriodList)
	Set EpidemicTrachomaInfList 	= ..GetDictionary("EpidemicTrachomaInf")
	Set PossibleSourceList 	= ..GetDictionary("EpidemicPossibleSource")
	Set SimpleSourceList 	= ..GetDictionary("EpidemicSimpleSource")
	Set EpdemicHaveList 	= ..GetDictionary("EpdemicHave")
	Set EpdSexSymbolLst2List 	= ..GetDictionary("EpdSexSymbolLst2")
	Set EPDHIVBusinessList 	= ..GetDictionary("EPDHIVBusiness")
	Set EpidemicLabResultList 	= ..GetDictionary("EpidemicLabResult")
	Set EpdSexLabResultList 	= ..GetDictionary("EpdSexLabResult")
	Set EpidemicContactList 	= ..GetDictionary("EpidemicContact")
	
	Set HIVDicData = $LB(MaritalList,EducationList,EpdSex2PeriodList,EpidemicTrachomaInfList,PossibleSourceList,SimpleSourceList,EpdemicHaveList,EpdSexSymbolLst2List,EPDHIVBusinessList,EpidemicLabResultList,EpdSexLabResultList,EpidemicContactList) 
	Set return = HIVDicData
	Quit return
}

/// w ##Class(DHCMed.EPDService.LodopReportInfo).GetHIVRepDicList()
ClassMethod GetEpdSex2PeriodList(EpdSex2PeriodList As %List) As %List
{
	Set return = ""
	
	For Ind=1:1:$ll(EpdSex2PeriodList){
		Set EpdSex2Period = $lg(EpdSex2PeriodList,Ind)
		If (EpdSex2Period="一期梅毒"){
			Set Period = "Ⅰ期"
		}
		If (EpdSex2Period="二期梅毒"){
			Set Period = "Ⅱ期"
		}
		If (EpdSex2Period="三期梅毒"){
			Set Period = "Ⅲ期"
		}
		If (EpdSex2Period="隐性梅毒"){
			Set Period = "隐性"
		}
		If (EpdSex2Period="胎传梅毒"){
			Set Period = "胎传"
		}
		Set return = return_","_Period
	}
	Set:return'="" return=$Extract(return,2,$Length(return))
	Set return=$LFS(return,",")
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-03-18
/// Description:  获取传染病附卡STD(性病)信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aEpisodeID就诊ID
/// Return：        
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetSTDReportInfo("41")
ClassMethod GetSTDReportInfo(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID) // 传染病报告信息
	Quit:'$IsObject(objRep) return
	Set PatientID = objRep.MEPDPapmiDR
	Set Contact = objRep.MEPDIntimateCode
	Set:Contact'="" objContact = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicContact",Contact,"1")
	If ($IsObject(objContact)){
		Set Contact = objContact.Description
	}
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID) // 病人信息
	Quit:'$IsObject(objPatient) return
	Set Paadm = objRep.MEPDText1
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)	// 病人就诊信息
	
	
	Set (RepNo,PatientName,MEPDFamName,Nation,HIVMarriage,HIVEducation,MEPDAddress,STDDiaTypeOne,STDDiaTypeTwo,STDDiaTypeThr,STDDiaTypeFour,STDDiaTypeFiv,STDSexPeriod,STDSexPeriodTwo,STDSexPeriodThr,STDSexPeriodFour,STDSexPeriodFiv,STDTrachomaInfList,STDDrugHistory,STDInjection,STDUnmarHistory,STDUnmarried,STDFixedCom,STDMSMHistory,STDMSM,STDBloodDona,STDBloodTran,STDExposure,STDOperation,STDQtResume,OtherSTDQtResume,STDUnknown,STDStdHistory,STDPobSourceList,STDPosSource,STDSimSourceList,STDSimSource,STDTestResult,STDResultDate,STDTestCompany,STDDigSureDate,RepLocDesc,LocTelephone,RepUserName,RepDate,STDResume) = ""
	Set (STDDigSureDate,STDLabResultList,STDUnDo,STDDt,STDTPResultList,STDTPHAResultList,STDELISAResultList,STDQtTest,STDQTResultList,STDMLabResultList,STDMUnDo,STDMDt,STDMTPResultList,STDMTPHAResultList,STDMELISAResultList,STDMQtTest,STDMQTResultList,STDHaveList,STDSymbolList,STDQtSymbol,STDBusiness,STDLabResult,STDTPResult,STDTPHAResult,STDELISAResult,IsSTDQtTest,STDMLabResult,STDMTPResult,STDMTPHAResult,STDMELISAResult,STDMQtTest)=""
	
	/*  报告基本信息   */
	Set RepNo			= objRep.MEPDText2          			 // 卡片编号	
	Set PatientName 	= objPatient.PatientName				 // 患者姓名
	Set MEPDFamName 	= objRep.MEPDFamName					 // 患儿家长姓名
	Set Nation 			= objPatient.Nation						 // 民族
	Set MEPDAddress 	= objRep.MEPDAddress				 	 // 户籍地址
	Set RepLoc 			= objRep.MEPDLocDR    					 // 科室
	
	Set RepLocDesc=""
	Set LocTelephone = ""
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLoc)
	If $IsObject(objRepLoc){
		Set RepLocDesc=objRepLoc.Descs // 填报科室
		Set LocTelephone = objRepLoc.Telephone	// 科室电话
	}	
	Set RepUser=objRep.MEPDRepUsrDR                 //报告人
	Set RepUserName=""
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(RepUser)
	If $IsObject(objRepUser){
		Set RepUserCode=objRepUser.Code
		Set RepUserName=objRepUser.Name  		// 填报人
	}	
	Set RepDate= objRep.MEPDRepDate    			// 填报日期
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set:RepDate["/" RepDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(RepDate)
	
	/* STD附卡信息 */		
	s STDInfoArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.EPDService.EpidemicSubSrv","QryEpidemicSubInfo",aReportID)	
	
	Set SubData = ""
	For ind=1:1:STDInfoArray.Count(){
		Set STDInfo=STDInfoArray.GetAt(ind)
		Set ItemCode  = STDInfo.GetAt("ItemCode")
		Set ItemValue = STDInfo.GetAt("ItemValue")
		Set SubData(ItemCode) = ItemValue
	}
	
	Set STDMarriage 		= SubData("cboSTDMarriage")	    // 婚姻状况
	Set STDEducation 		= SubData("cboSTDEducation")	// 文化程度
	Set STDDiaTypeList 		= SubData("chkSTDDiaTypeList")	// 疾病名称列	
	For indexDiaType=1:1:$l(STDDiaTypeList,","){
		Set Value = $p(STDDiaTypeList,",",indexDiaType)
		If (Value="艾滋病病毒感染"){
			 Set STDDiaTypeOne = 1
		}
		If (Value="艾滋病"){
			Set STDDiaTypeTwo = 1
		}
		If (Value="淋病"){
			Set STDDiaTypeThr = 1
		}
		If (Value="尖锐湿疣"){
			Set STDDiaTypeFour = 1
		}
		If (Value="生殖器疱疹"){
			Set STDDiaTypeFiv = 1
		}	
	}
	
	Set STDSexPeriodList 	= SubData("radSTDSexPeriodList")	// 梅毒分期	
	For indexSexPeriod=1:1:$l(STDSexPeriodList,","){
		Set Value = $p(STDSexPeriodList,",",indexSexPeriod)
		If (ItemValue["一期"){
			 Set STDSexPeriod = "Ⅰ期"
		}
		If (ItemValue["二期"){
		 	Set STDSexPeriod = "Ⅱ期"
		}
		If (ItemValue["三期"){
		 	Set STDSexPeriod = "Ⅲ期"
		}
		If (ItemValue["胎传"){
		 	Set STDSexPeriod = "胎传"
			}
		If (ItemValue["隐性"){
		 	Set STDSexPeriod = "隐性"
		}
	}	
	
	Set STDTrachomaInfList 	= SubData("radSTDTrachomaInfList")	// 生殖道沙眼衣原体感染
	Set STDDrugHistory 		= SubData("chk-STDDrugHistory")		// 注射毒品史
	Set STDInjection 		= SubData("num-STDInjection")		// 共用过注射器人数
	Set STDUnmarHistory 	= SubData("chk-STDUnmarHistory")	// 非婚异性性接触史
	Set STDUnmarried 		= SubData("num-STDUnmarried")		// 非婚性行为人数   
	Set STDFixedCom 		= SubData("chk-STDFixedCom")		// 配偶/固定性伴阳性    
	Set STDMSMHistory 		= SubData("chk-STDMSMHistory")		// 男男性行为史    
	Set STDMSM		 		= SubData("num-STDMSM")				// 同性性行为人数 
	Set STDBloodDona 		= SubData("chk-STDBloodDona")		// 献血(浆)史    
	Set STDBloodTran 		= SubData("chk-STDBloodTran")		// 输血/血制品史    
	Set STDMotherPose 		= SubData("chk-STDMotherPose")		// 母亲阳性
	Set STDExposure 		= SubData("chk-STDExposure")		// 职业暴露史
	Set STDOperation 		= SubData("chk-STDOperation")		// 手术史  
	
	Set STDQtResume 		= SubData("chk-STDQtResume")		// 接触史其他    
	Set OtherSTDQtResume 	= SubData("txt-STDQtResume")		// 其他详细说明
	Set STDUnknown 			= SubData("chk-STDUnknown")			// 接触史不详   
	Set STDStdHistory 		= SubData("cboSTDStdHistory")		// 性病史	
	Set STDPobSourceList 	= SubData("radSTDPobSourceList")	// 最可能的感染途径
	
	Set STDPosSource 		= SubData("txtSTDPosSource")		// 最可能的感染途径其他说明    
	Set STDSimSourceList 	= SubData("radSTDSimSourceList")	// 检测样本来源		
	Set STDSimSource 		= SubData("txtSTDSimSource")		// 检测样本来源其他说明    
	Set STDTestResult 		= SubData("cboSTDTestResult")		// 实验室检测结论		
	Set STDResultDate 		= SubData("dtSTDResultDate")		// 确认(替代策略)检测阳性日期 
	Set:STDResultDate'="" STDResultDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(STDResultDate)
	Set:STDResultDate["/" STDResultDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(STDResultDate)
	   
	Set STDTestCompany 		= SubData("txtSTDTestCompany")		// 确认(替代策略)检测单位    
	Set STDDigSureDate 		= SubData("dtSTDDigSureDate")		// 艾滋病确诊日期  
	Set:STDDigSureDate'="" STDDigSureDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(STDDigSureDate) 
	Set:STDDigSureDate["/" STDDigSureDate=##Class(DHCMed.SSService.CommonCls).ChangeDateFormat(STDDigSureDate)
	Set STDResume 			= ""			// 备注 
	Set STDDigSureDate 		= SubData("dtSTDDigSureDate")		// 艾滋病确诊日期 
	
	Set STDLabResultList 	= SubData("radSTDLabResultList")	// RPR/TRUST定性 
	Set STDUnDo 			= SubData("chk-STDUnDo")			// RPR/TRUST定性滴度未做 
	Set STDDt		 		= SubData("num-STDDt")				// RPR/TRUST定性滴度 
	Set STDTPResultList 	= SubData("radSTDTPResultList")		// TP暗视野镜检 
	Set STDTPHAResultList 	= SubData("radSTDTPHAResultList")	// TPPA/TPHA 
	Set STDELISAResultList 	= SubData("radSTDELISAResultList")	// TP-ELISA 
	Set STDQtTest 			= SubData("txt-STDQtTest")			// 其它检测方法
	Set STDQTResultList 	= SubData("radSTDQTResultList")		// 其它检测方法结果 
	if (STDLabResultList'=""){ Set STDLabResult = 1}
	if (STDTPResultList'=""){ Set STDTPResult = 1}
	if (STDTPHAResultList'=""){ Set STDTPHAResult = 1}
	if (STDELISAResultList'=""){ Set STDELISAResult = 1}
	if (STDQtTest'=""){ Set IsSTDQtTest = 1} 
	Set STDMLabResultList 	= SubData("radSTDMLabResultList")	// 患儿生母RPR/TRUST定性 
	Set STDMUnDo 			= SubData("chk-STDMUnDo")			// 患儿生母RPR/TRUST定性滴度未做 
	Set STDMDt 				= SubData("num-STDMDt")				// 患儿生母RPR/TRUST定性滴度 
	Set STDMTPResultList 	= SubData("radSTDMTPResultList")	// 患儿生母TP暗视野镜检 
	Set STDMTPHAResultList	= SubData("radSTDMTPHAResultList")	// 患儿生母TPPA/TPHA 
	
	Set STDMELISAResultList	= SubData("radSTDMELISAResultList")	// 患儿生母TP-ELISA 
	Set STDMQtTest			= SubData("txt-STDMQtTest")			// 患儿生母其它检测方法 
	Set STDMQTResultList	= SubData("radSTDMQTResultList")	// 患儿生母其它检测方法结果 
	
	if (STDMLabResultList'=""){ Set STDMLabResult = 1}
	if (STDMTPResultList'=""){ Set STDMTPResult = 1}
	if (STDMTPHAResultList'=""){ Set STDMTPHAResult = 1}
	if (STDMELISAResultList'=""){ Set STDMELISAResult = 1}
	if (STDMQtTest'=""){ Set IsSTDMQtTest = 1} 
	
	Set STDHaveList			= SubData("radSTDHaveList")			// 梅毒临床表现 
	Set STDSymbolList		= SubData("chkSTDSymbolList")		// 梅毒临床表现症状 
	Set STDQtSymbol			= SubData("txt-STDQtSymbol")		// 梅毒临床表现其他症状 
	Set STDBusiness			= SubData("radSTDBusiness")			// 是否商业 
	
	Set Data =RepNo_"^"_PatientName_"^"_MEPDFamName_"^"_Nation_"^"_STDMarriage_"^"_STDEducation_"^"_MEPDAddress_"^"_STDDiaTypeOne_"^"_STDDiaTypeTwo_"^"_STDDiaTypeThr_"^"_STDDiaTypeFour_"^"_STDDiaTypeFiv_"^"_STDSexPeriod_"^"_STDSexPeriodTwo_"^"_STDSexPeriodThr_"^"_STDSexPeriodFour_"^"_STDSexPeriodFiv_"^"_STDTrachomaInfList_"^"_STDDrugHistory_"^"_STDInjection_"^"_STDUnmarHistory_"^"_STDUnmarried_"^"_STDFixedCom_"^"_STDMSMHistory_"^"_STDMSM_"^"_STDBloodDona_"^"_STDBloodTran_"^"_STDExposure_"^"_STDOperation_"^"_STDQtResume_"^"_OtherSTDQtResume_"^"_STDUnknown_"^"_STDStdHistory_"^"_STDPobSourceList_"^"_STDPosSource_"^"_STDSimSourceList_"^"_STDSimSource_"^"_STDTestResult_"^"_STDResultDate_"^"_STDTestCompany_"^"_STDDigSureDate_"^"_RepLocDesc_"^"_LocTelephone_"^"_RepUserName_"^"_RepDate_"^"_STDResume
	Set Data = Data_"^"_STDDigSureDate_"^"_STDLabResultList_"^"_STDUnDo_"^"_STDDt_"^"_STDTPResultList_"^"_STDTPHAResultList_"^"_STDELISAResultList_"^"_STDQtTest_"^"_STDQTResultList_"^"_STDMLabResultList_"^"_STDMUnDo_"^"_STDMDt_"^"_STDMTPResultList_"^"_STDMTPHAResultList_"^"_STDMELISAResultList_"^"_STDMQtTest_"^"_STDMQTResultList_"^"_STDHaveList_"^"_STDSymbolList_"^"_STDQtSymbol_"^"_STDBusiness_"^"_STDLabResult_"^"_STDTPResult_"^"_STDTPHAResult_"^"_STDELISAResult_"^"_IsSTDQtTest_"^"_STDMLabResult_"^"_STDMTPResult_"^"_STDMTPHAResult_"^"_STDMELISAResult_"^"_STDMQtTest_"^"_Contact
	Set return = Data
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-03-21
/// Description:  获取传染病附卡HBV（乙肝）信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：       aEpisodeID就诊ID
/// Return：        
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetHBVReportInfo("41")
ClassMethod GetHBVReportInfo(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	
	Set objRep=##class(DHCMed.EPD.Epidemic).GetObjById(aReportID) // 传染病报告信息
	Quit:'$IsObject(objRep) return
	Set PatientID = objRep.MEPDPapmiDR
	Set Contact = objRep.MEPDIntimateCode
	Set objContact = ""
	Set:Contact'="" objContact = ##class(DHCMed.SS.Dictionary).GetByTypeCode("EpidemicContact",Contact,"1")
	If ($IsObject(objContact)){
		Set Contact = objContact.Description
	}
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID) // 病人信息
	Quit:'$IsObject(objPatient) return
	Set Paadm = objRep.MEPDText1
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)	// 病人就诊信息
	
	Set (RepNo,PatientName,MEPDFamName,Nation,HIVMarriage,HIVEducation,MEPDAddress,STDDiaTypeOne,STDDiaTypeTwo,STDDiaTypeThr,STDDiaTypeFour,STDDiaTypeFiv,STDSexPeriod,STDSexPeriodTwo,STDSexPeriodThr,STDSexPeriodFour,STDSexPeriodFiv,STDTrachomaInfList,STDDrugHistory,STDInjection,STDUnmarHistory,STDUnmarried,STDFixedCom,STDMSMHistory,STDMSM,STDBloodDona,STDBloodTran,STDExposure,STDOperation,STDQtResume,OtherSTDQtResume,STDUnknown,STDStdHistory,STDPobSourceList,STDPosSource,STDSimSourceList,STDSimSource,STDTestResult,STDResultDate,STDTestCompany,STDDigSureDate,RepLocDesc,LocTelephone,RepUserName,RepDate,STDResume) = ""
	Set (STDDigSureDate,STDLabResultList,STDUnDo,STDDt,STDTPResultList,STDTPHAResultList,STDELISAResultList,STDQtTest,STDQTResultList,STDMLabResultList,STDMUnDo,STDMDt,STDMTPResultList,STDMTPHAResultList,STDMELISAResultList,STDMQtTest,STDMQTResultList,STDHaveList,STDSymbolList,STDQtSymbol,STDBusiness,STDLabResult,STDTPResult,STDTPHAResult,STDELISAResult,IsSTDQtTest,STDMLabResult,STDMTPResult,STDMTPHAResult,STDMELISAResult,STDMQtTest)=""
	
	/*  报告基本信息   */
	Set PatientName 	= objPatient.PatientName				 // 患者姓名
	Set PatientSex 		= objPatient.Sex					 	 // 患者性别
	Set Birthday 		= objPatient.Birthday					 // 出生日期
	
	/* HBV附卡信息 */		
	s STDInfoArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCMed.EPDService.EpidemicSubSrv","QryEpidemicSubInfo",aReportID)	
	
	Set SubData = ""
	For ind=1:1:STDInfoArray.Count(){
		Set STDInfo=STDInfoArray.GetAt(ind)
		Set ItemCode  = STDInfo.GetAt("ItemCode")
		Set ItemValue = STDInfo.GetAt("ItemValue")
		Set SubData(ItemCode) = ItemValue
	}
	
	Set HBVHBsAgPositive 		= SubData("cboHBVHBsAgPositive")	    // HBsAg阳性时间
	
	Set HBVDiluteList	 		= SubData("radHBVDiluteList")	    	// 抗-HBc  IgM 1:1000稀释检测结果
	Set HBVALT			 		= SubData("txtHBVALT")	   			 	// 本次ALT
	Set HBVSymbolDate	 		= SubData("dtHBVSymbolDate")	    	// 首次出现乙肝症状和体征的时间
	Set HBVLiverResult	 		= SubData("cboHBVLiverResult")	   	 	// 肝组织穿刺检测结果
	Set HBVSerumList	 		= SubData("radHBVSerumList")	    	// 恢复期血清HBsAg阴转,抗HBs阳转
	Set HBVSymbol	 			= SubData("chk-HBVSymbol")	    		// 无症状
	Set HBVUnknown		 		= SubData("chk-HBVUnknown")	    		// 不详
	Set Data =PatientName_"^"_PatientSex_"^"_Birthday_"^"_HBVHBsAgPositive_"^"_HBVDiluteList_"^"_HBVALT_"^"_HBVSymbolDate_"^"_HBVLiverResult_"^"_HBVSerumList_"^"_HBVSymbol_"^"_HBVUnknown_"^"_Contact
	Set return = Data
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-03-21
/// Description:  获取HBV传染病报卡字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：
/// zw ##Class(DHCMed.EPDService.LodopReportInfo).GetHBVRepDicList()
ClassMethod GetHBVRepDicList() As %List
{
	Set return = ""
	
	Set HBVListOne		= ..GetDictionary("EpdemicHBsAgPositiveTime")
	Set HBVListTwo 		= ..GetDictionary("EpdemicLiverTestResult")
	Set HBVListThr 		= ..GetDictionary("EpdemicPositiveNegative")
	Set HBVListFor	 	= ..GetDictionary("EpdHBVHBsAgLab")
	Set EpidemicContactList 	= ..GetDictionary("EpidemicContact")
	
	Set HIVDicData = $LB(HBVListOne,HBVListTwo,HBVListThr,HBVListFor,EpidemicContactList) 
	Set return = HIVDicData
	Quit return
}

}

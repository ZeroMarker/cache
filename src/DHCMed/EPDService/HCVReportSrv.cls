/// 新诊断报告丙肝病例调查表
Class DHCMed.EPDService.HCVReportSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Description:  根据ID获取新诊断报告丙肝病例调查表
/// Table：       DHCMed.EPD.HCVReport
/// Input：       ID: DHCMed.EPD.HCVReport.ID
/// Return：      返回obj
/// W ##class(DHCMed.EPDService.HCVReportSrv).GetRepByID("3")
ClassMethod GetRepByID(aID As %String) As %String
{
	New (aID)
	Set return = ""
	Set separete=..#SEPARATE
	
	Set objRep =##class(DHCMed.EPD.HCVReport).GetObjById(aID)
	Quit:'$IsObject(objRep) return
	
	Set EpisodeID        = objRep.HcvEpisodeID
	Set PatientID        = objRep.HcvPatientID
	Set StatusDr         = objRep.HcvStatusDr
	Set (StatusID,StatusCode,StatusDesc)=""
	If $IsObject(StatusDr) {
		Set StatusID=StatusDr.%Id()
		Set StatusCode=StatusDr.Code
		Set StatusDesc=StatusDr.Description
	}

	Set OrganName = objRep.HcvOrganName
	Set OrganID = objRep.HcvOrganID             //机构代码
	Set SerialNum = objRep.HcvSerialNum
	If (SerialNum = "") {
		If ($l(aID) < 4) {
			Set $p(SerialNum,"0",4-$l(aID)) = aID		//流水号根据ID自动填充成三位
		} Else {
			Set SerialNum = aID
		}
		//保存自动生成的流水号
		Set SaveID = ""
		Set SaveID = ##class(DHCMed.EPD.HCVReport).UpdateSerialNum(aID,SerialNum)
	}
	//文化程度
	Set Education = objRep.HcvEducation
	Set (EducationID,EducationCode,EducationDesc)=""
	If $IsObject(Education) {
		Set EducationID=Education.%Id()
		Set EducationCode=Education.Code
		Set EducationDesc=Education.Description
	}
	//婚姻
	Set Marrige = objRep.HcvMarrige
	Set (MarrigeID,MarrigeCode,MarrigeDesc)=""
	If $IsObject(Marrige) {
		Set MarrigeID=Marrige.%Id()
		Set MarrigeCode=Marrige.Code
		Set MarrigeDesc=Marrige.Description
	}
	//月收入
	Set PerMonIncome = objRep.HcvPerMonIncome
	Set (PerMonIncomeID,PerMonIncomeCode,PerMonIncomeDesc)=""
	If $IsObject(PerMonIncome) {
		Set PerMonIncomeID=PerMonIncome.%Id()
		Set PerMonIncomeCode=PerMonIncome.Code
		Set PerMonIncomeDesc=PerMonIncome.Description
	}
	//医保
	Set MedInsType = objRep.HcvMedInsType
	Set (MedInsTypeID,MedInsTypeCode,MedInsTypeDesc)=""
	If $IsObject(MedInsType) {
		Set MedInsTypeID=MedInsType.%Id()
		Set MedInsTypeCode=MedInsType.Code
		Set MedInsTypeDesc=MedInsType.Description
	}
	Set MedInsTypeExt=objRep.HcvMedInsTypeExt            //医保其他
	Set TestPosDate=objRep.HcvTestPosDate                
	Set:TestPosDate'="" TestPosDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(TestPosDate)	
	Set TestMethod = objRep.HcvTestMethod
	Set (TestMethodID,TestMethodCode,TestMethodDesc)=""
	If $IsObject(TestMethod) {
		Set TestMethodID=TestMethod.%Id()
		Set TestMethodCode=TestMethod.Code
		Set TestMethodDesc=TestMethod.Description
	}
	
	Set TestReasonDR = objRep.HcvTestReasonDR
	Set (TestReasonID,TestReasonCode,TestReasonDesc)=""
	If $IsObject(TestReasonDR) {
		Set TestReasonID=TestReasonDR.%Id()
		Set TestReasonCode=TestReasonDR.Code
		Set TestReasonDesc=TestReasonDR.Description
	}
	Set TestReasonExt=objRep.HcvTestReasonExt    
	Set RecheckDate=objRep.HcvRecheckDate                
	Set:RecheckDate'="" RecheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RecheckDate)	
	Set IsRecheck = objRep.HcvIsRecheck
	Set IsRecheckDesc=$Select(IsRecheck=1:"已做",1:"未做")
	Set RechMethod = objRep.HcvRechMethod
	Set (RechMethodID,RechMethodCode,RechMethodDesc)=""
	If $IsObject(RechMethod) {
		Set RechMethodID=RechMethod.%Id()
		Set RechMethodCode=RechMethod.Code
		Set RechMethodDesc=RechMethod.Description
	}
	Set Results = objRep.HcvResults
	Set (ResultsID,ResultsCode,ResultsDesc)=""
	If $IsObject(Results) {
		Set ResultsID=Results.%Id()
		Set ResultsCode=Results.Code
		Set ResultsDesc=Results.Description
	}      
	Set NucleinRet = objRep.HcvNucleinRet
	Set NucleinRetDesc = $Select(NucleinRet=1:"阳性",1:"阴性")
    Set NucleinRetExt = objRep.HcvNucleinRetExt 
	Set BloodDate = objRep.HcvBloodDate                
	Set:BloodDate'="" BloodDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(BloodDate)	
	Set IsCheck = objRep.HcvIsCheck
	Set IsCheckDesc = $Select(IsCheck=1:"已采",1:"未采")
	Set EntryDate = objRep.HcvEntryDate                
	Set:EntryDate'="" EntryDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EntryDate)	
 	Set CardNo = objRep.HcvCardNo
	Set ReferDate = objRep.HcvReferDate                
	Set:ReferDate'="" ReferDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReferDate)	
	Set IsRefer = objRep.HcvIsRefer
	Set IsReferDesc = $Select(IsRefer=1:"已转介",1:"未转介")
	Set ReferResult = objRep.HcvReferResult
	Set (ReferResultID,ReferResultCode,ReferResultDesc)=""
	If $IsObject(ReferResult) {
		Set ReferResultID=ReferResult.%Id()
		Set ReferResultCode=ReferResult.Code
		Set ReferResultDesc=ReferResult.Description
	}      
	Set TreatmentDate = objRep.HcvTreatmentDate                
	Set:TreatmentDate'="" TreatmentDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(TreatmentDate)	
	Set UntreatedDR = objRep.HcvUntreatedDR
	Set (UntreatedID,UntreatedCode,UntreatedDesc)=""
	If $IsObject(UntreatedDR) {
		Set UntreatedID = UntreatedDR.%Id()
		Set UntreatedCode = UntreatedDR.Code
		Set UntreatedDesc = UntreatedDR.Description
	}
	Set UntreatedExt=objRep.HcvUntreatedExt    

	Set RepUser=objRep.HcvRepUser                 //报告人
	Set RepDate=objRep.HcvRepDate                  //报告日期)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set Resume=objRep.HcvResume                 //报告状态

	 
	Set return=aID_separete                               //报告ID
	Set return=return_EpisodeID_separete                  //EpisodeID
	set return=return_PatientID_separete                  //PatientID
	Set return=return_StatusID_$c(2)_StatusCode_$c(2)_StatusDesc_separete      //报告状态             
	Set return=return_OrganName_separete             //机构名称
	Set return=return_OrganID_separete              //机构代码
	Set return=return_SerialNum_separete          //流水号
	Set return=return_EducationID_$c(2)_EducationCode_$c(2)_EducationDesc_separete      //文化程度             
	Set return=return_MarrigeID_$c(2)_MarrigeCode_$c(2)_MarrigeDesc_separete      //婚姻状况            
	Set return=return_PerMonIncomeID_$c(2)_PerMonIncomeCode_$c(2)_PerMonIncomeDesc_separete      //个人月收入             
	Set return=return_MedInsTypeID_$c(2)_MedInsTypeCode_$c(2)_MedInsTypeDesc_separete      //医保类型           
    Set return=return_MedInsTypeExt_separete            //医保类型其他
	Set return=return_TestPosDate_separete              //首次抗体检测阳性日期
	Set return=return_TestMethodID_$c(2)_TestMethodCode_$c(2)_TestMethodDesc_separete      //首次抗体检测阳性方法             
	Set return=return_TestReasonID_$c(2)_TestReasonCode_$c(2)_TestReasonDesc_separete      //检测主要原因
	Set return=return_TestReasonExt_separete                            //其他检测原因	
	Set return=return_RecheckDate_separete                              //抗体复检日期
	Set return=return_IsRecheck_$c(2)_IsRecheckDesc_separete          //是否做抗体复检
	Set return=return_RechMethodID_$c(2)_RechMethodCode_$c(2)_RechMethodDesc_separete          //抗体复检方法
	Set return=return_ResultsID_$c(2)_ResultsCode_$c(2)_ResultsDesc_separete          //抗体复检结果
	Set return=return_NucleinRet_$c(2)_NucleinRetDesc_separete          //丙肝核酸检测结果	
	Set return=return_NucleinRetExt_separete                            //病毒载量
	Set return=return_BloodDate_separete                             // 采血日期
	Set return=return_IsCheck_$c(2)_IsCheckDesc_separete            //是否采血
	Set return=return_EntryDate_separete                           // 网络直报录入日期	
	Set return=return_CardNo_separete                              // 疫情库卡片编号
	Set return=return_ReferDate_separete  							  //转介治疗日期
	Set return=return_IsRefer_$c(2)_IsReferDesc_separete           //是否转介
	Set return=return_ReferResultID_$c(2)_ReferResultCode_$c(2)_ReferResultDesc_separete  //转介结果             //上报位置
	Set return=return_TreatmentDate_separete 						//治疗开始日期
	Set return=return_UntreatedID_$c(2)_UntreatedCode_$c(2)_UntreatedDesc_separete      //未治疗原因
	Set return=return_UntreatedExt_separete           //其他未治疗原因
	Set return=return_RepUser_separete                // 填报人
	Set return=return_RepDate_separete               // 填报日期
	Set return=return_Resume_separete                //备注
	Quit return
}

/// Creator： zhangjuan
/// CreatDate： 2022-06-13
/// Description: 查询患者个案调查登记(用做公卫界面显示报告)
/// Table： DHCMed.EPD.HCVReport
/// Input： PatientID病人ID
/// Return：xID,SerialNum,EpisodeID,PatientID,PapmiNo,PatientName,PatientSex,PatientAge,Birthday,StatusID,StatusCode,StatusDesc,TestPosDate,TestMethodDesc,TestReasonDesc,RecheckDate,NucleinRetDesc,ReferResultDesc,RepDate
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.HCVReportSrv","QryReportByPat","51")
Query QryReportByPat(aPatientID As %String) As %Query(ROWSPEC = "RepoetID:%String,SerialNum:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,Birthday:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,TestPosDate:%String,TestMethodDesc:%String,TestReasonDesc:%String,RecheckDate:%String,NucleinRetDesc:%String,ReferResultDesc:%String,RepDate:%String,Reason:%String") [ SqlProc ]
{
}

ClassMethod QryReportByPatExecute(ByRef qHandle As %Binary, aPatientID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:(aPatientID="") $$$OK
	Set xID=""
	For {		
		Set xID=$o(^DHCMed.EPD.HCVReportI("IndexPatientID"," "_$ZCVT(aPatientID,"U"),xID),-1)
		Quit:(xID="")
		Set objReport=##class(DHCMed.EPD.HCVReport).GetObjById(xID)
		Continue:'$IsObject(objReport)
			
		Set EpisodeID = objReport.HcvEpisodeID
		Set PatientID = objReport.HcvPatientID
		Set SerialNum = objReport.HcvSerialNum	
		Set StatusDr = objReport.HcvStatusDr
		Set (StatusID,StatusCode,StatusDesc)=""
		If $IsObject(StatusDr) {
			Set StatusID=StatusDr.%Id()
			Set StatusCode=StatusDr.Code
			Set StatusDesc=StatusDr.Description
		}
		Set TestPosDate = objReport.HcvTestPosDate  //首次抗体检测阳性日期
		Set:TestPosDate'="" TestPosDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(TestPosDate)	    
	    Set TestMethod = objReport.HcvTestMethod	
	    Set TestMethodDesc = ""
		If $IsObject(TestMethod) {
			Set TestMethodDesc=TestMethod.Description
		}
	    Set TestReasonDR = objReport.HcvTestReasonDR
		Set TestReasonDesc = ""
		If $IsObject(TestReasonDR) {
			Set TestReasonDesc=TestReasonDR.Description
		}
		Set RecheckDate = objReport.HcvRecheckDate
		Set:RecheckDate'="" RecheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RecheckDate)	    		
		Set NucleinRet = objReport.HcvNucleinRet
		Set NucleinRetExt = objReport.HcvNucleinRetExt
		Set NucleinRetDesc = ""
		If (NucleinRet=1) {
			Set NucleinRetDesc = "阳性,病毒载量为："_NucleinRetExt_"IU/ml"
		} else {
			Set NucleinRetDesc = "阴性"
		}
		Set ReferResult = objReport.HcvReferResult
		Set (ReferResultID,ReferResultCode,ReferResultDesc)=""
		If $IsObject(ReferResult) {
			Set ReferResultID=ReferResult.%Id()
			Set ReferResultCode=ReferResult.Code
			Set ReferResultDesc=ReferResult.Description
		}
		Set RepDate = objReport.HcvRepDate
		Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)	    		
		Set Reason = objReport.HcvReason
		
		Set Data = $lb(xID,SerialNum,EpisodeID,PatientID,PapmiNo,PatientName,PatientSex,PatientAge,Birthday,StatusID,StatusCode,StatusDesc,TestPosDate,TestMethodDesc,TestReasonDesc,RecheckDate,NucleinRetDesc,ReferResultDesc,RepDate,Reason)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReportByPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportByPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind) // Save QHandle
	Quit $$$OK
}

/// Description:  打印界面获取字典信息
/// Table：       DHCMed.SS.Dictionary
/// Input：       Type
/// Return：        
/// zw ##Class(DHCMed.EPDService.HCVReportSrv).GetDictionary("PerMonIncome")
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

/// Description:  打印界面获取报卡字典信息
/// Table：       DHCMed.SS.Dictionary
/// Input：      
/// Return：
/// w ##Class(DHCMed.EPDService.HCVReportSrv).GetRepDicList()
ClassMethod GetRepDicList() As %List
{
	Set rentun = ""
	
	Set SexList = ..GetDictionary("EPDPetSex")
	Set EducationList = ..GetDictionary("HCVEducation")
	Set MarrigeList = ..GetDictionary("HCVSexWed")
	Set PerMonIncomeList = ..GetDictionary("HCVPerMonIncome")
	Set MedInsTypeList = ..GetDictionary("HCVMedInsType")
	Set TestMethodList = ..GetDictionary("HCVTestPosMethod")
	Set TestReasonList = ..GetDictionary("HCVTestReason")
	Set ResultsList = ..GetDictionary("HCVLabResult")		//复检结果
	Set ReferResultList = ..GetDictionary("HCVReferResult")	
	Set UntreatedList = ..GetDictionary("HCVUntreated")		//复检结果	
	
	Set DicList = $LB(SexList,EducationList,MarrigeList,PerMonIncomeList,MedInsTypeList,TestMethodList,TestReasonList,ResultsList,ReferResultList,UntreatedList) 
	Set rentun = DicList
	Quit rentun
}

/// Creator： zhangjuan
/// CreatDate： 202218-06-17
/// Description: 根据日期查询个案调查登记
/// Table： DHCMed.EPD.HCVReport
/// Input： aDateType:日期类型,aStaDate:开始日期, aEndDate:结束日期 , aStatusList:状态
/// Return： ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.HCVReportSrv","QryReportByDate","","","2022-01-01","2022-06-17","")
Query QryReportByDate(aHospID As %String, aDateType As %String, aStaDate As %String, aEndDate As %String, aStatusList As %String) As %Query(ROWSPEC = "ReportID:%String,SerialNum:%String,EpisodeID:%String,PatientID:%String,PapmiNo:%String,PatientName:%String,PatientSex:%String,PatientAge:%String,Birthday:%String,StatusID:%String,StatusCode:%String,StatusDesc:%String,TestPosDate:%String,TestMethodDesc:%String,TestReasonDesc:%String,ResultsDesc:%String,NucleinRet:%String,BloodDate:%String,EntryDate:%String,ReferResultDesc:%String,RepUser:%String,RepDate:%String,CheckUser:%String,CheckDate:%String") [ SqlProc ]
{
}

ClassMethod QryReportByDateExecute(ByRef qHandle As %Binary, aHospID As %String, aDateType As %String, aStaDate As %String, aEndDate As %String, aStatusList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:(aStaDate="")||(aEndDate="") $$$OK
	Set aStaDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aStaDate)
	Set aEndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aEndDate)
	Set:(aDateType="") aDateType="IndexReportDate"
	Set StatusList=""
	If $l(aStatusList,",")>0 {
		For tmpStatusInd=1:1:$l(aStatusList,",") {
			Set StatusList=StatusList_$lb($p(aStatusList,",",tmpStatusInd))
		}
	}
	Set xDate=aStaDate-1
	For {
		Set xDate=$o(^DHCMed.EPD.HCVReportI(aDateType,xDate))
		Quit:(xDate="")||(xDate>aEndDate)
		Set xID=""
		For {
			Set xID=$o(^DHCMed.EPD.HCVReportI(aDateType,xDate,xID))
			Quit:(xID="")
			Set objReport=##class(DHCMed.EPD.HCVReport).GetObjById(xID)
			Continue:'$IsObject(objReport)
			Set (StatusID,StatusCode,StatusDesc)=""
			Set StatusDr=objReport.HcvStatusDr
			If $IsObject(StatusDr) {
				Set StatusID=StatusDr.%Id()
				Set StatusCode=StatusDr.Code
				Set StatusDesc=StatusDr.Description
			}
			Continue:(StatusCode="")||($ListFind(StatusList,StatusCode)<1)
				
			Set SerialNum = objReport.HcvSerialNum
			Set EpisodeID = objReport.HcvEpisodeID
			Set PatientID = objReport.HcvPatientID
			Set HCVPatInfo = ##class(DHCMed.EPDService.InitRepLoadSrv).GetPatInfo(EpisodeID)
			Set PapmiNo = $P($Get(HCVPatInfo),"^",1)             //登记号
			Set PatientName = $P($Get(HCVPatInfo),"^",3)       //姓名
			Set PatientSex = $P($Get(HCVPatInfo),"^",4)               //性别
			Set PatientAge = $P($Get(HCVPatInfo),"^",5) 
			Set TestPosDate = objReport.HcvTestPosDate
			Set:TestPosDate'="" TestPosDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(TestPosDate)
			Set TestMethod = objReport.HcvTestMethod
			Set TestMethodDesc = ""
			If $IsObject(TestMethod) {
				Set TestMethodDesc = TestMethod.Description
			}
			Set TestReason = objReport.HcvTestReasonDR
			Set TestReasonDesc = ""
			If $IsObject(TestReason) {
				Set TestReasonDesc = TestReason.Description
			}
			Set TestReasonExt = objReport.HcvTestReasonExt
			Set:TestReasonDesc="其他" TestReasonDesc = TestReasonExt
			Set Results = objReport.HcvResults
			Set ResultsDesc = ""
			If $IsObject(Results) {
				Set ResultsDesc = Results.Description
			}
			Set:ResultsDesc="" ResultsDesc = "未做"
			Set NucleinRet = objReport.HcvNucleinRetExt
			If (NucleinRet="") {
				Set NucleinRet = "阴性"
			} Else {
				Set NucleinRet = "阳性,病毒载量:"_NucleinRet_"IU/ml"
			}
			Set BloodDate = objReport.HcvBloodDate
			Set:BloodDate'="" BloodDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(BloodDate)
			Set:BloodDate="" BloodDate="未采"
			Set EntryDate = objReport.HcvEntryDate
			Set:EntryDate'="" EntryDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(EntryDate)
			Set ReferResult = objReport.HcvReferResult
			Set ReferResultDesc = ""
			If $IsObject(ReferResult) {
				Set ReferResultDesc = ReferResult.Description
			}
			Set:ReferResultDesc="" ReferResultDesc = "未转介"
			Set RepUser = objReport.HcvRepUser
			Set RepDate = objReport.HcvRepDate
			Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)				
			Set CheckUser = objReport.HcvCheckUser
			Set CheckDate = objReport.HcvCheckDate
			Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
			
			Set Data = $lb(xID,SerialNum,EpisodeID,PatientID,PapmiNo,PatientName,PatientSex,PatientAge,Birthday,StatusID,StatusCode,StatusDesc)
			Set Data =Data_$lb(TestPosDate,TestMethodDesc,TestReasonDesc,ResultsDesc,NucleinRet,BloodDate,EntryDate,ReferResultDesc,RepUser,RepDate,CheckUser,CheckDate)

			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryReportByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If (ind="") {	// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	} Else {	// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind) // Save QHandle
	Quit $$$OK
}

}

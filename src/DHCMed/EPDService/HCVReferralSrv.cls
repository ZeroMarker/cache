/// 名称:  DHCMed.EPDService.HCVReferralSrv
/// 描述:  丙肝转介通知单服务类
/// 编写者： chenrui
/// 编写日期:  2023-03-01
Class DHCMed.EPDService.HCVReferralSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

///  Creator：     chenrui
///  CreatDate：   2023-03-01
///  Description:  根据就诊号查询丙肝转介单卡信息（公共卫生事件加载）
///  Table：       DHCMed.EPD.SYPChildReport
///  d ##class(%ResultSet).RunQuery("DHCMed.EPDService.HCVReferralSrv","QueryHCVRefByPaadm","175")
Query QueryHCVRefByPaadm(aEpisodeID As %String) As %Query(ROWSPEC = "RepID:%String,PatName:%String,PatSex:%String,PersonalID:%String,ReportDate:%String,RefOrgName:%String,RefDoctor:%String,RepStatus:%String") [ SqlProc ]
{
}

ClassMethod QueryHCVRefByPaadmExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set (PatName,PatSex,PersonalID,ReportDate,RefOrgName,RefDoctor,RepStatus) =""
	Set xRepID=""
		For{
			Set xRepID=$o(^DHCMed.EPD.HCVReferralI("EpisodeIDIndex",aEpisodeID,xRepID))
			Quit:xRepID=""
			Set objReport=##class(DHCMed.EPD.HCVReferral).GetObjById(xRepID)
			Continue:'$IsObject(objReport)
			
			Set PatName 		=  objReport.PatName
			Set PatSex		 	=  objReport.PatSex
			Set:PatSex'="" PatSex = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
			Set PersonalID 		=  objReport.PersonalID
			Set ReportDate 		=  objReport.ReportDate
			Set:ReportDate'="" ReportDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
			Set RefOrgName 		=  objReport.RefOrgName
			Set:RefOrgName'="" RefOrgName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc","",RefOrgName)
			Set RefDoctor 		=  objReport.RefDoctor
			Set:RefDoctor'="" RefDoctor = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc","",RefDoctor)
			Set RepStatus 		=  objReport.RepStatus
			Set:RepStatus'="" RepStatus = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",RepStatus)	
			Set Date = $lb(xRepID,PatName,PatSex,PersonalID,ReportDate,RefOrgName,RefDoctor,RepStatus)
			
			Set ^CacheTemp(repid,ind)=Date
			Set ind=ind+1
			
		}

	Quit $$$OK
}

ClassMethod QueryHCVRefByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHCVRefByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryHCVRefByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHCVRefByPaadmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator： chenrui
/// CreatDate： 2023-03-01
/// Description: 根据日期查询丙肝转介单
/// Table： DHCMed.EPD.HCVReferral
/// Input： aDateType:日期类型,aStaDate:开始日期, aEndDate:结束日期 , aStatusList:状态
/// Return： ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.EPDService.HCVReferralSrv","QryReportByDate","","2023-02-01","2023-03-01","")
Query QryReportByDate(aHospID As %String, aStaDate As %String, aEndDate As %String, aStatusList As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,RecHospName:%String,PatName:%String,PatSex:%String,PersonalID:%String,DetectionDesc:%String,ExamPlanDesc:%String,OtherPlan:%String,RefTelPhone:%String,RefDoctor:%String,RefOrgName:%String,Resume:%String,ReportDate:%String,RepStatus:%String") [ SqlProc ]
{
}

ClassMethod QryReportByDateExecute(ByRef qHandle As %Binary, aHospID As %String, aStaDate As %String, aEndDate As %String, aStatusList As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Quit:(aStaDate="")||(aEndDate="") $$$OK
	Set aStaDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aStaDate)
	Set aEndDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aEndDate)
	Set (EpisodeID,RecHospName,PatName,PatSex,PersonalID,DetectionDesc,ExamPlanDesc,OtherPlan,RefTelPhone,RefDoctor,RefOrgName,Resume,ReportDate,RepStatus)=""
	
	For TempDate=aStaDate:1:aEndDate{
		Set xID=""
		For{
			Set xID = $o(^DHCMed.EPD.HCVReferralI("ReportDateIndex",TempDate,xID))
			Quit:xID=""
			Set HCVRefInfo = $g(^DHCMed.EPD.HCVReferralD(xID))
			Set EpisodeID   = $lg(HCVRefInfo,2)
			Set RecHospName = $lg(HCVRefInfo,4)
			Set PatName  	= $lg(HCVRefInfo,5)
			Set PatSex  	= $lg(HCVRefInfo,6)
			Set PersonalID  = $lg(HCVRefInfo,7)
			Set DetectionDr = $lg(HCVRefInfo,8)
			Set:DetectionDr'="" DetectionDesc = $lg($g(^DHCMed.SS.DictionaryD(DetectionDr)),4)
			Set ExamPlanDr  = $lg(HCVRefInfo,9)
			Set:ExamPlanDr'="" ExamPlanDesc = $lg($g(^DHCMed.SS.DictionaryD(ExamPlanDr)),4)
			Set OtherPlan   = $lg(HCVRefInfo,10)
			Set RefTelPhone = $lg(HCVRefInfo,11)
			Set RefDoctor   = $lg(HCVRefInfo,12)
			Set RefOrgName  = $lg(HCVRefInfo,13)
			Set Resume  	= $lg(HCVRefInfo,14)
			Set ReportDate  = $lg(HCVRefInfo,15)
			Set:ReportDate'="" ReportDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
			Set RepStatus   = $lg(HCVRefInfo,16)
			Continue:((aStatusList'="")&&(aStatusList'[RepStatus))
			Set Data = $lb(xID,EpisodeID,RecHospName,PatName,PatSex,PersonalID,DetectionDesc,ExamPlanDesc,OtherPlan,RefTelPhone,RefDoctor,RefOrgName,Resume,ReportDate,RepStatus)
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

/// 打印丙肝转介通知单
/// w ##Class(DHCMed.EPDService.HCVReferralSrv).PrintHCVRefReport("1")
ClassMethod PrintHCVRefReport(aReportID As %String) As %String
{
	new (aReportID) 
	Set return = ""
	Quit:aReportID="" return
	Set (RecHospName,PatName,PatSex,PersonalID,DetectionDesc,ExamPlanDesc,OtherPlan,RefTelPhone,RefDoctor,RefOrgName,Resume,ReportDate) = ""
	Set HCVRefInfo = $g(^DHCMed.EPD.HCVReferralD(aReportID))
	Set RecHospName = $lg(HCVRefInfo,4)
	Set PatName  	= $lg(HCVRefInfo,5)
	Set PatSex  	= $lg(HCVRefInfo,6)
	Set PersonalID  = $lg(HCVRefInfo,7)
	Set DetectionDr = $lg(HCVRefInfo,8)
	Set:DetectionDr'="" DetectionDesc = $lg($g(^DHCMed.SS.DictionaryD(DetectionDr)),4)
	Set ExamPlanDr  = $lg(HCVRefInfo,9)
	Set:ExamPlanDr'="" ExamPlanDesc = $lg($g(^DHCMed.SS.DictionaryD(ExamPlanDr)),4)
	Set OtherPlan   = $lg(HCVRefInfo,10)
	Set RefTelPhone = $lg(HCVRefInfo,11)
	Set RefDoctor   = $lg(HCVRefInfo,12)
	Set RefOrgName  = $lg(HCVRefInfo,13)
	Set Resume  	= $lg(HCVRefInfo,14)
	Set ReportDate  = $lg(HCVRefInfo,15)
	Set:ReportDate'="" ReportDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	
	Set return = RecHospName_"^"_PatName_"^"_PatSex_"^"_PersonalID_"^"_DetectionDesc_"^"_ExamPlanDesc_"^"_OtherPlan_"^"_RefTelPhone_"^"_RefDoctor_"^"_RefOrgName_"^"_Resume_"^"_ReportDate
	
	Quit return
}

/// zw ##Class(DHCMed.EPDService.HCVReferralSrv).GetHCVRefDicList()
ClassMethod GetHCVRefDicList() As %List
{
	
	Set return = ""
	Set HcvDetectionList 	= ..GetDictionary("EPDHcvDetection")
	Set HcvExamPlanList 	= ..GetDictionary("EPDHcvExamPlan")
	Set return = $LB(HcvDetectionList,HcvExamPlanList) 
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-02-25
/// Description:  获取字典信息
/// Table：       DHCMed.EPD.Epidemic
/// Input：      
/// Return：        
/// zw ##Class(DHCMed.EPDService.HCVReferralSrv).GetDictionary("DTMRegType")
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

}

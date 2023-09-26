/// 创建者：李阳
/// 创建日期：2015-02-04
/// 功能：为导出XML提供数据加工功能【严重精神障碍患者发病报告卡】
Class DHCMed.SMDService.ExportXml02 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod BuildData(objRep As DHCMed.SMD.Report) As %List
{
	New (objRep)
	Set return=""
	Quit:'$IsObject(objRep) return
	Set ReportID=objRep.%Id()
	Set EpisodeID=objRep.SREpisodeID
	
	//获取患者基本信息
	Set objPat=##class(DHCMed.SMD.ReportPat).GetPatObj(ReportID,EpisodeID)
	
	Set return=return_$lb(objRep.SRCardNo)                //CARD_ID 卡片ID
	Set PatTypeCode=""
	If $IsObject(objRep.SRPatTypeDr){
		;Set PatTypeCode=..GetMapping("IOPatType",objRep.SRRepTypeDr.Code,"",objRep.SRRepTypeDr.Description)
		set PatTypeCode=objRep.SRPatTypeDr.Code
	}
	Set return=return_$lb(PatTypeCode)                    //REPORT_TYPE 患者类型
	Set AdmitReasonCode=""
	If $IsObject(objRep.SRAdmitReasonDr){
		Set AdmitReasonCode=..GetMapping("IOAdmitReason",objRep.SRAdmitReasonDr.Code,"",objRep.SRAdmitReasonDr.Description)
	}
	Set return=return_$lb(AdmitReasonCode)                //INHOS_REASON 本次入院原因
	Set WholenessCode=""
	If $IsObject(objRep.SRWholenessDr){
		Set WholenessCode=..GetMapping("IOWholeness",objRep.SRWholenessDr.Code,"",objRep.SRWholenessDr.Description)
	}
	Set return=return_$lb(WholenessCode)                  //INTEGRITY 患者信息完整性
	Set AdmitDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	Set return=return_$lb(AdmitDate)                      //INHOS_DATE 入院日期
	Set return=return_$lb(objPat.RPPatName)               //NAME 姓名
	Set return=return_$lb(objRep.SRContactor)             //LINKER_NAME 联系人
	Set return=return_$lb(objRep.SRContactorTel)          //LINKER_PHONE 联系人电话
	Set return=return_$lb(objPat.RPPersonalID)            //IDENTITY_CARD 身份证号
	Set SexCode=""
	If (objPat.RPSex'="") {
		Set SexCode=..GetMapping("IOSex",objPat.RPSex,"",objPat.RPSex)
	}
	Set return=return_$lb(SexCode)                        //SEX 性别
	Set return=return_$lb(objRep.SRCompany)               //WORKING 工作单位
	Set return=return_$lb(objRep.SRCompanyTel)            //WORKING_PHONE 工作单位电话
	Set LocalCode=""
	If $IsObject(objRep.SRLocalDr){
		Set LocalCode=..GetMapping("IOLocal",objRep.SRLocalDr.Code,"",objRep.SRLocalDr.Description)
	}
	Set return=return_$lb(LocalCode)                      //CENSUS 人员属地
	
	Set RegAddrTypeCode=""
	If $IsObject(objRep.SRRegAddrTypeDr){
		Set RegAddrTypeCode=..GetMapping("IOAddrType",objRep.SRRegAddrTypeDr.Code,"",objRep.SRRegAddrTypeDr.Description)
	}
	Set return=return_$lb(RegAddrTypeCode)                //hj_type 户籍地区类型
	Set RegProvince=""
	If (objRep.SRRegProvince'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegProvince)
		If $IsObject(objArea) {
			Set RegProvince=..GetMapping("IOProvince",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(RegProvince)                    //hj_province 户籍省
	Set RegCounty=""
	If (objRep.SRRegCounty'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegCounty)
		If $IsObject(objArea) {
			Set RegCounty=..GetMapping("IOCounty",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(RegCounty)                      //HJ_REGION 户籍所在区县
	Set RegVillage=""
	If (objRep.SRRegVillage'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegVillage)
		If $IsObject(objArea) {
			Set RegVillage=..GetMapping("IOVillage",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(RegVillage)                     //HJ_STREET 户籍所在街道
	Set return=return_$lb(objRep.SRRegAddress)            //HJ_DETAIL 户籍详细地址
	Set CurrAddrTypeCode=""
	If $IsObject(objRep.SRCurrAddrTypeDr){
		Set CurrAddrTypeCode=..GetMapping("IOAddrType",objRep.SRCurrAddrTypeDr.Code,"",objRep.SRCurrAddrTypeDr.Description)
	}
	Set return=return_$lb(CurrAddrTypeCode)               //type 现住址地区类型
	Set CurrProvince=""
	If (objRep.SRCurrProvince'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrProvince)
		If $IsObject(objArea) {
			Set CurrProvince=..GetMapping("IOProvince",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(CurrProvince)                   //CENTER 现住址省
	Set CurrCounty=""
	If (objRep.SRCurrCounty'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrCounty)
		If $IsObject(objArea) {
			Set CurrCounty=..GetMapping("IOCounty",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(CurrCounty)                     //REGION 现住址区县
	Set CurrVillage=""
	If (objRep.SRCurrVillage'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrVillage)
		If $IsObject(objArea) {
			Set CurrVillage=..GetMapping("IOVillage",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(CurrVillage)                    //STREET 现住址街道
	Set return=return_$lb(objRep.SRCurrAddress)           //DETAIL 现住址详细地址
	
	Set OccupationCode=""
	If $IsObject(objRep.SROccupationDr){
		Set OccupationCode=..GetMapping("IOOccupation",objRep.SROccupationDr.Code,"",objRep.SROccupationDr.Description)
	}
	Set return=return_$lb(OccupationCode)                 //JOB 职业
	Set SickDate=objRep.SRSickDate
	Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set return=return_$lb(SickDate)                       //FIRST_DATE 初次发病日期
	Set ReferralStr=""
	For indRef=1:1:objRep.SRReferralDr.Count() {
		Set objRef=objRep.SRReferralDr.GetAt(indRef)
		Continue:'$IsObject(objRef)
		Set ReferralCode=..GetMapping("IOReferral",objRef.Code,"",objRef.Description)
		Continue:ReferralCode=""
		Set:ReferralStr'="" ReferralStr=ReferralStr_","
		Set ReferralStr=ReferralStr_ReferralCode
	}
	Set return=return_$lb(ReferralStr)                  //SEND_SUBJECT 送诊主体
	Set return=return_$lb(objRep.SRReferralTxt)         //SUBJECT_QT 送诊主体备注
	Set DiagDate=objRep.SRDiagDate
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set return=return_$lb(DiagDate)                     //DIAGNOSE_DATE 本次确诊日期
	
	Set DiseaseCatCode="",DiseaseICD10=""
	If $IsObject(objRep.SRDiseaseDr){
		If $IsObject(objRep.SRDiseaseDr.IDCateDr) {
			Set DiseaseCatCode=..GetMapping("IODiseasType",objRep.SRDiseaseDr.IDCateDr.Code,"",objRep.SRDiseaseDr.IDCateDr.Description)
		}
		Set DiseaseICD10=..GetMapping("IOICD10",objRep.SRDiseaseDr.IDCode,"",objRep.SRDiseaseDr.IDDesc)
	}
	Set return=return_$lb(DiseaseCatCode)               //ILL_CODE 住院诊断
	Set return=return_$lb(DiseaseICD10)                 //icd10 -- icd10编码
	Set return=return_$lb(objRep.SRDiagHospital)        //REPORT_UNITS 报告单位
	Set return=return_$lb(objRep.SRRepLocTel)           //ZZJG_PHONE 报告单位电话
	Set RepUserID=objRep.SRReportUser
	Set:RepUserID'="" RepUserDesc=$p($g(^SSU("SSUSR",RepUserID)),"^",2)
	Set return=return_$lb(RepUserDesc)                  //REPORT_DOCTOR 填卡医生
	Set RepDate=objRep.SRReportDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set return=return_$lb(RepDate)                      //CARD_DATE 填卡日期
	Set return=return_$lb(objRep.SRReportNote)          //REMARK 备注
	Quit return
}

/// Creator：     李阳
/// CreatDate：   2015-02-16
/// Description:  导出XML数据集
/// Table：       DHCMed.SMD.Report
/// Input：       ReportIDs : 报告ID串,“^”分隔
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.SMDService.ExportXml02","QryForXML","1")
Query QryForXML(aReportIDs As %String) As %Query(ROWSPEC = "CARD_ID:%String,REPORT_TYPE:%String,INHOS_REASON:%String,INTEGRITY:%String,INHOS_DATE:%String,NAME:%String,LINKER_NAME:%String,LINKER_PHONE:%String,IDENTITY_CARD:%String,SEX:%String,WORKING:%String,WORKING_PHONE:%String,CENSUS:%String,HJ_TYPE:%String,HJ_PROVINCE:%String,HJ_REGION:%String,HJ_STREET:%String,HJ_DETAIL:%String,TYPE:%String,CENTER:%String,REGION:%String,STREET:%String,DETAIL:%String,JOB:%String,FIRST_DATE:%String,SEND_SUBJECT:%String,SUBJECT_QT:%String,DIAGNOSE_DATE:%String,ILL_CODE:%String,ICD10:%String,REPORT_UNITS:%String,ZZJG_PHONE:%String,REPORT_DOCTOR:%String,CARD_DATE:%String,REMARK:%String")
{
}

ClassMethod QryForXMLExecute(ByRef qHandle As %Binary, aReportIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	For indRep=1:1:$l(aReportIDs,"^") {
		Set ReportID=$p(aReportIDs,"^",indRep)
		Continue:ReportID=""
		
		Set objRep=##class(DHCMed.SMD.Report).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Set Data=..BuildData(objRep)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryForXMLClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryForXMLExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryForXMLFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryForXMLExecute ]
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

/// 取对照接口字典值，取值为空返回默认值
ClassMethod GetMapping(aMappingType As %String, aSrcValue As %String, aSrcDesc As %String, aDefaultValue As %String = "") As %String
{
	New (aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Set return=##Class(DHCMed.SMDService.ExportXmlSrv).GetMapping(aMappingType,aSrcValue,aSrcDesc,aDefaultValue)
	Quit return
}

}

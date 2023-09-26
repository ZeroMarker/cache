/// 创建者：李阳
/// 创建日期：2015-02-04
/// 功能：为导出XML提供数据加工功能【严重精神障碍患者(含重性精神疾病)出院信息单】
Class DHCMed.SMDService.ExportXml01 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
	
	Set PatSerialNo=##class(DHCMed.SMDService.ExportXmlSrv).GetPatSerialNo(ReportID)
	Set return=$lb(PatSerialNo)                              //patient_id    --病人编码
	Set return=return_$lb(objPat.RPPatName)                  //name    --姓名
	Set return=return_$lb(objPat.RPPersonalID)               //identity--身份证号
	Set return=return_$lb(objPat.RPTelPhone)                 //family_phone-- 家庭电话
	Set return=return_$lb(objRep.SRContactor)                //linker -- 联系人姓名
	Set return=return_$lb(objRep.SRContactorTel)             //linker_phone-- 联系人电话
	Set LocalCode=""
	If $IsObject(objRep.SRLocalDr){
		Set LocalCode=..GetMapping("IOLocal",objRep.SRLocalDr.Code,"",objRep.SRLocalDr.Description)
	}
	Set return=return_$lb(LocalCode)                         //reg_type-- 常住类型
	Set NationDr=##class(DHCMed.SS.Dictionary).GetObjById(objPat.RPNation)
	;Set return=return_$lb(objPat.RPNation)                   //nationality -- 民族
	Set return=return_$lb(NationDr.Description)
	Set RegAddrTypeCode=""
	If $IsObject(objRep.SRRegAddrTypeDr){
		Set RegAddrTypeCode=..GetMapping("IOAddrType",objRep.SRRegAddrTypeDr.Code,"",objRep.SRRegAddrTypeDr.Description)
	}
	Set return=return_$lb(RegAddrTypeCode)                   //hj_type -- 户籍地区类型
	Set RegProvince=""
	If (objRep.SRRegProvince'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegProvince)
		If $IsObject(objArea) {
			Set RegProvince=..GetMapping("IOProvince",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(RegProvince)                       //hj_sheng -- 户籍省
	Set RegCounty=""
	If (objRep.SRRegCounty'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegCounty)
		If $IsObject(objArea) {
			Set RegCounty=..GetMapping("IOCounty",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(RegCounty)                         //hj_region -- 户籍所在区县
	Set RegVillage=""
	If (objRep.SRRegVillage'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRRegVillage)
		If $IsObject(objArea) {
			Set RegVillage=..GetMapping("IOVillage",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(RegVillage)                        //hj_street -- 户籍所在街道
	Set return=return_$lb(objRep.SRRegAddress)               //hj_detail -- 户籍详细地址
	Set CurrAddrTypeCode=""
	If $IsObject(objRep.SRCurrAddrTypeDr){
		Set CurrAddrTypeCode=..GetMapping("IOAddrType",objRep.SRCurrAddrTypeDr.Code,"",objRep.SRCurrAddrTypeDr.Description)
	}
	Set return=return_$lb(CurrAddrTypeCode)                  //type -- 现住址地区类型
	Set CurrProvince=""
	If (objRep.SRCurrProvince'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrProvince)
		If $IsObject(objArea) {
			Set CurrProvince=..GetMapping("IOProvince",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(CurrProvince)                      //center -- 现住址省
	Set CurrCounty=""
	If (objRep.SRCurrCounty'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrCounty)
		If $IsObject(objArea) {
			Set CurrCounty=..GetMapping("IOCounty",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(CurrCounty)                        //publish_region -- 现住址区县
	Set CurrVillage=""
	If (objRep.SRCurrVillage'="") {
		Set objArea=##class(DHCMed.SS.AreaDic).GetObjById(objRep.SRCurrVillage)
		If $IsObject(objArea) {
			Set CurrVillage=..GetMapping("IOVillage",objArea.Code,"",objArea.ShortDesc)
		}
	}
	Set return=return_$lb(CurrVillage)                       //street -- 现住址街道
	Set return=return_$lb(objRep.SRCurrAddress)              //detail -- 现住址详细地址
	Set SickDate=objRep.SRSickDate
	Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set return=return_$lb(SickDate)                          //first_date -- 初次发病时间
	//Set AdmitDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmitDate=$p(AdmDateTime,"^",1)
	Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	Set return=return_$lb(AdmitDate)                         //inhos_date -- 本次入院时间
	//Set DischDate=$p($g(^PAADM(+EpisodeID)),"^",17)
	//Update by pylian 2016-01-21 修改出院时间取值方式
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	
	Set:DischDate'="" DischDate=$zd(DischDate,3)
	Set return=return_$lb(DischDate)                         //outhos_date -- 本次出院时间
	Set AdmitReasonCode=""
	If $IsObject(objRep.SRAdmitReasonDr){
		Set AdmitReasonCode=..GetMapping("IOAdmitReason",objRep.SRAdmitReasonDr.Code,"",objRep.SRAdmitReasonDr.Description)
	}
	Set return=return_$lb(AdmitReasonCode)                   //inhos_reason -- 本次入院原因
	
	Set SymptomCodeStr=""
	For indSym=1:1:objRep.SRSymptomDr.Count() {
		Set objDic=objRep.SRSymptomDr.GetAt(indSym)
		Continue:'$IsObject(objDic)
		Set SymptomCode=..GetMapping("IOSymptom",objDic.MSCode,"",objDic.MSDesc)
		Continue:SymptomCode=""
		Set:SymptomCodeStr'="" SymptomCodeStr=SymptomCodeStr_","
		Set SymptomCodeStr=SymptomCodeStr_SymptomCode
	}
	Set return=return_$lb(SymptomCodeStr)                    // mentallist--精神症状编码
	Set SocietyImpact=objRep.SRSocietyImpact
	Set return=return_$lb($p(SocietyImpact,",",1))           //zishi -- 轻度滋事
	Set return=return_$lb($p(SocietyImpact,",",2))           //zhaoshi -- 肇事
	Set return=return_$lb($p(SocietyImpact,",",3))           //zhaohuo -- 肇祸
	Set return=return_$lb($p(SocietyImpact,",",5))           //zishang -- 自伤
	Set return=return_$lb($p(SocietyImpact,",",6))           //zisha -- 自杀未遂
	Set return=return_$lb($p(SocietyImpact,",",4))           //other_behavior -- 其它危害行为
	Set return=return_$lb(objRep.SRSocietyImpactTxt)         //other_effect -- 其他需要说明的特殊情况
	
	Set OPTreatmentCode=""
	If $IsObject(objRep.SROPTreatmentDr){
		Set OPTreatmentCode=..GetMapping("IOOPTreatment",objRep.SROPTreatmentDr.Code,"",objRep.SROPTreatmentDr.Description)
	}
	Set return=return_$lb(OPTreatmentCode)                   //policlinic -- 门诊既往治疗情况
	Set FirstDrugTreatDate=objRep.SRFirstDrugTreatDate
	Set:FirstDrugTreatDate'="" FirstDrugTreatDate=$zd(FirstDrugTreatDate,3)
	Set return=return_$lb(FirstDrugTreatDate)                //first_drugtreatment -- 首次抗精神药物治疗时间
	Set return=return_$lb(objRep.SRIPTreatTimes)             //inhospital -- 曾住精神专科医院/综合医院精神科
	Set return=return_$lb(objPat.RPOPNo)                     //policlinic_number -- 门诊病案号
	Set return=return_$lb(objPat.RPIPNo)                     //inhospital_number -- 住院病案号
	Set PaymentCode=""
	If $IsObject(objRep.SRPaymentDr){
		Set PaymentCode=..GetMapping("IOPayment",objRep.SRPaymentDr.Code,"",objRep.SRPaymentDr.Description)
	}
	Set return=return_$lb(PaymentCode)                       //payment_type -- 主要医疗付款方式
	Set return=return_$lb(objPat.RPInsurNo)                  //insur_no -- 医保号/新农合号
	
	Set DiseaseCatCode="",DiseaseICD10=""
	If $IsObject(objRep.SRDiseaseDr){
		If $IsObject(objRep.SRDiseaseDr.IDCateDr) {
			Set DiseaseCatCode=..GetMapping("IODiseasType",objRep.SRDiseaseDr.IDCateDr.Code,"",objRep.SRDiseaseDr.IDCateDr.Description)
		}
		Set DiseaseICD10=..GetMapping("IOICD10",objRep.SRDiseaseDr.IDCode,"",objRep.SRDiseaseDr.IDDesc)
	}
	Set return=return_$lb(DiseaseCatCode)                    //diagnose -- 住院诊断
	Set return=return_$lb(DiseaseICD10)                      //icd10 -- icd10编码
	Set DiagDate=objRep.SRDiagDate
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set return=return_$lb(DiagDate)                          //diagnose_date -- 本次确诊日期
	
	Set TreatPharmacyStr=""
	For indPy=1:1:objRep.SRTreatPharmacy.Count() {
		Set objPy=objRep.SRTreatPharmacy.GetAt(indPy)
		Continue:'$IsObject(objPy)
		
		Continue:'$IsObject(objPy.RPDrugDr)		// 药物名称
		Continue:objPy.RPDoseQty=""				// 剂量
		Continue:'$IsObject(objPy.RPDoseUnitDr)	// 单位
		Continue:'$IsObject(objPy.RPInstrucDr)	// 频次(用法)
		Set drugCode=objPy.RPDrugDr.PDCode
		Set doseQty=objPy.RPDoseQty
		Set doseUnit=objPy.RPDoseUnitDr.Code
		Set instruc=objPy.RPInstrucDr.Code
		Set TreatPharmacyStr=TreatPharmacyStr_drugCode_"^"_doseQty_"^"_doseUnit_"^"_instruc
		Set:TreatPharmacyStr'="" TreatPharmacyStr=TreatPharmacyStr_","
	}
	Set return=return_$lb(TreatPharmacyStr)                  //InMedicationList>   -- --住院用药list
	Set TreatMeasureStr=""
	For indTM=1:1:objRep.SRTreatMeasureDr.Count() {
		Set objTM=objRep.SRTreatMeasureDr.GetAt(indTM)
		Set TreatMeasureCode=..GetMapping("IOMeasure",objTM.Code,"",objTM.Description)
		Continue:TreatMeasureCode=""
		Set:TreatMeasureStr'="" TreatMeasureStr=TreatMeasureStr_","
		Set TreatMeasureStr=TreatMeasureStr_TreatMeasureCode
	}
	Set return=return_$lb(TreatMeasureStr)                   //inhospital_method -- 本次住院康复措施
	Set return=return_$lb(objRep.SRTreatMeasureTxt) //inhospital_method_qt -- 住院康复措施其他
	Set PrognosisCode=""
	If $IsObject(objRep.SRPrognosisDr){
		Set PrognosisCode=..GetMapping("IOPrognosis",objRep.SRPrognosisDr.Code,"",objRep.SRPrognosisDr.Description)
	}
	Set return=return_$lb(PrognosisCode)                     //cure_result -- 住院疗效
	Set IsFunding=""
	If $IsObject(objRep.SRIsFunding){
		Set IsFunding=..GetMapping("IOIsFunding",objRep.SRIsFunding.Code,"",objRep.SRIsFunding.Description)
	}
	Set return=return_$lb(IsFunding)                         //if_subsidy -- 本次住院患者是否获得经费补助
	Set FundsType=""
	If $IsObject(objRep.SRFundsType){
		Set FundsType=..GetMapping("IOFundsType",objRep.SRFundsType.Code,"",objRep.SRFundsType.Description)
	}
	Set return=return_$lb(FundsType)                         //subsidy_type -- 补贴类型
	Set FundsSourceCode=""
	If $IsObject(objRep.SRFundsSourceDr){
		Set FundsSourceCode=..GetMapping("IOFundsSource",objRep.SRFundsSourceDr.Code,"",objRep.SRFundsSourceDr.Description)
	}
	Set return=return_$lb(FundsSourceCode)                   //subsidy -- 经费来源
	Set return=return_$lb(objRep.SRFundsSourceTxt)           //subsidy_other -- 其他经费补助来源
	
	Set RehabPharmacyStr=""
	For indPy=1:1:objRep.SRRehabPharmacy.Count() {
		Set objRP=objRep.SRRehabPharmacy.GetAt(indPy)
		Continue:'$IsObject(objRP)
		
		Continue:'$IsObject(objRP.RPDrugDr)		// 药物名称
		Continue:objRP.RPDoseQty=""				// 剂量
		Continue:'$IsObject(objRP.RPDoseUnitDr)	// 单位
		Continue:'$IsObject(objRP.RPInstrucDr)	// 频次(用法)
		Set drugCode=objRP.RPDrugDr.PDCode
		Set doseQty=objRP.RPDoseQty
		Set doseUnit=objRP.RPDoseUnitDr.Code
		Set instruc=objRP.RPInstrucDr.Code
		Set RehabPharmacyStr=RehabPharmacyStr_drugCode_"^"_doseQty_"^"_doseUnit_"^"_instruc
		Set:RehabPharmacyStr'="" RehabPharmacyStr=RehabPharmacyStr_","
	}
	Set return=return_$lb(RehabPharmacyStr)                  //NextMedicationList>   -- 下一步治疗方案及康复用药
	Set RehabMeasureStr=""
	For indRM=1:1:objRep.SRRehabMeasureDr.Count() {
		Set objRM=objRep.SRRehabMeasureDr.GetAt(indRM)
		Set RehabMeasureCode=..GetMapping("IOMeasure",objRM.Code,"",objRM.Description)
		Continue:RehabMeasureCode=""
		Set:RehabMeasureStr'="" RehabMeasureStr=RehabMeasureStr_","
		Set RehabMeasureStr=RehabMeasureStr_RehabMeasureCode
	}
	Set return=return_$lb(RehabMeasureStr)                   //next_method -- 下一步康复措施
	Set return=return_$lb(objRep.SRTreatMeasureTxt)          //next_method_qt -- 下一步康复措施其他
	Set return=return_$lb(objRep.SRRehabResume)              //remarks -- 其他注意事项
	Set RepUserID=objRep.SRReportUser
	Set:RepUserID'="" RepUserDesc=$p($g(^SSU("SSUSR",RepUserID)),"^",2)
	Set return=return_$lb(RepUserDesc)                       //doctor -- 经治医生
	Set return=return_$lb(objRep.SRRepLocTel)                //doctor_phone -- 医生联系电话
	Set RepDate=objRep.SRReportDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set return=return_$lb(RepDate)                           //sign_time -- 签字日期
	Quit return
}

/// Creator：     李阳
/// CreatDate：   2015-02-16
/// Description:  导出XML数据集
/// Table：       DHCMed.SMD.Report
/// Input：       ReportIDs : 报告ID串,“^”分隔
/// Return：      ROWSPEC=...
/// d ##Class(%ResultSet).RunQuery("DHCMed.SMDService.ExportXml01","QryForXML","1582")
Query QryForXML(aReportIDs As %String) As %Query(ROWSPEC = "PATIENT_ID:%String,NAME:%String,IDENTITY:%String,FAMILY_PHONE:%String,LINKER:%String,LINKER_PHONE:%String,REG_TYPE:%String,NATIONALITY:%String,HJ_TYPE:%String,HJ_SHENG:%String,HJ_REGION:%String,HJ_STREET:%String,HJ_DETAIL:%String,TYPE:%String,CENTER:%String,PUBLISH_REGION:%String,STREET:%String,DETAIL:%String,FIRST_DATE:%String,INHOS_DATE:%String,OUTHOS_DATE:%String,INHOS_REASON:%String,MENTALLIST:%String,ZISHI:%String,ZHAOSHI:%String,ZHAOHUO:%String,ZISHANG:%String,ZISHA:%String,OTHER_BEHAVIOR:%String,OTHER_EFFECT:%String,POLICLINIC:%String,FIRST_DRUGTREATMENT:%String,INHOSPITAL:%String,POLICLINIC_NUMBER:%String,INHOSPITAL_NUMBER:%String,PAYMENT_TYPE:%String,INSUR_NO:%String,DIAGNOSE:%String,ICD10:%String,DIAGNOSE_DATE:%String,INMEDICATIONLIST:%String,INHOSPITAL_METHOD:%String,INHOSPITAL_METHOD_QT:%String,CURE_RESULT:%String,IF_SUBSIDY:%String,SUBSIDY_TYPE:%String,SUBSIDY:%String,SUBSIDY_OTHER:%String,NEXTMEDICATIONLIST:%String,NEXT_METHOD:%String,NEXT_METHOD_QT:%String,REMARKS:%String,DOCTOR:%String,DOCTOR_PHONE:%String,SIGN_TIME:%String")
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

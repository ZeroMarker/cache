/// 严重精神障碍患者表结构 Severe mental disorders
/// 创建者：李阳
/// 创建日期：2014-12-08
Class DHCMed.SMD.Report Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property SREpisodeID As %String;

/// 基本信息ID
Property SRPatientID As %String;

/// 报告类型
/// 指向DHCMed.SS.Dictionary("SMDRepType")
/// (1-重性精神疾病报卡/2-重性精神疾病出院信息单/3-严重精神障碍报卡/4-严重精神障碍出院信息单)
Property SRRepTypeDr As DHCMed.SS.Dictionary;

/// 发病报卡类型(门诊/住院)("SMDAdmType")
Property SRAdmTypeDr As DHCMed.SS.Dictionary;

/// 患者类型(新诊断/复发病人)("SMDPatType")
Property SRPatTypeDr As DHCMed.SS.Dictionary;

/// 人员属地("SMDLocal")
Property SRLocalDr As DHCMed.SS.Dictionary;

/// 严重精神疾病名称
Property SRDiseaseDr As DHCMed.SS.Disease;

/// 严重精神疾病备注
Property SRDiseaseText As %String;

/// 报告状态("SMDRepStatus")
Property SRStatusDr As DHCMed.SS.Dictionary;

/// 卡片编号
Property SRCardNo As %String;

/// 患者信息完整性("SMDIsComplete")
Property SRWholenessDr As DHCMed.SS.Dictionary;

/// 病人基本信息
Property SRPatientObj As DHCMed.SMD.ReportPat;

/// 主要医疗付款方式("SMDPaidType")
Property SRPaymentDr As DHCMed.SS.Dictionary;

/// 联系人姓名
Property SRContactor As %String;

/// 联系人电话
Property SRContactorTel As %String;

/// 联系电话
Property SRHomeTel As %String;

/// 户籍地址
Property SRRegAddress As %String(MAXLEN = 500, TRUNCATE = 1);

/// 户籍地址类型("SMDAddrType")
Property SRRegAddrTypeDr As DHCMed.SS.Dictionary;

/// 户籍地省
Property SRRegProvince As %String;

/// 户籍地市
Property SRRegCity As %String;

/// 户籍地县
Property SRRegCounty As %String;

/// 户籍地乡
Property SRRegVillage As %String;

/// 户籍地街道
Property SRRegRoad As %String;

/// 现住址
Property SRCurrAddress As %String(MAXLEN = 500, TRUNCATE = 1);

/// 现住址类型("SMDAddrType")
Property SRCurrAddrTypeDr As DHCMed.SS.Dictionary;

/// 现住址省
Property SRCurrProvince As %String;

/// 现住址市
Property SRCurrCity As %String;

/// 现住址县
Property SRCurrCounty As %String;

/// 现住址乡
Property SRCurrVillage As %String;

/// 现住址街道
Property SRCurrRoad As %String;

/// 职业(类别)("SMDOccupation")
Property SROccupationDr As DHCMed.SS.Dictionary;

/// 工作单位
Property SRCompany As %String;

/// 工作单位联系电话
Property SRCompanyTel As %String;

/// 初次发病日期
Property SRSickDate As %Date;

/// 送诊主体(可多选)("SMDReferral")
Property SRReferralDr As list Of DHCMed.SS.Dictionary;

/// 送诊主体备注
Property SRReferralTxt As %String;

/// 确诊医院
Property SRDiagHospital As %String;

/// 确诊日期
Property SRDiagDate As %Date;

/// 本次入院原因("SMDAdmitReason")
Property SRAdmitReasonDr As DHCMed.SS.Dictionary;

/// 精神状态
Property SRSymptomDr As list Of DHCMed.SMD.Symptom;

/// 患者对社会以及家庭的影响
Property SRSocietyImpact As %String;

/// 患者对社会以及家庭的影响其他说明
Property SRSocietyImpactTxt As %String;

/// 既往门诊治疗情况("SMDOPTreatment")
Property SROPTreatmentDr As DHCMed.SS.Dictionary;

/// 既往住院治疗情况
Property SRIPTreatTimes As %String;

/// 首次抗精神药物治疗时间
Property SRFirstDrugTreatDate As %Date;

/// 住院诊断
Property SRDischDiagnos As %String;

/// 住院疗效/转归情况("SMDPrognosis")
Property SRPrognosisDr As DHCMed.SS.Dictionary;

/// 本次住院是否获得经费补助（"SMDIsFunding"）
Property SRIsFunding As DHCMed.SS.Dictionary;

/// 	是否服药("SMDISDRUG"/SMDKJSYW)	update:2020-7-24
Property SRIsDrug As %Boolean;

/// 出院康复	是否服药("SMDISDRUG"/SMDKJSYW) update:2020-7-24
Property RPIsDrug As %Boolean;

/// 补助类型（"SMDFundsType"）
Property SRFundsType As DHCMed.SS.Dictionary;

/// 经费来源("SMDFundsSource")
Property SRFundsSourceDr As DHCMed.SS.Dictionary;

/// 经济来源其他
Property SRFundsSourceTxt As %String;

/// 住院用药/目前用药
Property SRTreatPharmacy As list Of DHCMed.SMD.ReportPh;

/// 本次住院康复措施("SMDRehabMeasure")
Property SRTreatMeasureDr As list Of DHCMed.SS.Dictionary;

/// 本次住院康复措施其他
Property SRTreatMeasureTxt As %String;

/// 康复用药
Property SRRehabPharmacy As list Of DHCMed.SMD.ReportPh;

/// 康复措施("SMDRehabMeasure")
Property SRRehabMeasureDr As list Of DHCMed.SS.Dictionary;

/// 康复措施备注
Property SRRehabMeasureTxt As %String;

/// 其他注意事项
Property SRRehabResume As %String;

/// 报告备注
Property SRReportNote As %String;

/// 报告单位及科室
Property SRReportLoc As %String;

/// 科室联系电话
Property SRRepLocTel As %String;

/// 填卡人
Property SRReportUser As %String;

/// 填卡日期
Property SRReportDate As %Date;

/// 填卡日期
Property SRReportTime As %String;

/// 审核人/录入人
Property SRCheckUser As %String;

/// 审核日期/录入日期
Property SRCheckDate As %String;

/// 审核时间/录入时间
Property SRCheckTime As %String;

/// 与患者关系
Property SRPatRelationDr As DHCMed.SS.Dictionary;

/// 国籍
Property SRPatNationDr As DHCMed.SS.Dictionary;

/// 证件类型
Property SRCertTypeDr As DHCMed.SS.Dictionary;

/// 民族
Property SRNationalDr As DHCMed.SS.Dictionary;

/// 户别
Property SRHuBieDr As DHCMed.SS.Dictionary;

/// 文化程度
Property SRDegreeDr As DHCMed.SS.Dictionary;

/// 婚姻状况
Property SRWedLockDr As DHCMed.SS.Dictionary;

/// 两系三代严重精神疾病("SMDZFamily")
Property SRHouseHoldDr As DHCMed.SS.Dictionary;

/// 是否已进行抗精神药物治疗(SMDKJSYW)
Property SRIsDrugTreatment As %Boolean;

/// 既往关锁情况
Property SRLockStatusDr As DHCMed.SS.Dictionary;

/// 既往危险性评估
Property SRAssessmentDr As DHCMed.SS.Dictionary;

/// 知情同意
Property SRAgree As %String;

/// 知情同意时间
Property SRAgreeDate As %Date;

/// 既往危险行为
Property SRBehaviors As %String;

/// 联系电话（副）
Property SRTelephone2 As %String;

/// 报告日期索引
Index IndexReportDate On SRReportDate;

/// 患者ID索引
Index IndexPatientID On SRPatientID;

/// 报卡类型 + 患者ID索引
Index IndexRepTypePatID On (SRRepTypeDr, SRPatientID);

/// Creator：     zhufei
/// CreatDate：   2015-02-27
/// Description:  根据ID取报告信息
/// Table：       DHCMed.SMD.Report
/// Input：       ID:    DHCMed.SMD.Report.ID
/// Return：      返回obj
/// w ##class(DHCMed.SMD.Report).GetObjById(1)
ClassMethod GetObjById(id As %String) As DHCMed.SMD.Report
{
	new (id)
	set return=""
	quit:id="" return
	quit:'##class(DHCMed.SMD.Report).%ExistsId(+id) return
	set obj=##Class(DHCMed.SMD.Report).%OpenId(+id)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-27
/// Description:  根据报告类型和病人ID取发病报卡
/// Table：       DHCMed.SMD.Report
/// Input：       RepTypeCode ：报告类型
///               PatientID : 病人ID
/// Return：      返回Object
/// w ##class(DHCMed.SMD.Report).GetObjByRepType("1",104)
ClassMethod GetObjByRepType(aRepTypeCode As %String, aPatientID As %String) As DHCMed.SMD.Report
{
	New (aRepTypeCode,aPatientID)
	Set return=""
	Quit:(aRepTypeCode="")||(aPatientID="") return
	
	Set RepTypeCode=""
	If ((aRepTypeCode="1")||(aRepTypeCode="2")) {
		Set RepTypeCode=1
	} Else {
		Set RepTypeCode=3
	}
	Set objRepTp=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDRepType",RepTypeCode,"1")
	Quit:'$IsObject(objRepTp) return
	Set RepTpID=objRepTp.%Id()
	
	Set xID=""
	For {
		Set xID=$o(^DHCMed.SMD.ReportI("IndexRepTypePatID",RepTpID," "_aPatientID,xID),-1)
		Quit:xID=""
		Quit:return'=""
		
		Set objReport=..GetObjById(xID)
		Continue:'$IsObject(objReport)
		Set return=objReport
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-27
/// Description:  更新报告内容
/// Table：       DHCMed.SMD.Report
/// Input：       InputStr : 报告内容
///               MentalSymptom : 精神症状
///               TreatPharmacy : 住院用药
///               RehabPharmacy : 康复用药
///               Separate : 分隔符
/// Return：      返回String
/// w ##class(DHCMed.SMDService.ReportSrv).GetReportString("","1","189")
ClassMethod Update(aInputStr As %String, aMentalSymptom As %String, aTreatPharmacy As %String, aRehabPharmacy As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aMentalSymptom,aTreatPharmacy,aRehabPharmacy,aSeparate)
	Set return=0
	
	Set ID=$p(aInputStr,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.SMD.Report).%New()
	} Else {
		Set obj=##class(DHCMed.SMD.Report).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.SRRepTypeDr     = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,2))
	Set obj.SRAdmTypeDr     = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,3))
	if obj.SRRepTypeDr.Description="严重精神障碍患者出院信息单"{
		Set SRAdmTypeDr=$o(^DHCMed.SS.DictionaryI("IndexTypeDesc"," SMDADMTYPE"," 住院",0))
		Set obj.SRAdmTypeDr = ##class(DHCMed.SS.Dictionary).GetObjById(SRAdmTypeDr)
	}
	Set obj.SRPatTypeDr     = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,4))
	Set obj.SREpisodeID     = $p(aInputStr,aSeparate,5)
	Set obj.SRPatientID     = $p(aInputStr,aSeparate,6)
	Set obj.SRLocalDr       = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,7))
	Set obj.SRDiseaseDr     = ##class(DHCMed.SS.Disease).GetObjById($p(aInputStr,aSeparate,8))
	Set obj.SRDiseaseText   = $p(aInputStr,aSeparate,9)
	Set obj.SRStatusDr      = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,10))
	
	//卡片编号自动生成 update by zf 20150215
	Set CardNo=$p(aInputStr,aSeparate,11)
	If CardNo="" {
		Set EpisodeID=$p(aInputStr,aSeparate,5)
		Set AdmLocID=$p($g(^PAADM(+EpisodeID)),"^",4)
		Set HospitalID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLocID)
		Set CardNo=..GetNewCardNo(HospitalID)
	}
	Set obj.SRCardNo	    = CardNo
	
	Set obj.SRWholenessDr   = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,12))
	Set obj.SRPatientObj    = ##class(DHCMed.SMD.ReportPat).GetObj($p(aInputStr,aSeparate,13),$c(2))
	Set obj.SRContactor     = $p(aInputStr,aSeparate,14)
	Set obj.SRContactorTel  = $p(aInputStr,aSeparate,15)
	Set obj.SRRegAddress    = $p(aInputStr,aSeparate,16)
	Set obj.SRRegAddrTypeDr = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,17))
	Set obj.SRRegProvince   = $p(aInputStr,aSeparate,18)
	Set obj.SRRegCity       = $p(aInputStr,aSeparate,19)
	Set obj.SRRegCounty     = $p(aInputStr,aSeparate,20)
	Set obj.SRRegVillage    = $p(aInputStr,aSeparate,21)
	Set obj.SRRegRoad       = $p(aInputStr,aSeparate,22)
	Set obj.SRCurrAddress	= $p(aInputStr,aSeparate,23)
	Set obj.SRCurrAddrTypeDr= ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,24))
	Set obj.SRCurrProvince  = $p(aInputStr,aSeparate,25)
	Set obj.SRCurrCity		= $p(aInputStr,aSeparate,26)
	Set obj.SRCurrCounty	= $p(aInputStr,aSeparate,27)
	Set obj.SRCurrVillage	= $p(aInputStr,aSeparate,28)
	Set obj.SRCurrRoad		= $p(aInputStr,aSeparate,29)
	Set obj.SROccupationDr	= ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,30))
	Set obj.SRCompany		= $p(aInputStr,aSeparate,31)
	Set obj.SRCompanyTel    = $p(aInputStr,aSeparate,32)
	;Set:$p(aInputStr,aSeparate,33)'="" $p(aInputStr,aSeparate,33)=$zdh($p(aInputStr,aSeparate,33),3)
	Set:$p(aInputStr,aSeparate,33)'="" $p(aInputStr,aSeparate,33)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInputStr,aSeparate,33))
	Set obj.SRSickDate		= $p(aInputStr,aSeparate,33)	//发病时间
	
	//送检主体
	Do obj.SRReferralDr.Clear()
	Set tmp=$p(aInputStr,aSeparate,34)
	For i=1:1:$l(tmp,","){
		Set tmpID=$p(tmp,",",i)
		Continue:tmpID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Do obj.SRReferralDr.Insert(objDic)
	}
	Set obj.SRReferralTxt	= $p(aInputStr,aSeparate,35)
	
	Set obj.SRDiagHospital	= $p(aInputStr,aSeparate,36)
	;Set:$p(aInputStr,aSeparate,37)'="" $p(aInputStr,aSeparate,37)=$zdh($p(aInputStr,aSeparate,37),3)
	Set:$p(aInputStr,aSeparate,37)'="" $p(aInputStr,aSeparate,37)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInputStr,aSeparate,37))
	Set obj.SRDiagDate		= $p(aInputStr,aSeparate,37)	//确诊时间
	If (ID="") {	//修改报卡内容时，不更改初始填报科室和人员
		Set obj.SRReportLoc		= $p(aInputStr,aSeparate,38)	//填报科室
		Set obj.SRReportUser	= $p(aInputStr,aSeparate,39)	//填报人
	}
	Set obj.SRRepLocTel		= $p(aInputStr,aSeparate,40)
	Set obj.SRReportDate	= +$h
	Set obj.SRReportTime	= $p($h,",",2)
	Set obj.SRReportNote    = $p(aInputStr,aSeparate,43)
	// 本次入院原因
	Set obj.SRAdmitReasonDr = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,44))
	
	/// 出院信息单信息
	/// 患者对家庭社会的影响
	Set obj.SRSocietyImpact 	= $p(aInputStr,aSeparate,45)
	Set obj.SRSocietyImpactTxt  = $p(aInputStr,aSeparate,46)
	Set obj.SROPTreatmentDr		= ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,47))
	;Set:$p(aInputStr,aSeparate,48)'="" $p(aInputStr,aSeparate,48)=$zdh($p(aInputStr,aSeparate,48),3)
	Set:$p(aInputStr,aSeparate,48)'="" $p(aInputStr,aSeparate,48)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInputStr,aSeparate,48))
	Set obj.SRFirstDrugTreatDate= $p(aInputStr,aSeparate,48)	//首次抗精神药物治疗时间
	Set obj.SRIPTreatTimes 		= $p(aInputStr,aSeparate,49)
	Set obj.SRDischDiagnos 	 	= $p(aInputStr,aSeparate,50)
	Set obj.SRPrognosisDr 		= ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,51))
	
	//主要医疗付款方式 add by zf 2015-02-15
	Set obj.SRPaymentDr 	    = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,61))
	
	/// 本次住院康复措施
	Do obj.SRTreatMeasureDr.Clear()
	Set tmp = $p(aInputStr,aSeparate,52)
	For i=1:1:$l(tmp,","){
		Set tmpID=$p(tmp,",",i)
		Continue:tmpID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Do obj.SRTreatMeasureDr.Insert(objDic)
	}
	Set obj.SRTreatMeasureTxt = $p(aInputStr,aSeparate,53)
	//康复措施
	Do obj.SRRehabMeasureDr.Clear()
	Set tmp = $p(aInputStr,aSeparate,54)
	For i=1:1:$l(tmp,","){
		Set tmpID=$p(tmp,",",i)
		Continue:tmpID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(tmpID)
		Continue:'$IsObject(objDic)
		Do obj.SRRehabMeasureDr.Insert(objDic)
	}
	Set obj.SRRehabMeasureTxt   = $p(aInputStr,aSeparate,55)
	Set obj.SRRehabResume		= $p(aInputStr,aSeparate,56)
	/// 经费补助
	Set obj.SRIsFunding 	    = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,57))
	Set obj.SRFundsType			= ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,58))
	Set obj.SRFundsSourceDr 	= ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,59))
	Set obj.SRFundsSourceTxt	= $p(aInputStr,aSeparate,60)
	/// 精神症状
	Do obj.SRSymptomDr.Clear()
	For i=1:1:$l(aMentalSymptom,"#"){
		Set tmpID=$p(aMentalSymptom,"#",i)
		Continue:tmpID=""
		Set objMs=##class(DHCMed.SMD.Symptom).GetObjById(tmpID)
		Continue:'$IsObject(objMs)
		Do obj.SRSymptomDr.Insert(objMs)
	}
	/// 住院用药
	While (obj.SRTreatPharmacy.Count()>0) {
		Do obj.SRTreatPharmacy.RemoveAt(1)
	}
	
	For i=1:1:$l(aTreatPharmacy,$c(1)) {
		Set tmp=$p(aTreatPharmacy,$c(1),i)
		Continue:tmp=""
		Set objData=##class(DHCMed.SMD.ReportPh).GetObj(tmp,"^")
		Continue:'$IsObject(objData)
		Do obj.SRTreatPharmacy.Insert(objData)
	}
	/// 康复用药
	While (obj.SRRehabPharmacy.Count()>0) {
		Do obj.SRRehabPharmacy.RemoveAt(1)
	}
	
	For i=1:1:$l(aRehabPharmacy,$c(1)) {
		Set tmp=$p(aRehabPharmacy,$c(1),i)
		Continue:tmp=""
		Set objData=##class(DHCMed.SMD.ReportPh).GetObj(tmp,"^")
		Continue:'$IsObject(objData)
		Do obj.SRRehabPharmacy.Insert(objData)
	}	
	
	Set obj.SRPatRelationDr    = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,62)) //与患者关系
	Set obj.SRPatNationDr      = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,63)) //国籍
	Set obj.SRCertTypeDr       = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,64)) //证件类型
	Set obj.SRNationalDr       = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,65)) //民族
	Set obj.SRHuBieDr          = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,66)) //户别
	Set obj.SRDegreeDr         = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,67)) //文化程度
	Set obj.SRWedLockDr        = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,68)) //婚姻状况
	Set obj.SRHouseHoldDr      = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,69)) //两系三代严重精神障碍家族史
	
	Set obj.SRIsDrugTreatment  = $p(aInputStr,aSeparate,70)                                           //是否已进行抗精神病药物治疗
	Set obj.SRLockStatusDr     = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,71)) //既往关锁情况
	Set obj.SRAssessmentDr     = ##class(DHCMed.SS.Dictionary).GetObjById($p(aInputStr,aSeparate,72)) //既往危险性评估
	Set obj.SRAgree            = $p(aInputStr,aSeparate,73)  										  //知情同意
	Set:$p(aInputStr,aSeparate,74)'="" $p(aInputStr,aSeparate,74)=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical($p(aInputStr,aSeparate,74))
	Set obj.SRAgreeDate       = $p(aInputStr,aSeparate,74)                                            //知情同意时间
	Set obj.SRBehaviors       = $p(aInputStr,aSeparate,75)   
	Set obj.SRTelephone2      = $p(aInputStr,aSeparate,76)  
	//是否服药update:2020-7-24
	Set obj.SRIsDrug      	  = $p(aInputStr,aSeparate,77)
	Set obj.RPIsDrug      	  = $p(aInputStr,aSeparate,78)
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-27
/// Description:  审核报告
/// Table：       DHCMed.SMD.Report
/// Input：       ReportID : 报告ID
///               StatusID : 状态代码
///               ResumeText : 附加说明
///               UserID : 审核操作用户
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod CheckReport(ReportID As %String, StatusCode As %String, ResumeText As %String, UserID As %String) As %String
{
	New (ReportID,StatusCode,UserID,ResumeText)
	Set return=-1
	Quit:(ReportID="")||(StatusCode="") return
	
	Set return=-2
	Set objStatus=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDRepStatus",StatusCode,"1")
	Quit:'$IsObject(objStatus) return
	
	Set return=-3
	Set obj=##class(DHCMed.SMD.Report).GetObjById(ReportID)
	Quit:'$IsObject(obj) return
	Set (CheckUser,CheckDate,CheckTime)=""
	If StatusCode="2" {
		Set CheckUser=UserID
		Set CheckDate=+$h
		Set CheckTime=$p($h,",",2)
	}
	
	Set obj.SRStatusDr=objStatus
	Set obj.SRCheckUser=CheckUser
	Set obj.SRCheckDate=CheckDate
	Set obj.SRCheckTime=CheckTime
	//fix bug 113977 审核、退回的备注覆盖报告的备注
	Set:ResumeText'="" obj.SRReportNote=obj.SRReportNote_"  "_"退回原因："_ResumeText
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		//Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		;Set return=obj.%Id()
		Set return=1
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-27
/// Description:  删除报告内容
/// Table：       DHCMed.SMD.Report
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.SMD.Report).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

ClassMethod GetReportPatObjById(aId As %String) As DHCMed.SMD.ReportPat
{
	New (aId)
	Set ret=""
	Set obj=##Class(DHCMed.SMD.Report).%OpenId(aId)
	Set:$IsObject(obj) ret=obj.SRPatientObj
	Do:obj'="" obj.%Close()
	Quit ret
}

/// 取值送诊主体
ClassMethod GetSRReferralDr(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	For ind=1:1:obj.SRReferralDr.Count() {
		Set objDic=obj.SRReferralDr.GetAt(ind)
		Set:return'="" return=return_"#"
		Set return=return_objDic.%Id()_"^"_objDic.Code_"^"_objDic.Description
	}
	
	Quit return
}

/// 取值住院康复措施
ClassMethod GetSRTreatMeasureDr(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	For ind=1:1:obj.SRTreatMeasureDr.Count() {
		Set objDic=obj.SRTreatMeasureDr.GetAt(ind)
		Set:return'="" return=return_"#"
		Set return=return_objDic.%Id()_"^"_objDic.Code_"^"_objDic.Description
	}
	
	Quit return
}

/// 取值既往危险行为
ClassMethod GetBehaviors(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	Set Behaviors=obj.SRBehaviors

	//测试模块:校对旧数据 2019-12
	if ($LISTVALID(Behaviors)=1){
		Set Behaviors=$LISTTOSTRING(Behaviors)
		Set Behaviors=$REPLACE(Behaviors,$c(6,1),"")
	}
	For ind=1:1:$l(Behaviors,",") {
		Set xId=$p(Behaviors,",",ind)
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xId)
		Continue:'$IsObject(objDic)
		Set:return'="" return=return_"#"
		Set return=return_objDic.%Id()_"^"_objDic.Code_"^"_objDic.Description
	}
	Quit return
}

/// 取值康复措施
ClassMethod GetSRRehabMeasureDr(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	For ind=1:1:obj.SRRehabMeasureDr.Count() {
		Set objDic=obj.SRRehabMeasureDr.GetAt(ind)
		Set:return'="" return=return_"#"
		Set return=return_objDic.%Id()_"^"_objDic.Code_"^"_objDic.Description
	}
	
	Quit return
}

/// 取值精神症状
ClassMethod GetSRSymptomDr(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	For ind=1:1:obj.SRSymptomDr.Count() {
		Set objSym=obj.SRSymptomDr.GetAt(ind)
		Set:return'="" return=return_"#"
		Set return=return_objSym.%Id()_"^"_objSym.MSCode_"^"_objSym.MSDesc
	}
	
	Quit return
}

/// *取值住院用药/康复用药 by DHCMed.SMD.ReportPh
ClassMethod GetDrugFromPh(objPh As DHCMed.SMD.ReportPh) As %String
{
	New (objPh)
	Set return=""
	Quit:'$IsObject(objPh) return
		
	If $IsObject(objPh) {
		Set DrugSpec = objPh.RPDrugSpec  
		If $IsObject(objPh.RPDrugDr) {
			Set DrugID=objPh.RPDrugDr.%Id()
			Set DrugName=objPh.RPDrugDr.PDDesc
			Set:DrugSpec="" DrugSpec=$p(objPh.RPDrugDr.PDSpec,"mg",1)
		} Else {
			Set DrugID=""
			Set DrugName=objPh.RPDrugName
		}
		Set Instruc=objPh.RPInstruc
		Set InstrucDesc=""
		If $IsObject(objPh.RPInstrucDr) {
			Set InstrucID=objPh.RPInstrucDr.%Id()
			Set InstrucDesc=objPh.RPInstrucDr.Description
			//新旧数据调整 266001->周 266002->月
			if (InstrucDesc["次/"){
				Set InstrucID=""
				Set InstrucCode="266001"
				Set Instruc=$p(InstrucDesc,"次/",1)
					
				if (InstrucDesc["日"){
					Set Instruc=Instruc*7
				}elseif(InstrucDesc["周"){
				}elseif(InstrucDesc["月"){	
					Set InstrucCode="266002"
				}else{
					Set Instruc=0
				}
				Set InstrucObj=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDPCDW","InstrucCode","1")
				Set:$IsObject(InstrucObj) InstrucID=InstrucObj.%Id()
				Set:$IsObject(InstrucObj) InstrucDesc=InstrucObj.Description
			}
		} Else {
			Set InstrucID=""
		}
		If $IsObject(objPh.RPDoseUnitDr) {
			Set DoseUnitID=objPh.RPDoseUnitDr.%Id()
			Set DoseUnit=objPh.RPDoseUnitDr.Description
		} Else {
			Set DoseUnitID=""
			Set DoseUnit=objPh.RPDoseUnit
		}
		
		Set return=return_"^"_DrugName
		Set return=return_"^"_Instruc      			     		//频次
		Set return=return_"^"_objPh.RPDoseQty     				//剂量
		Set return=return_"^"_DoseUnit
		Set return=return_"^"_DrugID
		Set return=return_"^"_InstrucID
		Set return=return_"^"_DoseUnitID
		
		Set return=return_"^"_objPh.RPIsLongTerm    //是否长效药
		Set return=return_"^"_DrugSpec	    		//规格
		Set return=return_"^"_objPh.RPUsageMorn    	//用法：早
		Set return=return_"^"_objPh.RPUsageNoon    	//用法：中
		Set return=return_"^"_objPh.RPUsageEven    	//用法：晚
		Set return=return_"^"_InstrucDesc           //频次单位
		
	} Else {
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
		Set return=return_"^"_""
	}
	
	Quit return
}

/// *取值康复用药
ClassMethod GetSRRehabPharmacy(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	For ind=1:1:obj.SRRehabPharmacy.Count() {
		Set objDrug=obj.SRRehabPharmacy.GetAt(ind)
		Set:return'="" return=return_"#"
		Set return=return_..GetDrugFromPh(objDrug)
		
	}
	
	Quit return
}

/// *取值住院用药
ClassMethod GetSRTreatPharmacy(obj As DHCMed.SMD.Report) As %String
{
	New (obj)
	Set return=""
	Quit:'$IsObject(obj) return
	
	For ind=1:1:obj.SRTreatPharmacy.Count() {
		Set objDrug=obj.SRTreatPharmacy.GetAt(ind)
		Set:return'="" return=return_"#"
		Set return=return_..GetDrugFromPh(objDrug)
	
	}
	
	Quit return
}

/// Creator     : zhufei
/// CreateDate  : 2015-02-15
/// Description : 获取新的卡片编号
/// Input       : aHospitalID 医院ID
/// Output      : 新的卡片编号
/// w ##class(DHCMed.SMD.Report).GetNewCardNo(2)
ClassMethod GetNewCardNo(aHospitalID As %String, aSMDHospCode As %String = "") As %String
{
	new (aHospitalID,aSMDHospCode)
	set return=""
	quit:aHospitalID="" return
	
	if aSMDHospCode="" {
		set SMDHospCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SMD-HospInsCode",aHospitalID)
		quit:SMDHospCode="" return
	} else {
		set SMDHospCode=aSMDHospCode
	}
	quit:SMDHospCode="" return
	
	Set CurrDate=$zd(+$h,3)
	Set CurrDate=$tr(CurrDate,"-","")
	Set CurrDate=$e(CurrDate,3,$l(CurrDate))
	Set num=$i(^DHCMed.SMD.CardNoC(CurrDate))
	If $l(num)<5 {
		Set $p(return,"0",5-$l(num))=num
	} Else {
		Set return=num
	}
	
	Set return=SMDHospCode_CurrDate_return  //医疗机构代码+年月日（150101）+四位顺序号
	Quit return
}

/// Creator     : pylian
/// CreatDate   : 2020-04-27
/// Description : 处理2019年06月21日修改报告日期字段属性后历史报告查询不到数据问题
/// Table       : DHCMed.SMD.Report
/// Input       : ""
/// w ##class(DHCMed.SMD.Report).SyncReportDate()
ClassMethod SyncReportDate() As %String
{
	Set return=""
    Set Count=0
    
    Set DateFrom=$zdh("2000-01-01",3)  //设置一个起始日期
    
    For xDate=DateFrom:1:+$h {
		Set xID=""
		For {
			Set xID=$o(^DHCMed.SMD.ReportI("IndexReportDate"," "_xDate,xID))
			Quit:xID=""
		   	Set objRep=##class(DHCMed.SMD.Report).GetObjById(xID)
		    Continue:'$IsObject(objRep)
				
		    Set ReportDate =objRep.SRReportDate
		  	  
			Set obj=##class(DHCMed.SMD.Report).GetObjById(xID)
			Set obj.SRReportDate = ReportDate
			
			Set sc=obj.%Save()
			If $System.Status.IsError(sc) {  
		   		Do $System.OBJ.DisplayError(sc)
		   		Set return=-1
			} Else {
				Set return=obj.%Id()
				Set Count=Count+1
				w "处理报告ID:",xID,!
			}
			Do obj.%Close()
		}
    }
    
    d ##class(DHCMed.SMD.Report).%BuildIndices()
    
    Set return=Count
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SREpisodeID</Value>
</Value>
<Value name="3">
<Value>SRPatientID</Value>
</Value>
<Value name="4">
<Value>SRRepTypeDr</Value>
</Value>
<Value name="5">
<Value>SRAdmTypeDr</Value>
</Value>
<Value name="6">
<Value>SRPatTypeDr</Value>
</Value>
<Value name="7">
<Value>SRLocalDr</Value>
</Value>
<Value name="8">
<Value>SRDiseaseDr</Value>
</Value>
<Value name="9">
<Value>SRDiseaseText</Value>
</Value>
<Value name="10">
<Value>SRStatusDr</Value>
</Value>
<Value name="11">
<Value>SRCardNo</Value>
</Value>
<Value name="12">
<Value>SRWholenessDr</Value>
</Value>
<Value name="13">
<Value>SRPatientObj</Value>
</Value>
<Value name="14">
<Value>SRContactor</Value>
</Value>
<Value name="15">
<Value>SRContactorTel</Value>
</Value>
<Value name="16">
<Value>SRHomeTel</Value>
</Value>
<Value name="17">
<Value>SRRegAddrTypeDr</Value>
</Value>
<Value name="18">
<Value>SRRegAddress</Value>
</Value>
<Value name="19">
<Value>SRRegProvince</Value>
</Value>
<Value name="20">
<Value>SRRegCity</Value>
</Value>
<Value name="21">
<Value>SRRegCounty</Value>
</Value>
<Value name="22">
<Value>SRRegVillage</Value>
</Value>
<Value name="23">
<Value>SRRegRoad</Value>
</Value>
<Value name="24">
<Value>SRCurrAddrTypeDr</Value>
</Value>
<Value name="25">
<Value>SRCurrAddress</Value>
</Value>
<Value name="26">
<Value>SRCurrProvince</Value>
</Value>
<Value name="27">
<Value>SRCurrCity</Value>
</Value>
<Value name="28">
<Value>SRCurrCounty</Value>
</Value>
<Value name="29">
<Value>SRCurrVillage</Value>
</Value>
<Value name="30">
<Value>SRCurrRoad</Value>
</Value>
<Value name="31">
<Value>SROccupationDr</Value>
</Value>
<Value name="32">
<Value>SRCompany</Value>
</Value>
<Value name="33">
<Value>SRCompanyTel</Value>
</Value>
<Value name="34">
<Value>SRSickDate</Value>
</Value>
<Value name="35">
<Value>SRReferralDr</Value>
</Value>
<Value name="36">
<Value>SRReferralTxt</Value>
</Value>
<Value name="37">
<Value>SRDiagHospital</Value>
</Value>
<Value name="38">
<Value>SRDiagDate</Value>
</Value>
<Value name="39">
<Value>SRAdmitReasonDr</Value>
</Value>
<Value name="40">
<Value>SRSymptomDr</Value>
</Value>
<Value name="41">
<Value>SRSocietyImpact</Value>
</Value>
<Value name="42">
<Value>SRSocietyImpactTxt</Value>
</Value>
<Value name="43">
<Value>SROPTreatmentDr</Value>
</Value>
<Value name="44">
<Value>SRIPTreatTimes</Value>
</Value>
<Value name="45">
<Value>SRFirstDrugTreatDate</Value>
</Value>
<Value name="46">
<Value>SRDischDiagnos</Value>
</Value>
<Value name="47">
<Value>SRPrognosisDr</Value>
</Value>
<Value name="48">
<Value>SRIsFunding</Value>
</Value>
<Value name="49">
<Value>SRFundsType</Value>
</Value>
<Value name="50">
<Value>SRFundsSourceDr</Value>
</Value>
<Value name="51">
<Value>SRFundsSourceTxt</Value>
</Value>
<Value name="52">
<Value>SRTreatPharmacy</Value>
</Value>
<Value name="53">
<Value>SRTreatMeasureDr</Value>
</Value>
<Value name="54">
<Value>SRTreatMeasureTxt</Value>
</Value>
<Value name="55">
<Value>SRRehabPharmacy</Value>
</Value>
<Value name="56">
<Value>SRRehabMeasureDr</Value>
</Value>
<Value name="57">
<Value>SRRehabMeasureTxt</Value>
</Value>
<Value name="58">
<Value>SRRehabResume</Value>
</Value>
<Value name="59">
<Value>SRReportNote</Value>
</Value>
<Value name="60">
<Value>SRReportLoc</Value>
</Value>
<Value name="61">
<Value>SRRepLocTel</Value>
</Value>
<Value name="62">
<Value>SRReportUser</Value>
</Value>
<Value name="63">
<Value>SRReportDate</Value>
</Value>
<Value name="64">
<Value>SRReportTime</Value>
</Value>
<Value name="65">
<Value>SRCheckUser</Value>
</Value>
<Value name="66">
<Value>SRCheckDate</Value>
</Value>
<Value name="67">
<Value>SRCheckTime</Value>
</Value>
<Value name="68">
<Value>SRPaymentDr</Value>
</Value>
<Value name="69">
<Value>SRPatRelationDr</Value>
</Value>
<Value name="70">
<Value>SRPatNationDr</Value>
</Value>
<Value name="71">
<Value>SRCertTypeDr</Value>
</Value>
<Value name="72">
<Value>SRNationalDr</Value>
</Value>
<Value name="73">
<Value>SRHuBieDr</Value>
</Value>
<Value name="74">
<Value>SRDegreeDr</Value>
</Value>
<Value name="75">
<Value>SRWedLockDr</Value>
</Value>
<Value name="76">
<Value>SRHouseHoldDr</Value>
</Value>
<Value name="77">
<Value>SRIsDrugTreatment</Value>
</Value>
<Value name="78">
<Value>SRLockStatusDr</Value>
</Value>
<Value name="79">
<Value>SRAssessmentDr</Value>
</Value>
<Value name="80">
<Value>SRAgree</Value>
</Value>
<Value name="81">
<Value>SRAgreeDate</Value>
</Value>
<Value name="82">
<Value>SRBehaviors</Value>
</Value>
<Value name="83">
<Value>SRTelephone2</Value>
</Value>
<Value name="84">
<Value>SRIsDrug</Value>
</Value>
<Value name="85">
<Value>RPIsDrug</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SMD.ReportD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.SMD.ReportD</IdLocation>
<IndexLocation>^DHCMed.SMD.ReportI</IndexLocation>
<StreamLocation>^DHCMed.SMD.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

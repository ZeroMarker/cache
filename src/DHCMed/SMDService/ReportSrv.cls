/// 名称: DHCMed.SMDService.ReportSrv
/// 描述: 精神疾病报告相关内容
/// 编写者：李阳
/// 编写日期: 2014-12-15
Class DHCMed.SMDService.ReportSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-08
/// Description:  取报告内容
/// Table：       DHCMed.SMD.Report
/// Input：       ReportID : 报告ID
///               EpisodeID : 就诊号
/// Return：      返回String
/// w ##class(DHCMed.SMDService.ReportSrv).GetReportString("","1","189")
ClassMethod GetReportString(aReportID As %String, aRepTypeCode As %String, aEpisodeID As %String) As %String
{
	New (aReportID,aRepTypeCode,aEpisodeID,%session)
	Set return=""
	Quit:(aReportID="")&&(aEpisodeID="") return
	
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	
	Set PatientID = $p($g(^PAADM(+aEpisodeID)),"^",1)
	
	If aReportID'="" {
		Set objRep=##class(DHCMed.SMD.Report).GetObjById(aReportID)
		Quit:'$IsObject(objRep) return
		
		Set $p(return,$c(1),1)=objRep.%Id()
		Set $p(return,$c(1),2)=objRep.SREpisodeID
		Set $p(return,$c(1),3)=objRep.SRPatientID
		Set $p(return,$c(1),4)=..GetDicString(objRep.SRRepTypeDr)
		Set $p(return,$c(1),5)=..GetDicString(objRep.SRAdmTypeDr)
		Set $p(return,$c(1),6)=..GetDicString(objRep.SRPatTypeDr)
		Set $p(return,$c(1),7)=..GetDicString(objRep.SRLocalDr)
		Set $p(return,$c(1),8)=..GetICDString(objRep.SRDiseaseDr)
		Set $p(return,$c(1),9)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc",Languages,objRep.SRDiseaseText)
		Set $p(return,$c(1),10)=..GetDicString(objRep.SRStatusDr)
		Set $p(return,$c(1),11)=objRep.SRCardNo
		Set $p(return,$c(1),12)=..GetDicString(objRep.SRWholenessDr)
		Set $p(return,$c(1),13)=##class(DHCMed.SMD.ReportPat).GetPatStr(aReportID,objRep.SREpisodeID)
		Set $p(return,$c(1),14)=objRep.SRContactor
		Set $p(return,$c(1),15)=objRep.SRContactorTel
		Set $p(return,$c(1),16)=objRep.SRHomeTel
		Set $p(return,$c(1),17)=..GetDicString(objRep.SRRegAddrTypeDr)
		Set $p(return,$c(1),18)=objRep.SRRegAddress
		Set $p(return,$c(1),19)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,objRep.SRRegProvince)	
		Set $p(return,$c(1),20)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,objRep.SRRegCity)
		Set $p(return,$c(1),21)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,objRep.SRRegCounty)
		Set $p(return,$c(1),22)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,objRep.SRRegVillage)
		Set $p(return,$c(1),23)=objRep.SRRegRoad
		Set $p(return,$c(1),24)=..GetDicString(objRep.SRCurrAddrTypeDr)
		Set $p(return,$c(1),25)=objRep.SRCurrAddress
		Set $p(return,$c(1),26)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,objRep.SRCurrProvince)	
		Set $p(return,$c(1),27)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,objRep.SRCurrCity)
		Set $p(return,$c(1),28)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,objRep.SRCurrCounty)
		Set $p(return,$c(1),29)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,objRep.SRCurrVillage)
		Set $p(return,$c(1),30)=objRep.SRCurrRoad
		Set $p(return,$c(1),31)=..GetDicString(objRep.SROccupationDr)
		Set $p(return,$c(1),32)=objRep.SRCompany
		Set $p(return,$c(1),33)=objRep.SRCompanyTel
		Set $p(return,$c(1),34)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRSickDate)
		Set $p(return,$c(1),35)=##class(DHCMed.SMD.Report).GetSRReferralDr(objRep)    //objRep.SRReferralDr
		Set $p(return,$c(1),36)=objRep.SRReferralTxt
		Set $p(return,$c(1),37)=objRep.SRDiagHospital
		Set $p(return,$c(1),38)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRDiagDate)
		Set $p(return,$c(1),39)=..GetDicString(objRep.SRAdmitReasonDr)
		Set $p(return,$c(1),40)=##class(DHCMed.SMD.Report).GetSRSymptomDr(objRep)	//objRep.SRSymptomDr
		Set $p(return,$c(1),41)=objRep.SRSocietyImpact
		Set $p(return,$c(1),42)=objRep.SRSocietyImpactTxt
		Set $p(return,$c(1),43)=..GetDicString(objRep.SROPTreatmentDr)
		Set $p(return,$c(1),44)=objRep.SRIPTreatTimes
		Set $p(return,$c(1),45)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRFirstDrugTreatDate)
		Set $p(return,$c(1),46)=..GetICDString(##class(DHCMed.SS.Disease).GetObjById(objRep.SRDischDiagnos))	//objRep.SRDischDiagnos
		Set $p(return,$c(1),47)=..GetDicString(objRep.SRPrognosisDr)
		Set $p(return,$c(1),48)=..GetDicString(objRep.SRIsFunding)
		Set $p(return,$c(1),49)=..GetDicString(objRep.SRFundsType)
		Set $p(return,$c(1),50)=..GetDicString(objRep.SRFundsSourceDr)
		Set $p(return,$c(1),51)=objRep.SRFundsSourceTxt
		Set $p(return,$c(1),52)=##class(DHCMed.SMD.Report).GetSRTreatPharmacy(objRep) //objRep.SRTreatPharmacy
		Set $p(return,$c(1),53)=##class(DHCMed.SMD.Report).GetSRTreatMeasureDr(objRep)	//objRep.SRTreatMeasureDr
		Set $p(return,$c(1),54)=objRep.SRTreatMeasureTxt
		Set $p(return,$c(1),55)=##class(DHCMed.SMD.Report).GetSRRehabPharmacy(objRep)	//objRep.SRRehabPharmacy
		Set $p(return,$c(1),56)=##class(DHCMed.SMD.Report).GetSRRehabMeasureDr(objRep)	//objRep.SRRehabMeasureDr
		Set $p(return,$c(1),57)=objRep.SRRehabMeasureTxt
		Set $p(return,$c(1),58)=objRep.SRRehabResume
		Set $p(return,$c(1),59)=objRep.SRReportNote
		Set ReportLoc = $p($g(^CTLOC(objRep.SRReportLoc)),"^",2)
		Set:ReportLoc["-" ReportLoc=$p(ReportLoc,"-",2)
		Set ReportLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,ReportLoc)
		Set $p(return,$c(1),60)=ReportLoc
	
		Set $p(return,$c(1),61)=objRep.SRRepLocTel
		Set RepUserName =..GetUserString(+objRep.SRReportUser)
		Set RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,RepUserName)	
		Set $p(return,$c(1),62)=RepUserName
		Set $p(return,$c(1),63)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRReportDate)
		Set $p(return,$c(1),64)=$zt(+objRep.SRReportTime,1)
		Set $p(return,$c(1),65)=..GetUserString(+objRep.SRCheckUser)
		If objRep.SRCheckDate'=""{
			Set $p(return,$c(1),66)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRCheckDate)
			Set $p(return,$c(1),67)=$zt(+objRep.SRCheckTime,1)
		}Else{
			Set $p(return,$c(1),66)=""
			Set $p(return,$c(1),67)=""
		}
		//主要医疗付款方式 update by zf 20150215
		Set $p(return,$c(1),68) = ..GetDicString(objRep.SRPaymentDr)
		Set $p(return,$c(1),69) = ..GetDicString(objRep.SRPatRelationDr)
		Set $p(return,$c(1),70) = ..GetDicString(objRep.SRPatNationDr)   //国籍
		Set $p(return,$c(1),71) = ..GetDicString(objRep.SRCertTypeDr)   //证件类型
		Set $p(return,$c(1),72) = ..GetDicString(objRep.SRNationalDr)   //民族
		Set $p(return,$c(1),73) = ..GetDicString(objRep.SRHuBieDr)   //户别
		Set $p(return,$c(1),74) = ..GetDicString(objRep.SRDegreeDr)   //文化程度
		Set $p(return,$c(1),75) = ..GetDicString(objRep.SRWedLockDr)   //婚姻状况
		Set $p(return,$c(1),76) = ..GetDicString(objRep.SRHouseHoldDr)     //两系三代严重精神障碍家族史
		Set $p(return,$c(1),77) = objRep.SRIsDrugTreatment			       //是否已进行抗精神病药物治疗
		Set $p(return,$c(1),78) = ..GetDicString(objRep.SRLockStatusDr)     //既往关锁情况
		Set $p(return,$c(1),79) = ..GetDicString(objRep.SRAssessmentDr)     //既往危险性评估
		Set objAgree=##class(DHCMed.SS.Dictionary).GetObjById(objRep.SRAgree)
		Set $p(return,$c(1),80) = ..GetDicString(objAgree)     //知情同意
		Set $p(return,$c(1),81)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRAgreeDate)  //知情同意时间
		Set $p(return,$c(1),82)=##class(DHCMed.SMD.Report).GetBehaviors(objRep)	// 既往危险行为
		Set $p(return,$c(1),83)=objRep.SRTelephone2       //联系电话（副）
		//省市县乡 地址描述 add 20200426
		Set $p(return,$c(1),84)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegProvince,1)
		Set $p(return,$c(1),85)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegCity,2)
		Set $p(return,$c(1),86)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegCounty,3)
		Set $p(return,$c(1),87)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegVillage,4)

		Set $p(return,$c(1),88)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrProvince,1)
		Set $p(return,$c(1),89)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrCity,2)
		Set $p(return,$c(1),90)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrCounty,3)
		Set $p(return,$c(1),91)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrVillage,4)
		//是否服药update:2020-7-24
		Set $p(return,$c(1),92) = objRep.SRIsDrug			       //是否服药
		Set $p(return,$c(1),93) = objRep.RPIsDrug			       //是否服药 康复
		
	}Elseif((aReportID="")&&($d(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID)))){
		Set aRepID = ..GetRepIDByPaadm(aEpisodeID)
		Set objRep=##class(DHCMed.SMD.Report).GetObjById(aRepID)
		Quit:'$IsObject(objRep) return
		
		Set $p(return,$c(1),1)=objRep.%Id()
		Set $p(return,$c(1),2)=objRep.SREpisodeID
		Set $p(return,$c(1),3)=objRep.SRPatientID
		Set $p(return,$c(1),4)=..GetDicString(objRep.SRRepTypeDr)
		Set $p(return,$c(1),5)=..GetDicString(objRep.SRAdmTypeDr)
		Set $p(return,$c(1),6)=..GetDicString(objRep.SRPatTypeDr)
		Set $p(return,$c(1),7)=..GetDicString(objRep.SRLocalDr)
		Set $p(return,$c(1),8)=..GetICDString(objRep.SRDiseaseDr)
		Set $p(return,$c(1),9)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc",Languages,objRep.SRDiseaseText)
		Set $p(return,$c(1),10)=..GetDicString(objRep.SRStatusDr)
		Set $p(return,$c(1),11)=objRep.SRCardNo
		Set $p(return,$c(1),12)=..GetDicString(objRep.SRWholenessDr)
		Set $p(return,$c(1),13)=##class(DHCMed.SMD.ReportPat).GetPatStr(aRepID,objRep.SREpisodeID)
		Set $p(return,$c(1),14)=objRep.SRContactor
		Set $p(return,$c(1),15)=objRep.SRContactorTel
		Set $p(return,$c(1),16)=objRep.SRHomeTel
		Set $p(return,$c(1),17)=..GetDicString(objRep.SRRegAddrTypeDr)
		Set $p(return,$c(1),18)=objRep.SRRegAddress
		Set $p(return,$c(1),19)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,objRep.SRRegProvince)	
		Set $p(return,$c(1),20)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,objRep.SRRegCity)
		Set $p(return,$c(1),21)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,objRep.SRRegCounty)
		Set $p(return,$c(1),22)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,objRep.SRRegVillage)
		Set $p(return,$c(1),23)=objRep.SRRegRoad
		Set $p(return,$c(1),24)=..GetDicString(objRep.SRCurrAddrTypeDr)
		Set $p(return,$c(1),25)=objRep.SRCurrAddress
		Set $p(return,$c(1),26)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTProvince","PROVDesc",Languages,objRep.SRCurrProvince)	
		Set $p(return,$c(1),27)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCity","CTCITDesc",Languages,objRep.SRCurrCity)
		Set $p(return,$c(1),28)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCityArea","CITAREADesc",Languages,objRep.SRCurrCounty)
		Set $p(return,$c(1),29)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLocalityType","LOCTYPEDesc",Languages,objRep.SRCurrVillage)
		Set $p(return,$c(1),30)=objRep.SRCurrRoad
		Set $p(return,$c(1),31)=..GetDicString(objRep.SROccupationDr)
		Set $p(return,$c(1),32)=objRep.SRCompany
		Set $p(return,$c(1),33)=objRep.SRCompanyTel
		Set $p(return,$c(1),34)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRSickDate)
		Set $p(return,$c(1),35)=##class(DHCMed.SMD.Report).GetSRReferralDr(objRep)    //objRep.SRReferralDr
		Set $p(return,$c(1),36)=objRep.SRReferralTxt
		Set $p(return,$c(1),37)=objRep.SRDiagHospital
		Set $p(return,$c(1),38)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRDiagDate)
		Set $p(return,$c(1),39)=..GetDicString(objRep.SRAdmitReasonDr)
		Set $p(return,$c(1),40)=##class(DHCMed.SMD.Report).GetSRSymptomDr(objRep)	//objRep.SRSymptomDr
		Set $p(return,$c(1),41)=objRep.SRSocietyImpact
		Set $p(return,$c(1),42)=objRep.SRSocietyImpactTxt
		Set $p(return,$c(1),43)=..GetDicString(objRep.SROPTreatmentDr)
		Set $p(return,$c(1),44)=objRep.SRIPTreatTimes
		Set $p(return,$c(1),45)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRFirstDrugTreatDate)
		Set $p(return,$c(1),46)=..GetICDString(##class(DHCMed.SS.Disease).GetObjById(objRep.SRDischDiagnos))	//objRep.SRDischDiagnos
		Set $p(return,$c(1),47)=..GetDicString(objRep.SRPrognosisDr)
		Set $p(return,$c(1),48)=..GetDicString(objRep.SRIsFunding)
		Set $p(return,$c(1),49)=..GetDicString(objRep.SRFundsType)
		Set $p(return,$c(1),50)=..GetDicString(objRep.SRFundsSourceDr)
		Set $p(return,$c(1),51)=objRep.SRFundsSourceTxt
		Set $p(return,$c(1),52)=##class(DHCMed.SMD.Report).GetSRTreatPharmacy(objRep) //objRep.SRTreatPharmacy
		Set $p(return,$c(1),53)=##class(DHCMed.SMD.Report).GetSRTreatMeasureDr(objRep)	//objRep.SRTreatMeasureDr
		Set $p(return,$c(1),54)=objRep.SRTreatMeasureTxt
		Set $p(return,$c(1),55)=##class(DHCMed.SMD.Report).GetSRRehabPharmacy(objRep)	//objRep.SRRehabPharmacy
		Set $p(return,$c(1),56)=##class(DHCMed.SMD.Report).GetSRRehabMeasureDr(objRep)	//objRep.SRRehabMeasureDr
		Set $p(return,$c(1),57)=objRep.SRRehabMeasureTxt
		Set $p(return,$c(1),58)=objRep.SRRehabResume
		Set $p(return,$c(1),59)=objRep.SRReportNote
		Set ReportLoc = $p($g(^CTLOC(objRep.SRReportLoc)),"^",2)
		Set:ReportLoc["-" ReportLoc=$p(ReportLoc,"-",2)
		Set ReportLoc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,ReportLoc)
		Set $p(return,$c(1),60)=ReportLoc
	
		Set $p(return,$c(1),61)=objRep.SRRepLocTel
		Set RepUserName =..GetUserString(+objRep.SRReportUser)
		Set RepUserName = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,RepUserName)	
		Set $p(return,$c(1),62)=RepUserName
		Set $p(return,$c(1),63)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRReportDate)
		Set $p(return,$c(1),64)=$zt(+objRep.SRReportTime,1)
		Set $p(return,$c(1),65)=..GetUserString(+objRep.SRCheckUser)
		If objRep.SRCheckDate'=""{
			Set $p(return,$c(1),66)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRCheckDate)
			Set $p(return,$c(1),67)=$zt(+objRep.SRCheckTime,1)
		}Else{
			Set $p(return,$c(1),66)=""
			Set $p(return,$c(1),67)=""
		}
		//主要医疗付款方式 update by zf 20150215
		Set $p(return,$c(1),68) = ..GetDicString(objRep.SRPaymentDr)
		Set $p(return,$c(1),69) = ..GetDicString(objRep.SRPatRelationDr)
		Set $p(return,$c(1),70) = ..GetDicString(objRep.SRPatNationDr)   //国籍
		Set $p(return,$c(1),71) = ..GetDicString(objRep.SRCertTypeDr)   //证件类型
		Set $p(return,$c(1),72) = ..GetDicString(objRep.SRNationalDr)   //民族
		Set $p(return,$c(1),73) = ..GetDicString(objRep.SRHuBieDr)   //户别
		Set $p(return,$c(1),74) = ..GetDicString(objRep.SRDegreeDr)   //文化程度
		Set $p(return,$c(1),75) = ..GetDicString(objRep.SRWedLockDr)   //婚姻状况
		Set $p(return,$c(1),76) = ..GetDicString(objRep.SRHouseHoldDr)     //两系三代严重精神障碍家族史
		Set $p(return,$c(1),77) = objRep.SRIsDrugTreatment			       //是否已进行抗精神病药物治疗
		Set $p(return,$c(1),78) = ..GetDicString(objRep.SRLockStatusDr)     //既往关锁情况
		Set $p(return,$c(1),79) = ..GetDicString(objRep.SRAssessmentDr)     //既往危险性评估
		Set objAgree=##class(DHCMed.SS.Dictionary).GetObjById(objRep.SRAgree)
		Set $p(return,$c(1),80) = ..GetDicString(objAgree)     //知情同意
		Set $p(return,$c(1),81)=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(objRep.SRAgreeDate)  //知情同意时间
		Set $p(return,$c(1),82)=##class(DHCMed.SMD.Report).GetBehaviors(objRep)	// 既往危险行为
		Set $p(return,$c(1),83)=objRep.SRTelephone2       //联系电话（副）
		//省市县乡 地址描述 add 20200426
		Set $p(return,$c(1),84)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegProvince,1)
		Set $p(return,$c(1),85)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegCity,2)
		Set $p(return,$c(1),86)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegCounty,3)
		Set $p(return,$c(1),87)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRRegVillage,4)

		Set $p(return,$c(1),88)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrProvince,1)
		Set $p(return,$c(1),89)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrCity,2)
		Set $p(return,$c(1),90)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrCounty,3)
		Set $p(return,$c(1),91)=##class(DHCMed.SS.AreaDic).GetShordDescById(objRep.SRCurrVillage,4)
		//是否服药update:2020-7-24
		Set $p(return,$c(1),92) = objRep.SRIsDrug			       //是否服药
		Set $p(return,$c(1),93) = objRep.RPIsDrug			       //是否服药 康复
		
	}Else {
		Set PatientID = $p($g(^PAADM(+aEpisodeID)),"^",1)
		Set $p(return,$c(1),1)=""
		Set $p(return,$c(1),2)=aEpisodeID
		Set $p(return,$c(1),3)=PatientID
		Set AdmType=$p($g(^PAADM(+aEpisodeID)),"^",2)
		If (AdmType="I"){
			Set AdmTypeCode=2
		}Else{
			Set AdmTypeCode=1
		}
		Set objDicAdmType=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDADMTYPE",AdmTypeCode,1)
		Set:$IsObject(objDicAdmType) $p(return,$c(1),5)=..GetDicString(objDicAdmType)
		Set $p(return,$c(1),13)=##class(DHCMed.SMD.ReportPat).GetPatStr("",aEpisodeID)
		//联系人、联系人电话、工作单位
		Set $p(return,$c(1),14)=$p($g(^PAPER(PatientID,"PER",2)),"^",13)
		Set $p(return,$c(1),15)=$p($g(^PAPER(PatientID,"ALL")),"^",4)
		Set $p(return,$c(1),32)=$p($g(^PAPER(PatientID,"PER",4)),"^",18)
		
		//update by zf 20150514 先屏蔽掉新建报卡自动取住院用药程序
		//##class(DHCMed.SMDService.OrdItemSrv).GetDrugOrderItem(aEpisodeID)
		Set $p(return,$c(1),52)="" //住院用药
		Set $p(return,$c(1),67)=""
		
		//主要医疗付款方式 update by zf 20150215
		Set $p(return,$c(1),68)=""
		Set $p(return,$c(1),69)=""
		Set $p(return,$c(1),70)=""
		Set PatIDType=""
		Set PersonalIDTypeID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
		Set PersonalIDType = $p($g(^PAC("CARD",+PersonalIDTypeID)),"^",2)
		Set:PersonalIDType["身份证" PatIDType="身份证"
		Set:PersonalIDType["护照" PatIDType="护照"
		Set:PersonalIDType["港澳居民来往内地通行证" PatIDType="港澳台居民居住证"
		Set:PersonalIDType["台湾居民来往内地通行证" PatIDType="港澳台居民居住证"
		Set:PersonalIDType["户口簿" PatIDType="户口簿"
		Set objPer=##class(DHCMed.SSService.DictionarySrv).GetObjByTypeDesc("SMDZJLX",PatIDType)
		If $IsObject(objPer) {
			Set $p(return,$c(1),71)=objPer.%Id()_$c(2)_objPer.Code_$c(2)_objPer.Description
		}Else {
			Set $p(return,$c(1),71)=""
		}
		Set $p(return,$c(1),72)=""
		Set $p(return,$c(1),73)=""
		Set $p(return,$c(1),74)=""
		Set $p(return,$c(1),75)=""
		Set $p(return,$c(1),76)=""
		Set $p(return,$c(1),77)=""
		Set $p(return,$c(1),78)=""
		Set $p(return,$c(1),79)=""
		Set $p(return,$c(1),80)=""
		Set $p(return,$c(1),81)=""
		Set $p(return,$c(1),82)=""
		Set $p(return,$c(1),83)=""
		
		Set $p(return,$c(1),92)=""		//是否服药
		
		//门诊老病人再次就诊，取患者最后一次报卡基本信息作为默认值
		Set HistoryInfo=""
		Set AdmType=$p($g(^PAADM(+aEpisodeID)),"^",2)
		If AdmType="O" {
			Set HistoryInfo=..GetHistoryInfo(aRepTypeCode,aEpisodeID)
			If HistoryInfo'="" {
				Set $p(return,$c(1),14)=$p(HistoryInfo,"^",1)
				Set $p(return,$c(1),15)=$p(HistoryInfo,"^",2)
				Set $p(return,$c(1),18)=$p(HistoryInfo,"^",3)
				Set $p(return,$c(1),19)=$p(HistoryInfo,"^",4)
				Set $p(return,$c(1),20)=$p(HistoryInfo,"^",5)
				Set $p(return,$c(1),21)=$p(HistoryInfo,"^",6)
				Set $p(return,$c(1),22)=$p(HistoryInfo,"^",7)
				Set $p(return,$c(1),23)=$p(HistoryInfo,"^",8)
				Set $p(return,$c(1),25)=$p(HistoryInfo,"^",9)
				Set $p(return,$c(1),26)=$p(HistoryInfo,"^",10)
				Set $p(return,$c(1),27)=$p(HistoryInfo,"^",11)
				Set $p(return,$c(1),28)=$p(HistoryInfo,"^",12)
				Set $p(return,$c(1),29)=$p(HistoryInfo,"^",13)
				Set $p(return,$c(1),30)=$p(HistoryInfo,"^",14)
				Set $p(return,$c(1),7) =$p(HistoryInfo,"^",15)
				Set $p(return,$c(1),31)=$p(HistoryInfo,"^",16)
				Set $p(return,$c(1),32)=$p(HistoryInfo,"^",17)
				Set $p(return,$c(1),33)=$p(HistoryInfo,"^",18)
				Set $p(return,$c(1),34)=$p(HistoryInfo,"^",19)
				Set $p(return,$c(1),37)=$p(HistoryInfo,"^",20)
				Set $p(return,$c(1),38)=$p(HistoryInfo,"^",21)
				//省市县乡 地址描述 add 20200426
				Set $p(return,$c(1),84)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",4),1)
				Set $p(return,$c(1),85)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",5),2)
				Set $p(return,$c(1),86)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",6),3)
				Set $p(return,$c(1),87)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",7),4)

				Set $p(return,$c(1),88)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",10),1)
				Set $p(return,$c(1),89)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",11),2)
				Set $p(return,$c(1),90)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",12),3)
				Set $p(return,$c(1),91)=##class(DHCMed.SS.AreaDic).GetShordDescById($p(HistoryInfo,"^",13),4)		

			}
		}
	}
	
	Quit return
}

/// Creator		: chenrui
/// CreateDate	: 2021-05-25
/// Descrption	: 根据就诊号取患者最后一次报卡基本信息
/// Input		: RepTypeCode,EpisodeID
/// OutPut		: 返回String
/// w ##class(DHCMed.SMDService.ReportSrv).GetRepIDByPaadm(524)
ClassMethod GetRepIDByPaadm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set ReportID=$o(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID,""),-1)
	Quit:ReportID="" return
	Set return = ReportID
	Quit return
}

/// Creator		: zhufei
/// CreateDate	: 2015-01-15
/// Descrption	: 根据就诊号取患者最后一次报卡基本信息
/// Input		: RepTypeCode,EpisodeID
/// OutPut		: 返回String
/// w ##class(DHCMed.SMDService.ReportSrv).GetHistoryInfo("3",33)
ClassMethod GetHistoryInfo(aRepTypeCode As %String, aEpisodeID As %String) As %String
{
	New (aRepTypeCode,aEpisodeID)
	Set return=""
	Quit:((aRepTypeCode="")||(aEpisodeID="")) return
	
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set objRepTp=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDREPTYPE",aRepTypeCode,"")
	Quit:'$IsObject(objRepTp) return
	Set RepTpID=objRepTp.%Id()
	
	Set ReportID=$o(^DHCMed.SMD.ReportI("IndexRepTypePatID",RepTpID," "_PatientID,""),-1)
	Quit:ReportID="" return
	
	Set objRep=##class(DHCMed.SMD.Report).GetObjById(ReportID)
	Quit:'$IsObject(objRep) return
	Set $p(return,"^",1)	= objRep.SRContactor
	Set $p(return,"^",2)	= objRep.SRContactorTel
	Set $p(return,"^",3) 	= objRep.SRRegAddress
	Set $p(return,"^",4) 	= objRep.SRRegProvince
	Set $p(return,"^",5) 	= objRep.SRRegCity
	Set $p(return,"^",6) 	= objRep.SRRegCounty
	Set $p(return,"^",7) 	= objRep.SRRegVillage
	Set $p(return,"^",8) 	= objRep.SRRegRoad
	Set $p(return,"^",9) 	= objRep.SRCurrAddress
	Set $p(return,"^",10) 	= objRep.SRCurrProvince
	Set $p(return,"^",11) 	= objRep.SRCurrCity
	Set $p(return,"^",12) 	= objRep.SRCurrCounty
	Set $p(return,"^",13) 	= objRep.SRCurrVillage
	Set $p(return,"^",14) 	= objRep.SRCurrRoad
	Set $p(return,"^",15)	= ..GetDicString(objRep.SRLocalDr)
	Set $p(return,"^",16)	= ..GetDicString(objRep.SROccupationDr)
	Set $p(return,"^",17)	= objRep.SRCompany
	Set $p(return,"^",18)	= objRep.SRCompanyTel
	
	Set SickDate=objRep.SRSickDate
	;Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)
	Set $p(return,"^",19)	= SickDate
	
	Set $p(return,"^",20) 	= objRep.SRDiagHospital
	
	Set DiagDate=objRep.SRDiagDate
	;Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set:DiagDate'="" DiagDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DiagDate)
	Set $p(return,"^",21) 	= DiagDate
	
	Quit return
}

ClassMethod GetDicString(obj) As %String
{
	New (obj,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:'$IsObject(obj) return
	Set $p(return,$c(2),1)=obj.%Id()
	Set $p(return,$c(2),2)=obj.Code
	Set $p(return,$c(2),3)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.Description)
	Quit return
}

ClassMethod GetICDString(obj) As %String
{
	New (obj,%session)
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	Set return=""
	Quit:'$IsObject(obj) return
	Set $p(return,$c(2),1)=obj.%Id()
	Set $p(return,$c(2),2)=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,obj.IDDesc)
	Set $p(return,$c(2),3)=obj.IDICD10
	Quit return
}

ClassMethod GetUserString(aUserID) As %String
{
	New (aUserID)
	Set return=""
	Quit:aUserID="" return=""
	Set UserName = $p(^SSU("SSUSR",aUserID),"^",2)
	Set return = UserName
	Quit return
}

ClassMethod GetAdmType(aEpisodeID) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return=""
	
	Set AdmType=$p($g(^PAADM(+aEpisodeID)),"^",2)
	If (AdmType="I"){
		Set AdmTypeCode=2
	}Else{
		Set AdmTypeCode=1
	}
	Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("SMDADMTYPE",AdmTypeCode,1)
	Quit:'$IsObject(objDic) return
	
	Set return=..GetDicString(objDic)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-15
/// Description:  查询报告记录
/// Table：       DHCMed.SMD.Report
/// Input：       
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.SMDService.ReportSrv","QryReportByDate","","2015-01-06","2015-01-12","","","")
Query QryReportByDate(aRepType As %String, aDateFrom As %String, aDateTo As %String, aHospID As %String, aRepLoc As %String, aStatusList As %String, aAdmTypeList As %String, aPatName As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,PatientID:%String,RepTypeID:%String,RepTypeDesc:%String,StatusID:%String,StatusDesc:%String,CardNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,PatTypeID:%String,PatTypeDesc:%String,DiseaseID:%String,DiseaseICD:%String,DiseaseDesc:%String,DisCatID:%String,DisCatDesc:%String,Contactor:%String,ContactorTel:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,CheckUserID:%String,CheckUserDesc:%String,CheckDate:%String,CheckTime:%String,EncryptLevel:%String,PatLevel:%String,SickDate:%String")
{
}

ClassMethod QryReportByDateExecute(ByRef qHandle As %Binary, aRepType As %String, aDateFrom As %String, aDateTo As %String, aHospID As %String, aRepLoc As %String, aStatusList As %String, aAdmTypeList As %String, aPatName As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aRepType,aDateFrom,aDateTo,aRepLoc,aStatusList)
	
	Set:aStatusList'="" aStatusList=","_aStatusList_","
	Set:aAdmTypeList'="" aAdmTypeList=","_aAdmTypeList_","
	
	;Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	;Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	For xDate=aDateFrom:1:aDateTo {
		Set xID=""
		For {
			Set xID=$o(^DHCMed.SMD.ReportI("IndexReportDate",xDate,xID))
			Quit:xID=""
			
			Set objRep=##class(DHCMed.SMD.Report).GetObjById(xID)
			Continue:'$IsObject(objRep)
			Continue:'$IsObject(objRep.SRRepTypeDr)
			;Continue:'$IsObject(objRep.SRAdmTypeDr)
			
			Set RepType=objRep.SRRepTypeDr.%Id()
			Continue:(aRepType'="")&&(aRepType'=RepType) //报告类型
			Set RepLoc=objRep.SRReportLoc
			if aHospID'="" {
				set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(RepLoc,aHospID)
				continue:flg<1
			}
			Continue:(aRepLoc'="")&&(aRepLoc'=RepLoc) //报告科室
			Set RepStatus=objRep.SRStatusDr.%Id()
			Continue:(aStatusList'="")&&(aStatusList'[(","_RepStatus_",")) //报告状态
			If aAdmTypeList'="" {
				Continue:'$IsObject(objRep.SRAdmTypeDr)
				Set AdmType=objRep.SRAdmTypeDr.%Id()
				Continue:aAdmTypeList'[(","_AdmType_",") //报卡类型
			}
			Set objPat=objRep.SRPatientObj 
			Continue:'$IsObject(objPat)
			Set PatName=objPat.RPPatName
			Continue:(aPatName'="")&&(PatName'[aPatName)	//患者姓名过滤
			
			Set Data=..BuildData(objRep)
			Continue:Data=""
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

ClassMethod BuildData(objRep As DHCMed.SMD.Report) As %List
{
	New (objRep,%session)
	Set return=""
	Quit:'$IsObject(objRep) return
	
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	
	Set ReportID=objRep.%Id()
	Set EpisodeID=objRep.SREpisodeID
	Quit:EpisodeID="" return
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	Quit:PatientID="" return
	Set CardNo=objRep.SRCardNo
	Set CardNo=$e(CardNo,10,$l(CardNo))
	
	Set PapmiNo=$p(^PAPER(PatientID,"PAT",1),"^",1)
	Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
	Set Sex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
	Set:Sex'="" Sex=$p($g(^CT("SEX",+Sex)),"^",2)
	Set Birthday=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	//update by zf 20150228 统一调用年龄计算方法
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set Age=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
	;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	Set PersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	Set PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	If ($l(PAPMIDVAnumber)>10) {
		Set PersonalID=PAPMIDVAnumber
	}
	
	Set objPat=##class(DHCMed.SMD.ReportPat).GetPatObj(ReportID,EpisodeID)
	If $IsObject(objPat) {
		Set PatName=objPat.RPPatName          //姓名
		Set Sex=objPat.RPSex                  //性别
		Set Birthday=objPat.RPBirthday        //出生日期
		Set PersonalID=objPat.RPPersonalID    //身份证号
	}
	Set:Birthday'="" Birthday=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	
	Set (PatTypeID,PatTypeDesc)=""
	If $IsObject(objRep.SRPatTypeDr){
		Set PatTypeID=objRep.SRPatTypeDr.%Id()
		Set PatTypeDesc=objRep.SRPatTypeDr.Description
	}
	Set (RepTypeID,RepTypeDesc)=""
	If $IsObject(objRep.SRRepTypeDr){
		Set RepTypeID=objRep.SRRepTypeDr.%Id()
		Set RepTypeDesc=objRep.SRRepTypeDr.Description
		Set RepTypeDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,RepTypeDesc)
	}
	Set (StatusID,StatusDesc)=""
	If $IsObject(objRep.SRStatusDr){
		Set StatusID=objRep.SRStatusDr.%Id()
		Set StatusDesc=objRep.SRStatusDr.Description
		Set StatusDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,StatusDesc)
	}
	Set (DiseaseID,DiseaseICD,DiseaseDesc,DisCatID,DisCatDesc)=""
	If $IsObject(objRep.SRDiseaseDr){
		Set DiseaseID=objRep.SRDiseaseDr.%Id()
		Set DiseaseICD=objRep.SRDiseaseDr.IDICD10
		Set DiseaseDesc=objRep.SRDiseaseDr.IDDesc
		Set:DiseaseDesc'="" DiseaseDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc",Languages,DiseaseDesc)
		If $IsObject(objRep.SRDiseaseDr.IDCateDr){
			Set DisCatID=objRep.SRDiseaseDr.IDCateDr.%Id()
			Set DisCatDesc=objRep.SRDiseaseDr.IDCateDr.Description
		}
	}
	Set Contactor=objRep.SRContactor
	Set ContactorTel=objRep.SRContactorTel
	
	Set RepLocID=objRep.SRReportLoc
	Set RepLocDesc=""
	Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(RepLocID)
	If $IsObject(objLoc){
		Set RepLocDesc=objLoc.Descs
		Set RepLocDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,RepLocDesc)
	}
	Set RepUserID=objRep.SRReportUser
	Set RepUserDesc=""
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
	If $IsObject(objUser){
		Set RepUserDesc=objUser.Name
		Set RepUserDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,RepUserDesc)	
	}
	Set RepDate=objRep.SRReportDate
	;Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set:RepDate'="" RepDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(RepDate)
	Set RepTime=objRep.SRReportTime
	Set:RepTime'="" RepTime=$zt(RepTime,1)
	
	Set (CheckUserID,CheckUserDesc,CheckDate,CheckTime)=""
	If StatusDesc="审核" {
		Set CheckUserID=objRep.SRCheckUser
		Set CheckUserDesc=""
		Set objUser=##class(DHCMed.Base.SSUser).GetObjById(CheckUserID)
		If $IsObject(objUser){
			Set CheckUserDesc=objUser.Name
			Set CheckUserDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTCareProv","CTPCPDesc",Languages,CheckUserDesc)	
		}
		Set CheckDate=objRep.SRCheckDate
		Set:CheckDate'="" CheckDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(CheckDate)
		Set CheckTime=objRep.SRCheckTime
		Set:CheckTime'="" CheckTime=$zt(CheckTime,1)
	}
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set SickDate=objRep.SRSickDate
	Set:SickDate'="" SickDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(SickDate)

	Set Data=$lb(ReportID,EpisodeID,PatientID,RepTypeID,RepTypeDesc,StatusID,StatusDesc,CardNo)
	Set Data=Data_$lb(PapmiNo,PatName,Sex,Birthday,Age,PersonalID)
	Set Data=Data_$lb(PatTypeID,PatTypeDesc)
	Set Data=Data_$lb(DiseaseID,DiseaseICD,DiseaseDesc,DisCatID,DisCatDesc)
	Set Data=Data_$lb(Contactor,ContactorTel)
	Set Data=Data_$lb(RepLocID,RepLocDesc,RepUserID,RepUserDesc,RepDate,RepTime)
	Set Data=Data_$lb(CheckUserID,CheckUserDesc,CheckDate,CheckTime,EncryptLevel,PatLevel,SickDate)
	Quit Data
}

/// Creator：     zhufei
/// CreatDate：   2015-02-26
/// Description:  通过PatientID查询报告记录
/// Table：       DHCMed.SMD.Report
/// Input：       EpisodeID : 就诊号
/// Return：      返回ROWSPEC...
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.SMDService.ReportSrv","QryReportByAdm",189)
Query QryReportByAdm(aEpisodeID As %String) As %Query(ROWSPEC = "RowID:%String,EpisodeID:%String,PatientID:%String,RepTypeID:%String,RepTypeDesc:%String,StatusID:%String,StatusDesc:%String,CardNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,PatTypeID:%String,PatTypeDesc:%String,DiseaseID:%String,DiseaseICD:%String,DiseaseDesc:%String,DisCatID:%String,DisCatDesc:%String,Contactor:%String,ContactorTel:%String,RepLocID:%String,RepLocDesc:%String,RepUserID:%String,RepUserDesc:%String,RepDate:%String,RepTime:%String,CheckUserID:%String,CheckUserDesc:%String,CheckDate:%String,CheckTime:%String,EncryptLevel:%String,PatLevel:%String,SickDate:%String")
{
}

ClassMethod QryReportByAdmExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" $$$OK
	Set AdmType=$p($g(^PAADM(+aEpisodeID)),"^",2)
	
	Set xReportID=0
	For {
		Set xReportID=$o(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID,xReportID))
		Quit:xReportID=""
		
		Set objRep=##class(DHCMed.SMD.Report).GetObjById(xReportID)
		Continue:'$IsObject(objRep)
		Set EpisodeID=objRep.SREpisodeID
		Continue:aEpisodeID'=EpisodeID	//过滤当次就诊不显示之前的报卡
		Continue:'$IsObject(objRep.SRStatusDr)
		//Continue:objRep.SRStatusDr.Code=4  //删除的报告不显示
		Continue:'$IsObject(objRep.SRRepTypeDr)
		Set RepTpCode=objRep.SRRepTypeDr.Code
		If AdmType="I" {
			;Continue:(RepTpCode'=3)&&(RepTpCode'=4)
		} Else {
			Continue:RepTpCode'=1
		}
		
		Set Data=..BuildData(objRep)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryReportByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByAdmExecute ]
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

/// w ##Class(DHCMed.SMDService.ReportSrv).PrintSMDReport("fillxlSheet",1)
ClassMethod PrintSMDReport(itmjs As %String, aReportID As %String) As %String
{
	new (itmjs,aReportID)
	set return=0
	quit:aReportID="" return
	
	set objReport=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	quit:'$IsObject(objReport) return
	set EpisodeID=objReport.SREpisodeID
	quit:EpisodeID="" return
	
	Set PatList = ##class(DHCMed.SMD.ReportPat).GetPatStr(aReportID,objReport.SREpisodeID)
	Set AdmType = objReport.SRAdmTypeDr.Code
	
	If AdmType = 2
	{
		Set Row=2
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCardNo,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set Row = 3
		Set PatType = ..GetDicList("SMDPatType",$p(..GetDicString(objReport.SRPatTypeDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatType,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set IsComplete = ..GetDicList("SMDIsComplete",$p(..GetDicString(objReport.SRWholenessDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsComplete,"O","JS")_"',"_Row_",28);"
		&javascript<#(retval)#>
	
		Set AdmType = ..GetDicList("SMDAdmType",$p(..GetDicString(objReport.SRAdmTypeDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmType,"O","JS")_"',"_Row_",45);"
		&javascript<#(retval)#>
	
		Set Row = 4
		Set AdmitReason = ..GetDicList("SMDAdmitReason",$p(..GetDicString(objReport.SRAdmitReasonDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmitReason,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 5
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),1),"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),2),"O","JS")_"',"_Row_",20);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),4),"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set Birthday = $p(PatList,$C(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_Row_",45);"
		&javascript<#(retval)#>
	
		Set Row = 6
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactor,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactorTel,"O","JS")_"',"_Row_",29);"
		&javascript<#(retval)#>
	
		Set Row = 7
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCompany,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCompanyTel,"O","JS")_"',"_Row_",29);"
		&javascript<#(retval)#>
	
		Set Row = 8
		Set Local = ..GetDicList("SMDLocal",$p(..GetDicString(objReport.SRLocalDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Local,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 9
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRegAddress,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 10
		Set RegAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRRegAddrTypeDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddrType,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 11
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCurrAddress,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 12
		Set CurrAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRCurrAddrTypeDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(CurrAddrType,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 13
		Set Occupation = ..GetDicList("SMDOccupation",$p(..GetDicString(objReport.SROccupationDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Occupation,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 14
		Set SickDate = objReport.SRSickDate
		Set:SickDate'="" SickDate = $zd(SickDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(SickDate,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
	
		Set Row = 15
		Set Referral = ##class(DHCMed.SMD.Report).GetSRReferralDr(objReport)
		Set Referrals = ""
		For i=1:1:$l(Referral,"#"){
			;Set strReferral = $g(Referral,i)
			Set strReferral = $p(Referral,"#",i)	//修改打印时，送检主体不正确问题
			Set ReferralInfo = ..GetDescById($p(strReferral,"^",1))
			Set Referrals = Referrals_","_ReferralInfo
		}
		Set Referrals = $e(Referrals,2,$l(Referrals)+1)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Referrals,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReferralTxt,"O","JS")_"',"_Row_",44);"
		&javascript<#(retval)#>
	
		Set Row = 16
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRDiagHospital,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set DiagDate = objReport.SRDiagDate
		Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DiagDate,"O","JS")_"',"_Row_",36);"
		&javascript<#(retval)#>
	
		Set Row = 17
		Set Disease = ..GetICDString(objReport.SRDiseaseDr)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),2),"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),3),"O","JS")_"',"_Row_",36);"
		&javascript<#(retval)#>
	
		Set Row = 18
		Set RepLocDesc = $p($g(^CTLOC(objReport.SRReportLoc)),"^",2)
		Set:RepLocDesc["-" RepLocDesc=$p(RepLocDesc,"-",2)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepLocDesc,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRepLocTel,"O","JS")_"',"_Row_",36);"
		&javascript<#(retval)#>
	
		Set Row = 19
		Set RepUserName = $p($g(^SSU("SSUSR",objReport.SRReportUser)),"^",2)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepUserName,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		Set RepDate = objReport.SRReportDate
		Set:RepDate'="" RepDate=$zd(RepDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_Row_",22);"
		&javascript<#(retval)#>
	
		If objReport.SRCheckUser'=""{
			Set CheckUserName = $p($g(^SSU("SSUSR",objReport.SRCheckUser)),"^",2)
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(CheckUserName,"O","JS")_"',"_Row_",34);"
			&javascript<#(retval)#>
			Set CheckDate = objReport.SRCheckDate
			Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(CheckDate,"O","JS")_"',"_Row_",45);"
			&javascript<#(retval)#>
		}Else{
			Set retval=itmjs_"(xlSheet,'"_$ZCVT("","O","JS")_"',"_Row_",34);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT("","O","JS")_"',"_Row_",45);"
			&javascript<#(retval)#>
		}
	
		Set Row = 20
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReportNote,"O","JS")_"',"_Row_",11);"
		&javascript<#(retval)#>
		
	}Else{
		Set Row=2
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCardNo,"O","JS")_"',"_Row_",7);"
		&javascript<#(retval)#>
	
		Set Row = 3
		Set PatType = ..GetDicList("SMDPatType",$p(..GetDicString(objReport.SRPatTypeDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatType,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set IsComplete = ..GetDicList("SMDIsComplete",$p(..GetDicString(objReport.SRWholenessDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsComplete,"O","JS")_"',"_Row_",19);"
		&javascript<#(retval)#>
	
		Set AdmType = ..GetDicList("SMDAdmType",$p(..GetDicString(objReport.SRAdmTypeDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmType,"O","JS")_"',"_Row_",30);"
		&javascript<#(retval)#>
	
		Set Row = 4
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),1),"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),2),"O","JS")_"',"_Row_",14);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),4),"O","JS")_"',"_Row_",19);"
		&javascript<#(retval)#>
		Set Birthday = $p(PatList,$C(2),3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_Row_",30);"
		&javascript<#(retval)#>
	
		Set Row = 5
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactor,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactorTel,"O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
	
		Set Row = 6
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCompany,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCompanyTel,"O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
	
		Set Row = 7
		Set Local = ..GetDicList("SMDLocal",$p(..GetDicString(objReport.SRLocalDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Local,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set Row = 8
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRegAddress,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		
		Set Row = 9
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCurrAddress,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set Row = 10
		Set Occupation = ..GetDicList("SMDOccupation",$p(..GetDicString(objReport.SROccupationDr),$c(2),3))
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Occupation,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set Row = 11
		Set SickDate = objReport.SRSickDate
		Set:SickDate'="" SickDate = $zd(SickDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(SickDate,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
	
		Set Row = 12
		Set Referral = ##class(DHCMed.SMD.Report).GetSRReferralDr(objReport)
		Set Referrals = ""
		For i=1:1:$l(Referral,"#"){
			Set strReferral = $g(Referral,i)
			Set ReferralInfo = ..GetDescById($p(strReferral,"^",1))
			Set Referrals = Referrals_","_ReferralInfo
		}
		Set Referrals = $e(Referrals,2,$l(Referrals)+1)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(Referrals,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReferralTxt,"O","JS")_"',"_Row_",28);"
		&javascript<#(retval)#>
	
		Set Row = 13
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRDiagHospital,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set DiagDate = objReport.SRDiagDate
		Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(DiagDate,"O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
	
		Set Row = 14
		Set Disease = ..GetICDString(objReport.SRDiseaseDr)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),2),"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),3),"O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
	
		Set Row = 15
		Set RepLocDesc = $p($g(^CTLOC(objReport.SRReportLoc)),"^",2)
		Set:RepLocDesc["-" RepLocDesc=$p(RepLocDesc,"-",2)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepLocDesc,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRepLocTel,"O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
	
		Set Row = 16
		Set RepUserName = $p($g(^SSU("SSUSR",objReport.SRReportUser)),"^",2)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepUserName,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		Set RepDate = objReport.SRReportDate
		Set:RepDate'="" RepDate=$zd(RepDate,3)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_Row_",15);"
		&javascript<#(retval)#>
	
		If objReport.SRCheckUser'=""{
			Set CheckUserName = $p($g(^SSU("SSUSR",objReport.SRCheckUser)),"^",2)
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(CheckUserName,"O","JS")_"',"_Row_",23);"
			&javascript<#(retval)#>
			Set CheckDate = objReport.SRCheckDate
			Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
			Set retval=itmjs_"(xlSheet,'"_$ZCVT(CheckDate,"O","JS")_"',"_Row_",30);"
			&javascript<#(retval)#>
		}Else{
			Set retval=itmjs_"(xlSheet,'"_$ZCVT("","O","JS")_"',"_Row_",23);"
			&javascript<#(retval)#>
			Set retval=itmjs_"(xlSheet,'"_$ZCVT("","O","JS")_"',"_Row_",30);"
			&javascript<#(retval)#>
		}
	
		Set Row = 17
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRReportNote,"O","JS")_"',"_Row_",8);"
		&javascript<#(retval)#>
		
	}
	Set return=1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-11-25
/// Description:  通过ReportID查询报告信息
/// Table：       DHCMed.SMD.Report
/// Input：       ReportID : 报告
/// Return：      返回ROWSPEC...
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.SMDService.ReportSrv","QryReportPrint",2)
Query QryReportPrint(aReportID As %String) As %Query(ROWSPEC = "CardNo:%String,PatName:%String,Sex:%String,TelPhone:%String,PersonalID:%String,Birthday:%String,OPNo:%String,IPNo:%String,InsurNo:%String,Contactor:%String,ContactorTel:%String,AdmitReason:%String,PatType:%String,IsComplete:%String,AdmType:%String,AdmitReason:%String,Company:%String,CompanyTel:%String,Local:%String,RegAddress:%String,RegAddrType:%String,CurrAddress:%String,CurrAddrType:%String,Occupation:%String,SickDate:%String,Referrals:%String,ReferralTxt:%String,DiagHospital:%String,DiseaseDesc:%String,DiseaseICD:%String,DiagDate:%String,RepLocDesc:%String,RepLocTel:%String,RepUserName:%String,RepDate:%String,DiagHospital:%String,CheckUserName:%String,CheckDate:%String,ReportNote:%String,IPTreatTimes:%String,FDTreatDate:%String,Relation:%String,PatNation:%String,CertType:%String,National:%String,HuBie:%String,Degree:%String,Marriage:%String,WedLock:%String,HouseHold:%String,IsDrugTreatmentDesc:%String,LockStatus:%String,Assessment:%String,BehaviorsDesc:%String,Agree:%String,AgreeDate:%String,DrugName1:%String,IsLongTermYes1:%String,IsLongTermNo1:%String,Instruc1:%String,DoseQty1:%String,DoseQtyUnit1:%String,DrugSpec1:%String,UsageMorn1:%String,UsageNoon1:%String,UsageEven1:%String,DrugName2:%String,IsLongTermYes2:%String,IsLongTermNo2:%String,Instruc2:%String,DoseQty2:%String,DoseQtyUnit2:%String,DrugSpec2:%String,UsageMorn2:%String,UsageNoon2:%String,UsageEven2:%String,IsDrugDesc:%String,IsDrug2Desc:%String") [ SqlProc ]
{
}

ClassMethod QryReportPrintExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objReport=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Set EpisodeID=objReport.SREpisodeID
	Quit:EpisodeID="" return
	Set chkY="√",chkN="□",space="   "	// √gou■hei□bai
		
	Set PatList = ##class(DHCMed.SMD.ReportPat).GetPatStr(aReportID,objReport.SREpisodeID)
	Set objAdm = ##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Set CardNo=objReport.SRCardNo
	Set PatName=$p(PatList,$C(2),1)
	Set Sex=$p(PatList,$C(2),2)	
	
	Set TelPhone=$p(PatList,$C(2),5)
	Set PersonalID=$p(PatList,$C(2),4)
	Set Birthday = $p(PatList,$C(2),3)
	Set:Birthday'="" Birthday=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	Set:Birthday["-" Birthday = $p(Birthday,"-",1)_"年"_$p(Birthday,"-",2)_"月"_$p(Birthday,"-",3)_"日"
    Set OPNo=$p(PatList,$C(2),7)	
	Set IPNo=$p(PatList,$C(2),8)
	Set InsurNo=$p(PatList,$C(2),9)
	Set AdmType=$p(PatList,$C(2),10)

	Set Contactor=objReport.SRContactor	
	Set ContactorTel=objReport.SRContactorTel
	Set AdmitReason = ..GetDicList("SMDAdmitReason",$p(..GetDicString(objReport.SRAdmitReasonDr),$c(2),3))
	Set PatType = ..GetDicList("SMDPatType",$p(..GetDicString(objReport.SRPatTypeDr),$c(2),3))
	Set IsComplete = ..GetDicList("SMDIsComplete",$p(..GetDicString(objReport.SRWholenessDr),$c(2),3))	
	Set AdmType = ..GetDicList("SMDAdmType",$p(..GetDicString(objReport.SRAdmTypeDr),$c(2),3))
	Set AdmitReason = ..GetDicList("SMDAdmitReason",$p(..GetDicString(objReport.SRAdmitReasonDr),$c(2),3))
	Set Company=objReport.SRCompany
	Set CompanyTel=objReport.SRCompanyTel
	Set Local = ..GetDicList("SMDLocal",$p(..GetDicString(objReport.SRLocalDr),$c(2),3))	
	Set RegAddress=objReport.SRRegAddress
	Set RegAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRRegAddrTypeDr),$c(2),3))	
	Set CurrAddress=objReport.SRCurrAddress
	Set CurrAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRCurrAddrTypeDr),$c(2),3))
	Set Occupation = ..GetDicList("SMDOccupation",$p(..GetDicString(objReport.SROccupationDr),$c(2),3))
	Set SickDate = objReport.SRSickDate
	Set:SickDate'="" SickDate = $zd(SickDate,3)
	Set:SickDate["-" SickDate = $p(SickDate,"-",1)_"年"_$p(SickDate,"-",2)_"月"_$p(SickDate,"-",3)_"日"

	Set Referral = ##class(DHCMed.SMD.Report).GetSRReferralDr(objReport)
	Set Referrals = ""
	For i=1:1:$l(Referral,"#"){
		Set strReferral = $p(Referral,"#",i)	//修改打印时，送检主体不正确问题
		Set ReferralInfo = ..GetDescById($p(strReferral,"^",1))
		Set Referrals = Referrals_","_ReferralInfo
	}
	Set Referrals = $e(Referrals,2,$l(Referrals)+1)

	Set ReferralTxt=objReport.SRReferralTxt
	Set DiagHospital=objReport.SRDiagHospital
	
	Set Disease = ..GetICDString(objReport.SRDiseaseDr)
	Set DiseaseDesc=$p(Disease,$c(2),2)	
	Set DiseaseICD=$p(Disease,$c(2),3)
	Set DiagDate = objReport.SRDiagDate
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set DiagDate = $p(DiagDate,"-",1)_"年"_$p(DiagDate,"-",2)_"月"_$p(DiagDate,"-",3)_"日"

	Set RepLocDesc = $p($g(^CTLOC(objReport.SRReportLoc)),"^",2)
	Set:RepLocDesc["-" RepLocDesc=$p(RepLocDesc,"-",2)
	Set RepUserName = $p($g(^SSU("SSUSR",objReport.SRReportUser)),"^",2)	
	Set RepLocTel=objReport.SRRepLocTel	
	Set RepDate = objReport.SRReportDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepDate = $p(RepDate,"-",1)_"年"_$p(RepDate,"-",2)_"月"_$p(RepDate,"-",3)_"日"

	Set DiagHospital=objReport.SRDiagHospital
	Set (CheckUserName,CheckDate)=""
	If objReport.SRCheckUser'=""{
		Set CheckUserName = $p($g(^SSU("SSUSR",objReport.SRCheckUser)),"^",2)	
		Set CheckDate = objReport.SRCheckDate
		Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set CheckDate = $p(CheckDate,"-",1)_"年"_$p(CheckDate,"-",2)_"月"_$p(CheckDate,"-",3)_"日"
	}	
	Set ReportNote=objReport.SRReportNote
    
    Set IPTreatTimes = objReport.SRIPTreatTimes
    Set FDTreatDate = objReport.SRFirstDrugTreatDate
	Set:FDTreatDate'="" FDTreatDate=$zd(FDTreatDate,3)
	Set FDTreatDate = $p(FDTreatDate,"-",1)_"年"_$p(FDTreatDate,"-",2)_"月"_$p(FDTreatDate,"-",3)_"日"

    Set Relation = ..GetDicList("SMDPatRelation",$p(..GetDicString(objReport.SRPatRelationDr),$c(2),3))  //与患者关系  
    Set PatNation = ..GetDicList("SMDNationality",$p(..GetDicString(objReport.SRPatNationDr),$c(2),3))  //国籍
    Set CertType = ..GetDicList("SMDZJLX",$p(..GetDicString(objReport.SRCertTypeDr),$c(2),3))  //证件类型
    Set National = $p(..GetDicString(objReport.SRNationalDr),$c(2),3) //民族
    Set HuBie = ..GetDicList("SMDHB",$p(..GetDicString(objReport.SRHuBieDr),$c(2),3))  //户别
    Set Degree = ..GetDicList("SMDducation",$p(..GetDicString(objReport.SRDegreeDr),$c(2),3))  //文化程度
    Set WedLock = ..GetDicList("SMDMarriage",$p(..GetDicString(objReport.SRWedLockDr),$c(2),3))  //婚姻状况
  
    Set HouseHold = ..GetDicList("SMDZFamily",$p(..GetDicString(objReport.SRHouseHoldDr),$c(2),3))   //两系三代严重精神障碍家族史
    Set IsDrugTreatment = objReport.SRIsDrugTreatment     //是否已进行抗精神病药物治疗
    Set IsDrugTreatmentDesc=$s(IsDrugTreatment=1:"是",1:"否")
    Set IsDrug = objReport.SRIsDrug    					//是否服药
    Set IsDrugDesc=$s(IsDrug=1:"是",1:"否")
    Set IsDrug2 = objReport.RPIsDrug    					//是否服药出院康复
    Set IsDrug2Desc=$s(IsDrug=1:"是",1:"否")
	Set LockStatus = ..GetDicList("SMDGS",$p(..GetDicString(objReport.SRLockStatusDr),$c(2),3))     //既往关锁情况
    Set Assessment = ..GetDicList("SMDWXPG",$p(..GetDicString(objReport.SRAssessmentDr),$c(2),3))   //既往危险性评估
    Set Behaviors = objReport.SRBehaviors   //既往危险行为
    Set BehaviorsDesc = ""
	For i=1:1:$l(Behaviors,","){
		Set Behavior = ..GetDescById($p(Behaviors,",",i))
		Set BehaviorsDesc = BehaviorsDesc_","_Behavior
	}
	Set BehaviorsDesc = $e(BehaviorsDesc,2,$l(BehaviorsDesc)+1)
   	Set Agree = ..GetDicList("SMDZQTY",..GetDescById(objReport.SRAgree))   //知情同意
	Set AgreeDate=objReport.SRAgreeDate
	Set:AgreeDate'="" AgreeDate=$zd(AgreeDate,3)
	Set AgreeDate = $p(AgreeDate,"-",1)_"年"_$p(AgreeDate,"-",2)_"月"_$p(AgreeDate,"-",3)_"日"  //知情同意时间

    Set TreatPharmacy = ##class(DHCMed.SMD.Report).GetSRTreatPharmacy(objReport)
   
	Set (DrugName(1),IsLongTermYes(1),IsLongTermNo(1),Instruc(1),DoseQty(1),DoseQtyUnit(1),DrugSpec(1),UsageMorn(1),UsageNoon(1),UsageEven(1),DrugName(2),IsLongTermYes(2),IsLongTermNo(2),Instruc(2),DoseQty(2),DoseQtyUnit(2),DrugSpec(2),UsageMorn(2),UsageNoon(2),UsageEven(2))=""
	For i=1:1:$l(TreatPharmacy,"#"){
		Set TreatPharmacyInfo = $p(TreatPharmacy,"#",i)
		Set DrugName(i)=$p(TreatPharmacyInfo,"^",2)
		Set IsLongTerm(i)=$p(TreatPharmacyInfo,"^",9)	
		Set:IsLongTerm(i)=1 IsLongTermYes(i)=chkY_"是"
		Set:IsLongTerm(i)=1 IsLongTermNo(i)=chkN_"否"
		Set:IsLongTerm(i)=0 IsLongTermYes(i)=chkN_"是"
		Set:IsLongTerm(i)=0 IsLongTermNo(i)=chkY_"否"
		Set Instruc(i)=$p(TreatPharmacyInfo,"^",3)		
		Set DoseQty(i)=$p(TreatPharmacyInfo,"^",4)	
		Set DoseQtyUnit(i)=..GetDescById($p(TreatPharmacyInfo,"^",7))
		Set DrugSpec(i)=$p(TreatPharmacyInfo,"^",10)
		Set UsageMorn(i)=$p(TreatPharmacyInfo,"^",11)
		Set UsageNoon(i)=$p(TreatPharmacyInfo,"^",12)
		Set UsageEven(i)=$p(TreatPharmacyInfo,"^",13)
	}	
	
	Set Data=$lb(CardNo,PatName,Sex,TelPhone,PersonalID,Birthday,OPNo,IPNo,InsurNo,Contactor,ContactorTel,AdmitReason)
	Set Data=Data_$lb(PatType,IsComplete,AdmType,AdmitReason,Company,CompanyTel,Local,RegAddress,RegAddrType,CurrAddress,CurrAddrType,Occupation)
	Set Data=Data_$lb(SickDate,Referrals,ReferralTxt,DiagHospital,DiseaseDesc,DiseaseICD,DiagDate,RepLocDesc,RepLocTel,RepUserName,RepDate,DiagHospital,CheckUserName,CheckDate,ReportNote)
    Set Data=Data_$lb(IPTreatTimes,FDTreatDate,Relation,PatNation,CertType,National,HuBie,Degree,Marriage,WedLock,HouseHold,IsDrugTreatmentDesc,LockStatus,Assessment,BehaviorsDesc,Agree,AgreeDate)
    Set Data=Data_$lb(DrugName(1),IsLongTermYes(1),IsLongTermNo(1),Instruc(1),DoseQty(1),DoseQtyUnit(1),DrugSpec(1),UsageMorn(1),UsageNoon(1),UsageEven(1))        
	Set Data=Data_$lb(DrugName(2),IsLongTermYes(2),IsLongTermNo(2),Instruc(2),DoseQty(2),DoseQtyUnit(2),DrugSpec(2),UsageMorn(2),UsageNoon(2),UsageEven(2),IsDrugDesc,IsDrug2Desc)
	
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryReportPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportPrintExecute ]
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

/// 打印出院信息单
/// w ##Class(DHCMed.SMDService.ReportSrv).PrintSMDDisReport("fillxlSheet",1)
ClassMethod PrintSMDDisReport(itmjs As %String, aReportID As %String) As %String
{
	New (itmjs,aReportID)
	Set return=0
	Quit:aReportID="" return
	
	Set objReport=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Set EpisodeID=objReport.SREpisodeID
	Quit:EpisodeID="" return
	
	Set PatList = ##class(DHCMed.SMD.ReportPat).GetPatStr(aReportID,objReport.SREpisodeID)
	Set objAdm = ##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	
	Set Row=2
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCardNo,"O","JS")_"',"_Row_",6);"
	&javascript<#(retval)#>
	
	Set Row = 3
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),1),"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),2),"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	Set strNation=$p(PatList,$C(2),6)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(strNation,$C(3),3),"O","JS")_"',"_Row_",25);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),5),"O","JS")_"',"_Row_",35);"
	&javascript<#(retval)#>
	
	Set Row = 4
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),4),"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set Birthday = $p(PatList,$C(2),3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Birthday,"O","JS")_"',"_Row_",25);"
	&javascript<#(retval)#>
	
	Set Row = 5
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactor,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRContactorTel,"O","JS")_"',"_Row_",25);"
	&javascript<#(retval)#>
	
	Set Row = 6
	Set AdmitReason = ..GetDicList("SMDAdmitReason",$p(..GetDicString(objReport.SRAdmitReasonDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmitReason,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 7
	Set Local = ..GetDicList("SMDLocal",$p(..GetDicString(objReport.SRLocalDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Local,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 8
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRegAddress,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 9
	Set RegAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRRegAddrTypeDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RegAddrType,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 10
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRCurrAddress,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 11
	Set CurrAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRCurrAddrTypeDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(CurrAddrType,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 12
	Set SickDate = objReport.SRSickDate
	Set:SickDate'="" SickDate = $zd(SickDate,3)
	Set SickDate = $p(SickDate,"-",1)_"年"_$p(SickDate,"-",2)_"月"_$p(SickDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SickDate,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set AdmitDate= objAdm.AdmitDate
	//Set:AdmitDate'="" AdmitDate = $zd(AdmitDate,3)
	Set:AdmitDate["-" AdmitDate = $p(AdmitDate,"-",1)_"年"_$p(AdmitDate,"-",2)_"月"_$p(AdmitDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmitDate,"O","JS")_"',"_Row_",25);"
	&javascript<#(retval)#>
	Set DischDate = objAdm.DisDate
	//Set:DischDate'="" DischDate = $zd(DischDate,3)
	Set:DischDate["-" DischDate = $p(DischDate,"-",1)_"年"_$p(DischDate,"-",2)_"月"_$p(DischDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DischDate,"O","JS")_"',"_Row_",35);"
	&javascript<#(retval)#>
	
	Set Row = 13
	Set MentalSym = ##class(DHCMed.SMD.Report).GetSRSymptomDr(objReport)
	Set Symptoms = ""
	For i=1:1:$l(MentalSym,"#"){
		Set StrMental = $p(MentalSym,"#",i)
		Set Symptoms = Symptoms_","_$p(StrMental,"^",3)
	}
	Set Symptoms = $e(Symptoms,2,$l(Symptoms)+1)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Symptoms,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 14
	Set SocietyInf = objReport.SRSocietyImpact
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SocietyInf,",",1),"O","JS")_"',"_Row_",13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SocietyInf,",",2),"O","JS")_"',"_Row_",18);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SocietyInf,",",3),"O","JS")_"',"_Row_",23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SocietyInf,",",4),"O","JS")_"',"_Row_",29);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SocietyInf,",",5),"O","JS")_"',"_Row_",34);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(SocietyInf,",",6),"O","JS")_"',"_Row_",40);"
	&javascript<#(retval)#>
	
	Set Row = 15
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRSocietyImpactTxt,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 16
	Set OPTreatment = ..GetDicList("SMDOPTreatment",$p(..GetDicString(objReport.SROPTreatmentDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(OPTreatment,"O","JS")_"',"_Row_",13);"
	&javascript<#(retval)#>
	
	Set Row = 17
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRIPTreatTimes,"O","JS")_"',"_Row_",26);"
	&javascript<#(retval)#>
	Set FDTreatDate = objReport.SRFirstDrugTreatDate
	Set:FDTreatDate'="" FDTreatDate=$zd(FDTreatDate,3)
	Set FDTreatDate = $p(FDTreatDate,"-",1)_"年"_$p(FDTreatDate,"-",2)_"月"_$p(FDTreatDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FDTreatDate,"O","JS")_"',"_Row_",35);"
	&javascript<#(retval)#>
	
	Set Row = 18
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),7),"O","JS")_"',"_Row_",13);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),8),"O","JS")_"',"_Row_",25);"
	&javascript<#(retval)#>
	
	Set Row = 19
	Set Payment = ..GetDicList("SMDPaidType",$p(..GetDicString(objReport.SRPaymentDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Payment,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 20
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PatList,$C(2),9),"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 21
	Set Disease = ..GetICDString(##class(DHCMed.SS.Disease).GetObjById(objReport.SRDischDiagnos))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),2),"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(Disease,$c(2),3),"O","JS")_"',"_Row_",25);"
	&javascript<#(retval)#>
	Set DiagDate = objReport.SRDiagDate
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set DiagDate = $p(DiagDate,"-",1)_"年"_$p(DiagDate,"-",2)_"月"_$p(DiagDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DiagDate,"O","JS")_"',"_Row_",35);"
	&javascript<#(retval)#>
	
	Set Row = 22
	Set TreatPharmacy = ##class(DHCMed.SMD.Report).GetSRTreatPharmacy(objReport)
	For i=1:1:$l(TreatPharmacy,"#"){
		Set PharmacyInfo = $p(TreatPharmacy,"#",i)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PharmacyInfo,"^",2),"O","JS")_"',"_Row_",13);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PharmacyInfo,"^",3),"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set strPharmacy=$p(PharmacyInfo,"^",4)_$p(PharmacyInfo,"^",5)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(strPharmacy,"O","JS")_"',"_Row_",35);"
		&javascript<#(retval)#>
		Set Row = Row + 1
	}
	
	Set Row = 25
	Set Prognosis = ..GetDicList("SMDPrognosis",$p(..GetDicString(objReport.SRPrognosisDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Prognosis,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 26
	Set TreatMeasure = ##class(DHCMed.SMD.Report).GetSRTreatMeasureDr(objReport)
	Set String = ""
	For i=1:1:$l(TreatMeasure,"#"){
		Set String = String_","_$p($p(TreatMeasure,"#",i),"^",3)
	}
	Set String = $e(String,2,$l(String)+1)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(String,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRTreatMeasureTxt,"O","JS")_"',"_Row_",33);"
	&javascript<#(retval)#>
	
	Set Row = 27
	Set IsFunding = ..GetDicList("SMDIsFunding",$p(..GetDicString(objReport.SRIsFunding),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsFunding,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set FundsType = ..GetDicList("SMDFundsType",$p(..GetDicString(objReport.SRFundsType),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FundsType,"O","JS")_"',"_Row_",21);"
	&javascript<#(retval)#>
	
	Set Row = 28
	Set FundsSource = ..GetDicList("SMDFundsSource",$p(..GetDicString(objReport.SRFundsSourceDr),$c(2),3))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(FundsSource,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRFundsSourceTxt,"O","JS")_"',"_Row_",33);"
	&javascript<#(retval)#>
	
	Set Row = 30
	Set RehabPharmacy = ##class(DHCMed.SMD.Report).GetSRRehabPharmacy(objReport)
	For i=1:1:$l(RehabPharmacy,"#"){
		Set PharmacyInfo = $p(RehabPharmacy,"#",i)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PharmacyInfo,"^",2),"O","JS")_"',"_Row_",13);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT($p(PharmacyInfo,"^",3),"O","JS")_"',"_Row_",27);"
		&javascript<#(retval)#>
		Set strPharmacy=$p(PharmacyInfo,"^",4)_$p(PharmacyInfo,"^",5)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(strPharmacy,"O","JS")_"',"_Row_",35);"
		&javascript<#(retval)#>
		Set Row = Row + 1
	}
	
	Set Row = 33
	Set RehabtMeasure = ##class(DHCMed.SMD.Report).GetSRRehabMeasureDr(objReport)
	Set RehabtMeasDescs=""
	For i=1:1:$l(RehabtMeasure,"#"){
		Set String = $p(RehabtMeasure,"#",i)
		Set RehabtMeasDescs=RehabtMeasDescs_","_$p(String,"^",3)
		//Set StrRehabtMeas = ..GetDicList("SMDRehabMeasure",$p(String,"^",3))
		//Set retval=itmjs_"(xlSheet,'"_$ZCVT(StrRehabtMeas,"O","JS")_"',"_Row_",9);"
		//&javascript<#(retval)#>
	}
	Set StrRehabtMeas = ..GetDicList("SMDRehabMeasure",$e(RehabtMeasDescs,2,$l(RehabtMeasDescs)))
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(StrRehabtMeas,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRehabMeasureTxt,"O","JS")_"',"_Row_",33);"
	&javascript<#(retval)#>
	
	Set Row = 34
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRehabResume,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	
	Set Row = 35
	Set RepUserName = $p($g(^SSU("SSUSR",objReport.SRReportUser)),"^",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepUserName,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRRepLocTel,"O","JS")_"',"_Row_",21);"
	&javascript<#(retval)#>
	Set RepDate = objReport.SRReportDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepDate = $p(RepDate,"-",1)_"年"_$p(RepDate,"-",2)_"月"_$p(RepDate,"-",3)_"日"
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_Row_",35);"
	&javascript<#(retval)#>
	
	Set Row = 36
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.SRDiagHospital,"O","JS")_"',"_Row_",9);"
	&javascript<#(retval)#>
	If objReport.SRCheckUser'=""{
		Set CheckUserName = $p($g(^SSU("SSUSR",objReport.SRCheckUser)),"^",2)
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(CheckUserName,"O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
		Set CheckDate = objReport.SRCheckDate
		Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set CheckDate = $p(CheckDate,"-",1)_"年"_$p(CheckDate,"-",2)_"月"_$p(CheckDate,"-",3)_"日"
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(CheckDate,"O","JS")_"',"_Row_",35);"
		&javascript<#(retval)#>
	}Else{
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("","O","JS")_"',"_Row_",21);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT("","O","JS")_"',"_Row_",35);"
		&javascript<#(retval)#>
	}
	
	Set return = 1
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-11-25
/// Description:  通过ReportID查询报告信息
/// Table：       DHCMed.SMD.Report
/// Input：       ReportID : 报告
/// Return：      返回ROWSPEC...
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.SMDService.ReportSrv","QryDisReportPrint",6)
Query QryDisReportPrint(aReportID As %String) As %Query(ROWSPEC = "CardNo:%String,PatName:%String,Sex:%String,Nation:%String,TelPhone:%String,PersonalID:%String,Birthday:%String,OPNo:%String,IPNo:%String,InsurNo:%String,Contactor:%String,ContactorTel:%String,AdmitReason:%String,Local:%String,Telephone2:%String,Relation:%String,PatNation:%String,Assessment:%String,BehaviorsDesc:%String,RegAddress:%String,RegAddrType:%String,CurrAddress:%String,CurrAddrType:%String,SickDate:%String,AdmitDate:%String,DischDate:%String,Symptoms:%String,SocietyInf1:%String,SocietyInf2:%String,SocietyInf3:%String,SocietyInf4:%String,SocietyInf5:%String,SocietyInf6:%String,SocietyImpactTxt:%String,OPTreatment:%String,IPTreatTimes:%String,FDTreatDate:%String,TreatDrugName1:%String,TreatIsLongTermYes1:%String,TreatIsLongTermNo1:%String,TreatInstruc1:%String,TreatDoseQty1:%String,TreatDoseQtyUnit1:%String,TreatDrugSpec1:%String,TreatUsageMorn1:%String,TreatUsageNoon1:%String,TreatUsageEven1:%String,TreatDrugName2:%String,TreatIsLongTermYes2:%String,TreatIsLongTermNo2:%String,TreatInstruc2:%String,TreatDoseQty2:%String,TreatDoseQtyUnit2:%String,TreatDrugSpec2:%String,TreatUsageMorn2:%String,TreatUsageNoon2:%String,TreatUsageEven2:%String,Payment:%String,DiseaseICD:%String,DiseaseDesc:%String,DiagDate:%String,Prognosis:%String,TreatMeasures:%String,TreatMeasureTxt:%String,IsFunding:%String,FundsType:%String,FundsSource:%String,FundsSourceTxt:%String,RehabDrugName1:%String,RehabIsLongTermYes1:%String,RehabIsLongTermNo1:%String,RehabInstruc1:%String,RehabDoseQty1:%String,RehabDoseQtyUnit1:%String,RehabDrugSpec1:%String,RehabUsageMorn1:%String,RehabUsageNoon1:%String,RehabUsageEven1:%String,RehabDrugName2:%String,RehabIsLongTermYes2:%String,RehabIsLongTermNo2:%String,RehabInstruc2:%String,RehabDoseQty2:%String,RehabDoseQtyUnit2:%String,RehabDrugSpec2:%String,RehabUsageMorn2:%String,RehabUsageNoon2:%String,RehabUsageEven2:%String,RehabtMeasure:%String,RehabtMeas:%String,RehabMeasureTxt:%String,RehabResume:%String,RepUserName:%String,RepLocTel:%String,RepDate:%String,DiagHospital:%String,CheckUserName:%String,CheckDate:%String") [ SqlProc ]
{
}

ClassMethod QryDisReportPrintExecute(ByRef qHandle As %Binary, aReportID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objReport=##class(DHCMed.SMD.Report).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Set EpisodeID=objReport.SREpisodeID
	Quit:EpisodeID="" return
	Set chkY="√",chkN="□",space="   "	// √gou■hei□bai
	
	Set PatList = ##class(DHCMed.SMD.ReportPat).GetPatStr(aReportID,objReport.SREpisodeID)
	Set objAdm = ##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Set CardNo=objReport.SRCardNo
	Set PatName=$p(PatList,$C(2),1)
	Set Sex=$p(PatList,$C(2),2)	
	Set strNation=$p(PatList,$C(2),6)
	Set Nation=$p(strNation,$C(3),3)
	Set TelPhone=$p(PatList,$C(2),5)
	Set PersonalID=$p(PatList,$C(2),4)
	Set Birthday = $p(PatList,$C(2),3)
	Set:Birthday'="" Birthday=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(Birthday)
	Set:Birthday["-" Birthday = $p(Birthday,"-",1)_"年"_$p(Birthday,"-",2)_"月"_$p(Birthday,"-",3)_"日"
    Set OPNo=$p(PatList,$C(2),7)	
	Set IPNo=$p(PatList,$C(2),8)
	Set InsurNo=$p(PatList,$C(2),9)
	Set AdmType=$p(PatList,$C(2),10)

	Set Contactor=objReport.SRContactor	
	Set ContactorTel=objReport.SRContactorTel
	Set AdmitReason = ..GetDicList("SMDAdmitReason",$p(..GetDicString(objReport.SRAdmitReasonDr),$c(2),3))
	Set Local = ..GetDicList("SMDLocal",$p(..GetDicString(objReport.SRLocalDr),$c(2),3))	
	Set RegAddress=objReport.SRRegAddress
	Set RegAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRRegAddrTypeDr),$c(2),3))
	Set CurrAddress=objReport.SRCurrAddress
	Set CurrAddrType = ..GetDicList("SMDAddrType",$p(..GetDicString(objReport.SRCurrAddrTypeDr),$c(2),3))
	Set SickDate = objReport.SRSickDate
	Set:SickDate'="" SickDate = $zd(SickDate,3)
	Set SickDate = $p(SickDate,"-",1)_"年"_$p(SickDate,"-",2)_"月"_$p(SickDate,"-",3)_"日"
	
	Set AdmitDate= objAdm.AdmitDate
	Set:AdmitDate'="" AdmitDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmitDate)
	Set:AdmitDate["-" AdmitDate = $p(AdmitDate,"-",1)_"年"_$p(AdmitDate,"-",2)_"月"_$p(AdmitDate,"-",3)_"日"
	
	Set DischDate = objAdm.DisDate
	Set:DischDate'="" DischDate = ##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	Set:DischDate["-" DischDate = $p(DischDate,"-",1)_"年"_$p(DischDate,"-",2)_"月"_$p(DischDate,"-",3)_"日"

	Set MentalSym = ##class(DHCMed.SMD.Report).GetSRSymptomDr(objReport)
	Set Symptoms = ""
	For i=1:1:$l(MentalSym,"#"){
		Set StrMental = $p(MentalSym,"#",i)
		Set Symptoms = Symptoms_","_$p(StrMental,"^",3)
	}
	Set Symptoms = $e(Symptoms,2,$l(Symptoms)+1)
	
	Set SocietyInf = objReport.SRSocietyImpact
	Set SocietyInf1=$p(SocietyInf,",",1)
	Set SocietyInf2=$p(SocietyInf,",",2)
	Set SocietyInf3=$p(SocietyInf,",",3)	
	Set SocietyInf4=$p(SocietyInf,",",4)	
	Set SocietyInf5=$p(SocietyInf,",",5)
	Set SocietyInf6=$p(SocietyInf,",",6)
	
	Set SocietyImpactTxt=objReport.SRSocietyImpactTxt
	Set OPTreatment = ..GetDicList("SMDOPTreatment",$p(..GetDicString(objReport.SROPTreatmentDr),$c(2),3))
	Set IPTreatTimes=objReport.SRIPTreatTimes
	Set FDTreatDate = objReport.SRFirstDrugTreatDate
	Set:FDTreatDate'="" FDTreatDate=$zd(FDTreatDate,3)
	Set FDTreatDate = $p(FDTreatDate,"-",1)_"年"_$p(FDTreatDate,"-",2)_"月"_$p(FDTreatDate,"-",3)_"日"
	Set Payment = ..GetDicList("SMDPaidType",$p(..GetDicString(objReport.SRPaymentDr),$c(2),3))
	
	Set Disease = ..GetICDString(objReport.SRDiseaseDr)
	Set DiseaseDesc=$p(Disease,$c(2),2)	
	Set DiseaseICD=$p(Disease,$c(2),3)
	Set DiagDate = objReport.SRDiagDate
	Set:DiagDate'="" DiagDate=$zd(DiagDate,3)
	Set DiagDate = $p(DiagDate,"-",1)_"年"_$p(DiagDate,"-",2)_"月"_$p(DiagDate,"-",3)_"日"
	
	Set TreatPharmacy = ##class(DHCMed.SMD.Report).GetSRTreatPharmacy(objReport)
	Set (TreatDrugName(1),TreatIsLongTermYes(1),TreatIsLongTermNo(1),TreatInstruc(1),TreatDoseQty(1),TreatDoseQtyUnit(1),TreatDrugSpec(1),TreatUsageMorn(1),TreatUsageNoon(1),TreatUsageEven(1),TreatDrugName(2),TreatIsLongTermYes(2),TreatIsLongTermNo(2),TreatInstruc(2),TreatDoseQty(2),TreatDoseQtyUnit(2),TreatDrugSpec(2),TreatUsageMorn(2),TreatUsageNoon(2),TreatUsageEven(2))=""
	For i=1:1:$l(TreatPharmacy,"#"){
		Set TreatPharmacyInfo = $p(TreatPharmacy,"#",i)
		Set TreatDrugName(i)=$p(TreatPharmacyInfo,"^",2)
		Set TreatIsLongTerm(i)=$p(TreatPharmacyInfo,"^",9)	
		Set:TreatIsLongTerm(i)=1 TreatIsLongTermYes(i)=chkY_"是"
		Set:TreatIsLongTerm(i)=1 TreatIsLongTermNo(i)=chkN_"否"
		Set:TreatIsLongTerm(i)=0 TreatIsLongTermYes(i)=chkN_"是"
		Set:TreatIsLongTerm(i)=0 TreatIsLongTermNo(i)=chkY_"否"
		Set TreatInstruc(i)=$p(TreatPharmacyInfo,"^",3)		
		Set TreatDoseQty(i)=$p(TreatPharmacyInfo,"^",4)	
		Set TreatDoseQtyUnit(i)=..GetDescById($p(TreatPharmacyInfo,"^",7))
		Set TreatDrugSpec(i)=$p(TreatPharmacyInfo,"^",10)
		Set TreatUsageMorn(i)=$p(TreatPharmacyInfo,"^",11)
		Set TreatUsageNoon(i)=$p(TreatPharmacyInfo,"^",12)
		Set TreatUsageEven(i)=$p(TreatPharmacyInfo,"^",13)
	}	
	
	Set Prognosis = ..GetDicList("SMDPrognosis",$p(..GetDicString(objReport.SRPrognosisDr),$c(2),3))
	Set TreatMeasure = ##class(DHCMed.SMD.Report).GetSRTreatMeasureDr(objReport)
	Set TreatMeasures = ""
	For i=1:1:$l(TreatMeasure,"#"){
		Set TreatMeasures = TreatMeasures_","_$p($p(TreatMeasure,"#",i),"^",3)
	}
	Set TreatMeasures = $e(TreatMeasures,2,$l(TreatMeasures)+1)
	Set TreatMeasureTxt=objReport.SRTreatMeasureTxt
	
	Set IsFunding = ..GetDicList("SMDIsFunding",$p(..GetDicString(objReport.SRIsFunding),$c(2),3))	
	Set FundsType = ..GetDicList("SMDFundsType",$p(..GetDicString(objReport.SRFundsType),$c(2),3))
	Set FundsSource = ..GetDicList("SMDFundsSource",$p(..GetDicString(objReport.SRFundsSourceDr),$c(2),3))
	Set FundsSourceTxt=objReport.SRFundsSourceTxt
	Set RehabPharmacy = ##class(DHCMed.SMD.Report).GetSRRehabPharmacy(objReport)
	
	Set (RehabDrugName(1),RehabIsLongTermYes(1),RehabIsLongTermNo(1),RehabInstruc(1),RehabDoseQty(1),RehabDoseQtyUnit(1),RehabDrugSpec(1),RehabUsageMorn(1),RehabUsageNoon(1),RehabUsageEven(1),RehabDrugName(2),RehabIsLongTermYes(2),RehabIsLongTermNo(2),RehabInstruc(2),RehabDoseQty(2),RehabDoseQtyUnit(2),RehabDrugSpec(2),RehabUsageMorn(2),RehabUsageNoon(2),RehabUsageEven(2))=""
	For i=1:1:$l(RehabPharmacy,"#"){
		Set RehabPharmacyInfo = $p(RehabPharmacy,"#",i)
		Set RehabDrugName(i)=$p(RehabPharmacyInfo,"^",2)
		Set RehabIsLongTerm(i)=$p(RehabPharmacyInfo,"^",9)	
		Set:RehabIsLongTerm(i)=1 RehabIsLongTermYes(i)=chkY_"是"
		Set:RehabIsLongTerm(i)=1 RehabIsLongTermNo(i)=chkN_"否"
		Set:RehabIsLongTerm(i)=0 RehabIsLongTermYes(i)=chkN_"是"
		Set:RehabIsLongTerm(i)=0 RehabIsLongTermNo(i)=chkY_"否"
		Set RehabInstruc(i)=$p(RehabPharmacyInfo,"^",3)		
		Set RehabDoseQty(i)=$p(RehabPharmacyInfo,"^",4)	
		Set RehabDoseQtyUnit(i)=..GetDescById($p(RehabPharmacyInfo,"^",7))
		Set RehabDrugSpec(i)=$p(RehabPharmacyInfo,"^",10)
		Set RehabUsageMorn(i)=$p(RehabPharmacyInfo,"^",11)
		Set RehabUsageNoon(i)=$p(RehabPharmacyInfo,"^",12)
		Set RehabUsageEven(i)=$p(RehabPharmacyInfo,"^",13)
	}	
			
	Set RehabtMeasure = ##class(DHCMed.SMD.Report).GetSRRehabMeasureDr(objReport)
	Set RehabtMeasDescs=""
	For i=1:1:$l(RehabtMeasure,"#"){
		Set String = $p(RehabtMeasure,"#",i)
		Set RehabtMeasDescs=RehabtMeasDescs_","_$p(String,"^",3)
	}
	Set RehabtMeasDescs = $e(RehabtMeasDescs,2,$l(RehabtMeasDescs))
	Set RehabtMeas = ..GetDicList("SMDRehabMeasure",RehabtMeasDescs)	
	Set RehabMeasureTxt=objReport.SRRehabMeasureTxt	
	Set RehabResume=objReport.SRReportNote	
	Set RepUserName = $p($g(^SSU("SSUSR",objReport.SRReportUser)),"^",2)	
	Set RepLocTel=objReport.SRRepLocTel	
	Set RepDate = objReport.SRReportDate
	Set:RepDate'="" RepDate=$zd(RepDate,3)
	Set RepDate = $p(RepDate,"-",1)_"年"_$p(RepDate,"-",2)_"月"_$p(RepDate,"-",3)_"日"

	Set DiagHospital=objReport.SRDiagHospital
	Set (CheckUserName,CheckDate)=""
	If objReport.SRCheckUser'=""{
		Set CheckUserName = $p($g(^SSU("SSUSR",objReport.SRCheckUser)),"^",2)	
		Set CheckDate = objReport.SRCheckDate
		Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
		Set CheckDate = $p(CheckDate,"-",1)_"年"_$p(CheckDate,"-",2)_"月"_$p(CheckDate,"-",3)_"日"
	}
	/// 联系人姓名
    Set Contactor =  objReport.SRContactor
	Set ContactorTel = objReport.SRContactorTel
	Set Telephone2 = objReport.SRTelephone2
    Set Relation = $p(..GetDicString(objReport.SRPatRelationDr),$c(2),3)  //与患者关系  
    Set PatNation = $p(..GetDicString(objReport.SRPatNationDr),$c(2),3)  //国籍
    Set Assessment = ..GetDicList("SMDWXPG",$p(..GetDicString(objReport.SRAssessmentDr),$c(2),3))   //既往危险性评估
    Set Behaviors = objReport.SRBehaviors   //既往危险行为
    Set BehaviorsDesc = ""
	For i=1:1:$l(Behaviors,","){
		Set Behavior = ..GetDescById($p(Behaviors,",",i))
		Set BehaviorsDesc = BehaviorsDesc_","_Behavior
	}
	Set BehaviorsDesc = $e(BehaviorsDesc,2,$l(BehaviorsDesc)+1)
	
	Set Data=$lb(CardNo,PatName,Sex,Nation,TelPhone,PersonalID,Birthday,OPNo,IPNo,InsurNo,Contactor,ContactorTel,AdmitReason,Local,Telephone2,Relation,PatNation,Assessment,BehaviorsDesc)
	Set Data=Data_$lb(RegAddress,RegAddrType,CurrAddress,CurrAddrType,SickDate,AdmitDate,DischDate,Symptoms)
	Set Data=Data_$lb(SocietyInf1,SocietyInf2,SocietyInf3,SocietyInf4,SocietyInf5,SocietyInf6,SocietyImpactTxt,OPTreatment,IPTreatTimes,FDTreatDate)
	Set Data=Data_$lb(TreatDrugName(1),TreatIsLongTermYes(1),TreatIsLongTermNo(1),TreatInstruc(1),TreatDoseQty(1),TreatDoseQtyUnit(1),TreatDrugSpec(1),TreatUsageMorn(1),TreatUsageNoon(1),TreatUsageEven(1))
	Set Data=Data_$lb(TreatDrugName(2),TreatIsLongTermYes(2),TreatIsLongTermNo(2),TreatInstruc(2),TreatDoseQty(2),TreatDoseQtyUnit(2),TreatDrugSpec(2),TreatUsageMorn(2),TreatUsageNoon(2),TreatUsageEven(2))
	Set Data=Data_$lb(Payment,DiseaseICD,DiseaseDesc,DiagDate,Prognosis,TreatMeasures,TreatMeasureTxt,IsFunding,FundsType,FundsSource,FundsSourceTxt)
	Set Data=Data_$lb(RehabDrugName(1),RehabIsLongTermYes(1),RehabIsLongTermNo(1),RehabInstruc(1),RehabDoseQty(1),RehabDoseQtyUnit(1),RehabDrugSpec(1),RehabUsageMorn(1),RehabUsageNoon(1),RehabUsageEven(1))
	Set Data=Data_$lb(RehabDrugName(2),RehabIsLongTermYes(2),RehabIsLongTermNo(2),RehabInstruc(2),RehabDoseQty(2),RehabDoseQtyUnit(2),RehabDrugSpec(2),RehabUsageMorn(2),RehabUsageNoon(2),RehabUsageEven(2))
	Set Data=Data_$lb(RehabtMeasure,RehabtMeas,RehabMeasureTxt,RehabResume,RepUserName,RepLocTel,RepDate,DiagHospital,CheckUserName,CheckDate)

	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QryDisReportPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisReportPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDisReportPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisReportPrintExecute ]
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

/// w ##Class(DHCMed.DARService.EventRepPrint).GetDicList("SMDRepStatus","")
ClassMethod GetDicList(aDicType As %String, aDicDesc As %String)
{
	New (aDicType,aDicDesc)
	Set return=""
	Quit:aDicType="" return
	
	Set aDicDesc=","_aDicDesc_","
	
	Set xID=0,Number=0
 	For {
	 	Set xID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$zcvt(aDicType,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(objDic)
	 	
		Set IsActive=objDic.Active
		Continue:IsActive'=1
	 	Set Code=objDic.Code
		Set Description=objDic.Description
		Set Type=objDic.Type
		Continue:aDicType'=Type
		
		Set Number=Number+1
		Set:Number>1 return=return_"  "
		
		Set tmpDescription=","_Description_","
		If aDicDesc[tmpDescription {
			Set return=return_"√"_Description
		} Else {
			Set return=return_"□"_Description
		}
	}
	
	Quit return
}

/// w ##class(DHCMed.SMDServer.ReportSrv).GetDescById("5618")
ClassMethod GetDescById(id As %String) As %String
{
	new (id)
	set return=""
	quit:id="" return
	
	set obj=##Class(DHCMed.SS.Dictionary).GetObjById(id)
	quit:'$IsObject(obj) return
	
	set return=obj.Description
	quit return
}

/// 处理历史数据（特别是更新程序后，姓名字段显示乱码）
/// w ##class(DHCMed.SMDService.ReportSrv).ChangeErrData()
ClassMethod ChangeErrData() As %String
{
	new
	set return=""
	
	set xID=0
	for {
		set xID=$o(^DHCMed.SMD.ReportD(xID))
		quit:xID=""
		
		set repInfo=$g(^DHCMed.SMD.ReportD(xID))
		continue:repInfo=""
		
		set patientObj=$list(repInfo,13)
		continue:$listlength(patientObj)>1
		set patientObj=$list($list(patientObj,1),1)
		set $list(repInfo,13)=patientObj
		//W $LISTTOSTRING(patientObj),!
		set ^DHCMed.SMD.ReportD(xID)=repInfo
	}
	
	quit "OK"
}

}

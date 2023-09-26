/// 名称: DHCMed.NINFService.Rep.AimReportPrint
/// 描述: 目标性监测BS报告
/// 编写者：zhufei
/// 编写日期: 2016-05-27
Class DHCMed.NINFService.Rep.AimReportPrint Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhouruimeng
/// CreatDate：   2016-01-07
/// w ##Class(DHCMed.NINFService.Rep.AimReportPrint).PrintReportICU("fillxlSheet",51)
ClassMethod PrintReportICU(itmjs As %String, ReportID As %String) As %String
{
	New (itmjs,ReportID)
	Set Count=0
	
	Set ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.ReportExport:QryBaseInf")
	Do ds.Execute(ReportID,"")
	Do ds.Next()
	Set PapmiNo=ds.Data("PapmiNo")                             //登记号
	Set PatName=ds.Data("Name")                                   //姓名
	Set MrNo=ds.Data("MrNo")                                   //
	Set Sex=ds.Data("Sex")                                     //
	Set Age=ds.Data("Age")                                     //
	Set NowLoc=ds.Data("NowLoc")                               //
	Set AdmDate=ds.Data("AdmDate")                             //
	Set AdmTime=ds.Data("AdmTime")                             //
	Set DisDate=ds.Data("DisDate")                             //
	Set DisTime=ds.Data("DisTime")                             //
	Set ImpDays=ds.Data("ImpDate")                             //住院天数
	Set BedNo=ds.Data("BedNo")                                 //床号
	Set RelLocDesc=ds.Data("RelLoc")                       //当前科室
	Set ReportLocDesc=ds.Data("RepLoc")                 //上报科室
	Set RepDate=ds.Data("RepDate")                             //上报时间
	Set ReportUserDesc=ds.Data("RepMan")               //上报人 
	Set DiseasePrognosisDesc=ds.Data("DisPro")   //转归
	Set DeathRelationDesc=ds.Data("DeaRel")         //死亡
	Set TransLoc=ds.Data("TransLoc")                           //
	Set TransLocDesc=ds.Data("TransLocDesc")                   //
	Set TransDate=ds.Data("TransDate")                         //转科时间
	Set TransTime=ds.Data("TransTime")                         //转科时间
	Set TransDate=TransDate_" "_TransTime
	Set PrevTransWardDesc=ds.Data("PrevTransWardDesc")         //入科来源
	Set xNextTransWardDesc=ds.Data("NextTransWardDesc")       //出科去向
	Set xNextTransDate=ds.Data("NextTransDate")               //
	Set ApacheIICode=ds.Data("LocalSymptom")                   //ApacheIICode
	Set OutICUStatusDesc=ds.Data("OutICUStatusDesc")           //
	Set OutICU48StatusDesc=ds.Data("OutICU48StatusDesc")    //
	
	//第3行
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PapmiNo,"O","JS")_"',"_3_",7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatName,"O","JS")_"',"_3_",20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',"_3_",33);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_3_",46);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_3_",54);"
	&javascript<#(retval)#>
	
	//第4行
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(NowLoc,"O","JS")_"',"_4_",7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmDate,"O","JS")_"',"_4_",20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DisDate,"O","JS")_"',"_4_",33);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ImpDays,"O","JS")_"',"_4_",46);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(BedNo,"O","JS")_"',"_4_",54);"
	&javascript<#(retval)#>
	
	//第5行 上报信息
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RelLocDesc,"O","JS")_"',"_5_",7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportLocDesc,"O","JS")_"',"_5_",20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_5_",33);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ReportUserDesc,"O","JS")_"',"_5_",46);"
	&javascript<#(retval)#>
	
	//第6行 转科
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(TransDate,"O","JS")_"',"_6_",7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(xNextTransDate,"O","JS")_"',"_6_",20);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PrevTransWardDesc,"O","JS")_"',"_6_",33);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(xNextTransWardDesc,"O","JS")_"',"_6_",46);"
	&javascript<#(retval)#>
	
	//第7行 转归
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DiseasePrognosisDesc,"O","JS")_"',"_7_",7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DeathRelationDesc,"O","JS")_"',"_7_",33);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ApacheIICode,"O","JS")_"',"_7_",46);"
	&javascript<#(retval)#>
	
	//第8行 局部症状
	//Set retval=itmjs_"(xlSheet,'"_$ZCVT(LocalSymptom,"O","JS")_"',"_8_",7);"
	//&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(OutICUStatusDesc,"O","JS")_"',"_8_",20);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(OutICU48StatusDesc,"O","JS")_"',"_9_",20);"
	&javascript<#(retval)#>
	d ds.Close()
	
	// 基础诊断
	Set ds1 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportDiag:QrySubRec")
	DO ds1.Execute(+ReportID,"","BASE")
	Set DiagnosDesc=""
	while(ds1.Next())
	{
		Set DiagICD="" //ds1.Data("DiagnosICD")
		Set DiagDesc=ds1.Data("DiagnosDesc")
		Set DiagDate=ds1.Data("DiagnosDate")
		Set DiagTime=ds1.Data("DiagnosTime")
		
		Set DiagnosDesc=DiagnosDesc_DiagDesc_":"_DiagICD_";"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnosDesc,"O","JS")_"',"_10_",14);"
	&javascript<#(retval)#>
	d ds1.Close()
	
	// ICU诊断
	Set ds2 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportDiag:QrySubRec")
	Do ds2.Execute(+ReportID,"","ICU")
	Set ICDDiagnosDesc=""
	while(ds2.Next())
	{
		Set DiagICD="" //ds2.Data("DiagnosICD")
		Set DiagDesc=ds2.Data("DiagnosDesc")
		Set DiagDate=ds2.Data("DiagnosDate")
		Set DiagTime=ds2.Data("DiagnosTime")
		
		Set ICDDiagnosDesc=ICDDiagnosDesc_DiagDesc_":"_DiagICD_":"_DiagDate_" "_DiagTime_";"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(ICDDiagnosDesc,"O","JS")_"',"_11_",14);"
	&javascript<#(retval)#>
	d ds2.Close()
	
	// 静脉置管
	Set ds3 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportICU:QrySubRec")
	Do ds3.Execute(+ReportID,"","PICC")
	Set StartRow=14
	while(ds3.Next())
	{
		Set PICCIntubateTypeDesc=ds3.Data("PICCIntubateTypeDesc")
		Set PICCIntubateRegionDesc=ds3.Data("PICCIntubateRegionDesc")
		Set PICCIntubateNumDesc=ds3.Data("PICCIntubateNumDesc")
		Set IntubateDateTime=ds3.Data("IntubateDateTime")
		Set ExtubateDateTime=ds3.Data("ExtubateDateTime")
		Set IntubateUserTypeDesc=ds3.Data("IntubateUserTypeDesc")
		Set IntubatePlaceDesc=ds3.Data("IntubatePlaceDesc")
		Set IsInfection=ds3.Data("IsInfection")
		Set InfDate=ds3.Data("InfDate")
		
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PICCIntubateTypeDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PICCIntubateNumDesc,"O","JS")_"',"_StartRow_",7);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PICCIntubateRegionDesc,"O","JS")_"',"_StartRow_",13);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubateDateTime,"O","JS")_"',"_StartRow_",19);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ExtubateDateTime,"O","JS")_"',"_StartRow_",28);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubateUserTypeDesc,"O","JS")_"',"_StartRow_",37);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubatePlaceDesc,"O","JS")_"',"_StartRow_",42);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInfection,"O","JS")_"',"_StartRow_",48);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(InfDate,"O","JS")_"',"_StartRow_",52);"
		&javascript<#(retval)#>
		Set StartRow=StartRow+1
		Quit:StartRow>17
	}
	d ds3.Close()
	// 呼吸机
	Set ds4 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportICU:QrySubRec")
	Do ds4.Execute(+ReportID,"","VAP")
	Set StartRow=20
	while(ds4.Next())
	{
		Set VAPIntubateTypeDesc=ds4.Data("VAPIntubateTypeDesc")
		Set IntubateDateTime=ds4.Data("IntubateDateTime")
		Set ExtubateDateTime=ds4.Data("ExtubateDateTime")
		Set IntubateUserTypeDesc=ds4.Data("IntubateUserTypeDesc")
		Set IntubatePlaceDesc=ds4.Data("IntubatePlaceDesc")
		Set IsInfection=ds4.Data("IsInfection")
		Set InfDate=ds4.Data("InfDate")
		
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(VAPIntubateTypeDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubateDateTime,"O","JS")_"',"_StartRow_",7);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ExtubateDateTime,"O","JS")_"',"_StartRow_",22);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubateUserTypeDesc,"O","JS")_"',"_StartRow_",37);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubatePlaceDesc,"O","JS")_"',"_StartRow_",42);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInfection,"O","JS")_"',"_StartRow_",48);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(InfDate,"O","JS")_"',"_StartRow_",52);"
		&javascript<#(retval)#>
		Set StartRow=StartRow+1
		Quit:StartRow>20
	}
	d ds4.Close()
	// 导尿管
	Set ds5 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportICU:QrySubRec")
	Do ds5.Execute(+ReportID,"","UC")
	Set StartRow=23
	while(ds5.Next())
	{
		Set UCUrineBagTypeDesc=ds5.Data("UCUrineBagTypeDesc")
		Set IntubateDateTime=ds5.Data("IntubateDateTime")
		Set ExtubateDateTime=ds5.Data("ExtubateDateTime")
		Set IntubateUserTypeDesc=ds5.Data("IntubateUserTypeDesc")
		Set IntubatePlaceDesc=ds5.Data("IntubatePlaceDesc")
		Set IsInfection=ds5.Data("IsInfection")
		Set InfDate=ds5.Data("InfDate")
		
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(UCUrineBagTypeDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubateDateTime,"O","JS")_"',"_StartRow_",7);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ExtubateDateTime,"O","JS")_"',"_StartRow_",22);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubateUserTypeDesc,"O","JS")_"',"_StartRow_",37);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IntubatePlaceDesc,"O","JS")_"',"_StartRow_",42);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInfection,"O","JS")_"',"_StartRow_",48);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(InfDate,"O","JS")_"',"_StartRow_",52);"
		&javascript<#(retval)#>
		Set StartRow=StartRow+1
		Quit:StartRow>23
	}
	d ds5.Close()
	
	// 病原学
	Set ds6 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportLab:QrySubRec")
	Do ds6.Execute(+ReportID,"")
	Set StartRow=26
	while(ds6.Next())
	{
		Set ArcimDesc=ds6.Data("ArcimDesc")
		Set SpecimenDesc=ds6.Data("SpecimenDesc")
		Set InfectionPosDesc=ds6.Data("InfectionPosDesc")
		Set SubmissionDate=ds6.Data("SubmissionDate")
		Set AssayMethodDesc=ds6.Data("AssayMethodDesc")
		Set PathogenTestDesc=ds6.Data("PathogenTestDesc")
		Set TestResultValues=ds6.Data("TestResultValues")
		Set TestResultDescs=ds6.Data("TestResultDescs")
		
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(ArcimDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(SpecimenDesc,"O","JS")_"',"_StartRow_",13);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(SubmissionDate,"O","JS")_"',"_StartRow_",17);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(AssayMethodDesc,"O","JS")_"',"_StartRow_",25);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenTestDesc,"O","JS")_"',"_StartRow_",31);"
		&javascript<#(retval)#>
		Set retval=itmjs_"(xlSheet,'"_$ZCVT(TestResultDescs,"O","JS")_"',"_StartRow_",37);"
		&javascript<#(retval)#>
		Set StartRow=StartRow+1
	}
	d ds6.Close()
	
	q 1
}

/// Creator：     jiangpengpeng
/// CreatDate：   2014-07-08
/// w ##Class(DHCMed.NINFService.Rep.AimReportPrint).PrintReportOPR("fillxlSheet",291)
ClassMethod PrintReportOPR(itmjs As %String, ReportID As %String) As %String
{
	n (itmjs,ReportID)
	s Count=0
	s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.AimReportOPR:QryOprRepByID")
	d ds.Execute(ReportID)

	d ds.Next()
	
	s PapmiNo=ds.Data("PapmiNo")
	s PatMrNo=ds.Data("PatMrNo")
	s PatName=ds.Data("PatName")
	s PatSex=ds.Data("PatSex")
	s PatAge=ds.Data("PatAge")
	s OperationDesc=ds.Data("OperationDesc")
	s OperDocDesc=ds.Data("OperDocDesc")
	s OperStartDateTime=ds.Data("OperStartDateTime")
	s OperEndDateTime=ds.Data("OperEndDateTime")
	s OperationTypeDesc=ds.Data("OperationTypeDesc")
	s PreoperWBC=ds.Data("PreoperWBC")
	s CuteNumberDesc=ds.Data("CuteNumberDesc")
	s CuteTypeDesc=ds.Data("CuteTypeDesc")
	s ASAScoreDesc=ds.Data("ASAScoreDesc")
	s EndoscopeFlagDesc=ds.Data("EndoscopeFlagDesc")
	s ImplantFlagDesc=ds.Data("ImplantFlagDesc")
	s PreoperAntiFlagDesc=ds.Data("PreoperAntiFlagDesc")
	s CuteHealingDesc=ds.Data("CuteHealingDesc")
	s AnesthesiaDesc=ds.Data("AnesthesiaDesc")
	s CuteInfFlagDesc=ds.Data("CuteInfFlagDesc")
	s OperInfTypeDesc=ds.Data("OperInfTypeDesc")
	
	s InHospInfFlagDesc=ds.Data("InHospInfFlagDesc")
	s BloodLossFlagDesc=ds.Data("BloodLossFlagDesc")
	s BloodLoss=ds.Data("BloodLoss")
	s BloodTransFlagDesc=ds.Data("BloodTransFlagDesc")
	s BloodTrans=ds.Data("BloodTrans")
	s PostoperCompsDesc=ds.Data("PostoperCompsDesc")
	s ReportLocDesc=ds.Data("ReportLocDesc")
	s ReportUserDesc=ds.Data("ReportUserDesc")
	s ReportDate=ds.Data("ReportDate")
	s ReportTime=ds.Data("ReportTime")
	s AdmitDate=ds.Data("AdmitDate")
	s DischDate=ds.Data("DischDate")
	s AdmLoc=ds.Data("AdmLoc")
	s AdmWard=ds.Data("AdmWard")
	s AdmBed=ds.Data("AdmBed")
	s EpisodeID=ds.Data("EpisodeID")
	Set AdmDays=""
	S objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Set:$IsObject(objPaadm) AdmDays=objPaadm.Days
	
	s DisDthStr=##Class(DHCMed.NINFService.Rep.AimReportOPR).GetDataBySummID(ReportID)
	s DiseasePrognosis=$p(DisDthStr,"^",1)
	s DeathRelation=$p(DisDthStr,"^",2)
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PapmiNo,"O","JS")_"',"_3_",2);"
	&javascript<#(retval)#>
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PatName,"O","JS")_"',"_3_",5);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PatSex,"O","JS")_"',"_3_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',"_3_",12);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PatMrNo,"O","JS")_"',"_4_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AdmitDate,"O","JS")_"',"_4_",5);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DischDate,"O","JS")_"',"_4_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AdmDays,"O","JS")_"',"_4_",12);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AdmLoc,"O","JS")_"',"_5_",2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ReportLocDesc,"O","JS")_"',"_5_",5);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ReportDate,"O","JS")_"',"_5_",8);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AdmBed,"O","JS")_"',"_5_",12);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ReportUserDesc,"O","JS")_"',"_6_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DiseasePrognosis,"O","JS")_"',"_6_",5);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DeathRelation,"O","JS")_"',"_6_",8);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OperationDesc,"O","JS")_"',"_16_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OperStartDateTime,"O","JS")_"',"_17_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OperEndDateTime,"O","JS")_"',"_17_",6);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OperDocDesc,"O","JS")_"',"_18_",2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(OperationTypeDesc,"O","JS")_"',"_18_",5);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CuteNumberDesc,"O","JS")_"',"_19_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CuteTypeDesc,"O","JS")_"',"_19_",5);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PreoperWBC,"O","JS")_"',"_19_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CuteHealingDesc,"O","JS")_"',"_20_",2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AnesthesiaDesc,"O","JS")_"',"_20_",5);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(EndoscopeFlagDesc,"O","JS")_"',"_20_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ImplantFlagDesc,"O","JS")_"',"_20_",12);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CuteInfFlagDesc,"O","JS")_"',"_21_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PreoperAntiFlagDesc,"O","JS")_"',"_21_",5);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(ASAScoreDesc,"O","JS")_"',"_21_",8);"
	&javascript<#(retval)#>

	s retval=itmjs_"(xlSheet,'"_$ZCVT(OperInfTypeDesc,"O","JS")_"',"_22_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(InHospInfFlagDesc,"O","JS")_"',"_22_",8);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BloodLossFlagDesc,"O","JS")_"',"_23_",2);"
	&javascript<#(retval)#>
	//
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BloodLoss,"O","JS")_"',"_23_",5);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BloodTransFlagDesc,"O","JS")_"',"_23_",8);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(BloodTrans,"O","JS")_"',"_23_",12);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PostoperCompsDesc,"O","JS")_"',"_23_",2);"
	&javascript<#(retval)#>
	d ds.Close()
	
	s ds2 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportDiag:QrySubRec")
	d ds2.Execute(ReportID,"","BASE")
	s StartRow=9
	while(ds2.Next())
	{
		s DiagnosICD=""  //ds2.Data("DiagnosICD")
		s DiagnosDesc=ds2.Data("DiagnosDesc")
		s DiagnosDate=ds2.Data("DiagnosDate")
		s DiagnosTime=ds2.Data("DiagnosTime")
		S DiagnosDesc=DiagnosDesc_":"_DiagnosICD
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnosDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnosDate,"O","JS")_"',"_StartRow_",5);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagnosTime,"O","JS")_"',"_StartRow_",8);"
		&javascript<#(retval)#>
		s StartRow=StartRow+1
		Quit:StartRow>14
	}
	d ds2.Close()
	
	s ds3 = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportAnti:QrySubRec")
	d ds3.Execute(ReportID,"")
	s StartRow=27
	while(ds3.Next())
	{
		s ArcimDesc=ds3.Data("ArcimDesc")		//药名
		s AdminRouteDesc=ds3.Data("AdminRouteDesc")		//给药途径
		s StartDate=ds3.Data("StartDate")		//开始日期
		s StartTime=ds3.Data("StartTime")		//开始时间
		s StartDT=StartDate_" "_StartTime		
		s EndDate=ds3.Data("EndDate")			//结束日期
		s EndTime=ds3.Data("EndTime")			//结束时间
		s EndDT=EndDate_" "_EndTime
		s MedPurposeDesc=ds3.Data("MedPurposeDesc")	//目的	
		s TreatmentModeDesc=ds3.Data("TreatmentModeDesc") //用药方式
		s PreMedIndicatDesc=ds3.Data("PreMedIndicatDesc")	//用药指症
		s PreMedEffectDesc=ds3.Data("PreMedEffectDesc")		//用药效果
		s CombinedMedDesc=ds3.Data("CombinedMedDesc")		//联合用药
		Set MedUsePurposeDesc=ds3.Data("MedUsePurposeDesc")	//用途
		Set DoseQty=ds3.Data("DoseQty")	//剂量
		Set PhcFreqDesc=ds3.Data("PhcFreqDesc")	//频次
		Set PreMedTime=ds3.Data("PreMedTime")	//术前用药时间
		Set PostMedDays=ds3.Data("PostMedDays")	//术后用药天数
		
		s retval=itmjs_"(xlSheet,'"_$ZCVT(ArcimDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(MedUsePurposeDesc,"O","JS")_"',"_StartRow_",2);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(AdminRouteDesc,"O","JS")_"',"_StartRow_",3);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(StartDT,"O","JS")_"',"_StartRow_",4);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(EndDT,"O","JS")_"',"_StartRow_",5);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(DoseQty,"O","JS")_"',"_StartRow_",6);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PhcFreqDesc,"O","JS")_"',"_StartRow_",7);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(MedPurposeDesc,"O","JS")_"',"_StartRow_",8);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(TreatmentModeDesc,"O","JS")_"',"_StartRow_",9);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PreMedIndicatDesc,"O","JS")_"',"_StartRow_",10);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PreMedEffectDesc,"O","JS")_"',"_StartRow_",11);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(CombinedMedDesc,"O","JS")_"',"_StartRow_",12);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PreMedTime,"O","JS")_"',"_StartRow_",13);"
		&javascript<#(retval)#>
		s retval=itmjs_"(xlSheet,'"_$ZCVT(PostMedDays,"O","JS")_"',"_StartRow_",14);"
		&javascript<#(retval)#>
		s StartRow=StartRow+1
		
	}
	d ds3.Close()
	
	
	q 1
}

}

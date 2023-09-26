/// Description: CDSS演示用患者
/// Creator: 徐凯
/// Date: 2021-08-27
Class web.CDSS.CMKB.DHCDSSPatient Extends %RegisteredObject
{

/// Creator: 徐凯
/// CreatDate: 2021-08-27
/// Description：查询患者列表
/// Table：WDT.CDSS.PatientMaster,WDT.CDSS.PatientVisit
/// Input：rowid
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DHCDSSPatient","GetList","","","","DM000753","")
Query GetList(rowid, type, department, idno, patientdr) As %Query(ROWSPEC = "RowId,VisitType,VisitingDepartment,IDNO,PatientDR,VisitID")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, type, department, idno, patientdr) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
	s RowId=rowid
	s IDNO = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),2)
	s PatientDR = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),3)
	s VisitID = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),4)
	s VisitType = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),5)
	s VisitingDepartment = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),7)
	d OutputRow
 }
 else
 {
	s:idno'="" idno=$ZCONVERT(idno,"U")
	s:patientdr'="" patientdr=$ZCONVERT(patientdr,"U")

	s RowId=""
	for{  
		s RowId=$o(^WDT.CDSS.PatientVisitD(RowId),-1) 
		q:RowId=""  
		//就诊信息
		s IDNO = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),2)
		s PatientDR = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),3)
		s VisitID = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),4)
		s VisitType = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),5)
		s VisitingDepartment = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),7)
#;		if ((type=VisitType)||(type=""))&&((department=VisitingDepartment)||(department=""))&&(($ZCONVERT(IDNO,"U")[idno)||(idno=""))&&(($ZCONVERT(PatientDR,"U")[patientdr)||(patientdr="")){
		if (((type=VisitType)||(type=""))&&((department=VisitingDepartment)||(department=""))&&(($ZCONVERT(IDNO,"U")[idno)||(idno=""))&&(($ZCONVERT(PatientDR,"U")[patientdr)||(patientdr=""))){	
			d OutputRow
		}	
	}
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RowId,VisitType,VisitingDepartment,IDNO,PatientDR,VisitID)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator：徐凯
/// CreatDate: 2021-08-26
/// Description：数据打开方法
/// Table：WDT.CDSS.PatientMaster,WDT.CDSS.PatientVisit
/// Input：RowId
/// Return:Json
/// Other: w ##class(web.CDSS.CMKB.DHCDSSPatient).OpenData("1")
ClassMethod OpenData(RowId As %String) As %String
{
	s str=""
	s eobj = ##class(web.CDSSEntity.CMKB.DHCDSSPatient).%New()
	if (RowId'=""){
		//就诊信息
		s eobj.IDNO = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),2)
		s eobj.PatientDR = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),3)
		s eobj.VisitID = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),4)
		s eobj.VisitType = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),5)
		s eobj.VisitingDepartment = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),7)
		//患者信息
	#;	s eobj.IDNO = $LISTGET($G(^WDT.CDSS.PatientMasterD(eobj.HISPatMasterDR)),2)
	#;	s eobj.PatientDR = $LISTGET($G(^WDT.CDSS.PatientMasterD(eobj.HISPatMasterDR)),3)
		
	}
	s str = eobj.JsonS()	
	q str
}

/// Creator:赵文伟
/// CreatDate:2021-12-09
/// Description: 删除方法 [删除临床信息和就诊信息]
/// Table: WDT.CDSS.PatientMaster、WDT.CDSS.PatientVisit
/// others:w ##class(web.CDSS.CMKB.DHCDSSPatient).DeleteData("")
ClassMethod DeleteData(id As %String)
{
	s result=""
	s PatId	=""
	
	//就诊信息
	s IDNO = $LISTGET($G(^WDT.CDSS.PatientVisitD(id)),2)
	s PatientDR = $LISTGET($G(^WDT.CDSS.PatientVisitD(id)),3)
	s VisitID = $LISTGET($G(^WDT.CDSS.PatientVisitD(id)),4)
	s VisitType = $LISTGET($G(^WDT.CDSS.PatientVisitD(id)),5)
	TS
	s resClinical=..DelClinicalData(IDNO,PatientDR,VisitID,VisitType,"0")
	if (resClinical["false"){									//删除临床信息
	
		s result = resClinical
		
	}else{	
		s sc=##class(WDT.CDSS.PatientVisit).%DeleteId(id) 	//删除就诊信息
		if $$$ISOK(sc)
		{
			s result = "{success:'true',info:'删除成功！'}"	
				
		} else{
			//s result = "{success:'false',info:'就诊信息删除失败'}" 
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			
		}
	}
	if (result["false")
	{ 
		TRO   //回滚统一处理
	}
	else 
	{
		TC
		s result = "{success:'true',info:'删除成功！'}"	
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2021-12-10
/// Description:同步删除临床信息 flag 0:不删除无就诊次索引数据 1：删除无就诊次索引数据
/// others:w ##class(web.CDSS.CMKB.DHCDSSPatient).DelClinicalData("","","","")
ClassMethod DelClinicalData(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, flag As %String)
{
	s result=""
	TS
	;体征信息表 WDT.CDSS.SignInfo
	s SignId=""
	for {
		s SignId=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,SignId)) q:SignId=""
		
		s scSign=##class(WDT.CDSS.SignInfo).%DeleteId(SignId)	
		if $$$ISERR(scSign)
		{
			s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scSign)_"'}"  //返回错误信息
			q
		}
	}
	if (result=""){
		;主诉信息表 WDT.CDSS.ChiefCompInfo
		s ChiefCompId=""
		for {
			s ChiefCompId=$o(^WDT.CDSS.ChiefCompInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,ChiefCompId)) q:ChiefCompId=""
			
			s scChiefComp=##class(WDT.CDSS.ChiefCompInfo).%DeleteId(ChiefCompId)	
			if $$$ISERR(scChiefComp)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scChiefComp)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;现病史信息表 WDT.CDSS.CurrentMedHistory
		s CurrentMedId=""
		for {
			s CurrentMedId=$o(^WDT.CDSS.CurrentMedHistoryI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,CurrentMedId)) q:CurrentMedId=""
				
			s scCurrentMed=##class(WDT.CDSS.CurrentMedHistory).%DeleteId(CurrentMedId)	
			if $$$ISERR(scCurrentMed)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scCurrentMed)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;既往史信息表 WDT.CDSS.PastDiagnosis
		s PastDiagId=""
		for {
			s PastDiagId=$o(^WDT.CDSS.PastDiagnosisI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PastDiagId)) q:PastDiagId=""
			s scPastDiag=##class(WDT.CDSS.PastDiagnosis).%DeleteId(PastDiagId)	
			if $$$ISERR(scPastDiag)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPastDiag)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;个人史信息表 WDT.CDSS.PersonalInfo
		if (flag="1"){
			s PersonalId=""
			for {
				s PersonalId=$o(^WDT.CDSS.PersonalInfoI("PatDRIndex",PatientDR,PersonalId)) q:PersonalId=""
				s scPersonal=##class(WDT.CDSS.PersonalInfo).%DeleteId(PersonalId)	
				if $$$ISERR(scPersonal)
				{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPersonal)_"'}"  //返回错误信息
					q
				}
			}
		}
	}
	if (result=""){
		;婚育史信息表 WDT.CDSS.MarryInfo
		s MarryId=""
		for {
			s MarryId=$o(^WDT.CDSS.MarryInfoI("PatDRIndex",PatientDR,MarryId)) q:MarryId=""
			s scMarry=##class(WDT.CDSS.MarryInfo).%DeleteId(MarryId)	
			if $$$ISERR(scMarry)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scMarry)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;家族史信息表 WDT.CDSS.FamilyHisInfo
		s FamilyId=""
		for {
			s FamilyId=$o(^WDT.CDSS.FamilyHisInfoI("PatDRIndex",PatientDR,FamilyId)) q:FamilyId=""
			s scFamily=##class(WDT.CDSS.FamilyHisInfo).%DeleteId(FamilyId)	
			if $$$ISERR(scFamily)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scFamily)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;过敏史信息表 WDT.CDSS.AllergyHistory
		s AllergyId=""
		for {
			s AllergyId=$o(^WDT.CDSS.AllergyHistoryI("PatDRIndex",PatientDR,AllergyId)) q:AllergyId=""
			s scAllergy=##class(WDT.CDSS.AllergyHistory).%DeleteId(AllergyId)	
			if $$$ISERR(scAllergy)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAllergy)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;体格检查表 WDT.CDSS.PhysicalExam
		s PhyExamId=""
		for {
			s PhyExamId=$o(^WDT.CDSS.PhysicalExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PhyExamId)) q:PhyExamId=""
			s scPhyExam=##class(WDT.CDSS.PhysicalExam).%DeleteId(PhyExamId)	
			if $$$ISERR(scPhyExam)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPhyExam)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;专科检查表 WDT.CDSS.SpecExam
		s SpecExamId=""
		for {
			s SpecExamId=$o(^WDT.CDSS.SpecExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,SpecExamId)) q:SpecExamId=""
			s scSpecExam=##class(WDT.CDSS.SpecExam).%DeleteId(SpecExamId)	
			if $$$ISERR(scSpecExam)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scSpecExam)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;诊断信息表 WDT.CDSS.DiagnosisInfo
		s DiagnosisId=""
		for {
			s DiagnosisId=$o(^WDT.CDSS.DiagnosisInfoI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),DiagnosisId)) q:DiagnosisId=""
			//s DiagnosisId=$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRIndex",PatientDR,VisitID,DiagnosisId)) q:DiagnosisId=""
			
			s scDiagnosis=##class(WDT.CDSS.DiagnosisInfo).%DeleteId(DiagnosisId)	
			if $$$ISERR(scDiagnosis)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDiagnosis)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;处方信息表 WDT.CDSS.DrugInfo
		s DrugId=""
		for {
			s DrugId=$o(^WDT.CDSS.DrugInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,DrugId)) q:DrugId=""
			s scDrug=##class(WDT.CDSS.DrugInfo).%DeleteId(DrugId)	
			if $$$ISERR(scDrug)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDrug)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;检查信息表 WDT.CDSS.ExamInfo
		s ExamId=""
		for {
			s ExamId=$o(^WDT.CDSS.ExamInfoI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),ExamId)) q:ExamId=""
			//s ExamId=$o(^WDT.CDSS.ExamInfoI("PatVisDRIndex",PatientDR,VisitID,ExamId)) q:ExamId=""
			
			s scExam=##class(WDT.CDSS.ExamInfo).%DeleteId(ExamId)	
			if $$$ISERR(scExam)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scExam)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;检验信息表 WDT.CDSS.LabInfo
		s LabId=""
		for {
			s LabId=$o(^WDT.CDSS.LabInfoI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),LabId)) q:LabId=""
			//s LabId=$o(^WDT.CDSS.LabInfoI("PatVisDRIndex",PatientDR,VisitID,LabId)) q:LabId=""
			
			s scLab=##class(WDT.CDSS.LabInfo).%DeleteId(LabId)	
			if $$$ISERR(scLab)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scLab)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;辅助检验检查信息表 WDT.CDSS.LabExamInfo
		s LabExamId=""
		for {
			s LabExamId=$o(^WDT.CDSS.LabExamInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,LabExamId)) q:LabExamId=""
			s scLabExam=##class(WDT.CDSS.LabExamInfo).%DeleteId(LabExamId)	
			if $$$ISERR(scLabExam)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scLabExam)_"'}"  //返回错误信息
				q
			}
		}
	}

	if (result=""){
		;手术信息表 WDT.CDSS.OperationInfo
		s OperationId=""
		for {
			s OperationId=$o(^WDT.CDSS.OperationInfoI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),OperationId)) q:OperationId=""
			//s OperationId=$o(^WDT.CDSS.OperationInfoI("PatVisDRIndex",PatientDR,VisitID,OperationId)) q:OperationId=""
			
			s scOperation=##class(WDT.CDSS.OperationInfo).%DeleteId(OperationId)	
			if $$$ISERR(scOperation)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scOperation)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;麻醉信息表 WDT.CDSS.AnestInfo
		s AnestId=""
		for {
			s AnestId=$o(^WDT.CDSS.AnestInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,AnestId)) q:AnestId=""
			s objAnest=##class(WDT.CDSS.AnestInfo).%OpenId(AnestId)
			s scAnest=##class(WDT.CDSS.AnestInfo).%DeleteId(AnestId)	
			if $$$ISERR(scAnest)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scAnest)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;护理信息表 WDT.CDSS.NursingInfo
		s NursingId=""
		for {
			s NursingId=$o(^WDT.CDSS.NursingInfoI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),NursingId)) q:NursingId=""
			//s NursingId=$o(^WDT.CDSS.NursingInfoI("PatVisDRIndex",PatientDR,VisitID,NursingId)) q:NursingId=""
			
			s scNursing=##class(WDT.CDSS.NursingInfo).%DeleteId(NursingId)	
			if $$$ISERR(scNursing)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scNursing)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;输血信息表 WDT.CDSS.BloodTransInfo
		s BloodTransId=""
		for {
			s BloodTransId=$o(^WDT.CDSS.BloodTransInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,BloodTransId)) q:BloodTransId=""
			s scBloodTrans=##class(WDT.CDSS.BloodTransInfo).%DeleteId(BloodTransId)	
			if $$$ISERR(scBloodTrans)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scBloodTrans)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;饮食信息表 WDT.CDSS.DietInfo
		s DietId=""
		for {
			s DietId=$o(^WDT.CDSS.DietInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,DietId)) q:DietId=""
			s scDiet=##class(WDT.CDSS.DietInfo).%DeleteId(DietId)	
			if $$$ISERR(scDiet)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scDiet)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;临床表现表 WDT.CDSS.ClinicalFeature
		s ClinFeatureId=""
		for {
			
			s ClinFeatureId=$o(^WDT.CDSS.ClinicalFeatureI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,ClinFeatureId)) q:ClinFeatureId=""
			
			;临床表现明细表 WDT.CDSS.ClinicalFDetailed
			s ClinFDetailId=""
			for 
			{
				s ClinFDetailId=$o(^WDT.CDSS.ClinicalFDetailedI("FeatureDRIndex",ClinFeatureId,ClinFDetailId)) q:ClinFDetailId=""
				s scClinFDetail=##class(WDT.CDSS.ClinicalFDetailed).%DeleteId(ClinFDetailId)	
				if $$$ISERR(scClinFDetail)
				{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scClinFDetail)_"'}"  //返回错误信息
					q
				}
			}
			if (result=""){
				s scClinFeature=##class(WDT.CDSS.ClinicalFeature).%DeleteId(ClinFeatureId)	
				if $$$ISERR(scClinFeature)
				{
					s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scClinFeature)_"'}"  //返回错误信息
					q
				}
			}
																					
		}
	}
	if (result=""){
		;其他在院医嘱信息表 WDT.CDSS.OtherOrderInfo
		s OtherOrderId=""
		for {
			s OtherOrderId=$o(^WDT.CDSS.OtherOrderInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,OtherOrderId)) q:OtherOrderId=""
			s scOtherOrder=##class(WDT.CDSS.OtherOrderInfo).%DeleteId(OtherOrderId)	
			if $$$ISERR(scOtherOrder)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scOtherOrder)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;病历信息表 WDT.CDSS.InpatientInfo
		s InpatientId=""
		for {
			s InpatientId=$o(^WDT.CDSS.InpatientInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,InpatientId)) q:InpatientId=""
			s scInpatient=##class(WDT.CDSS.InpatientInfo).%DeleteId(InpatientId)	
			if $$$ISERR(scInpatient)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scInpatient)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;出院带药信息表 WDT.CDSS.CarryDrug
		s CarryDrugId=""
		for {
			s CarryDrugId=$o(^WDT.CDSS.CarryDrugI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),CarryDrugId)) q:CarryDrugId=""
			//s CarryDrugId=$o(^WDT.CDSS.CarryDrugI("PatVisDRIndex",PatientDR,VisitID,CarryDrugId)) q:CarryDrugId=""
			s scCarryDrug=##class(WDT.CDSS.CarryDrug).%DeleteId(CarryDrugId)	
			if $$$ISERR(scCarryDrug)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scCarryDrug)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;其他出院医嘱信息表 WDT.CDSS.OtherDisOrderInfo
		s OtherDisOrderId=""
		for {
			s OtherDisOrderId=$o(^WDT.CDSS.OtherDisOrderInfoI("IDNOIndex"," "_$ZCONVERT(IDNO,"U"),OtherDisOrderId)) q:OtherDisOrderId=""
			//s OtherDisOrderId=$o(^WDT.CDSS.OtherDisOrderInfoI("PatVisDRIndex",PatientDR,VisitID,OtherDisOrderId)) q:OtherDisOrderId=""
			s scOtherDisOrder=##class(WDT.CDSS.OtherDisOrderInfo).%DeleteId(OtherDisOrderId)	
			if $$$ISERR(scOtherDisOrder)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scOtherDisOrder)_"'}"  //返回错误信息
				q
			}
		}
	}
	if (result=""){
		;患者转科记录表 WDT.CDSS.PatientTransfer
		s PatTransferId=""
		for {
			s PatTransferId=$o(^WDT.CDSS.PatientTransferI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PatTransferId)) q:PatTransferId=""
			s scPatTransfer=##class(WDT.CDSS.PatientTransfer).%DeleteId(PatTransferId)	
			if $$$ISERR(scPatTransfer)
			{
				s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(scPatTransfer)_"'}"  //返回错误信息
				q
			}
		}
	}
																				
	if (result["false"){	//统一处理回滚
		TRO
	} else {
		TC
	}
	q result
}

/// Creator：赵文伟
/// CreatDate: 2022-08-26
/// Description：删除既不在V1.0也不在V2.0演示系统患者列表里的患者信息数据，同步删除临床信息
/// Table：WDT.CDSS.PatientMaster,WDT.CDSS.DEMOPatMaster,WDT.CDSS.HISPatientMaster
/// Input：
/// Return:
/// Other: w ##class(web.CDSS.CMKB.DHCDSSPatient).DeleteRedundantData()
ClassMethod DeleteRedundantData() As %String
{
	s count=0
	s result=""
	s PatMasterId=""
	TS
	for{
		s PatMasterId=$o(^WDT.CDSS.PatientMasterD(PatMasterId),-1) q:PatMasterId=""
		
		s IDNO = $LISTGET($G(^WDT.CDSS.PatientMasterD(PatMasterId)),2)
		s PatientDR = $LISTGET($G(^WDT.CDSS.PatientMasterD(PatMasterId)),3)
				
		if '($d(^WDT.CDSS.DEMOPatMasterI("PatDRIndex",PatientDR))){	//2.0中不存在
			
			if '($d(^WDT.CDSS.HISPatientMasterI("PatDRIndex",PatientDR))){	//1.0中不存在
				
				//就诊信息不为空，遍历删除就诊信息及临床信息,就诊信息全部删除后再删除患者信息
				s PatVisitId=""
				for{				//遍历取就诊信息
					s PatVisitId=$o(^WDT.CDSS.PatientVisitI("PatDRIndex",PatientDR,PatVisitId)) q:PatVisitId=""
					s result=..DeleteData(PatVisitId)	//删除就诊信息及临床信息
					if (result["false"){
						q
					}
				}
				if '(result["false"){	//删除患者信息
					s sc=##class(WDT.CDSS.PatientMaster).%DeleteId(PatMasterId)
					if $$$ISOK(sc)
					{
						s count=count+1
										 
					}else{
						s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
						q
					}
				}
			}
		}
	}
	if (result["false"){  //回滚统一处理
		tro
	}
	else
	{
		tc
		s result = "{success:'true',info:'删除成功,共处理"_count_"条数据！}"
	}
	q result
}

/// Creator：赵文伟
/// CreatDate: 2022-12-27
/// Description：取科室
/// Table：WDT.CDSS.PatientVisit
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DHCDSSPatient","GetDepDataForCmb1","","")
Query GetDepDataForCmb1(desc As %String, q As %String) As %Query(ROWSPEC = "RowId:%String,VisitingDepartment:%String")
{
}

ClassMethod GetDepDataForCmb1Execute(ByRef qHandle As %Binary, desc As %String, q As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
		s:q'="" desc=q
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s dep={}
		k ^TempDataHandle($ZNAME,repid,$JOB,"Short")
		s ID=0
		for 
		{
			s ID=$o(^WDT.CDSS.PatientVisitD(ID))
			q:ID=""
			s VisitingDepartment = $LISTGET($G(^WDT.CDSS.PatientVisitD(ID)),7)
			s length=$l(VisitingDepartment)
			s ^TempDataHandle($ZNAME,repid,$JOB,"Short",length,ID)=ID
		}
		s le=0
		s num=0
		for
		{
			s le=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le))
			q:le=""
			s RowId=0
			for
			{
				s RowId=$o(^TempDataHandle($ZNAME,repid,$JOB,"Short",le,RowId)) q:RowId=""
		 		s VisitingDepartment = $LISTGET($G(^WDT.CDSS.PatientVisitD(RowId)),7)
		 		s flag = dep.%Get(VisitingDepartment)
				if (flag=""){
					d dep.%Set(VisitingDepartment,VisitingDepartment)
				} else{
					continue
				}
		  		if ($ZCONVERT(VisitingDepartment,"U")[desc) {
		  			d OutputRowCmb
		  		}
		  		continue:(desc'="")
		        s num=num+1
		        q:num=1000
			}
			q:num=1000
		}

	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(RowId,VisitingDepartment)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDepDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDepDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^TempDataHandle($ZNAME,repid,$JOB,"Short")
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}

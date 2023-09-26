/// 数据中台后台类
Class web.CDSS.MiddlePlatform.InterfaceBackend Extends %RegisteredObject
{

/// Creator:李得原
/// CreatDate:2022-06-04
/// Description:处理病历信息，把病历数据存入患者临时global
/// Table:
/// Input: 
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).ProcessRecordPatient()
ClassMethod ProcessRecordPatient(JsonStr As %String) As %String
{
	if (JsonStr="")||(JsonStr="[]")
	{
		q ""
	}
	s Json = [].%FromJSON(JsonStr)
	s Json= Json.%Get(0)
	s Config = "1"
	s IDNO = Json.%Get("IDNO")
	s PatientDR = Json.%Get("PatientDR")
	s VisitID = Json.%Get("VisitID")
	s VisitType="3"
	s PatientUserInfo=Json.%Get("IDNO")_"^"_Json.%Get("PatientDR")_"^"_$tr(Json.%Get("VisitID"),0)_"^"_"住院"_"^"_Json.%Get("UserID")_"^"_Json.%Get("UserName")_"^"_Json.%Get("DeptName")_"^"_Config  //调用后台接口的参数
	s VisitType = ..ConvertVisitType(VisitType)
	s Children = Json.%Get("children")
	s TmpSymptomList = []    //症状信息列表
	s TmpPastDiagList = []   //既往史信息列表
	s TmpPhysicalExamList = [] //体格检查
	s TmpAllergyHistoryList = []  //过敏史
	s TmpMarryInfoList = []  //婚育史
	s TmpPersonalInfoList = [] //个人史
	s TmpFamilyHistoryList = [] //家族史
	for j=0:1:Children.%Size()-1
	{
		s ChildItem = Children.%Get(j)
		s DataClass = ChildItem.%Get("DataClass")
		s SubItemList = ChildItem.%Get("children")
		s SubItem = SubItemList.%Get(0)
		if (DataClass="ChiefCompInfo")||(DataClass="CurrentMedHistory")   //主诉，现病史表  收集症状
		{
			s TmpSymptom = {}
			s Symptom = SubItem.%Get("Symptom")   // 症状
			s SymptomFormal =SubItem.%Get("SymptomFormal") // 症状
			s SymptomCore = SubItem.%Get("SymptomCore") // 症状
	
			s TableNme="WDT.CDSS."_DataClass
			s:DataClass="ChiefCompInfo" IDNAME="CompID"
			s:DataClass="CurrentMedHistory" IDNAME="CurrentID"
			
			d TmpSymptom.%Set(IDNAME, "")
			d TmpSymptom.%Set("Symptom", Symptom)
			d TmpSymptom.%Set("SymptomFormal", SymptomFormal)
			d TmpSymptom.%Set("SymptomCore", SymptomCore)
			d ..GetWordsItemField("症状名称",.SubItem,.TmpSymptom)

			d TmpSymptom.%Set("TableName",TableNme)
			d TmpSymptomList.%Push(TmpSymptom)
			
			s TmpSymptomStr = TmpSymptom.%ToJSON()
			if Symptom'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"症状","Symptom",Symptom)=TmpSymptomStr
				s ^TempPInfoItemData($j,PatientUserInfo,"西医诊断症状","Symptom",Symptom)=TmpSymptomStr
				d ..SaveSatisfyIW("WDT.CDSS.ChiefCompInfo","Symptom",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
				d ..SaveSatisfyIW("WDT.CDSS.CurrentMedHistory","Symptom",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
			
			if SymptomFormal'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"症状","SymptomFormal",SymptomFormal)=TmpSymptomStr
				d ..SaveSatisfyIW("WDT.CDSS.ChiefCompInfo","SymptomFormal",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
				d ..SaveSatisfyIW("WDT.CDSS.CurrentMedHistory","SymptomFormal",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
			
			if SymptomCore'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"症状","SymptomCore",SymptomCore)=TmpSymptomStr
				d ..SaveSatisfyIW("WDT.CDSS.ChiefCompInfo","SymptomCore",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
				d ..SaveSatisfyIW("WDT.CDSS.CurrentMedHistory","SymptomCore",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
			
			
		}
		if DataClass="PastDiagnosis"     //既往史
		{
			s TmpPastDiag = {}
			s PastDiagnosisName = SubItem.%Get("PastDiagnosisName")
			d TmpPastDiag.%Set("PastDiagnosisName",PastDiagnosisName)
			d TmpPastDiag.%Set("DiagnosisType",SubItem.%Get("DiagnosisType"))
			d ..GetWordsItemField("既往诊断名称",.SubItem,.TmpPastDiag)

			d TmpPastDiag.%Set("TableName","WDT.CDSS.PastDiagnosis")
			d TmpPastDiagList.%Push(TmpPastDiag)
			s TmpPastDiagStr=TmpPastDiag.%ToJSON()
			if PastDiagnosisName'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"既往史","PastDiagnosisName",PastDiagnosisName)=TmpPastDiagStr
				d ..SaveSatisfyIW("WDT.CDSS.PastDiagnosis","PastDiagnosisName",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
		}
		
		if DataClass="AllergyHistory"    //过敏史
		{
			
			s TmpAllergyHistory = {}
			s AllergySourceName = SubItem.%Get("AllergySourceName")
			d TmpAllergyHistory.%Set("AllergySourceName",AllergySourceName)
			d TmpAllergyHistory.%Set("TableName","WDT.CDSS.AllergyHistory")
			d ..GetWordsItemField("过敏原名称",.SubItem,.TmpAllergyHistory)
			d TmpAllergyHistoryList.%Push(TmpAllergyHistory)
			s TmpAllergyHistoryStr = TmpAllergyHistory.%ToJSON()
			if AllergySourceName'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"过敏史","AllergySourceName",AllergySourceName)=TmpAllergyHistoryStr
				d ..SaveSatisfyIW("WDT.CDSS.AllergyHistory","AllergySourceName",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
		}
		
		if DataClass="PhysicalExam"  //体格检查
		{
			s TmpPhysical = {}
			s ExamItem = SubItem.%Get("ExamItem")

			d TmpPhysical.%Set("ExamItem", ExamItem)
			d ..GetWordsItemField("体格检查名称",.SubItem,.TmpPhysical)
			d TmpPhysical.%Set("TableName", "WDT.CDSS.PhysicalExam")
			d TmpPhysicalExamList.%Push(TmpPhysical)
			s TmpPhysicalStr=TmpPhysical.%ToJSON()
			if ExamItem'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"体格检查","ExamItem",ExamItem)=TmpPhysicalStr
				d ..SaveSatisfyIW("WDT.CDSS.PhysicalExam","ExamItem",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
		}
		
		if DataClass="MarryInfo"    //婚育史
		{
			s TmpMarryInfo = {}
			s TypeOfMarriage = SubItem.%Get("TypeOfMarriage")
			d TmpMarryInfo.%Set("TypeOfMarriage",TypeOfMarriage)
			
			d ..GetWordsItemField("月经婚育项目名称",.SubItem,.TmpMarryInfo)
			d TmpMarryInfo.%Set("TableName","WDT.CDSS.MarryInfo")
			d TmpMarryInfoList.%Push(TmpMarryInfo)
			s TmpMarryInfoStr = TmpMarryInfo.%ToJSON()
			if TypeOfMarriage'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"婚育史","TypeOfMarriage",TypeOfMarriage)=TmpMarryInfoStr	
				d ..SaveSatisfyIW("WDT.CDSS.MarryInfo","TypeOfMarriage",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
		}
		
		if DataClass="PersonalInfo" //个人史
		{
			s TmpPersonal = {}
			s PersonalHistoryOverview = SubItem.%Get("PersonalHistoryOverview")
			d TmpPersonal.%Set("PersonalHistoryOverview",PersonalHistoryOverview)
			d ..GetWordsItemField("个人史名称",.SubItem,.TmpPersonal)
			d TmpPersonal.%Set("TableName","WDT.CDSS.PersonalInfo")
			
			d TmpPersonalInfoList.%Push(TmpPersonal)
			s TmpPersonalStr = TmpPersonal.%ToJSON()
			if PersonalHistoryOverview'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"个人史","PersonalHistoryOverview",PersonalHistoryOverview)=TmpPersonalStr	
				d ..SaveSatisfyIW("WDT.CDSS.PersonalInfo","PersonalHistoryOverview",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
		}
		
		if DataClass="FamilyHisInfo" //家族史
		{
			s TmpFamilyHistory = {}
			s GeneticDiseName = SubItem.%Get("GeneticDiseName")
			d TmpFamilyHistory.%Set("GeneticDiseName",GeneticDiseName)
			
			d ..GetWordsItemField("家族史",.SubItem,.TmpFamilyHistory)
			d TmpFamilyHistory.%Set("TableName","WDT.CDSS.FamilyHisInfo")
			
			d TmpFamilyHistoryList.%Push(TmpFamilyHistory)
			s TmpFamilyHistoryStr = TmpFamilyHistory.%ToJSON()
			if GeneticDiseName'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"家族史","GeneticDiseName",GeneticDiseName)=TmpFamilyHistoryStr	
				//d ..SaveSatisfyIW("WDT.CDSS.FamilyHisInfo","GeneticDiseName",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
		}
		if ((DataClass="ExamInfo")||(DataClass="LabInfo"))   //检查检验信息
		{
			s TmpExamInfo={}
			s InfoName = ""
			s ExamItemRowid=$o(^CT.WDT.CDSS.WordsItemI("DescIndex"," 检查检验结果名称",0))
			s ExamItemFields=$lg($g(^CT.WDT.CDSS.WordsItemD(ExamItemRowid)),7)  //关联字段
			d ..GetWordsItemField("检查检验结果名称",.SubItem,.TmpExamInfo)
			
			s pItem=$g(^TempPInfoItemData($j,PatientUserInfo,"检查检验结果"))
			if (pItem'="")&(pItem'="[]")
			{
				s ExamListStr = ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果")
				s ExamList=[].%FromJSON(ExamListStr)
				d ExamList.%Push(SubItem)
				s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果")=ExamList.%ToJSON()
			}
			else
			{
				s ExamList=[]
				d ExamList.%Push(SubItem)
				s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果")=ExamList.%ToJSON()
			}
			for ExamItemFieldIndex=1:1:$l(ExamItemFields,"&")
			{
				s TmpExamInfo={}
				s ExamName=SubItem.%Get("ExamName")
				d TmpExamInfo.%Set("TableName","WDT.CDSS.ExamInfo")
				d TmpExamInfo.%Set("ExamName",ExamName)
				s ExamItemField=$p(ExamItemFields,"&",ExamItemFieldIndex)
				s ExamItemFieldValue = SubItem.%Get(ExamItemField)
				if ExamItemFieldValue'=""
				{
					s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果",ExamItemField,ExamItemFieldValue)=TmpExamInfo.%ToJSON()
				}
			}
			d ..SaveSatisfyIW("WDT.CDSS.ExamInfo","ExamResult",IDNO,PatientDR,VisitID,VisitType)   //存变化类型	
		}
		
		
		if DataClass="LabExamInfo" //辅助检验检查
		{
			s TmpLabExamInfo = {}
			s InfoName = ""
			s CheckType = SubItem.%Get("CheckType")
			if (CheckType["Ris")||(CheckType["ris")
			{
				s InfoName = "检查结果"
				s CheckValue = SubItem.%Get("CheckValue")
				d TmpLabExamInfo.%Set("CheckName",SubItem.%Get("CheckName"))
				d TmpLabExamInfo.%Set("CheckValue",CheckValue)
				d TmpLabExamInfo.%Set("SymProperty",SubItem.%Get("SymProperty"))
				d TmpLabExamInfo.%Set("PositionWord",SubItem.%Get("PositionWordDR"))
				d TmpLabExamInfo.%Set("TableName","WDT.CDSS.LabExamInfo")

				s CDSS2PartDR=SubItem.%Get("CDSS2PartDR")
				
				d TmpLabExamInfo.%Set("PartL",CDSS2PartDR)
				d TmpLabExamInfo.%Set("Part",CDSS2PartDR)
				d TmpLabExamInfo.%Set("PartStr",CDSS2PartDR)

				s ^TempPInfoItemData($j,PatientUserInfo,InfoName,"CheckValue",CheckValue)=TmpLabExamInfo.%ToJSON()

			}
			elseif (CheckType["Lis")||(CheckType["lis")
			{
				s InfoName = "检验结果"
				
				//s ^TempPInfoItemData($j,PatientUserInfo,InfoName,"CheckValue",CheckValue)=TmpLabExamInfo.%ToJSON()
			}
				
		}
		if DataClass="PatientMaster"     //妊娠
		{
			s PregStatus = SubItem.%Get("PregStatus")
			s GestWeek = SubItem.%Get("GestWeek")
			if PregStatus'=""
			{
				
				s TmpPregnancyInfo = {}
				d TmpPregnancyInfo.%Set("PregStatus",PregStatus)
				d ..GetWordsItemField("妊娠/产后状态名称",.SubItem,.TmpPregnancyInfo)
				d TmpPregnancyInfo.%Set("TableName","WDT.CDSS.PatientMaster")
				d TmpPregnancyInfo.%Set("ProjectName",PregStatus)
				s ^TempPInfoItemData($j,PatientUserInfo,"妊娠/产后状态")="["_TmpPregnancyInfo.%ToJSON()_"]"
				s ^TempPInfoItemData($j,PatientUserInfo,"妊娠/产后状态","PregStatus",PregStatus)=TmpPregnancyInfo.%ToJSON()
				d ..SaveSatisfyIW("WDT.CDSS.PatientMaster","PregStatus",IDNO,PatientDR,VisitID,VisitType)   //存变化类型
			}
			
		} 
		
	}
	s TmpSymptomListStr=TmpSymptomList.%ToJSON()
	s DiagSymptom = $g(^TempPInfoItemData($j,PatientUserInfo,"诊断症状"))
	if (DiagSymptom'="")&(DiagSymptom'="[]")
    {
	    if (TmpSymptomListStr'="")&(TmpSymptomListStr'="[]")
	    {
			s DiagSymptomUnion = "["_$e(TmpSymptomListStr,2,*-1)_","_$e(DiagSymptom,2,*-1)_"]"
		    
			s ^TempPInfoItemData($j,PatientUserInfo,"诊断症状")=DiagSymptomUnion
	    }
	}
	else
	{
		s ^TempPInfoItemData($j,PatientUserInfo,"诊断症状")=TmpSymptomListStr
	}
	s ^TempPInfoItemData($j,PatientUserInfo,"症状")=TmpSymptomList.%ToJSON()  
	s ^TempPInfoItemData($j,PatientUserInfo,"既往史")=TmpPastDiagList.%ToJSON()  
	s ^TempPInfoItemData($j,PatientUserInfo,"体格检查")=TmpPhysicalExamList.%ToJSON()  
	s ^TempPInfoItemData($j,PatientUserInfo,"过敏史")=TmpAllergyHistoryList.%ToJSON()  
	s ^TempPInfoItemData($j,PatientUserInfo,"婚育史")=TmpMarryInfoList.%ToJSON()  
	s ^TempPInfoItemData($j,PatientUserInfo,"个人史")=TmpPersonalInfoList.%ToJSON()  
	s ^TempPInfoItemData($j,PatientUserInfo,"家族史")=TmpFamilyHistoryList.%ToJSON()
	q ""
}

/// Creator:陈代雷
/// CreatDate:2020-06-04
/// Description:初始化患者信息
/// Table:
/// Input: BasicInfo : 患者基本信息 {"IDNO": "患者主索引", "PatientDR":"病人标识","VisitID":"就诊次","Name":"患者姓名","UserID":"医生ID","UserName":"医生姓名","DeptCode":"科室编码","DeptName":"科室名称","PageSource":"数据来源"}
/// Return:标准版信息
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).GetBasicInfo(BasicInfo)
ClassMethod GetBasicInfo(BasicInfo As %String) As %String
{
    s info=[].%FromJSON(BasicInfo)
	s GenderList = []
	s IDNO=info.%Get("IDNO")
    s PatientDR=info.%Get("PatientDR")
    s VisitID=info.%Get("VisitID")
    s VisitType=info.%Get("VisitType")
	s Config = "1"
	s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
	s PatientInfo = info.%Get("PatientInfo")
	s Gender = PatientInfo.%Get("Gender")
	s Loc = PatientInfo.%Get("VisitingDepartment")
	
	s BirthDate = PatientInfo.%Get("BirthDate")
	s PregnancyStatus = PatientInfo.%Get("PregnancyStatus")
	if Gender'=""
	{
		s GenderJson={}
		d GenderJson.%Set("Sex",Gender)
		d GenderList.%Push(GenderJson)
		s ^TempPInfoItemData($j,PatientUserInfo,"性别","Sex",Gender)=GenderJson.%ToJSON()
		s ^TempPInfoItemData($j,PatientUserInfo,"性别")=GenderList.%ToJSON()
		d ..SaveSatisfyIW("WDT.CDSS.PatientMaster","Sex",IDNO,PatientDR,VisitID,VisitType)
	}
	
	if Loc'=""
	{
		s LocJson={}
		d LocJson.%Set("VisitingDepartment",Loc)
		s ^TempPInfoItemData($j,PatientUserInfo,"就诊科室","VisitingDepartment",Loc)=LocJson.%ToJSON()
		s ^TempPInfoItemData($j,PatientUserInfo,"就诊科室")="[{""VisitingDepartment"":"""_Loc_"""}]"
		d ..SaveSatisfyIW("WDT.CDSS.PatientVisit","VisitingDepartment",IDNO,PatientDR,VisitID,VisitType)	
	}
	
	if BirthDate'=""
	{
		s Age = ..CurrentAge($zdh(BirthDate,3))
		s BirthJson={}
		d BirthJson.%Set("Age",Age)
		s ^TempPInfoItemData($j,PatientUserInfo,"年龄","Age",Age)=BirthJson.%ToJSON()
		s ^TempPInfoItemData($j,PatientUserInfo,"年龄")="[{""Age"":"""_Age_"""}]"
		if (BirthDate'="")
		{
			s dateday=$zdh(BirthDate,3)
			s days=+$h-dateday
		}
		else
		{
			s days=""
		}
		if (days="")
		{
			s days=Age*365
		}
		s BirthJsonStr="{""Age"":"""_days_"""}"
		s ^TempPInfoItemData($j,PatientUserInfo,"年龄(天)","Age",days)=BirthJsonStr 
		s ^TempPInfoItemData($j,PatientUserInfo,"年龄(天)")="[{""Age"":"""_days_"""}]"
		d ..SaveSatisfyIW("WDT.CDSS.PatientMaster","Age",IDNO,PatientDR,VisitID,VisitType)
	}
	q ""
}

/// 评分量表信息
ClassMethod SaveRatingScaleJsonInfo(ScaleJson As %String) As %String
{
    s info=[].%FromJSON(ScaleJson)
    s IDNO=info.%Get("IDNO")
    s PatientDR=info.%Get("PatientDR")
    s VisitID=info.%Get("VisitID")
    s VisitType=info.%Get("VisitType")
	s Config = "1"
	s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
	s ScaleList = []
	s RatingScaleList=info.%Get("RatingScale")  //诊断信息列表
	for RatingIndex=0:1:RatingScaleList.%Size()-1
	{
		s TempRating = {}
		s RatingItem = RatingScaleList.%Get(RatingIndex)
		s RatingScaleName=RatingItem.%Get("RatingScaleName")
		s RatingDesc = RatingItem.%Get("RatingDesc")
		s RatingRank = RatingItem.%Get("RatingRank")
		s RatingScore = RatingItem.%Get("RatingScore")
		d TempRating.%Set("RatingScaleName",RatingScaleName)
		d TempRating.%Set("RatingDesc",RatingDesc)
		d TempRating.%Set("RatingRank",RatingRank)
		d TempRating.%Set("RatingScore",RatingScore)
		d ..GetWordsItemField("评估表",RatingScaleList.%Get(RatingIndex),TempRating)
		continue:RatingScaleName=""
		s ^TempPInfoItemData($j,PatientUserInfo,"评估表","RatingScaleName",RatingScaleName)=TempRating.%ToJSON()
		d ScaleList.%Push(TempRating)
	}
	s ^TempPInfoItemData($j,PatientUserInfo,"评估表")=ScaleList.%ToJSON()
	d ..SaveSatisfyIW("WDT.CDSS.PatientRatingScale","RatingScaleDictDR",IDNO,PatientDR,VisitID,VisitType)
    q ""
}

/// Creator:陈代雷
/// CreatDate:2020-06-05
/// Description:同步诊断数据
/// Table:
/// Input: DiagInfo : 患者基本信息 {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "DiagnosisList": [{"DiagnosisId": "诊断ID", "DiagnosisCode": "诊断编码", "DiagnosisName": "诊断名称", "DiagnosisType": "诊断类型", "DiagnosisDoctorType": "诊断分类", "IsMainDiagnosis": "是否主诊断", "DiagnosisSequence": "诊断顺序", "RecordTime": "开立时间", "DiagnosisDoctorId": "开立医生ID", "DiagnosisDoctorName": "开立医生名称"}]}
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).SynchronousDiagInfo(DiagInfo)
ClassMethod SynchronousDiagInfo(DiagInfo As %String) As %String
{
    s info=[].%FromJSON(DiagInfo)
    s IDNO=info.%Get("IDNO")
    s PatientDR=info.%Get("PatientDR")
    s VisitID=info.%Get("VisitID")
    s VisitType=info.%Get("VisitType")
	s Config = "1"
	s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
	s DiagList = []
    s DiagnosisList=info.%Get("DiagnosisList")  //诊断信息列表

    s DiagFlag=""
    for i=0:1:(DiagnosisList.%Size()-1)
    {
        s DiagnosisInfo={}  //诊断信息
        d DiagnosisInfo.%Set("DataClass","DiagnosisInfo")

        
        s DiagnosisNames=##class(web.CDSS.IMP.ContrastDict).GetDiectName(DiagnosisList.%Get(i).%Get("DiagnosisName"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"诊断字典")  //诊断名称
        
        for DiagnosisIndex=1:1:$l(DiagnosisNames,"&%")
        {
	        s DiagnosisName= $p(DiagnosisNames,"&%",DiagnosisIndex)
	        s ProjectName = DiagnosisList.%Get(i).%Get("DiagnosisName")
			
			s DiagItemJson = {}
			d DiagItemJson.%Set("DiagnosisName",DiagnosisName)
			d DiagItemJson.%Set("ProjectName", ProjectName)
			d DiagItemJson.%Set("TableName", "WDT.CDSS.DiagnosisInfo")
			d ..GetWordsItemField("诊断名称",DiagnosisList.%Get(i),DiagItemJson)
			
			d DiagList.%Push(DiagItemJson)
			s DiagItemStr = DiagItemJson.%ToJSON()
			if DiagnosisName'=""
			{
				s ^TempPInfoItemData($j,PatientUserInfo,"西医诊断","DiagnosisName",DiagnosisName)=DiagItemStr
				s ^TempPInfoItemData($j,PatientUserInfo,"西医诊断症状","DiagnosisName",DiagnosisName)=DiagItemStr
			}
        }
    }
    s DiagListStr=DiagList.%ToJSON()
    s ^TempPInfoItemData($j,PatientUserInfo,"西医诊断")=DiagListStr
    s DiagSymptom = $g(^TempPInfoItemData($j,PatientUserInfo,"西医诊断症状"))
    if (DiagSymptom'="")&(DiagSymptom'="[]")
    {
	    if (DiagListStr'="")&(DiagListStr'="[]")
	    {
			s DiagSymptomUnion = "["_$e(DiagListStr,2,*-1)_","_$e(DiagSymptom,2,*-1)_"]"
			s ^TempPInfoItemData($j,PatientUserInfo,"西医诊断症状")=DiagSymptomUnion
	    }
	}
	else
	{
		s ^TempPInfoItemData($j,PatientUserInfo,"西医诊断症状")=DiagListStr
	}
	d ..SaveSatisfyIW("WDT.CDSS.DiagnosisInfo","DiagnosisName",IDNO,PatientDR,VisitID,VisitType)
    q ""
}

/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).CurrentAge("56931")
ClassMethod CurrentAge(date As %Date = "") As %Integer
{
    s age =$Select(date="":"",1:($ZD($H,8)-$ZD(date,8)\10000))
    q age
}

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:根据第三方诊断ID，去对照表中获取到我们的诊断编码
/// Table:
/// Input: DiagnosisId:诊断id
/// Return:标准版诊断信息
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).GetDiagNodeByDiagId()
ClassMethod GetDiagNodeByDiagId(DiagnosisId As %String) As %String
{
    q DiagnosisId
}

/// Creator:陈代雷
/// CreatDate:2020-06-09
/// Description:保存病例信息
/// Table:
/// Input: ProgressInfo : {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "1", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "ProgressNoteList": {"ProgressId": "病历唯一标识", "ProgressType": "病历类型", "ProgressTempleateID": "模板唯一标示", "ProgressTemplateName": "模板名称", "MsgType": "病历内容传递格式", "Message": "病历内容", "MessageList": [{"key": "主诉", "value": "今天发热，头痛，转移性右下腹痛"}, {"key": "现病史", "value": "现病史内容"}], "DoctorId": "开立医生ID", "DoctorName": "医生姓名", "CreateDeptCode": "开立科室代码", "CreateDeptName": "开立科室名称", "RecordTime": "病历记录时间"}}
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).SaveProgress(ProgressInfo)
ClassMethod SaveProgress(ProgressInfo As %String) As %String
{
    s info=[].%FromJSON(ProgressInfo)
    //s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptCode")_"^"_info.%Get("DeptName")_"^"  //调用后台接口的参数
    s PatientUserInfo=info.%Get("IDNO")
    s CaseJson={}
    d CaseJson.%Set("IDNO",info.%Get("IDNO"))
    d CaseJson.%Set("PatientDR",info.%Get("PatientDR"))
    d CaseJson.%Set("VisitID",info.%Get("VisitID"))
    d CaseJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d CaseJson.%Set("UserID",info.%Get("UserID"))
    d CaseJson.%Set("UserName",info.%Get("UserName"))
    d CaseJson.%Set("CTLocID",info.%Get("DeptCode"))
    d CaseJson.%Set("CTLocDesc",info.%Get("DeptName"))
    //d CaseJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
    s children=[]  //所有信息表
    ///基础信息表
    s PatientMaster={}  //基础信息字典
    d PatientMaster.%Set("DataClass","PatientMaster")
    s PatientMasterC=[]  ////基础信息详细内容
    s PatientMasterDict={}  //单个基础信息详细内容
    d PatientMasterDict.%Set("MedicareCardNum",info.%Get("IDNO")) //病人标识 //医保卡号
    d PatientMasterDict.%Set("IDCardNumber",info.%Get("IDNO")) //病人标识, //身份证号
    d PatientMasterDict.%Set("Name",info.%Get("Name"))   //姓名
    d PatientMasterDict.%Set("Sex",..ConvertSex(info.%Get("PatientInfo").%Get("Gender")))  //性别（性别病史）
    if (##class(%Library.TimeStamp).IsValid(info.%Get("PatientInfo").%Get("BirthDate")))
    {
    	s Age=..CurrentAge($zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))
    }
    else
    {
	    s Age=""
    }
    //s Age=($h-$zdh(info.%Get("PatientInfo").%Get("BirthDate"),3))/365
    d PatientMasterDict.%Set("Age",Age) //年龄
    d PatientMasterDict.%Set("Profession","") //职业（职业病史）
    d PatientMasterDict.%Set("Nation","") //民族
    d PatientMasterDict.%Set("Marriage","") //婚姻
    d PatientMasterDict.%Set("BloodGroup","") //血型
    d PatientMasterDict.%Set("Country","") //国籍
    d PatientMasterDict.%Set("Birthplace","") //籍贯
    d PatientMasterDict.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  			//出生日期		
    d PatientMasterDict.%Set("CurrentAddress",info.%Get("PatientInfo").%Get("CurrentAddress")) //现住址
    d PatientMasterDict.%Set("PhoneNumber","") //电话
    d PatientMasterC.%Push(PatientMasterDict)
    d PatientMaster.%Set("children",PatientMasterC)
    d children.%Push(PatientMaster)
    d CaseJson.%Set("Birthday",info.%Get("PatientInfo").%Get("BirthDate"))  //出生日期

    ///病例信息表
    s CaseInfo={}  //病例信息
    d CaseInfo.%Set("DataClass","PatientVisit")
    s CaseInfoC=[]  //病例信息详细内容
    s CaseList=info.%Get("ProgressNoteList")  //病例信息列表，医院数据
    s MRCode=CaseList.%Get("ProgressID")
    d CaseJson.%Set("MRCode",MRCode)
    s CaseInfoDict={}  //单个基础信息详细内容
    d CaseInfoDict.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType"))) //就诊类型（急诊、门诊、住院）
    d CaseInfoDict.%Set("TreatmentTime",CaseList.%Get("RecordTime")) //就诊时间
    d CaseInfoDict.%Set("VisitingDepartment",CaseList.%Get("CreateDeptName")) //就诊科室
    d CaseInfoDict.%Set("ComorbidityMarker","") //合并症标记
    d CaseInfoDict.%Set("TransferRecord","") //转科记录
    d CaseInfoDict.%Set("DischargeTime",CaseList.%Get("RecordTime")) //离院时间
    d CaseInfoDict.%Set("DischargeDepartment",CaseList.%Get("CreateDeptName")) //离院科室

    s MessageList=CaseList.%Get("MessageList")  //病历字典
    for i=0:1:(MessageList.%Size()-1)
    {
        if (MessageList.%Get(i).%Get("key")="主诉")
        {
	        d CaseInfoDict.%Set("ChiefCompSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //主诉概述
        }
        if (MessageList.%Get(i).%Get("key")="现病史")
        {
            d CaseInfoDict.%Set("CurrentMedHisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //现病史概述
        }
        if (MessageList.%Get(i).%Get("key")="既往史")
        {
            d CaseInfoDict.%Set("PastDiagnosisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //既往史概述
        }
        if (MessageList.%Get(i).%Get("key")="家族史")
        {
            d CaseInfoDict.%Set("FamilyHisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //家族史概述
        }
        if (MessageList.%Get(i).%Get("key")="个人史")
        {
            d CaseInfoDict.%Set("PersonalHisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //个人史概述
        }
        if (MessageList.%Get(i).%Get("key")="婚育史")
        {
            d CaseInfoDict.%Set("MarryHisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //婚育史概述
        }
        if (MessageList.%Get(i).%Get("key")="月经史")
        {
            d CaseInfoDict.%Set("MenstrualHisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //月经史概述
        }
        if (MessageList.%Get(i).%Get("key")="过敏史")
        {
            d CaseInfoDict.%Set("AllergyHisSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //过敏史概述
        }
        if (MessageList.%Get(i).%Get("key")="体格检查")
        {
            d CaseInfoDict.%Set("PhysicalExamSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //体格检查概述
        }
        if (MessageList.%Get(i).%Get("key")="转科检查")
        {
            d CaseInfoDict.%Set("SpecExamSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //转科检查概述
        }
        //新增诊断信息解析 2021-10-21
        if (MessageList.%Get(i).%Get("key")="初步诊断")
        {
	    	d CaseInfoDict.%Set("PrimaryDiag",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //初步诊断概述    
	    }
        if (MessageList.%Get(i).%Get("key")="确诊诊断")
        {
	    	d CaseInfoDict.%Set("DefiniteDiag",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value")))  //确诊诊断概述
	    }
        if (MessageList.%Get(i).%Get("key")="补充诊断")
        {
	    	d CaseInfoDict.%Set("SuppleDiag",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //补充诊断概述
	    }
        if (MessageList.%Get(i).%Get("key")="修正诊断")
        {
	    	d CaseInfoDict.%Set("CurrectionDiag",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //修正诊断概述   
	    }
	    //新增辅助检查信息解析 2021-12-03
	    if (MessageList.%Get(i).%Get("key")="辅助检查")
        {
	    	d CaseInfoDict.%Set("LabExamSum",##class(web.DHCBL.BDP.FunLib).TransLinefeed(MessageList.%Get(i).%Get("value"))) //修正诊断概述   
	    }
    }
    d CaseInfoC.%Push(CaseInfoDict)
    d CaseInfo.%Set("children",CaseInfoC)
    d children.%Push(CaseInfo)
	
	
    if (CaseInfoDict.%Get("PhysicalExamSum")'="")
    {
	    s PhysicalExamSum=##class(web.CDSS.MachineLearning.NLPProcessingData).SignInfoToNLP(CaseInfoDict.%Get("PhysicalExamSum"))
        ///体征信息表
        if PhysicalExamSum'="[]"
        {
	       	s PhysicalExamSum=[].%FromJSON(PhysicalExamSum)
	        s SignInfo={}  //体征信息
	        d SignInfo.%Set("DataClass","SignInfo")
	        s SignInfoC=[]  //体征信息详细内容
	        s SignList=info.%Get("ProgressNoteList")  //体征信息列表，医院数据
	        s SignInfoDict={}  //单个体征信息详细内容
	        ;s PhysicalExamSum=##class(web.CDSS.IMP.HospLinkRules).SplitPhysicalcheckToJson(CaseInfoDict.%Get("PhysicalExamSum"))
	        s PhysicalExamSum=[].%FromJSON(PhysicalExamSum)
	        d SignInfoDict.%Set("BodyTemperature","")  // 体温
	        d SignInfoDict.%Set("BloodPressure","")  // 血压
	        d SignInfoDict.%Set("Pulse","")  // 脉搏
	        d SignInfoDict.%Set("BreathFeature","")  // 呼吸
	        d SignInfoDict.%Set("HeartRate","")  // 心率
	        d SignInfoDict.%Set("Height","")  // 身高
	        d SignInfoDict.%Set("Weight","")  // 体重
	        for j=0:1:(PhysicalExamSum.%Size()-1)
	        {
	            s PSignInfo=PhysicalExamSum.%Get(j)
	            if (PSignInfo.%Get("key")="体温")
	            {
		            s BodyTemperature = PSignInfo.%Get("value")
		            s BodyTemperatureStr = BodyTemperature.%ToJSON()
	                s ^TempPInfoItemData($j,PatientUserInfo,"体温","BodyTemperature")=BodyTemperatureStr
	            }
	            if (PSignInfo.%Get("key")="脉搏")
	            {
	                d SignInfoDict.%Set("Pulse",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="呼吸")
	            {
	                d SignInfoDict.%Set("BreathFeature",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="血压")
	            {
	                d SignInfoDict.%Set("BloodPressure",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="心率")
	            {
	                d SignInfoDict.%Set("HeartRate",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="身高")
	            {
	                d SignInfoDict.%Set("Height",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="体重")
	            {
	                d SignInfoDict.%Set("Weight",PSignInfo.%Get("value"))
	            }
	        }
	        d SignInfoDict.%Set("MeasureDate","")  // 测量时间

	        d SignInfoDict.%Set("DiastolicBlood","")  // 舒张压
	        d SignInfoDict.%Set("SystolicBlood","")  // 收缩压

	        d SignInfoDict.%Set("OxygenSaturation","")  //血氧饱和度
	        d SignInfoDict.%Set("Pupil","")  // 瞳孔
	        d SignInfoDict.%Set("CornealReflex","")  // 角膜反射

	        d SignInfoDict.%Set("PassFlag","")  //同步标记（0为同步，1为新增）
	        d SignInfoC.%Push(SignInfoDict)
	        d SignInfo.%Set("children",SignInfoC)
	        d children.%Push(SignInfo)
        }
    }
    
    if (CaseInfoDict.%Get("CurrentMedHisSum")'="") //现病史中的体征信息存体征信息表
    {
	    s CurrentMedHisSum=##class(web.CDSS.MachineLearning.NLPProcessingData).SignInfoToNLP(CaseInfoDict.%Get("CurrentMedHisSum"))
        if (CurrentMedHisSum'="[]")
	    {
			s CurrentMedHisSum=[].%FromJSON(CurrentMedHisSum)	    
		    ///体征信息表
	        s SignInfo={}  //体征信息
	        d SignInfo.%Set("DataClass","SignInfo")
	        s SignInfoC=[]  //体征信息详细内容
	        s SignList=info.%Get("ProgressNoteList")  //体征信息列表，医院数据
	        s SignInfoDict={}  //单个体征信息详细内容
	        s CurrentMedHisSum=##class(web.CDSS.MachineLearning.NLPProcessingData).SignInfoToNLP(CaseInfoDict.%Get("CurrentMedHisSum"))
	        s CurrentMedHisSum=[].%FromJSON(CurrentMedHisSum)
	        d SignInfoDict.%Set("BodyTemperature","")  // 体温
	        d SignInfoDict.%Set("BloodPressure","")  // 血压
	        d SignInfoDict.%Set("Pulse","")  // 脉搏
	        d SignInfoDict.%Set("BreathFeature","")  // 呼吸
	        d SignInfoDict.%Set("HeartRate","")  // 心率
	        d SignInfoDict.%Set("Height","")  // 身高
	        d SignInfoDict.%Set("Weight","")  // 体重
	        for j=0:1:(CurrentMedHisSum.%Size()-1)
	        {
	            s PSignInfo=CurrentMedHisSum.%Get(j)
	            if (PSignInfo.%Get("key")="体温")
	            {
	                d SignInfoDict.%Set("BodyTemperature",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="脉搏")
	            {
	                d SignInfoDict.%Set("Pulse",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="呼吸")
	            {
	                d SignInfoDict.%Set("BreathFeature",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="血压")
	            {
	                d SignInfoDict.%Set("BloodPressure",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="心率")
	            {
	                d SignInfoDict.%Set("HeartRate",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="身高")
	            {
	                d SignInfoDict.%Set("Height",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="体重")
	            {
	                d SignInfoDict.%Set("Weight",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="收缩压")
	            {
	                d SignInfoDict.%Set("SystolicBlood",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="舒张压")
	            {
	                d SignInfoDict.%Set("DiastolicBlood",PSignInfo.%Get("value"))
	            }
	            if (PSignInfo.%Get("key")="血氧饱和度")
	            {
		            d SignInfoDict.%Set("OxygenSaturation",PSignInfo.%Get("value"))
		        }
		        if (PSignInfo.%Get("key")="口温")
	            {
		            d SignInfoDict.%Set("OralTemperature",PSignInfo.%Get("value"))
		        }
		        if (PSignInfo.%Get("key")="肛温")
	            {
		            d SignInfoDict.%Set("AnalTemperature",PSignInfo.%Get("value"))
		        }
	        }
	        d SignInfoDict.%Set("MeasureDate",$zdt($H,3))  // 测量时间
	        //d SignInfoDict.%Set("BodyTemperature",NLPSignInfo.%Get(0).%Get("sign_value").%Get("name"))  // 体温
	        //d SignInfoDict.%Set("BloodPressure",NLPSignInfo.%Get(3).%Get("sign_value").%Get("name"))  // 血压
	        //d SignInfoDict.%Set("DiastolicBlood","")  // 舒张压
	        //d SignInfoDict.%Set("SystolicBlood","")  // 收缩压
	        //d SignInfoDict.%Set("Pulse",NLPSignInfo.%Get(1).%Get("sign_value").%Get("name"))  // 脉搏
	        //d SignInfoDict.%Set("BreathFeature",NLPSignInfo.%Get(2).%Get("sign_value").%Get("name"))  // 呼吸
	        //d SignInfoDict.%Set("HeartRate","")  // 心率
	        //d SignInfoDict.%Set("OxygenSaturation","")  //血氧饱和度
	        d SignInfoDict.%Set("Pupil","")  // 瞳孔
	        d SignInfoDict.%Set("CornealReflex","")  // 角膜反射
	        //d SignInfoDict.%Set("Height",NLPSignInfo.%Get(4).%Get("sign_value").%Get("name"))  //身高
	        //d SignInfoDict.%Set("Weight",NLPSignInfo.%Get(5).%Get("sign_value").%Get("name"))  // 体重
	        d SignInfoDict.%Set("PassFlag","")  //同步标记（0为同步，1为新增）
	        d SignInfoC.%Push(SignInfoDict)
	        d SignInfo.%Set("children",SignInfoC)
	        d children.%Push(SignInfo)
	    }
	}
	
    s InpatientInfo={}  //其他在院医嘱信息
    d InpatientInfo.%Set("DataClass","InpatientInfo")
    s InpatientInfoC=[]  //详细内容
    s InpatientInfoDict={}  //单个详细内容
    d InpatientInfoDict.%Set("MRTempletName",CaseList.%Get("ProgressTempleateID")) //病例模板
    d InpatientInfoDict.%Set("MRNum","")  //病历顺序
    d InpatientInfoDict.%Set("MRClass","入院记录") //病历类型
    d InpatientInfoDict.%Set("MRFileNum","") //病历文件顺序
    d InpatientInfoDict.%Set("MRCode",MRCode) //病历编码
    d InpatientInfoDict.%Set("MRDesc",CaseList.%Get("Message")) //病历概述
    d InpatientInfoDict.%Set("UpdateDate",CaseList.%Get("RecordTime")) //更新时间
    d InpatientInfoDict.%Set("UpdateRemarks","") //更新说明
    d InpatientInfoC.%Push(InpatientInfoDict)
    d InpatientInfo.%Set("children",InpatientInfoC)
    d children.%Push(InpatientInfo)
    d CaseJson.%Set("children",children)

    s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
    s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(CaseJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
    s RationalResult=[].%FromJSON(RationalResult)
    s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(CaseJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
    s UnifomResult=[].%FromJSON(UnifomResult)
    s ^TMPSXW(1)=CaseJson.%ToJSON()
    s CaseJson=##Class(web.CDSS.MachineLearning.NLPProcessingData).GetStructedDataJson(CaseJson.%ToJSON())
    s CaseJson=[].%FromJSON(CaseJson)
    s TableArr=["ChiefCompInfo","CurrentMedHistory","PastDiagnosis","FamilyHisInfo","PersonalInfo","MarryInfo","MarryInfo","AllergyHistory","PhysicalExam","SpecExam"]
    for i=0:1:(CaseJson.%Size()-1)
    {
	    s PatientJson=CaseJson.%Get(i)
	    s PatientIterator=PatientJson.%GetIterator()
        while PatientIterator.%GetNext(.key,.value)
        {
	        if key="DataClass"
	        {
		        continue:PatientJson.%Get("DataClass")=""
                continue:'(TableArr.%IsDefined(PatientJson.%Get("DataClass")))
	        }
            if key="children"    //如果键值对中的键为"children"
            {
                s ChildrenArray=PatientJson.%Get("children")       //包含表名的children
	    		for j=0:1:(ChildrenArray.%Size()-1)
                {
	                s TalbeJson=ChildrenArray.%Get(j)
	    			s TalbleIterator=TalbeJson.%GetIterator()
	                while TalbleIterator.%GetNext(.key1,.value1)
			        {
				        if key1="DataClass"
				        {
					        continue:value1=""
			                continue:'(TableArr.%IsDefined(value))
				        }
			        }
	                d CaseJson.%Get(i).%Get("children").%Get(j).%Get("children").%Get(0).%Set("MRCode",MRCode)
	                //w CaseJson.%Get(i).%Get("children").%Get(j).%Get("children").%Get(0).%ToJSON(),!
                }
            }
        }
    }
    s CaseJson=CaseJson.%ToJSON()
    
    
    if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
    {
        q CaseJson
    }
    elseif(config="Y")  //有错误信息，但是允许强制交互
    {
        q CaseJson
    }
    else  //有错误信息，不允许强制交互
    {
        for i=0:1:UnifomResult.%Size()-1
        {
            d RationalResult.%Push(UnifomResult.%Get(i))
        } 
        q RationalResult.%ToJSON()  
    }
}

/// Creator:李得原
/// CreatDate:2022-07-06
/// Description:获取识别词项目字典中的字段
/// Table:
/// Input: 
/// Return:
/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).GetWordsItemField()
ClassMethod GetWordsItemField(Desc As %String, ByRef JsonGet, ByRef JsonSet)
{
	q:Desc="" ""
	s Desc=$zcvt(Desc,"U")
    s ItemRowid=0
    for
    {
        s ItemRowid=$o(^CT.WDT.CDSS.WordsItemI("DescIndex"," "_Desc,ItemRowid))
        q:ItemRowid=""

        s ChildRowid=0
        for
        {
            s ChildRowid = $o(^CT.WDT.CDSS.WordsItemI("ParCatIdx",ItemRowid,ChildRowid))
            q:ChildRowid=""
            
            s FieldNames=$lg($g(^CT.WDT.CDSS.WordsItemD(ChildRowid)),7)
            s FieldNames = $tr(FieldNames,"&*","|")
            for FieldIndex=1:1:$l(FieldNames,"|")
            {
	            s FieldName = $p(FieldNames,"|",FieldIndex)
	            continue:FieldName=""
	            s FieldValue = JsonGet.%Get(FieldName)=""
            	if FieldValue'=""
            	{
	            	d JsonSet.%Set(FieldName,FieldValue)
            	}
	        }
        }
    }
    q JsonSet
}

/// Creator:李得原
/// CreatDate:2020-06-09
/// Description:同步医嘱信息
/// Table:
/// Input: CaseInfo : {"IDNO": "患者主索引", "PatientDR": "病人标识", "VisitID": "就诊次", "Name": "患者姓名", "UserID": "医生ID", "UserName": "医生姓名", "DeptCode": "科室编码", "DeptName": "科室名称", "PatientInfo": {"Gender": "性别", "BirthDate": "出生日期", "PregnancyStatus": "妊娠状态"}, "OrderEntry": {"OrderID": "医嘱唯一标识", "OrderClass": "医嘱类型", "OrderFlag": "医嘱 操作标识", "OrderType": "医嘱分类", "CreatTime": "医嘱创建时间", "StopTime": "医嘱作废时间", "DoctorId": "医生唯一标识", "DoctorName": "医生姓名", "CreateDeptCode": "开立科室代码", "CreateDeptName": "开立科室名称", "GroupSequence": "医嘱组顺序", "OrderCode": "医嘱代码", "OrderContent": "医嘱内容", "Dosage": "给药剂量", "Unit": "剂量单位", "Frequency": "频率", "Specification": "规格", "Pathway": "给药方式", "Sample": "样本", "Position": "部位", "Level": "手术等级", "IncisionType": "切口类型", "Anesthesia": "麻醉方式", "PreoperativeDiagnose": "术前诊断"}}
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).SynchronizeOrder(OrderInfo)
ClassMethod SynchronizeOrder(OrderInfo As %String) As %String
{
	
    s info=[].%FromJSON(OrderInfo)
	s Config = "1"
	s IDNO = info.%Get("IDNO")
	s PatientDR = info.%Get("PatientDR")
	s VisitID = $tr(info.%Get("VisitID"),0)
	
	s VisitType=3
	s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
   	s VisitType = ..ConvertVisitType(info.%Get("VisitType"))
    s OrderInfoC=[]  //病例信息详细内容
    s AllOrderEntry=info.%Get("OrderEntry")  //医嘱信息列表，医院数据
    
    s TmpDrugList = []
    s TmpExamList = []
    s TmpLabList = []
    s TmpOperationList = []
    s TmpNurseList = []
    
    
    for i=0:1:(AllOrderEntry.%Size()-1)
    {
        s OrderEntry=AllOrderEntry.%Get(i)
        s OrderInfoDict={}  //单个基础信息详细内容
        s OrderType=OrderEntry.%Get("OrderType")  //医嘱分类
        s OrderClass=OrderEntry.%Get("OrderClass")  //医嘱类型
        
        //2021-12-02
        if (OrderType=10)
        {
	       	//检查
	    	if $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent")))
	    	{
		    	s OrderType=2 	
		    }
		    //检验项目
		    elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查检验",OrderEntry.%Get("OrderContent")))
		    {
				s OrderType=3    
			}
			//药品
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=1	
			}
			//护理
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理",OrderEntry.%Get("OrderContent")))
			{
				s OrderType=5	
			}
			//手术
			elseif $d(^CT.WDT.CDSS.ContrastDictI("IntDictDescIndex",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"手术",OrderEntry.%Get("OrderContent")))
        	{
	        	s OrderType=4	
	        }
	    }
        ///处方信息（药品）
        if (OrderType=1)
        {
            s DrugNames = ##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"药品字典") //药品名称
            if DrugNames'=""
            {
	            for DrugIndex=1:1:$l(DrugNames,"&%")
	            {
		            s DrugName=$p(DrugNames,"&%",DrugIndex)
		            s DrugInfoDict = {}
		            d DrugInfoDict.%Set("DrugName",DrugName)
		            
		            d ..GetWordsItemField("药物名称",.OrderEntry,.DrugInfoDict)

		            d DrugInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent"))
		            d DrugInfoDict.%Set("TableName","WDT.CDSS.DrugInfo")
		            
		            d TmpDrugList.%Push(DrugInfoDict)
					s ^TempPInfoItemData($j,PatientUserInfo,"药品","DrugName",DrugName)=DrugInfoDict.%ToJSON()
	            }
				d ..SaveSatisfyIW("WDT.CDSS.DrugInfo","DrugName",IDNO,PatientDR,VisitID,VisitType)
            }
        }
        ///检查
        elseif (OrderType=2)
        {
            s ExamNames=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检查项目字典") //检查名称
			if ExamNames'=""
			{
				for ExamIndex=1:1:$l(ExamNames,"&%")
				{
					s ExamName=$p(ExamNames,"&%",ExamIndex)
					s ExamInfoDict={}  //单个详细内容
					d ExamInfoDict.%Set("ExamName", ExamName)
					d ..GetWordsItemField("检查项目名称",.OrderEntry,.ExamInfoDict)
					d ExamInfoDict.%Set("ProjectName",OrderEntry.%Get("OrderContent"))
					d ExamInfoDict.%Set("TableName","WDT.CDSS.ExamInfo")
					d TmpExamList.%Push(ExamInfoDict)
					s ^TempPInfoItemData($j,PatientUserInfo,"检查","ExamName",ExamName)=ExamInfoDict.%ToJSON()
					
				}
				d ..SaveSatisfyIW("WDT.CDSS.ExamInfo","ExamName",IDNO,PatientDR,VisitID,VisitType)
			}
        }
        ///检验
        elseif (OrderType=3)
        {
  			
            s InspectionNames = ##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"检验项目字典") //检验大项名称
            if InspectionNames'=""
            {
	            for InspectionIndex=1:1:$l(InspectionNames,"&%")
	            {
		            s InspectionName=$p(InspectionNames,"&%",InspectionIndex)
			        s LabInfoDict={} 
		            d LabInfoDict.%Set("InspectionName", InspectionName)
		            d LabInfoDict.%Set("ProjectName", OrderEntry.%Get("OrderContent"))
		            d LabInfoDict.%Set("TableName", "WDT.CDSS.LabInfo")
		            
					d ..GetWordsItemField("检验医嘱名称",.OrderEntry,.LabInfoDict)
		            
		            d TmpLabList.%Push(LabInfoDict)
		            s ^TempPInfoItemData($j,PatientUserInfo,"检验","InspectionName",InspectionName)=LabInfoDict.%ToJSON()  
		        }

	            d ..SaveSatisfyIW("WDT.CDSS.LabInfo","InspectionName",IDNO,PatientDR,VisitID,VisitType)
            }
            
        }
        ///手术
        elseif (OrderType=4)
        {
            s OperNames=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"手术操作字典") //手术名称
            if OperNames'=""
            {
	            for OperIndex=1:1:$l(OperNames,"&%")
	            {
		            s OperName=$p(OperNames,"&%",OperIndex)
		            s OperationInfoDict={}  //单个详细内容  
		            s ProjectName=OrderEntry.%Get("OrderContent") //20211209
		            d OperationInfoDict.%Set("OperName",OperName)
		            d OperationInfoDict.%Set("ProjectName",ProjectName)
		            d OperationInfoDict.%Set("TableName","WDT.CDSS.OperationInfo")
					d ..GetWordsItemField("手术名称",.OrderEntry,.OperationInfoDict)
					d TmpOperationList.%Push(OperationInfoDict)
					s ^TempPInfoItemData($j,PatientUserInfo,"手术","OperName",OperName)=OperationInfoDict.%ToJSON()
	            }
	            d ..SaveSatisfyIW("WDT.CDSS.OperationInfo","OperName",IDNO,PatientDR,VisitID,VisitType)
            }
        }

        ///护理
        elseif (OrderType=5)
        { 
            s NursingItemNames=##class(web.CDSS.IMP.ContrastDict).GetDiectName(OrderEntry.%Get("OrderContent"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"护理医嘱字典")
            if NursingItemNames'=""
            {
	            for NursingItemIndex=1:1:$l(NursingItemNames,"&%")
	            {
		            s NursingItemName=$p(NursingItemNames,"&%",NursingItemIndex)
		            s NursingInfoDict={}  //单个详细内容
		            s ProjectName=OrderEntry.%Get("OrderContent")
		            
		            d NursingInfoDict.%Set("NursingItemName", NursingItemName)
		            d NursingInfoDict.%Set("ProjectName", ProjectName)
		            d NursingInfoDict.%Set("TableName","WDT.CDSS.NursingInfo")
		            d ..GetWordsItemField("护理项目名称",.OrderEntry,.NursingInfoDict)
		            d TmpNurseList.%Push(NursingInfoDict)
		            s NursingInfoDictStr=NursingInfoDict.%ToJSON()
		            
		            s ^TempPInfoItemData($j,PatientUserInfo,"护理","NursingItemName",NursingItemName)=NursingInfoDictStr
	            }
            }
            d ..SaveSatisfyIW("WDT.CDSS.NursingInfo","NursingItemName",IDNO,PatientDR,VisitID,VisitType)
        }
    }
     s ^TempPInfoItemData($j,PatientUserInfo,"药品")=TmpDrugList.%ToJSON()
     if $g(^TempPInfoItemData($j,PatientUserInfo,"检查"))=""
     {
     	s ^TempPInfoItemData($j,PatientUserInfo,"检查")=TmpExamList.%ToJSON()
     }
     else
     {
	     s TmpExam=TmpExamList.%ToJSON()
	     s TmpData=$g(^TempPInfoItemData($j,PatientUserInfo,"检查"))
	     s TmpListStr = $e(TmpData,2,*-1)_","_$e(TmpExam,2,*-1)
	     s ^TempPInfoItemData($j,PatientUserInfo,"检查")=TmpListStr
	 }
     s ^TempPInfoItemData($j,PatientUserInfo,"手术")=TmpOperationList.%ToJSON()
     if $g(^TempPInfoItemData($j,PatientUserInfo,"检验"))=""
     {
     	s ^TempPInfoItemData($j,PatientUserInfo,"检验")=TmpLabList.%ToJSON()
     }
     else
     {
	     s TmpLab=TmpLabList.%ToJSON()
	     s TmpData=^TempPInfoItemData($j,PatientUserInfo,"检验")
	     s TmpListStr = $e(TmpData,2,*-1)_","_$e(TmpLab,2,*-1)
	     s ^TempPInfoItemData($j,PatientUserInfo,"检验")=TmpListStr
	 }
     s ^TempPInfoItemData($j,PatientUserInfo,"护理")=TmpNurseList.%ToJSON()
     q ""
}

/// Creator:陈代雷
/// CreatDate:2020-06-11
/// Description:检验报告更新
/// Table:
/// Input: JsonStr : 基础信息+各种报告json串 tableName：表名
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).SaveRealTimeInfo(JsonStr,tableName)
ClassMethod SaveRealTimeInfo(JsonStr As %String, tableName As %String) As %String
{
    s info=[].%FromJSON(JsonStr)
    s DealedJson={}
    d DealedJson.%Set("IDNO",info.%Get("IDNO"))
    d DealedJson.%Set("PatientDR",info.%Get("PatientDR"))
    d DealedJson.%Set("VisitID",info.%Get("VisitID"))
    d DealedJson.%Set("VisitType",..ConvertVisitType(info.%Get("VisitType")))
    d DealedJson.%Set("UserID",info.%Get("UserID"))
    d DealedJson.%Set("UserName",info.%Get("UserName"))
    d DealedJson.%Set("CTLocID",info.%Get("DeptCode"))
    d DealedJson.%Set("CTLocDesc",info.%Get("DeptName"))
    //d DealedJson.%Set("Config",##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416"))
    s children=[]  //所有信息表
    s dict={}  //每一类信息表
    d dict.%Set("DataClass",tableName)
    s childrenC=[]  //每一类信息所有数据
    d childrenC.%Push(info.%Get("字段名"))
    d dict.%Set("children",childrenC)
    d children.%Push(dict)
    d DealedJson.%Set("children",children)
    s config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020061601")
    s RationalResult=##Class(web.CDSS.MachineLearning.DataVerification).DataRationalisation(DealedJson.%ToJSON())  //对第三方数据json串进行数据合理性校验，包括（数据类型是否匹配，主键是否存在等）
    s RationalResult=[].%FromJSON(RationalResult)
    s UnifomResult=##Class(web.CDSS.MachineLearning.DataVerification).DataConsistency(DealedJson.%ToJSON())  //对第三方数据json串进行基本信息、就诊信息数据一致性和临床信息完整性校验
    s UnifomResult=[].%FromJSON(UnifomResult)
    if (RationalResult.%Size()=0)&(UnifomResult.%Size()=0)  //如果没有错误信息
    {
        q DealedJson.%ToJSON()      
    }
    elseif(config="Y")  //有错误信息，但是允许强制交互
    {
        q DealedJson.%ToJSON()
    }
    else  //有错误信息，不允许强制交互
    {
        for i=0:1:UnifomResult.%Size()-1
        {
            d RationalResult.%Push(UnifomResult.%Get(i))
        } 
        q RationalResult.%ToJSON()  
    }
}

// 2022-05-30

// 患者数据组装临时Global

ClassMethod CreatePatientGlobal(Contents As %String) As %String
{
	s Contents = [].%FromJSON(Contents)
	s PatientFlag = ""
	for index=0:1:Contents.%Size()-1
	{
		s Content=Contents.%Get(index)
		s action= Content.%Get("action")
		s info=Content.%Get("data")
		s json=info.%ToJSON()
		s UserName = info.%Get("UserName")
		s UserLoc = info.%Get("DeptName")
		//s Config=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSdyn20200416")
		s Config = "1"
	    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
		s PatientFlag = PatientUserInfo
	    s result=""

	    if (action="INITIALIZE_PATIENT_INFORMATION")  //初始化患者信息
	    {
	        d ..GetBasicInfo(json)
	    }
	    
	    if (action="SYNCHRONOUS_DIAGNOSTIC_INFORMATION")  //同步诊断信息
	    {
		    //s end1 = $p($zdt($now(),3,1,4),":",*)
	        d ..SynchronousDiagInfo(json)
	        //s end2 = $p($zdt($now(),3,1,4),":",*)
	        //s a=end2-end1
	        //w "diag cost:"_a,!
	    }
	    
	    if (action="SAVE_MEDICAL_RECORD_INFORMATION")  //保存病例信息
	    {
	        s result=##class(web.CDSS.MachineLearning.InteractiveInterface).SaveProgress(json)
	        d ..ProcessRecordPatient(result)
	    }
		if (action="DHCDSSOperationInfo")  //同步术后报告
		{
			d ..SyncOperationReport(json)
		}
	    if (action="SYNCHRONIZE_PATIENT_ORDERS")  //同步患者医嘱信息
	    {
	        d ..SynchronizeOrder(json)
	    }
	    if (action="SAVE_Exam_INFORMATION")  //演示系统检查报告更新
	    {
	        s result=..SaveExamJsonInfo(json)
	    }
	    if (action="SAVE_Lab_INFORMATION")  //演示系统检验报告更新
	    {
	        s result=..SaveLabJsonInfo(json)
	    }
		
		if (action="CATCH_ORDER_WARNING")	//输血接口
	    {
			s result=..SaveBloodTransInfo(json)
		}
		
		if (action="ALLERGY_INFORMATION")    //过敏信息
		{
			s result=..SynchronousAllergyInfo(json)	
		}
		if (action="SYNCHRONOUS_SIGN_INFORMATION")   //体征信息
		{
			s result=..SaveSignJsonInfo(json)
		}
		if (action="RATING_SCALE_INFORMATION")
		{
			s result=..SaveRatingScaleJsonInfo(json)
		}
		
		continue:result=""
		
	}
	q PatientFlag
}

// 术后报告

ClassMethod SyncOperationReport(json)
{
	if (json="{}")||(json="")
	{
		q ""
	}
	s TmpOperList=[]
    s InfoJson={}.%FromJSON(json)
	s Config = "1"
	s PatientUserInfo=InfoJson.%Get("IDNO")_"^"_InfoJson.%Get("PatientDR")_"^"_$tr(InfoJson.%Get("VisitID"),0)_"^"_..ConvertVisitType(InfoJson.%Get("VisitType"))_"^"_InfoJson.%Get("UserID")_"^"_InfoJson.%Get("UserName")_"^"_InfoJson.%Get("DeptName")_"^"_Config  //调用后台接口的参数
    s IDNO = InfoJson.%Get("IDNO")
	s PatientDR  = InfoJson.%Get("PatientDR")
	s VisitID = InfoJson.%Get("VisitID")
	s VisitType = InfoJson.%Get("VisitType")
    s jsons=InfoJson.%Get("OperationInfo")
    for OperIndex=0:1:jsons.%Size()-1
    {
	    s OperInfo=jsons.%Get(OperIndex)
        s OperationInfoDict={}  //单个详细内容  
        
        s OperName=OperInfo.%Get("OperName") //20211209
        continue:OperName=""
        d OperationInfoDict.%Set("OperName",OperName)
        d OperationInfoDict.%Set("ProjectName",OperName)
        d OperationInfoDict.%Set("TableName","WDT.CDSS.OperationInfo")
		d ..GetWordsItemField("手术名称",.OperInfo,.OperationInfoDict)
		
		if $d(^TempPInfoItemData($j,PatientUserInfo,"手术","OperName",OperName))
		{
			s TmpData=$g(^TempPInfoItemData($j,PatientUserInfo,"手术","OperName",OperName))
			s TmpDataJson={}.%FromJSON(TmpData)
			s UnionJson = ..MergeTwoJsonField(TmpDataJson,OperationInfoDict)
			s ^TempPInfoItemData($j,PatientUserInfo,"手术","OperName",OperName)=UnionJson.%ToJSON()
			s OperationInfoDict=UnionJson
		}
		else
		{
			s ^TempPInfoItemData($j,PatientUserInfo,"手术","OperName",OperName)=OperationInfoDict.%ToJSON()
		}
		d TmpOperList.%Push(OperationInfoDict)
	}
	s TmpList=$g(^TempPInfoItemData($j,PatientUserInfo,"手术"))
	s TmpOperListStr=TmpOperList.%ToJSON()
	if (TmpList'="")&(TmpList'="[]")
	{
		s ^TempPInfoItemData($j,PatientUserInfo,"手术")="["_$e(TmpList,2,*-1)_","_$e(TmpOperListStr,2,*-1)_"]"
	}
	else
	{
		s ^TempPInfoItemData($j,PatientUserInfo,"手术")=TmpOperListStr
	}
	
	d ..SaveSatisfyIW("WDT.CDSS.OperationInfo","OperName",IDNO,PatientDR,VisitID,VisitType)
}

ClassMethod MergeTwoJsonField(A, B)
{
	s UnionJson={}
	s AJson=A.%GetIterator()     //遍历第一层{}
	while AJson.%GetNext(.AKey,.AValue)
	{
		if AValue'=""
		{
			d UnionJson.%Set(AKey,AValue)
		}
		else
		{
			if B.%Get(AKey)'=""
			{
				d UnionJson.%Set(AKey,B.%Get(AKey))
			}
		}
	}
	q UnionJson
}

/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).CreateDOIndex()
ClassMethod CreateDOIndex() As %String
{
	d ..CreateTypeIndex()
	hang 1
	d ..GetRequiredIW("sds")
	q ""
}

/// 构建推荐类型相关的规则和识别词
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).CreateTypeIndex()
ClassMethod CreateTypeIndex() As %String
{
	k ^CDSSMatchRule
	hang 1
	s RecomTypeMap={"推荐鉴别诊断":"RecommendDifferDiag","推荐检验检查":"RecommendLabExam","推荐临床指征评估表":"RecommendAssess","推荐科室关联评估表":"RecommendAssess","推荐评估表":"RecommendAssess","推荐护理处置":"RecommendNursing","推荐护理措施":"RecomNursingTreat", "推荐治疗方案":"AssistTreat","推荐治疗方案-药品":"AssistTreat","推荐治疗方案-手术":"AssistTreat","推荐确诊":"RecomDiag","检查合理性":"LabExamWarning","检验合理性":"LabExamWarning","手术合理性":"OperationWarning","手术并发症":"OperationComplication","护理/处置合理性":"NursingWarning","输血合理性":"BloodWarning","药品合理性":"DrugWarning","出院指导":"OutHospital","诊断合理性":"DiseaseWarning","推荐治疗方案-处置":"AssistTreat"}
	s RuleRowid=0
	for
	{
		s RuleRowid=$o(^CT.WDT.CDSS.RuleNodeI("RuleDRTypeIndex",RuleRowid))
		q:RuleRowid=""
		s ProVision=$lg($g(^CT.WDT.CDSS.RuleDictD(RuleRowid)),14)
		s:ProVision="" ProVision="dhcc"
		s RuleStatus=$LISTGET($G(^CT.WDT.CDSS.RuleDictD(RuleRowid)),8)
		if (RuleStatus'="已上线")&(RuleStatus'="审核通过")
		{
			continue
		}

		s RuleType = ""
		for
		{
			s RuleType = $o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid, RuleType))
			q:RuleType=""
			
			s FlowNum = 0
			for
			{
				s FlowNum=$o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid, RuleType, FlowNum))
				q:FlowNum=""
				
				s IWRowids=""
				s FinalType=""
				
				s NodeRowid=0
				for
				{
					s NodeRowid = $o(^CT.WDT.CDSS.RuleNodeI("TypeChartIndex",RuleRowid, RuleType, FlowNum, NodeRowid))
					q:NodeRowid=""
					
					s RuleRowid = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),2)     //RuleDR
					s RuleTypeDR = $lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),10)   //RuleType
					s NodeTypeDR=$lg($g(^CT.WDT.CDSS.RuleNodeD(NodeRowid)),5) 
					s:RuleTypeDR="" RuleTypeDR=-100000000000000
					continue:NodeTypeDR=""
					s NodeTypeDesc = $lg($g(^CT.WDT.CDSS.NodeTypeD(NodeTypeDR)),3) //获取节点类型
					if (NodeTypeDesc="开始")||(NodeTypeDesc="结束")
					{
						continue
					}

					if (NodeTypeDesc="基本信息-年龄")||(NodeTypeDesc="基本信息-性别")||(NodeTypeDesc="主要条件-诊断")||(NodeTypeDesc="主要条件-识别词")||(NodeTypeDesc="否定条件-识别词")||(NodeTypeDesc="否定条件-诊断")
					{
						s IWRowid=0
						for
						{
							s IWRowid=$o(^CT.WDT.CDSS.RuleIndexI("RuleTypeFlowIndex",RuleRowid,RuleTypeDR,FlowNum,IWRowid))
							q:IWRowid=""
							if IWRowids'[IWRowid
							{
								s:IWRowids'="" IWRowids=IWRowids_"[A]"_IWRowid
								s:IWRowids="" IWRowids=IWRowid
							}
						}

					}	
					else
					{
						s FinalType=RecomTypeMap.%Get(NodeTypeDesc)
					}

				}
				if FinalType'=""
				{
					s ^CDSSMatchRule(ProVision, FinalType, RuleRowid, RuleTypeDR,FlowNum)=IWRowids
				}
			}

		}
	}
	hang 1
	q ""
}

/// 构建推荐类型相关的规则和识别词
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).GetRequiredIW("sds")
ClassMethod GetRequiredIW(ProVision As %String)
{
	k ^RequireIW
	s RecomType=""
	for
	{
		s RecomType=$o(^CDSSMatchRule(ProVision,RecomType)) q:RecomType=""
		s RuleRowid=0
		for
		{
			s RuleRowid=$o(^CDSSMatchRule(ProVision,RecomType,RuleRowid)) q:RuleRowid=""
			s RuleType=""
			for
			{
				s RuleType=$o(^CDSSMatchRule(ProVision,RecomType,RuleRowid,RuleType)) q:RuleType=""
				s FlowNum=0
				for
				{
					s FlowNum=$o(^CDSSMatchRule(ProVision,RecomType,RuleRowid,RuleType,FlowNum)) q:FlowNum=""
					s IWString=^CDSSMatchRule(ProVision,RecomType,RuleRowid,RuleType,FlowNum)
					for i=1:1:$l(IWString,"[A]")
					{
						
						s IWRowid=$p(IWString,"[A]",i)
						continue:IWRowid=""
						s ^RequireIW(ProVision,RecomType,IWRowid)=""
					}
				}
			}
		}
		
	}
	q ""
}

/// CreatDate:2020-06-15
/// Description:第三方调用数据接口
/// Table:
/// Input: action:命令 json：json信息串
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).DHCHisInterface(a,b,c,d)
ClassMethod DHCHisInterface(Contents As %String, RecomType As %String = "", ProVision As %String = "", SingleDisease As %String = "") As %String
{
	s ^TMP("test-a")=Contents
	s ^TMP("test-d")=SingleDisease
	s ^TMP("test-c")=ProVision
	s ^TMP("test-b")=RecomType
	s start = $p($zdt($now(),3,1,4),":",*)
	s ExecutionTimeSt=$p($ZDT($NOW(),3,1,4),":",*)
	if (Contents="")||(Contents="[]")
	{
		q ""
	}
    s PatientUserInfo=..CreatePatientGlobal(Contents)
	s RuleRowid=""
	s SingleDisease=$zstrip(SingleDisease,"<>W")
	if ((SingleDisease'="")&(SingleDisease'=$c(0)))
	{
		if $d(^CT.WDT.CDSS.RuleDictI("DescIndex"," "_$zconvert(SingleDisease,"U")))
		{
			s RuleRowid=$o(^CT.WDT.CDSS.RuleDictI("DescIndex"," "_$zconvert(SingleDisease,"U"),0))
		}
		if RuleRowid=""
		{
			q ""
		}
	}
	
	try
    {
    	d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo,RecomType, ProVision,RuleRowid)
    }
    catch e
    {

	}
	k ^TempPInfoItemData($j,PatientUserInfo)
    q PatientUserInfo
}

/// CreatDate:2022-05-29
/// Description：体征信息存到临时Global
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend2).SaveSignJsonInfo()
ClassMethod SaveSignJsonInfo(json As %String) As %String
{
    s json=[].%FromJSON(json)
    s Array=""
    //获得推送内容
    s SignFlag=json.%Get("SignFlag")
    s IDNO=json.%Get("IDNO")
    s PatientDR=json.%Get("PatientDR")
    s VisitID=json.%Get("VisitID")
	;s:VisitID="" VisitID=$o(^WDT.CDSS.SignInfo("PatVisDRIndex",PatientDR,""),-1)   //获取最后一次就诊次
    s VisitType=json.%Get("VisitType")
    s PatientUserInfo=json.%Get("IDNO")_"^"_json.%Get("PatientDR")_"^"_$tr(json.%Get("VisitID"),0)_"^"_..ConvertVisitType(json.%Get("VisitType"))_"^"_json.%Get("UserID")_"^"_json.%Get("UserName")_"^"_json.%Get("DeptName")_"^"_1  //调用后台接口的参数
    s BodyTemperature=json.%Get("BodyTemperature")
    s:BodyTemperature'="" Array("BodyTemperature")=BodyTemperature

    s BloodPressure=json.%Get("BloodPressure")
	s:BloodPressure'="" Array("BloodPressure")=BloodPressure
	
    s Pulse=json.%Get("Pulse")
    s:Pulse'="" Array("Pulse")=Pulse

    s BreathFeature=json.%Get("BreathFeature")
    s:BreathFeature'="" Array("BreathFeature")=BreathFeature
    
    s HeartRate=json.%Get("HeartRate")
    s:HeartRate'="" Array("HeartRate")=HeartRate
    
    s OxygenSaturation=json.%Get("OxygenSaturation")
    s:OxygenSaturation'="" Array("OxygenSaturation")=OxygenSaturation

    s Pupil=json.%Get("Pupil")
    s:Pupil'="" Array("Pupil")=Pupil
    
    s CornealReflex=json.%Get("CornealReflex")
    s:CornealReflex'="" Array("CornealReflex")=CornealReflex
    
    s Height=json.%Get("Height")
    s:Height'="" Array("Height")=Height

    s Weight=json.%Get("Weight")
    s:Weight'="" Array("Weight")=Weight

    
    s DiastolicBlood=json.%Get("DiastolicBlood")
  	 s:DiastolicBlood'="" Array("DiastolicBlood")=DiastolicBlood
    
    s SystolicBlood=json.%Get("SystolicBlood")
    s:SystolicBlood'="" Array("SystolicBlood")=SystolicBlood
	
	s Mapping ={"BodyTemperature":"体温", "BloodPressure":"血压", "BreathFeature":"呼吸", "Pulse":"脉搏", "HeartRate":"心率", "OxygenSaturation":"血氧饱和度","Pupil":"瞳孔", "CornealReflex":"角膜反射", "Height":"身高", "Weight":"体重", "DiastolicBlood":"舒张压", "SystolicBlood":"收缩压","HeartRate":"心率"}
	s SignsList = []
	s Field=""
	for
	{
		s Field=$o(Array(Field))
		q:Field=""
		s TmpList = []
		d ..SaveSatisfyIW("WDT.CDSS.SignInfo",Field,IDNO,PatientDR,VisitID,VisitType)
		s Desc = Mapping.%Get(Field)
		s Value = Array(Field)
		s Json = {}
		d Json.%Set(Field,Value)
		d SignsList.%Push(Json)
		d TmpList.%Push(Json)
		s ^TempPInfoItemData($j,PatientUserInfo,"体征",Desc)=Desc
		s ^TempPInfoItemData($j,PatientUserInfo,Desc) = TmpList.%ToJSON()
		s ^TempPInfoItemData($j,PatientUserInfo,Desc,Field,Value)=Json.%ToJSON()
	}
	s ^TempPInfoItemData($j,PatientUserInfo,"体征")=SignsList.%ToJSON()	    

    q ""
}

ClassMethod SynchronousAllergyInfo(allergyjson)
{
	s flag=0
    s info=[].%FromJSON(allergyjson)
    s IDNO=info.%Get("IDNO")
    s PatientDR=info.%Get("PatientDR")
    s VisitID=info.%Get("VisitID")
	;s:VisitID="" VisitID=$o(^WDT.CDSS.SignInfo("PatVisDRIndex",PatientDR,""),-1)   //获取最后一次就诊次
    s VisitType=info.%Get("VisitType")
    s AllergyJson={}
    s TmpAllergyList = []

    s children=[]  //所有信息表
    s ChildrenList=info.%Get("AllergyList")  //过敏信息列表
    s Config = "1"
	s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_Config  //调用后台接口的参数
    for i=0:1:(ChildrenList.%Size()-1)
    {
    	s TmpAllergyInfo={}  //过敏信息

        s AllergySourceName=ChildrenList.%Get(i).%Get("AllergySourceName")  //过敏源名称
        if AllergySourceName'=""
        {
	        s flag=1
	        d TmpAllergyInfo.%Set("AllergySourceName", AllergySourceName)
	        d TmpAllergyInfo.%Set("TableName","WDT.CDSS.AllergyHistory")
	        d TmpAllergyList.%Push(TmpAllergyInfo)
	        s ^TempPInfoItemData($j,PatientUserInfo,"过敏史","AllergySourceName",AllergySourceName)=TmpAllergyInfo.%ToJSON()
        }
    }
    if flag=1
    {
	    s ^TempPInfoItemData($j,PatientUserInfo,"过敏史")=TmpAllergyList.%ToJSON()
	    d ..SaveSatisfyIW("WDT.CDSS.AllergyHistory","AllergySourceName",IDNO,PatientDR,VisitID,VisitType)
    }
    q ""
}

/// Creator:陈代雷
/// CreatDate:2020-07-15
/// Description:性别数字转换成文字描述
/// Table:
/// Input: SexCode:性别代码
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend2).ConvertSex(1)
ClassMethod ConvertSex(SexCode As %String) As %String
{
    s sex=$CASE(SexCode,0:"女",1:"男",2:"其他",:"其他")
    q sex
}

/// Creator:陈代雷
/// CreatDate:2021-01-25
/// Description:病历类型代码转描述
/// Table:
/// Input: ProgressCode:病历类型代码
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).ConvertProgress(1)
ClassMethod ConvertProgress(ProgressCode As %String) As %String
{
    s ProgressType=$CASE(ProgressCode,0:"门诊病历",
	1:"入院记录",
	2:"首次病程记录",
	3:"日常病程",
	4:"查房记录",
	5:"术前小结",
	6:"术后首次病程",
	7:"阶段小结",
	8:"会诊记录",
	9:"出院记录",
	10:"手术记录",
	11:"24小时入出院记录",
	12:"上级医师查房记录",
	13:"转入记录",
	14:"转出记录",
	15:"术前访视记录",
	16:"抢救记录",
	17:"死亡记录",
	18:"术前讨论",
	19:"疑难病例讨论记录",
	20:"交班记录",
	21:"接班记录",
	22:"有创操作记录",
	23:"死亡讨论记录",
	24:"急诊留观记录",:"入院记录")
    q ProgressType
}

/// Creator:陈代雷
/// CreatDate:2020-08-13
/// Description:性别数字转换成文字描述
/// Table:
/// Input: SexCode:性别代码
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).CDRConvertSex(1)
ClassMethod CDRConvertSex(SexCode As %String) As %String
{
    s sex=$CASE(SexCode,2:"女",1:"男",0:"其他",9:"其他",:"其他")
    q sex
}

/// Creator:陈代雷
/// CreatDate:2020-07-16
/// Description:就诊类型编码转换成数字
/// Table:
/// Input: VisitTypeCode:就诊类型代码
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).ConvertVisitType(1)
ClassMethod ConvertVisitType(VisitTypeCode As %String) As %String
{
    s VisitType=$CASE(VisitTypeCode,1:"急诊",2:"门诊",3:"住院",:"")
    q VisitType
}

/// Creator:Xuwenhu
/// CreatDate:2021-12-09
/// Description:解析输血信息，返回json
/// Table:
/// Input: bloodjson 输血信息
/// Return:输血信息表json串
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).SaveBloodTransInfo(bloodjson)
ClassMethod SaveBloodTransInfo(bloodjson As %String) As %String
{
	s flag = 0
	s info=[].%FromJSON(bloodjson)
	s IDNO = info.%Get("IDNO")
    s PatientDR  = info.%Get("PatientDR")
    s VisitID = info.%Get("VisitID")
    s VisitType = info.%Get("VisitType")
    s PatientUserInfo=info.%Get("IDNO")_"^"_info.%Get("PatientDR")_"^"_$tr(info.%Get("VisitID"),0)_"^"_..ConvertVisitType(info.%Get("VisitType"))_"^"_info.%Get("UserID")_"^"_info.%Get("UserName")_"^"_info.%Get("DeptName")_"^"_1  //调用后台接口的参数
    s BloodJson={}
    d BloodJson.%Set("IDNO",info.%Get("IDNO"))
    d BloodJson.%Set("PatientDR",info.%Get("PatientDR"))
    d BloodJson.%Set("VisitID",info.%Get("VisitID"))
    d BloodJson.%Set("VisitType",info.%Get("VisitType"))
    s children=[]  //所有信息表
    s BloodInfoList = []
    s ChildrenList=info.%Get("BloodTransInfo")  //输血信息列表
    for i=0:1:(ChildrenList.%Size()-1)
    {
          //单个输血信息详细内容
        s BloodTransClasses = ##class(web.CDSS.IMP.ContrastDict).GetDiectName( ChildrenList.%Get(i).%Get("BloodTransClass"),##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSScdl2020072401"),"输血品字典")  		//输血品名称
        if BloodTransClasses'=""
        {
	        for BloodIndex=1:1:$l(BloodTransClasses,"&%")
	        {
		        s BloodTransClass=$p(BloodTransClasses,"&%",BloodIndex)
		        s flag = 1
		        s BloodInfoDict={}
		        d BloodInfoDict.%Set("BloodTransClass",BloodTransClass)
		 	
		        d BloodInfoDict.%Set("ProjectName",ChildrenList.%Get(i).%Get("BloodTransClass"))			//项目名称
		        d BloodInfoDict.%Set("TableName","WDT.CDSS.BloodTransInfo")
		        d ..GetWordsItemField("输血品名称",ChildrenList.%Get(i),BloodInfoDict)
		       	d BloodInfoList.%Push(BloodInfoDict)
		       	s ^TempPInfoItemData($j,PatientUserInfo,"输血",BloodTransClass)=BloodInfoDict.%ToJSON()
	        }
        }
       	
   	}
   	if flag=1
   	{
	   	s ^TempPInfoItemData($j,PatientUserInfo,"输血")=BloodInfoList.%ToJSON()
		d ..SaveSatisfyIW("WDT.CDSS.LabInfo","LabResult",IDNO,PatientDR,VisitID,VisitType)
   	}
 
	q ""
}

/// Creator:阚延新
/// CreatDate:2021-08-19
/// Description：用于内部检查报告入库
/// Input：{ "GroupFlag":"医嘱号","ExamCode":"检查编码","ExamName":"检查名称","ExamResult":"检查结果","PartDR":"部位,可以直接传位置或者根据部位表传id或者传空","ExecuteTime":"执行时间","ReportTime":"报告时间","Remarks":"备注"}
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveExamJsonInfo(^TMP("KYXExam"))
ClassMethod SaveExamJsonInfo(Info As %String) As %String
{
	
	if (Info="{}")||(Info="")
	{
		q ""
	}
	s TmpExamList=[]
    s InfoJson={}.%FromJSON(Info)
	s Config = "1"
	s PatientUserInfo=InfoJson.%Get("IDNO")_"^"_InfoJson.%Get("PatientDR")_"^"_$tr(InfoJson.%Get("VisitID"),0)_"^"_..ConvertVisitType(InfoJson.%Get("VisitType"))_"^"_InfoJson.%Get("UserID")_"^"_InfoJson.%Get("UserName")_"^"_InfoJson.%Get("DeptName")_"^"_Config  //调用后台接口的参数
    s IDNO = InfoJson.%Get("IDNO")
	s PatientDR  = InfoJson.%Get("PatientDR")
	s VisitID = InfoJson.%Get("VisitID")
	s VisitType = InfoJson.%Get("VisitType")
    s jsons=InfoJson.%Get("ExamList")
    s ExecuteTime = $zdt($h,3)
    s flag =0
    for j=0:1:jsons.%Size()-1
    {
		s json = jsons.%Get(j)
	    s ExamName =json.%Get("ExamName")
		
	    //获得推送内容
	    s ExamResult = json.%Get("ExamResult")
	    s ExamResultDesc = json.%Get("ExamResultDesc") 
	    s ExamResultDescs = ExamResult_ExamResultDesc
	    s ExamResultDescNLP=##class(web.CDSS.MachineLearning.Inteplatform).GetStructedDataAPI(ExamResultDescs)
	    s ExamResultDescNLP=$REPLACE(ExamResultDescNLP,"""","'")
	    if ExamResultDescNLP'=""
	    {
	    	s ExamResultDescFormal=##class(web.CDSS.MachineLearning.Inteplatform).CollectResultToNLP(ExamResultDescNLP)
	    }
	    else
	    {
		    s ExamResultDescFormal=""
		}
		
	    s ExamResultFlag = json.%Get("ExamResultFlag") 
	    s ExamResultNum = json.%Get("ExamResultNum") 
	    s:ExecuteTime="" ExecuteTime = json.%Get("ExecuteTime") 
	    s Remarks = json.%Get("Remarks")
	    s PartDR =json.%Get("PartDR")

	    s size=$l(ExamResultDescFormal,";")
	    
	    for i=1:1:size
	    {
		    s ExamResults=$p(ExamResultDescFormal,";",i)
		    s ExamResultD=$p(ExamResults,"%%",1)
		    s SymptomCore=$p(ExamResults,"%%",2)
		    s SymProperty=$p(ExamResults,"%%",3)
		    s CDSS2PartDR=$p(ExamResults,"%%",4)
		    s PositionWordDR=$p(ExamResults,"%%",5)
		    //s:PositionWordDR'="" PositionWordDR=$o(^CT.WDT.CDSS.PositionWordI("DescIndex"," "_PositionWordDR,0))
			
			s TmpExam = {}
			d TmpExam.%Set("ExamName", ExamName)
			
			d TmpExam.%Set("ExamResultDesc", ExamResultD)
			
			d TmpExam.%Set("ExamResultFlag", ExamResultFlag)
			d TmpExam.%Set("ExamResult", ExamResultD)
			d TmpExam.%Set("SymProperty", SymProperty)
			if CDSS2PartDR'=""
			{
				d TmpExam.%Set("Part", CDSS2PartDR)
			}
			else
			{
				d TmpExam.%Set("Part", PartDR)
			}
			d TmpExam.%Set("PositionWord",PositionWordDR )
			d TmpExam.%Set("TableName","WDT.CDSS.ExamInfo")
			d TmpExamList.%Push(TmpExam)
			
			if ExamResultD'=""
			{
				for ExamIndex=1:1:$l(ExamResultD,"&%")
				{
					s ExamResultItem=$p(ExamResultD,"&%",ExamIndex)
					try
					{
						s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果","ExamResult",ExamResultItem)=TmpExam.%ToJSON()
						s flag=1
					}
					catch e
					{
						//w e.Name,!
					}
				}
			}
			
		}
	}
	
	s OriginExamList = $g(^TempPInfoItemData($j,PatientUserInfo,"检查"))
	s TmpExamListStr = TmpExamList.%ToJSON()
	if (OriginExamList'="") || (OriginExamList'="[]")
	{
		if (OriginExamList'="[]") & (OriginExamList'="")
		{
			s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果")="["_$e(TmpExamListStr,2,*-1)_","_$e(OriginExamList,2,*-1)_"]"
		}
		else
		{
			s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果")=TmpExamListStr
		}
	}
	else
	{
		s ^TempPInfoItemData($j,PatientUserInfo,"检查检验结果")=TmpExamListStr
	}
	if flag=1
	{
		d ..SaveSatisfyIW("WDT.CDSS.ExamInfo","ExamResult",IDNO,PatientDR,VisitID,VisitType)
	}
		
    q ""
}

/// Creator:阚延新
/// CreatDate:2021-08-19
/// Description：用于内部检验报告入库
/// Input：{"GroupFlag":"01","InspectionCode":"001","InspectionName":"k1","LabResultInfo":[{"LabItemCode":"检验小项号","LabItemName":"x1","LabResult":"0.1","LabResultFlag":"阴性阳性","Unit":"单位","Reference":"参考范围"},{"LabItemCode":"检验小项号","LabItemName":"检验小项名称","LabResult":"检验结果","LabResultFlag":"阴性阳性","Unit":"单位","Reference":"参考范围"}],"ExecuteTime":"执行时间","ReportTime":"报告时间","Remarks":"备注"}
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveLabJsonInfo(^TMP("KYXLab"))
ClassMethod SaveLabJsonInfo(Info As %String) As %String
{
 
 	s TmpLabList = []
	if (Info="")||(Info="{}")
	{
		q ""
	}
    s InfoJson={}.%FromJSON(Info)
	s Flag = 0
	s Config = "1"
	s PatientUserInfo=InfoJson.%Get("IDNO")_"^"_InfoJson.%Get("PatientDR")_"^"_$tr(InfoJson.%Get("VisitID"),0)_"^"_..ConvertVisitType(InfoJson.%Get("VisitType"))_"^"_InfoJson.%Get("UserID")_"^"_InfoJson.%Get("UserName")_"^"_InfoJson.%Get("DeptName")_"^"_Config  //调用后台接口的参数
    s IDNO = InfoJson.%Get("IDNO")
    s PatientDR  = InfoJson.%Get("PatientDR")
    s VisitID = InfoJson.%Get("VisitID")
    s VisitType = InfoJson.%Get("VisitType")
    
    s GroupSequence ="TMP001"
    s InspectionCode = "TMP001"
    s jsons = InfoJson.%Get("LabList")
    for i=0:1:jsons.%Size()-1
    {
	    s json = jsons.%Get(i)
		s InspectionName =json.%Get("InspectionName")
		if InspectionName'=""
		{
			s Flag = 1
			s Unit = json.%Get("Unit")
			s ExecuteTime = $zdt($h,3)
			s ReportTime = $ZDT($H,3)
			s Remarks = ""
	    	s PassFlag = ""
	    	s LabResultFlag = ""
	    	s ChildItem=json.%Get("LabResultInfo")
		 	for j=0:1:(ChildItem.%Size()-1)
			{
				s LabItemCode="TMP001"
				s LabItemName=ChildItem.%Get(j).%Get("LabItemName")
				s LabResult=ChildItem.%Get(j).%Get("LabResult")
				s LabResultFlag=ChildItem.%Get(j).%Get("LabResultFlag")
				s:(LabResultFlag'="预期寿命")&(LabResultFlag'="阴性")&(LabResultFlag'="阳性")&(LabResultFlag'="已治愈")&(LabResultFlag'="原因性质待查")&(LabResultFlag'="存在状态未明确")&(LabResultFlag'="弱阳性")&(LabResultFlag'="强阳性")&(LabResultFlag'="减弱")&(LabResultFlag'="消失")&(LabResultFlag'="亢进")&(LabResultFlag'="迟钝")&(LabResultFlag'="升高")&(LabResultFlag'="降低") LabResultFlag=""
				
				s Unit=ChildItem.%Get(j).%Get("Unit")
				
				s TmpLab={}
				d TmpLab.%Set("InspectionName", InspectionName)
				//d TmpLab.%Set("LabResult", LabResult)
				//d TmpLab.%Set("Unit", Unit)
				//d TmpLab.%Set("LabResultFlag", LabResultFlag)
				d ..GetWordsItemField("检验项目名称",ChildItem.%Get(j),TmpLab)
				d TmpLab.%Set("TableName","WDT.CDSS.LabInfo")
				d TmpLabList.%Push(TmpLab)
				s ^TempPInfoItemData($j,PatientUserInfo,"检验结果","InspectionName",InspectionName)=TmpLab.%ToJSON()	
			}
		}
	}
	if Flag=1
	{
		s ^TempPInfoItemData($j,PatientUserInfo,"检验结果")=TmpLabList.%ToJSON()
		d ..SaveSatisfyIW("WDT.CDSS.LabInfo","LabResult",IDNO,PatientDR,VisitID,VisitType)
	}
	q ""
}

/// Creator:Fanwenkai	
/// CreatDate:2021-12-27
/// Description：用于内部体征信息入库时触发识别词更新
/// Input：json
/// Output: 
/// w ##class(web.CDSS.MachineLearning.Inteplatform).SaveSignJsonInfo()
ClassMethod SaveSatisfyIW(TableName, fieldkey, IDNOValue, PatientDRValue, VisitIDValue, VisitTypeValue) As %String
{
	s:VisitTypeValue=3 VisitTypeValue="住院"
	//判断该字段是否要触发识别词
    s TableRowID = $o(^CT.WDT.CDSS.DataTableDictI("TableNameIndex",TableName,fieldkey,""))
    q:TableRowID="" ""
    s PMDataType=$lg($g(^CT.WDT.CDSS.DataTableDictD(TableRowID)),14)
    if (PMDataType'="")
	{
		s PMDataTypeNum=$l(PMDataType,"&")
		for i=1:1:(PMDataTypeNum)
		{
			
			s DataType=$p(PMDataType,"&",i)
			continue:$d(^WDT.CDSS.PatPMTypeIndexI("PatVisDRUpTypeIndex",PatientDRValue,VisitIDValue,1,DataType))
			s PMobj=##class(WDT.CDSS.PatPMTypeIndex).%New()
			s PMobj.IDNO=IDNOValue
			s PMobj.PatientDR=PatientDRValue
			s PMobj.VisitID=VisitIDValue
			s PMobj.VisitType=VisitTypeValue
			s PMobj.DataType=DataType
			s PMobj.IsLastUpdate=1
			s sc= PMobj.%Save()
			d PMobj.%Close()
		}
	}
	//d ##class(web.CDSS.IdentifyWords.GetPatientIW).GetSatisfyIW(PatientUserInfo)
}

/// Creator:wuzhe	
/// CreatDate:20220530
/// Description：用于数据中台疑似疾病2.0取患者信息
/// Input：
/// Output: 
/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend2).GetPatientData()
ClassMethod GetPatientData(Contents As %String) As %String
{
	if (Contents="")||(Contents="[]")
	{
		q ""
	}
	s PatientInfo = ..CreatePatientGlobal(Contents)
	// 1.从临时Global ^TempPInfoItemData取值，组成json串
	
	// 2. kill ^TempPInfoItemData
	
	// 3. 返回患者信息的json串
}

/// Creator:wuzhe	
/// CreatDate:20220530
/// Description：
/// Input：Contents：处理完后的患者信息
/// Output: 
/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend2).DealPatietnData(^TMP("ldy"))
ClassMethod DealPatietnData(Contents As %String) As %String
{
	s PatientInfo = ..CreatePatientGlobal(Contents)
	// 1.从临时Global ^TempPInfoItemData取值，组成json串 包括主诉、现病史、
	s JsonRes = {}
	s Type=""
	for
	{
		s Type=$o(^TempPInfoItemData($j,PatientInfo,Type))
		q:Type=""
		if $g(^TempPInfoItemData($j,PatientInfo,Type))'=""
		{
			s Value = ^TempPInfoItemData($j,PatientInfo,Type)
			d JsonRes.%Set(Type,Value)
		}

	}
	
	kill ^TempPInfoItemData($j,PatientInfo)
	
#;	s PatientIterator=JsonRes.%GetIterator()     //遍历{}
#;	while PatientIterator.%GetNext(.key,.value)
#;	{
#;		if (key="检查")||(key="检验")
#;		{
#;			w value,!
#;#;			for i=0:1:value.%Size()-1   //遍历列表
#;#;			{
#;#;				s PatientJson=PatientArray.%Get(i)
#;#;				w PatientJson,!
#;#;			} 
#;		}
#;		
#;	}
	
	s JsonStr = JsonRes.%ToJSON()
	s JsonStr=$replace(JsonStr,"\","")
	//q ""
	q JsonStr
}

/// Creator:wz
/// CreatDate:2022-06-06
/// Description：推荐疑似疾病2.0单双症状逻辑
/// 入参：SymptomsString：症状字符串 Age：年龄 Gender：性别
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).SingleSymptomLogicV2("") 
ClassMethod SingleSymptomLogicV2(SymptomsString As %String, Age As %String, Gender As %String) As %String
{
	s SymptomsArray=[].%FromJSON(SymptomsString)
	
	s Symptoms=""
	s SymList=""
	s Count=0
	for i=0:1:SymptomsArray.%Size()-1
	{
		s TempSym=SymptomsArray.%Get(i)
		s Count=Count+1
		s SymList(TempSym)=""
		
		s:Symptoms'="" Symptoms=Symptoms_"^^^"_TempSym
		s:Symptoms="" Symptoms=TempSym
	}
	
	S RuleCode=0
	for
	{
		s RuleCode=$o(^CT.WDT.CDSS.SingleSymptomRuleI("TotalIndex",Count,RuleCode))    //获取症状个数为Count个的索引
		q:RuleCode=""
		
		s RuleRowid=$o(^CT.WDT.CDSS.SingleSymptomRuleI("TotalIndex",Count,RuleCode,0))
		s RuleGender=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),9)    //性别
		if RuleGender'=""
		{
			continue:RuleGender'=Gender   //性别不匹配
		}
		s MinAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),5)
		s MinAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),6)
		
		s MaxAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),7)
		s MaxAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),8)
		if MinAge'=""
		{
			continue:Age=""              //如果当前患者年龄没获取到
			s Exp=Age_MinAgeOpera_MinAge
			if @Exp
			{
				
			}
			else
			{
				continue
			}
		}
		if MaxAge'=""
		{
			continue:Age=""           //如果当前患者年龄没获取到
			s Exp=Age_MaxAgeOpera_MaxAge
			if @Exp
			{}
			else
			{
				continue
			}
		}
		
		s flag="1"
		s SymptomList=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),4)
		for j=1:1:$listlength(SymptomList)
		{
			s RuleSymptom=$lg(SymptomList,j) 
			continue:RuleSymptom=""
			if '$d(SymList(RuleSymptom)) 
			{
				s flag="0"
				q
			}
		}
		continue:flag="0"
		s RuleDiseases=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),10) //疾病集合
		
		s Result=""
		for m=1:1:$listlength(RuleDiseases)
		{
			s Disease=$lg(RuleDiseases,m)
			
			s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
			s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),2)
			s:Result'="" Result=Result_"[N]"_DiseaseName_"[A]"_DiseaseCode
			s:Result="" Result=DiseaseName_"[A]"_DiseaseCode
		}
		s Res = Result_"**"_Symptoms
		return Res
	}
	return "0"
}

// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).DeletePatientInfo("TMPAPI326341")

ClassMethod DeletePatientInfo(IDNO As %String)
{
	if IDNO'=""
	{
		s Rowid=""
		for
		{
			s Rowid=$o(^WDT.CDSS.PatientRecomInfoI("IDNOIndex",IDNO,Rowid)) q:Rowid=""
			d ##class(WDT.CDSS.PatientRecomInfo).%DeleteId(Rowid)
		}
		s IWRowid=""
		for
		{
			s IWRowid=$o(^WDT.CDSS.PatTriggerIWI("IDNOIndex"," "_IDNO,IWRowid)) q:IWRowid=""
			d ##class(WDT.CDSS.PatTriggerIW).%DeleteId(IWRowid)
		}
		s RuleRowid=""
		for
		{
			s RuleRowid=$o(^WDT.CDSS.PatTriggerRuleI("IDNOIndex"," "_IDNO,RuleRowid)) q:RuleRowid=""
			d ##class(WDT.CDSS.PatTriggerRule).%DeleteId(RuleRowid)
		}
		
	}
	q ""
}

/// w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).GetPatientInfo("TMPAPI2895","推荐治疗方案") 
ClassMethod GetPatientInfo(IDNO As %String, Type As %String) As %String
{
	s result=[]
	if Type'="RecordGender"
	{
		s Rowid=""
		for
		{
			s Rowid=$o(^WDT.CDSS.PatientRecomInfoI("IDNOIndex",IDNO,Rowid)) q:Rowid=""
			s InterfaceReturn = $lg($g(^WDT.CDSS.PatientRecomInfoD(Rowid)),7)
			s InterfaceName= $lg($g(^WDT.CDSS.PatientRecomInfoD(Rowid)),6)
			if Type[InterfaceName
			{
				s RecomJson=[].%FromJSON(InterfaceReturn)

				d result.%Push(RecomJson.%Get(0))
				
			}
		} 
	}
	else
	{
		s result = []
		s Rowid=""
		for
		{
			s Rowid=$o(^WDT.CDSS.PatientRecomInfoI("IDNOIndex",IDNO,Rowid)) q:Rowid=""
			s RecomContent = $lg($g(^WDT.CDSS.PatientRecomInfoD(Rowid)),7)
			s InterfaceName= $lg($g(^WDT.CDSS.PatientRecomInfoD(Rowid)),6)
			continue:InterfaceName["推荐"
			continue:InterfaceName["鉴别"
			continue:InterfaceName["出院"
			continue:InterfaceName["阻断"
			s RecomJson=[].%FromJSON(RecomContent)
			if RecomJson.%Get(0).%Get("InterfaceValue").%Size()'=0
			{
				d result.%Push(RecomJson.%Get(0))
			}
		}
	}
	q result.%ToJSON()
}

/// Creator:李得原
/// CreatDate:2022-11-16
/// Description:访问日志记录
/// Table:
/// Input: 
/// Return:
/// Others:w ##class(web.CDSS.MiddlePlatform.InterfaceBackend).RecordLog()
/// ,"IsError":str(e),"AccessGroup":access_group,"Params":recom_params,"Result":""}
ClassMethod RecordLog(LogInfo As %String) As %String
{
	if (LogInfo="")||(LogInfo=$c(0))
	{
		q ""
	}
	try
	{
		s LogInfoJson={}.%FromJSON(LogInfo)
		s IP=LogInfoJson.%Get("AccessIP")
		s AccessTime=LogInfoJson.%Get("AccessTime")
		s AccessInterface=LogInfoJson.%Get("AccessInterface")
		s AccessGroup=LogInfoJson.%Get("AccessGroup")
		s IsError=LogInfoJson.%Get("IsError")
		s Params =LogInfoJson.%Get("Params")
		s AccessUserName=LogInfoJson.%Get("AccessUserName")
		s Result =LogInfoJson.%Get("Result")
		s obj =##class(WDT.CDSS.AccessLog).%New()
		s obj.AccessGroup=AccessGroup
		s obj.AccessInterface=AccessInterface
		s obj.AccessIP=IP
		s obj.AccessTime=AccessTime
		s obj.AccessUserName=AccessUserName
		s obj.IsError=IsError
		s obj.Params=Params
		s obj.Result=Result
		s sc =obj.%Save()
		if $$$ISERR(sc)
		{
			w $system.OBJ.DisplayError(sc),!
		}
		
	}
	catch e{
		w "error:"_e,!
	}
	q ""
}

}

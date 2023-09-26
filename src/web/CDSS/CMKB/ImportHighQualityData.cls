/// 名称:优质病历导入数据
/// 描述:优质电子病历字典导入
/// 编写者:wuzhe
/// 编写日期:2023-03-23
Class web.CDSS.CMKB.ImportHighQualityData Extends %RegisteredObject
{

/// Function: 相似病历（优质病历）Excel数据过NLP并导入
/// Creater:wz
/// CreatDate:2023-04-13
/// Table: 
/// Input: RecordString：一条数据，【AND】作为分隔符   RowID：病历ID Flag：导入为空，新增为"add"，修改为"modify"
/// Output: True：导入成功，False：导入失败
/// Others:w ##class(web.CDSS.CMKB.ImportHighQualityData).SaveHighQualityRecord("001【AND】呼吸与危重症医学科一部【AND】男【AND】75岁【AND】出生地：*** 民族：汉族国籍：中国 婚姻状况：已婚 职业：其他 家庭地址（户口所在地）：***  邮编：***【AND】2019-11-07【AND】2019-11-07 15:16【AND】患者本人【AND】刺激性干咳1月，发热9天【AND】患者1月前出现咳嗽，多为刺激性干咳【AND】既往有下肢深静脉血栓病史【AND】【AND】生于河北省廊坊市【AND】婚姻史适龄结婚年龄,配偶子女健康状况。婚姻史] 。【AND】父亲有支气管扩张，否认家族性遗传病史。【AND】体温36.5℃脉搏62次／分呼吸20次／分血压107／67mmHg。【AND】【AND】2019年11月03日胸部CT左肺占位伴感染【AND】【AND】1、左肺病变性质待查  2、肺部感染  3、下肢深静脉血栓 【AND】【AND】【AND】下肢深静脉血栓，行抗凝治疗后自行停药，未复查。【AND】***")
/// 前端按列读取Excel（xlsx），一列一条数据，【AND】作为分隔符
ClassMethod SaveHighQualityRecord(RecordString As %String, RowID As %String = "", Flag As %String = "") As %String
{
	q:RecordString="" "Fasle"
	//s:RecordString["009" ^TMP("wz")=RecordString
	kill ^TEMP("CDSSNOTDiag") //存储无对照，或有对照不在CDSS字典的诊断
	if RecordString[""""
	{
		s RecordString=$replace(RecordString,"""","")
	}
	s RecordContenDict={} //病历内容字典
	s AllFactorArray=[] //诊断因子列表
	s Result="False"
	s Diagnosis="" //诊断
	s EMRType="入院记录" //病历类型
	s VisitType="住院" //就诊类型
	s RecordNumber=$p(RecordString,"【AND】",1) //病历编号
	s Loc=$p(RecordString,"【AND】",2) //入院科室
	s Sex=$p(RecordString,"【AND】",3) //性别
	s Age=$p(RecordString,"【AND】",4) //年龄
	s OtherInfo=$p(RecordString,"【AND】",5) //其他信息
	s HospitalDate=$p(RecordString,"【AND】",6) //入院日期
	s RecordDate=$p(RecordString,"【AND】",7) //记录时间
	s Expressionist=$p(RecordString,"【AND】",8) //病史陈述者
	s ChiefCompSum=$p(RecordString,"【AND】",9) //主诉
	s CurrentMedHisSum=$p(RecordString,"【AND】",10) //现病史
	s PastDiagnosisSum=$p(RecordString,"【AND】",11) //既往史
	s SystemReview=$p(RecordString,"【AND】",12) //系统回顾
	s PersonalHisSum=$p(RecordString,"【AND】",13) //个人史
	s MarryHisSum=$p(RecordString,"【AND】",14) //婚育史
	s FamilyHisSum=$p(RecordString,"【AND】",15) //家族史
	s PhysicalExamSum=$p(RecordString,"【AND】",16) //体格检查
	s SpecialInspection=$p(RecordString,"【AND】",17)  //特殊检查
	s LabExamSum=$p(RecordString,"【AND】",18) //辅助检查
	s MedicalRecord=$p(RecordString,"【AND】",19) //病历摘要
	s PrimaryDiag=$p(RecordString,"【AND】",20) //初步诊断
	s DiagnosticBasis=$p(RecordString,"【AND】",21) //诊断依据
	s DiagTreatPlan=$p(RecordString,"【AND】",22) //诊疗计划
	s MedSituation=$p(RecordString,"【AND】",23) //当前治疗疾病及用药情况
	s DoctorSignature=$p(RecordString,"【AND】",24) //医生签名
	q:(EMRType="")||(VisitType="")||(ChiefCompSum="") "False^主诉为空"
	
	//统计病历内容
	if ChiefCompSum["主诉："
	{
		s ChiefCompSum=$p(ChiefCompSum,"主诉：",2)
	}
	elseif ChiefCompSum["主 诉："
	{
		s ChiefCompSum=$p(ChiefCompSum,"主 诉：",2)
	}
	if CurrentMedHisSum["现病史："
	{
		s CurrentMedHisSum=$p(CurrentMedHisSum,"现病史：",2)
	}
	if PastDiagnosisSum["既往史："
	{
		s PastDiagnosisSum=$p(PastDiagnosisSum,"既往史：",2)
	}
	if PersonalHisSum["个人史："
	{
		s PersonalHisSum=$p(PersonalHisSum,"个人史：",2)
	}
	if MarryHisSum["婚育史："
	{
		s MarryHisSum=$p(MarryHisSum,"婚育史：",2)
	}
	if FamilyHisSum["家族史："
	{
		s FamilyHisSum=$p(FamilyHisSum,"家族史：",2)
	}
	d RecordContenDict.%Set("主诉",ChiefCompSum)
	d RecordContenDict.%Set("现病史",CurrentMedHisSum)
	d RecordContenDict.%Set("既往史",PastDiagnosisSum)
	d RecordContenDict.%Set("系统回顾",SystemReview)
	d RecordContenDict.%Set("个人史",PersonalHisSum)
	d RecordContenDict.%Set("婚育史",MarryHisSum)
	d RecordContenDict.%Set("家族史",FamilyHisSum)
	d RecordContenDict.%Set("体格检查",PhysicalExamSum)
	d RecordContenDict.%Set("特殊检查",SpecialInspection)
	d RecordContenDict.%Set("辅助检查",LabExamSum)
	d RecordContenDict.%Set("病历摘要",MedicalRecord)
	d RecordContenDict.%Set("初步诊断",PrimaryDiag)
	d RecordContenDict.%Set("诊断依据",DiagnosticBasis)
	d RecordContenDict.%Set("诊疗计划",DiagTreatPlan)
	d RecordContenDict.%Set("当前治疗疾病及用药情况",MedSituation)
	d RecordContenDict.%Set("医生签名",DoctorSignature)
	if PrimaryDiag'=""
	{
		s Diagnosis=..GetStructedDataAPI(PrimaryDiag) //初步诊断过NLP
	}
	//保存优质病历
	s BasicInfo=""
	//病历类型【AND】就诊类型【AND】病历编号【AND】入院科室【AND】性别【AND】年龄【AND】其他信息【AND】入院日期【AND】记录时间【AND】病情陈述者【AND】医生签名
	s BasicInfo=EMRType_"【AND】"_VisitType_"【AND】"_RecordNumber_"【AND】"_Loc_"【AND】"_Sex_"【AND】"_Age_"【AND】"_OtherInfo_"【AND】"_HospitalDate_"【AND】"_RecordDate_"【AND】"_Expressionist_"【AND】"_DoctorSignature
	s EMRContent=RecordContenDict.%ToJSON() //病历内容
	s RecordID="False"
	s RecordID=..SaveHighQualityEMR(BasicInfo,EMRContent,RowID,Flag)
	//w RecordID,!
	q:(RecordID["False")||(RecordID="") RecordID //"False"
	s Result="True"
	//保存优质病历关联诊断
	if (Diagnosis'="")&(Diagnosis'="[]")&(Diagnosis'["error")
	{
		try
		{
			s DiagSaveResult=..SaveDiagnosis(RecordID,Diagnosis,Flag)
			//w DiagSaveResult,!
		}
		catch e
		{
		}
	}
	//保存优质病历关联诊断因子
	if ChiefCompSum'=""
	{
		s ChiefStructArray=..GetStructDataEMR("主诉",ChiefCompSum) //主诉过NLP
		if ChiefStructArray.%ToJSON()'="[]"
		{
			d AllFactorArray.%Push(ChiefStructArray)
		}
	}
	if CurrentMedHisSum'=""
	{
		s CurrentMedStructArray=..GetStructDataEMR("现病史",CurrentMedHisSum) //现病史过NLP
		if CurrentMedStructArray.%ToJSON()'="[]"
		{
			d AllFactorArray.%Push(CurrentMedStructArray)
		}
	}
	if PhysicalExamSum'=""
	{
		s PhysicalExamStructArray=..GetStructDataEMR("体格检查",PhysicalExamSum) //体格检查过NLP
		if PhysicalExamStructArray.%ToJSON()'="[]"
		{
			d AllFactorArray.%Push(PhysicalExamStructArray)
		}
	}
	if AllFactorArray.%ToJSON()'="[]"
	{
		try
		{
			s AllFactoJSON=AllFactorArray.%ToJSON()
			s FactorSaveResult=..SaveFactor(RecordID,AllFactoJSON,Flag)
			//w FactorSaveResult,!
		}
		catch e
		{
		}
	}
	q Result
}

/// Function：保存优质病历-支持导入，新增，修改
/// Creater:wz
/// CreatDate:2023-03-29
/// Table: CT.WDT.CDSS.HighQualityEMR 优质病历字典表
/// Input: BasicInfo：基础信息，EMRContentSTR：病历内容，EMRID：病历ID Flag：空：导入，新增：add
///        基础信息：病历类型【AND】就诊类型【AND】病历编号【AND】入院科室【AND】性别【AND】年龄【AND】其他信息【AND】入院日期【AND】记录时间【AND】病情陈述者
/// Output: True：保存成功，False：保存失败
/// Others:w ##class(web.CDSS.CMKB.ImportHighQualityData).SaveHighQualityEMR("","")
ClassMethod SaveHighQualityEMR(BasicInfo As %String, EMRContentSTR As %String, EMRID As %String = "", Flag As %String = "") As %String
{
	q:(BasicInfo="")||(EMRContentSTR="{}") "False"
	s Result="False"
	s (LocID,Sex,Age,HospitalDate,RecordDate,Expressionist,DoctorName,Nation,Profession,CurrentAddress,Marriage,Birthplace)=""
	s EMRContent=EMRContentSTR /// 病历内容（JSON信息）
	s EMRType=$p(BasicInfo,"【AND】",1) // 病历类型（入院记录/首次病程记录...）
	s VisitType=$p(BasicInfo,"【AND】",2)  //就诊类型
	s EMRCode=$p(BasicInfo,"【AND】",3) //病历编码
	s LocSTR=$p(BasicInfo,"【AND】",4) //入院科室
	s SexStr=$p(BasicInfo,"【AND】",5) //性别
	s AgeSTR=$p(BasicInfo,"【AND】",6) //年龄
	s OtherSTR=$p(BasicInfo,"【AND】",7) //其他信息
	s HospitalDateSTR=$p(BasicInfo,"【AND】",8) //住院日期
	s RecordDateSTR=$p(BasicInfo,"【AND】",9) //记录日期
	s ExpressionistSTR=$p(BasicInfo,"【AND】",10) /// 病史表达者
	s DoctorNameSTR=$p(BasicInfo,"【AND】",11) //医生签名
	s LocID=LocSTR //科室
	if SexStr'=""
	{
		if SexStr["性别："
		{
			s Sex=$p(SexStr,"性别：",2)
		}
		else
		{
			s Sex=SexStr
		}
	}
	if (AgeSTR'="")
	{	
		if ((AgeSTR["年龄：")&(AgeSTR["岁"))
		{
			s Age=$p($p(AgeSTR,"年龄：",2),"岁",1)
		}
		elseif (AgeSTR["岁")
		{
			s Age=$p(AgeSTR,"岁",1)	
		}
		else
		{
			s Age=AgeSTR
		}
	}
	if OtherSTR'=""
	{
		if (OtherSTR["民族：")&(OtherSTR["国籍")
		{
			s Nation=$p($p(OtherSTR,"民族：",2),"国籍",1) //民族
		}
		if (OtherSTR["职业：")&(OtherSTR["家庭地址")
		{
			s Profession=$p($p(OtherSTR,"职业：",2),"家庭地址",1) //职业
		}
		if (OtherSTR["家庭地址（户口所在地）：")&(OtherSTR["邮编")
		{
			s CurrentAddress=$p($p(OtherSTR,"家庭地址（户口所在地）：",2),"邮编",1) //地址
		}
		if (OtherSTR["婚姻状况：")&(OtherSTR[" 职业")
		{
			s Marriage=$p($p(OtherSTR,"婚姻状况：",2)," 职业",1) //婚姻
		}
		if (OtherSTR["出生地：")&(OtherSTR[" 民族")
		{
			s Birthplace=$p($p(OtherSTR,"出生地：",2)," 民族",1) //出生地
		}
	}
	if (HospitalDateSTR'="")&(HospitalDateSTR["-")
	{
		if HospitalDateSTR["入院日期："
		{
			s HospitalDate=$p(HospitalDateSTR,"入院日期：",2)
			//容错时间位数不够 "2019-11-7 15:16"
			try
			{
				s HospitalDate=$zdth(HospitalDate,3)
				s HospitalDate=$zdt(HospitalDate,3)
			}
			catch e
			{
				s HospitalDate=""
			}
		}
		else
		{	
			s HospitalDate=HospitalDateSTR
			try
			{
				s HospitalDate=$zdth(HospitalDate,3)
				s HospitalDate=$zdt(HospitalDate,3)
			}
			catch e
			{
				s HospitalDate=""
			}
		}
	}
	elseif (HospitalDateSTR'="")&(HospitalDateSTR'["-")
	{
		try
		{
			s HospitalDate=$zd(HospitalDateSTR,3)
		}
		catch e
		{
			//w HospitalDateSTR,!
		}
	}
	
	if (RecordDateSTR'="")&(RecordDateSTR["-")
	{
		if RecordDateSTR["记录时间："
		{
			s RecordDate=$p(RecordDateSTR,"记录时间：",2)
			try
			{
				s RecordDate=$zdth(RecordDate,3)
				s RecordDate=$zdt(RecordDate,3)
			}
			catch e
			{
				s RecordDate=""
			}
		}
		else
		{
			s RecordDate=RecordDateSTR
			try
			{
				s RecordDate=$zdth(RecordDate,3)
				s RecordDate=$zdt(RecordDate,3)
			}
			catch e
			{
				s RecordDate=""
			}
		}
	}
	elseif (RecordDateSTR'="")&(RecordDateSTR'["-")
	{
		try
		{
			s RecordDate=$zdt(RecordDateSTR,3)
		}
		catch e
		{
			//w RecordDateSTR,!
		}
	}
	
	if ExpressionistSTR'=""
	{
		if ExpressionistSTR["病史陈述者："
		{
			s Expressionist=$p(ExpressionistSTR,"病史陈述者：",2)
		}
		else
		{
			s Expressionist=ExpressionistSTR
		}
	}
	if DoctorNameSTR'=""
	{
		if DoctorNameSTR["医生署名："
		{
			s DoctorName=$p(DoctorNameSTR,"医生署名：",2)
		}
		else
		{
			s DoctorName=DoctorNameSTR
		}
	}
	
	//保存
	if EMRID="" //新增/导入数据-为空字段不存
	{
		s eobj = ##class(CT.WDT.CDSS.HighQualityEMR).%New()
		s eobj.EMRType=EMRType // 病例类型
		s eobj.EMRContent=EMRContent // 病历内容
		s eobj.VisitType=VisitType /// 就诊类型（急诊、门诊、住院）
		if Flag="add" //新增
		{
			s eobj.UseFlag=0 //使用标志
		}
		else //导入
		{
			s eobj.UseFlag=2 //使用标志
		}
		s eobj.UpdateDate=$ZDATETIME($HOROLOG,3) //编辑时间
		s eobj.EMRCode=EMRCode //病历编码
		//s eobj.UpdateUser="wz" //编辑人员
		s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME")) //编辑人员
		if LocID'=""
		{
			s eobj.Loc=LocID  /// 科室(多选用中文，连接科室id)
		}
		if Sex'=""
		{
			s eobj.Sex=Sex
		}
		//s eobj.Sex=$p(BasicInfo,"【AND】",5) /// 性别
		if Age'=""
		{
			s eobj.Age=Age /// 年龄
		}
		if HospitalDate'=""
		{ 
			s eobj.HospitalDate=HospitalDate //入院日期
		}
		if RecordDate'=""
		{
			s eobj.RecordDate=RecordDate //记录日期
		}
		if Expressionist'=""
		{
			s eobj.Expressionist=Expressionist /// 病史表达者
		}
		if DoctorName'=""
		{
			s eobj.DoctorName=DoctorName /// 主管医师
		}
		if Nation'=""
		{
			s eobj.Nation=Nation /// 民族
		}
		if Profession'=""
		{
			s eobj.Profession=Profession /// 职业
		}
		if CurrentAddress'=""
		{
			s eobj.CurrentAddress=CurrentAddress /// 地址
		}
		if Marriage'=""
		{
			s eobj.Marriage=Marriage //婚姻
		}
		if Birthplace'=""
		{
			s eobj.Birthplace=Birthplace //出生地
		}
		Ts
		s sc=eobj.%Save()
	   	d eobj.%Close()
	   	If $$$ISOK(sc)
	   	{
		   	Tc
		   	s Result=eobj.%Id() //返回病历ID
	   	}
	   	else
	   	{
		   	Trollback
		   	//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
		   	s Result=Result_"^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else //修改数据-不管是否为空均改
	{
		//按模板已有数据
		s obj=##class(CT.WDT.CDSS.HighQualityEMR).%OpenId(EMRID)
		s obj.EMRType=EMRType // 病例类型
		s obj.EMRContent=EMRContent // 病历内容
		s obj.VisitType=VisitType /// 就诊类型（急诊、门诊、住院）
		s obj.UseFlag=0 //使用标志
		s obj.UpdateDate=$ZDATETIME($HOROLOG,3) //编辑时间
		s obj.EMRCode=EMRCode //病历编码
		//s obj.UpdateUser="wz" //编辑人员
		s obj.UpdateUser=$g(%session.Data("LOGON.USERNAME")) //编辑人员
		s obj.Loc=LocID  /// 科室(多选用中文，连接科室id)
		s obj.Sex=Sex //性别
		//s obj.Sex=$p(BasicInfo,"【AND】",5) /// 性别
		s obj.Age=Age /// 年龄
		if HospitalDate'=""
		{
			s obj.HospitalDate=HospitalDate //入院日期
		}
		if RecordDate'=""
		{
			s obj.RecordDate=RecordDate //记录日期
		}
		s obj.Expressionist=Expressionist /// 病史表达者
		s obj.DoctorName=DoctorName /// 主管医师
		s obj.Nation=Nation /// 民族
		s obj.Profession=Profession /// 职业
		s obj.CurrentAddress=CurrentAddress /// 地址
		s obj.Marriage=Marriage //婚姻
		s obj.Birthplace=Birthplace //出生地
		Ts
		s sc=obj.%Save()
	   	d obj.%Close()
	   	If $$$ISOK(sc)
	   	{
		   	Tc
		   	s Result=EMRID //返回病历ID
	   	}
	   	else
	   	{
		   	Trollback
		   	//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
		   	s Result=Result_"^"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q Result
}

/// Function：保存优质病历关联诊断
/// Creater:wz
/// CreatDate:2023-03-27
/// Table: CT.WDT.CDSS.HighQEMRConDia 优质病历关联诊断表
/// Input: EMRID：病历ID, DiagnosisSTR：诊断名称, EMRID：病历ID
/// Output: 
/// Others:w ##class(web.CDSS.CMKB.ImportHighQualityData).SaveDiagnosis("1","阑尾炎")
/// 若诊断即是西又是中，先西医-后中医-最后证型
ClassMethod SaveDiagnosis(EMRID As %String, DiagnosisSTR As %String, Flag As %String = "") As %String
{
	q:(EMRID="")||(DiagnosisSTR="")||(DiagnosisSTR="[]")||(DiagnosisSTR["error") "False"
	if DiagnosisSTR[" "
	{
		s DiagnosisSTR=$replace(DiagnosisSTR," ","")
	}
	//s:DiagnosisSTR="双膝骨关节炎" DiagnosisSTR="风湿性关节炎"
	s Result="False"
	//修改诊断先删除之前诊断,新增和导入则不用
	if Flag="modify"
	{
		s DiagnosisID=0
		for
		{
			s DiagnosisID=$o(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRIndex",EMRID,DiagnosisID))
			q:DiagnosisID=""
			d ##class(CT.WDT.CDSS.HighQEMRConDia).%DeleteId(DiagnosisID)
		}
	}
	s DiagnosisArray=[].%FromJSON(DiagnosisSTR)
	for sum=0:1:DiagnosisArray.%Size()-1
	{
		s ItemDict=DiagnosisArray.%Get(sum)
		s Name=ItemDict.%Get("name")   //获取诊断名称
		continue:Name=""
		//诊断名称,诊断分类,诊断字典表ID
		s (DiagnosisName,DiagnosisClass,DiagnosisID,ResultClassID)=""
		s ResultClassID=..GetDiagClassID(Name) //获取诊断分类和ID
		if ResultClassID="" //不在CDSS字典，遍历所有医院去进行对照
		{
			s ResultClassID=..GetDictNameFromNlp(Name) //多个或1个
			if ResultClassID=""
			{
				if $d(^TEMP("CDSSNOTDiag"))
				{
					s ^TEMP("CDSSNOTDiag")=^TEMP("CDSSNOTDiag")_"【AND】"_Name
				}
				else
				{
					s ^TEMP("CDSSNOTDiag")=Name
				}
	
			}
		}
		continue:ResultClassID=""
		//保存
		s IsMainDiagnosis="0"
		if sum=0 //NLP解析的第一个作为主诊断
		{
			s IsMainDiagnosis="1" //是否主诊断
		}
		s Type="初步诊断" //诊断来源
		s DiagnosisType=$case(Type,"确诊诊断":"1","初步诊断":"2","补充诊断":"4","修正诊断":"3")
		for num=1:$l(ResultClassID,"&%")
		{
			s ResultClassIDNow=$p(ResultClassIDNow,"&%",num)
			if ResultClassIDNow["**"
			{
				continue:($p(ResultClassIDNow,"**",1)="")||($p(ResultClassIDNow,"**",2)="")||($p(ResultClassIDNow,"**",3)="")
				s DiagnosisName=$p(ResultClassIDNow,"**",1)
				s DiagnosisClass=$p(ResultClassIDNow,"**",2)
				s DiagnosisID=$p(ResultClassIDNow,"**",3)
				s DiagnosisSequence=$o(^CT.WDT.CDSS.HighQEMRConDiaI("EMRDRDiagnosisSequenceIndex",EMRID,""),-1)+1 //诊断顺序号
				/*if DiagnosisSequence="1"
				{
					s IsMainDiagnosis="1" //是否主诊断 
				}*/
				//同病历同诊断不重复存储
				if '$d(^CT.WDT.CDSS.HighQEMRConDiaI("DiagEMRDRIndex",DiagnosisClass,DiagnosisName,EMRID))
				{
					s eobj = ##class(CT.WDT.CDSS.HighQEMRConDia).%New()
					d eobj.EMRDRSetObjectId(EMRID)
					s eobj.DiagnosisClass=DiagnosisClass
					//s eobj.DiagnosisDR=DiagnosisID
					s eobj.DiagnosisName=DiagnosisName
					s eobj.DiagnosisSequence=DiagnosisSequence
					s eobj.IsMainDiagnosis=IsMainDiagnosis
					s eobj.DiagnosisType=DiagnosisType
					s eobj.Remarks=""
					Ts
					s sc=eobj.%Save()
				   	d eobj.%Close()
				   	If $$$ISOK(sc)
				   	{
					   	Tc
					   	if Result'="Fasle"
					   	{
					   		s Result=Result_"^^"_DiagnosisName
					   	}
					   	else
					   	{
						   	s Result=DiagnosisName
						}
				   	}
				   	else
				   	{
					   	Trollback
					   	//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
					}
				}
			}
		}
	}
	q Result
}

/// Function：保存优质病历关联诊断因子
/// Creater:wz
/// CreatDate:2023-03-29
/// Table: CT.WDT.CDSS.HighQEMRConSym 优质病历关联诊断因子表
/// Input: EMRID：病历ID FactorJSON：诊断因子JSON串
/// Output: 
/// Others:w ##class(web.CDSS.CMKB.ImportHighQualityData).SaveFactor("")
ClassMethod SaveFactor(EMRID As %String, FactorJSON As %String, Flag As %String = "") As %String
{
	q:(FactorJSON="[]")||(EMRID="") "False"
	s Result="False"
	//修改数据先删除之前诊断因子,新增和导入则不用
	if Flag="modify"
	{
		s FactorID=0
		for
		{
			s FactorID=$o(^CT.WDT.CDSS.HighQEMRConSymI("EMRDRIndex",EMRID,FactorID))
			q:FactorID=""
			d ##class(CT.WDT.CDSS.HighQEMRConSym).%DeleteId(FactorID)
		}
	}
	s FactorArray=[].%FromJSON(FactorJSON)
	//w EMRID,!
	for sum=0:1:FactorArray.%Size()-1
	{
		s ItemArray=FactorArray.%Get(sum)
		for num=0:1:ItemArray.%Size()-1
		{
			s ChildDict=ItemArray.%Get(num)
			if ChildDict.%IsDefined("EMRNode")
			{
				s (PartDR,PositionWordDR)=""
				s EMRNode=ChildDict.%Get("EMRNode")
				//w EMRNode,!
				//w ChildDict.%ToJSON(),!
				if ChildDict.%IsDefined("Part")
				{
					s Part=ChildDict.%Get("Part")
					if Part'=""
					{
						//部位字典
						s PartDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_$ZCONVERT(Part,"U"),0))
						if PartDR=""
						{
							//别名
							s PartDR=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.BodyPartsDict",$ZCONVERT(Part,"U"),0))
						}
					}
				}
				if ChildDict.%IsDefined("PositionWord")
				{
					s PositionWord=ChildDict.%Get("PositionWord")
					if PositionWord'=""
					{
						//方位字典
						s PositionWordDR=$o(^CT.WDT.CDSS.PositionWordI("DescIndex"," "_$ZCONVERT(PositionWord,"U"),0))
						if PositionWordDR=""
						{
							//别名
							s PositionWordDR=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PositionWord",$ZCONVERT(PositionWord,"U"),0))
						}
					}
				}
				
				s SymptomNum=$o(^CT.WDT.CDSS.HighQEMRConSymI("SymptomNumIndex",EMRID,""),-1) //症状顺序号
                if (SymptomNum=" ")
                {
                    s SymptomNum = 1
                }
                else
                {
                    s SymptomNum = SymptomNum+1
                } 
				
				s eobj = ##class(CT.WDT.CDSS.HighQEMRConSym).%New()
				d eobj.EMRDRSetObjectId(EMRID)  //病历指针
				s eobj.EMRNode=EMRNode /// 病历节点
				s eobj.SymptomNum=SymptomNum //症状顺序号
				s eobj.Symptom=ChildDict.%Get("Symptom") //症状
				s eobj.Duration=ChildDict.%Get("Duration") //持续时长
				s eobj.AbnormalMax=ChildDict.%Get("AbnormalMax") //症状的值
				s eobj.RangeUnit=ChildDict.%Get("RangeUnit") //属性
				s eobj.SymptomType=ChildDict.%Get("SymptomType") //值域单位
				s eobj.SymptomFormal=ChildDict.%Get("SymptomFormal") //归一
				s eobj.SymptomCore=ChildDict.%Get("SymptomCore") //上位
				s eobj.SymProperty=ChildDict.%Get("SymProperty") //属性
				s eobj.Cause=ChildDict.%Get("Cause") //病因
				s eobj.Remarks="" // 备注
				if PartDR'=""
				{
					d eobj.PartDRSetObjectId(PartDR) //部位
				}
				if PositionWordDR'=""
				{
					d eobj.PositionWordDRSetObjectId(PositionWordDR) //方位
				}
				Ts
				s sc=eobj.%Save()
			   	d eobj.%Close()
			   	If $$$ISOK(sc)
			   	{
				   	Tc
				   	s Result="Ture"
			   	}
			   	else
			   	{
				   	Trollback
				   	//w ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
				}
			}
		}
	}
	q Result
}

/// Function: 相似病历（优质病历）Excel数据过NLP
/// Creater:wz
/// CreatDate:2023-03-23
/// Table: 
/// Input: DataString：字符串
/// Output: JSON
/// Others:w ##class(web.CDSS.CMKB.ImportHighQualityData).GetStructDataEMR("主诉","腹痛，突发左侧肢体无力5日")
ClassMethod GetStructDataEMR(EMRNode As %String, DataString As %String) As %String
{
	q:(DataString="")||(EMRNode="") []
	s NLPString=..GetStructedDataAPI(DataString) //过NLP
	if (NLPString="[]")||(NLPString["error") //NLP未识别
	{
		q []
	}
	s SymptomArray=[]
	s NLPArray=[].%FromJSON(NLPString)
	for sum=0:1:NLPArray.%Size()-1
	{
		s ItemJson=NLPArray.%Get(sum)
		//判断阴阳性
		s IsPositiveFlag=ItemJson.%Get("type")
		if (IsPositiveFlag["+")||(IsPositiveFlag["-")
		{
			s IsPositive=$e(ItemJson.%Get("type"),1,1)   //用来取阴性和阳性
			s IsPositive=$case(IsPositive,"+":"阳性","-":"阴性")
		}
		else
		{
			s IsPositive="阳性"
		}
		continue:IsPositive="阴性" //过滤阴性症状
		//实体
		s Name=ItemJson.%Get("name")   //症状名称
		//归一
		if (ItemJson.%IsDefined("formal"))&&(ItemJson.%Get("formal")'=ItemJson.%Get("name"))
		{
			s Formal=ItemJson.%Get("formal") ///归一词
		}
		else
		{
			s Formal=""
		}
		//上位
		if (ItemJson.%IsDefined("core"))&&(ItemJson.%Get("core")'=ItemJson.%Get("name"))
		{
			s Core=ItemJson.%Get("core")  ///上位词
			s Core=$replace(Core,"、","&%")
		}
		else
		{
			s Core=""
		}
		
		s NameFlag=..ExistDict(Name) //是否存在CDSS字典
		s FormalFlag="0" ///归一是否在CDSS字典
		///处理归一词和上位词
		if Formal'=""
		{
			s FormalFlag=..ExistDict(Formal) //归一是否在CDSS字典
		}
		s CoreFlag="0" ///上位是否在CDSS字典
		if Core'=""
		{
			s CoreNum=$l(Core,"&%")
			s CoreDeal="" //存在CDSS字典
			for v=1:1:CoreNum
			{
				s CoreNow=$p(Core,"&%",v)
				s CoreNowFlag=..ExistDict(CoreNow)
				s:(CoreDeal'="")&(CoreNowFlag="1") CoreDeal=CoreDeal_"&%"_CoreNow
				s:(CoreDeal="")&(CoreNowFlag="1") CoreDeal=CoreNow
			 }
			 if CoreDeal'=""
			 {
				 s CoreFlag="1"
				 s Core=CoreDeal
			 }
			 else
			 {
				 s Core=""
			 }
			 
		}
		
		//体格检查数据处理
		s PhysicalExamFlag="0"
		if (IsPositiveFlag["sign")||(IsPositiveFlag["generalstatus")
		{
			s Symptom=""
			if ItemJson.%IsDefined("sign_name")   //体征项目名
			{
				s Symptom=ItemJson.%Get("sign_name").%Get("name")
			}
			elseif ItemJson.%IsDefined("sign")
			{
				s Symptom=ItemJson.%Get("sign").%Get("name") //NLP部位+NLP体征项
				if ItemJson.%Get("sign").%IsDefined("core") //NLP体征项
				{
					s ExamItemCore=ItemJson.%Get("sign").%Get("core")
					if (ExamItemCore'="")&(ExamItemCore'=Symptom)
					{
						s Symptom=ExamItemCore
					}
				} 
			}
			//体格检查数据增加判断体格检查+通用名字典
			s PhysicalExamFlag=..WhetherPyhExamDict(Symptom) //体征判断
			if PhysicalExamFlag["^"
			{
				s Name=$p(PhysicalExamFlag,"^",2) //别名转体格检查名
			}
			elseif (PhysicalExamFlag="0")&(Symptom'=Name) //实体判断
			{
				s PhysicalExamFlag=..WhetherPyhExamDict(Name)
				if PhysicalExamFlag["^" //实体在且是别名
				{
					s Name=$p(PhysicalExamFlag,"^",2)
				}
				elseif (PhysicalExamFlag="0")&(Symptom'=Name)&(Name'=Formal) //归一判断
				{
					s PhysicalExamFlag=..WhetherPyhExamDict(Formal)
					if (PhysicalExamFlag["^")||(PhysicalExamFlag=1)
					{
						s Name=Formal
					}
				}
			}
		}
		continue:(NameFlag="0")&(FormalFlag="0")&(CoreFlag="0")&(PhysicalExamFlag="0") //症状，归一，上位不可同时不存在CDSS字典
		if (NameFlag="0")&(PhysicalExamFlag="0")
		{
			s Name=""
		}
		if (FormalFlag="0")&(PhysicalExamFlag="0")
		{
			s Formal=""
		}
		
		s (SymProperty,AbnormalMax,RangeUnit,Symbol)="" //属性，症状值，值单位，符号
		//1.0部位
		if ItemJson.%IsDefined("position")    //存在部位
		{
			s Part=ItemJson.%Get("position").%Get("name")   //部位
		}
		else    //不存在部位
		{ 
			s Part=""
		}
		//Duration字段有last_tiem优先存，没有则存happen_time
		if ItemJson.%IsDefined("last_time")
		{
			s Duration=ItemJson.%Get("last_time").%Get("name") //获取持续时长
			s Duration=..DealLastTime(Duration)   ///处理持续时间并进行单位转换（时）
		}
		else
		{
			if ItemJson.%IsDefined("happen_time")
			{
				s Duration=ItemJson.%Get("happen_time").%Get("name")
				s Duration=..DealHappentime(Duration) ///处理开始时间并进行单位转换（时）
			}
			else
			{
				s Duration=""
			}
		}
		///属性：用&%拼接level，frequency，nature，day_time，incentive内容
		if ItemJson.%IsDefined("level")
		{
			s LevelValue=ItemJson.%Get("level") //程度
			s LevelType=ItemJson.%GetTypeOf("level")
			if LevelType="array"   //如果值是一个数组
			{
				s LevelArraySize=LevelValue.%Size()
				s Level=""
				for LeSize=0:1:LevelArraySize-1
				{
					s:Level'="" Level=Level_"&%"_LevelValue.%Get(LeSize).%Get("name")
					s:Level="" Level=LevelValue.%Get(LeSize).%Get("name")
				}
			}
			elseif LevelType="object"  //如果值只是一个{}
			{
				s Level=LevelValue.%Get("name") //程度
			}
			else
			{
				s Level=""
			}
			s SymProperty=Level
		}
		if ItemJson.%IsDefined("frenquency")
		{
			s Frenquency=ItemJson.%Get("frenquency").%Get("name")  //频率
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Frenquency
			s:SymProperty="" SymProperty=Frenquency
		}
		if ItemJson.%IsDefined("nature")
		{
			///nature的格式区别于level和frequency，"[...]"格式
			s Nature=""
			if ($e(ItemJson.%Get("nature").%ToJSON(),1)="[")  //"[...]"格式
			{
				for p=0:1:ItemJson.%Get("nature").%Size()-1 //$l(ItemJson.%Get("nature"))
				{
					s NatureJson=ItemJson.%Get("nature").%Get(p)
					s NatureNow=NatureJson.%Get("name")
					s:Nature'="" Nature=Nature_"&%"_NatureNow
					s:Nature="" Nature=NatureNow
				}
			}
			elseif ($e(ItemJson.%Get("nature").%ToJSON(),1)="{") //"{...}"格式
			{
				s Nature=ItemJson.%Get("nature").%Get("name")  //性质
			}
			
			//s Nature=ItemJson.%Get("nature").%Get("name")  //性质
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Nature
			s:SymProperty="" SymProperty=Nature
		}
		if ItemJson.%IsDefined("day_time")
		{
			///day_time的格式区别于level和frequency，"[...]"格式
			s DayTime=""
			for y=0:1:ItemJson.%Get("day_time").%Size()-1 //$l(ItemJson.%Get("day_time"))
			{
				s DayTimeJson=ItemJson.%Get("day_time").%Get(y)
				s DayTimeNow=DayTimeJson.%Get("name")
				s:DayTime'="" DayTime=DayTime_"&%"_DayTimeNow
				s:DayTime="" DayTime=DayTimeNow
			}
			s:SymProperty'="" SymProperty=SymProperty_"&%"_DayTime
			s:SymProperty="" SymProperty=DayTime
		}
		//诱因
		if ItemJson.%IsDefined("incentive")
		{
			s Incentive=ItemJson.%Get("incentive").%Get("name")  //诱因
			s:SymProperty'="" SymProperty=SymProperty_"&%"_Incentive
			s:SymProperty="" SymProperty=Incentive
			
			//诱因/病因识别词维护时取自 诱因/病因，定语字典
			
			/*s PathogenyID=$o(^CT.WDT.CDSS.PathogenyDictI("DescIndex"," "_$ZCONVERT(Incentive,"U"),0)) ///诱因/病因字典
			if PathogenyID=""
			{
				s PathogenyID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PathogenyDict",$ZCONVERT(Incentive,"U"),0)) ///别名通用名
				if PathogenyID="" //不在诱因字典，也不是诱因字典的别名
				{
					s AttributeID=$o(^CT.WDT.CDSS.AttributeDictI("DescIndex"," "_$ZCONVERT(Incentive,"U"),0)) ///定语字典
					if AttributeID="" //不在定语字典，也不是定语字典的别名
					{
						s AttributeID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.AttributeDict",$ZCONVERT(Incentive,"U"),0)) ///别名通用名
						s:AttributeID="" Incentive=""
						s:AttributeID'="" Incentive=$lg($g(^CT.WDT.CDSS.AttributeDictD(AttributeID)),3)
					}
				}
				else
				{
					s Incentive=$lg($g(^CT.WDT.CDSS.PathogenyDictD(PathogenyID)),3)
				}
			}*/
		}
		else
		{
			s Incentive=""
		}
		
		//疾病类型数据的肿瘤分期属性
		if ItemJson.%IsDefined("tnm")&&(IsPositiveFlag["disease")
		{
			s TNM=ItemJson.%Get("tnm").%Get("name")
			if TNM'=""
			{
				s:SymProperty'="" SymProperty=SymProperty_"&%"_TNM
				s:SymProperty="" SymProperty=TNM
			}
		}
		
		//症状的值
		if ItemJson.%IsDefined("value")
		{
			s AbnormalMax=ItemJson.%Get("value").%Get("name")  //症状的值
		}
		//值的单位
		if ItemJson.%IsDefined("unit")
		{
			s RangeUnit=ItemJson.%Get("unit").%Get("name")  //值的单位
			//单位名称是否在单位字典表中，不在则存""
			
			/*s UnitID=$o(^CT.WDT.CDSS.UnitDictI("DescIndex"," "_$zconvert(RangeUnit,"U"),0))
			if UnitID'=""
			{
				s RangeUnit=RangeUnit
			}
			else
			{
				s UnitAliasID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.UnitDict",RangeUnit,0)) //单位字典表 ID
				if UnitAliasID'=""
				{
					s RangeUnit=$lg($g(^CT.WDT.CDSS.UnitDictD(UnitAliasID)),3)  //单位字典表 单位名称
				}
				else
				{
					s RangeUnit=""
				}
			}*/
		}
		
		//2.0的部位和方位
		if ItemJson.%IsDefined("stand_body") ///2.0的部位 CDSS2PartDR
		{
			s Body=""
			for t=0:1:ItemJson.%Get("stand_body").%Size()-1
			{
				s BodyJson=ItemJson.%Get("stand_body").%Get(t)
				s BodyNow=BodyJson.%Get("name")
				s:Body'="" Body=Body_BodyNow
				s:Body="" Body=BodyNow
			}
		}
		else
		{
			s Body=""
		}
		if ItemJson.%IsDefined("stand_pos")  //2.0的方位  PositionWordDR
		{
			s Pos=""
			for q=0:1:ItemJson.%Get("stand_pos").%Size()-1
			{
				s PosJson=ItemJson.%Get("stand_pos").%Get(q)
				s PosNow=PosJson.%Get("name")
				s:Pos'="" Pos=Pos_PosNow
				s:Pos="" Pos=PosNow
			}
		}
		else
		{
			s Pos=""
		}
		
		//符号
		if ItemJson.%IsDefined("symbol")
		{
			s Symbol=ItemJson.%Get("symbol").%Get("name")
		}
		
		s ChildItem={}
		//d ChildItem.%Set("UserName","CT.WDT.CDSS.HighQEMRConSym") //表名
		d ChildItem.%Set("SymptomType",IsPositiveFlag) //类型
		d ChildItem.%Set("EMRNode",EMRNode) //病历节点
		d ChildItem.%Set("SymptomNum",sum+1) //症状顺序号
		d ChildItem.%Set("Symptom",Name) //症状
		d ChildItem.%Set("SymptomFormal",Formal) //归一
		d ChildItem.%Set("SymptomCore",Core) //上位
		d ChildItem.%Set("Duration",Duration) //持续时间
		d ChildItem.%Set("AbnormalMax",AbnormalMax) //症状的值
		d ChildItem.%Set("RangeUnit",RangeUnit) //值的单位
		d ChildItem.%Set("Cause",Incentive) //病因
		d ChildItem.%Set("SymProperty",SymProperty) //属性
		d ChildItem.%Set("Part",Body) //部位
		d ChildItem.%Set("PositionWord",Pos) //方位
		d SymptomArray.%Push(ChildItem)
	}
	q SymptomArray
}

/// Creator:wz
/// CreatDate:2022-06-03
/// Description：查看症状名称是否存在症状字典(2.0)/诊断因子字典(2.0)/疾病字典/中医疾病字典中
/// Input：症状名称
/// Output: 1 存在   0 不存在
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).ExistSymptom("痛经进行性加重")
ClassMethod ExistDict(Symptom As %String) As %String
{
	q:Symptom="" 0
	s Symptom=$zstrip(Symptom,"<>W")
	s SymptomU=$ZCONVERT(Symptom,"U")
	//症状字典2.0+诊断因子字典库2.0判断是否存在 
	if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU))||$d(^CT.WDT.CDSS.SymptomDictI("DescIndex"," "_SymptomU)))
	{
		s Result=1
    }
    //疾病字典+中医疾病字典
    elseif($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_SymptomU))||$d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",SymptomU)))
    {
	    s Result=1
	}
    else
    {
		s Result=0   
	}
	q Result
}

/// Creator:wuzhe
/// CreatDate:2022-10-10
/// Description：判断数据是否在体格检查字典中
/// Table: CT.WDT.CDSS.PhysicalExamDict：体格检查字典
/// Input:Context：字符串
/// Output: 1：是，0：否，1^体格检查名：入参是体格检查的别名
/// Others: w ##class(web.CDSS.CMKB.ImportHighQualityData).WhetherPyhExamDict("毛发变白")
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).WhetherPyhExamDict("脑卒中样发作")
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).WhetherPyhExamDict("体温")
ClassMethod WhetherPyhExamDict(Context As %String) As %String
{
	//q:Context="四肢" "0"
	q:Context="" 0
	s result=0
	s ID=$o(^CT.WDT.CDSS.PhysicalExamDictI("NameIndex"," "_Context,0))  //体格检查字典判断
	if (ID="")
	{
		s ID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.PhysicalExamDict",Context,0))  //别名通用名判断
		if (ID'="")
		{
			s PhysicalExamName=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),3) //体格检查名
			s result=1_"^"_PhysicalExamName
		}
		else
		{
			s CommonID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex","3",Context,0))  //通用名字典进行判断
			if CommonID=""
			{
				s CommonID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",Context,0))  //别名通用名判断
				if CommonID'=""
				{
					s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonID)),4)  //通用名名称
					s result=1_"^"_DictDesc
				}
			}
			else
			{
				s result=1
			}
		}
	}
	else
	{
		s Flag=$lg($g(^CT.WDT.CDSS.PhysicalExamDictD(ID)),10) //使用标志（0编辑中，1已删除，2已审核）
		//体温即在体格检查字典又在通用名字典
		if (Flag=0)||(Flag=1)||(Flag="") //编辑，删除
		{
			s CommonID=$o(^CT.WDT.CDSS.CommonDictI("TypeDescIndex","3",Context,0))  //通用名字典进行判断
			if CommonID=""
			{
				s CommonID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.CommonDict",Context,0))  //别名通用名判断
				if CommonID'=""
				{
					s DictDesc=$lg($g(^CT.WDT.CDSS.CommonDictD(CommonID)),4)  //通用名名称
					s result=1_"^"_DictDesc
				}
			}
			else
			{
				s result=1
			}
		}
		else //已审核
		{
			s result=1
		}
	}
	q result
}

/// Creator:wuzhe
/// CreatDate:2021-11-24
/// Description：处理持续时间
/// Table：
/// Input：LastTime:持续时间内容
/// Output: "":没有小时  数字：小时
/// Others：w ##class(web.CDSS.CMKB.ImportHighQualityData).DealLastTime("2天")
/// 1月余当1月来算   10个半小时
ClassMethod DealLastTime(LastTime As %String) As %String
{
	s result=""
	s str="1,2,3,4,5,6,7,8,9,0,半"
	s timeunit="分钟,时,日,天,周,月,年,岁"
	s exchange=1 ///单位转化成小时的系数
	s number=""
	s unit=""
	
	s:LastTime["余" LastTime=$replace(LastTime,"余","")
	///数值默认第一个位置,也有10小时这种的
	///s number=$e(LastTime,1)
	for i=1:1:$l(LastTime)
	{
		s:(str[$e(LastTime,i))&(number'="") number=number_$e(LastTime,i)
		s:(str[$e(LastTime,i))&(number="") number=$e(LastTime,i)
		s:(timeunit[$e(LastTime,i))&(unit'="") unit=unit_$e(LastTime,i)
		s:(timeunit[$e(LastTime,i))&(unit="") unit=$e(LastTime,i)
	}
	
	s:number="半" number=0.5
	///应对 10个半小时-10半 
	s:($e(number,1)'="半")&(number["半") number=0.5+$replace(number,"半","")
	
	///单位默认最后一个位置，默认单位：分钟，小时/时，天，月，年，周，岁；如果单位是秒过滤
	///s unit=$e(LastTime,$l(LastTime))
	///q:(unit="分")||(unit="秒") ""
	s:unit'["时" exchange=$case(unit,"分钟":"0.016","日":"24","天":"24","周":"168","月":"744","年":"8760","岁":"8760","分":"0.016",:"")
	
	s:exchange'=1 number=number*exchange
	//s:(exchange'=1)&(exchange'="") number=number*exchange
	s result=number
	
	q result
}

/// Creator:wuzhe
/// CreatDate:2021-12-30
/// Description：处理开始时间(happen_time)
/// Input：内容
/// Output: 小时
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).DealHappentime("2020年")
/// 3年  一般出现在持续时间里，3年后  一般不会这样写
ClassMethod DealHappentime(Content As %String)
{
	q:Content="" ""
	s result=""
	s TimeLimit="前"
	s str="1,2,3,4,5,6,7,8,9,0,半"
	s timeunit="时,日,天,周,月,年"
	s exchange=1 ///单位转化成小时的系数
	s number=""
	s unit=""
	//s TimeNow="2022-1-6"
	//s TimeNow="2022-1-4"
	s TimeNow=$zdate(+$H,3)
	
	for i=1:1:$l(Content)
	{
		s:(str[$e(Content,i))&(number'="") number=number_$e(Content,i)
		s:(str[$e(Content,i))&(number="") number=$e(Content,i)
		s:(timeunit[$e(Content,i))&(unit'="") unit=unit_$e(Content,i)
		s:(timeunit[$e(Content,i))&(unit="") unit=$e(Content,i)
	}
	
	//if Content["前"  在外围
	if unit="年"
	{
		s number=($p(TimeNow,"-",1)-number)*8760
	}
	elseif unit="年月"
	{
		s yearnumber=$p(Content,"年","1")
		s monthnumber=$p($replace(Content,yearnumber_"年",""),"月","1")
		//年
		s yearlast=($p(TimeNow,"-",1)-yearnumber)*8760   //年 减  现在的年>=病历中的年
		//月
		s:$p(TimeNow,"-",2)>=monthnumber monthlast=($p(TimeNow,"-",2)-monthnumber)*744  //现在月大 减
		s:$p(TimeNow,"-",2)<monthnumber monthlast=12-monthnumber+$p(TimeNow,"-",2)*744    //现在月小 减：病历 2020.10 现在 2022.1
		s:$p(TimeNow,"-",2)<monthnumber yearlast=yearlast-8760
		
		s number=yearlast+monthlast
	}
	elseif unit="年月日"
	{
		//w TimeNow,!
		s yearnumber=$p(Content,"年","1") //病历 年
		s monthnumber=$p($replace(Content,yearnumber_"年",""),"月","1") //病历 月
		s daynumber=$p($replace(Content,yearnumber_"年"_monthnumber_"月",""),"日","1") //病历 日
		//年
		s yearlast=($p(TimeNow,"-",1)-yearnumber)*8760   //年 减
		//月
		s:$p(TimeNow,"-",2)>=monthnumber monthlast=($p(TimeNow,"-",2)-monthnumber)*744  //现在月大 减
		s:$p(TimeNow,"-",2)<monthnumber monthlast=12-monthnumber+$p(TimeNow,"-",2)*744   //现在月小 减：病历 2020.10 现在 2022.1
		s:$p(TimeNow,"-",2)<monthnumber yearlast=yearlast-8760 //现在月小年-1
		//日
		s:$p(TimeNow,"-",3)>=daynumber daylast=($p(TimeNow,"-",3)-daynumber)*24   //现在日大 减
		s:$p(TimeNow,"-",3)<daynumber daylast=31-daynumber+$p(TimeNow,"-",3)*24   //现在日小 减：病历 2020.10.5  现在 2022.1.6
		s:$p(TimeNow,"-",3)<daynumber monthlast=monthlast-744  //现在日小月-1 减：病历 2020.10.5  现在 2022.1.4
		
		s number=yearlast+monthlast+daylast
		//w (yearlast/8760)_"年"_(monthlast/744)_"月"_(daylast/24)_"日",!
	}
	else
	{
		s:number="半" number="0.5"
		///应对 10个半小时-10半 
		s:($e(number,1)'="半")&(number["半") number=0.5+$replace(number,"半","")

		///单位默认最后一个位置，默认单位：小时/时，天，月，年，周；如果单位是分或者秒过滤	
		s:unit'["时" exchange=$case(unit,"日":"24","天":"24","周":"168","月":"744","年":"8760",:"")
		s:(exchange'=1)&(exchange'="") number=number*exchange
	}
	s result=number
	
	q result
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把非结构化数据通过调用nlp服务器接口，转化为结构化数据
/// Input：data: json格式数据，key:data,value:要结构化的内容
/// Output: 结构化结果json字符串
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).GetStructedDataAPI("周期性下腹痛11月，加重并扪及腹部硬块6月")
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).GetStructedDataAPI("心悸一年半，游走性关节疼痛")
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).GetStructedDataAPI("反复腹痛明显")
ClassMethod GetStructedDataAPI(content As %String) As %String
{
	s content=$zstrip(content,"<>W") //只去掉字符串前和后的控制，不去掉字符之间的空格
	q:content="" "[]"
	
	s CacheData=..StoreNLPResult(content,"")
	if CacheData'=""
	{
		q CacheData
	}
	set httpRequest = ##class(%Net.HttpRequest).%New()
 	//s Url="http://111.205.6.207:1223/tag"
 	s Url=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSldy2020070701")
 	if Url["https" //标版NLP用的https，腾讯云电信云用NLP外网是http
 	{
	 	s httpRequest.SSLConfiguration="SSLECP"
 		s httpRequest.SSLCheckServerIdentity=0	
	}
 	
    Do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("data", content)
    //超时时间
    s httpRequest.Timeout=1.5
    //set status = httpRequest.Post(Url)
    set status = httpRequest.Get(Url)
    If $$$ISERR(status) 
    { //Quit $system.OBJ.DisplayError(status)
    	//w "nlp error",! 
    	q "[]"
    }
    //s stream=##class(%GlobalCharacterStream).%New()
    s stream=##class(%Stream.GlobalCharacter).%New()
    s stream= httpRequest.HttpResponse.Data
    Set responseString =""
    while 'stream.AtEnd
    {
	    s responseString=responseString_stream.ReadLine()
	}
	s CacheData=..StoreNLPResult(content,responseString)
    Quit responseString
}

/// Creator:李得原
/// CreatDate:2023-04-13
/// Description：缓存病历过nlp
/// Input：nlp json返回的字符串
/// Output: 
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).StoreNLPResult()
ClassMethod StoreNLPResult(InputStr As %String, ResponseStr As %String)
{
	s Result=""
	s md5=$system.Encryption.MD5Hash(InputStr)
	s md5hex=##class(%xsd.hexBinary).LogicalToXSD(md5)
	if $d(^TEMP(md5hex))
	{
		s Result=^TEMP(md5hex)
	}
	else
	{
		if ResponseStr'=""
		{
			s ^TEMP(md5hex)=ResponseStr
		}
	}
	q Result
}

/// Creator:wz
/// CreatDate:2023-05-12
/// Description：通过疾病名称获取疾病ID和疾病分类（中医，西医，证型）
/// Input: InputStr：疾病名称
/// Output: Result:名称**分类**ID/  **分类**ID
/// Others: w ##class(web.CDSS.CMKB.ImportHighQualityData).GetDiagClassID("脑梗塞")
/// w ##class(web.CDSS.CMKB.ImportHighQualityData).GetDiagClassID("脑梗死")
ClassMethod GetDiagClassID(InputStr As %String) As %String
{
	
	q:InputStr="" ""	
	s Result=""
	s Name=InputStr
	//诊断名称,诊断分类,诊断字典表ID
	s (DiagnosisName,DiagnosisClass,DiagnosisID)=""
	//疾病字典
	if $d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Name,"U")))
	{
		s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Name,"U"),0))
		if DiseaseID'=""
		{
			s DiagnosisName=Name
			s DiagnosisClass="西医"
			s DiagnosisID=DiseaseID
		}
	}
	else //通用别名表中是否存在
	{
		s DisBieMingID=""
		s DisBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",$ZCONVERT(Name,"U"),0))
		if DisBieMingID'=""
		{
			s DiagnosisName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),3) //别名转正名
			s DiagnosisClass="西医"
			s DiagnosisID=DiseaseID
		}
	}
	//中医疾病字典
	if DiagnosisID=""
	{
		if $d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(Name,"U")))
		{
			s TCMDiseaseID=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",$ZCONVERT(Name,"U"),0))
			if TCMDiseaseID'="" 
			{
				s DiagnosisName=Name
				s DiagnosisClass="中医"
				s DiagnosisID=TCMDiseaseID
			}
		}
		else ///通用别名表中是否存在
		{
			s TCMBieMingID=""
			s TCMBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMDisease",$ZCONVERT(Name,"U"),0))
			if TCMBieMingID'=""
			{
				s DiagnosisName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(TCMBieMingID)),3) //别名转正名
				s DiagnosisClass="中医"
				s DiagnosisID=TCMBieMingID
			}
		}
	}
	//中医证候字典
	if DiagnosisID=""
	{
		if $d(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(Name,"U")))
		{
			s TCMSymptomID=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_$ZCONVERT(Name,"U"),0))
			if TCMSymptomID'="" 
			{
				s DiagnosisName=Name
				s DiagnosisClass="证候"
				s DiagnosisID=TCMSymptomID
			}
		}
		else ///通用别名表中是否存在
		{
			s TCMSyBieMingID=""
			s TCMSyBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.TCMSymptom",$ZCONVERT(Name,"U"),0))
			if TCMSyBieMingID'="" 
			{
				s DiagnosisName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSyBieMingID)),3) //别名转正名
				s DiagnosisClass="证候"
				s DiagnosisID=TCMSyBieMingID
			}
		}
	}
	
	if (DiagnosisClass'="")&(DiagnosisID'="")
	{
		s Result=DiagnosisName_"**"_DiagnosisClass_"**"_DiagnosisID
	} 
	q Result
}

/// Creator:wz
/// CreatDate:2023-05-15
/// Description: 遍历所有医院去进行对照，若对照上，通过疾病名称获取疾病ID和疾病分类（中医，西医，证型）
/// Input: Diag：疾病名称
/// Output: ""：对照后不在CDSS，    名称**分类**ID/  **分类**ID   /   **分类**ID&%  /  名称**分类**ID&% 
/// Others: w ##class(web.CDSS.CMKB.ImportHighQualityData).GetDictNameFromNlp("脑梗塞")
ClassMethod GetDictNameFromNlp(Diag As %String) As %String
{
	q:Diag="" ""
	s Result=""
	s RecordName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(Diag,"","诊断") //对照配置医院
	if RecordName'=Diag
	{
		for i=1:1:$l(RecordName,"&%") //多个或1个对照
		{
			s RecordNameNow=$p(RecordName,"&%",i)
			s ResultClassID=..GetDiagClassID(RecordNameNow)
			if ResultClassID'=""
			{
				if Result=""
				{
					s Result=ResultClassID
				}
				else
				{
					s Result=Result_"&%"_ResultClassID
				}
			}	
		}
	}
	q:Result'="" Result
	
	//对照所有医院，对照上即退出
	s HospID=0
	for
	{
		s HospID=$o(^CT.WDT.CDSS.CustomerHospD(HospID)) //医院字典表
		q:HospID=""
		s HospitalName=$lg($g(^CT.WDT.CDSS.CustomerHospD(HospID)),3)
		s RecordName=##class(web.CDSS.IMP.ContrastDict).GetDiectName(Diag,HospID,"诊断") //对照HospID医院
		if RecordName'=Diag
		{
			for sum=1:1:$l(RecordName,"&%") //多个或1个对照
			{
				s RecordNameNow=$p(RecordName,"&%",sum)
				s ResultClassID=..GetDiagClassID(RecordNameNow)
				if ResultClassID'=""
				{
					if Result=""
					{
						s Result=ResultClassID
					}
					else
					{
						s Result=Result_"&%"_ResultClassID
					}
				}	
			}
			q:Result'="" //某一医院对照上退出循环
		}
	}
	q Result
}

}

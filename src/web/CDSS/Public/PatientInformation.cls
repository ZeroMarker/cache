Class web.CDSS.Public.PatientInformation Extends %RegisteredObject
{

/// Creator:luweijie
/// CreatDate:2021-5-18
/// Description：获取患者就诊信息表中的主诉，就诊类型，就诊科室
/// Table：WDT.CDSS.PatientVisit
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者就诊信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientVisitInfo("DH0001","te001","1","")
/// w ##class(web.CDSS.Public.PatientModel).GetPatientVisitc("DH0001","te001","1","")
ClassMethod GetPatientVisitc(IDNO As %String, PatientDR As %String, VisitID As %String, Config As %String) As %String
{
	
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientVisitInfo="",VisitInfo=""
	s VisiID=""
	if (IDNO'="")  //患者主索引
	{
		s VisiID =$o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
	}
	
	if (VisiID'="")  //就诊信息表ID不为空
	{
		s VisitType=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),5)
		s VisitingDepartment=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),7)
		s ChiefCompSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),12)

		s TotleInfo=VisitType_"^^"_VisitingDepartment_"^^"_ChiefCompSum
		
		if (PatientVisitInfo="")
		{
			s PatientVisitInfo=TotleInfo
		}
		else
		{
			s PatientVisitInfo=PatientVisitInfo_","_TotleInfo
		}
	}
	
	return PatientVisitInfo
}

/// Creator:luweijie
/// CreatDate:2021-6-15
/// 获取疾病关联诊断因子表中的症状对应的疾病名称，权重，和三个判断条件
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorIF()
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorIF("性生活连续规律正常,1年以上未避孕")
ClassMethod GetDHCDSSDiseJFactorIF(SymptomStr As %String) As %String
{
	//s SymptomStr = ["发热","头痛","腹痛","头痛"]
	s NumSymtom = [].%FromJSON(SymptomStr)
	s Result = []
	for i = 0:1:(NumSymtom.%Size()-1)
	{		
	    s Symptom=NumSymtom.%Get(i)
	    s SymptomU=$ZCONVERT(Symptom,"U")
	    ///w Symptom,!
	    if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU)))
	    {
			d Result.%Push(Symptom)
			//s Result = SymptomU
			//q 
    	}
	}
	q Result.%ToJSON()
}

/// Creator:luweijie
/// CreatDate:2021-6-15
/// 获取疾病关联诊断因子表中的症状对应的疾病名称，权重，和三个判断条件
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorIF()
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorIF("性生活连续规律正常,1年以上未避孕")
ClassMethod GetDataOfficeDiseJFactorIF(SymptomStr As %String) As %String
{
	//s SymptomStr = ["发热","头痛","腹痛","头痛"]
	s NumSymtom = [].%FromJSON(SymptomStr)
	s Result = ""
	for i = 0:1:(NumSymtom.%Size()-1)
	{		
	    s Symptom=NumSymtom.%Get(i)
	    s SymptomU=$ZCONVERT(Symptom,"U")
	    ///w Symptom,!
	    if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU)))
	    {
			s Result = SymptomU
			q 
    	}
	}
	q Result
}

/// Creator:luweijie
/// CreatDate:2021-6-15
/// 获取疾病关联诊断因子表中的症状对应的疾病名称，权重，和三个判断条件
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorIF()
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorIF("性生活连续规律正常,1年以上未避孕")
ClassMethod GetDemoDiseJFactorIF(SymptomStr As %String) As %String
{
	//s SymptomStr = ["发热","头痛","腹痛","头痛"]
	s NumSymtom = [].%FromJSON(SymptomStr)
	s Result = ""
	for i = 0:1:(NumSymtom.%Size()-1)
	{		
	    s Symptom=NumSymtom.%Get(i)
	    s SymptomU=$ZCONVERT(Symptom,"U")
	    if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU)))
	    {
			s Result = SymptomU
			q 
    	}
	}
	q Result
}

/// Creator:luweijie
/// CreatDate:2021-6-15
/// 获取疾病关联诊断因子表中的症状对应的疾病名称，权重，和三个判断条件
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorInfo()
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJFactorInfo("性生活连续规律正常,1年以上未避孕")
ClassMethod GetDHCDSSDiseJFactorInfo(SymptomStr As %String) As %String
{
	
	///s NumSymtom = ["肺癌","头痛","腹痛","头痛"]
	///s NumSymtom = SymptomStr.%ToJSON()
	s NumSymtom = [].%FromJSON(SymptomStr)
	s Result = ""
	for i = 0:1:(NumSymtom.%Size()-1)
	{		
	    s Symptom=NumSymtom.%Get(i)
	    s SymptomU=$ZCONVERT(Symptom,"U")
	    if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU)))
	    {
    		s SymRowid=$o(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU,""))
    		s SymUseFlag =$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(SymRowid)),5) continue:SymUseFlag'=2
			s Rowid=0
			for	
				{
					s Rowid=$o(^CT.WDT.CDSS.DiseJFactorI("FactorIndex",SymRowid,Rowid)) q:Rowid=""
					s DiseaseDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),2)
					continue:DiseaseDR=""
					s DiseJPropertyID=$o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",DiseaseDR,0)) //疾病关联属性表V2.0
					continue:DiseJPropertyID=""
					s Status=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(DiseJPropertyID)),30) //状态
					continue:Status="已下线"
					
					s DiseaseUseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),18) continue:DiseaseUseFlag'=2
					s DiseaseName=""
					s:DiseaseDR'="" DiseaseName= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
					continue:DiseaseName=""
					s DiseaseCode= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),2)
					s RareDiseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),19)
					///w DiseaseCode,!
					///筛选掉R和Z码
					if (DiseaseCode'["R")&(DiseaseCode'["Z")
					{
						/// 诊断因子等级	
						s FactorGrade =$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),5)
						/// 是否否定条件（0否，1是）
						s IsNegatCondi = $lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),6)
						/// 是否充要条件（0否，1是）
						s IsNecessAndSuffiCondi =$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),7)
						/// 是否必要条件（0否，1是）
						s IsNecessCondi =$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),8)
						/// 是否住院召回（0否，1是）
						s IsHospRecall = $lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),9)
						/// 是否门诊召回（0否，1是）
						s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),10)
						if Result = ""
						{
							s Result = DiseaseDR_"^^"_DiseaseName_"^^"_SymRowid_"^^"_Symptom_"^^"_FactorGrade_"^^"_IsNegatCondi_"^^"_IsNecessAndSuffiCondi_"^^"_IsNecessCondi_"^^"_IsHospRecall_"^^"_IsOutpatientRecall_"^^"_RareDiseFlag
						}
						else
						{
							s Result = Result_"**"_DiseaseDR_"^^"_DiseaseName_"^^"_SymRowid_"^^"_Symptom_"^^"_FactorGrade_"^^"_IsNegatCondi_"^^"_IsNecessAndSuffiCondi_"^^"_IsNecessCondi_"^^"_IsHospRecall_"^^"_IsOutpatientRecall_"^^"_RareDiseFlag
						}
					}
				}
				
    	}    
	}
    q Result
}

/// Creator:luweijie
/// CreatDate:2021-7-9
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseJPropertyInfo(["胆囊结石伴胆囊炎"])
ClassMethod GetDHCDSSDiseJPropertyInfo(Dieaselst As %String) As %String
{
	      
	s length=[].%FromJSON(Dieaselst)
	///s length=(Dieaselst)
    s Result=""
    for i=0:1:(length.%Size()-1)
    {
	    s Diease=length.%Get(i)
	    s DieaseU=$ZCONVERT(Diease,"U")
	    
	    if ($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DieaseU)))
	    {
    		
    		s ITRowid=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DieaseU,"")) 
			s Rowid=0
			for
			{
				s Rowid=$o(^CT.WDT.CDSS.DiseJPropertyI("DiseaseDRIndex",ITRowid,Rowid)) q:Rowid="" //疾病关联属性表V2.0
				/// 性别限制（无，男，女）
				s SexLimit=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),3)
				/// 高发性别（无，男，女）
				s PopuSex=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),4)		
				/// 常见科室（科室id串）CT.WDT.CDSS.DiseaseDeptDict
				s CommonDept = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),19)
				/// 疾病关联诊断因子必要条件个数
				s NumOfNConditions = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),32)
				if NumOfNConditions = ""
				{
					s NumOfNConditions = "0"
				}
				s CommonDeptName =""
				if CommonDept '= ""
				{
					s Dept = $l(CommonDept,",")
					for num=1:1:Dept
						{
							s ID = $p(CommonDept,",",num)
							
							s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(ID)),3)
							if CommonDeptName =""
							{
								s CommonDeptName = DeptName
							}
							else
							{
								s CommonDeptName = CommonDeptName_","_DeptName
							}
							
						}
				}
				
				/// 是否急危重症（0否，1是）
				s IsEmergency = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),20)
				if IsEmergency=""
				{
					s IsEmergency="0"
				}
				
				/// 高发种族（找到实例之后再说，目前是文本）
				s PopuNation = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),21)
				/// 高发地区（找到实例之后再说，目前是文本
				s PopuRegion = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),22)
				/// 年龄限制最小值（天）
				s AgeLimitMinDays = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),33)
				/// 年龄限制最大值（天）
				s AgeLimitMaxDays = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),34)
				/// 高发年龄段最小值（天）
				s PopuAgeMinDays = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),35)
				/// 高发年龄段最大值（天）
				s PopuAgeMaxDays = $lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),36)
				
				/// 是否包含年龄限制最小值（0否，1是）
				s IsIncludeAgeLimitMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),8)
				if IsIncludeAgeLimitMin=""
				{
					s IsIncludeAgeLimitMin="0"
				}
				
				/// 是否包含年龄限制最大值（0否，1是）
				s IsIncludeAgeLimitMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),11)
				if IsIncludeAgeLimitMax=""
				{
					s IsIncludeAgeLimitMax="0"
				}
				
				/// 是否包含高发年龄段最小值（0否，1是）
				s IsIncludePopuAgeMin=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),15)
				if IsIncludePopuAgeMin=""
				{
					s IsIncludePopuAgeMin="0"
				}
				
				/// 是否包含高发年龄段最大值（0否，1是）
				s IsIncludePopuAgeMax=$lg($g(^CT.WDT.CDSS.DiseJPropertyD(Rowid)),18)
				if IsIncludePopuAgeMax=""
				{
					s IsIncludePopuAgeMax="0"
				}
				
				if Result = ""
					{
						/*
						疾病，疾病id，性别限制，高发性别，常见科室，是否急危，高发种族，高发地区，必要条件个数
						年龄限制最小值（天），年龄限制最大值（天），高发年龄段最小值（天），高发年龄段最大值（天）
						是否包含高发年龄段最小值，是否包含高发年龄段最大值，是否包含高发年龄段最小值
						是否包含年龄限制最大值
						*/ 
						s Result = Diease_"^^"_ITRowid_"^^"_SexLimit_"^^"_PopuSex_"^^"_CommonDeptName_"^^"_IsEmergency_"^^"_PopuNation_"^^"_PopuRegion_"^^"_NumOfNConditions_"^^"_AgeLimitMinDays_"^^"_AgeLimitMaxDays_"^^"_PopuAgeMinDays_"^^"_PopuAgeMaxDays_"^^"_IsIncludePopuAgeMin_"^^"_IsIncludePopuAgeMax_"^^"_IsIncludeAgeLimitMin_"^^"_IsIncludeAgeLimitMax
					}
					else
					{
						s Result = Result_"**"_Diease_"^^"_ITRowid_"^^"_SexLimit_"^^"_PopuSex_"^^"_CommonDeptName_"^^"_IsEmergency_"^^"_PopuNation_"^^"_PopuRegion_"^^"_NumOfNConditions_"^^"_AgeLimitMinDays_"^^"_AgeLimitMaxDays_"^^"_PopuAgeMinDays_"^^"_PopuAgeMaxDays_"^^"_IsIncludePopuAgeMin_"^^"_IsIncludePopuAgeMax_"^^"_IsIncludeAgeLimitMin_"^^"_IsIncludeAgeLimitMax
					}	
			}
	    }
	}
	q Result
}

/// Description：患者模型的枚举接口
/// Input：IDNO^PatientDR^VisitID^VisitType^UserID^UserName^CTLocID^CTLocDesc^Config^枚举字段  IDNO患者主索引 PatientDR病人标识 VisitID就诊次数编号 UserID用户ID UserName用户名 CTLocID科室ID CTLocDesc 科室名称 枚举字段（姓名/性别等,A为全部）
/// Output: 返回枚举字段的json串
/// w ##class(web.CDSS.Public.PatientInformation).GetPatientEnumInfoV2("DH002^te002^1^^1^Demo Group^1^^1^门诊症状")
/// w ##class(web.CDSS.Public.PatientInformation).GetPatientEnumInfoV2("DH002^te002^1^^1^Demo Group^1^^1^住院症状")
/// w ##class(web.CDSS.Public.PatientInformation).GetPatientEnumInfoV2("XiaMenXiangAN993832^993832^1^住院^1^Demo Group^1^^1^门诊症状")
ClassMethod GetPatientEnumInfoV2(PatentVar As %String) As %String
{
	s IDNO=$p(PatentVar,"^",1)
	s PatientDR=$p(PatentVar,"^",2)
	s VisitID=$p(PatentVar,"^",3)
	s VisitType=$p(PatentVar,"^",4) //就诊类型
	s Config=$p(PatentVar,"^",9)
	s Type=$p(PatentVar,"^",10)
	if Config="" 
	{
		s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	}
	s TypeCode=Type
	if TypeCode["CDD"
	{
		s DictItemRowId=""
		s:TypeCode'="" DictItemRowId=$o(^User.DHCDSSBasicsDictI("ItemCodeIndex"," "_$ZCONVERT(TypeCode,"U"),"")) //基础信息字典集合表
		s TypeName=""
		s:DictItemRowId'="" TypeName=$listGet($g(^User.DHCDSSBasicsDictD(DictItemRowId)),9)
		s Type=TypeName
	}
	if (Type="门诊症状")
	{
		s PatientInfo=""
		s BaseID=""
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		}
		if BaseID '= ""
		{
			s Sex=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),7)
			s:(Sex'="") Sex="{""Sex"":"""_Sex_"""}"
			s Age=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),8)
			s:(Age'="") Age="{""Age"":"""_Age_"""}"
			if (PatientInfo'="")
			{
		  		s:(Sex'="") PatientInfo=PatientInfo_","_Sex
			}
			else
			{
				s:(Sex'="") PatientInfo=Sex	
			}
			if (PatientInfo'="")
			{
		  		s:(Age'="") PatientInfo=PatientInfo_","_Age
			}
			else
			{
				s:(Age'="") PatientInfo=Age	
			}
		}
		if SignID '= ""
		{
			s BodyTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),6)
			s:(BodyTemperature'="") BodyTemperature="{""BodyTemperature"":"""_BodyTemperature_"""}"
			s Pulse=$lg($g(^WDT.CDSS.SignInfoD(SignID)),8)
			s:(Pulse'="") Pulse="{""Pulse"":"""_Pulse_"""}"
			s BreathFeature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),9)
			s:(BreathFeature'="") BreathFeature="{""BreathFeature"":"""_BreathFeature_"""}"
			s HeartRate=$lg($g(^WDT.CDSS.SignInfoD(SignID)),10)
			s:(HeartRate'="") HeartRate="{""HeartRate"":"""_HeartRate_"""}"
			s Height=$lg($g(^WDT.CDSS.SignInfoD(SignID)),14)
			s:(Height'="") Height="{""Height"":"""_Height_"""}"
			s Weight=$lg($g(^WDT.CDSS.SignInfoD(SignID)),15)
			s:(Weight'="") Weight="{""Weight"":"""_Weight_"""}"
			s DiastolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),18)
			s:(DiastolicBlood'="") DiastolicBlood="{""DiastolicBlood"":"""_DiastolicBlood_"""}" 	
			s SystolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),19)
			s:(SystolicBlood'="") SystolicBlood="{""SystolicBlood"":"""_SystolicBlood_"""}"
			if (PatientInfo'="")
			{
		  		s:(BodyTemperature'="") PatientInfo=PatientInfo_","_BodyTemperature
			}
			else
			{
				s:(BodyTemperature'="") PatientInfo=BodyTemperature	
			}
			if (PatientInfo'="")
			{
		  		s:(Pulse'="") PatientInfo=PatientInfo_","_Pulse
			}
			else
			{
				s:(Pulse'="") PatientInfo=Pulse	
			}
			if (PatientInfo'="")
			{
		  		s:(BreathFeature'="") PatientInfo=PatientInfo_","_BreathFeature
			}
			else
			{
				s:(BreathFeature'="") PatientInfo=BreathFeature	
			}
			if (PatientInfo'="")
			{
		 	 	s:(HeartRate'="") PatientInfo=PatientInfo_","_HeartRate
			}
			else
			{
				s:(HeartRate'="") PatientInfo=HeartRate	
			}
			if (PatientInfo'="")
			{
		  		s:(Height'="") PatientInfo=PatientInfo_","_Height
			}
			else
			{
				s:(Height'="") PatientInfo=Height	
			}
			if (PatientInfo'="")
			{
		  		s:(Weight'="") PatientInfo=PatientInfo_","_Weight
			}
			else
			{
				s:(Weight'="") PatientInfo=Weight	
			}
			if (PatientInfo'="")
			{
		  		s:(DiastolicBlood'="") PatientInfo=PatientInfo_","_DiastolicBlood
			}
			else
			{
				s:(DiastolicBlood'="") PatientInfo=DiastolicBlood	
			}
			if (PatientInfo'="")
			{
		  		s:(SystolicBlood'="") PatientInfo=PatientInfo_","_SystolicBlood
			}
			else
			{
				s:(SystolicBlood'="") PatientInfo=SystolicBlood	
			}
		}
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s PhysicalExam=##class(web.CDSS.Public.PatientModel).GetPhysicalExam(IDNO,PatientDR,VisitID,VisitType,Config)
		s SpecExamInfo=##class(web.CDSS.Public.PatientModel).GetSpecExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		
	
		if (PatientInfo'="")
		{
		  s:(CurrentMedHistory'="") PatientInfo=PatientInfo_","_CurrentMedHistory
		}
		else
		{
			s:(CurrentMedHistory'="") PatientInfo=CurrentMedHistory	
		}
		
		if (PatientInfo'="")
		{
		  s:(PhysicalExam'="") PatientInfo=PatientInfo_","_PhysicalExam
		}
		else
		{
			s:(PhysicalExam'="") PatientInfo=PhysicalExam	
		}
		if (PatientInfo'="")
		{
		  s:(SpecExamInfo'="") PatientInfo=PatientInfo_","_SpecExamInfo
		}
		else
		{
			s:(SpecExamInfo'="") PatientInfo=SpecExamInfo	
		}
		
		
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
	}
	elseif (Type="住院症状")
	{
		
		s PatientInfo=""
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}
		if BaseID '= ""
		{
			s Sex=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),7)
			s:(Sex'="") Sex="{""Sex"":"""_Sex_"""}"
			s Age=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),8)
			s:(Age'="") Age="{""Age"":"""_Age_"""}"
			if (PatientInfo'="")
			{
		  		s:(Sex'="") PatientInfo=PatientInfo_","_Sex
			}
			else
			{
				s:(Sex'="") PatientInfo=Sex	
			}
			if (PatientInfo'="")
			{
		  		s:(Age'="") PatientInfo=PatientInfo_","_Age
			}
			else
			{
				s:(Age'="") PatientInfo=Age	
			}
		}
		
		
		s SignInfo=##class(web.CDSS.Public.PatientModel).GetPatientSignInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PhysicalExam=##class(web.CDSS.Public.PatientModel).GetPhysicalExam(IDNO,PatientDR,VisitID,VisitType,Config)
		s ExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s LabInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		
	
		if (PatientInfo'="")
		{
		  s:(SignInfo'="") PatientInfo=PatientInfo_","_SignInfo
		}
		else
		{
			s:(SignInfo'="") PatientInfo=SignInfo	
		}
		if (PatientInfo'="")
		{
		  s:(PatienCompInfo'="") PatientInfo=PatientInfo_","_PatienCompInfo
		}
		else
		{
			s:(PatienCompInfo'="") PatientInfo=PatienCompInfo	
		}
		if (PatientInfo'="")
		{
		  s:(PhysicalExam'="") PatientInfo=PatientInfo_","_PhysicalExam
		}
		else
		{
			s:(PhysicalExam'="") PatientInfo=PhysicalExam	
		}
		if (PatientInfo'="")
		{
		  s:(ExamInfo'="") PatientInfo=PatientInfo_","_ExamInfo
		}
		else
		{
			s:(ExamInfo'="") PatientInfo=ExamInfo	
		}
		if (PatientInfo'="")
		{
		  s:(LabInfo'="") PatientInfo=PatientInfo_","_LabInfo
		}
		else
		{
			s:(LabInfo'="") PatientInfo=LabInfo	
		}
		if (PatientInfo'="")
		{
		  s:(CurrentMedHistory'="") PatientInfo=PatientInfo_","_CurrentMedHistory
		}
		else
		{
			s:(CurrentMedHistory'="") PatientInfo=CurrentMedHistory	
		}
		
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
	}
	else
	{
		return ""
	}
}

/// Description：获取患者信息当前触发的识别词列表
/// Table：WDT.CDSS.PatTriggerIW
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSPatTriggerIW("GXPCS07^GXPCS07^1^门诊^6464^石萧伟^111^信息部^1")
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSPatTriggerIW("GXPCS09^GXPCS09^1^^1^Demo Group^1^^1")
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSPatTriggerIW("cardiology22^cardiology22^1^^1^Demo Group^1^^1")
ClassMethod GetDHCDSSPatTriggerIW(PatentVar As %String) As %String
{
	q:PatentVar="" "[]"
	s IDNO=$p(PatentVar,"^",1)
	s PatientDR=$p(PatentVar,"^",2)
	s VisitID=$p(PatentVar,"^",3)
	s VisitType=$p(PatentVar,"^",4) //就诊类型
	s Config=$p(PatentVar,"^",9)
	if Config=""
	{
		s Config="1"
	}
	s a= IDNO_","_PatientDR_","_VisitID_","_Config
	s Result = ""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="")
	{
		s CompID=0
		if ($d(^WDT.CDSS.PatTriggerIWI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s PatTriggerIWResult = ""
			for	
			{
				s PatTriggerInfo = ""
				s CompID =$o(^WDT.CDSS.PatTriggerIWI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,CompID)) q:CompID=""
				s SymID=$lg($g(^WDT.CDSS.PatTriggerIWD(CompID)),6) //识别词ID
				continue:SymID=""
				s PFiledNameStr=$lg($g(^WDT.CDSS.PatTriggerIWD(CompID)),9)
				s PTableNameStr=$lg($g(^WDT.CDSS.PatTriggerIWD(CompID)),8)
				s SymName = $lg($g(^CT.WDT.CDSS.IdentifyWordsD(SymID)),3) //识别词字典表V2.0
				s WordsType=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(SymID)),4) //识别词类型
				s PatTriggerIWIF="{""SymName"":"""_SymName_""",""PFiledNameStr"":"""_PFiledNameStr_""",""PTableNameStr"":"""_PTableNameStr_""",""IdentifyWordsDR"":"""_SymID_""",""WordsType"":"""_WordsType_"""}"
				if (PatTriggerIWResult = "")
				{
					s PatTriggerIWResult = PatTriggerIWIF
				}
				else
				{
					s PatTriggerIWResult = PatTriggerIWResult_","_PatTriggerIWIF
				}
			}	
		}
		else
		{
			s PatTriggerIWResult = ""
		}	
	}
	else
	{
		s PatTriggerIWResult = ""
	}
	s PatTriggerIWResult = "["_PatTriggerIWResult_"]"
	q PatTriggerIWResult
}

/// Description：获取患者信息当前触发的识别词列表
/// Table：WDT.CDSS.PatTriggerIW
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSPatTriggerIW("GXPCS07^GXPCS07^2^门诊^6464^石萧伟^111^信息部^1")
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSPatTriggerIW("GXPCS09^GXPCS09^1^^1^Demo Group^1^^1")
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSPatTriggerIW("cardiology22^cardiology22^1^^1^Demo Group^1^^1")
/// w ##class(web.CDSS.Public.PatientInformation).GetNLPResult()
ClassMethod GetNLPResult(PatentVar As %String) As %String
{
	s PatientNum = 1
	for 
	{	
		s PatientName = "cardiology"_PatientNum
		if ($d(^WDT.CDSS.PatientMasterI("PatDRIndex",""_PatientName,0)))
		{
			//w PatientName,!
			s CompID=$o(^WDT.CDSS.PatientMasterI("PatDRIndex",""_PatientName))
			s SymID=$lg($g(^WDT.CDSS.PatTriggerIWD(CompID)),6)
		}
		
		s PatientNum = PatientNum + 1
		q:PatientNum=10
	}
	q ""
}

/// Description：获取疾病名称和ID
/// Table：CT.WDT.CDSS.DiseaseDict
/// Creator：luweijie
/// CreatDate：2021-11-2
/// Input：JSON串
/// Output：字符串
/// Others：w ##class(web.CDSS.Public.PatientInformation).GetNLPResult()
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseID(["喘息性肺炎","手足口病","上呼吸道感染","天花"])
ClassMethod GetDHCDSSDiseID(Dieaselst As %String) As %String
{
	s length=[].%FromJSON(Dieaselst)
	///s length=(Dieaselst)
    s Result=""
    for i=0:1:(length.%Size()-1)
    {
	    s Diease=length.%Get(i)
	    s DieaseU=$ZCONVERT(Diease,"U")
	    if ($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DieaseU))) //疾病字典
	    {
    		s ITRowid=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DieaseU,"")) 
			s Rowid=0
			s result = """"_DieaseU_""":"""_ITRowid_""""

			if Result = ""
			{
				s Result = result
			}
			else
			{
				s Result = ""_Result_","_result_""
				
			}
				
	    }
	}
	s Result = "{"_Result_"}"
	q Result
}

/// Creator:luweijie
/// CreatDate:2021-11-9
/// w ##class(web.CDSS.Public.PatientInformation).GetDiseAndFactor(["手足口病","周期性呕吐","后循环缺血"])
/// w ##class(web.CDSS.Public.PatientInformation).GetDise("1^2")
ClassMethod GetDise(Num As %String) As %String
{
#;	w Num,!
	s NUM=$p(Num,"""",2)
	///s NUM =[].%ToJSON(Num)
	///s NUM =[].%FromJSON(Num)
	s Start=$p(NUM,"^",1)
	s End=$p(NUM,"^",2)
#;	w Start,!
#;	w End,!
	s DiseaseRowid= 0
	s Result=""
	for i=Start:1:End
	{
		s result = ""   
	 	s FactorIf = ""
	 	s FactorList = ""
		s DiseaseRowid=i
		s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowid)),3) //疾病字典
		s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowid)),2)
		s Rowid=0
	 	for
	 	{
		 	s Rowid=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowid,Rowid)) q:Rowid="" //疾病关联诊断因子表V2.0
			s SymptomDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),3)
			s FactorType=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),4)
			s FactorGrade=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),5)
			s:SymptomDR'="" SymptomName= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(SymptomDR)),3)
			///w DiseaseName_","_SymptomName_","_SymptomDR,!
			if FactorType '= ""
			{
				s:SymptomName'="" FactorIf = "["""_SymptomName_""","""_FactorGrade_""","""_FactorType_"""]"
			}
			else
			{
				s:SymptomName'="" FactorIf = "["""_SymptomName_""","""_FactorGrade_""",""空""]"
			}
			if FactorList = ""
			{
				s FactorList = FactorIf
			}
			else
			{
				s FactorList = ""_FactorList_","_FactorIf_""
			}
		}
		s FactorLIST = "["_FactorList_"]"
	    s result = """"_DiseaseName_"---"_DiseaseCode_""":"_FactorLIST_""
	    if Result = ""
	    {
			s Result = result
		} 
		else
		{
			s Result = ""_Result_","_result_""
		}
		
	
	}
	s Result = "{"_Result_"}"
    q Result
}

/// Creator:luweijie
/// CreatDate:2021-11-9
/// w ##class(web.CDSS.Public.PatientInformation).GetDiseAndFactor(["手足口病","周期性呕吐","后循环缺血"])
/// w ##class(web.CDSS.Public.PatientInformation).GetDiseAndFactor(["手足口病"])
ClassMethod GetDiseAndFactor(Dieaselst As %String) As %String
{
	      
	///s length=[].%FromJSON(Dieaselst)
	s length=(Dieaselst)
    s Result=""
    for i=0:1:(length.%Size()-1)
    {
	    s Diease=length.%Get(i)
	    s DieaseU=$ZCONVERT(Diease,"U")
	 	s result = ""   
	 	s FactorIf = ""
	 	s FactorList = ""
	    if ($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DieaseU)))
	    {
		    s DiseaseRowid=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DieaseU,""))
		    s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseRowid)),2)
		    ///w DiseaseRowid
			s Rowid=0
			for	
 				{
					s Rowid=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowid,Rowid)) q:Rowid=""
					s SymptomDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),3)
					s FactorType=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),4)
					s FactorGrade=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),5)
					s:SymptomDR'="" SymptomName= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(SymptomDR)),3) //诊断因子字典库V2.0 
					if FactorType '= ""
					{
						s:SymptomName'="" FactorIf = "["""_SymptomName_""","""_FactorGrade_""","""_FactorType_"""]"
					}
					else
					{
						s:SymptomName'="" FactorIf = "["""_SymptomName_""","""_FactorGrade_""",""空""]"
					}
					

					if FactorList = ""
					{
						s FactorList = FactorIf
					}
					else
					{
						s FactorList = ""_FactorList_","_FactorIf_""
					}
					
 				}
 			s FactorLIST = "["_FactorList_"]"
	    s result = """"_DieaseU_"^^^"_DiseaseCode_""":"_FactorLIST_""
	    if Result = ""
	    	{
				s Result = result
			} 
		else
			{
				s Result = ""_Result_","_result_""
			}
		
	    }
	}
	s Result = "{"_Result_"}"
    q Result
}

/// Creator:鲁为杰
/// Description：获取诊断因子对应的疾病和信息
/// CreatDate:2022-2-17
/// w ##class(web.CDSS.Public.PatientInformation).GetTCMDisease(["手足口病","周期性呕吐","后循环缺血"])
/// w ##class(web.CDSS.Public.PatientInformation).GetTCMDisease(["发热"])
/// w ##class(web.CDSS.Public.PatientInformation).GetTCMDiseaseFactorInfo("")
ClassMethod GetTCMDiseaseFactorInfo(SymptomList As %String) As %String
{
	//s SymptomList = ["胃痛","上腹胀","嘈杂"]
	//s SymptomList = ["咳嗽^^105225","发烧^^105204"]

	s SymptomList = [].%FromJSON(SymptomList)
	s Result = ""
	for i = 0:1:(SymptomList.%Size()-1)
	{		
	    s SymptomAllInfo=SymptomList.%Get(i)
	    s Symptom=$p(SymptomAllInfo,"^^","1")
	    s SymptomU=$ZCONVERT(Symptom,"U")
	    s SymptomID=$p(SymptomAllInfo,"^^","2")
	    //if ($d(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_SymptomU)))
	    if ($d(^CT.WDT.CDSS.IdentifyWordsD(SymptomID))) //是否是识别词
	    {
			//s SymRowid=$o(^CT.WDT.CDSS.IdentifyWordsI("DescIndex"," "_SymptomU,""))
			s SymRowid=SymptomID
			s Rowid=0
			for
			{
				s Rowid=$o(^CT.WDT.CDSS.TCMDiseJWordsI("WordIndex",SymRowid,Rowid)) q:Rowid=""
				
				///疾病DR
				//w Rowid,!
				s DiseaseDR=$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),2)
				//w DiseaseDR,!
				s:DiseaseDR'="" DiseaseName=$lg($g(^CT.WDT.CDSS.TCMDiseaseD(DiseaseDR)),3)
				//w DiseaseName,!
				
				/// 诊断因子等级	
				s FactorGrade =$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),5)
				/// 是否否定条件（0否，1是）
				s IsNegatCondi = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),6)
				/// 是否充要条件（0否，1是）
				s IsNecessAndSuffiCondi =$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),7)
				/// 是否必要条件（0否，1是）
				s IsNecessCondi =$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),8)
				/// 是否住院召回（0否，1是）
				s IsHospRecall = $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),9)
				/// 是否门诊召回（0否，1是）
				s IsOutpatientRecall= $lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),10)
				
				if Result = ""
				{
					s Result = DiseaseDR_"^^"_DiseaseName_"^^"_SymRowid_"^^"_Symptom_"^^"_FactorGrade_"^^"_IsNegatCondi_"^^"_IsNecessAndSuffiCondi_"^^"_IsNecessCondi
				}
				else
				{
					s Result = Result_"**"_DiseaseDR_"^^"_DiseaseName_"^^"_SymRowid_"^^"_Symptom_"^^"_FactorGrade_"^^"_IsNegatCondi_"^^"_IsNecessAndSuffiCondi_"^^"_IsNecessCondi
				}
				//w Result,!
			
			}
	 
		}
	}
	q Result
}

/// Creator:鲁为杰
/// Description：获取疾病对应的证候和信息
/// CreatDate:2022-2-21
/// w ##class(web.CDSS.Public.PatientInformation).GetTCMDiseJSymInfo(["胃脘痛病","胃痞病"],["胃痛","上腹胀","嘈杂"])
ClassMethod GetTCMDiseJSymInfo(DiseaseList As %String, SymptomList As %String) As %String
{
	//s DiseaseList = ["胃脘痛病","胃痞病"]
	//s SymptomList = ["胃痛","上腹胀","嘈杂","畏寒"]
	//s DiseaseList = ["感冒"]
	//s SymptomList = ["咳嗽^^105225","发热^^105204"]
	
	s DiseaseList = [].%FromJSON(DiseaseList)
#;	w DiseaseList,!
	s SymptomList = [].%FromJSON(SymptomList)
#;	w SymptomList,!
	s Result = ""
	for i = 0:1:(DiseaseList.%Size()-1)
	{		
	    s Disease=DiseaseList.%Get(i)
	    s DiseaseU=$ZCONVERT(Disease,"U")
	    s TCMSymNameList=""
		s result=""
		///w "疾病======",DiseaseU,!
	    if ($d(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiseaseU))) //中医疾病字典
	    {
			s DiseaseRowid=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiseaseU,""))
			s Rowid=0
			for
			{
				s Rowid=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseDRIndex",DiseaseRowid,Rowid)) q:Rowid="" //中医疾病关联证候
				s TCMSymDR=$lg($g(^CT.WDT.CDSS.TCMDiseJSymD(Rowid)),3) //证候ID
				s TCMSymName=$lg($g(^CT.WDT.CDSS.TCMSymptomD(TCMSymDR)),3) //中医证候字典,证候名称
				//w "症形：",TCMSymName,!
				s SymInforesult=""
				s TCMDiseJSymRowid=0
				for
				{
					//中医辩证识别词表
					s TCMDiseJSymRowid=$o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",Rowid,TCMDiseJSymRowid)) q:TCMDiseJSymRowid=""
					s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseJSymRowid)),3)
					s WordName=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3) 
					s WordGrade=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseJSymRowid)),5) //等级
					s IsNegatCondi=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseJSymRowid)),6) //是否否定条件
					s IsNecessAndSuffiCondi=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseJSymRowid)),7) //是否充要条件
					s IsNecessCondi=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(TCMDiseJSymRowid)),8) //是否必要条件
					//w WordName,!
					continue:(WordName="")||(WordGrade="")
					
					s WordFlag=0
					for j = 0:1:(SymptomList.%Size()-1)
					{		
	    				s Symptom=$p(SymptomList.%Get(j),"^^",1)
	    				s SymptomID=$p(SymptomList.%Get(j),"^^",2)
	    				s SymptomU=$ZCONVERT(Symptom,"U")
	    				
	    				//if WordName=SymptomU
	    				if WordDR=SymptomID
	    				{
		    				s WordFlag=1
		    				q
		    			}
					}
					if WordFlag=1
					{
						if SymInforesult=""
						{
							//s SymInforesult = """"_WordName_""":["_WordGrade_","_IsNegatCondi_","_IsNecessAndSuffiCondi_","_IsNecessCondi_"]"
							//s SymInforesult = """"_WordName_""":""["_WordGrade_","_IsNegatCondi_","_IsNecessAndSuffiCondi_","_IsNecessCondi_"]"""
							s SymInforesult = """"_WordName_""":"""_WordGrade_"^"_IsNegatCondi_"^"_IsNecessAndSuffiCondi_"^"_IsNecessCondi_""""
						}
						else
						{
							//s SymInforesult = SymInforesult_","""_WordName_""":["_WordGrade_","_IsNegatCondi_","_IsNecessAndSuffiCondi_","_IsNecessCondi_"]"
							//s SymInforesult = SymInforesult_","""_WordName_""":""["_WordGrade_","_IsNegatCondi_","_IsNecessAndSuffiCondi_","_IsNecessCondi_"]"""
							s SymInforesult = SymInforesult_","""_WordName_""":"""_WordGrade_"^"_IsNegatCondi_"^"_IsNecessAndSuffiCondi_"^"_IsNecessCondi_""""
						}
					}
					else
					{
						if SymInforesult=""
						{
							s SymInforesult = """"_WordName_""":[]"
						}
						else
						{
							s SymInforesult = SymInforesult_","""_WordName_""":[]"
						}
					}
				}
				if SymInforesult'=""
				{
					s SymInforesult="{"_SymInforesult_"}"
				
					if result=""
					{
						s result=""""_TCMSymName_""":"_SymInforesult
					}
					else
					{
						s result=result_","""_TCMSymName_""":"_SymInforesult
					}
				}
			}
			if result'=""
			{
				s result = """"_DiseaseU_""":{"_result_"}"
			}
			//w result
	    }
	    if result'=""
	    {
	    	if Result=""
	    	{
		    	s Result=result
			}
	    	else
	    	{
		    	s Result = Result_","_result
			}
	    }
	    
	
	}
	s Result = "{"_Result_"}"
  
	q Result
}

/// Creator:鲁为杰
/// Description：获取疾病频次表中疾病信息
/// CreatDate:2022-3-1
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseaseFreq2()
ClassMethod GetDHCDSSDiseaseFreq2() As %String
{
	s TotelDiseSymFreq=..CountTotalFreq()
	s DiseTotal=$p(TotelDiseSymFreq,",",1)
	s SymTotal=$p(TotelDiseSymFreq,",",2)
	//w DiseTotal,!
	//w SymTotal,!
	s MaxDiseaseFreq = 5500
	s MinDiseaseFreq = 4000
	s RowID=0
	for DiseFreq=MaxDiseaseFreq:-1:MinDiseaseFreq
	{
		if ($d(^User.DHCDSSDiseaseFreqI("DiseaseFreqIndex",DiseFreq)))
		{
			s DiseFreqID=0
			for
			{
				s DiseFreqID=$o(^User.DHCDSSDiseaseFreqI("DiseaseFreqIndex",DiseFreq,DiseFreqID)) q:DiseFreqID=""
				s DiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseFreqID)),2)
				s DictDiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseFreqID)),5)
				s DiseaseFreq= $lg($g(^User.DHCDSSDiseaseFreqD(DiseFreqID)),3)
				//w DictDiseaseName_","_DiseaseName_","_(DiseaseFreq/DiseTotal),!
			}
 
		}
		
	}
	q ""
}

/// Creator:鲁为杰
/// Description：获取疾病频次表中疾病信息
/// CreatDate:2022-4-13
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseaseInfo("3") 
ClassMethod GetDHCDSSDiseaseInfo(DiseRowID As %String) As %String
{
	s Result =""
	if ($d(^User.DHCDSSDiseaseFreqD(DiseRowID)))
	{
		///原始疾病名称
		s DiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),2)
		///对照字典表中疾病名称
		s DictDiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),4)
		/// 知识库疾病名称-》调字典对照接口(归一词)
		s DictFormalDiseaseName=$lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),5)
		/// 知识库疾病名称-》调字典对照接口(上位词)
		s DictCoreDiseaseName=$lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),6)
#;		///疾病频次
#;		s DiseaseFreq= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),3)
		s DiseaseFreq= 0 
		s DiseSymTotal =0 
		s DiseList = ""
		if (DictDiseaseName '= "")
		{
			s DiseID=0
			for 
			{
				s DiseID=$o(^User.DHCDSSDiseaseFreqI("DictDiseaseNameIndex"," "_DictDiseaseName,DiseID)) q:DiseID=""
				//w DiseID,!
				
				if DiseList =""
				{
					s DiseList = DiseID
				}
				else
				{
					s DiseList = DiseList_"**"_DiseID
				}
				///疾病下症状总频次
				s DiseSymFreq = ..GetDHCDSSDiseSymTotalFreq(DiseID)
				s NewDiseaseFreq = $lg($g(^User.DHCDSSDiseaseFreqD(DiseID)),3)
				s DiseaseFreq = DiseaseFreq + NewDiseaseFreq
				s DiseSymTotal = DiseSymTotal + DiseSymFreq
					
			}	
			s Result = DictDiseaseName_","_DiseaseFreq_","_DiseSymTotal_","_DiseList
		}
		elseif (DictDiseaseName '= "")
		{
			s Result = ""
		}
	}
	else
	{
		s Result = ""	
	}
	q Result
}

/// Creator:鲁为杰
/// Description：获取疾病频次表中疾病信息-备份
/// CreatDate:2022-3-1
/// w ##class(web.CDSS.Public.PatientInformation)GetDHCDSSDiseaseInfoBackUp("838") 
ClassMethod GetDHCDSSDiseaseInfoBackUp(DiseRowID As %String) As %String
{
	s Result =""
	if ($d(^User.DHCDSSDiseaseFreqD(DiseRowID)))
	{
		///原始疾病名称
		s DiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),2)
		///对照字典表中疾病名称
		s DictDiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),5)
#;		///疾病频次
#;		s DiseaseFreq= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),3)
		s DiseaseFreq= 0 
		s DiseSymTotal =0 
		s DiseList = ""
		if (DictDiseaseName '= "")
		{
			s DiseID=0
			for 
			{
				s DiseID=$o(^User.DHCDSSDiseaseFreqI("DictDiseaseNameIndex"," "_DictDiseaseName,DiseID)) q:DiseID=""
				//w DiseID,!
				
				if DiseList =""
				{
					s DiseList = DiseID
				}
				else
				{
					s DiseList = DiseList_"**"_DiseID
				}
				///疾病下症状总频次
				s DiseSymFreq = ..GetDHCDSSDiseSymTotalFreq(DiseID)
				s NewDiseaseFreq = $lg($g(^User.DHCDSSDiseaseFreqD(DiseID)),3)
				s DiseaseFreq = DiseaseFreq + NewDiseaseFreq
				s DiseSymTotal = DiseSymTotal + DiseSymFreq
					
			}	
			s Result = DictDiseaseName_","_DiseaseFreq_","_DiseSymTotal_","_DiseList
		}
		else
		{
			s Result = ""
		}
	}
	else
	{
		s Result = ""	
	}
	q Result
}

/// Creator:鲁为杰
/// Description：获取疾病频次表中疾病信息
/// CreatDate:2022-3-1
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSSymptomInfo("1")
ClassMethod GetDHCDSSSymptomInfo(DiseRowID As %String) As %String
{
	s Result =""
	s result = ""
	if ($d(^User.DHCDSSDiseFacFreqI("DiseaseDRIndex",DiseRowID)))
	{
		s DiseaseName = $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),5)
			
		if ($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseName)))
		{
					
			s DiseaseRowid=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseName,"")) 
			s Rowid=0
			for 
			{
				s Rowid=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseRowid,Rowid)) q:Rowid=""
				s SymptomDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),3)
				s FactorGrade=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),5) 
				s:SymptomDR'="" SymptomName= $lg($g(^CT.WDT.CDSS.DiagFactorBaseD(SymptomDR)),3)
				continue:FactorGrade=""
				if result ="" 
				{
					s result = """"_SymptomName_""":"_FactorGrade
				}
				else
				{
					s result = result_","""_SymptomName_""":"_FactorGrade
				}
			}
			s result = "{"_result_"}"
		}

		s DiseFacFreqID=0
		for
		{
				s DiseFacFreqID=$o(^User.DHCDSSDiseFacFreqI("DiseaseDRIndex",DiseRowID,DiseFacFreqID)) q:DiseFacFreqID=""
				s FactorDR = $lg($g(^User.DHCDSSDiseFacFreqD(DiseFacFreqID)),3)
				s DiseFactFreq = $lg($g(^User.DHCDSSDiseFacFreqD(DiseFacFreqID)),4)
				s FactorName = $lg($g(^User.DHCDSSFactorFreqD(FactorDR)),2)		
				continue:DiseFactFreq=1
				if Result ="" 
				{
					s Result = """"_FactorName_""":"_DiseFactFreq
				}
				else
				{
					s Result = Result_","""_FactorName_""":"_DiseFactFreq
				}
		}
		s Result = "{"_Result_"}"
		s RESULT = Result_"&&"_result
			
	}
	q RESULT
}

/// Creator:鲁为杰
/// Description：获取疾病频次表中疾病信息
/// CreatDate:2022-3-1
/// w ##class(web.CDSS.Public.PatientInformation).GetDHCDSSDiseSymTotalFreq("1")
ClassMethod GetDHCDSSDiseSymTotalFreq(DiseRowID As %String) As %String
{
	s Result =""
	if ($d(^User.DHCDSSDiseFacFreqI("DiseaseDRIndex",DiseRowID)))

		{
			s DiseaseName= $lg($g(^User.DHCDSSDiseaseFreqD(DiseRowID)),2)
			s DiseFacFreqID=0
			s DiseSymTotal = 0
			for
			{
				s DiseFacFreqID=$o(^User.DHCDSSDiseFacFreqI("DiseaseDRIndex",DiseRowID,DiseFacFreqID)) q:DiseFacFreqID=""
				s DiseFactFreq = $lg($g(^User.DHCDSSDiseFacFreqD(DiseFacFreqID)),4)
				s DiseSymTotal = DiseSymTotal+DiseFactFreq 	
			}	
			s Result = DiseSymTotal
		}
	q Result
}

/// Creator:鲁为杰
/// Description：获取疾病频次表中疾病信息
/// CreatDate:2022-3-1
/// w ##class(web.CDSS.Public.PatientInformation).CountTotalFreq()
ClassMethod CountTotalFreq() As %String
{
	s TotalDiseFreq=0
	s TotalSymFreq=0
	s DiseID =0
	s SymID =0
	for 
	{
		s DiseID= $o(^User.DHCDSSDiseaseFreqD(DiseID))	q:DiseID=""
		s DiseFreq =$lg($g(^User.DHCDSSDiseaseFreqD(DiseID)),3)
		s TotalDiseFreq = TotalDiseFreq+DiseFreq
	}
	for 
	{
		s SymID=$o(^User.DHCDSSFactorFreqD(SymID)) q:SymID=""
		s SymFreq =$lg($g(^User.DHCDSSFactorFreqD(SymID)),3)
		
		s TotalSymFreq=TotalSymFreq+SymFreq
	}
	q TotalDiseFreq_","_TotalSymFreq
}

/// Creator:luweijie
/// CreatDate:2021-6-15
/// 获取疾病关联诊断因子表中的症状对应的疾病名称，权重，和三个判断条件
/// w ##class(web.CDSS.Public.PatientInformation).GetBNModelDise()
/// w ##class(web.CDSS.Public.PatientInformation).GetBNModelDise(["发热"])
ClassMethod GetBNModelDise(SymptomStr As %String) As %String
{
	
#;	s SymptomStr = ["发热","头痛","腹痛","头痛"]
#;	s NumSymtom = SymptomStr.%ToJSON()
	///s NumSymtom = [].%FromJSON(SymptomStr)
	s Result = ""
	for i = 0:1:(SymptomStr.%Size()-1)
	{		
	    s Symptom=SymptomStr.%Get(i)
	    s SymptomU=$ZCONVERT(Symptom,"U")
	    if ($d(^User.DHCDSSFactorFreqI("FactorNameIndex"," "_SymptomU)))
	    {
    		s SymRowid=$o(^User.DHCDSSFactorFreqI("FactorNameIndex"," "_SymptomU,"")) 
    		w SymRowid,!
    		s Rowid=0
			for	
			{
				s Rowid=$o(^User.DHCDSSDiseFacFreqI("FactorDRIndex",SymRowid,Rowid)) q:Rowid=""
				s DiseaseDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),2)
				s DictDiseaseName=$lg($g(^User.DHCDSSDiseaseFreqD(DiseaseDR)),5)
				if DictDiseaseName'=""
				{
					w DictDiseaseName_","_DiseaseDR,!
				}
				
				
			}
	    }
	
	}
	
	q ""
#;			s Rowid=0
#;			for	
#;				{
#;					s Rowid=$o(^CT.WDT.CDSS.DiseJFactorI("FactorIndex",SymRowid,Rowid)) q:Rowid=""
#;					s DiseaseDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(Rowid)),2)
#;					s DiseaseName=""
#;					s:DiseaseDR'="" DiseaseName= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),3)
#;					s DiseaseCode= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),2)
#;					s RareDiseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDictD(DiseaseDR)),19)
}

/// Creator:lideyuan
/// CreatDate:2020-05-13
/// Description：把非结构化数据通过调用nlp服务器接口，转化为结构化数据
/// Input：data: json格式数据，key:data,value:要结构化的内容
/// Output: 结构化结果json字符串
/// w ##class(web.CDSS.Public.PatientInformation).GetStructedDataAPI("入院前3+年，患儿出现反复性咳嗽，咳黄色粘痰，无气促、呼吸困难，无发热，无潮热、盗汗，无呕吐、腹泻、腹痛，无皮疹，无瘀点瘀斑等症状，病情加重时以“肺部感染”，于多家医院予以次抗感染治疗后病情稍好转。2020-4-10日于我院诊断为：肺部感染（流感嗜血杆菌、MRSA），并予以积极抗感染治疗后好转。我院行胸部CT提示右肺中下叶实变，局部支气管扩张现为进一步诊治，转入我院。    患儿患病以来，精神食欲、睡眠尚可，大小便量及外观未见异常，体重增长欠佳，目前体重24Kg。"",""PastDiagnosisSum"":""一般情况良好，否认 肝炎、结核或其他"",""PersonalHisSum"":""长期居住于原籍，职业学生，未到过牧区及疫区，无冶游史，无吸毒史，无吸烟史，无饮酒史。")
/// w ##class(web.CDSS.Public.PatientInformation).GetStructedDataAPI("患者10余天前饮酒后出现憋气不适，后逐渐缓解。此后间断出现，夜间睡眠时 多发，清醒后即好转。无双下肢浮肿、夜间阵发性呼吸困难、端坐呼吸。2019.8.5 于荆门当地医院行冠脉造影检查示：""右冠90%狭窄""。建议PCI治疗，转入我院。今为进一步治疗入院。    起病以来，患者精神、食欲尚可，睡眠差，大小便无异常，体重无改变，体力无下降。;")
ClassMethod GetStructedDataAPI(content As %String) As %String
{
	set httpRequest = ##class(%Net.HttpRequest).%New()
 	//s Url="http://192.144.152.252:8090/nlp/tag"
 	s Url=##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSldy2020070701")
 	if Url["https" //标版NLP用的https，腾讯云电信云用NLP外网是http
 	{
	 	s httpRequest.SSLConfiguration="SSLECP"
 		s httpRequest.SSLCheckServerIdentity=0	
	}
    Do httpRequest.SetHeader("Content-Type","application/x-www-form-urlencoded; charset=utf8")
    do httpRequest.InsertFormData("data", content)
    set status = httpRequest.Post(Url)
    If $$$ISERR(status) { Quit $system.OBJ.DisplayError(status) }
    s stream=##class(%Stream.GlobalCharacter).%New()
    s stream= httpRequest.HttpResponse.Data
    Set responseString =""
    while 'stream.AtEnd
    {
	    s responseString=responseString_stream.ReadLine()
	}
    Quit responseString
}

/// Creator:luweijie
/// CreatDate:2021-6-15
/// 获取疾病关联诊断因子表中的症状对应的疾病名称，权重，和三个判断条件
/// w ##class(web.CDSS.Public.PatientInformation).GetDiagInfo()
/// w ##class(web.CDSS.Public.PatientInformation).GetDiagInfo("DM000003^DM000003^1^^1^Demo Group^1^^1")
/// w ##class(web.CDSS.Public.PatientInformation).GetDiagInfo("DM000020^DM000020^1^住院^1^Demo Group^1^^1")
ClassMethod GetDiagInfo(PatientInfo As %String) As %String
{
	q:PatientInfo="" ""
	s IDNO=$p(PatientInfo,"^",1)
	q:IDNO="" ""
	s PatientDR=$p(PatientInfo,"^",2)
	s VisitID=$p(PatientInfo,"^",3)
	s Diag = ""
	s DiagResult =""
	if (IDNO'="")
    {
	    //患者信息表获取ID
	    s PatID =$o(^WDT.CDSS.DEMOPatMasterI("IDNOIndex",IDNO,0)) //$zcvt(IDNO,"U") 
	    q:PatID="" ""
	    // 入院记录获取确诊诊断
	    s PatDR =$o(^WDT.CDSS.DEMOAdmRecI("PatIndex",PatID,0))
	    q:PatDR="" ""
        s PreliminaryDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(PatDR)),15)	//初步诊断
        s ConfirmDiag=$lg($g(^WDT.CDSS.DEMOAdmRecD(PatDR)),16)	//确诊诊断
        if ConfirmDiag '= ""
        {
	    	s Diag = ConfirmDiag
	    }
	    elseif PreliminaryDiag '= ""
		{
			s Diag = PreliminaryDiag
		}
		if Diag '= ""
		{
			s DiagResult = ..GetStructedDataAPI(Diag) //诊断过NLP
			s:(DiagResult="[]")||(DiagResult["error") DiagResult=Diag
		}
    }
    q DiagResult  
	///w ##class(web.CDSS.Public.GetProjectData).GetStructedDataAPI
}

/// Creator:luweijie
/// CreatDate:2022-4-13
/// Description:判断诊断因子是否是疾病
/// Input：诊断因子列表
/// Output: 疾病列表
/// w ##class(web.CDSS.Public.PatientInformation).IsDisease(["胆囊结石伴胆囊炎","发热","呼吸困难","上呼吸道感染","胆囊息肉"])
ClassMethod IsDisease(Diseaselst As %String) As %String
{
	s length=[].%FromJSON(Diseaselst)
	///s length=(Diseaselst)
    s Result=""
    s DiseaseList=""
    for i=0:1:(length.%Size()-1)
    {
	    s Disease=length.%Get(i)
	    s DiseaseU=$ZCONVERT(Disease,"U")
	    
	    if ($d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseU)))
	    {
    		s ITRowid=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseU,"")) 
    		s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(ITRowid)),2)

    		if DiseaseCode'["R"
    		{
	    		if DiseaseList = ""
	    		{
		    		s DiseaseList = """"_DiseaseU_""":"""_ITRowid_""""
		    	}
		    	else
		    	{
			    	s DiseaseList = DiseaseList_","""_DiseaseU_""":"""_ITRowid_""""
			    }
    		}
	    }
    }
    s DiseaseList = "{"_DiseaseList_"}"
    q DiseaseList
}

/// Creator:luweijie
/// CreatDate:2022-4-13
/// Description:判断诊断因子是否是疾病
/// Input：诊断因子列表
/// Output: 疾病列表
/// w ##class(web.CDSS.Public.PatientInformation).GetDiseFreq(["血胸", "胆囊结石伴慢性胆囊炎", "肠粘连", "感染","纵隔肿瘤","椎管狭窄"])
ClassMethod GetDiseFreq(Diseaselst As %String) As %String
{

	s length=[].%FromJSON(Diseaselst)
    s Result=""
    s DiseaseList=""
    k arr
    s Result =""
    for i=0:1:(length.%Size()-1)
    {
	    s Disease=length.%Get(i)
	    s DiseaseU=$ZCONVERT(Disease,"U")
	    s DiseTotalFreq = 0
	    if ($d(^User.DHCDSSDiseaseFreqI("DictDiseaseNameIndex"," "_DiseaseU)))
	    {	
			s Rowid=0
			for 
			{
				s Rowid=$o(^User.DHCDSSDiseaseFreqI("DictDiseaseNameIndex"," "_DiseaseU,Rowid)) 
				q:Rowid=""
    			s DiseaseFreq=$lg($g(^User.DHCDSSDiseaseFreqD(Rowid)),3)
    			if DiseTotalFreq = 0
    			{
	    			s DiseTotalFreq = DiseaseFreq
	    		}
	    		else
	    		{
		    		s DiseTotalFreq = DiseTotalFreq + DiseaseFreq
		    	}		
	    	}		
	    }
	    elseif ($d(^User.DHCDSSDiseaseFreqI("DictFormalDiseaseNameIndex"," "_DiseaseU)))
	   	{
		   	s Rowid=0
			for 
			{
				s Rowid=$o(^User.DHCDSSDiseaseFreqI("DictFormalDiseaseNameIndex"," "_DiseaseU,Rowid)) 
				q:Rowid=""
    			s DiseaseFreq=$lg($g(^User.DHCDSSDiseaseFreqD(Rowid)),3)
    			if DiseTotalFreq = 0
    			{
	    			s DiseTotalFreq = DiseaseFreq
	    		}
	    		else
	    		{
		    		s DiseTotalFreq = DiseTotalFreq + DiseaseFreq
		    	}	
	    	}
		}

		if Result = ""
		{
			s Result=	""""_Disease_""":"_DiseTotalFreq_""
			
		}
		else
		{
			s Result=	Result_","""_Disease_""":"_DiseTotalFreq_""
		}
		
    }
    s Result = "{"_Result_"}"
    q Result
}

/// Function:患者信息表数据插入
/// Creater:鲁为杰
/// CreatDate:2022-5-6
/// w ##class(web.CDSS.Public.PatientInformation).SaveAccessLog(["Louie", "CDSS", "127.0.0.1","SuspectedDiseaseMainV2","N"])
ClassMethod SaveAccessLog(AccessLogINFO As %String) As %String
{
	s AccessLogINFO=[].%FromJSON(AccessLogINFO)
	s AccessUserName=AccessLogINFO.%Get(0) q:AccessUserName=""
	s AccessGroup=AccessLogINFO.%Get(1) q:AccessGroup=""
	s AccessIP=AccessLogINFO.%Get(2) q:AccessIP=""
	s AccessInterface=AccessLogINFO.%Get(3) q:AccessInterface=""
	s IsErroe=AccessLogINFO.%Get(4) q:IsErroe=""
	s obj=##class(User.DHCDSSAccessLog).%New()
/// 访问用户名
	s obj.AccessUserName=AccessUserName
/// 访问归属组
	s obj.AccessGroup=AccessGroup
/// 访问IP
	s obj.AccessIP=AccessIP 
/// 访问接口
	s obj.AccessInterface=AccessInterface
/// 是否报错
	s obj.IsErroe=IsErroe
/// 访问日期
	s obj.AccessTime=$ZDATETIME($HOROLOG,3)
	s sc =obj.%Save()
	if $$$ISOK(sc)
		{
			w "success",!
		}
		else
		{
			w $system.OBJ.DisplayError(sc),!

		}
	d obj.%Close()
	q ""
}

/// Function:找中医疾病的所有必要条件
/// Creater:wuzhe
/// CreatDate:2022-07-25
/// Input: "["咳嗽","水肿"...]"-JSON串
/// Output: 串：疾病^^必要条件个数^^识别词名称1^^识别词名称2...
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetTCMDisNecess("")
ClassMethod GetTCMDisNecess(DiagnosisALL As %String) As %String
{
	s result=""
	s DiagnosisList=["感冒"]
	//s DiagnosisList= [].%FromJSON(DiagnosisALL)
	for i = 0:1:(DiagnosisList.%Size()-1)
	{
	    s Diagnosis=DiagnosisList.%Get(i)
	    s DiagnosisU=$ZCONVERT(Diagnosis,"U")
	    s DisRowid=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiagnosisU,"")) //中医疾病字典
	    continue:DisRowid=""
	    
	    s Sum=0
	    s DisNecess=""
	    
		s Rowid=0
		for
		{
			s Rowid=$o(^CT.WDT.CDSS.TCMDiseJWordsI("DiseDRIndex",DisRowid,Rowid)) //中医疾病关联识别词表
			q:Rowid=""
			
			// 是否必要条件（0否，1是）
			s IsNecessCondi=$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),8)
			continue:(IsNecessCondi=0)||(IsNecessCondi="")
			
			s Sum=Sum+1
			// 识别词ID
			s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseJWordsD(Rowid)),3)
			s WordDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3) //识别词字典V2.0
			
			if DisNecess = ""
			{
				s DisNecess = WordDesc
			}
			else
			{
				s DisNecess = DisNecess_"^^"_WordDesc
			}
		}
		continue:(Sum=0)||(DisNecess="")
		
		if result=""
		{
			s result=Diagnosis_"^^"_Sum_"^^"_DisNecess
		}
		else
		{
			s result=result_"**"_Diagnosis_"^^"_Sum_"^^"_DisNecess
		}
	}
	q result
}

/// Function:找中医疾病关联证型的所有必要条件
/// Creater:wuzhe
/// CreatDate:2022-07-26
/// Input: "["感冒^^表闭水停证","感冒^^表实证"...]"-JSON串
/// Output: 
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetTCMDisJSymNecess("")
ClassMethod GetTCMDisJSymNecess(info As %String) As %String
{
	s result=""
	//s InfoList=["感冒^^表闭水停证","感冒^^表实证"]
	
	s InfoList= [].%FromJSON(info)
	for i = 0:1:(InfoList.%Size()-1)
	{
	    s Diagnosis=$p(InfoList.%Get(i),"^^",1)  //中医诊断
	    s DiagnosisU=$ZCONVERT(Diagnosis,"U")
	    s DiagJSym=$p(InfoList.%Get(i),"^^",2) //证型
	    s DiagJSymU=$ZCONVERT(DiagJSym,"U")
	    
	    s DisRowid=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiagnosisU,"")) //中医疾病字典
	    continue:DisRowid=""
	    
	    s SymRowid=$o(^CT.WDT.CDSS.TCMSymptomI("NameIndex"," "_DiagJSymU,"")) //中医症候字典
	    continue:SymRowid=""
	    
	    s DisJSymRowid=$o(^CT.WDT.CDSS.TCMDiseJSymI("DiseSymIndex",DisRowid,SymRowid,"")) //中医疾病关联证候表
	    continue:DisJSymRowid=""
	    
	    s SymNecess=""
	    s sum=0
	    s Rowid=0
	    for
	    {
		    s Rowid=$o(^CT.WDT.CDSS.TCMDiseSymJWordsI("DiseSymDRIndex",DisJSymRowid,Rowid)) //辨证识别词
	    	q:Rowid=""

	    	s IsNecessCondi=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(Rowid)),8) //必要条件
	    	continue:(IsNecessCondi=0)||(IsNecessCondi="")
			s WordDR=$lg($g(^CT.WDT.CDSS.TCMDiseSymJWordsD(Rowid)),3) 
			s WordDesc=$lg($g(^CT.WDT.CDSS.IdentifyWordsD(WordDR)),3) //识别词名称
			s sum=sum+1
			
			if SymNecess = ""
			{
				s SymNecess = WordDesc
			}
			else
			{
				s SymNecess = SymNecess_"^^"_WordDesc
			}
		} 
		continue:SymNecess=""
		
		if result=""
		{
			s result=Diagnosis_"^^"_DiagJSym_"^^"_sum_"^^"_SymNecess
		}
		else
		{
			s result=result_"**"_Diagnosis_"^^"_DiagJSym_"^^"_sum_"^^"_SymNecess
		}
	}
	q result
}

/// Function:找西医疾病关联诊断因子组合
/// Creater:wuzhe
/// CreatDate:2022-07-26
/// Input: DiseaseList：疾病JSON串
/// Output: 
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetDiseaseComposeRule("")
ClassMethod GetDiseaseComposeRule(DiseaseList As %String) As %String
{
	s result=""
	//s DiseaseArray=["心房颤动","心脏压塞"]
	s DiseaseArray= [].%FromJSON(DiseaseList)
	for i = 0:1:(DiseaseArray.%Size()-1)
	{
	    s Disease=DiseaseArray.%Get(i)  //诊断
	    s DiseaseU=$ZCONVERT(Disease,"U")
	    //s DisUTF=$ZCONVERT(Disease,"O","UTF8")
		//w DisUTF,!
		s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseU,"")) //疾病字典表
		continue:DiseaseDR=""
		
		s DisComposeID=0
		for
		{
			s DisComposeID=$o(^CT.WDT.CDSS.DiseJFactorCombI("DiseaseDRIndex",DiseaseDR,DisComposeID)) //疾病关联诊断因子组合表V2.0
			q:DisComposeID=""
			s DiseJFactorDRs=$lg($g(^CT.WDT.CDSS.DiseJFactorCombD(DisComposeID)),3) //疾病关联诊断因子的id串
			s CombGrade=$lg($g(^CT.WDT.CDSS.DiseJFactorCombD(DisComposeID)),4) //组合等级
			
			s FactorCompose=""
			for j=1:1:$l(DiseJFactorDRs,",")
			{
				s DisJFactorID=$p(DiseJFactorDRs,",",j)
				s FactorDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(DisJFactorID)),3) //疾病关联诊断因子表V2.0-诊断因子ID
				s DiagFactorName=""
				s:FactorDR'="" DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3) //诊断因子字典库V2.0-诊断因子名称
				if DiagFactorName'=""
				{
					if FactorCompose=""
					{
						s FactorCompose=DiagFactorName
					}
					else
					{
						s FactorCompose=FactorCompose_"^^"_DiagFactorName
					}
				}
			}
			continue:FactorCompose=""
			s FactorCompose=Disease_"^^"_CombGrade_"^^"_FactorCompose
			
			if result=""
			{
				s result=FactorCompose
			}
			else
			{
				s result=result_"**"_FactorCompose
			}
		} 
	}
	q result
}

/// Function:找中医疾病关联的属性
/// Creater:wuzhe
/// CreatDate:2022-08-10
/// Table: CT.WDT.CDSS.TCMDiseJProperty
/// Input: DiseaseList：疾病JSON串
/// Output: 
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetTCMDiseaseProperty("")
ClassMethod GetTCMDiseaseProperty(DiseaseList As %String) As %String
{
	s result=""
	//s DiseaseArray=["感冒"]
	s DiseaseArray= [].%FromJSON(DiseaseList)
	for i = 0:1:(DiseaseArray.%Size()-1)
	{
	    s Disease=DiseaseArray.%Get(i)  //诊断
	    s DiseaseU=$ZCONVERT(Disease,"U")
		s DiseaseDR=$o(^CT.WDT.CDSS.TCMDiseaseI("NameIndex",DiseaseU,"")) //中医疾病字典
		continue:DiseaseDR=""
		
		s PropertyID=$o(^CT.WDT.CDSS.TCMDiseJPropertyI("DiseDRIndex",DiseaseDR,"")) //中医疾病关联属性表
		continue:PropertyID=""
		
		s SexLimit=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),3) //性别限制
		s PopuSex=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),4) //高发性别
		
		s AgeLimitMin=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),6) //年龄限制最小值
		s AgeLimitMinUnit=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),7) //年龄限制最小值单位
		s IsIncludeAgeLimitMin=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),8) //是否包含年龄最小值
		
		s AgeLimitMax=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),9) //年龄限制最大值
		s AgeLimitMaxUnit=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),10) //年龄限制最大值单位（天，月，岁）
		s IsIncludeAgeLimitMax=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),11) //是否包含年龄限制最大值（0否，1是）
		
		
		s PopuAgeMin=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),13) //高发年龄段最小值
		s PopuAgeMinUnit=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),14) //高发年龄段最小值单位（天，月，岁）
		s IsIncludePopuAgeMin=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),15) //是否包含高发年龄段最小值（0否，1是）
		
		s PopuAgeMax=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),16) //高发年龄段最大值
		s PopuAgeMaxUnit=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),17) //高发年龄段最大值单位（天，月，岁）
		s IsIncludePopuAgeMax=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),18) //是否包含高发年龄段最大值（0否，1是）
		
		s CommonDept=$lg($g(^CT.WDT.CDSS.TCMDiseJPropertyD(PropertyID)),19) //常见科室
		
		if result=""
		{
			s result=Disease_"^^"_SexLimit_"^^"_PopuSex_"^^"_AgeLimitMin_"^^"_AgeLimitMinUnit_"^^"_IsIncludeAgeLimitMin_"^^"_AgeLimitMax_"^^"_AgeLimitMinUnit_"^^"_IsIncludeAgeLimitMax_"^^"_PopuAgeMin_"^^"_PopuAgeMinUnit_"^^"_IsIncludePopuAgeMin_"^^"_PopuAgeMax_"^^"_PopuAgeMaxUnit_"^^"_IsIncludePopuAgeMax_"^^"_CommonDept
		}
		else
		{
			s result=result_"**"_Disease_"^^"_SexLimit_"^^"_PopuSex_"^^"_AgeLimitMin_"^^"_AgeLimitMinUnit_"^^"_IsIncludeAgeLimitMin_"^^"_AgeLimitMax_"^^"_AgeLimitMinUnit_"^^"_IsIncludeAgeLimitMax_"^^"_PopuAgeMin_"^^"_PopuAgeMinUnit_"^^"_IsIncludePopuAgeMin_"^^"_PopuAgeMax_"^^"_PopuAgeMaxUnit_"^^"_IsIncludePopuAgeMax_"^^"_CommonDept
		}
	}
	q result
}

/// Function:筛选症状是否是诊断因子
/// Creator:wz
/// CreatDate:2023-02-03
/// Input: SymptomStr：症状JSON串
/// Output: 
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetDisFactor()
ClassMethod GetDisFactor(SymptomStr As %String) As %String
{
	q:SymptomStr="[]" [].%ToJSON()
	//s NumSymtom = ["突发左侧肢体无力", "左侧肢体无力、左侧肢体麻木无力、单侧肢体无力、左侧肢体乏力、一侧肢体无力、肢体无力、肢体麻木无力、乏力、疲乏"]
	s Result = []
	s NumSymtom = [].%FromJSON(SymptomStr)
	for i = 0:1:(NumSymtom.%Size()-1)
	{		
	    s Symptom=NumSymtom.%Get(i)
	    if Symptom["、"
	    {
		    for k=1:1:$l(Symptom,"、")
		    {
			    s SymptomNow=$p(Symptom,"、",k)
			    s SymptomU=$ZCONVERT(SymptomNow,"U")
			    if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU))) //诊断因子字典判断
			    {
				    d Result.%Push(SymptomU)
		    	}
			}
		}
	    else
	    {
		    s SymptomU=$ZCONVERT(Symptom,"U")
		    if ($d(^CT.WDT.CDSS.DiagFactorBaseI("NameIndex"," "_SymptomU))) //诊断因子字典判断
		    {
			    d Result.%Push(SymptomU)
	    	}
		}
	}
	q Result.%ToJSON()
}

/// Function:内涵质控推荐疑似疾病2.0单一症状接口
/// Creator:wz
/// CreatDate:2023-02-06
/// Input: PatientInfo：患者信息串，
/// Output: 
/// Others:w ##class(web.CDSS.Public.PatientInformation).RecordSingleLogic("DM000768^DM000768^1^住院^20^伍哲^1^信息科^Y","")
ClassMethod RecordSingleLogic(DiagFactorJSON As %String) As %String
{
	q:(DiagFactorJSON="[]") "0"
	s FactorList=[].%FromJSON(DiagFactorJSON)
	//s FactorList=["突发失明"]
	s Count=FactorList.%Size()
	s MatchFactor=""
	S RuleCode=0
	for
	{
		s RuleCode=$o(^CT.WDT.CDSS.SingleSymptomRuleI("TotalIndex",Count,RuleCode))    //获取症状个数为Count个的索引
		q:RuleCode=""
		
		s RuleRowid=$o(^CT.WDT.CDSS.SingleSymptomRuleI("TotalIndex",Count,RuleCode,0))
		s Flag="1"
		s SymptomList=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),4) //症状集合
		for j=1:1:$listlength(SymptomList) //疾病的诊断因子
		{
			s RuleSymptom=$lg(SymptomList,j)
			continue:RuleSymptom=""
			//疾病的诊断因子患者必须也有
			s FlagNo="0"
			for sum=0:1:FactorList.%Size()-1 //患者的诊断因子
			{
				s FactorStr=FactorList.%Get(sum)
				if FactorStr=RuleSymptom
				{
					if MatchFactor=""
					{
						s MatchFactor=RuleSymptom
					}
					else
					{
						s MatchFactor=MatchFactor_"^^"_RuleSymptom
					}
					s FlagNo="1"
				}
			}
			s:FlagNo="0" Flag="0"
			q:FlagNo="0"
		}
		continue:Flag="0"
		s RuleDiseases=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),10) //疾病集合
		
		s Result=""
		for m=1:1:$listlength(RuleDiseases)
		{
			s Disease=$lg(RuleDiseases,m) //疾病ID
			s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
			s:Result'="" Result=Result_"[N]"_DiseaseName
			s:Result="" Result=DiseaseName
		}
		if Result'=""
		{
			s Res = Result_"**"_MatchFactor
			return Res
		}
	}
	return "0"
}

/// Function:获取疾病的所有诊断因子
/// Creater:wuzhe
/// CreatDate:2023-03-15
/// Table: 
/// Input: Diangonsis:诊断名称
/// Output: Result：诊断因子集合，JSON传
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetDiseaseAllFactor("脑梗死")
/// w ##class(web.CDSS.Public.PatientInformation).GetDiseaseAllFactor("血病")
ClassMethod GetDiseaseAllFactor(Diangonsis As %String) As %String
{
	q:Diangonsis="" "{}"
	s Result={}
	s DiangonsisU=$ZCONVERT(Diangonsis,"U")
	if $d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiangonsisU)) //疾病字典是否存在
	{
		s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiangonsisU,0))
		s RowID=0
		for
		{
			s RowID=$o(^CT.WDT.CDSS.DiseJFactorI("DiseaseDRIndex",DiseaseID,RowID)) //疾病关联诊断因子表V2.0
			q:RowID=""
			s FactorDR=$lg($g(^CT.WDT.CDSS.DiseJFactorD(RowID)),3)
			continue:FactorDR=""
			//诊断因子字典库V2.0
			s DiagFactorName=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),3) //诊断因子名称
			continue:DiagFactorName=""
			s DiagFactorClass=$lg($g(^CT.WDT.CDSS.DiagFactorBaseD(FactorDR)),4) //诊断因子分类
			//w $d(Factor(DiagFactorName)),!
			if $d(Factor(DiagFactorName))=0 //不重复
			{
				d Result.%Set(DiagFactorName,DiagFactorClass)
				s Factor(DiagFactorName)=""
			}
		}
	}
	kill Factor
	q Result.%ToJSON()
}

/// Function:诊断别名转诊断名称
/// Creater:wuzhe
/// CreatDate:2023-05-05
/// Table: 
/// Input: Alias：别名
/// Output: Result：诊断名称
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetAlliasToDiag("主动脉夹层")
/// w ##class(web.CDSS.Public.PatientInformation).GetAlliasToDiag("阑尾炎")
ClassMethod GetAlliasToDiag(Alias As %String) As %String
{
	q:Alias="" ""
	s Result=""
	if $d(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Alias,"U")))  ///疾病字典表
	{
		s DiseaseID=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_$ZCONVERT(Alias,"U"),0))
		s Result=Alias
	}
	else ///不存在则判断通用别名表中是否存在（诊断的别名判断）
	{
		s DisBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",Alias,0)) ///通用字典表别名索引
		s:DisBieMingID'="" Result=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),3)
	}
	q Result
}

/// Function:诊断上位词别名转诊断名称
/// Creater:wuzhe
/// CreatDate:2023-05-06
/// Table: 
/// Input: 
/// Output: 
/// Others:w ##class(web.CDSS.Public.PatientInformation).GetCoreAlliasToDiag("['阑尾炎','主动脉夹层']")
/// w ##class(web.CDSS.Public.PatientInformation).GetCoreAlliasToDiag("1")
ClassMethod GetCoreAlliasToDiag(CoreJSON As %String) As %String
{
	q:CoreJSON="" "[]"
	s ResultArray=[]
	//s CoreJSON=$replace(CoreJSON,"'","""")
	//s CoreArray=["阑尾炎","主动脉夹层"]
	s CoreArray=[].%FromJSON(CoreJSON)
	for Sum=0:1:CoreArray.%Size()-1
	{
		s CoreNow=CoreArray.%Get(Sum)
		s DisBieMingID=$o(^CT.WDT.CDSS.AliasI("AliasIndex","CT.WDT.CDSS.DiseaseDict",CoreNow,0)) ///通用字典表别名索引
		if DisBieMingID'="" 
		{
			s Result=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DisBieMingID)),3) //别名转诊断名称
			d ResultArray.%Push(Result)
		}
		else
		{
			d ResultArray.%Push(CoreNow)
		}
	}
	q ResultArray.%ToJSON()
}

}

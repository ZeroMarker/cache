/// 名称: 获取患者模型的信息
/// 描述: 获取患者模型的信息
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-07
Class web.CDSS.Public.PatientModel Extends %RegisteredObject
{

/// Creator:dingyanan
/// CreatDate:2019-12-25
/// Description：获取患者基础信息表信息
/// Table：WDT.CDSS.PatientMaster
/// Input：IDNO 患者主索引 MedicareCardNum医保卡号 IDCardNumber身份证号
/// Output：患者基础信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientBaseInfo("DH001","te001","")
ClassMethod GetPatientBaseInfo(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="")||(Config="Y") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s BaseID=""
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{
		s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
	}
	elseif (IDNO'="")  //患者主索引
	{
		s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
	}
	
	q:BaseID="" ""
	s IDNO1=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),2)
	s PatientDR=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),3)
	s MedicareCardNumOrg= $lg($g(^WDT.CDSS.PatientMasterD(BaseID)),4)
	s MedicareCardNumlen=$l(MedicareCardNumOrg)
	s MedicareCardNum=MedicareCardNumOrg
	if (MedicareCardNumlen>10)
	{
		s MedicareCardNum=$E(MedicareCardNumOrg,1,6)_"****"_$E(MedicareCardNumOrg,*-3,*)
	}
	s IDCardNumberOrg= $lg($g(^WDT.CDSS.PatientMasterD(BaseID)),5)
	s IDCardNumberlen=$l(IDCardNumberOrg)
	s IDCardNumber=IDCardNumberOrg
	if (IDCardNumberlen=18)
	{
		s IDCardNumber=$E(IDCardNumberOrg,1,6)_"********"_$E(IDCardNumberOrg,*-3,*)
	}
	
	s NameOrg= $lg($g(^WDT.CDSS.PatientMasterD(BaseID)),6)
	s Namelen=$length(NameOrg)
	s Name=NameOrg
	if (Namelen>3)
	{
		s Name=$E(NameOrg,1)_"**"_$E(NameOrg,*)
	}
	elseif (Namelen=3)
	{
		s Name=$E(NameOrg,1)_"*"_$E(NameOrg,*)
	}
	elseif(Namelen=2)
	{
		s Name=$E(NameOrg,1)_"*"
	}
			
	s Sex=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),7)
	s Age=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),8)
	s Profession=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),9)
	s Nation=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),10)
	s Marriage=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),11)
	s BloodGroup=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),12)
	s Country=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),13)
	s Birthplace=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),14)
	s CurrentAddressOrg=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),15)
	s CurrentAddresslen=$l(CurrentAddressOrg)
	s CurrentAddress=CurrentAddressOrg
	if (CurrentAddresslen>2)
	{
		s CurrentAddress=$E(CurrentAddressOrg,1)_"****"_$E(CurrentAddressOrg,*)
	}
	elseif(CurrentAddresslen=2)
	{
		s CurrentAddress="*"_$E(CurrentAddressOrg,*)
	}
		
	s PhoneNumberOrg= $lg($g(^WDT.CDSS.PatientMasterD(BaseID)),16)
	s PhoneNumberlen=$l(PhoneNumberOrg)
	s PhoneNumber=PhoneNumberOrg
	if (PhoneNumberlen=11)
	{
		s PhoneNumber=$E(PhoneNumberOrg,1,3)_"****"_$E(PhoneNumberOrg,*-3,*)
	}
	
		
	
	s PatientBaseInfo="{""IDNO"":"""_IDNO1_""",""PatientDR"":"""_PatientDR_""",""MedicareCardNum"":"""_
	MedicareCardNum_""",""IDCardNumber"":"""_IDCardNumber_""",""Name"":"""_Name_""",""Sex"":"""_Sex_""",""Age"":"""_Age_""",""Profession"":"""_
	Profession_""",""Nation"":"""_Nation_""",""Marriage"":"""_Marriage_""",""BloodGroup"":"""_BloodGroup_""",""Country"":"""_
	Country_""",""Birthplace"":"""_Birthplace_""",""CurrentAddress"":"""_CurrentAddress_""",""PhoneNumber"":"""_PhoneNumber_"""}"
	s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
	return PatientBaseInfo
}

/// Creator:dingyanan
/// CreatDate:2019-12-25
/// Description：获取患者就诊信息表信息 
/// Table：WDT.CDSS.PatientVisit
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者就诊信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientVisitInfo("DH0001","te001","1","")
ClassMethod GetPatientVisitInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientVisitInfo="",VisitInfo=""
	s VisiID=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s VisiID =$o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,0)) 
		}
	} 
	elseif (IDNO'="")  //患者主索引
	{
		s VisiID =$o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
	}
	
	
	if (VisiID'="")  //就诊信息表ID不为空
	{
		//s VisitType=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),5)
		s TreatmentTime=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),6)
		//if TreatmentTime'="" s TreatmentTime=$zdate(TreatmentTime,3)
		s VisitingDepartment=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),7)
		s ComorbidityMarker=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),8)
		s TransferRecord=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),9)
		s DischargeTime=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),10)
		//if DischargeTime'="" s DischargeTime=$zdate(DischargeTime,3)
		s DischargeDepartment=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),11)
		s ChiefCompSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),12)
		s CurrentMedHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),13)
		s PastDiagnosisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),14)
		s FamilyHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),15)
		s PersonalHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),16)
		s MarryHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),17)
		s MenstrualHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),18)
		s AllergyHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),19)
		s PhysicalExamSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),20)
		s SpecExamSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),21)
		
		s VisitInfo="{""IDNO"":"""_IDNO_""",""VisiID"":"""_VisitID_""",""VisitType"":"""_VisitType_""",""TreatmentTime"":"""_TreatmentTime_""",""VisitingDepartment"":"""_VisitingDepartment_""",""ComorbidityMarker"":"""_ComorbidityMarker
		_""",""TransferRecord"":"""_TransferRecord_""",""DischargeTime"":"""_DischargeTime_""",""DischargeDepartment"":"""_DischargeDepartment_""",""ChiefCompSum"":"""_ChiefCompSum_""",""CurrentMedHisSum"":"""_CurrentMedHisSum
		_""",""PastDiagnosisSum"":"""_PastDiagnosisSum_""",""FamilyHisSum"":"""_FamilyHisSum_""",""PersonalHisSum"":"""_PersonalHisSum_""",""MarryHisSum"":"""_MarryHisSum_""",""MenstrualHisSum"":"""_MenstrualHisSum_""",""AllergyHisSum"":"""_AllergyHisSum
		_""",""AllergyHisSum"":"""_AllergyHisSum_""",""PhysicalExamSum"":"""_PhysicalExamSum_""",""SpecExamSum"":"""_SpecExamSum_"""}"
			
		if (PatientVisitInfo="")
		{
			s PatientVisitInfo=VisitInfo
		}
		else
		{
			s PatientVisitInfo=PatientVisitInfo_","_VisitInfo
		}
	}
	s PatientVisitInfo = ##class(web.BDP.util.String).Replace(PatientVisitInfo,"\","\\")
	return PatientVisitInfo
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者体征信息表信息 
/// Table：WDT.CDSS.SignInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者体征信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientSignInfo("","te001","1","")
ClassMethod GetPatientSignInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientSignInfo="",SignInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
		{
			s MeasureDate=0
			for{
				s MeasureDate=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate)) q:MeasureDate=""
				s SignID=0
				for{
					s SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID)) q:SignID=""
					s BodyTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),6)
					s BloodPressure=$lg($g(^WDT.CDSS.SignInfoD(SignID)),7)
					s Pulse=$lg($g(^WDT.CDSS.SignInfoD(SignID)),8)
					s BreathFeature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),9)
					s HeartRate=$lg($g(^WDT.CDSS.SignInfoD(SignID)),10)
					s OxygenSaturation=$lg($g(^WDT.CDSS.SignInfoD(SignID)),11)
					s Pupil=$lg($g(^WDT.CDSS.SignInfoD(SignID)),12)
					s CornealReflex=$lg($g(^WDT.CDSS.SignInfoD(SignID)),13)
					s Height=$lg($g(^WDT.CDSS.SignInfoD(SignID)),14)
					s Weight=$lg($g(^WDT.CDSS.SignInfoD(SignID)),15)
					//s MeasureDate=$lg($g(^WDT.CDSS.SignInfoD(SignID)),16)
					s PassFlag=$lg($g(^WDT.CDSS.SignInfoD(SignID)),17)
					s DiastolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),18)
					s SystolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),19)
					s OralTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),20)
					s AnalTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),21)
					
					s SignInfo="{""SignID"":"""_SignID_""",""BodyTemperature"":"""_BodyTemperature_""",""BloodPressure"":"""_BloodPressure_""",""Pulse"":"""_Pulse_""",""BreathFeature"":"""_BreathFeature_""",""HeartRate"":"""
						_HeartRate_""",""OxygenSaturation"":"""_OxygenSaturation_""",""Pupil"":"""_Pupil_""",""CornealReflex"":"""_CornealReflex_""",""Height"":"""_Height_""",""Weight"":"""_Weight
						_""",""MeasureDate"":"""_MeasureDate_""",""PassFlag"":"""_PassFlag_""",""DiastolicBlood"":"""_DiastolicBlood_""",""SystolicBlood"":"""_SystolicBlood_""",""OralTemperature"":"""_OralTemperature_""",""AnalTemperature"":"""_AnalTemperature_""",""TableName"":""WDT.CDSS.SignInfo""}"
					
					if (PatientSignInfo="")
					{
						s PatientSignInfo=SignInfo
					}
					else
					{
						s PatientSignInfo=PatientSignInfo_","_SignInfo
					}
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s MeasureDate=0
		for{
			s MeasureDate=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate)) q:MeasureDate=""
			s SignID=0
			for{
				s SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID)) q:SignID=""
				s BodyTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),6)
				s BloodPressure=$lg($g(^WDT.CDSS.SignInfoD(SignID)),7)
				s Pulse=$lg($g(^WDT.CDSS.SignInfoD(SignID)),8)
				s BreathFeature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),9)
				s HeartRate=$lg($g(^WDT.CDSS.SignInfoD(SignID)),10)
				s OxygenSaturation=$lg($g(^WDT.CDSS.SignInfoD(SignID)),11)
				s Pupil=$lg($g(^WDT.CDSS.SignInfoD(SignID)),12)
				s CornealReflex=$lg($g(^WDT.CDSS.SignInfoD(SignID)),13)
				s Height=$lg($g(^WDT.CDSS.SignInfoD(SignID)),14)
				s Weight=$lg($g(^WDT.CDSS.SignInfoD(SignID)),15)
				//s MeasureDate=$lg($g(^WDT.CDSS.SignInfoD(SignID)),16)
				//if MeasureDate'="" s MeasureDate1=$zdate(MeasureDate,3)
				s PassFlag=$lg($g(^WDT.CDSS.SignInfoD(SignID)),17)
				s DiastolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),18)
				s SystolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),19)
				s OralTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),20)
				s AnalTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),21)
					
				s SignInfo="{""SignID"":"""_SignID_""",""BodyTemperature"":"""_BodyTemperature_""",""BloodPressure"":"""_BloodPressure_""",""Pulse"":"""_Pulse_""",""BreathFeature"":"""_BreathFeature_""",""HeartRate"":"""
						_HeartRate_""",""OxygenSaturation"":"""_OxygenSaturation_""",""Pupil"":"""_Pupil_""",""CornealReflex"":"""_CornealReflex_""",""Height"":"""_Height_""",""Weight"":"""_Weight
						_""",""MeasureDate"":"""_MeasureDate_""",""PassFlag"":"""_PassFlag_""",""DiastolicBlood"":"""_DiastolicBlood_""",""SystolicBlood"":"""_SystolicBlood_""",""OralTemperature"":"""_OralTemperature_""",""AnalTemperature"":"""_AnalTemperature_""",""TableName"":""WDT.CDSS.SignInfo""}"
					
				if (PatientSignInfo="")
				{
					s PatientSignInfo=SignInfo
				}
				else
				{
					s PatientSignInfo=PatientSignInfo_","_SignInfo
				}
			}
		}
	}
	s PatientSignInfo = ##class(web.BDP.util.String).Replace(PatientSignInfo,"\","\\")
	return "["_PatientSignInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-05-14
/// Description：获取患者的部位 
/// Input：
/// Output：分级为1的部位
/// Table：User.DHCDSSBodyParDict
/// w ##class(web.CDSS.Public.PatientModel).GetPatienPart(149)
ClassMethod GetPatienPart(PartDR As %String) As %String
{
	q:##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict")'=1 ""
	s Part=""
	if (PartDR'="")
	{
		s BodyPartGrade=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),5) //取部位分级
		if (BodyPartGrade="1")
		{
			s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3) //取部位名称
		}
		else
		{
			s BodyLastLevel=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),10) //取部位的父级ID
			s:BodyLastLevel'="" Part=..GetPatienPart(BodyLastLevel)		
		}
	}
	q Part
}

/// Creator:dingyanan
/// CreatDate:2021-07-14
/// Description：获取患者的部位串（从根节点到叶子节点）
/// Input：
/// Output：
/// Table：User.DHCDSSBodyParDict
/// w ##class(web.CDSS.Public.PatientModel).GetPatienPartStr(13)
ClassMethod GetPatienPartStr(PartDR As %String) As %String
{
	q:##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict")'=1 ""
	s Part=""
	if (PartDR'="")
	{
		s BodyPartName=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3) 
		s BodyLastLevel=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),10) //取部位的父级ID
		if (BodyLastLevel'="")
		{
			s Part=..GetPatienPartStr(BodyLastLevel)_"-"_BodyPartName
		}
		else
		{
			s Part=BodyPartName
		}
		
	}
	q Part
}

/// Creator:dingyanan
/// CreatDate:2021-11-10
/// Description：获取CDSSV2.0患者的部位 
/// Input：
/// Output：获取最上级节点
/// Table：WDT.CDSS.BodyPartsDict,CT.WDT.CDSS.BodyPartsLevel
/// w ##class(web.CDSS.Public.PatientModel).GetPatienPart(149)
ClassMethod GetCDSS2PatienPart(PartDR As %String) As %String
{
	s Part=""
	if (PartDR'="")
	{
		s Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
		s LevelRowId=$O(^CT.WDT.CDSS.BodyPartsLevelI("PartDRIndex","解剖",PartDR,"")) //取部位分级表的RowId
		if (LevelRowId'="")
		{
			s BodyLastLevel=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(LevelRowId)),3) //取部位分级表的上级节点
			if (BodyLastLevel'="")
			{
				s Part=..GetCDSS2PatienPartLevel(BodyLastLevel)
			}	
		}
	}
	q Part
}

/// Creator:dingyanan
/// CreatDate:2021-11-10
/// Description：获取CDSSV2.0患者的部位 
/// Input：
/// Output：获取最上级节点
/// Table：WDT.CDSS.BodyPartsDict,CT.WDT.CDSS.BodyPartsLevel
/// w ##class(web.CDSS.Public.PatientModel).GetCDSS2PatienPartLevel(149)
ClassMethod GetCDSS2PatienPartLevel(LevelRowId As %String) As %String
{
	s Part=""
	if (LevelRowId'="")
	{
		s BodyPartDR=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(LevelRowId)),2) //取部位DR
		s:BodyPartDR'="" Part=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),2) //取部位名称
		s BodyLastLevel=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(LevelRowId)),3) //取部位分级表的上级节点
		if (BodyLastLevel'="")
		{
			s Part=..GetCDSS2PatienPartLevel(BodyLastLevel)
		}
	}
	q Part
}

/// Creator:dingyanan
/// CreatDate:2021-11-10
/// Description：获取CDSSV2.0患者的部位 （从根节点到叶子节点）
/// Input：
/// Output：
/// Table：WDT.CDSS.BodyPartsDict
/// w ##class(web.CDSS.Public.PatientModel).GetCDSS2PatienPartStr(13)
ClassMethod GetCDSS2PatienPartStr(PartDR As %String) As %String
{
	s Part=""
	if (PartDR'="")
	{
		s BodyPart=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(PartDR)),3) //取部位名称
		s LevelRowId=$O(^CT.WDT.CDSS.BodyPartsLevelI("PartDRIndex","解剖",PartDR,"")) //取部位分级表的RowId
		if (LevelRowId'="")
		{
			s BodyLastLevel=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(LevelRowId)),3) //取部位分级表的上级节点
			if (BodyLastLevel'="")
			{
				s Part=..GetCDSS2PatienPartLevelStr(BodyLastLevel)_"-"_BodyPart
			}
			else
			{
				s Part=BodyPart
			}	
		}	
	}
	q Part
}

/// Creator:dingyanan
/// CreatDate:2021-07-14
/// Description：获取患者的部位串（从根节点到叶子节点）
/// Input：
/// Output：
/// Table：WDT.CDSS.BodyParDict
/// w ##class(web.CDSS.Public.PatientModel).GetCDSS2PatienPartLevelStr(13)
ClassMethod GetCDSS2PatienPartLevelStr(LevelRowId As %String) As %String
{
	s Part=""
	if (LevelRowId'="")
	{
		s BodyPartDR=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(LevelRowId)),2) //取部位DR
		s BodyPart=""
		s:BodyPartDR'="" BodyPart=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),2) //取部位名称
		s BodyLastLevel=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(LevelRowId)),3) //取部位分级表的上级节点
		if (BodyLastLevel'="")
		{
			s Part=..GetCDSS2PatienPartLevelStr(BodyLastLevel)_"-"_BodyPart
		}
		else
		{
			s Part=BodyPart
		}
		
	}
	q Part
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者主诉信息表信息 
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者主诉信息表枚举字段的json串
/// Table：WDT.CDSS.ChiefCompInfo、User.DHCDSSBodyParDict
/// w ##class(web.CDSS.Public.PatientModel).GetPatienCompInfo("DH001","te001","1","")
ClassMethod GetPatienCompInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatienCompInfo="",CompInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.ChiefCompInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s CompID=0
			for
			{
				s CompID =$o(^WDT.CDSS.ChiefCompInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,CompID)) q:CompID=""
				s SymptomNum=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),6)
				s PartDR=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),7)
				s CDSS2PartDR=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),24)
				s Part="",PartL="",PartStr=""
				if (CDSS2PartDR'="")
				{
					s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
					s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
					s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
				}
				elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
				{
					s PartL=..GetPatienPart(PartDR)
					s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
					s PartStr=..GetPatienPartStr(PartDR)
				}
				s Symptom=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),8)
				s Duration=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),9)
				s AbnormalMax=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),10)
				s AbnormalMin=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),11)
				s NormalMax=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),12)
				s NormalMin=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),13)
				s RangeUnit=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),14)
				s RangeType=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),15)
				s Cause=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),16)
				s PassFlag=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),17)
				
				s MRCode=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),18)
				s SymptomType=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),19)
				s SymptomFormal=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),20)
				s SymptomCore=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),21)
				s SymProperty=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),22)
				s SymptomChildren=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),23)
				s PositionWord=""
				s PositionWordDR=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),25)
				s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
				s CompInfo="{""CompID"":"""_CompID_""",""SymptomNum"":"""_SymptomNum_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""Symptom"":"""_Symptom_""",""Duration"":"""_
					Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_AbnormalMin_""",""NormalMax"":"""_
					NormalMax_""",""NormalMin"":"""_NormalMin_""",""RangeUnit"":"""_RangeUnit_""",""RangeType"":"""_
					RangeType_""",""Cause"":"""_Cause_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""SymptomType"":"""_SymptomType_""",""SymptomFormal"":"""_
					SymptomFormal_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""SymptomChildren"":"""_SymptomChildren_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.ChiefCompInfo""}"
					
				
				if (PatienCompInfo="")
				{
					s PatienCompInfo=CompInfo
				}
				else
				{
					s PatienCompInfo=PatienCompInfo_","_CompInfo
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s CompID=0
		for
		{
			s CompID =$o(^WDT.CDSS.ChiefCompInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),CompID))
			q:CompID=""
			s SymptomNum=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),6)
			s PartDR=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),7)
			s CDSS2PartDR=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),24)
			s Part="",PartL="",PartStr=""
			if (CDSS2PartDR'="")
			{
				s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
				s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
				s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
			}
			elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
			{
				s PartL=..GetPatienPart(PartDR)
				s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
				s PartStr=..GetPatienPartStr(PartDR)
			}
			s Symptom=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),8)
			s Duration=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),9)
			s AbnormalMax=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),10)
			s AbnormalMin=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),11)
			s NormalMax=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),12)
			s NormalMin=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),13)
			s RangeUnit=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),14)
			s RangeType=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),15)
			s Cause=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),16)
			s PassFlag=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),17)
			
			s MRCode=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),18)
			s SymptomType=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),19)
			s SymptomFormal=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),20)
			s SymptomCore=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),21)
			s SymProperty=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),22)
			s SymptomChildren=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),23)
			s PositionWord=""
			s PositionWordDR=$lg($g(^WDT.CDSS.ChiefCompInfoD(CompID)),25)
			s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
			s CompInfo="{""CompID"":"""_CompID_""",""SymptomNum"":"""_SymptomNum_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""Symptom"":"""_Symptom_""",""Duration"":"""_
				Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_AbnormalMin_""",""NormalMax"":"""_
				NormalMax_""",""NormalMin"":"""_NormalMin_""",""RangeUnit"":"""_RangeUnit_""",""RangeType"":"""_
				RangeType_""",""Cause"":"""_Cause_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""SymptomType"":"""_SymptomType_""",""SymptomFormal"":"""_
					SymptomFormal_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""SymptomChildren"":"""_SymptomChildren_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.ChiefCompInfo""}"
				
			
			if (PatienCompInfo="")
			{
				s PatienCompInfo=CompInfo
			}
			else
			{
				s PatienCompInfo=PatienCompInfo_","_CompInfo
			}
		}
	}	
	s PatienCompInfo = ##class(web.BDP.util.String).Replace(PatienCompInfo,"\","\\")
	return PatienCompInfo
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者现病史信息表信息 
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：现病史信息表枚举字段的json串
/// Table：WDT.CDSS.CurrentMedHistory
/// w ##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory("DH001","te001","1")
ClassMethod GetCurrentMedHistory(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s CurrentMedHistory="",MedHistory=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.CurrentMedHistoryI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s CurrentID=0
			for
			{
				s CurrentID =$o(^WDT.CDSS.CurrentMedHistoryI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,CurrentID))
				q:CurrentID=""
				s CurMedHistoryOverview=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),6)
				s Status=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),7)
				s Cause=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),8)
				s PartDR=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),9)
				s CDSS2PartDR=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),25)
				s Part="",PartL="",PartStr=""
				if (CDSS2PartDR'="")
				{
					s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
					s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
					s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
				}
				elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
				{
					s PartL=..GetPatienPart(PartDR)
					s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
					s PartStr=..GetPatienPartStr(PartDR)
				}
				s Symptom=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),10)
				s Duration=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),11)
				s AbnormalMax=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),12)
				s AbnormalMin=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),13)
				s NormalMax=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),14)
				s NormalMin=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),15)
				s RangeUnit=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),16)
				s RangeType=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),17)
				s PassFlag=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),18)
				
				s MRCode=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),19)
				s SymptomType=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),20)
				s SymptomFormal=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),21)
				s SymptomCore=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),22)
				s SymProperty=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),23)
				s SymptomChildren=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),24)
				s PositionWord=""
				s PositionWordDR=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),26)
				s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
			
				s MedHistory="{""CurrentID"":"""_CurrentID_""",""Symptom"":"""_Symptom_""",""Status"":"""_Status_""",""Cause"":"""_
					Cause_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""Symptom"":"""_Symptom_""",""Duration"":"""_Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_
					AbnormalMin_""",""NormalMax"":"""_NormalMax_""",""NormalMin"":"""_NormalMin_""",""RangeUnit"":"""_
					RangeUnit_""",""RangeType"":"""_RangeType_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""SymptomType"":"""_SymptomType_""",""SymptomFormal"":"""_
					SymptomFormal_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""SymptomChildren"":"""_SymptomChildren_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.CurrentMedHistory""}"
					
				if (CurrentMedHistory="")
				{
					s CurrentMedHistory=MedHistory
				}
				else
				{
					s CurrentMedHistory=CurrentMedHistory_","_MedHistory
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s CurrentID=0
		for
		{
			s CurrentID =$o(^WDT.CDSS.CurrentMedHistoryI("IDNOIndex"," "_$zcvt(IDNO,"U"),CurrentID))
			q:CurrentID=""
			s CurMedHistoryOverview=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),6)
			s Status=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),7)
			s Cause=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),8)
			s PartDR=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),9)
			s CDSS2PartDR=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),25)
			s Part="",PartL="",PartStr=""
			if (CDSS2PartDR'="")
			{
				s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
				s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
				s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
			}
			elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
			{
				s PartL=..GetPatienPart(PartDR)
				s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
				s PartStr=..GetPatienPartStr(PartDR)
			}
			s Symptom=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),10)
			s Duration=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),11)
			s AbnormalMax=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),12)
			s AbnormalMin=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),13)
			s NormalMax=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),14)
			s NormalMin=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),15)
			s RangeUnit=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),16)
			s RangeType=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),17)
			s PassFlag=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),18)
			s MRCode=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),19)
			s SymptomType=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),20)
			s SymptomFormal=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),21)
			s SymptomCore=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),22)
			s SymProperty=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),23)
			s SymptomChildren=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),24)
			s PositionWord=""
			s PositionWordDR=$lg($g(^WDT.CDSS.CurrentMedHistoryD(CurrentID)),26)
			s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
			s MedHistory="{""CurrentID"":"""_CurrentID_""",""Symptom"":"""_Symptom_""",""Status"":"""_Status_""",""Cause"":"""_
				Cause_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""Symptom"":"""_Symptom_""",""Duration"":"""_Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_
				AbnormalMin_""",""NormalMax"":"""_NormalMax_""",""NormalMin"":"""_NormalMin_""",""RangeUnit"":"""_
				RangeUnit_""",""RangeType"":"""_RangeType_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""SymptomType"":"""_SymptomType_""",""SymptomFormal"":"""_
					SymptomFormal_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""SymptomChildren"":"""_SymptomChildren_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.CurrentMedHistory""}"
				
			if (CurrentMedHistory="")
			{
				s CurrentMedHistory=MedHistory
			}
			else
			{
				s CurrentMedHistory=CurrentMedHistory_","_MedHistory
			}
		}
	}
	s CurrentMedHistory = ##class(web.BDP.util.String).Replace(CurrentMedHistory,"\","\\")
	return CurrentMedHistory
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者既往史信息表信息 
/// Table：WDT.CDSS.PastDiagnosis
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者既往史信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPastDiagnosis("DH001","te001","1")
ClassMethod GetPastDiagnosis(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PastDiagnosis="",Diagnosis=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PastDiagnosisI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s PastID=0
			for
			{
				s PastID =$o(^WDT.CDSS.PastDiagnosisI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PastID)) q:PastID=""
				s PastHistoryNum=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),6)
				s PastDiagnosisName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),7)
				s DiagnosisType=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),8)
				s StartTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),9)
				if StartTime'="" s StartTime=$zdate(StartTime,3)
				s EndTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),10)
				if EndTime'="" s EndTime=$zdate(EndTime,3)
				s Duration=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),11)
				s Criticality=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),12)
				s TreatmentEffect=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),13)
				s Remarks=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),14)
				s PassFlag=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),15)
				s BloodTransName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),16)
				s Diagnosis="{""PastID"":"""_PastID_""",""PastHistoryNum"":"""_PastHistoryNum_""",""PastDiagnosisName"":"""_PastDiagnosisName_""",""DiagnosisType"":"""_DiagnosisType_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
					EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""TreatmentEffect"":"""_TreatmentEffect_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""BloodTransName"":"""_BloodTransName_""",""TableName"":""WDT.CDSS.PastDiagnosis""}"
				
				if (PastDiagnosis="")
				{
					s PastDiagnosis=Diagnosis
				}
				else
				{
					s PastDiagnosis=PastDiagnosis_","_Diagnosis
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s PastID=0
		for
		{
			s PastID =$o(^WDT.CDSS.PastDiagnosisI("IDNOIndex"," "_$zcvt(IDNO,"U"),PastID)) q:PastID=""
			s PastHistoryNum=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),6)
			s PastDiagnosisName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),7)
			s DiagnosisType=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),8)
			s StartTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),9)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),10)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),11)
			s Criticality=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),12)
			s TreatmentEffect=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),13)
			s Remarks=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),14)
			s PassFlag=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),15)
			s BloodTransName=$lg($g(^WDT.CDSS.PastDiagnosisD(PastID)),16)
			
			s Diagnosis="{""PastID"":"""_PastID_""",""PastHistoryNum"":"""_PastHistoryNum_""",""PastDiagnosisName"":"""_PastDiagnosisName_""",""DiagnosisType"":"""_DiagnosisType_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
				EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""TreatmentEffect"":"""_TreatmentEffect_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""BloodTransName"":"""_BloodTransName_""",""TableName"":""WDT.CDSS.PastDiagnosis""}"
			
			if (PastDiagnosis="")
			{
				s PastDiagnosis=Diagnosis
			}
			else
			{
				s PastDiagnosis=PastDiagnosis_","_Diagnosis
			}
		}
	}
	s PastDiagnosis = ##class(web.BDP.util.String).Replace(PastDiagnosis,"\","\\")			
	return "["_PastDiagnosis_"]"
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者个人史信息表信息 
/// Table：WDT.CDSS.PersonalInfo
/// Input：IDNO 患者主索引 
/// Output：患者个人史信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPersonalInfo("DH001","te001","")
ClassMethod GetPersonalInfo(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PersonalInfo="",Info=""
	s PersonalID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{	
		for
		{
			s PersonalID =$o(^WDT.CDSS.PersonalInfoI("PatDRIndex",PatientDR,PersonalID)) q:PersonalID=""
			s PersonalHistoryOverview=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),4)
			s StartTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),5)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),6)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),7)
			s Criticality=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),8)
			s Remarks=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),9)
			s PassFlag=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),10)
			s Value=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),12)
			s Frequency=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),13)
			
			s Info="{""PersonalID"":"""_PersonalID_""",""PersonalHistoryOverview"":"""_PersonalHistoryOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
				EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""Value"":"""_Value_""",""Frequency"":"""_Frequency_"""}"
				
			if (PersonalInfo="")
			{
				s PersonalInfo=Info
			}
			else
			{
				s PersonalInfo=PersonalInfo_","_Info
			}
		}
		
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s PersonalID =$o(^WDT.CDSS.PersonalInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),PersonalID)) q:PersonalID=""
			s PersonalHistoryOverview=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),4)
			s StartTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),5)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),6)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),7)
			s Criticality=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),8)
			s Remarks=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),9)
			s PassFlag=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),10)
			s Value=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),12)
			s Frequency=$lg($g(^WDT.CDSS.PersonalInfoD(PersonalID)),13)
			
			s Info="{""PersonalID"":"""_PersonalID_""",""PersonalHistoryOverview"":"""_PersonalHistoryOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
				EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""Value"":"""_Value_""",""Frequency"":"""_Frequency_"""}"
				
			if (PersonalInfo="")
			{
				s PersonalInfo=Info
			}
			else
			{
				s PersonalInfo=PersonalInfo_","_Info
			}
		}
	}
	s PersonalInfo = ##class(web.BDP.util.String).Replace(PersonalInfo,"\","\\")
	return "["_PersonalInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者婚育史信息表信息 
/// Table：WDT.CDSS.MarryInfo
/// Input：IDNO 患者主索引 
/// Output：患者婚育史信息枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetMarryInfo("DH001","te001","")
ClassMethod GetMarryInfo(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s MarryInfo="",Info=""
	s MarryID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{
		for
		{
			s MarryID =$o(^WDT.CDSS.MarryInfoI("PatDRIndex",PatientDR,MarryID)) q:MarryID=""
			s TypeOfMarriage=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),4)	
			s MarriageOverview=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),5)
			s StartTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),6)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),7)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),8)
			s Criticality=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),9)
			s Remarks=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),10)
			s PassFlag=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),11)
			s MRCode=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),12)
			
			s Info="{""MarryID"":"""_MarryID_""",""TypeOfMarriage"":"""_TypeOfMarriage_""",""MarriageOverview"":"""_MarriageOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_
				Criticality_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""TableName"":""WDT.CDSS.MarryInfo""}"
				
			if (MarryInfo="")
			{
				s MarryInfo=Info
			}
			else
			{
				s MarryInfo=MarryInfo_","_Info
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s MarryID =$o(^WDT.CDSS.MarryInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),MarryID)) q:MarryID=""
			s TypeOfMarriage=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),4)	
			s MarriageOverview=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),5)
			s StartTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),6)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),7)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),8)
			s Criticality=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),9)
			s Remarks=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),10)
			s PassFlag=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),11)
			s MRCode=$lg($g(^WDT.CDSS.MarryInfoD(MarryID)),12)
			
			s Info="{""MarryID"":"""_MarryID_""",""TypeOfMarriage"":"""_TypeOfMarriage_""",""MarriageOverview"":"""_MarriageOverview_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_
				Criticality_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""TableName"":""WDT.CDSS.MarryInfo""}"
				
			if (MarryInfo="")
			{
				s MarryInfo=Info
			}
			else
			{
				s MarryInfo=MarryInfo_","_Info
			}
		}
	}
	s MarryInfo = ##class(web.BDP.util.String).Replace(MarryInfo,"\","\\")
	return "["_MarryInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2019-12-26
/// Description：获取患者家族史信息表信息 
/// Table：WDT.CDSS.FamilyHisInfo
/// Input：IDNO 患者主索引 
/// Output：患者家族史信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetFamilyHisInfo("DH001")
ClassMethod GetFamilyHisInfo(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s FamilyHisInfo="",HisInfo=""
	s FamilyHisID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{
	
		for
		{
			s FamilyHisID =$o(^WDT.CDSS.FamilyHisInfoI("PatDRIndex",PatientDR,FamilyHisID)) q:FamilyHisID=""
			s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
			s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
			s GeneticDiseNo=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),6)
			s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
			s ConditionDescription=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),8)
			s StartTime=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),9)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),10)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),11)
			s Criticality=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),12)
			s IsCure=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),13)
			s Remarks=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),14)
			s PassFlag=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),15)
			s MRCode=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),16)
			
			s HisInfo="{""FamilyHisID"":"""_FamilyHisID_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseNo"":"""_
				GeneticDiseNo_""",""GeneticDiseName"":"""_GeneticDiseName_""",""ConditionDescription"":"""_ConditionDescription_""",""StartTime"":"""_
				StartTime_""",""EndTime"":"""_EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""IsCure"":"""_
				IsCure_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_"""}"
				
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s FamilyHisID =$o(^WDT.CDSS.FamilyHisInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),FamilyHisID)) q:FamilyHisID=""
			s Relationship=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),4)
			s RelativeName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),5)
			s GeneticDiseNo=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),6)
			s GeneticDiseName=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),7)
			s ConditionDescription=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),8)
			s StartTime=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),9)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),10)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s Duration=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),11)
			s Criticality=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),12)
			s IsCure=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),13)
			s Remarks=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),14)
			s PassFlag=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),15)
			s MRCode=$lg($g(^WDT.CDSS.FamilyHisInfoD(FamilyHisID)),16)
			
			s HisInfo="{""FamilyHisID"":"""_FamilyHisID_""",""Relationship"":"""_Relationship_""",""RelativeName"":"""_RelativeName_""",""GeneticDiseNo"":"""_
				GeneticDiseNo_""",""GeneticDiseName"":"""_GeneticDiseName_""",""ConditionDescription"":"""_ConditionDescription_""",""StartTime"":"""_
				StartTime_""",""EndTime"":"""_EndTime_""",""Duration"":"""_Duration_""",""Criticality"":"""_Criticality_""",""IsCure"":"""_
				IsCure_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_"""}"
				
			if (FamilyHisInfo="")
			{
				s FamilyHisInfo=HisInfo
			}
			else
			{
				s FamilyHisInfo=FamilyHisInfo_","_HisInfo
			}
		}
	}
	s FamilyHisInfo = ##class(web.BDP.util.String).Replace(FamilyHisInfo,"\","\\")
	return "["_FamilyHisInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-03-26
/// Description：获取患者过敏史信息 
/// Table：WDT.CDSS.PastDiagnosis
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者既往史信息表的过敏史枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPastDiagnosis("DH001")
ClassMethod GetAllergyHistory(IDNO As %String, PatientDR As %String, Config As %String) As %String
{
	
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s AllergyInfo="",Allergy=""
	s AllergyID=0
	if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
	{
		for
		{
			s AllergyID =$o(^WDT.CDSS.AllergyHistoryI("PatDRIndex",PatientDR,AllergyID)) q:AllergyID=""
			s AllergySourceName=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),4)
			s AllergySourceType=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),5)
			s AllergyHistoryNum=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),6)
			s StartTime=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),7)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),8)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s RiskLevel=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),9)
			s TreatmentEffect=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),10)
			s Remarks=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),11)
			s PassFlag=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),12)
			s MRCode=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),13)
			
			s Allergy="{""AllergyID"":"""_AllergyID_""",""PatientDR"":"""_PatientDR_""",""AllergySourceName"":"""_AllergySourceName_""",""AllergySourceType"":"""_AllergySourceType_""",""AllergyHistoryNum"":"""_AllergyHistoryNum_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
				EndTime_""",""RiskLevel"":"""_RiskLevel_""",""TreatmentEffect"":"""_TreatmentEffect_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""TableName"":""WDT.CDSS.AllergyHistory""}"
			
			if (AllergyInfo="")
			{
				s AllergyInfo=Allergy
			}
			else
			{
				s AllergyInfo=AllergyInfo_","_Allergy
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		for
		{
			s AllergyID =$o(^WDT.CDSS.AllergyHistoryI("IDNOIndex"," "_$zcvt(IDNO,"U"),AllergyID)) q:AllergyID=""
			s PatientDR=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),3)
			s AllergySourceName=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),4)
			s AllergySourceType=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),5)
			s AllergyHistoryNum=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),6)
			s StartTime=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),7)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),8)
			if EndTime'="" s EndTime=$zdate(EndTime,3)
			s RiskLevel=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),9)
			s TreatmentEffect=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),10)
			s Remarks=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),11)
			s PassFlag=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),12)
			s MRCode=$lg($g(^WDT.CDSS.AllergyHistoryD(AllergyID)),13)
			
			s Allergy="{""AllergyID"":"""_AllergyID_""",""PatientDR"":"""_PatientDR_""",""AllergySourceName"":"""_AllergySourceName_""",""AllergySourceType"":"""_AllergySourceType_""",""AllergyHistoryNum"":"""_AllergyHistoryNum_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_
				EndTime_""",""RiskLevel"":"""_RiskLevel_""",""TreatmentEffect"":"""_TreatmentEffect_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""TableName"":""WDT.CDSS.AllergyHistory""}"
			
			if (AllergyInfo="")
			{
				s AllergyInfo=Allergy
			}
			else
			{
				s AllergyInfo=AllergyInfo_","_Allergy
			}
		}
	}
	s AllergyInfo = ##class(web.BDP.util.String).Replace(AllergyInfo,"\","\\")
	return "["_AllergyInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2019-12-30
/// Description：获取患者体格检查信息表信息 
/// Table：WDT.CDSS.PhysicalExam
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者体格检查信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPhysicalExam("DH001","te001","1")
ClassMethod GetPhysicalExam(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s Part=""
	s PhysicalExam="",Exam=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PhysicalExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s PhysicalID=0
			for
			{
				s PhysicalID =$o(^WDT.CDSS.PhysicalExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,PhysicalID)) q:PhysicalID=""
				s Status=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),6)
				
				s PartDR=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),7)
				s CDSS2PartDR=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),24)
				s Part="",PartL="",PartStr=""
				if (CDSS2PartDR'="")
				{
					s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
					s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
					s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
				}
				elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
				{
					s PartL=..GetPatienPart(PartDR)
					s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
					s PartStr=..GetPatienPartStr(PartDR)
				}
				s ExamItem=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),8)
				
				s Duration=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),9)
				s AbnormalMax=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),10)
				s AbnormalMin=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),11)
				s NormalMax=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),12)
				s NormalMin=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),13)
				s RangeUnit=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),14)
				s RangeType=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),15)
				s SymptomNum=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),16)
				s Symptom=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),17)
				s PassFlag=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),18)
				
				s MRCode=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),19)
				s SymptomType=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),20)
				s SymptomFormal=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),21)
				s SymptomCore=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),22)
				s SymProperty=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),23)
				s PositionWord=""
				s PositionWordDR=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),25)
				s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
				
				s Exam="{""PhysicalID"":"""_PhysicalID_""",""Status"":"""_Status_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""ExamItem"":"""_ExamItem_""",""Duration"":"""_Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_AbnormalMin_""",""NormalMax"":"""_
					NormalMax_""",""NormalMin"":"""_NormalMin_""",""RangeUnit"":"""_RangeUnit_""",""RangeType"":"""_RangeType_""",""SymptomNum"":"""_SymptomNum_""",""Symptom"":"""_
					Symptom_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""SymptomType"":"""_SymptomType_""",""SymptomFormal"":"""_
					SymptomFormal_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.PhysicalExam""}"
					
				if (PhysicalExam="")
				{
					s PhysicalExam=Exam
				}
				else
				{
					s PhysicalExam=PhysicalExam_","_Exam
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s PhysicalID=0
		for
		{
			s PhysicalID =$o(^WDT.CDSS.PhysicalExamI("IDNOIndex"," "_$zcvt(IDNO,"U"),PhysicalID)) q:PhysicalID=""
			s Status=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),6)
			
			s PartDR=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),7)
			s CDSS2PartDR=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),24)
			s Part="",PartL="",PartStr=""
			if (CDSS2PartDR'="")
			{
				s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
				s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
				s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
			}
			elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
			{
				s PartL=..GetPatienPart(PartDR)
				s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
				s PartStr=..GetPatienPartStr(PartDR)
			}
			s ExamItem=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),8)
			
			s Duration=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),9)
			s AbnormalMax=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),10)
			s AbnormalMin=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),11)
			s NormalMax=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),12)
			s NormalMin=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),13)
			s RangeUnit=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),14)
			s RangeType=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),15)
			s SymptomNum=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),16)
			s Symptom=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),17)
			s PassFlag=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),18)
			s MRCode=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),19)
			s SymptomType=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),20)
			s SymptomFormal=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),21)
			s SymptomCore=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),22)
			s SymProperty=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),23)
			s PositionWord=""
			s PositionWordDR=$lg($g(^WDT.CDSS.PhysicalExamD(PhysicalID)),25)
			s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
			s Exam="{""PhysicalID"":"""_PhysicalID_""",""Status"":"""_Status_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""ExamItem"":"""_ExamItem_""",""Duration"":"""_Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_AbnormalMin_""",""NormalMax"":"""_
				NormalMax_""",""NormalMin"":"""_NormalMin_""",""RangeUnit"":"""_RangeUnit_""",""RangeType"":"""_RangeType_""",""SymptomNum"":"""_SymptomNum_""",""Symptom"":"""_
				Symptom_""",""PassFlag"":"""_PassFlag_""",""MRCode"":"""_MRCode_""",""SymptomType"":"""_SymptomType_""",""SymptomFormal"":"""_
					SymptomFormal_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.PhysicalExam""}"
				
			if (PhysicalExam="")
			{
				s PhysicalExam=Exam
			}
			else
			{
				s PhysicalExam=PhysicalExam_","_Exam
			}
		}
	}
	s PhysicalExam = ##class(web.BDP.util.String).Replace(PhysicalExam,"\","\\")
	return PhysicalExam
}

/// Creator:dingyanan
/// CreatDate:2019-12-30
/// Description：获取患者专科检查表信息 
/// Table：WDT.CDSS.SpecExam
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者专科检查表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetSpecExamInfo("DH001","te001","1")
ClassMethod GetSpecExamInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s SpecExamInfo="",ExamInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.SpecExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s SpecID=0
			for
			{
				s SpecID =$o(^WDT.CDSS.SpecExamI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,SpecID)) q:SpecID=""
				s Status=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),6)
				s PartDR=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),7)
				s CDSS2PartDR=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),20)
				s Part="",PartL="",PartStr=""
				if (CDSS2PartDR'="")
				{
					s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
					s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
					s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
				}
				elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
				{
					s PartL=..GetPatienPart(PartDR)
					s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
					s PartStr=..GetPatienPartStr(PartDR)
				}
			
				s ExamItem=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),8)
				s Duration=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),9)
				s AbnormalMax=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),10)
				s AbnormalMin=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),11)
				s RangeUnit=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),12)
				s RangeType=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),13)
				s SymptomNum=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),14)
				s Symptom=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),15)
				s PassFlag=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),16)
				s PositionWord=""
				s PositionWordDR=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),21)
				s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
				s ExamInfo="{""SpecID"":"""_SpecID_""",""Status"":"""_Status_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""ExamItem"":"""_ExamItem_""",""Duration"":"""_
					Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_AbnormalMin_""",""RangeUnit"":"""_RangeUnit_""",""RangeType"":"""_RangeType_
					""",""SymptomNum"":"""_SymptomNum_""",""Symptom"":"""_Symptom_""",""PassFlag"":"""_PassFlag_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.SpecExam""}"
					
				if (SpecExamInfo="")
				{
					s SpecExamInfo=ExamInfo
				}
				else
				{
					s SpecExamInfo=SpecExamInfo_","_ExamInfo	
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s SpecID=0
		for
		{
			s SpecID =$o(^WDT.CDSS.SpecExamI("IDNOIndex"," "_$zcvt(IDNO,"U"),SpecID)) q:SpecID=""
			s Status=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),6)
			s PartDR=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),7)
			s CDSS2PartDR=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),20)
			s Part="",PartL="",PartStr=""
			if (CDSS2PartDR'="")
			{
				s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
				s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
				s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
			}
			elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
			{
				s PartL=..GetPatienPart(PartDR)
				s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
				s PartStr=..GetPatienPartStr(PartDR)
			}
			s ExamItem=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),8)
			s Duration=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),9)
			s AbnormalMax=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),10)
			s AbnormalMin=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),11)
			s RangeUnit=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),12)
			s RangeType=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),13)
			s SymptomNum=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),14)
			s Symptom=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),15)
			s PassFlag=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),16)
			s PositionWord=""
			s PositionWordDR=$lg($g(^WDT.CDSS.SpecExamD(SpecID)),21)
			s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
			s ExamInfo="{""SpecID"":"""_SpecID_""",""Status"":"""_Status_""",""PartDR"":"""_Part_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PartStr"":"""_PartStr_""",""ExamItem"":"""_ExamItem_""",""Duration"":"""_
				Duration_""",""AbnormalMax"":"""_AbnormalMax_""",""AbnormalMin"":"""_AbnormalMin_""",""RangeUnit"":"""_RangeUnit_""",""RangeType"":"""_RangeType_
				""",""SymptomNum"":"""_SymptomNum_""",""Symptom"":"""_Symptom_""",""PassFlag"":"""_PassFlag_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.SpecExam""}"
				
			if (SpecExamInfo="")
			{
				s SpecExamInfo=ExamInfo
			}
			else
			{
				s SpecExamInfo=SpecExamInfo_","_ExamInfo	
			}
		}
	}
	s SpecExamInfo = ##class(web.BDP.util.String).Replace(SpecExamInfo,"\","\\")
	return SpecExamInfo
}

/// Creator:dingyanan
/// CreatDate:2020-03-20
/// Description：获取患者诊断信息表信息 
/// Table：WDT.CDSS.DiagnosisInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者诊断信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo("43","0000000057","1",1)
ClassMethod GetDiagnosisInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String, DiagClass As %String = "") As %String
{
	
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s DiagnosisInfo="",Info="",isExistChild="0"  //上个节点是否是子节点（0否，1是）
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.DiagnosisInfoI("PatVisDRTyDiaTySeqIndex",PatientDR,VisitID,VisitType)))
		{
			s DiagnosisType1=""	
			for
			{
				s DiagnosisType1 =$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTyDiaTySeqIndex",PatientDR,VisitID,VisitType,DiagnosisType1)) q:DiagnosisType1=""
				s Sequence=""
				for
				{
					s Sequence =$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTyDiaTySeqIndex",PatientDR,VisitID,VisitType,DiagnosisType1,Sequence)) q:Sequence=""
					s DiagnosisID=0
					for
					{
						s DiagnosisID =$o(^WDT.CDSS.DiagnosisInfoI("PatVisDRTyDiaTySeqIndex",PatientDR,VisitID,VisitType,DiagnosisType1,Sequence,DiagnosisID)) q:DiagnosisID=""
						s DiagnosisType=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),6)
						s DiagnosisType=$CASE(DiagnosisType,"1":"入院诊断","2":"初步诊断","3":"更正诊断","4":"补充诊断","5":"出院诊断","6":"死亡诊断","7":"留观诊断","8":"门诊诊断","":"入院诊断",:DiagnosisType) 
						s DiagnosisSequence=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),7)
						s DiagnosisCode=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),8)
						s DiagnosisName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),9)
						s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DiagnosisName,"诊断")
						s DiagnosisDesc=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),10)
						s DiagnosisTime=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),11)
						//if DiagnosisTime'="" s DiagnosisTime=$zdate(DiagnosisTime,3)
						s DiagnosisStatus=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),12)
						s ChildDiagnosisFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),13)  //子诊断标记（0是，1否）
						s PassFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),14)
						
						s ProjectName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),17)
						s DiagnosisClass=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),18)
						s:DiagnosisClass="" DiagnosisClass="西医"
					
						continue:DiagnosisClass'[DiagClass
						
						s Info="{""DiagnosisID"":"""_DiagnosisID_""",""DiagnosisType"":"""_DiagnosisType_""",""DiagnosisSequence"":"""_DiagnosisSequence_""",""DiagnosisCode"":"""_
							DiagnosisCode_""",""DiagnosisName"":"""_DiagnosisName_""",""ProjectDataName"":"""_ProjectDataName_""",""DiagnosisDesc"":"""_DiagnosisDesc_""",""DiagnosisTime"":"""_
							DiagnosisTime_""",""DiagnosisStatus"":"""_DiagnosisStatus_""",""ChildDiagnosisFlag"":"""_ChildDiagnosisFlag_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""DiagnosisClass"":"""_DiagnosisClass_""",""TableName"":""WDT.CDSS.DiagnosisInfo""}"
							
						/*if (DiagnosisInfo="")
						{
							s DiagnosisInfo=Info			
						}
						else
						{
							
							if (ChildDiagnosisFlag="0")&(isExistChild="0")  //是子节点且上个节点不是子节点
							{
								s DiagnosisInfo=DiagnosisInfo_",""children"":["_Info_"}"
								s isExistChild="1"
							}
							elseif(ChildDiagnosisFlag="0")&(isExistChild="1") //是子节点且上个节点也是子节点
							{
								s DiagnosisInfo=DiagnosisInfo_","_Info_"}"	
								s isExistChild="1"
							}
							elseif(ChildDiagnosisFlag'="0")&(isExistChild="1") //不是子节点且上个节点是子节点
							{
								s DiagnosisInfo=DiagnosisInfo_"]},"_Info
								s isExistChild="0"	
							}
							else  //不是子节点且上个节点不是子节点
							{
								s DiagnosisInfo=DiagnosisInfo_"},"_Info
								s isExistChild="0"
							}
						}*/
						s:DiagnosisInfo'="" DiagnosisInfo=DiagnosisInfo_","_Info
						s:DiagnosisInfo="" DiagnosisInfo=Info
					}
				}
			}
			
			/*if (DiagnosisInfo'="")
			{
				if (isExistChild="1")   //最后一个节点是子节点
				{
					s DiagnosisInfo=DiagnosisInfo_"]}"
				}
				else
				{
				 	s DiagnosisInfo=DiagnosisInfo_"}"
				}
			
			}*/
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s DiagnosisType1=""	
		for
		{
			s DiagnosisType1 =$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType1)) q:DiagnosisType1=""
			s Sequence=""
			for
			{
				s Sequence =$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType1,Sequence)) q:Sequence=""
				s DiagnosisID=0
				for
				{
					s DiagnosisID =$o(^WDT.CDSS.DiagnosisInfoI("IDNODiaTySeqIndex",IDNO,DiagnosisType1,Sequence,DiagnosisID)) q:DiagnosisID=""
					s DiagnosisType=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),6)
					s DiagnosisType=$CASE(DiagnosisType,"1":"入院诊断","2":"初步诊断","3":"更正诊断","4":"补充诊断","5":"出院诊断","6":"死亡诊断","7":"留观诊断","8":"门诊诊断","":"入院诊断",:DiagnosisType)
					s DiagnosisSequence=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),7)
					s DiagnosisCode=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),8)
					s DiagnosisName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),9)
					s ProjectDataName =  ##class(web.CDSS.IMP.ContrastDict).GetProjectDataName(DiagnosisName,"诊断")
					s DiagnosisDesc=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),10)
					s DiagnosisTime=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),11)
					//if DiagnosisTime'="" s DiagnosisTime=$zdate(DiagnosisTime,3)
					s DiagnosisStatus=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),12)
					s ChildDiagnosisFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),13)  //子诊断标记（0是，1否）
					s PassFlag=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),14)
					s ProjectName=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),17)
					s DiagnosisClass=$lg($g(^WDT.CDSS.DiagnosisInfoD(DiagnosisID)),18)
					s:DiagnosisClass="" DiagnosisClass="西医"
					continue:DiagnosisClass'[DiagClass
						
					s Info="{""DiagnosisID"":"""_DiagnosisID_""",""DiagnosisType"":"""_DiagnosisType_""",""DiagnosisSequence"":"""_DiagnosisSequence_""",""DiagnosisCode"":"""_
						DiagnosisCode_""",""DiagnosisName"":"""_DiagnosisName_""",""ProjectDataName"":"""_ProjectDataName_""",""DiagnosisDesc"":"""_DiagnosisDesc_""",""DiagnosisTime"":"""_
						DiagnosisTime_""",""DiagnosisStatus"":"""_DiagnosisStatus_""",""ChildDiagnosisFlag"":"""_ChildDiagnosisFlag_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""DiagnosisClass"":"""_DiagnosisClass_""",""TableName"":""WDT.CDSS.DiagnosisInfo""}"
						
					/*if (DiagnosisInfo="")
					{
						s DiagnosisInfo=Info			
					}
					else
					{
						
						if (ChildDiagnosisFlag="0")&(isExistChild="0")  //是子节点且上个节点不是子节点
						{
							s DiagnosisInfo=DiagnosisInfo_",""children"":["_Info_"}"
							s isExistChild="1"
						}
						elseif(ChildDiagnosisFlag="0")&(isExistChild="1") //是子节点且上个节点也是子节点
						{
							s DiagnosisInfo=DiagnosisInfo_","_Info_"}"	
							s isExistChild="1"
						}
						elseif(ChildDiagnosisFlag'="0")&(isExistChild="1") //不是子节点且上个节点是子节点
						{
							s DiagnosisInfo=DiagnosisInfo_"]},"_Info
							s isExistChild="0"	
						}
						else  //不是子节点且上个节点不是子节点
						{
							s DiagnosisInfo=DiagnosisInfo_"},"_Info
							s isExistChild="0"
						}
					}*/
					s:DiagnosisInfo'="" DiagnosisInfo=DiagnosisInfo_","_Info
					s:DiagnosisInfo="" DiagnosisInfo=Info
				}
			}
		}
		
		/*if (DiagnosisInfo'="")
		{
			if (isExistChild="1")   //最后一个节点是子节点
			{
				s DiagnosisInfo=DiagnosisInfo_"]}"
			}
			else
			{
			 	s DiagnosisInfo=DiagnosisInfo_"}"
			}
		
		}*/
	}
	s DiagnosisInfo = ##class(web.BDP.util.String).Replace(DiagnosisInfo,"\","\\")		
	return "["_DiagnosisInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2019-12-31
/// Description：获取患者处方信息表信息 
/// Table：WDT.CDSS.LabExamInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者处方信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientDrugInfo("DH001","te001","1","1")
ClassMethod GetPatientDrugInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientDrugInfo="",DrugInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.DrugInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s DrugID=0
			for 
			{
				s DrugID =$o(^WDT.CDSS.DrugInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,DrugID)) q:DrugID=""	
				s Type=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),6)
				
				s GroupFlag=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),7)
				s GroupSequence=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),8)
				s DrugCode=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),9)
				s DrugName=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),10)
				s Usage=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),11)
				s Dose=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),12)
				s Frequency=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),13)
				s Unit=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),14)
				s Specification=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),15)
				s StartTime=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),16)
				
				//if StartTime'="" s StartTime=$zdate(StartTime,3)
				s ExecuteTime=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),17)
				s ContrastTime=StartTime
				if (ExecuteTime'="")
				{
					s ContrastTime=ExecuteTime
				}
				continue:(Type="Short")&&($p(ContrastTime," ",1)'= $zd($h,3))
				continue:(Type="Short")&&(ExecuteTime'= "")
				//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
				s StopTime=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),18)
				//if StopTime'="" s StopTime=$zdate(StopTime,3)
				s Remarks=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),19)
				s PassFlag=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),20)
				
				s ProjectName=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),21)
				
				s DrugInfo="{""DrugID"":"""_DrugID_""",""Type"":"""_Type_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""DrugCode"":"""_
					DrugCode_""",""DrugName"":"""_DrugName_""",""Usage"":"""_Usage_""",""Dose"":"""_Dose_""",""Frequency"":"""_Frequency_""",""Unit"":"""_
					Unit_""",""Specification"":"""_Specification_""",""StartTime"":"""_StartTime_""",""ExecuteTime"":"""_ExecuteTime_""",""StopTime"":"""_StopTime
					_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""TableName"":""WDT.CDSS.DrugInfo""}"
					
				if (PatientDrugInfo="")
				{
					s PatientDrugInfo=DrugInfo
				}
				else
				{
					s PatientDrugInfo=PatientDrugInfo_","_DrugInfo		
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s DrugID=0
		for 
		{
			s DrugID =$o(^WDT.CDSS.DrugInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),DrugID)) q:DrugID=""	
			s Type=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),6)
			s GroupFlag=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),7)
			s GroupSequence=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),8)
			s DrugCode=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),9)
			s DrugName=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),10)
			s Usage=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),11)
			s Dose=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),12)
			s Frequency=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),13)
			s Unit=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),14)
			s Specification=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),15)
			s StartTime=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),16)
			//if StartTime'="" s StartTime=$zdate(StartTime,3)
			s ExecuteTime=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),17)
			//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
			s StopTime=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),18)
			//if StopTime'="" s StopTime=$zdate(StopTime,3)
			s ContrastTime=StartTime
			if (ExecuteTime'="")
			{
				s ContrastTime=ExecuteTime
			}
			continue:(Type="Short")&&($p(ContrastTime," ",1)'= $zd($h,3))
			continue:(Type="Short")&&(ExecuteTime'= "")
			
			s Remarks=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),19)
			s PassFlag=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),20)
			s ProjectName=$lg($g(^WDT.CDSS.DrugInfoD(DrugID)),21)
			
			s DrugInfo="{""DrugID"":"""_DrugID_""",""Type"":"""_Type_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""DrugCode"":"""_
				DrugCode_""",""DrugName"":"""_DrugName_""",""Usage"":"""_Usage_""",""Dose"":"""_Dose_""",""Frequency"":"""_Frequency_""",""Unit"":"""_
				Unit_""",""Specification"":"""_Specification_""",""StartTime"":"""_StartTime_""",""ExecuteTime"":"""_ExecuteTime_""",""StopTime"":"""_StopTime
				_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""TableName"":""WDT.CDSS.DrugInfo""}"
				
			if (PatientDrugInfo="")
			{
				s PatientDrugInfo=DrugInfo
			}
			else
			{
				s PatientDrugInfo=PatientDrugInfo_","_DrugInfo		
			}
		}
	}
	s PatientDrugInfo = ##class(web.BDP.util.String).Replace(PatientDrugInfo,"\","\\")			
	return "["_PatientDrugInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2019-12-31
/// Description：获取患者检查信息表信息 
/// Table：WDT.CDSS.ExamInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者检查信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientExamInfo("","te001","1","1")
ClassMethod GetPatientExamInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String, FilterFlag As %String = "") As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientExamInfo="",ExamInfo="",ResultInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType)))
		{
			
			s GroupFlag=0
			for
			{
				s GroupFlag =$o(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType,GroupFlag)) q:GroupFlag=""
				s ExamCode=0
				for
				{
					s ExamCode =$o(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType,GroupFlag,ExamCode)) q:ExamCode=""
					s ExamID=0
					for
					{
						s ExamID =$o(^WDT.CDSS.ExamInfoI("PatVisDRTyExamIndex",PatientDR,VisitID,VisitType,GroupFlag,ExamCode,ExamID)) q:ExamID=""
						
						s GroupSequence=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),7)
						//s ExamCode=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),8)
						s ExamName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),9)
						s ExamResult=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),10)
						s PartDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),11)
						s CDSS2PartDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),19)
						
						s Part="",PartL="",PartStr=""
						if (CDSS2PartDR'="")
						{
							s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
							s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
							s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
						}
						elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
						{
							s PartL=..GetPatienPart(PartDR)
							s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
							s PartStr=..GetPatienPartStr(PartDR)
						}
				
						s ExecuteTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),12)
						//continue:(FilterFlag="1")&&(ExecuteTime'="")
						//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
						s ReportTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),13)
						//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
						s Remarks=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),14)
						s PassFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),15)
						s ExamResultNum=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),16)
						s ExamResultFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),17)
						s ExamResultDesc=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),18)
						s ProjectName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),20)
						s SymptomCore=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),21)
						s SymProperty=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),22)
						s PositionWordDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),23)
						s PositionWord=""
						s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
						
						s Info= "{""ExamID"":"""_ExamID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""ExamCode"":"""_ExamCode_""",""ExamName"":"""_
							ExamName_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""ExecuteTime"":"""_ExecuteTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_
							""",""ExamResult"":"""_ExamResult_""",""ExamResultNum"":"""_ExamResultNum_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.ExamInfo""}"
						
						/*s ExamInfo="{""ExamID"":"""_ExamID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""ExamCode"":"""_ExamCode_""",""ExamName"":"""_
							ExamName_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""ExecuteTime"":"""_ExecuteTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""ExamResult"":"""_ExamResult_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.ExamInfo"""
						s ResultInfo="{""ExamResult"":"""_ExamResult_""",""ExamResultNum"":"""_ExamResultNum_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_"""}"	
						
						if (PatientExamInfo="")
						{
							s PatientExamInfo=ExamInfo_",""children"":["_ResultInfo			
						}
						elseif (PatientExamInfo[ExamInfo)  //已经有检查
						{
							s PatientExamInfo=PatientExamInfo_","_ResultInfo			
						}
						else  //新的检查
						{
							s PatientExamInfo=PatientExamInfo_"]},"_ExamInfo_",""children"":["_ResultInfo	
						}*/
						
						s:PatientExamInfo'="" PatientExamInfo=PatientExamInfo_","_Info
						s:PatientExamInfo="" PatientExamInfo=Info
						
					}
				}
				
			}
			//s:PatientExamInfo'="" PatientExamInfo=PatientExamInfo_"]}"	
		}
		
	}
	elseif ($d(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO))) //患者主索引
	{
		
		s GroupFlag=0
		for
		{
			s GroupFlag =$o(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO,GroupFlag)) q:GroupFlag=""
			s ExamCode=0
			for
			{
				s ExamCode =$o(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO,GroupFlag,ExamCode)) q:ExamCode=""
				s ExamID=0
				for
				{
					s ExamID =$o(^WDT.CDSS.ExamInfoI("IDNOExamIndex",IDNO,GroupFlag,ExamCode,ExamID)) q:ExamID=""
					s GroupSequence=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),7)
					//s ExamCode=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),8)
					s ExamName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),9)
					s ExamResult=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),10)
					s PartDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),11)
					s CDSS2PartDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),19)
					s Part="",PartL="",PartStr=""
					if (CDSS2PartDR'="")
					{
						s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
						s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
						s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
					}
					elseif (PartDR'="")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBodyParDict"))&&($d(^User.DHCDSSBodyParDictD(PartDR)))
					{
						s PartL=..GetPatienPart(PartDR)
						s Part=$lg($g(^User.DHCDSSBodyParDictD(PartDR)),3)
						s PartStr=..GetPatienPartStr(PartDR)
					}
					s ExecuteTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),12)
					//continue:(FilterFlag="1")&&(ExecuteTime'="")
					//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
					s ReportTime=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),13)
					//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
					s Remarks=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),14)
					s PassFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),15)
					s ExamResultNum=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),16)
					s ExamResultFlag=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),17)
					s ExamResultDesc=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),18)
					s ProjectName=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),20)
					s SymptomCore=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),21)
					s SymProperty=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),22)
					s PositionWordDR=$lg($g(^WDT.CDSS.ExamInfoD(ExamID)),23)
					s PositionWord=""
					s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
							
					s Info= "{""ExamID"":"""_ExamID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""ExamCode"":"""_ExamCode_""",""ExamName"":"""_
							ExamName_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""ExecuteTime"":"""_ExecuteTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_
							""",""ExamResult"":"""_ExamResult_""",""ExamResultNum"":"""_ExamResultNum_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.ExamInfo""}"
							
					/*s ExamInfo="{""ExamID"":"""_ExamID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""ExamCode"":"""_ExamCode_""",""ExamName"":"""_
							ExamName_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""ExecuteTime"":"""_ExecuteTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""ExamResult"":"""_ExamResult_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.ExamInfo"""
					s ResultInfo="{""ExamResult"":"""_ExamResult_""",""ExamResultNum"":"""_ExamResultNum_""",""ExamResultFlag"":"""_ExamResultFlag_""",""ExamResultDesc"":"""_ExamResultDesc_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_"""}"	
						
					if (PatientExamInfo="")
					{
						s PatientExamInfo=ExamInfo_",""children"":["_ResultInfo			
					}
					elseif (PatientExamInfo[ExamInfo)  //已经有检查
					{
						s PatientExamInfo=PatientExamInfo_","_ResultInfo			
					}
					else  //新的检查
					{
						s PatientExamInfo=PatientExamInfo_"]},"_ExamInfo_",""children"":["_ResultInfo	
					}*/
					s:PatientExamInfo'="" PatientExamInfo=PatientExamInfo_","_Info
					s:PatientExamInfo="" PatientExamInfo=Info
				}
					
			}
			
		}
		//s:PatientExamInfo'="" PatientExamInfo=PatientExamInfo_"]}"	
	}
	s PatientExamInfo = ##class(web.BDP.util.String).Replace(PatientExamInfo,"\","\\")	
	return "["_PatientExamInfo_"]"
}

/// Creator:丁亚男
/// CreatDate:2021-08-12
/// Description：辅助检验检查（非结构化） 
/// Table：WDT.CDSS.LabExamInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者处方信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientLabExamInfo("DH001","te001","1","1","")
ClassMethod GetPatientLabExamInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String, Type As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	if (Type="") s Type="检验检查"
	s PatientLabExamInfo="",LabExamInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.LabExamInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s LabExamID=0
			for 
			{
				s LabExamID =$o(^WDT.CDSS.LabExamInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,LabExamID)) q:LabExamID=""	
				s CheckType=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),6)
				continue:Type'[CheckType
				s CheckName=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),7)
				s CheckValue=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),8)
				s CheckUnit=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),9)
				s NormalMax=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),10)
				s NormalMin=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),11)
				s CheckFormal=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),12)
				s PassFlag=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),13)
				s MRCode=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),14)
				s ProjectName=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),15)
				
				s SymptomCore=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),16)
				s SymProperty=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),17)
				s CDSS2PartDR=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),18)
				s Part="",PartL="",PartStr=""
				if (CDSS2PartDR'="")
				{
					s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
					s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
					s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
				}
				s PositionWordDR=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),19)
				s PositionWord=""
				s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
				
				
				s LabExamInfo="{""LabExamID"":"""_LabExamID_""",""CheckType"":"""_CheckType_""",""CheckName"":"""_CheckName_""",""CheckValue"":"""_CheckValue_""",""CheckUnit"":"""_
					CheckUnit_""",""NormalMax"":"""_NormalMax_""",""NormalMin"":"""_NormalMin_""",""CheckFormal"":"""_CheckFormal_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""MRCode"":"""_
					MRCode_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.LabExamInfo""}"
					
				if (PatientLabExamInfo="")
				{
					s PatientLabExamInfo=LabExamInfo
				}
				else
				{
					s PatientLabExamInfo=PatientLabExamInfo_","_LabExamInfo		
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s LabExamID=0
		for 
		{
			s LabExamID =$o(^WDT.CDSS.LabExamInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,LabExamID)) q:LabExamID=""	
			s CheckType=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),6)
			continue:Type'[CheckType
			s CheckName=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),7)
			s CheckValue=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),8)
			s CheckUnit=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),9)
			s NormalMax=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),10)
			s NormalMin=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),11)
			s CheckFormal=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),12)
			s PassFlag=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),13)
			s MRCode=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),14)
			s ProjectName=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),15)
			s SymptomCore=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),16)
			s SymProperty=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),17)
			s CDSS2PartDR=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),18)
			s Part="",PartL="",PartStr=""
			if (CDSS2PartDR'="")
			{
				s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
				s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
				s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
			}
			s PositionWordDR=$lg($g(^WDT.CDSS.LabExamInfoD(LabExamID)),19)
			s PositionWord=""
			s:PositionWordDR'="" PositionWord=$lg($g(^CT.WDT.CDSS.PositionWordD(PositionWordDR)),3)
			
			s LabExamInfo="{""LabExamID"":"""_LabExamID_""",""CheckType"":"""_CheckType_""",""CheckName"":"""_CheckName_""",""CheckValue"":"""_CheckValue_""",""CheckUnit"":"""_
				CheckUnit_""",""NormalMax"":"""_NormalMax_""",""NormalMin"":"""_NormalMin_""",""CheckFormal"":"""_CheckFormal_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""MRCode"":"""_
				MRCode_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""Part"":"""_Part_""",""PartL"":"""_PartL_""",""PositionWord"":"""_PositionWord_""",""TableName"":""WDT.CDSS.LabExamInfo""}"
				
			if (PatientLabExamInfo="")
			{
				s PatientLabExamInfo=LabExamInfo
			}
			else
			{
				s PatientLabExamInfo=PatientLabExamInfo_","_LabExamInfo		
			}
		}
	}
	s PatientLabExamInfo = ##class(web.BDP.util.String).Replace(PatientLabExamInfo,"\","\\")			
	return "["_PatientLabExamInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-03-20
/// Description：获取患者检验信息表信息 
/// Table：WDT.CDSS.LabInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者检验信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientLabInfo("003","003","1","0")
ClassMethod GetPatientLabInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String, FilterFlag As %String = "") As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientLabInfo="",LabInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.LabInfoI("PatVisDRTyLabIndex",PatientDR,VisitID,VisitType)))
		{
			
			s GroupFlag=0
			for
			{
				s GroupFlag =$o(^WDT.CDSS.LabInfoI("PatVisDRTyLabIndex",PatientDR,VisitID,VisitType,GroupFlag)) q:GroupFlag=""
				s InspectionCode=""
				for
				{
					s InspectionCode =$o(^WDT.CDSS.LabInfoI("PatVisDRTyLabIndex",PatientDR,VisitID,VisitType,GroupFlag,InspectionCode)) q:InspectionCode=""
					s LabID=0
					for
					{
						s LabID =$o(^WDT.CDSS.LabInfoI("PatVisDRTyLabIndex",PatientDR,VisitID,VisitType,GroupFlag,InspectionCode,LabID)) q:LabID=""
						//s GroupFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),6)
						s GroupSequence=$lg($g(^WDT.CDSS.LabInfoD(LabID)),7)
						//s InspectionCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),8)
						s InspectionName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),9)
						s LabItemCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),10)
						s LabItemName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),11)
						s LabResult=$lg($g(^WDT.CDSS.LabInfoD(LabID)),12)
						s Unit=$lg($g(^WDT.CDSS.LabInfoD(LabID)),13)
						s Reference=$lg($g(^WDT.CDSS.LabInfoD(LabID)),14)
						s Specimen=$lg($g(^WDT.CDSS.LabInfoD(LabID)),15)
						s ExecuteTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),16)
						//continue:(FilterFlag="1")&&(ExecuteTime'="")     //患者模型不再过滤已执行医嘱，算法在识别词部分处理已经医嘱不再触发预警的规则
						//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
						s ReportTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),17)
						//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
						s Remarks=$lg($g(^WDT.CDSS.LabInfoD(LabID)),18)
						s PassFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),19)
						s LabResultFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),20)
						s ProjectName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),21)
						
						s Info="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_InspectionName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
							Unit_""",""LabResultFlag"":"""_LabResultFlag_""",""ProjectName"":"""_ProjectName_""",""LabItemName"":"""_LabItemName_""",""LabID"":"""_LabID_
							""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""Reference"":"""_Reference_
							""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""TableName"":""WDT.CDSS.LabInfo""}"
							
						/*s InspectionInfo="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_InspectionName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
							Unit_""",""LabResultFlag"":"""_LabResultFlag_""",""ProjectName"":"""_ProjectName_""",""LabItemName"":"""_LabItemName_""",""TableName"":""WDT.CDSS.LabInfo"""	
						if (LabItemName="")
						{
							s LabInfo="{""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
							Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""LabResultFlag"":"""_LabResultFlag_""","""_InspectionName_""":"""_LabResultFlag_"""}"	
						}
						else
						{
							s LabInfo="{""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
							Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""LabResultFlag"":"""_LabResultFlag_""","""_LabItemName_""":"""_LabResult_"""}"	
						
						}	
						if (PatientLabInfo="")
						{
							s PatientLabInfo=InspectionInfo_",""children"":["_LabInfo			
						}
						elseif (PatientLabInfo[InspectionInfo)  //已经有检验大项
						{
							s PatientLabInfo=PatientLabInfo_","_LabInfo			
						}
						else  //新的检验大项
						{
							s PatientLabInfo=PatientLabInfo_"]},"_InspectionInfo_",""children"":["_LabInfo	
						}
						*/
						s:PatientLabInfo'="" PatientLabInfo=PatientLabInfo_","_Info
						s:PatientLabInfo="" PatientLabInfo=Info
					}
					
				}
				
			}
			//s:PatientLabInfo'="" PatientLabInfo=PatientLabInfo_"]}"
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s GroupFlag=0
		for
		{
			s GroupFlag =$o(^WDT.CDSS.LabInfoI("IDNOInspecIndex",IDNO,GroupFlag)) q:GroupFlag=""
			s InspectionCode=0
			for
			{
				s InspectionCode =$o(^WDT.CDSS.LabInfoI("IDNOInspecIndex",IDNO,GroupFlag,InspectionCode)) q:InspectionCode=""
				s LabID=0
				for
				{
					s LabID =$o(^WDT.CDSS.LabInfoI("IDNOInspecIndex",IDNO,GroupFlag,InspectionCode,LabID)) q:LabID=""
					//s GroupFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),6)
					s GroupSequence=$lg($g(^WDT.CDSS.LabInfoD(LabID)),7)
					//s InspectionCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),8)
					s InspectionName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),9)
					s LabItemCode=$lg($g(^WDT.CDSS.LabInfoD(LabID)),10)
					s LabItemName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),11)
					s LabResult=$lg($g(^WDT.CDSS.LabInfoD(LabID)),12)
					s Unit=$lg($g(^WDT.CDSS.LabInfoD(LabID)),13)
					s Reference=$lg($g(^WDT.CDSS.LabInfoD(LabID)),14)
					s Specimen=$lg($g(^WDT.CDSS.LabInfoD(LabID)),15)
					s ExecuteTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),16)
					//continue:(FilterFlag="1")&&(ExecuteTime'="")  //患者模型不再过滤已执行医嘱，算法在识别词部分处理已经医嘱不再触发预警的规则
					//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
					s ReportTime=$lg($g(^WDT.CDSS.LabInfoD(LabID)),17)
					//if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
					s Remarks=$lg($g(^WDT.CDSS.LabInfoD(LabID)),18)
					s PassFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),19)
					s LabResultFlag=$lg($g(^WDT.CDSS.LabInfoD(LabID)),20)
					s ProjectName=$lg($g(^WDT.CDSS.LabInfoD(LabID)),21)
					
					s Info="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_InspectionName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
							Unit_""",""LabResultFlag"":"""_LabResultFlag_""",""ProjectName"":"""_ProjectName_""",""LabItemName"":"""_LabItemName_""",""LabID"":"""_LabID_
							""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""Reference"":"""_Reference_
							""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""TableName"":""WDT.CDSS.LabInfo""}"
							
					/*
					s InspectionInfo="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_InspectionName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
							Unit_""",""LabResultFlag"":"""_LabResultFlag_""",""ProjectName"":"""_ProjectName_""",""LabItemName"":"""_LabItemName_""",""TableName"":""WDT.CDSS.LabInfo"""	
					if (LabItemName="")
					{
						s LabInfo="{""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
						Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""LabResultFlag"":"""_LabResultFlag_""","""_InspectionName_""":"""_LabResultFlag_"""}"	
					}
					else
					{
						s LabInfo="{""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"":"""_
						Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_""",""LabResultFlag"":"""_LabResultFlag_""","""_LabItemName_""":"""_LabResult_"""}"	
					
					}
					if (PatientLabInfo="")
					{
						s PatientLabInfo=InspectionInfo_",""children"":["_LabInfo			
					}
					elseif (PatientLabInfo[InspectionInfo)  //已经有检验大项
					{
						s PatientLabInfo=PatientLabInfo_","_LabInfo			
					}
					else  //新的检验大项
					{
						s PatientLabInfo=PatientLabInfo_"]},"_InspectionInfo_",""children"":["_LabInfo	
					}
					*/
					s:PatientLabInfo'="" PatientLabInfo=PatientLabInfo_","_Info
					s:PatientLabInfo="" PatientLabInfo=Info
				}
				
			}
			
		}
		//s:PatientLabInfo'="" PatientLabInfo=PatientLabInfo_"]}"
	}
	s PatientLabInfo = ##class(web.BDP.util.String).Replace(PatientLabInfo,"\","\\")
	return "["_PatientLabInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-03-20
/// Description：获取患者手术信息表信息 
/// Table：WDT.CDSS.OperationInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者手术信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetOperationInfo("DH001","te001","1")
ClassMethod GetOperationInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s OperationInfo="",Info="",MainOper=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.OperationInfoI("PatVisDRTyOpNumIndex",PatientDR,VisitID,VisitType)))
		{
			s OperNum=""
			for
			{
				s OperNum =$o(^WDT.CDSS.OperationInfoI("PatVisDRTyOpNumIndex",PatientDR,VisitID,VisitType,OperNum)) q:OperNum=""
				s OperID=0
				for
				{
					s OperID =$o(^WDT.CDSS.OperationInfoI("PatVisDRTyOpNumIndex",PatientDR,VisitID,VisitType,OperNum,OperID)) q:OperID=""
					//s OperNum=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),6)
					s OperSequence=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),7)
					s MainOperFlag=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),8)  //主手术标记
					s OperCode=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),9)
					s OperName=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),10)
					s OperDesc=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),11)
					s OperType=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),12)
					s OperPosition=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),13)
					s IntraoperDiagnosis=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),14)
					s OperDuration=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),15)
					s OperStartTime=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),16)
					//if OperStartTime'="" s OperStartTime=$zdate(OperStartTime,3)
					s OperEndTime=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),17)
					//if OperEndTime'="" s OperEndTime=$zdate(OperEndTime,3)
					s PassFlag=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),18)
					s ProjectName=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),19)
					s OperClass=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),20)
					s OperLevel=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),21)
					s OperAnest=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),22)
					s OperIncisionType=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),23)
					
					s Info="{""OperID"":"""_OperID_""",""OperNum"":"""_OperNum_""",""OperSequence"":"""_OperSequence_""",""MainOperFlag"":"""_MainOperFlag_""",""OperCode"":"""_OperCode_""",""OperName"":"""_
						OperName_""",""OperDesc"":"""_OperDesc_""",""OperType"":"""_OperType_""",""OperPosition"":"""_OperPosition_""",""IntraoperDiagnosis"":"""_
						IntraoperDiagnosis_""",""OperDuration"":"""_OperDuration_""",""OperStartTime"":"""_OperStartTime_""",""OperEndTime"":"""_OperEndTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_
						""",""OperClass"":"""_OperClass_""",""OperLevel"":"""_OperLevel_""",""OperAnest"":"""_OperAnest_""",""OperIncisionType"":"""_OperIncisionType_""",""TableName"":""WDT.CDSS.OperationInfo""}"
					if (OperationInfo="")
					{
						s OperationInfo=Info	
					}
					else
					{
						s OperationInfo=OperationInfo_","_Info
					}
					
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s OperNum=""
		for
		{
			s OperNum =$o(^WDT.CDSS.OperationInfoI("IDNOOpNumIndex",IDNO,OperNum)) q:OperNum=""
			s OperID=0
			for
			{
				s OperID =$o(^WDT.CDSS.OperationInfoI("IDNOOpNumIndex",IDNO,OperNum,OperID)) q:OperID=""
				//s OperNum=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),6)
				s OperSequence=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),7)
				s MainOperFlag=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),8)  //主手术标记
				s OperCode=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),9)
				s OperName=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),10)
				s OperDesc=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),11)
				s OperType=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),12)
				s OperPosition=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),13)
				s IntraoperDiagnosis=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),14)
				s OperDuration=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),15)
				s OperStartTime=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),16)
				//if OperStartTime'="" s OperStartTime=$zdate(OperStartTime,3)
				s OperEndTime=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),17)
				//if OperEndTime'="" s OperEndTime=$zdate(OperEndTime,3)
				s PassFlag=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),18)
				s ProjectName=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),19)
				s OperClass=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),20)
				s OperLevel=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),21)
				s OperAnest=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),22)
				s OperIncisionType=$lg($g(^WDT.CDSS.OperationInfoD(OperID)),23)
					
				s Info="{""OperID"":"""_OperID_""",""OperNum"":"""_OperNum_""",""OperSequence"":"""_OperSequence_""",""MainOperFlag"":"""_MainOperFlag_""",""OperCode"":"""_OperCode_""",""OperName"":"""_
						OperName_""",""OperDesc"":"""_OperDesc_""",""OperType"":"""_OperType_""",""OperPosition"":"""_OperPosition_""",""IntraoperDiagnosis"":"""_
						IntraoperDiagnosis_""",""OperDuration"":"""_OperDuration_""",""OperStartTime"":"""_OperStartTime_""",""OperEndTime"":"""_OperEndTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_
						""",""OperClass"":"""_OperClass_""",""OperLevel"":"""_OperLevel_""",""OperAnest"":"""_OperAnest_""",""OperIncisionType"":"""_OperIncisionType_""",""TableName"":""WDT.CDSS.OperationInfo""}"
				if (OperationInfo="")
				{
					s OperationInfo=Info	
				}
				else
				{
					s OperationInfo=OperationInfo_","_Info
				}
			}
		}
	}
	s OperationInfo = ##class(web.BDP.util.String).Replace(OperationInfo,"\","\\")
	return "["_OperationInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-01-02
/// Description：获取患者麻醉信息表信息 
/// Table：WDT.CDSS.AnestInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者麻醉信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetAnestInfo("DH001","te001","1")
ClassMethod GetAnestInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s AnestInfo="",Info=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.AnestInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s AnestID=0
			for
			{
				s AnestID =$o(^WDT.CDSS.AnestInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,AnestID)) q:AnestID=""
				s AnestMedication=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),6)
				s Dose=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),7)
				s Usage=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),8)
				s Anesthesia=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),9)
				s AnestSite=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),10)
				s AnestDuration=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),11)
				s AnestStartTime=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),12)
				//if AnestStartTime'="" s AnestStartTime=$zdate(AnestStartTime,3)
				s PassFlag=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),13)
				s ProjectName=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),14)
				
				s Info="{""AnestID"":"""_AnestID_""",""AnestMedication"":"""_AnestMedication_""",""Dose"":"""_Dose_""",""Usage"":"""_Usage_""",""Anesthesia"":"""_Anesthesia_""",""AnestSite"":"""_
					AnestSite_""",""AnestDuration"":"""_AnestDuration_""",""AnestStartTime"":"""_AnestStartTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_"""}"
					
				if (AnestInfo="")
				{
					s AnestInfo=Info
				}
				else
				{
					s AnestInfo=AnestInfo_","_Info
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s AnestID=0
		for
		{
			s AnestID =$o(^WDT.CDSS.AnestInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),AnestID)) q:AnestID=""
			s AnestMedication=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),6)
			s Dose=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),7)
			s Usage=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),8)
			s Anesthesia=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),9)
			s AnestSite=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),10)
			s AnestDuration=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),11)
			s AnestStartTime=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),12)
			//if AnestStartTime'="" s AnestStartTime=$zdate(AnestStartTime,3)
			s PassFlag=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),13)
			s ProjectName=$lg($g(^WDT.CDSS.AnestInfoD(AnestID)),14)
			
			s Info="{""AnestID"":"""_AnestID_""",""AnestMedication"":"""_AnestMedication_""",""Dose"":"""_Dose_""",""Usage"":"""_Usage_""",""Anesthesia"":"""_Anesthesia_""",""AnestSite"":"""_
				AnestSite_""",""AnestDuration"":"""_AnestDuration_""",""AnestStartTime"":"""_AnestStartTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_"""}"
				
			if (AnestInfo="")
			{
				s AnestInfo=Info
			}
			else
			{
				s AnestInfo=AnestInfo_","_Info
			}
		}
	}
	s AnestInfo = ##class(web.BDP.util.String).Replace(AnestInfo,"\","\\")
	return "["_AnestInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-01-02
/// Description：获取患者护理信息表信息 
/// Table：WDT.CDSS.NursingInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// w ##class(web.CDSS.Public.PatientModel).GetNursingInfo("DH001","te001","1","")
ClassMethod GetNursingInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	s NursingInfo="",Info=""
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.NursingInfoI("PatVisDRTyNursNumIndex",PatientDR,VisitID,VisitType)))
		{	
			s NursingItemNum=""
			for
			{
				s NursingItemNum =$o(^WDT.CDSS.NursingInfoI("PatVisDRTyNursNumIndex",PatientDR,VisitID,VisitType,NursingItemNum)) q:NursingItemNum=""
				s ChildItemNum=""
				for
				{
					s ChildItemNum =$o(^WDT.CDSS.NursingInfoI("PatVisDRTyNursNumIndex",PatientDR,VisitID,VisitType,NursingItemNum,ChildItemNum)) q:ChildItemNum=""
					s NursID=0
					for
					{
						s NursID =$o(^WDT.CDSS.NursingInfoI("PatVisDRTyNursNumIndex",PatientDR,VisitID,VisitType,NursingItemNum,ChildItemNum,NursID)) q:NursID=""
						s NursingItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),7)
						s NursingItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),8)
						s ChildItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),9)
						s ChildItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),11)
						s NursingEffect=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),12)
						s PassFlag=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),13)
						s ProjectName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),15)
						s NursingItemFreq=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),16)
						
						s NursingDate=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),14)
						s NursingDuration=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),17)
						s NursingrEndTime=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),18)
						if (NursingDuration="")
						{
							if (NursingrEndTime="")&(NursingDate'="")
							{
								s NursingDuration=$ZTIMESTAMP-NursingDate
							}
						}
						s Info="{""NursingItemCode"":"""_NursingItemCode_""",""NursingItemName"":"""_NursingItemName_""",""NursingItemNum"":"""_NursingItemNum_
						""",""ChildItemName"":"""_ChildItemName_""",""ProjectName"":"""_ProjectName_""",""NursingItemFreq"":"""_NursingItemFreq_
						""",""NursingDuration"":"""_NursingDuration_""",""TableName"":""WDT.CDSS.NursingInfo"",""NursID"":"""_NursID_""",""ChildItemCode"":"""_ChildItemCode_
						""",""ChildItemName"":"""_ChildItemName_""",""NursingEffect"":"""_NursingEffect_""",""ChildItemNum"":"""_ChildItemNum_""",""PassFlag"":"""_PassFlag_"""}"
						
						/*
						s Info="{""NursingItemCode"":"""_NursingItemCode_""",""NursingItemName"":"""_NursingItemName_""",""NursingItemNum"":"""_NursingItemNum_""",""ChildItemName"":"""_ChildItemName_""",""ProjectName"":"""_ProjectName_""",""NursingItemFreq"":"""_NursingItemFreq_""",""NursingDuration"":"""_NursingDuration_""",""TableName"":""WDT.CDSS.NursingInfo"""
						s ChildInfo="{""NursID"":"""_NursID_""",""ChildItemCode"":"""_ChildItemCode_""",""ChildItemName"":"""_ChildItemName_""",""NursingItemFreq"":"""_NursingItemFreq_""",""NursingEffect"":"""_NursingEffect_""",""ChildItemNum"":"""_ChildItemNum_""",""PassFlag"":"""_PassFlag_"""}"
						
						if (NursingInfo="")
						{
							s NursingInfo=Info_",""children"":["_ChildInfo			
						}
						elseif (NursingInfo[Info)  //已有护理大项
						{
							s NursingInfo=NursingInfo_","_ChildInfo			
						}
						else //新的护理大项
						{
							s NursingInfo=NursingInfo_"]},"_Info_",""children"":["_ChildInfo	
						}
						*/
						if (NursingInfo="")
						{
							s NursingInfo=Info
						}
						else
						{
							s NursingInfo=NursingInfo_","_Info
						}
						
					}
					
				}	
			}
			//s:NursingInfo'="" NursingInfo=NursingInfo_"]}"		
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s NursingItemNum=""
		for
		{
			s NursingItemNum =$o(^WDT.CDSS.NursingInfoI("IDNONursNumIndex",IDNO,NursingItemNum)) q:NursingItemNum=""
			s ChildItemNum=""
			for
			{
				s ChildItemNum =$o(^WDT.CDSS.NursingInfoI("IDNONursNumIndex",IDNO,NursingItemNum,ChildItemNum)) q:ChildItemNum=""
				s NursID=0
				for
				{
					s NursID =$o(^WDT.CDSS.NursingInfoI("IDNONursNumIndex",IDNO,NursingItemNum,ChildItemNum,NursID)) q:NursID=""
					s NursingItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),7)
					s NursingItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),8)
					s ChildItemCode=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),9)
					s ChildItemName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),11)
					s NursingEffect=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),12)
					s PassFlag=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),13)
					s ProjectName=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),15)
					s NursingItemFreq=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),16)
					s NursingDate=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),14)
					s NursingDuration=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),17)
					s NursingrEndTime=$lg($g(^WDT.CDSS.NursingInfoD(NursID)),18)
					if (NursingDuration="")
					{
						if (NursingrEndTime="")&(NursingDate'="")
						{
							s NursingDuration=$ZTIMESTAMP-NursingDate
						}
					}
					s Info="{""NursingItemCode"":"""_NursingItemCode_""",""NursingItemName"":"""_NursingItemName_""",""NursingItemNum"":"""_NursingItemNum_
						""",""ChildItemName"":"""_ChildItemName_""",""ProjectName"":"""_ProjectName_""",""NursingItemFreq"":"""_NursingItemFreq_
						""",""NursingDuration"":"""_NursingDuration_""",""TableName"":""WDT.CDSS.NursingInfo"",""NursID"":"""_NursID_""",""ChildItemCode"":"""_ChildItemCode_
						""",""ChildItemName"":"""_ChildItemName_""",""NursingEffect"":"""_NursingEffect_""",""ChildItemNum"":"""_ChildItemNum_""",""PassFlag"":"""_PassFlag_"""}"
							
					/*s Info="{""NursingItemCode"":"""_NursingItemCode_""",""NursingItemName"":"""_NursingItemName_""",""NursingItemNum"":"""_NursingItemNum_""",""ChildItemName"":"""_ChildItemName_""",""ProjectName"":"""_ProjectName_""",""NursingItemFreq"":"""_NursingItemFreq_""",""NursingDuration"":"""_NursingDuration_""",""TableName"":""WDT.CDSS.NursingInfo"""
					s ChildInfo="{""NursID"":"""_NursID_""",""ChildItemCode"":"""_ChildItemCode_""",""ChildItemName"":"""_ChildItemName_""",""NursingEffect"":"""_NursingEffect_""",""ChildItemNum"":"""_ChildItemNum_""",""PassFlag"":"""_PassFlag_"""}"
						
					if (NursingInfo="")
					{
						s NursingInfo=Info_",""children"":["_ChildInfo			
					}
					elseif (NursingInfo[Info)  //已有护理大项
					{
						s NursingInfo=NursingInfo_","_ChildInfo			
					}
					else //新的护理大项
					{
						s NursingInfo=NursingInfo_"]},"_Info_",""children"":["_ChildInfo	
					}*/
					
					if (NursingInfo="")
					{
						s NursingInfo=Info
					}
					else
					{
						s NursingInfo=NursingInfo_","_Info
					}
				}
				
			}
		}
		//s:NursingInfo'="" NursingInfo=NursingInfo_"]}"	
	}
	s NursingInfo = ##class(web.BDP.util.String).Replace(NursingInfo,"\","\\")
	return "["_NursingInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-01-02
/// Description：获取患者输血信息表信息 
/// Table：WDT.CDSS.BloodTransInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者输血信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetBloodTransInfo("DH001","te001","1")
ClassMethod GetBloodTransInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	s BloodTransInfo="",Info=""
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.BloodTransInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s BloodID=0
			for
			{
				s BloodID =$o(^WDT.CDSS.BloodTransInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,BloodID)) q:BloodID=""	
				s BloodTransStartTime=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),6)
				s BloodTransEndTime=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),7)
				s BloodTransDuration=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),8)
				s BloodTransVolume=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),9)
				s BloodTransSite=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),10)
				s BloodTransType=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),11)
				s PassFlag=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),12)
				s BloodTransDurationU=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),13)
				s BloodTransVolumeU=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),14)
				s BloodTransClass=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),15)
				s ProjectName=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),20)
				
				s Info="{""BloodID"":"""_BloodID_""",""BloodTransStartTime"":"""_BloodTransStartTime_""",""BloodTransEndTime"":"""_BloodTransEndTime_""",""BloodTransDuration"":"""_BloodTransDuration_""",""BloodTransVolume"":"""_BloodTransVolume_
				""",""BloodTransSite"":"""_BloodTransSite_""",""BloodTransType"":"""_BloodTransType_""",""PassFlag"":"""_PassFlag_
				""",""BloodTransDurationU"":"""_BloodTransDurationU_""",""BloodTransVolumeU"":"""_BloodTransVolumeU_""",""BloodTransClass"":"""_BloodTransClass_""",""ProjectName"":"""_ProjectName_""",""TableName"":""WDT.CDSS.BloodTransInfo""}"
					
				if (BloodTransInfo="")
				{
					s BloodTransInfo=Info
				}
				else
				{
					s BloodTransInfo=BloodTransInfo_","_Info	
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s BloodID=0
		for
		{
			s BloodID =$o(^WDT.CDSS.BloodTransInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),BloodID)) q:BloodID=""	
			s BloodTransStartTime=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),6)
			s BloodTransEndTime=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),7)
			s BloodTransDuration=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),8)
			s BloodTransVolume=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),9)
			s BloodTransSite=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),10)
			s BloodTransType=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),11)
			s PassFlag=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),12)
			s BloodTransDurationU=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),13)
			s BloodTransVolumeU=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),14)
			s BloodTransClass=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),15)
			s ProjectName=$lg($g(^WDT.CDSS.BloodTransInfoD(BloodID)),20)
			
			s Info="{""BloodID"":"""_BloodID_""",""BloodTransStartTime"":"""_BloodTransStartTime_""",""BloodTransEndTime"":"""_BloodTransEndTime_""",""BloodTransDuration"":"""_BloodTransDuration_""",""BloodTransVolume"":"""_BloodTransVolume_
			""",""BloodTransSite"":"""_BloodTransSite_""",""BloodTransType"":"""_BloodTransType_""",""PassFlag"":"""_PassFlag_
			""",""BloodTransDurationU"":"""_BloodTransDurationU_""",""BloodTransVolumeU"":"""_BloodTransVolumeU_""",""BloodTransClass"":"""_BloodTransClass_""",""ProjectName"":"""_ProjectName_""",""TableName"":""WDT.CDSS.BloodTransInfo""}"
					
			if (BloodTransInfo="")
			{
				s BloodTransInfo=Info
			}
			else
			{
				s BloodTransInfo=BloodTransInfo_","_Info	
			}
		}
	}
	s BloodTransInfo = ##class(web.BDP.util.String).Replace(BloodTransInfo,"\","\\")
	return "["_BloodTransInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-01-02
/// Description：获取患者饮食信息表信息 
/// Table：WDT.CDSS.DietInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者饮食信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetPatientDietInfo("DH001","te001","1")
ClassMethod GetPatientDietInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientDietInfo="",DietInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.DietInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s DietID=0
			for
			{
				s DietID =$o(^WDT.CDSS.DietInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,DietID)) q:DietID=""	
				s DietMethod=$lg($g(^WDT.CDSS.DietInfoD(DietID)),6)
				s DietType=$lg($g(^WDT.CDSS.DietInfoD(DietID)),7)
				s DietContent=$lg($g(^WDT.CDSS.DietInfoD(DietID)),8)
				s DietAmount=$lg($g(^WDT.CDSS.DietInfoD(DietID)),9)
				s DietInstructions=$lg($g(^WDT.CDSS.DietInfoD(DietID)),10)
				s Duration=$lg($g(^WDT.CDSS.DietInfoD(DietID)),11)
				s StartTime=$lg($g(^WDT.CDSS.DietInfoD(DietID)),12)
				//if StartTime'="" s StartTime=$zdate(StartTime,3)
				s EndTime=$lg($g(^WDT.CDSS.DietInfoD(DietID)),13)
				//if EndTime'="" s EndTime=$zdate(EndTime,3)	
				s PassFlag=$lg($g(^WDT.CDSS.DietInfoD(DietID)),14)
				s ProjectName=$lg($g(^WDT.CDSS.DietInfoD(DietID)),17)
				
				s DietInfo="{""DietID"":"""_DietID_""",""DietMethod"":"""_DietMethod_""",""DietType"":"""_DietType_""",""DietContent"":"""_DietContent_""",""DietAmount"":"""_
					DietAmount_""",""DietInstructions"":"""_DietInstructions_""",""Duration"":"""_Duration_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""TableName"":""WDT.CDSS.DietInfo""}"
					
				if (PatientDietInfo="")
				{
					s PatientDietInfo=DietInfo
				}
				else
				{
					s PatientDietInfo=PatientDietInfo_","_DietInfo
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s DietID=0
		for
		{
			s DietID =$o(^WDT.CDSS.DietInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),DietID)) q:DietID=""	
			s DietMethod=$lg($g(^WDT.CDSS.DietInfoD(DietID)),6)
			s DietType=$lg($g(^WDT.CDSS.DietInfoD(DietID)),7)
			s DietContent=$lg($g(^WDT.CDSS.DietInfoD(DietID)),8)
			s DietAmount=$lg($g(^WDT.CDSS.DietInfoD(DietID)),9)
			s DietInstructions=$lg($g(^WDT.CDSS.DietInfoD(DietID)),10)
			s Duration=$lg($g(^WDT.CDSS.DietInfoD(DietID)),11)
			s StartTime=$lg($g(^WDT.CDSS.DietInfoD(DietID)),12)
			//if StartTime'="" s StartTime=$zdate(StartTime,3)
			s EndTime=$lg($g(^WDT.CDSS.DietInfoD(DietID)),13)
			//if EndTime'="" s EndTime=$zdate(EndTime,3)	
			s PassFlag=$lg($g(^WDT.CDSS.DietInfoD(DietID)),14)
			s ProjectName=$lg($g(^WDT.CDSS.DietInfoD(DietID)),17)
			
			s DietInfo="{""DietID"":"""_DietID_""",""DietMethod"":"""_DietMethod_""",""DietType"":"""_DietType_""",""DietContent"":"""_DietContent_""",""DietAmount"":"""_
				DietAmount_""",""DietInstructions"":"""_DietInstructions_""",""Duration"":"""_Duration_""",""StartTime"":"""_StartTime_""",""EndTime"":"""_EndTime_""",""PassFlag"":"""_PassFlag_""",""ProjectName"":"""_ProjectName_""",""TableName"":""WDT.CDSS.DietInfo""}"
				
			if (PatientDietInfo="")
			{
				s PatientDietInfo=DietInfo
			}
			else
			{
				s PatientDietInfo=PatientDietInfo_","_DietInfo
			}
		}
	}
	s PatientDietInfo = ##class(web.BDP.util.String).Replace(PatientDietInfo,"\","\\")
	return "["_PatientDietInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-01-02
/// Description：获取患者其他医嘱信息表信息 
/// Table：WDT.CDSS.OtherOrderInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者其他信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetOtherOrderInfo("DH001","te001","1")
ClassMethod GetOtherOrderInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s OtherOrderInfo="",OrderInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.OtherOrderInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s OrderID=0
			for
			{
				s OrderID =$o(^WDT.CDSS.OtherOrderInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,OrderID)) q:OrderID=""
				s OrderDesc=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),6)
				s ExecuteTime=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),7)
				//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)	
				s ExecuteResult=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),8)
				s PassFlag=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),9)
				s GroupFlag=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),10)
				s GroupSequence=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),11)
				
				s OrderInfo="{""OrderID"":"""_OrderID_""",""OrderDesc"":"""_OrderDesc_""",""ExecuteTime"":"""_ExecuteTime_""",""ExecuteResult"":"""_ExecuteResult_""",""PassFlag"":"""_PassFlag_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_"""}"	
				
				if (OtherOrderInfo="")
				{
					s OtherOrderInfo=OrderInfo			
				}
				else
				{
					s OtherOrderInfo=OtherOrderInfo_","_OrderInfo
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s OrderID=0
		for
		{
			s OrderID =$o(^WDT.CDSS.OtherOrderInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),OrderID)) q:OrderID=""
			s OrderDesc=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),6)
			s ExecuteTime=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),7)
			//if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)	
			s ExecuteResult=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),8)
			s PassFlag=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),9)
			s GroupFlag=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),10)
			s GroupSequence=$lg($g(^WDT.CDSS.OtherOrderInfoD(OrderID)),11)
			
			s OrderInfo="{""OrderID"":"""_OrderID_""",""OrderDesc"":"""_OrderDesc_""",""ExecuteTime"":"""_ExecuteTime_""",""ExecuteResult"":"""_ExecuteResult_""",""PassFlag"":"""_PassFlag_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_"""}"	
			
			if (OtherOrderInfo="")
			{
				s OtherOrderInfo=OrderInfo			
			}
			else
			{
				s OtherOrderInfo=OtherOrderInfo_","_OrderInfo
			}
		}
	}
	s OtherOrderInfo = ##class(web.BDP.util.String).Replace(OtherOrderInfo,"\","\\")
	return "["_OtherOrderInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-03-10
/// Description：获取患者住院病历信息表
/// Table：WDT.CDSS.InpatientInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者住院病历信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetInpatientInfo("DH001","te001","1")
ClassMethod GetInpatientInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s InpatientInfo="",Info=""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.InpatientInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s InpatientID=0
			for
			{
				s InpatientID =$o(^WDT.CDSS.InpatientInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,InpatientID)) q:InpatientID=""
				s MRNum=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),6)
				s MRClass=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),7)
				s MRFileNum=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),8)
				s MRCode=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),9)
				s MRDesc=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),10)
				s UpdateDate=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),11)
				s UpdateRemarks=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),11)
				
				s Info="{""InpatientID"":"""_InpatientID_""",""MRNum"":"""_MRNum_""",""MRClass"":"""_MRClass_""",""MRFileNum"":"""_MRFileNum
					_""",""MRCode"":"""_MRCode_""",""MRDesc"":"""_MRDesc_""",""UpdateDate"":"""_UpdateDate_""",""UpdateRemarks"":"""_UpdateRemarks_"""}"	
				
				if (InpatientInfo="")
				{
					s InpatientInfo=Info			
				}
				else
				{
					s InpatientInfo=InpatientInfo_","_Info
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s InpatientID=0
		for
		{
			s InpatientID =$o(^WDT.CDSS.InpatientInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),InpatientID)) q:InpatientID=""
			s MRNum=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),6)
			s MRClass=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),7)
			s MRFileNum=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),8)
			s MRCode=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),9)
			s MRDesc=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),10)
			s UpdateDate=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),11)
			s UpdateRemarks=$lg($g(^WDT.CDSS.InpatientInfoD(InpatientID)),11)
			
			s Info="{""InpatientID"":"""_InpatientID_""",""MRNum"":"""_MRNum_""",""MRClass"":"""_MRClass_""",""MRFileNum"":"""_MRFileNum
				_""",""MRCode"":"""_MRCode_""",""MRDesc"":"""_MRDesc_""",""UpdateDate"":"""_UpdateDate_""",""UpdateRemarks"":"""_UpdateRemarks_"""}"	
			
			if (InpatientInfo="")
			{
				s InpatientInfo=Info			
			}
			else
			{
				s InpatientInfo=InpatientInfo_","_Info
			}
		}
	}
	s InpatientInfo = ##class(web.BDP.util.String).Replace(InpatientInfo,"\","\\")
	return "["_InpatientInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-03-10
/// Description：获取患者出院带药信息表
/// Table：WDT.CDSS.CarryDrug
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者出院带药信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetCarryDrugInfo("DH001","te001","1")
ClassMethod GetCarryDrugInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s CarryDrugInfo="",Info=""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.CarryDrugI("PatVisDRIndex",PatientDR,VisitID,VisitType)))
		{
			s CarryDrugID=0
			for
			{
				s CarryDrugID =$o(^WDT.CDSS.CarryDrugI("PatVisDRIndex",PatientDR,VisitID,VisitType,CarryDrugID)) q:CarryDrugID=""
				s GroupFlag=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),5)
				s GroupSequence=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),6)
				s DrugCode=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),7)
				s DrugName=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),8)
				s Usage=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),9)
				s Dose=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),10)
				s Frequency=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),11)
				s Unit=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),12)
				s Specification=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),13)
				s StartTime=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),14)
				if StartTime'="" s StartTime=$zdate(StartTime,3)
				s StopTime=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),15)
				if StopTime'="" s StopTime=$zdate(StopTime,3)
				s Remarks=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),16)
				s PassFlag=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),17)
				
				s Info="{""CarryDrugID"":"""_CarryDrugID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence
				_""",""DrugCode"":"""_DrugCode_""",""DrugName"":"""_DrugName_""",""Usage"":"""_Usage_""",""Dose"":"""_Dose
				_""",""Frequency"":"""_Frequency_""",""Unit"":"""_Unit_""",""Specification"":"""_Specification_""",""StartTime"":"""_StartTime
				_""",""StopTime"":"""_StopTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_"""}"	
				
				if (CarryDrugInfo="")
				{
					s CarryDrugInfo=Info			
				}
				else
				{
					s CarryDrugInfo=CarryDrugInfo_","_Info
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s CarryDrugID=0
		for
		{
			s CarryDrugID =$o(^WDT.CDSS.CarryDrugI("IDNOIndex"," "_$zcvt(IDNO,"U"),CarryDrugID)) q:CarryDrugID=""
			s GroupFlag=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),5)
			s GroupSequence=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),6)
			s DrugCode=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),7)
			s DrugName=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),8)
			s Usage=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),9)
			s Dose=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),10)
			s Frequency=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),11)
			s Unit=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),12)
			s Specification=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),13)
			s StartTime=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),14)
			if StartTime'="" s StartTime=$zdate(StartTime,3)
			s StopTime=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),15)
			if StopTime'="" s StopTime=$zdate(StopTime,3)
			s Remarks=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),16)
			s PassFlag=$lg($g(^WDT.CDSS.CarryDrugD(CarryDrugID)),17)
			
			s Info="{""CarryDrugID"":"""_CarryDrugID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence
			_""",""DrugCode"":"""_DrugCode_""",""DrugName"":"""_DrugName_""",""Usage"":"""_Usage_""",""Dose"":"""_Dose
			_""",""Frequency"":"""_Frequency_""",""Unit"":"""_Unit_""",""Specification"":"""_Specification_""",""StartTime"":"""_StartTime
			_""",""StopTime"":"""_StopTime_""",""Remarks"":"""_Remarks_""",""PassFlag"":"""_PassFlag_"""}"	
			
			if (CarryDrugInfo="")
			{
				s CarryDrugInfo=Info			
			}
			else
			{
				s CarryDrugInfo=CarryDrugInfo_","_Info
			}
		}
	}
	s CarryDrugInfo = ##class(web.BDP.util.String).Replace(CarryDrugInfo,"\","\\")
	return "["_CarryDrugInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2020-03-10
/// Description：获取患者其他出院医嘱信息表
/// Table：WDT.CDSS.OtherDisOrderInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者其他出院医嘱信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetOtherDisOrderInfo("DH001","te001","1","")
ClassMethod GetOtherDisOrderInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s OtherDisOrderInfo="",Info=""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.OtherDisOrderInfoI("PatVisDRIndex",PatientDR,VisitID,VisitType)))
		{
			s OtherDisOrderID=0
			for
			{
				s OtherDisOrderID =$o(^WDT.CDSS.OtherDisOrderInfoI("PatVisDRIndex",PatientDR,VisitID,VisitType,OtherDisOrderID)) q:OtherDisOrderID=""
				s OrderDesc=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),5)
				s ExecuteMethod=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),6)
				s PlanStartTime=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),7)
				if PlanStartTime'="" s PlanStartTime=$zdate(PlanStartTime,3)
				s PlanStopTime=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),8)
				if PlanStopTime'="" s PlanStopTime=$zdate(PlanStopTime,3)
				s ExecuteDesc=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),9)
				s PassFlag=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),10)
				s GroupFlag=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),11)
				s GroupSequence=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),12)
			
				s Info="{""OtherDisOrderID"":"""_OtherDisOrderID_""",""OrderDesc"":"""_OrderDesc_""",""ExecuteMethod"":"""_ExecuteMethod
				_""",""PlanStartTime"":"""_PlanStartTime_""",""PlanStopTime"":"""_PlanStopTime_""",""ExecuteDesc"":"""_ExecuteDesc_""",""PassFlag"":"""_PassFlag_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_"""}"	
				
				if (OtherDisOrderInfo="")
				{
					s OtherDisOrderInfo=Info			
				}
				else
				{
					s OtherDisOrderInfo=OtherDisOrderInfo_","_Info
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s OtherDisOrderID=0
		for
		{
			s OtherDisOrderID =$o(^WDT.CDSS.OtherDisOrderInfoI("IDNOIndex"," "_$zcvt(IDNO,"U"),OtherDisOrderID)) q:OtherDisOrderID=""
			s OrderDesc=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),5)
			s ExecuteMethod=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),6)
			s PlanStartTime=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),7)
			if PlanStartTime'="" s PlanStartTime=$zdate(PlanStartTime,3)
			s PlanStopTime=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),8)
			if PlanStopTime'="" s PlanStopTime=$zdate(PlanStopTime,3)
			s ExecuteDesc=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),9)
			s PassFlag=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),10)
			s GroupFlag=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),11)
			s GroupSequence=$lg($g(^WDT.CDSS.OtherDisOrderInfoD(OtherDisOrderID)),12)
				
			s Info="{""OtherDisOrderID"":"""_OtherDisOrderID_""",""OrderDesc"":"""_OrderDesc_""",""ExecuteMethod"":"""_ExecuteMethod
			_""",""PlanStartTime"":"""_PlanStartTime_""",""PlanStopTime"":"""_PlanStopTime_""",""ExecuteDesc"":"""_ExecuteDesc_""",""PassFlag"":"""_PassFlag_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_"""}"	
			
			if (OtherDisOrderInfo="")
			{
				s OtherDisOrderInfo=Info			
			}
			else
			{
				s OtherDisOrderInfo=OtherDisOrderInfo_","_Info
			}
		}
	}
	s OtherDisOrderInfo = ##class(web.BDP.util.String).Replace(OtherDisOrderInfo,"\","\\")
	return "["_OtherDisOrderInfo_"]"
}

/// Creator:dingyanan
/// CreatDate:2021-11-05
/// Description：获取患者评估记录表信息
/// Table：WDT.CDSS.PatientRatingScale
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者评估记录表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetRatingScaleInfo("zhishikuceshi","zhishikuceshi","1","住院",2)
ClassMethod GetRatingScaleInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s RatingScaleInfo="",Info=""
	if (Config=1)&(PatientDR'="")&(VisitID'="")&(VisitType'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.PatientRatingScaleI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s ScaleID=0
			for
			{
				s ScaleID =$o(^WDT.CDSS.PatientRatingScaleI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,ScaleID)) q:ScaleID=""
				
				s RatingScaleDictDR=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),7)
				s MKBABDesc=""
				s:RatingScaleDictDR'="" MKBABDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RatingScaleDictDR)),3)
				s RatingDate=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),8)
				s RatingUser=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),9)
				s RatingDept=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),10)
				s RatingRemarks=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),11)
				s RatingScore=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),12)
				s RatingDesc=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),13)
				s RatingRank=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),14)
				
				s RatingScaleName=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),17)
				s:RatingScaleDictDR'="" RatingScaleName=MKBABDesc
				s RatingResultName="",RatingResult=""
				if (RatingRank'="")
				{
					s lengthRR=$l(RatingRank,"；")
					for iRR=1:1:lengthRR
					{
						s iRRStr=$p(RatingRank,"；",iRR)
						s RatingResultName=$p(iRRStr,"：",1)
						s RatingResults=$p(iRRStr,"：",2)
						s lenResults=$l(RatingResults,"，")
						for iResults=1:1:lenResults
						{
							s RatingResult=$p(RatingResults,"，",iResults)
							s Info="{""ScaleID"":"""_ScaleID_""",""RatingScaleName"":"""_RatingScaleName_""",""RatingDesc"":"""_RatingDesc
							_""",""RatingRank"":"""_RatingRank_""",""RatingScore"":"""_RatingScore_""",""RatingResultName"":"""_RatingResultName_""",""RatingResult"":"""_RatingResult_""",""TableName"":""WDT.CDSS.PatientRatingScale""}"	
									
							if (RatingScaleInfo="")
							{
								s RatingScaleInfo=Info			
							}
							else
							{
								s RatingScaleInfo=RatingScaleInfo_","_Info
							}		
						}
					}
				}
				else
				{
					s Info="{""ScaleID"":"""_ScaleID_""",""RatingScaleName"":"""_RatingScaleName_""",""RatingDesc"":"""_RatingDesc
							_""",""RatingRank"":"""_RatingRank_""",""RatingScore"":"""_RatingScore_""",""RatingResultName"":"""_RatingResultName_""",""RatingResult"":"""_RatingResult_""",""TableName"":""WDT.CDSS.PatientRatingScale""}"	
							
					if (RatingScaleInfo="")
					{
						s RatingScaleInfo=Info			
					}
					else
					{
						s RatingScaleInfo=RatingScaleInfo_","_Info
					}
				}
			}
		}
	}
	elseif (IDNO'="")  //患者主索引
	{
		s ScaleID=0
		for
		{
			s ScaleID =$o(^WDT.CDSS.PatientRatingScaleI("IDNOIndex"," "_$zcvt(IDNO,"U"),ScaleID)) q:ScaleID=""
			s RatingScaleDictDR=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),7)
			s MKBABDesc=""
			s:RatingScaleDictDR'="" MKBABDesc=$lg($g(^CT.WDT.CDSS.AssBaseD(RatingScaleDictDR)),3)
			s RatingDate=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),8)
			s RatingUser=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),9)
			s RatingDept=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),10)
			s RatingRemarks=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),11)
			s RatingScore=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),12)
			s RatingDesc=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),13)
			s RatingRank=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),14)
			
			s RatingScaleName=$lg($g(^WDT.CDSS.PatientRatingScaleD(ScaleID)),17)
			s:RatingScaleDictDR'="" RatingScaleName=MKBABDesc
			
			s RatingResultName="",RatingResult=""
			if (RatingRank'="")
			{
				s lengthRR=$l(RatingRank,"；")
				for iRR=1:1:lengthRR
				{
					s iRRStr=$p(RatingRank,"；",iRR)
					s RatingResultName=$p(iRRStr,"：",1)
					s RatingResults=$p(iRRStr,"：",2)
					s lenResults=$l(RatingResults,"，")
					for iResults=1:1:lenResults
					{
						s RatingResult=$p(RatingResults,"，",iResults)
						s Info="{""ScaleID"":"""_ScaleID_""",""RatingScaleName"":"""_RatingScaleName_""",""RatingDesc"":"""_RatingDesc
						_""",""RatingRank"":"""_RatingRank_""",""RatingScore"":"""_RatingScore_""",""RatingResultName"":"""_RatingResultName_""",""RatingResult"":"""_RatingResult_""",""TableName"":""WDT.CDSS.PatientRatingScale""}"	
								
						if (RatingScaleInfo="")
						{
							s RatingScaleInfo=Info			
						}
						else
						{
							s RatingScaleInfo=RatingScaleInfo_","_Info
						}		
					}
				}
			}
			else
			{
				s Info="{""ScaleID"":"""_ScaleID_""",""RatingScaleName"":"""_RatingScaleName_""",""RatingDesc"":"""_RatingDesc
						_""",""RatingRank"":"""_RatingRank_""",""RatingScore"":"""_RatingScore_""",""RatingResultName"":"""_RatingResultName_""",""RatingResult"":"""_RatingResult_""",""TableName"":""WDT.CDSS.PatientRatingScale""}"	
						
				if (RatingScaleInfo="")
				{
					s RatingScaleInfo=Info			
				}
				else
				{
					s RatingScaleInfo=RatingScaleInfo_","_Info
				}
			}
		}
	}
	s RatingScaleInfo = ##class(web.BDP.util.String).Replace(RatingScaleInfo,"\","\\")
	return "["_RatingScaleInfo_"]"
}

/// Creator:丁亚男
/// CreatDate:2022-10-10
/// Description：护理结果信息表 
/// Table：WDT.CDSS.NursResultInfo
/// Input：IDNO 患者主索引 VisitID 就诊次数编号 VisitType就诊类型
/// Output：患者处方信息表枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetNursResultInfo("DH001","te001","1","1","")
ClassMethod GetNursResultInfo(IDNO As %String, PatientDR As %String, VisitID As %String, VisitType As %String, Config As %String) As %String
{
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s PatientNursResultInfo="",NursResultInfo=""
	if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
	{
		if ($d(^WDT.CDSS.NursResultInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType)))
		{
			s NursResultID=0
			for 
			{
				s NursResultID =$o(^WDT.CDSS.NursResultInfoI("PatVisDRTypeIndex",PatientDR,VisitID,VisitType,NursResultID)) q:NursResultID=""	
				s AnaesId=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),6)
				s MeasureDate=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),7)
				s NursResult=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),8)
				s NursItemName=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),9)
				s NursValue=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),10)
				s NurseValueUnit=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),11)
				s NursMethod=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),12)
				s CDSS2PartDR=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),13)
				s Part="",PartL="",PartStr=""
				if (CDSS2PartDR'="")
				{
					s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
					s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
					s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
				}
				s NursState=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),14)
				s PassFlag=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),15)
				s CheckFormal=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),16)
				s SymptomCore=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),17)
				s SymProperty=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),18)
				
				
				s NursResultInfo="{""NursResultID"":"""_NursResultID_""",""AnaesId"":"""_AnaesId_""",""MeasureDate"":"""_MeasureDate_""",""NursResult"":"""_NursResult_""",""NursItemName"":"""_
					NursItemName_""",""NursValue"":"""_NursValue_""",""NurseValueUnit"":"""_NurseValueUnit_""",""NursMethod"":"""_NursMethod_""",""Part"":"""_Part_""",""PartL"":"""_PartL_
					""",""PassFlag"":"""_PassFlag_""",""NursState"":"""_NursState_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""CheckFormal"":"""_CheckFormal_""",""TableName"":""WDT.CDSS.NursResultInfo""}"
					
				if (PatientNursResultInfo="")
				{
					s PatientNursResultInfo=NursResultInfo
				}
				else
				{
					s PatientNursResultInfo=PatientNursResultInfo_","_NursResultInfo		
				}
			}
		}
	}
	elseif(IDNO'="")  //患者主索引
	{
		s NursResultID=0
		for 
		{
			s NursResultID =$o(^WDT.CDSS.NursResultInfoI("IDNOIndex",IDNO,NursResultID)) q:NursResultID=""	
			s AnaesId=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),6)
			s MeasureDate=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),7)
			s NursResult=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),8)
			s NursItemName=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),9)
			s NursValue=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),10)
			s NurseValueUnit=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),11)
			s NursMethod=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),12)
			
			s CDSS2PartDR=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),13)
			s Part="",PartL="",PartStr=""
			if (CDSS2PartDR'="")
			{
				s PartL=..GetCDSS2PatienPart(CDSS2PartDR)
				s Part=$lg($g(^WDT.CDSS.BodyPartsDictD(CDSS2PartDR)),3)
				s PartStr=..GetCDSS2PatienPartStr(CDSS2PartDR)
			}
			s NursState=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),14)
			s PassFlag=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),15)
			s CheckFormal=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),16)
			s SymptomCore=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),17)
			s SymProperty=$lg($g(^WDT.CDSS.NursResultInfoD(NursResultID)),18)
			
			
			s NursResultInfo="{""NursResultID"":"""_NursResultID_""",""AnaesId"":"""_AnaesId_""",""MeasureDate"":"""_MeasureDate_""",""NursResult"":"""_NursResult_""",""NursItemName"":"""_
				NursItemName_""",""NursValue"":"""_NursValue_""",""NurseValueUnit"":"""_NurseValueUnit_""",""NursMethod"":"""_NursMethod_""",""Part"":"""_Part_""",""PartL"":"""_PartL_
				""",""PassFlag"":"""_PassFlag_""",""NursState"":"""_NursState_""",""SymptomCore"":"""_SymptomCore_""",""SymProperty"":"""_SymProperty_""",""CheckFormal"":"""_CheckFormal_""",""TableName"":""WDT.CDSS.NursResultInfo""}"
					
					
			if (PatientNursResultInfo="")
			{
				s PatientNursResultInfo=NursResultInfo
			}
			else
			{
				s PatientNursResultInfo=PatientNursResultInfo_","_NursResultInfo		
			}
		}
	}
	s PatientNursResultInfo = ##class(web.BDP.util.String).Replace(PatientNursResultInfo,"\","\\")			
	return "["_PatientNursResultInfo_"]"
}

/// 暂时弃用
/// Creator:丁亚男
/// CreatDate:2019-12-26
/// Description：获取用户信息 
/// Input：空
/// Output：当前用户信息枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetDHCDSSUserInfo()
ClassMethod GetDHCDSSUserInfo() As %String
{
    // 用户信息赋值方法，从HIS直接获取或者第三方给接口
	/*s %session.Data("LOGON.USERID")="1"
	s %session.Data("LOGON.USERNAME")="demo"
	s %session.Data("LOGON.CTLOCID")="1"
	s %session.Data("LOGON.LOCDESC")="呼吸内科门诊"
	s UserInfo="",UserID="",UserName="",LocDesc=""
	*/
	if ($d(%session))
	{
		s UserID=$g(%session.Data("LOGON.USERID"))
		s UserName=$g(%session.Data("LOGON.USERNAME"))
		s LocID=$g(%session.Data("LOGON.CTLOCID"))
		s LocDesc=$g(%session.Data("LOGON.LOCDESC"))				
	}
	
	s UserInfo="{""UserID"":"""_UserID_""",""UserName"":"""_UserName_""",""LocID"":"""_LocID_""",""LocDesc"":"""_LocDesc_"""}"
	return "["_UserInfo_"]"
}

/// 暂时弃用
/// Creator:丁亚男
/// CreatDate:2019-12-26
/// Description：获取患者信息 
/// Input：空
/// Output：当前患者信息枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModel).GetDHCDSSPatientInfo()
ClassMethod GetDHCDSSPatientInfo() As %String
{
	// 患者信息赋值方法，从HIS直接获取的话可以在前端赋值或者第三方给接口
	s %session.Data("LOGON.IDNO")="DH001"
	s %session.Data("LOGON.PatientDR")="te001"
	s %session.Data("LOGON.VisitID")="1"
	s IDNO="",PatientDR="",VisitID=""
	if ($d(%session))
	{
		s IDNO=$g(%session.Data("LOGON.IDNO"))
		s PatientDR=$g(%session.Data("LOGON.PatientDR"))
		s VisitID=$g(%session.Data("LOGON.VisitID"))				
	}
	
	s UserInfo="{""IDNO"":"""_IDNO_""",""PatientDR"":"""_PatientDR_""",""VisitID"":"""_VisitID_"""}"
	return "["_UserInfo_"]"
}

}

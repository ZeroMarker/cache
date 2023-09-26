/// 名称:获取患者模型信息的接口
/// 描述: cdss与python获取患者模型信息的接口
/// 编写者：丁亚男-基础数据平台
/// 编写日期: 2020-04-07
Class web.CDSS.Public.PatientModelInterface Extends %RegisteredObject
{

/// 暂时未使用--后期是否用或删除
/// Creator:tianhongxiang
/// CreatDate:2019-12-25
/// Description：neo4j 知识图谱构建获取疾病信息调用Api接口
/// w ##class(web.CDSS.Public.PatientModelInterface).GetDiseaseInfoByNeo4jOld()
ClassMethod GetDiseaseInfoByNeo4jOld(diseasinfo As %String) As %String
{
	;s conn = "{""name"":""急性阑尾炎""}"
	s url = "http://127.0.0.1:8801/UpdateDiseaseOld"
	s conn=$zconvert(diseasinfo,"O","UTF8")  //设置为utf-8
	s httprequest = ##class(%Net.HttpRequest).%New()
	s httprequest.ContentType = "application/json"
	d httprequest.EntityBody.Write(conn)
	s tSc = httprequest.Post(url)
	s Str = httprequest.HttpResponse.Data.Read()
    return Str
}

/// Creator:tianhongxiang
/// CreatDate:2019-12-25
/// Description：neo4j 知识图谱构建获取疾病信息调用Api接口 --根据20200325调整的算法模型
/// w ##class(web.DHCDSS.PY.Interface).GetDiseaseInfoByNeo4j()
ClassMethod GetDiseaseInfoByNeo4j(diseasinfo As %String) As %String
{
	;s conn = "{""name"":""急性阑尾炎""}"
	s url = "http://127.0.0.1:8801/UpdateDisease"
	s conn=$zconvert(diseasinfo,"O","UTF8")  //设置为utf-8
	s httprequest = ##class(%Net.HttpRequest).%New()
	s httprequest.ContentType = "application/json"
	d httprequest.EntityBody.Write(conn)
	s tSc = httprequest.Post(url)
	s Str = httprequest.HttpResponse.Data.Read()
    return Str
}

/// Creator:tianhongxiang
/// CreatDate:2020-02-27
/// Description：neo4j 知识图谱构建获取评分量表api接口
/// w ##class(web.CDSS.Public.PatientModelInterface).Neo4jApi()
ClassMethod GetEstimateScaleByNeo4j(scaleinfo As %String) As %String
{
	s url = "http://127.0.0.1:8801/UpdateRatingScale"
	s conn=$zconvert(scaleinfo,"O","UTF8")  //设置为utf-8
	s httprequest = ##class(%Net.HttpRequest).%New()
	s httprequest.ContentType = "application/json"
	d httprequest.EntityBody.Write(conn)
	s tSc = httprequest.Post(url)
	s Str = httprequest.HttpResponse.Data.Read()
    return Str
}

/// Creator:tianhongxiang
/// CreatDate:2020-03-30
/// Description：获得评分量表返回的推理信息
/// w ##class(web.CDSS.Public.PatientModelInterface).GetEstimateScaleByNeo4j("急性阑尾炎^十二指肠溃疡","上腹痛","","","","","","","")
ClassMethod GetRatingScaleByAppItems(dise, sym, test, check, sign, cons, Sex, Age, BT) As %String
{
	s info="dise="_dise_"&sym="_sym_"&test="_test_"&check="_check_"&sign="_sign_"&cons="_sign_"&Sex="_Sex_"&Age="_Age_"&BT="_BT_""
	s url = "http://192.144.152.252:8080/recom_sating_scale?"_info_""
	s conn=$zconvert(url,"O","UTF8")  //设置为utf-8
	s httprequest = ##class(%Net.HttpRequest).%New()
	s httprequest.ContentType = "application/json"
	d httprequest.EntityBody.Write(conn)
	s tSc = httprequest.Get(url)
	s Str = httprequest.HttpResponse.Data.Read()
	s Str=$zconvert(Str,"I","UTF8")  //设置为utf-8
    return Str
}

/// Creator:dingyanan
/// CreatDate:2020-03-18
/// Description：患者模型的枚举接口
/// Input：IDNO^PatientDR^VisitID^VisitType^UserID^UserName^CTLocID^CTLocDesc^Config^枚举字段  IDNO患者主索引 PatientDR病人标识 VisitID就诊次数编号 UserID用户ID UserName用户名 CTLocID科室ID CTLocDesc 科室名称 枚举字段（姓名/性别等,A为全部）
/// Output: 返回枚举字段的json串
/// w ##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo("35^0000000037^1^住院^18881^医生01^ZYZY002^消化内科^1^诊断")
ClassMethod GetPatientEnumInfo(PatentVar As %String) As %String
{
	s IDNO=$p(PatentVar,"^",1)
	s PatientDR=$p(PatentVar,"^",2)
	s VisitID=$p(PatentVar,"^",3)
	s VisitType=$p(PatentVar,"^",4)
	s Config=$p(PatentVar,"^",9)
	s Type=$p(PatentVar,"^",10)
	if (Config="") s Config=1	//是否启用流水号（急诊号、门诊号、住院号）为患者就诊唯一标识（0为是，1为否），默认为1
	s TypeCode=Type
	if (TypeCode["CDD")&&(##class(web.DHCBL.BDP.FunLib).IsValidClassName("User.DHCDSSBasicsDict"))&&($d(^User.DHCDSSBasicsDictI("ItemCodeIndex")))
	{
		s DictItemRowId=""
		s:TypeCode'="" DictItemRowId=$o(^User.DHCDSSBasicsDictI("ItemCodeIndex"," "_$ZCONVERT(TypeCode,"U"),""))
		s TypeName=""
		s:DictItemRowId'="" TypeName=$listGet($g(^User.DHCDSSBasicsDictD(DictItemRowId)),9)
		s Type=TypeName
	}
	
	if (Type="A")   //取患者模型所有的数据信息
	{
		s PatientBaseInfo=##class(web.CDSS.Public.PatientModel).GetPatientBaseInfo(IDNO,PatientDR,Config)
		s PatientVisitInfo=##class(web.CDSS.Public.PatientModel).GetPatientVisitInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientSignInfo=##class(web.CDSS.Public.PatientModel).GetPatientSignInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s PastDiagnosis=##class(web.CDSS.Public.PatientModel).GetPastDiagnosis(IDNO,PatientDR,VisitID,VisitType,Config)
		s PersonalInfo=##class(web.CDSS.Public.PatientModel).GetPersonalInfo(IDNO,PatientDR,Config)
		s MarryInfo=##class(web.CDSS.Public.PatientModel).GetMarryInfo(IDNO,PatientDR,Config)
		s FamilyHisInfo=##class(web.CDSS.Public.PatientModel).GetFamilyHisInfo(IDNO,PatientDR,Config)
		s AllergyInfo=##class(web.CDSS.Public.PatientModel).GetAllergyHistory(IDNO,PatientDR,Config)
		s PhysicalExam=##class(web.CDSS.Public.PatientModel).GetPhysicalExam(IDNO,PatientDR,VisitID,VisitType,Config)
		s SpecExamInfo=##class(web.CDSS.Public.PatientModel).GetSpecExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientDrugInfo=##class(web.CDSS.Public.PatientModel).GetPatientDrugInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientLabInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s OperationInfo=##class(web.CDSS.Public.PatientModel).GetOperationInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s AnestInfo=##class(web.CDSS.Public.PatientModel).GetAnestInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s NursingInfo=##class(web.CDSS.Public.PatientModel).GetNursingInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s BloodTransInfo=##class(web.CDSS.Public.PatientModel).GetBloodTransInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientDietInfo=##class(web.CDSS.Public.PatientModel).GetPatientDietInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s OtherOrderInfo=##class(web.CDSS.Public.PatientModel).GetOtherOrderInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s InpatientInfo= ##class(web.CDSS.Public.PatientModel).GetInpatientInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CarryDrugInfo=##class(web.CDSS.Public.PatientModel).GetCarryDrugInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s GetOtherDisOrderInfo=##class(web.CDSS.Public.PatientModel).GetOtherDisOrderInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		
		s PatientInfo="[{""IDNO"":"""_IDNO_""",""PatientDR"":"""_PatientDR_""",""VisitID"":"""_VisitID_""",""children"":[{"
		_"""DataClass"":""DHCDSSPatientMaster"",""children"":["_PatientBaseInfo_"]},{""DataClass"":""DHCDSSPatientVisit"",""children"":["_PatientVisitInfo_"]},{""DataClass"":""DHCDSSSignInfo"",""children"":"_PatientSignInfo_"},{""DataClass"":""DHCDSSChiefCompInfo"",""children"":["_PatienCompInfo_"]},{""DataClass"":""DHCDSSCurrentMedHistory"",""children"":["_CurrentMedHistory_"]},{""DataClass"":""DHCDSSPastDiagnosis"",""children"":"_PastDiagnosis
		_"},{""DataClass"":""DHCDSSPersonalInfo"",""children"":"_PersonalInfo_"},{""DataClass"":""DHCDSSMarryInfo"",""children"":"_MarryInfo_"},{""DataClass"":""DHCDSSFamilyHisInfo"",""children"":"_FamilyHisInfo_"},{""DataClass"":""DHCDSSAllergyHistory"",""children"":"_AllergyInfo_"},{""DataClass"":""DHCDSSPhysicalExam"",""children"":["_PhysicalExam_"]},{""DataClass"":""DHCDSSSpecExam"",""children"":["_SpecExamInfo
		_"]},{""DataClass"":""DHCDSSDiagnosisInfo"",""children"":"_DiagnosisInfo_"},{""DataClass"":""DHCDSSDrugInfo"",""children"":"_PatientDrugInfo_"},{""DataClass"":""DHCDSSExamInfo"",""children"":"_PatientExamInfo_"},{""DataClass"":""DHCDSSLabInfo"",""children"":"_PatientLabInfo_"},{""DataClass"":""DHCDSSOperationInfo"",""children"":"_OperationInfo_"},{""DataClass"":""DHCDSSAnestInfo"",""children"":"_AnestInfo
		_"},{""DataClass"":""DHCDSSNursingInfo"",""children"":"_NursingInfo_"},{""DataClass"":""DHCDSSBloodTransInfo"",""children"":"_BloodTransInfo_"},{""DataClass"":""DHCDSSDietInfo"",""children"":"_PatientDietInfo_"},{""DataClass"":""DHCDSSOtherOrderInfo"",""children"":"_OtherOrderInfo_"},{""DataClass"":""DHCDSSInpatientInfo"",""children"":"_InpatientInfo_"},{""DataClass"":""DHCDSSCarryDrug"",""children"":"_CarryDrugInfo
		_"},{""DataClass"":""DHCDSSOtherDisOrderInfo"",""children"":"_GetOtherDisOrderInfo_"}]}]"
		
		s PatientInfo = ##class(web.BDP.util.String).Replace(PatientInfo,"\","\\")
		return PatientInfo
	}
	//根据枚举字段取患者模型对应的数据信息
	elseif (Type="姓名") 
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}
		q:BaseID="" "[]"
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
		s PatientBaseInfo="[{""Name"":"""_Name_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo
	}
	elseif (Type="性别")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}
		q:BaseID="" "[]"
		s Sex=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),7)
		s PatientBaseInfo="[{""Sex"":"""_Sex_"""}]"
		return PatientBaseInfo
	}
	elseif (Type="年龄")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Age=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),8)
		s PatientBaseInfo="[{""Age"":"""_Age_"""}]"
		return PatientBaseInfo
	}
	elseif (Type="年龄(天)")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Birthday=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),17)
		if (Birthday'="")
		{
			s dateday=$zdh(Birthday,3)
			s days=+$h-dateday
		}
		else
		{
			s days=""
		}
		s PatientBaseInfo="[{""Age"":"""_days_"""}]"
		return PatientBaseInfo
	}
	elseif (Type="职业")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Profession=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),9)
		s PatientBaseInfo="[{""Profession"":"""_Profession_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo
	}
	elseif (Type="民族")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Nation=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),10)
		s PatientBaseInfo="[{""Nation"":"""_Nation_"""}]"
		return PatientBaseInfo
	}
	elseif (Type="婚姻")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Marriage=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),11)
		s PatientBaseInfo="[{""Marriage"":"""_Marriage_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo	
	}
	elseif (Type="血型")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s BloodGroup=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),12)
		s PatientBaseInfo="[{""BloodGroup"":"""_BloodGroup_"""}]"
		return PatientBaseInfo	
	}
	elseif (Type="国籍")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Country=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),13)
		s PatientBaseInfo="[{""Country"":"""_Country_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo
	}
	elseif (Type="籍贯")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s Birthplace=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),14)
		s PatientBaseInfo="[{""Birthplace"":"""_Birthplace_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo
	}
	elseif (Type="现住址")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
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
		s PatientBaseInfo="[{""CurrentAddress"":"""_CurrentAddress_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo
	}
	elseif (Type="电话")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}
		q:BaseID="" "[]"
		s PhoneNumberOrg=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),16)
		s PhoneNumberlen=$l(PhoneNumberOrg)
		s PhoneNumber=PhoneNumberOrg
		if (PhoneNumberlen=11)
		{
			s PhoneNumber=$E(PhoneNumberOrg,1,3)_"****"_$E(PhoneNumberOrg,*-3,*)
		}
		s PatientBaseInfo="[{""PhoneNumber"":"""_PhoneNumber_"""}]"
		return PatientBaseInfo
	}
	elseif (Type="妊娠/产后状态")
	{
		s BaseID=""
		if (Config=1)&(PatientDR'="")  //单个患者单次就诊 根据病人标识取数据
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("PatDRIndex",PatientDR,0))
		}
		elseif (IDNO'="")  //患者主索引
		{
			s BaseID =$o(^WDT.CDSS.PatientMasterI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		}	
		q:BaseID="" "[]"
		s PregStatus=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),18)
		s GestWeek=$lg($g(^WDT.CDSS.PatientMasterD(BaseID)),19)
		s PatientBaseInfo="[{""PregStatus"":"""_PregStatus_""",""GestWeek"":"""_GestWeek_"""}]"
		s PatientBaseInfo = ##class(web.BDP.util.String).Replace(PatientBaseInfo,"\","\\")
		return PatientBaseInfo
	}
	elseif (Type="就诊时间")
	{
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
		q:VisiID="" "[]"
		s TreatmentTime=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),6)
		//if TreatmentTime'="" s TreatmentTime=$zdate(TreatmentTime,3)
		s VisitInfo="[{""TreatmentTime"":"""_TreatmentTime_"""}]"
		return VisitInfo	
	}
	elseif (Type="就诊科室")
	{
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
		q:VisiID="" "[]"
		s VisitingDepartment=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),7)
		s VisitInfo="[{""VisitingDepartment"":"""_VisitingDepartment_"""}]"
		s VisitInfo = ##class(web.BDP.util.String).Replace(VisitInfo,"\","\\")
		return VisitInfo	
	}
	elseif (Type="合并症标记")
	{
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
		q:VisiID="" "[]"
		s ComorbidityMarker=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),8)
		s VisitInfo="[{""ComorbidityMarker"":"""_ComorbidityMarker_"""}]"
		return VisitInfo	
	}
	elseif (Type="转科记录")
	{
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
		q:VisiID="" "[]"
		s TransferRecord=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),9)
		s VisitInfo="[{""TransferRecord"":"""_TransferRecord_"""}]"
		s VisitInfo = ##class(web.BDP.util.String).Replace(VisitInfo,"\","\\")
		return VisitInfo	
	}
	elseif (Type="离院时间")
	{
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
		q:VisiID="" "[]"
		s DischargeTime=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),10)
		if DischargeTime'="" s DischargeTime=$zdate(DischargeTime,3)
		s VisitInfo="[{""DischargeTime"":"""_DischargeTime_"""}]"
		return VisitInfo	
	}
	elseif (Type="离院科室")
	{
		s VisiID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID)))
			{
				s VisiID =$o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,0)) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			s VisiID =$o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		} 
		q:VisiID="" "[]"
		s DischargeDepartment=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),11)
		s VisitInfo="[{""DischargeDepartment"":"""_DischargeDepartment_"""}]"
		s VisitInfo = ##class(web.BDP.util.String).Replace(VisitInfo,"\","\\")
		return VisitInfo	
	}
	elseif (Type="就诊信息")
	{
		s VisiID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID)))
			{
				s VisiID =$o(^WDT.CDSS.PatientVisitI("PatVisDRTypeIndex",PatientDR,VisitID,0)) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			s VisiID =$o(^WDT.CDSS.PatientVisitI("IDNOIndex"," "_$zcvt(IDNO,"U"),0))
		} 
		q:VisiID="" "[]"
		//s VisitType=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),5)
		s TreatmentTime=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),6)
		//if TreatmentTime'="" s TreatmentTime=$zdate(TreatmentTime,3)
		s VisitInfo="[{""VisitType"":"""_VisitType_""",""TreatmentTime"":"""_TreatmentTime_"""}]"
		s VisitInfo = ##class(web.BDP.util.String).Replace(VisitInfo,"\","\\")
		return VisitInfo	
	}
	elseif (Type="主诉")
	{
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
		q:VisiID="" "[]"
		s ChiefCompSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),12)
		s VisitInfo="[{""ChiefCompSum"":"""_ChiefCompSum_"""}]"
		s VisitInfo = ##class(web.BDP.util.String).Replace(VisitInfo,"\","\\")
		return VisitInfo	
	}
	elseif (Type="现病史")
	{
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
		q:VisiID="" "[]"
		s CurrentMedHisSum=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),13)
		s VisitInfo="[{""CurrentMedHisSum"":"""_CurrentMedHisSum_"""}]"
		s VisitInfo = ##class(web.BDP.util.String).Replace(VisitInfo,"\","\\")
		return VisitInfo	
	}
	elseif (Type="危机标志")
	{
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
		q:VisiID="" "[]"
		s IsDanger=$lg($g(^WDT.CDSS.PatientVisitD(VisiID)),22)
		
		s VisitInfo="[{""IsDanger"":"""_IsDanger_"""}]"
		return VisitInfo	
	}
	elseif (Type="体温")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s BodyTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),6)
		s SignInfo="[{""BodyTemperature"":"""_BodyTemperature_"""}]"
		return SignInfo	
	}
	elseif (Type="血压")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s BloodPressure=$lg($g(^WDT.CDSS.SignInfoD(SignID)),7)
		s SignInfo="[{""BloodPressure"":"""_BloodPressure_"""}]"
		s SignInfo = ##class(web.BDP.util.String).Replace(SignInfo,"\","\\")
		return SignInfo	
	}
	elseif (Type="舒张压")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s DiastolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),18)
		s SignInfo="[{""DiastolicBlood"":"""_DiastolicBlood_"""}]"
		return SignInfo	
	}
	elseif (Type="收缩压")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s SystolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),19)
		s SignInfo="[{""SystolicBlood"":"""_SystolicBlood_"""}]"
		return SignInfo	
	}
	elseif (Type="平均动脉压")  //平均动脉压=(收缩压+2×舒张压)/3  安徽省立项目
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s DiastolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),18)  //收缩压
		s SystolicBlood=$lg($g(^WDT.CDSS.SignInfoD(SignID)),19)  //舒张压
		s AvgBlood=(DiastolicBlood+2*SystolicBlood)/3
		s SignInfo="[{""AvgBlood"":"""_AvgBlood_"""}]"
		return SignInfo	
	}
	elseif (Type="脉搏")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s Pulse=$lg($g(^WDT.CDSS.SignInfoD(SignID)),8)
		s:Pulse="" Pulse=$lg($g(^WDT.CDSS.SignInfoD(SignID)),10)
		s SignInfo="[{""Pulse"":"""_Pulse_"""}]"
		return SignInfo	
	}
	elseif (Type="呼吸")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s BreathFeature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),9)
		s SignInfo="[{""BreathFeature"":"""_BreathFeature_"""}]"
		return SignInfo	
	}
	elseif (Type="心率")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s HeartRate=$lg($g(^WDT.CDSS.SignInfoD(SignID)),10)
		s SignInfo="[{""HeartRate"":"""_HeartRate_"""}]"
		return SignInfo	
	}
	elseif (Type="血氧饱和度")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		
		s OxygenSaturation=$lg($g(^WDT.CDSS.SignInfoD(SignID)),11)
		s SignInfo="[{""OxygenSaturation"":"""_OxygenSaturation_"""}]"
		return SignInfo	
	}
	elseif (Type="瞳孔")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s Pupil=$lg($g(^WDT.CDSS.SignInfoD(SignID)),12)
		s SignInfo="[{""Pupil"":"""_Pupil_"""}]"
		return SignInfo	
	}
	elseif (Type="角膜反射")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s CornealReflex=$lg($g(^WDT.CDSS.SignInfoD(SignID)),13)
		s SignInfo="[{""CornealReflex"":"""_CornealReflex_"""}]"
		return SignInfo	
	}
	elseif (Type="身高")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s Height=$lg($g(^WDT.CDSS.SignInfoD(SignID)),14)
		s SignInfo="[{""Height"":"""_Height_"""}]"
		return SignInfo	
	}
	elseif (Type="体重")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s Weight=$lg($g(^WDT.CDSS.SignInfoD(SignID)),15)
		s SignInfo="[{""Weight"":"""_Weight_"""}]"
		return SignInfo	
	}
	elseif (Type="BMI")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s Height=$lg($g(^WDT.CDSS.SignInfoD(SignID)),14)
		s Weight=$lg($g(^WDT.CDSS.SignInfoD(SignID)),15)
		s BMI="未知"
		if (Height'="")&(Weight'="")
		{
			s BMI=Weight/(Height*Height)*10000
			s BMI=$fn(BMI,"",2)
		}
		s SignInfo="[{""BMI"":"""_BMI_"""}]"
		return SignInfo	
	}
	elseif (Type="口温")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s OralTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),20)
		s SignInfo="[{""OralTemperature"":"""_OralTemperature_"""}]"
		return SignInfo	
	}
	elseif (Type="肛温")
	{
		s MeasureDate="",SignID=""
		if (Config=1)&(PatientDR'="")&(VisitID'="") // 单个患者单次就诊 根据病人标识和就诊次数编号取数据
		{
			if ($d(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("PatVisDRTypeTimeIndex",PatientDR,VisitID,VisitType,MeasureDate,SignID),-1) 
			}
		} 
		elseif (IDNO'="")  //患者主索引
		{
			if ($d(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO)))
			{
				s MeasureDate =$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate),-1) 
				s:MeasureDate'="" SignID=$o(^WDT.CDSS.SignInfoI("IDNOTimeIndex",IDNO,MeasureDate,SignID),-1) 
			}
		} 
		q:SignID="" "[]"
		s AnalTemperature=$lg($g(^WDT.CDSS.SignInfoD(SignID)),21)
		s SignInfo="[{""AnalTemperature"":"""_AnalTemperature_"""}]"
		return SignInfo	
	}
	elseif (Type="体征")
	{
		s PatientSignInfo=##class(web.CDSS.Public.PatientModel).GetPatientSignInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return PatientSignInfo
	}
	elseif (Type="体格检查")
	{
		s PhysicalExam=##class(web.CDSS.Public.PatientModel).GetPhysicalExam(IDNO,PatientDR,VisitID,VisitType,Config)
		return PhysicalExam
	}
	elseif (Type="症状")
	{
		s PatientInfo=""
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s PhysicalExam=##class(web.CDSS.Public.PatientModel).GetPhysicalExam(IDNO,PatientDR,VisitID,VisitType,Config)
		s SpecExamInfo=##class(web.CDSS.Public.PatientModel).GetSpecExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s:(PatienCompInfo'="") PatientInfo=PatienCompInfo
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
	elseif (Type="诱因")
	{
		s PatientInfo=""
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		
		s PastDiagnosis=##class(web.CDSS.Public.PatientModel).GetPastDiagnosis(IDNO,PatientDR,VisitID,VisitType,Config)
		s PersonalInfo=##class(web.CDSS.Public.PatientModel).GetPersonalInfo(IDNO,PatientDR,Config)
		
		s:(PatienCompInfo'="") PatientInfo=PatienCompInfo
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
		  s:(PastDiagnosis'="[]") PatientInfo=PatientInfo_","_$e(PastDiagnosis,2,*-1)
		}
		else
		{
			s:(PastDiagnosis'="[]") PatientInfo=$e(PastDiagnosis,2,*-1)	
		}
		
		if (PatientInfo'="")
		{
		  s:(PersonalInfo'="[]") PatientInfo=PatientInfo_","_$e(PersonalInfo,2,*-1)
		}
		else
		{
			s:(PersonalInfo'="[]") PatientInfo=$e(PersonalInfo,2,*-1)	
		}
		
		
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
		
	}
	elseif (Type="诊断症状")
	{
		s PatientInfo=""
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"")
		
		s:(PatienCompInfo'="") PatientInfo=PatienCompInfo
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
		  s:(DiagnosisInfo'="[]") PatientInfo=PatientInfo_","_$e(DiagnosisInfo,2,*-1)
		}
		else
		{
		  s:(DiagnosisInfo'="[]") PatientInfo=$e(DiagnosisInfo,2,*-1)
		}
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
		
	}
	elseif (Type="西医诊断症状")
	{
		s PatientInfo=""
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"西医")
		
		s:(PatienCompInfo'="") PatientInfo=PatienCompInfo
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
		  s:(DiagnosisInfo'="[]") PatientInfo=PatientInfo_","_$e(DiagnosisInfo,2,*-1)
		}
		else
		{
		  s:(DiagnosisInfo'="[]") PatientInfo=$e(DiagnosisInfo,2,*-1)
		}
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
		
	}
	elseif (Type="中医诊断症状")
	{
		s PatientInfo=""
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"中医")
		
		s:(PatienCompInfo'="") PatientInfo=PatienCompInfo
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
		  s:(DiagnosisInfo'="[]") PatientInfo=PatientInfo_","_$e(DiagnosisInfo,2,*-1)
		}
		else
		{
		  s:(DiagnosisInfo'="[]") PatientInfo=$e(DiagnosisInfo,2,*-1)
		}
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
		
	}
	elseif (Type="证型症状")
	{
		s PatientInfo=""
		s PatienCompInfo=##class(web.CDSS.Public.PatientModel).GetPatienCompInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s CurrentMedHistory=##class(web.CDSS.Public.PatientModel).GetCurrentMedHistory(IDNO,PatientDR,VisitID,VisitType,Config)
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"证型")
		
		s:(PatienCompInfo'="") PatientInfo=PatienCompInfo
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
		  s:(DiagnosisInfo'="[]") PatientInfo=PatientInfo_","_$e(DiagnosisInfo,2,*-1)
		}
		else
		{
		  s:(DiagnosisInfo'="[]") PatientInfo=$e(DiagnosisInfo,2,*-1)
		}
		s PatientInfo="["_PatientInfo_"]"
		return PatientInfo
		
	}
	elseif (Type="既往史")
	{
		s PastDiagnosis=##class(web.CDSS.Public.PatientModel).GetPastDiagnosis(IDNO,PatientDR,VisitID,VisitType,Config)
		return PastDiagnosis	
	}
	elseif (Type="个人史")
	{
		s PersonalInfo=##class(web.CDSS.Public.PatientModel).GetPersonalInfo(IDNO,PatientDR,Config)
		return PersonalInfo	
	}
	elseif (Type="婚育史")
	{
		s MarryInfo=##class(web.CDSS.Public.PatientModel).GetMarryInfo(IDNO,PatientDR,Config)
		return MarryInfo
	}
	elseif (Type="家族史")
	{
		s FamilyHisInfo=##class(web.CDSS.Public.PatientModel).GetFamilyHisInfo(IDNO,PatientDR,Config)
		return FamilyHisInfo
	}
	elseif (Type="过敏史")
	{
		s AllergyInfo=##class(web.CDSS.Public.PatientModel).GetAllergyHistory(IDNO,PatientDR,Config)
		return AllergyInfo
	}
	elseif (Type="诊断")
	{
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"")
		return DiagnosisInfo	
	}
	elseif (Type="西医诊断")
	{
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"西医")
		return DiagnosisInfo	
	}
	elseif (Type="中医诊断")
	{
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"中医")
		return DiagnosisInfo	
	}
	elseif (Type="证型")
	{
		s DiagnosisInfo=##class(web.CDSS.Public.PatientModel).GetDiagnosisInfo(IDNO,PatientDR,VisitID,VisitType,Config,"证型")
		return DiagnosisInfo	
	}
	elseif (Type="药品")
	{
		s PatientDrugInfo=##class(web.CDSS.Public.PatientModel).GetPatientDrugInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return PatientDrugInfo
	}
	elseif (Type="检查")
	{
		s PatientExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientExamInfo(IDNO,PatientDR,VisitID,VisitType,Config,"1")
		return PatientExamInfo
	}
	elseif (Type="检验")
	{
		s PatientLabInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabInfo(IDNO,PatientDR,VisitID,VisitType,Config,"1")
		
		return PatientLabInfo
	}
	elseif (Type="检查结果")
	{
		s PatientExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientLabExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabExamInfo(IDNO,PatientDR,VisitID,VisitType,Config,"检查")
		
		s PatientInfo=""
		s:(PatientExamInfo'="[]") PatientInfo=PatientExamInfo
		if (PatientInfo'="")
		{
		  s:PatientLabExamInfo'="[]" PatientInfo="["_$e(PatientInfo,2,*-1)_","_$e(PatientLabExamInfo,2,*-1)_"]"
		}
		else
		{
			s:PatientLabExamInfo'="" PatientInfo=PatientLabExamInfo	
		}
		
		return PatientInfo
	}
	elseif (Type="检验结果")
	{
		s PatientLabInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientLabExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabExamInfo(IDNO,PatientDR,VisitID,VisitType,Config,"检验")
		
		s PatientInfo=""
		s:(PatientLabInfo'="[]") PatientInfo=PatientLabInfo
		if (PatientInfo'="")
		{
		  s:PatientLabExamInfo'="[]" PatientInfo="["_$e(PatientInfo,2,*-1)_","_$e(PatientLabExamInfo,2,*-1)_"]"
		}
		else
		{
			s:PatientLabExamInfo'="" PatientInfo=PatientLabExamInfo	
		}
		
		return PatientInfo
	}
	elseif (Type="检查检验结果")
	{
		s PatientExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientExamInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientLabInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		s PatientLabExamInfo=##class(web.CDSS.Public.PatientModel).GetPatientLabExamInfo(IDNO,PatientDR,VisitID,VisitType,Config,"")
		
		s PatientInfo=""
		s:(PatientExamInfo'="[]") PatientInfo=PatientExamInfo
		if (PatientInfo'="")
		{
		  s:PatientLabInfo'="[]" PatientInfo="["_$e(PatientInfo,2,*-1)_","_$e(PatientLabInfo,2,*-1)_"]"
		}
		else
		{
			s:PatientLabInfo'="[]" PatientInfo=PatientLabInfo	
		}
		
		if (PatientInfo'="")
		{
		  s:PatientLabExamInfo'="[]" PatientInfo="["_$e(PatientInfo,2,*-1)_","_$e(PatientLabExamInfo,2,*-1)_"]"
		}
		else
		{
			s:PatientLabExamInfo'="[]" PatientInfo=PatientLabExamInfo	
		}
		
		return PatientInfo
	}
	elseif (Type="手术")
	{
		s OperationInfo=##class(web.CDSS.Public.PatientModel).GetOperationInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return OperationInfo
	}
	elseif (Type="麻醉")
	{
		s AnestInfo=##class(web.CDSS.Public.PatientModel).GetAnestInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return AnestInfo
	}
	elseif (Type="护理")
	{
		s NursingInfo=##class(web.CDSS.Public.PatientModel).GetNursingInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return NursingInfo	
	}
	elseif (Type="输血")
	{
		s BloodTransInfo=##class(web.CDSS.Public.PatientModel).GetBloodTransInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return BloodTransInfo
	}
	elseif (Type="饮食")
	{
		s PatientDietInfo=##class(web.CDSS.Public.PatientModel).GetPatientDietInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return PatientDietInfo
	}
	elseif (Type="处置")
	{
		s OtherOrderInfo=##class(web.CDSS.Public.PatientModel).GetOtherOrderInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return OtherOrderInfo
	}
	elseif (Type="病历信息")
	{
		s InpatientInfo=##class(web.CDSS.Public.PatientModel).GetInpatientInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return InpatientInfo
	}
	elseif (Type="出院医嘱")
	{
		s CarryDrugInfo=##class(web.CDSS.Public.PatientModel).GetCarryDrugInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return CarryDrugInfo
	}
	elseif (Type="评估表")
	{
		s RatingScaleInfo=##class(web.CDSS.Public.PatientModel).GetRatingScaleInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return RatingScaleInfo
	}
	elseif (Type="护理结果")
	{
		s NursResultInfo=##class(web.CDSS.Public.PatientModel).GetNursResultInfo(IDNO,PatientDR,VisitID,VisitType,Config)
		return NursResultInfo
	}
	else
	{
		return ""
	}
}

/// 暂时未使用--后期是否用或删除
/// Creator:tianhongxiang
/// CreatDate:2020-02-25
/// Description：提供python调用推荐评分量表信息接口
/// w ##class(web.CDSS.Public.PatientModelInterface).RecomSatingScale("急性阑尾炎^dise")
ClassMethod RecomSatingScale(info As %String) As %String
{
	s result=""
    s flag=$p(info,"^",2)
    if (flag="dise")
    {
		s result=##class(web.CDSS.TreatDecision.ScoringScale).DiseSatingScale($p(info,"^",1))
    }
    elseif (flag="sym")
    {
	    s result=##class(web.CDSS.TreatDecision.ScoringScale).SymSatingScale($p(info,"^",1))
	}
	elseif (flag="Lab")
	{
		s result=##class(web.CDSS.TreatDecision.ScoringScale).LabSatingScale($p(info,"^",1))
	}
	elseif (flag="Exam")
	{
		s result=##class(web.CDSS.TreatDecision.ScoringScale).ExamSatingScale($p(info,"^",1))
	}
	elseif (flag="Sign")
	{
		s result=##class(web.CDSS.TreatDecision.ScoringScale).SignSatingScale($p(info,"^",1))
	}
	elseif (flag="Cons")
	{
		s result=##class(web.CDSS.TreatDecision.ScoringScale).ConsSatingScale($p(info,"^",1))
	}
	return result
}

/// Creator:tianhongxiang
/// CreatDate:2020-02-25
/// Description：提供python调用急诊预检分诊分级算法推荐患者病情等级的功能字典信息获取
/// w ##class(web.CDSS.Public.PatientModelInterface).GetEmerStandGrade("心率")
ClassMethod GetEmerStandGrade(FirstNorm As %String) As %String
{
	s result=""
	if (FirstNorm'="")
	{
		s result=##class(web.CDSS.DiagDecision.IllnessGrade).EmerStandInfo(FirstNorm)
	}
	return result
}

/// w ##class(web.CDSS.Public.PatientModelInterface).SaveMasterData()
ClassMethod SaveMasterData()
{
	ts
	
	s obj=##class(WDT.CDSS.PatientMaster).%New()
	s obj.IDNO="ID0000000011"
	s obj.PatientDR="yy00011"
	s obj.MedicareCardNum="Card000000011"
	s obj.IDCardNumber="IDCard00011"
	s obj.Name="张三"
	s obj.Sex="男"
	s obj.Age="12"
	s obj.Profession="颈椎病"
	s obj.Nation="汉"
	s obj.Marriage="已婚"
	s obj.BloodGroup="A"
	s obj.Country="中国"
	s obj.Birthplace="北京市"
	s obj.CurrentAddress="北京市"
	s obj.PhoneNumber="89238927329"
	
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		tc
	}
	else
	{
		w $System.OBJ.DisplayError(sc)
		tro
	}
	q ""
}

/// w ##class(web.CDSS.Public.PatientModelInterface).SaveSignData()
ClassMethod SaveSignData()
{
	ts
	
	s obj=##class(WDT.CDSS.SignInfo).%OpenId(2)
	s obj.MeasureDate="2020-04-22 09:30:00"
	
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		tc
	}
	else
	{
		w $System.OBJ.DisplayError(sc)
		tro
	}
	q ""
}

/// Creator:丁亚男
/// CreatDate:2022-11-03
/// Description:生成患者信息表的索引
/// Table: 
/// Input: 
/// Return:
/// others:w ##class(web.CDSS.Public.PatientModelInterface).BuildPatientIndices()
ClassMethod BuildPatientIndices()
{
	
	d ##class(WDT.CDSS.PatientVisit).%BuildIndices()
	d ##class(WDT.CDSS.SignInfo).%BuildIndices()
	d ##class(WDT.CDSS.ChiefCompInfo).%BuildIndices()
	d ##class(WDT.CDSS.CurrentMedHistory).%BuildIndices()
	d ##class(WDT.CDSS.PastDiagnosis).%BuildIndices()
	
	d ##class(WDT.CDSS.PhysicalExam).%BuildIndices()
	d ##class(WDT.CDSS.SpecExam).%BuildIndices()
	d ##class(WDT.CDSS.DiagnosisInfo).%BuildIndices()
	d ##class(WDT.CDSS.DrugInfo).%BuildIndices()
	d ##class(WDT.CDSS.ExamInfo).%BuildIndices()
	
	d ##class(WDT.CDSS.LabExamInfo).%BuildIndices()
	d ##class(WDT.CDSS.LabInfo).%BuildIndices()
	d ##class(WDT.CDSS.OperationInfo).%BuildIndices()
	d ##class(WDT.CDSS.AnestInfo).%BuildIndices()
	d ##class(WDT.CDSS.NursingInfo).%BuildIndices()
	
	d ##class(WDT.CDSS.BloodTransInfo).%BuildIndices()
	d ##class(WDT.CDSS.OtherOrderInfo).%BuildIndices()
	d ##class(WDT.CDSS.InpatientInfo).%BuildIndices()
	d ##class(WDT.CDSS.DietInfo).%BuildIndices()
	d ##class(WDT.CDSS.PatientRatingScale).%BuildIndices()
	d ##class(WDT.CDSS.NursResultInfo).%BuildIndices()
	
	q "OK"
}

}

/// 公共方法，取数据用
/// 2019-06-21
/// zhouxin
Class web.DHCCKBCommon Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取知识类型id(ModelFlag:(实体)|AttrFlag:(实体属性)|DictionFlag:(字典))
/// w ##class(web.DHCCKBCommon).GetKnowType()
ClassMethod GetKnowType() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("KnowType")
}

/// Descript:知识类型->实体
/// w ##class(web.DHCCKBCommon).GetModelFlag()
ClassMethod GetModelFlag() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ModelFlag")
}

/// Descript:知识类型->实体属性
/// w ##class(web.DHCCKBCommon).GetAttrFlag()
ClassMethod GetAttrFlag() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("AttrFlag")
}

/// Descript:知识类型->字典
/// w ##class(web.DHCCKBCommon).GetDictionFlag()
ClassMethod GetDictionFlag() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DictionFlag")
}

/// Descript:通过知识类型标识(获取所有属性)<实体下的属性>
/// w ##class(web.DHCCKBCommon).GetLinkProp()
ClassMethod GetLinkProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LinkProp")
}

/// Descript通过代码获取属性id
/// w ##class(web.DHCCKBCommon).GetProp()
ClassMethod GetProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Prop")
}

/// Descript通过代码获取药品字典id
/// w ##class(web.DHCCKBCommon).GetDrugData()
ClassMethod GetDrugData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugData")
}

/// Creator: 	kemaolin
/// CreatDate： 2020-04-22
/// Descript通过代码获取药品字典id(中成药)
/// w ##class(web.DHCCKBCommon).GetChineseDrugData()
ClassMethod GetChineseDrugData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugData")
}

/// Creator: 	kemaolin
/// CreatDate： 2020-04-22
/// Descript通过代码获取药品字典id(中药饮片)
/// w ##class(web.DHCCKBCommon).GetChineseHMData()
ClassMethod GetChineseHMData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseHerbalMedicineData")
}

/// Descript:药品目录
/// w ##class(web.DHCCKBCommon).GetDrugLibary()
ClassMethod GetDrugLibary() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugLibary")
}

/// Descript:药品目录字典
/// w ##class(web.DHCCKBCommon).GetDrugLibaryData()
ClassMethod GetDrugLibaryData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugLibaryData")
}

/// Descript:
/// w ##class(web.DHCCKBCommon).GetDrug()
ClassMethod GetDrug() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Drug")
}

/// Descript:
/// w ##class(web.DHCCKBCommon).GetLinkRuleDir()
ClassMethod GetLinkRuleDir() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LinkRuleDir")
}

/// Descript: 药学分类字典
/// w ##class(web.DHCCKBCommon).GetDrugCategoryData()
ClassMethod GetDrugCategoryData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategoryData")
}

/// Descript:
/// w ##class(web.DHCCKBCommon).GetAddRuleFlag()
ClassMethod GetAddRuleFlag() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("AddRuleFlag")
}

/// Descript:
/// w ##class(web.DHCCKBCommon).GetDataSource()
ClassMethod GetDataSource() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DataSource")
}

/// Descript:单位字典
/// w ##class(web.DHCCKBCommon).GetUnitData()
ClassMethod GetUnitData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("UnitData")
}

/// Descript:通过实体代码获取id
/// w ##class(web.DHCCKBCommon).GetDicIdByCode("Drug","")
ClassMethod GetDicIdByCode(code, parref = "") As %String
{
	n (code,parref)
	s code=$SYSTEM.Util.Collation(code,6)
	q:code="" ""
	s ret=0
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(code),id))	q:id=""  d
	.s tmpparref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),4)
	.q:(parref'="")&(parref'=tmpparref)
	.s ret=id

	q ret
	//s typeId=+$o(^CT.CKB.PDSS.CommonDictionI("Code",code,""))
	//q typeId
}

/// Descript:通过实体描述获取id
/// w ##class(web.DHCCKBCommon).GetDicIdByDesc()
ClassMethod GetDicIdByDesc(desc, parref = "") As %String
{
	n (desc,parref)
		
	s desc=$SYSTEM.Util.Collation(desc,6)
	q:desc="" ""

	s ret=0
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc),id))	q:id=""  d
	.s tmpparref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),4)
	.q:(parref'="")&(parref'=tmpparref)
	.s ret=id

	q ret	
	//s typeId=+$o(^CT.CKB.PDSS.CommonDictionI("Desc",desc,""))
	//q typeId
}

/// Descript:通过实体代码获取描述
/// w ##class(web.DHCCKBCommon).GetDicDescByCode()
ClassMethod GetDicDescByCode(code) As %String
{
		n (code)
		
		q:code="" ""
		s code=$SYSTEM.Util.Collation(code,6)
		s typeId=+$o(^CT.CKB.PDSS.CommonDictionI("Code",code,""))
		
		q:typeId=0 ""
		
		q $lg($g(^CT.CKB.PDSS.CommonDictionD(+typeId)),3)
}

/// Descript:  单位转化系数
/// w ##class(web.DHCCKBCommon).GetFacProp()
ClassMethod GetFacProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FactorProp")
}

/// Descript:  药学分类属性
/// w ##class(web.DHCCKBCommon).GetPhCategory()
ClassMethod GetPhCategory() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugCategory")
}

/// Descript:  数据类型
/// w ##class(web.DHCCKBCommon).GetDataType()
ClassMethod GetDataType() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DataTypeProp")
}

/// Descript:药品属性
/// w ##class(web.DHCCKBCommon).GetDrugProp()
ClassMethod GetDrugProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugProp")
}

/// Descript:药品的成分属性id
/// w ##class(web.DHCCKBCommon).GetDrugIngredient()
ClassMethod GetDrugIngredient() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"Ingredient")
}

/// Descript:药品的禁忌症属性id
ClassMethod GetDrugContr() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"Contr")
}

/// kml 2020-05-06 (test)
/// Descript:药品的禁忌症属性id
ClassMethod GetDrugContrNew() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	s RuleContr=##class(web.DHCCKBCommon).GetDicIdByCode("RuleContr")
	q RuleContr
	q:(+DrugProp=0)||(+RuleContr=0) ""
	s DrugContr=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",RuleContr,DrugProp,""))
	q DrugContr
}

/// kml 2020-05-06 (test)
/// Descript:药品的适应症属性id
/// w ##class(web.DHCCKBCommon).GetDrugIndicNew()
ClassMethod GetDrugIndicNew() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	s RuleIndic=##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic")
	q RuleIndic
	q:(+DrugProp=0)||(+RuleIndic=0) ""
	s DrugIndic=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",RuleIndic,DrugProp,""))
	q DrugIndic
}

/// Descript:药品的适应症属性id
ClassMethod GetDrugIndic() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"Indic")
}

/// Descript:药品的通用名属性id
/// w ##class(web.DHCCKBCommon).GetDrugGenerName()
ClassMethod GetDrugGenerName() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"GenerNameProp")
}

/// Descript:药品的规格属性id
///  w ##class(web.DHCCKBCommon).GetDrugSpec()
ClassMethod GetDrugSpec() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"DrugSpec")
}

/// Descript:药品的剂型属性id
/// w ##class(web.DHCCKBCommon).GetDrugForm()
ClassMethod GetDrugForm() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"FormProp")
}

/// Descript:药品的生产企业性id
/// w ##class(web.DHCCKBCommon).GetDrugManf()
ClassMethod GetDrugManf() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	q ##class(web.DHCCKBCommon).GetProByEntity(DrugProp,"ManufacturerProp")
}

/// Descript:生产企业id 
ClassMethod GetManufacturerData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ManufacturerData")
}

/// Descript:成分字典表id 
/// w ##class(web.DHCCKBCommon).GetIngreData()
ClassMethod GetIngreData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientData")
}

/// Descript:环境字典表id 
ClassMethod GetEnvironReasonData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EnvironReasonData")
}

/// Descript:成分属性id 
ClassMethod GetIngreProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Ingredient")
}

/// Descript:辅料字典表id 
ClassMethod GetExcipientData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ExcipientData")
}

/// Descript:辅料属性id 
ClassMethod GetExcipientProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ExcipientProp")
}

/// Descript:剂型字典表id 
/// w ##class(web.DHCCKBCommon).GetFormData()
ClassMethod GetFormData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FormData")
}

/// Descript:剂型属性id 
ClassMethod GetFormProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FormProp")
}

/// Descript:前提条件属性id 
/// w ##class(web.DHCCKBCommon).GetPrioCondProp()
ClassMethod GetPrioCondProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("prioCondProp")
}

/// Descript:是否可用
ClassMethod GetAvailable() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Available")
}

/// Descript:前提条件
ClassMethod GetPreconditions() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Preconditions")
}

/// Descript:项目列表属性
/// w ##class(web.DHCCKBCommon).GetCheckItmListProp()
ClassMethod GetCheckItmListProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("CheckItmListProp")
}

/// Descript:是否需要维护属性值
ClassMethod GetIsAddValueProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IsAddValueProp")
}

/// Descript:药品商品名字典
ClassMethod GetDrugProNameData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugProNameData")
}

/// Descript:检验指标字典
ClassMethod GetLabItmData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LabItmData")
}

/// Descript:细菌字典
ClassMethod GetBacteriaData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("BacteriaData")
}

/// Descript:菌属字典
ClassMethod GetBacteriaCatData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("BacteriaCatData")
}

/// Descript:疾病字典(诊断)
ClassMethod GetDiseaseData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DiseaseData")
}

/// Descript:症状字典
ClassMethod GetSymptomData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SymptomData")
}

/// Descript:特殊人群
ClassMethod GetSpecPopData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SpecialPopData")
}

/// Descript:性别字典
ClassMethod GetSexData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SexData")
}

/// Descript:职业字典
ClassMethod GetProfessData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ProfessData")
}

/// Descript:给药途径
/// w ##class(web.DHCCKBCommon).GetDrugPreMetData()
ClassMethod GetDrugPreMetData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugPreMetData")
}

/// Descript:首次用药字典
ClassMethod GetFirstUseData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FirstUseData")
}

/// Descript:检验实体id
ClassMethod GetLab() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Lab")
}

/// Descript:检验指标实体id
ClassMethod GetLabItm() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LabItm")
}

/// Descript:检验指标->范围值属性id
ClassMethod GetLabItmValueLimitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LabItmValueLimitProp")
}

/// Descript:细菌实体id
ClassMethod GetBacteria() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Bacteria")
}

/// Descript:菌属实体id
ClassMethod GetBacteriaCat() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("BacteriaCat")
}

/// Descript:疾病实体
ClassMethod GetDisease() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Disease")
}

/// Descript:症状实体id
ClassMethod GetSymptom() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Symptom")
}

/// Descript:患者实体id
ClassMethod GetPatient() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Patient")
}

/// Descript:患者-特殊人群属性id
ClassMethod GetSpecialPopProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SpecialPop")
}

/// Descript:患者-年龄属性id
ClassMethod GetAgeProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("AgeProp")
}

/// Descript:患者-体重属性id
ClassMethod GetWeightProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Weight")
}

/// Descript:患者-性别属性id
ClassMethod GetSexProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SexProp")
}

/// Descript:患者-性别属性id
ClassMethod GetProfessProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ProfessProp")
}

/// Descript:药品-给药途径属性id
ClassMethod GetDrugPreMet() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugPreMet")
}

/// Descript:药品-溶媒属性id
ClassMethod GetSolventProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SolventProp")
}

/// Descript:药品-溶液属性id
ClassMethod GetSolutionProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionProp")
}

/// Descript:药品-溶媒浓度属性id
ClassMethod GetSolventDensityProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SolventDensity")
}

/// Descript:药品-溶液浓度属性id
ClassMethod GetSolutionDensityProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionDensity")
}

/// Descript:药品-溶煤体积属性id
ClassMethod GetSolventvolumeProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Solventvolume")
}

/// Descript:药品-溶液体积属性id
ClassMethod GetSolutionVolumeProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SolutionVolume")
}

/// Descript:药品-商品名属性id
ClassMethod GetProNameProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ProNameProp")
}

/// Descript:药品-是否首次id
ClassMethod GetIsFirstUseProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IsFirstUseProp")
}

/// Descript:药品-单次剂量属性id
/// w ##class(web.DHCCKBCommon).GetOnceDoseProp()
ClassMethod GetOnceDoseProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OnceDose")
}

/// Descript:药品-每日剂量属性id
/// w ##class(web.DHCCKBCommon).GetDayDoseProp()
ClassMethod GetDayDoseProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DayDose")
}

/// Descript:药品-给药时间属性id
ClassMethod GetDrugUseTimeProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugUseTime")
}

/// Descript:药品-给药速度属性id
ClassMethod GetDurgSpeedProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DurgSpeedProp")
}

/// Descript:用药频率字典id
ClassMethod GetDrugFreqData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugFreqData")
}

/// Descript:用药频率属性id
ClassMethod GetDrugFreqProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugFreq")
}

/// Descript:药品->单次最大量属性id
ClassMethod GetOnceDoseMaxProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OnceDoseMax")
}

/// Descript:药品->每日最大量属性id
ClassMethod GetDayDoseMaxProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DayDoseMax")
}

/// Descript:药品->单次极量属性id
ClassMethod GetOnceDoseLimitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OnceDoseLimit")
}

/// Descript:药品->每日极量属性id
ClassMethod GetDayDoseLimitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DayDoseLimit")
}

/// Descript:药品->疗程属性id
ClassMethod GetTreatmentProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Treatment")
}

/// Descript:药品->疗程间间隔时长属性id
ClassMethod GetTreatBettenDayProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TreatBettenDayNum")
}

/// Descript:药品->疗程内间隔时长属性id
ClassMethod GetTreatDayNumProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TreatDayNum")
}

/// Descript:药品->连续用药时长属性id
ClassMethod GetcarryUseDrugTimeProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("carryUseDrugTime")
}

/// Descript:药品->英文名称属性id
ClassMethod GetEngNameProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EngName")
}

/// Descript:药品->药品的合用类别属性id
ClassMethod GetTogetherProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TogetherProp")
}

/// Descript:药品->药品的用药时机属性id
ClassMethod GetMedicalTimeProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("MedicalTimeProp")
}

/// Descript:药品->药品的用药时机属性id
ClassMethod GetTipsAtOnceProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TipsAtOnceProp")
}

/// Descript:药品输出实体id
/// w ##class(web.DHCCKBCommon).GetDrugPrint()
ClassMethod GetDrugPrint() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DrugPrint")
}

/// Descript:药品输出->通过标记属性id
ClassMethod GetPassFlagProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("PassFlag")
}

/// Descript:药品输出->管理级别属性id
ClassMethod GetLevelFlagProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag")
}

/// Descript:药品输出->提示信息属性id
ClassMethod GetWarnMessageProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("WarnMessage")
}

/// Descript:药品输出->提示依据属性id
ClassMethod GetSourceMsgProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SourceMsg")
}

/// Descript:药品输出->管制力度(警戒类型)属性id
ClassMethod GetControlLevelProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ControlLevel")
}

/// Descript:药品输出->消息提醒标记id  sufan 2020-04-22
ClassMethod GetControlOutMsgTips() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OutMsgTipsFlag")
}

/// Descript:患者属性->过敏史属性id
ClassMethod GetHisAllergyProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("HisAllergy")
}

/// Descript:目录
ClassMethod GetDirTemp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DirTemp")
}

/// Descript:合用类别字典
ClassMethod GetTogetherData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TogetherData")
}

/// Descript:用药时机字典
ClassMethod GetMedicalTimeData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("MedicalTimeData")
}

/// Descript:获取对象的属性的id
ClassMethod GetProByEntity(entity, code) As %String
{
	n (entity,code)
	s ret=""
	s id="" f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",entity,id)) q:(id="")||(ret'="")  d
	.s:code=$lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),2) ret=id
	q ret
}

/// Descript:成分属性模板
/// w ##class(web.DHCCKBCommon).GetIngredientPropTemp()
ClassMethod GetIngredientPropTemp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientPropTemp")
}

/// Descript:成分代码
/// w ##class(web.DHCCKBCommon).GetIngredientCode()
ClassMethod GetIngredientCode() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientCode")
}

/// Descript:成分剂量
/// w ##class(web.DHCCKBCommon).GetIngredientMete()
ClassMethod GetIngredientMete() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientMete")
}

/// Descript:成分单位
/// w ##class(web.DHCCKBCommon).GetIngredientUnit()
ClassMethod GetIngredientUnit() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IngredientUnit")
}

/// Descript:单位转换系数
ClassMethod GetUnitChangeFacProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("UnitChangeProp")
}

/// Descript:到单位
ClassMethod GetToUomProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ToUom")
}

/// Descript:系数
ClassMethod GetFactorProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Factor")
}

/// Descript:到单位
ClassMethod GetToUnitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ToUnit")
}

/// Descript:系数
ClassMethod GetFactorUnitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FactorUnit")
}

/// Descript:全局规则字典
ClassMethod GetGlobalData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("GlobalData")
}

/// Descript:判断该字典是否是实体类
/// w ##class(web.DHCCKBCommon).CheckIsModel()
/// Return: 0(不是实体类)|其他(是实体类)
ClassMethod CheckIsModel(id) As %String
{
	n (id)
	s GetKnowType=##class(web.DHCCKBCommon).GetKnowType() //知识类型
	s ModelFlag=##class(web.DHCCKBCommon).GetModelFlag()  //知识类型是实体
	s flag=0
	s linkId="" f  s linkId=$o(^CT.CKB.PDSS.DicLinkAttrI("IndexLinkAttrCodeForDic",GetKnowType,id,linkId)) q:(linkId="")||(flag'=0)  d
	.s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkId)),4)
	.s:ModelFlag=attrDr flag=1
	q flag
}

/// / Descript:管理级别代码转数字
/// w ##class(web.DHCCKBCommon).GetManLevelNum()
/// Return: 级别对应的数字
ClassMethod GetManLevelNum(code) As %String
{
	n (code)
	
	q $case(code,"normal":0,"tips":1,"warn":2,"forbid":3,:1)	// 没有级别时，默认为tips
}

/// / Descript:管理级别数字转代码
/// w ##class(web.DHCCKBCommon).GetManLevelCodeByNum()
/// Return: 级别对应的数字
ClassMethod GetManLevelCodeByNum(num) As %String
{
	n (num)
	
	q $case(num,0:"normal",1:"tips",2:"warn",3:"forbid",-1:"notlevel",:"tips")	// 没有级别时，默认为tips
}

/// 实体是否有业务规则
/// w ##class(web.DHCCKBCommon).IsExistRule()
ClassMethod IsExistRule(dicID)
{
	n (dicID)
	
	q:+dicID=0 0
	
	q $case($d(^CT.CKB.PDSS.RuleDicI("Dic",dicID))>0,1:1,:0)
}

/// 是否有全局规则
/// w ##class(web.DHCCKBCommon).IsExistGlobalRule()
ClassMethod IsExistGlobalRule()
{
	s globalDataID=##class(web.DHCCKBCommon).GetGlobalData()
	q $case($d(^CT.CKB.PDSS.RuleDicI("ParentDic",globalDataID))>0,1:1,:0)
}

/// Descript:是否需要存字典
/// w ##class(web.DHCCKBCommon).GetIsSaveDic()
ClassMethod GetIsSaveDic() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IsSaveDic")
}

/// Descript:别名字典
/// w ##class(web.DHCCKBCommon).GetOtherName()
ClassMethod GetOtherName() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OtherNameData")
}

/// Descript:模板关联  附加属性里
/// w ##class(web.DHCCKBCommon).GetTempLinkId()
ClassMethod GetTempLinkId()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TempLink")
}

/// Descript:疾病ICD诊断对照->属性ID
/// w ##class(web.DHCCKBCommon).GetIcdAttrCodeId()
ClassMethod GetIcdAttrCodeId()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IcdCompare")
}

/// Descript:计算方向
/// w ##class(web.DHCCKBCommon).GetCalcPath()
ClassMethod GetCalcPath()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("CalcPathProp")
}

/// Descript:获取别名属性
/// w ##class(web.DHCCKBCommon).GetOtherNameProp()
ClassMethod GetOtherNameProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OtherNameProp")
}

/// Descript:获取用药频率的转换因子
/// w ##class(web.DHCCKBCommon).GetFreqFactorUnitProp()
ClassMethod GetFreqFactorProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FreqFactorProp")
}

/// Descript:获取用药频率的转换单位
/// w ##class(web.DHCCKBCommon).GetFreqFactorUnitProp()
ClassMethod GetFreqFactorUnitProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FreqFactorUnitProp")
}

/// Descript:获取字典的别名
/// w ##class(web.DHCCKBCommon).GetDicSecondName(16403)
ClassMethod GetDicSecondName(dicID)
{
	n (dicID)
	//s otherNameProp=..GetOtherNameProp()
	//q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,otherNameProp)) ""
 	s otherNameProp=..GetDicOtherNameProp(dicID)
 	q:otherNameProp="" ""
	s secondName=""
	s linkID=""
	f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,otherNameProp,linkID))  q:linkID=""  d
	.s value=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)
	.q:(value="")||('$D(^CT.CKB.PDSS.CommonDictionD(value)))
	.s value=$lg($g(^CT.CKB.PDSS.CommonDictionD(+value)),3)
	.//s len=$LISTLENGTH(secondName)
	.i $e(value,*)=1 s value=$e(value,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	.s $list(secondName,*+1)=value
	
	q secondName
}

/// Descript:获取字典的别名属性。因为别名是公共属性，不能直接取属性
/// Author:		qunianpeng 
/// Date:				2020-08-31
/// w ##class(web.DHCCKBCommon).GetDicOtherNameProp(16403)
ClassMethod GetDicOtherNameProp(dicID)
{
	n (dicID)
	q:+dicID=0 ""
	q:'$d(^CT.CKB.PDSS.CommonDictionD(dicID)) ""		 //sufan 2020-09-13 
	s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),4)
	q:parref="" ""
	s linkProp=..GetLinkProp()
	q:linkProp="" ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parref,linkProp)) ""
	s dicAttrDr=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",parref,linkProp,""))
	q:dicAttrDr="" ""
	s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(dicAttrDr)),4)
	q:attrDr="" ""

	s realOtherNameID=""
	s otherNameID=""
	f  s otherNameID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",attrDr,otherNameID))  q:otherNameID=""  d
	.s linkID=$lg($g(^CT.CKB.PDSS.CommonDictionD(+otherNameID)),5)
	.q:(linkID'="")&(linkID'=..GetOtherNameProp())
	.q:(linkID="")&(otherNameID'=..GetOtherNameProp())
	.s realOtherNameID=otherNameID
	
	q realOtherNameID
}

/// Descript:属性别名
/// w ##class(web.DHCCKBCommon).GetOtherNameId()
ClassMethod GetOtherNameId()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OtherNameProp")
}

/// 导出规则中数据所有字典和引用字典不匹配的数据
Query ExportReplatRuleDic() As websys.Query(ROWSPEC = "f1:%String:字典数据,f2:%String:规则指向,f3:%String:实际指向")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCCKBCommon","ExportReplatRuleDic") 
/// @param: pid 进程号
ClassMethod ExportReplatRuleDicExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	
	Set repid=$I(^CacheTemp)	
	Set ind=1
	
	s pid=##class(web.DHCCKBCommonUtil).NewPid()
	d ..GetRuleDic(pid)
	
	set index=""	
	for  set index=$order(^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,index)) quit:index=""  do
	.set rowData=$get(^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,index))
	.q:rowData=""
	.set ^CacheTemp(repid,ind)=$listfromstring(rowData,"^")
	.set ind=ind+1	
	
	Set qHandle=$lb(0,repid,0)
	k ^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid)
	Quit $$$OK
}

/// 遍历所有的规则,找出规则中的字典和属性字典不一致的数据
ClassMethod GetRuleDic(pid)
{
	n (pid)
	s sourceProp=##class(web.DHCCKBCommon).GetDataSource()	
	s hisArrergy=..GetHisAllergyProp()
	s unitData=..GetUnitData()
	//s pid=##class(web.DHCCKBCommonUtil).NewPid()
	s ruleDataID="",h=0
	f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataD(ruleDataID))	q:ruleDataID=""  d
	.q:+ruleDataID=0
	.q:'$d(^CT.CKB.PDSS.RuleDataD(ruleDataID))
	.s leftValue=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),4)
	.s leftDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),5)
	.s left=$case(leftValue'="",1:leftValue,:leftDic)
	.q:left=""
	.q:left=hisArrergy
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",left,sourceProp))
	.s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",left,sourceProp,""),-1)
	.s source=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)	// 应该在的字典
	.
	.s rightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),10)
	.i rightType="Constant" d
	..s rightDic=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),8)
	..q:rightDic=""
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(rightDic))
	..s dicParref=..GetParref(rightDic)		// 现在在的字典
	..q:source=dicParref
	..s h=h+1
	..s linkattr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+rightDic)),5)
	..s:linkattr'="" rightDic=linkattr
	..s rightDicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+rightDic)),3)
	..s sourceDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+source)),3)
	..s dicParrefDesc=$case(dicParref'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicParref)),3),:"")
	..//s ^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic","repleat",pid,rightDic)=""
	..q:$d(^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,rightDic))
	..s ^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,rightDic)=rightDicDesc_"^"_sourceDesc_"^"_dicParrefDesc
	..//s ^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,h)=rightDic_"^"_source_"^"_dicParref	// 
	.
	.i (rightType="InputUom")||(rightType="InputLimit")  d
	..s rightExt=$lg($g(^CT.CKB.PDSS.RuleDataD(ruleDataID)),11)
	..q:rightExt=""
	..q:'$d(^CT.CKB.PDSS.CommonDictionD(rightExt))
	..s dicParref=..GetParref(rightExt)
	..q:dicParref=unitData
	..s h=h+1
	..s linkattr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+rightExt)),5)
	..s:linkattr'="" rightExt=linkattr
	..s rightExtDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+rightExt)),3)
	..s sourceDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+source)),3)
	..s dicParrefDesc=$case(dicParref'="",1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicParref)),3),:"")
	..q:$d(^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,rightExt))
	..s ^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,rightExt)=rightExtDesc_"^"_sourceDesc_"^"_dicParrefDesc
	..//s ^TMP("DHCCKB","web.DHCCKBCommon","GetRuleDic",pid,h)=rightExt_"^"_source_"^"_dicParref
	.
}

/// w #class(web.DHCCKBCommon).GetParref(11537)
ClassMethod GetParref(dicID)
{
	n (dicID)
	
	s parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),4)
	s parrefDic=""
	if parref'="" s parrefDic=$lg($g(^CT.CKB.PDSS.CommonDictionD(+parref)),4)
	q:parrefDic="" parref
	
	q ..GetParref(parref)
}

/// Descript:根据dicID、安全组、安全组ID过滤停用数据
/// Debug: 0 未停用  1 停用
/// w ##class(web.DHCCKBCommon).GetStopDicData("75282","2","290","1",11874)
ClassMethod GetStopDicData(dicID, hospID, groupID, locID, userID)
{
	//全院DHC>安全组G>科室L>人员U
	n (dicID, hospID, groupID, locID, userID)
	q:+dicID=0 0
	s stopflag=0  //停用标志
	s:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+dicID,"stop")) stopflag=1
	q stopflag
}

/// Descript:根据dicID、过滤存在授权表数据
/// Debug: 0 未停用  1 停用
/// w ##class(web.DHCCKBCommon).GetStopDicData(4300,2,1,1,1)
ClassMethod GetStopDicDataBydataID(dataID)
{
	//全院DHC>安全组G>科室L>人员U
	s stopflag=0  //停用标志
	s:$d(^CKB.PDSS.DicLogI("DLGDataDr",dataID)) stopflag=1
	q stopflag
}

/// Descript:根据dicID、功能过滤授权表数据
/// Debug: 0 未停用  1 停用
/// w ##class(web.DHCCKBCommon).GetStopDicData(4300,2,1,1,1)
ClassMethod GetStopDicDataByfunction(dataID, function)
{
	s stopflag=0  //停用标志
	s:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",+dicID,function)) stopflag=1
	q stopflag
}

/// Descript:根据dicID、安全组、安全组ID过滤核实数据
/// Debug: 0 未核实  1 核实
/// w ##class(web.DHCCKBCommon).GetAcceptDicData(49871,2,290,10,10)
ClassMethod GetAcceptDicData(dicID, hospID, groupID, locID, userID)
{
	s acceptflag=0  //核实标志
	s:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm")) acceptflag=1    //shy 2021-5-19
	;s:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm")) acceptflag=1
	;s:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm")) acceptflag=1
	;s:$d(^CKB.PDSS.DicLogI("Function","DHC_CKBCommonDiction",dicID,"confirm")) acceptflag=1
	q acceptflag
}

/// Description:	判断字典维护界面是否核实、未核实、取消核实
/// Creator:		wangxuejian
/// CreateDate:		2021-05-19	
/// Input:			CD_RowID 
/// return:			0 未核实  1 核实 2取消核实
/// other:			w ##class(web.DHCCKBCommon).GetConfirmFlag("")
ClassMethod GetConfirmFlag(dicID)
{
	n (dicID)
	q:+dicID=0 0
	s confirmflag=0  //核实标志
	s glgID=""
	f  s glgID=$o(^CKB.PDSS.DicLogI("DLGDataDr",dicID,glgID),-1)  q:(glgID="")||(confirmflag'=0)  d
	.s glgFunction=$lg(^CKB.PDSS.DicLogD(glgID),4)  //功能
	.s:glgFunction="unconfirm" confirmflag=2
	.s:glgFunction="confirm" confirmflag=1
	q confirmflag
}

/// 获取规则分支中的限定内容
/// w ##class(web.DHCCKBCommon).GetRuleLimitContent(1)
ClassMethod GetRuleLimitContent(ID)
{
	n (ID)
	q:(+ID=0)||'$d(^CT.CKB.PDSS.RuleDataD(ID)) ""
	
	s OpArith=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),7)
	s OpArith=$select(OpArith="Equals":"",OpArith="GreaterThen":">",OpArith="LessThen":"<",OpArith="LessThenEquals":"<=",OpArith="GreaterThenEquals":">=",OpArith="Between":"",OpArith="NotEquals":"不等于",1:"")
	s RightType=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),10)	
	s RetStr=""
	if RightType="Constant"		d 	// 数据集	 
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),8)
	.s RetStr=$case(+Value'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+Value)),3),:"")
	else  if RightType="Input"	d 	// 输入值	
	.s RetStr=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	else  if RightType="InputUom" d // 带单位的输入值    
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	.s:Value'="" Value = $fn(Value,"N")
	.s ValueUom=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)
	.s:ValueUom'="" ValueUom=$case(+ValueUom'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ValueUom)),3),:"")
	.s RetStr=Value_ValueUom
	else  if RightType="InputLimit"	d // 区间,带单位
	.s Value=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),9)
	.s:Value'="" Value = $fn(Value,"N")
	.s ValueMax=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),12)
	.s:ValueMax'="" ValueMax = $fn(ValueMax,"N")
	.s ValueUom=$lg($g(^CT.CKB.PDSS.RuleDataD(ID)),11)
	.s:ValueUom'="" ValueUom=$case(+ValueUom'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(ValueUom)),3),:"")
	.s RetStr=Value_"~"_ValueMax_ValueUom

	s:RetStr'="" RetStr=OpArith_RetStr

	q RetStr
}

/// Descript:	获取药学分类
/// w ##Class(web.DHCCKBCommon).GetPhCat("65")
/// flag 1 取id,flag 0 去描述
///  w ##class(web.DHCCKBCommon).GetPhCatAlone(50018,1)
ClassMethod GetPhCatAlone(DicID As %String, flag = 1) As %String
{
	n (DicID,flag)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类
	q:+PhCatID=0 ""
	
	s ExistFlag = 0,MarkPhCatID=""
	i '$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PhCatID)) d
	.q:'$d(^CT.CKB.PDSS.CommonDictionI("Link",PhCatID)) 
	.s LinkDr = ""
	.f  s LinkDr = $o(^CT.CKB.PDSS.CommonDictionI("Link",PhCatID,LinkDr)) q:(LinkDr="")||(ExistFlag=1)  d
	..q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,LinkDr))
	..s MarkPhCatID = LinkDr
	..s ExistFlag=1
	
	i ExistFlag=1 s PhCatID=MarkPhCatID
	
	q:+PhCatID=0 ""
	// 获取药品的分类
	k ListCat
	s ListCat=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PhCatID,LinkID))  q:LinkID=""  d
	.s ItmCatID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:+ItmCatID=0
	.if flag=1 d
	..s $LIST(ListCat,*+1)=ItmCatID
	.else  d
	..s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),5)
	..i linkDr="" d
	...s tmpdesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),3)
	...i $e(tmpdesc,*)=1 s tmpdesc=$e(tmpdesc,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	...s $LIST(ListCat,*+1)=tmpdesc
 	..e  d 
 	...d ..GetPhCatAloneLink(.ListCat,linkDr,flag)
	
	Q ListCat
}

ClassMethod GetPhCatAloneLink(ListCat, ItmCatID, flag)
{
	n (ListCat,ItmCatID,flag)
	s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),5)
	i linkDr="" d
	.s tmpdesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),3)
	.i $e(tmpdesc,*)=1 s tmpdesc=$e(tmpdesc,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	.s $LIST(ListCat,*+1)=tmpdesc
	e  d
	.d ..GetPhCatAloneLink(.ListCat,linkDr,flag)
}

/// Descript:	获取药学分类
/// w ##Class(web.DHCCKBCommon).GetPhCat("65")
/// flag 1 取id,flag 0 去描述
ClassMethod GetPhCat(DicID As %String, flag = 1) As %String
{
	n (DicID,flag)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类
	q:DicID="" ""
	// 获取药品的分类
	k ListCat
	s ListCat=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PhCatID,LinkID))  q:LinkID=""  d
	.s ItmCatID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.//d ..GetParentCat(.ListCat,ItmCatID,flag)						/// 获取分类的所有父分类
	.d ..GetChildCat(.ListCat,ItmCatID,flag)	/// 获取分类的所有子分类
	.d ..GetLinkCat(.ListCat,ItmCatID,flag)		/// 获取link的所有分类以及子分类
	
	Q ListCat
}

/// 获取分类的子层分类
/// w ##Class(web.DHCCKBCommon).GetChildCat(ListCat,"99516",0)
/// flag 1 取id,flag 0 取描述
ClassMethod GetChildCat(ListCat, ItmCatID, flag) As %String
{
	n (ListCat,ItmCatID,flag)
	s HasChildFlag=$d(^CT.CKB.PDSS.CommonDictionI("Parref",+ItmCatID))	
	q:ItmCatID="" ""
	if flag=1 d
	.q:##class(web.DHCCKBCommon).IsEnabled(ItmCatID)=0 // 停用
	.s ^TMPTEST("xwwss",ItmCatID)=""
	.i $lf(ListCat,ItmCatID)=0 s $LIST(ListCat,*+1)=ItmCatID
	else  d
	.s tmpdesc=""
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),5)
	.i (linkDr="")&(##class(web.DHCCKBCommon).IsEnabled(ItmCatID)=1) s tmpdesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),3)
	.i (linkDr'="") s tmpdesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+linkDr)),3)
	.i $e(tmpdesc,*)=1 s tmpdesc=$e(tmpdesc,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	.s:($g(tmpdesc)'="")&&($lf(ListCat,tmpdesc)=0) $LIST(ListCat,*+1)=tmpdesc
	.i (linkDr'="")&(linkDr'=ItmCatID)  d ..GetChildCat(.ListCat,linkDr,flag)

	q:HasChildFlag<=0 1
	s childCat=""
	f  s childCat=$o(^CT.CKB.PDSS.CommonDictionI("Parref",+ItmCatID,childCat))	q:childCat=""  d
	.q:ItmCatID=childCat
	.s dicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+childCat)),5)
	.q:dicLinkDr=childCat
	.s ^TMPTEST("xww",childCat)=ItmCatID_"^"_dicLinkDr
	.i dicLinkDr=""  d
	..d ..GetChildCat(.ListCat,childCat,flag)
	.e  d
	..i (flag=1)&&($lf(ListCat,childCat)=0) s $LIST(ListCat,*+1)=childCat
	..d ..GetChildCat(.ListCat,dicLinkDr,flag)
	
	q ""
}

/// 获取分类的link分类及子层分类
/// w ##Class(web.DHCCKBCommon).GetLinkCat(ListCat,"6023",0)
/// flag 1 取id,flag 0 取描述
ClassMethod GetLinkCat(ListCat, ItmCatID, Flag) As %String
{
	n (ListCat,ItmCatID,Flag)
	q:+ItmCatID<=0 1
	s LinkFlag=$d(^CT.CKB.PDSS.CommonDictionI("Link",+ItmCatID))	// 取子层分类时,需要把link下面的分类都取到
	
	q:LinkFlag<=0 1
	
	s LinkCat=""
	f  s LinkCat=$o(^CT.CKB.PDSS.CommonDictionI("Link",ItmCatID,LinkCat))	q:LinkCat=""  d
	.d ..GetChildCat(.ListCat,LinkCat,Flag)
		
	q 1
}

/// 获取分类的父分类
/// w ##Class(web.DHCCKBCommon).GetParentCat(ListCat,"638",1)
ClassMethod GetParentCat(ListCat, ItmCatID, flag) As %String
{
	n (ListCat,ItmCatID,flag)
	q:ItmCatID="" ""
	if flag=1 d
	.q:##class(web.DHCCKBCommon).IsEnabled(ItmCatID)=0 // 停用
	.q:$listfind(ListCat,ItmCatID)'=0
	.s $LIST(ListCat,*+1)=ItmCatID
	else  d
	.s tmpdesc=""
	.s linkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),5)
	.i (linkDr="")&(##class(web.DHCCKBCommon).IsEnabled(ItmCatID)=1) s tmpdesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),3)
	.i $e(tmpdesc,*)=1 s tmpdesc=$e(tmpdesc,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	.q:$listfind(ListCat,tmpdesc)'=0
	.s:$g(tmpdesc)'="" $LIST(ListCat,*+1)=tmpdesc
	.i linkDr'=""  d ..GetParentCat(.ListCat,linkDr,flag)
	
	s ParentCat=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),4)
	// 分类的父类不为空,且不是分类字典时,加入到分类列表
	i (ParentCat'="")&(ParentCat'=##class(web.DHCCKBCommon).GetDrugCategoryData())  d
	.d ..GetParentCat(.ListCat,ParentCat,flag)	
	
	q ""
}

/// Descript:	获取药学分类-关联关系维护的，不取分类的父子层
/// w ##Class(web.DHCCKBCommon).GetAlonePhCat("96073",0)
/// flag 1 取id,flag 0 去描述
ClassMethod GetAlonePhCat(DicID As %String, flag = 1) As %String
{
	n (DicID,flag)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类
	
	// 获取药品的分类
	k ListCat
	s ListCat=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PhCatID,LinkID))  q:LinkID=""  d
	.s ItmCatID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmCatID=""
	.i flag=1 s $List(ListCat,*+1)=ItmCatID
	.e  d
	..s dicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),5)
	..s desc=$case(+dicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+dicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmCatID)),3))
	..i $e(desc,*)=1 s desc=$e(desc,1,*-1)	// 2020/8/3 薛工在分类后面暂时加了一个1，需要忽略
	..s $List(ListCat,*+1)=desc

	Q ListCat
}

/// 获取药品的成分
/// w ##Class(web.DHCCKBCommon).GetIngredient("150")
/// flag:1 成分id  flag:0 成分描述
ClassMethod GetIngredient(DicID, flag = 1) As %String
{
	n (DicID,flag)
	//s IngrPropID=##class(web.DHCCKBCommon).GetDrugIngredient()   /// 药品成分属性
	
	// 获取药品的成分
	/*
	s ListIngr=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,IngrPropID,LinkID))  q:LinkID=""  d
	.s ItmIngrID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.i $LISTDATA(ListIngr) d
	..s Len=$LISTLENGTH(ListIngr)
	..s $List(ListIngr,Len+1)=ItmIngrID
	.s ListIngr=$lb(ItmIngrID)
	*/
	s IngrPropID=##class(web.DHCCKBCommon).GetIngredientCode()   /// 药品成分代码
	s ListIngr=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,IngrPropID,LinkID))  q:LinkID=""  d
	.s ItmIngrID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmIngrID=""
	.i flag=1 s $List(ListIngr,$LISTLENGTH(ListIngr)+1)=ItmIngrID
	.e  d
	..s dicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmIngrID)),5)
	..s desc=$case(+dicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmIngrID)),3))
	..s $List(ListIngr,$LISTLENGTH(ListIngr)+1)=desc
	
	Q ListIngr
}

/// 获取药品的辅料
/// w ##Class(web.DHCCKBCommon).GetExcipient("150")
/// flag:1 辅料id  flag:0 辅料描述
ClassMethod GetExcipient(DicID, flag = 1) As %String
{
	n (DicID,flag)
	s ExcipientPropID=##class(web.DHCCKBCommon).GetExcipientProp()   /// 药品辅料属性
	
	// 获取药品的辅料	
	s ListExci=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,ExcipientPropID,LinkID))  q:LinkID=""  d
	.s ItmExciID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.i flag=1 s $List(ListExci,$LISTLENGTH(ListExci)+1)=ItmExciID
	.e  d
	..s dicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmExciID)),5)
	..s desc=$case(+dicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmExciID)),3))
	..s $List(ListExci,$LISTLENGTH(ListExci)+1)=desc
	
	Q ListExci
}

/// Descript:	频次单位转化系数
/// w ##Class(web.DHCCKBCommon).GetFreqFac("3925","次/日")
ClassMethod GetFreqFac(DicID As %String, Unit) As %String
{
	n (DicID,Unit)
	Q:(+DicID=0)||(Unit="") ""
	s FreqFacUnit=##class(web.DHCCKBCommon).GetFreqFactorUnitProp()   /// 用药频次转换因子单位
	s FreqFac=##class(web.DHCCKBCommon).GetFreqFactorProp()		/// 用药频次转换因子
	s Fac=""
	s Group=""
	
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,FreqFacUnit,LinkID))  q:LinkID=""  d
	.s FreqUnit=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(FreqUnit)),5)
	.q:FreqUnit=""
	.s FreqUnitDesc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(FreqUnit)),3))
	.q:Unit'=FreqUnitDesc
	.s Group=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),6)	
	
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,FreqFac,LinkID))  q:LinkID=""  d
	.q:Group'=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),6)	
	.s Fac=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)
		
	Q Fac
}

/// 获取药品的通用名
/// flag:1 通用名id  flag:0 描述描述
/// ##class(web.DHCCKBCommon).GetGeneralName()
ClassMethod GetGeneralName(DicID, flag = 1) As %String
{
	n (DicID,flag)
	s GenerPropID=##class(web.DHCCKBCommon).GetDrugGenerName()   /// 药品通用名属性
	// 获取药品的通用名	
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,GenerPropID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.i flag=1 s $List(ListData,$LISTLENGTH(ListData)+1)=ItmDicID
	.e  d
	..s dicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s desc=$case(+dicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s $List(ListData,$LISTLENGTH(ListData)+1)=desc
	
	Q ListData
}

/// 获取药品的商品名
/// flag:1 商品名id  flag:0 描述
/// ##class(web.DHCCKBCommon).GetProName()
ClassMethod GetProName(DicID, flag = 1) As %String
{
	n (DicID,flag)
	s ProNameID=##class(web.DHCCKBCommon).GetProNameProp()   /// 药品商品名属性
	
	// 获取药品的通用名	
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,ProNameID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.i flag=1 s $List(ListData,$LISTLENGTH(ListData)+1)=ItmDicID
	.e  d
	..s dicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s desc=$case(+dicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(dicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s $List(ListData,$LISTLENGTH(ListData)+1)=desc
	
	Q ListData
}

/// 计算年龄
/// w ##class(web.DHCCKBCommon).ClacAge("1993-02-10")
ClassMethod ClacAge(argBirthday)
{
	n (argBirthday)
	//s argBirthday=$zdh(argBirthday,3)
	s argBirthday=##class(web.DHCCKBCommonUtil).DateHtmlToLogical(argBirthday)
	s cutage=+$h-argBirthday
	
	q:argBirthday>+$h ""
	s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	s tmpAge=$$CalAge^at182(argBirthday,+$h)
	i (tmpAge'="")&&($l(tmpAge,"|")'<14) D
	.s ageYears=$p(tmpAge,"|",12)
	.s ageMonths=$p(tmpAge,"|",13)
	.s ageDays=$p(tmpAge,"|",14)
	
	q:ageYears>0 ageYears_"岁"
	q:ageMonths>0 ageMonths_"月"
	q:ageDays>0 ageDays_"天"
	
	Q ""
}

/// Descript:项目列表属性
/// w ##class(web.DHCCKBCommon).GetMindInfoProp()
ClassMethod GetMindInfoProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("RemindMsg")
}

/// 获取实体或属性关联的数据源字典id
/// w ##class(web.DHCCKBCommon).GetDataSourceValue("Drug")
ClassMethod GetDataSourceValue(type)
{
	n (type)
	q:type="" ""
	s typeId=##class(web.DHCCKBCommon).GetDicIdByCode(type)
	q:+typeId=0 ""
	s sourceId=##class(web.DHCCKBCommon).GetDataSource()	// 数据源id
	s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",typeId,sourceId,""),-1) 
	q:linkID="" ""
  	s sourceData=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)
  	
  	q sourceData
}

/// Creator: 		qunianpeng 
/// CreateDate: 	2020-04-09
/// Descript: 		根据实体或属性的代码获取数据源字典id(可能是多个)
ClassMethod GetDataSourceAllValue(type)
{
	n (type)
	q:type="" ""
	s typeId=##class(web.DHCCKBCommon).GetDicIdByCode(type)
	q:+typeId=0 ""
	
	s sourceId=##class(web.DHCCKBCommon).GetDataSource()	// 数据源id
	
	s sourceDataStr=""
	s linkID=""
	f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",typeId,sourceId,linkID))	q:linkID=""  d
	.s tmpDicID=+$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkID)),4)
	.q:tmpDicID=0
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(tmpDicID))
	.i sourceDataStr="" s sourceDataStr=tmpDicID
	.e  s sourceDataStr=sourceDataStr_"^"_tmpDicID
  	
  	q sourceDataStr
}

/// 是否是统一模型的判断
/// 1 是，0 不是
/// ##class(web.DHCCKBCommon).IsComModelFlag(code)
ClassMethod IsComModelFlag(code)
{
	n (code) 
	
	s codeList=$lb("Drug","CombinedMedDrugNameProp","Ingredient","CombinedDrugCategory","GenerNameProp","ProNameProp","ExcipientProp","SolventProp","SolutionProp","LabItmValueLimitProp")
	s $list(codeList,*+1)="chHerbalMedName"
	s $list(codeList,*+1)="ChineseDrugNameProp"
	s $list(codeList,*+1)="PrescriptionCopeProp"
	//s $list(codeList,*+1)="SolutionDensity"  //xww 2021-12-16 浓度
	s $list(codeList,*+1)="GenerNameFormProp" // qunianpeng 2022022 通用名
	s ret=$listfind(codeList,code)
	
	q $case(ret>0,1:0,:1)
}

/// Descript：药品的等效单位
/// Author:	qunianpeng 2020-03-05
/// w ##class(web.DHCCKBCommon).GetEqUnitProp()
ClassMethod GetEqUnitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EqUnitProp")
}

/// Descript：药品的等效单位->从单位
/// Author:	qunianpeng 2020-03-05
ClassMethod GetEqFromUnitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EqFromUnitProp")
}

/// Descript：药品的等效单位->到单位 
/// Author:	qunianpeng 2020-03-05
ClassMethod GetEqToUnitProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EqToUnitProp")
}

/// Descript：药品的等效单位->等效数量 
/// Author:	qunianpeng 2020-03-05
ClassMethod GetEqFactorProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EqFactorProp")
}

/// Descript：目录->提醒消息
/// Author:	qunianpeng 2020-03-09
ClassMethod RemindMsgProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("RemindMsg")
}

/// 获取目录的提醒内容
/// Author:	qunianpeng 2020-03-09
/// w ##class(web.DHCCKBCommon).GetLabelRemindMsg(74)
ClassMethod GetLabelRemindMsg(Label) As %String
{
	n (Label)
	s RemindMsgProp=##class(web.DHCCKBCommon).RemindMsgProp()   /// 目录的提醒消息属性
	q:(+RemindMsgProp=0)||(+Label=0) ""
	// 获取药品的通用名	
	s Msg=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",Label,RemindMsgProp,LinkID))  q:LinkID=""  d
	.s TmpMsg=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)
	.q:TmpMsg=""
	.i Msg="" s Msg=TmpMsg
	.e  s Msg=Msg_""_TmpMsg
	
	Q Msg
}

/// 获取目录下某项目对的提醒内容
/// Author:	qunianpeng 2020-03-09
/// w ##class(web.DHCCKBCommon).GetItmRemindMsg(72,91)
ClassMethod GetItmRemindMsg(Label, ItmID) As %String
{
	n (Label, ItmID)
	q:(+Label=0)||(+ItmID=0) ""
	s RemindMsgProp=##class(web.DHCCKBCommon).RemindMsgProp()   /// 目录的提醒消息属性
	// 消息是存在目录和项目的关系的id上
	s CheckItmProp=##class(web.DHCCKBCommon).GetCheckItmListProp()
	q:(+RemindMsgProp=0)||(+CheckItmProp=0) ""	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",Label,CheckItmProp,ItmID)) ""
	s RealID=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",Label,CheckItmProp,ItmID,""),-1)
	
	s Msg=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",RealID,RemindMsgProp,LinkID)) q:LinkID=""  d	// 前提条件好像存储的不对 03/05
	.s TmpMsg=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),5)
	.q:TmpMsg=""
	.i Msg="" s Msg=TmpMsg
	.e  s Msg=Msg_""_TmpMsg
	
	q Msg
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-12
/// Descript: 		获取科室描述
ClassMethod GetCtLocDesc(ctLocId)
{
	n (ctLocId)
	
	q $case(ctLocId'="",1:$p($g(^CTLOC(+ctLocId)),"^",2),:"")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-12
/// Descript: 		获取医院描述
ClassMethod GetHospitalDesc(hospID)
{
	n (hospID)

	q $case(hospID'="",1:$p($g(^CT("HOSP",+hospID)),"^",2),:"")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-12
/// Descript: 		获取职称描述
/// w ##class(web.DHCCKBCommon).GetProfessDesc(1)
ClassMethod GetProfessDesc(userId)
{
	n (userId)
	
	s careProvDr=$case(userId'="",1:$p($g(^SSU("SSUSR",+userId)),"^",14),:"")	// ct_careprov
	s prvTpDr=$case(careProvDr'="",1:$p($g(^CTPCP(+careProvDr,1)),"^",4),:"")	// CT_CarPrvTp
	
	q $case(prvTpDr'="",1:$p($g(^CT("CPT",+prvTpDr)),"^",2),:"")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-12
/// Descript: 		获取职称id
/// w ##class(web.DHCCKBCommon).GetProfessID(1)
ClassMethod GetProfessID(userId)
{
	n (userId)
	
	s careProvDr=$case(userId'="",1:$p($g(^SSU("SSUSR",+userId)),"^",14),:"")	// ct_careprov
	s prvTpDr=$case(careProvDr'="",1:$p($g(^CTPCP(+careProvDr,1)),"^",4),:"")	// CT_CarPrvTp
	
	q prvTpDr
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-12
/// Descript: 		获取职称代码
/// w ##class(web.DHCCKBCommon).GetProfessDesc(1)
ClassMethod GetProfessCode(userId)
{
	n (userId)
	
	s careProvDr=$case(userId'="",1:$p($g(^SSU("SSUSR",+userId)),"^",14),:"")	// ct_careprov
	s prvTpDr=$case(careProvDr'="",1:$p($g(^CTPCP(+careProvDr,1)),"^",4),:"")	// CT_CarPrvTp
	
	q $case(prvTpDr'="",1:$p($g(^CT("CPT",+prvTpDr)),"^",1),:"")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-16
/// Descript: 		使用用户描述获取id
/// w ##class(web.DHCCKBCommon).GetProfessDesc(1)
ClassMethod GetUserIdByDesc(user)
{
	n (user)
	
	q:user="" 0
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(user),""),-1)
	
	q userId
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-16
/// Descript: 		使用职称描述获取id
/// w ##class(web.DHCCKBCommon).GetProfessDesc(1)
ClassMethod GetProfessIdByDesc(profess)
{
	n (profess)
	
	q:profess="" 0
	s professId=$o(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(profess),""),-1)
	
	q professId
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-16
/// Descript: 		使用科室描述获取id
ClassMethod GetLocIdByDesc(loc)
{
	n (loc)
	
	q:loc="" 0
	s locId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(loc),""),-1)
	
	q locId
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-16
/// Descript: 		使用安全组描述获取id
ClassMethod GetGroupIdByDesc(group)
{
	n (group)
	
	s groupId=""
	
	q groupId
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-16
/// Descript: 		使用医院描述获取id
/// w ##class(web.DHCCKBCommon).GetProfessDesc(1)
ClassMethod GetHospIdByDesc(hosp)
{
	n (hosp)
	
	q:hosp="" 0
	s hospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""),-1)
	
	q hospId
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-18
/// Descript: 		获取是否必填属性
/// w ##class(web.DHCCKBCommon).GetRequiredProp(1)
ClassMethod GetRequiredProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Required")
}

/// Descript:获取作用域-id
ClassMethod GetScopeData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ScopeData")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-23
/// Descript: 		获取医院字典id
/// w ##class(web.DHCCKBCommon).GetHospitalData()
ClassMethod GetHospitalData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("HospitalData")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-23
/// Descript: 		获取科室字典id
/// w ##class(web.DHCCKBCommon).GetLocData()
ClassMethod GetLocData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OfficeData")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-23
/// Descript: 		获取安全组字典id
/// w ##class(web.DHCCKBCommon).GetGroupData()
ClassMethod GetGroupData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("GroupData")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-23
/// Descript: 		获取职称字典id
/// w ##class(web.DHCCKBCommon).GetCarePrvData()
ClassMethod GetCarePrvData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("CarePrvData")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-23
/// Descript: 		获取医生字典id
/// w ##class(web.DHCCKBCommon).GetDocData()
ClassMethod GetDocData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DocData")
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2020-03-25
/// Descript: 		获取Y id
/// w ##class(web.DHCCKBCommon).GetYesData()
ClassMethod GetYesData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Y")
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2020-03-25
/// Descript: 		获取N id
/// w ##class(web.DHCCKBCommon).GetNoData()
ClassMethod GetNoData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("N")
}

/// Creator: 		sunhuiyong
/// CreateDate: 	2020-03-25
/// Descript: 		获取附加属性是否可用id
/// w ##class(web.DHCCKBCommon).GetAvailableData()
ClassMethod GetAvailableData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("Available")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 		公共显示判断
/// Input:			需要判断的项目,操作的表,登录信息(人员id^职称id^科室id^安全组id^医院id)
/// Outut:			1 显示 0 不显示
/// Other: 			操作的表(Table)根据调用的界面传不同的值,如浏览器调用,是看字典数据有没有授权,"DHC_CKBCommonDiction"; 数据对照界面："DHC_CKBComContrast"
/// w ##class(web.DHCCKBCommon).IsShow(3913,"DHC_CKBCommonDiction","1^^1^1^2")
/// w ##class(web.DHCCKBCommon).IsShow("23959","DHC_CKBCommonDiction","1^^289^2^心功能不全")
ClassMethod IsShow(ItmId, Table, LoginInfo = "") As %String
{
	
	n (ItmId,Table,LoginInfo)

	set $ZT="ERROR" // 设置一个异常
	//q:LoginInfo="" 0

	s Parref=..GetItmIdParref(ItmId) // ItmId 若是字典数据,需要判断,字典是否可用,若字典都被停用掉了,则字典数据也不可用
	s Ret=..IsEnabled(Parref)
	
	q:Ret=0 0
	s Ret=..IsEnabled(ItmId)		// 是否停用
	
	q:Ret=0 0
	s Ret=..IsPermission(ItmId,Table,LoginInfo)	// 是否授权(是否可见)
	
	q:Ret=0 0

	s Ret=..IsContrast(ItmId,LoginInfo)		// 是否对照,且授权
	q:Ret=0 0	

	q Ret
	
ERROR
	set $ZT=""
	set ErrorMsg=$ZE                  //$ZE 获取错误信息

	q 0		// 授权发生错误,则默认不显示
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 		判断数据是否可用(停用)
/// Input:			需要判断的项目
/// OutPut:			1 可用 0 不可用
/// w ##class(web.DHCCKBCommon).IsEnabled(16960)
ClassMethod IsEnabled(ItmId) As %String
{
	
	n (ItmId)
	q:ItmId="" 0
	// 附加属性,是否可用的Y/N 标记
	s Available=..GetAvailable()	// 是否可用标记
	q:'$d( ^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",ItmId,Available)) 1	//未标记是否可用,默认为可用
	s IsEnableFalg=1
	s DLARowID=""
	f  s DLARowID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",ItmId,Available,DLARowID))  q:(DLARowID="")||(IsEnableFalg=0)  d
	.s AttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),4)
	.i $lg($g(^CT.CKB.PDSS.CommonDictionD(+AttrDr)),3)="N" s IsEnableFalg=0
	.q:IsEnableFalg=0
	.s Result=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(DLARowID)),5)
	.i Result="N" s IsEnableFalg=0

	q IsEnableFalg
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 		判断数据是否授权
/// Input:			需要判断的项目,需要判断功能,医护人员
/// OutPut:			1 已授权 0 无授权
/// w ##class(web.DHCCKBCommon).IsGrantAuth()
ClassMethod IsPermission(ItmId, OperTable, LoginInfo) As %String
{
	
	n (ItmId,OperTable,LoginInfo)
		
	
	s Ret=..IsNeedPermission(ItmId)	// 是否需要授权
	q:Ret=0 1	

	s Type="grantAuth"
	//s OperTable="DHC_CKBCommonDiction"
	s Ret=..CheckGrantAuth(Type,OperTable,ItmId,LoginInfo)	// 存在问题:若标准版上根据科室(专科),人员进行了授权,项目上有相同的科室,是不是该科室就读取到了所有的专科数据

	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 		判断数据是否需要进行授权/对照
/// Input:			需要判断的项目
/// OutPut:			1 需要授权 0 不需要授权
/// w ##class(web.DHCCKBCommon).IsNeedPermission(77782)
ClassMethod IsNeedPermission(ItmId) As %String
{
	n (ItmId)
	s Ret=1
	s ItmCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmId)),2)
	s ItmLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmId)),3)
	q:(+ItmCode="")||(+ItmLinkDr=0) 0

	s Parref=..GetItmIdParref(ItmId) // ItmId 若是字典数据,需要判断,字典是否可用,若字典都被停用掉了,则字典数据也不可用
	s ParrefCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(+Parref)),2)
	
	s AuthObj=##class(web.DHCCKBConfig).InitGrantAuthList()	
	q:(AuthObj.%IsDefined(ItmCode)=0)&((AuthObj.%IsDefined(ParrefCode)=0)) 0 	// 是否是系统字典,系统字典不需要授权
	
	i AuthObj.%IsDefined(ItmCode)=1 d
	.s AccFlag=AuthObj.%Get(ItmCode)
	.s:AccFlag="N" Ret=0				// 系统字典中,不需要授权的项目

	i AuthObj.%IsDefined(ParrefCode)=1 d
	.s AccFlag=AuthObj.%Get(ParrefCode)
	.s:AccFlag="N" Ret=0				// 系统字典中,不需要授权的项目

	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 		检查授权
/// Input:			类型,操作表,项目,用户信息
/// OutPut:			1 授权 0 无授权
ClassMethod CheckGrantAuth(Type, OperTable, ItemId, UserInfo)
{
	n (Type,OperTable,ItemId,UserInfo)
	
	q:UserInfo="" 0
	q:ItemId="" 0
	s UserID=$p(UserInfo,"^",1)
	s ProfessID=$p(UserInfo,"^",2)
	s LocID=$p(UserInfo,"^",3)
	s GroupID=$p(UserInfo,"^",4)
	s HospID=$p(UserInfo,"^",5)
	s HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
	q:##class(web.DHCCKBConfig).SysUser()[HospDesc 1	// 内置用户不需要授权
	q:'$d(^CKB.PDSS.DicLogI("Function",OperTable,+ItemId,Type)) 0

	k TmpArr
	s LogId=""
	f  s LogId=$o(^CKB.PDSS.DicLogI("Function",OperTable,ItemId,Type,LogId))  q:LogId=""  d
	.s listData = $g(^CKB.PDSS.DicLogD(LogId))
	.s Scope = $lg(listData,8)
	.s ScopeVaule = $lg(listData,9)
	.q:Scope=""
	.q:ScopeVaule=""
	.s TmpArr(Scope,ScopeVaule)=""
	
	// 授权的优先级：人员(U),职称(P),科室(L),安全组(G),医院(D)

	q:(UserID'="")&&$d(TmpArr("U"))&&$d(TmpArr("U",UserID)) 1
	
	q:(ProfessID'="")&&$d(TmpArr("P"))&&$d(TmpArr("P",ProfessID)) 1
	
	q:(LocID'="")&&$d(TmpArr("L"))&&$d(TmpArr("L",LocID)) 1
	
	q:(GroupID'="")&&$d(TmpArr("G"))&&$d(TmpArr("G",GroupID)) 1
	
	q:(HospID'="")&&$d(TmpArr("D"))&&$d(TmpArr("D",HospID)) 1

	q 0
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 	    是否对照
/// Input:			类型,操作表,项目,用户信息
/// OutPut:			1 授权 0 无授权
ClassMethod IsContrast(ItmId, LoginInfo)
{
	n (ItmId,LoginInfo)
		
	s HospID=$p(LoginInfo,"^",5)
	s HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
	q:##class(web.DHCCKBConfig).SysUser()[HospDesc 1	// 内置用户不需要授权
		
	s Ret=..IsNeedPermission(ItmId)	// 是否需要对照
	q:Ret=0 1	
	
	s LibCode=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmId)),2)
	q:LibCode="" 0 

	s IsPermissFlag=0
	s HisCode=""
	f  s HisCode=$o(^CKB.PDSS.ComContrastI("LibCode",LibCode,HisCode))	q:(HisCode="")||(IsPermissFlag=1)  d
	.s CCRowID=""	
	..f  s CCRowID=$o(^CKB.PDSS.ComContrastI("LibCode",LibCode,HisCode,CCRowID))	q:(CCRowID="")||(IsPermissFlag=1)   d
	...s Table="DHC_CKBComContrast"
	...s IsPermissFlag=..IsPermission(CCRowID,Table,LoginInfo)	// 对照是否授权
	...q:IsPermissFlag=1

	s Ret=IsPermissFlag
	
	q Ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-03-26
/// Descript: 	    获取数据的最上层节点,用于判断字典
/// Input:			
/// OutPut:	
/// w ##class(web.DHCCKBCommon).GetItmIdParref(150)
ClassMethod GetItmIdParref(ItmId)
{
	n (ItmId)
	
	q:ItmId="" 0
	
	s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmId)),4) 
	q:Parref="" ItmId

	s Parref=..GetItmIdParref(Parref)
	
	q Parref
}

/// 取模板元素ID
/// w ##class(web.DHCCKBCommon).GetTempEleId()
ClassMethod GetTempEleId()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TempElement")
}

/// 取附加属性顺序号ID
/// w ##class(web.DHCCKBCommon).GetOrdNumId()
ClassMethod GetOrdNumId()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("OrderNum")
}

/// Description:	带剂型的通用名字典
/// Creator:		QuNianpeng 
/// CreateDate:		2020-04-7	
/// w ##class(web.DHCCKBCommon).GetGeneralFromData()
ClassMethod GetGeneralFromData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("GeneralFromData")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		获取药学分类关联的药品
/// Input:			CatID-药学分类id, flag-(1取id,flag 0 取描述)
/// w ##Class(web.DHCCKBCommon).GetDrugListByCat("667")
ClassMethod GetDrugListByCat(CatID As %String, flag = 1) As %String
{
	n (CatID,flag)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类属性id
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",CatID,PhCatID)) ""
	
		
	k DrugList
	s DrugList=""	
	s count=0 
	s LinkId="" 
	f  s LinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",CatID,PhCatID,LinkId)) q:LinkId=""  d
	.q:+LinkId=0
	.s DrugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkId)),2)
	.q:+DrugId=0    
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(DrugId))
	.q:0=##class(web.DHCCKBCommon).IsEnabled(DrugId)	// 过滤停用
	.if flag=1 d
	..s $LIST(DrugList,*+1)=DrugId
	.else  d
	..s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),5)
	..i LinkDr="" s DrugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),3)
	..e  s DrugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkDr)),3)
	..s:$g(tmpdesc)'="" $LIST(DrugList,*+1)=DrugDesc

	Q DrugList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		通过字典id,代码描述找到对应的知识库的id
/// Input:			Type(字典id), DicDesc描述
/// w ##Class(web.DHCCKBCommon).GetDicIDByType(106,"头孢菌素类")
ClassMethod GetDicIDByType(Type, DicDesc) As %String
{
	n (Type,DicDesc)
	s DicDesc=##class(web.DHCCKBPassNew).GetKnowBaseCode(DicDesc,Type,"")
	Q:DicDesc="" ""
	
	i $listvalid(DicDesc)=1 d
	.s DicDesc=$listtostring(DicDesc)
	
	s ParrefList=""
	i $d(^CT.CKB.PDSS.CommonDictionI("Parref",Type)) d
	.d ..GetChildNode(.ParrefList,Type)
	s Itmid="",DicID=""
	f  s DicID=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(DicDesc),DicID))	q:(DicID="")||(Itmid'="")  d
	.s Parref=$lg($g(^CT.CKB.PDSS.CommonDictionD(DicID)),4)
	.//q:(+Type'=0)&(Parref'=Type)	// 过滤数据源
	.q:(+Type'=0)&($listfind(ParrefList,Parref)=0)	// 过滤掉别名
	.s Itmid=DicID
	
	Q Itmid
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		获取当前节点的所有子节点,用于树行结构的多层节点的判断
/// Input:			Type(字典id), DicDesc描述
/// w ##Class(web.DHCCKBCommon).GetDicIDByType()
ClassMethod GetChildNode(ParrefList, Parref) As %String
{
	n (ParrefList, Parref)
	
	s $List(ParrefList,*+1)=Parref
	
	s ChildNode=""
	f  s ChildNode=$o(^CT.CKB.PDSS.CommonDictionI("Parref",Parref,ChildNode)) q:ChildNode=""  d
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",ChildNode)) d
	..d ..GetChildNode(.ParrefList,ChildNode)

	
	q ParrefList
}

/// Creator:		qunianpeng
/// CreatDate:		2020-04-11
/// Description:： 	获取通用名字典id
/// Other:	w ##class(web.DHCCKBCommon).GetGeneralData()
ClassMethod GetGeneralData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("GeneralData")
}

/// Creator:		qunianpeng
/// CreatDate:		2020-04-11
/// Description:： 	获取带剂型的通用名属性id
/// w ##class(web.DHCCKBCommon).GetGeneralFromProp()
ClassMethod GetGeneralFromProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameFormProp")
}

/// Creator:		qunianpeng
/// CreatDate:		2020-04-11
/// Description:： 	获取药品的带剂型的通用名
/// Input:			DicID药品id, flag(1 取id, 0 取描述)
/// Other:	w ##class(web.DHCCKBCommon).GetGeneralFrom()
ClassMethod GetGeneralFrom(DicID, Flag = 1) As %String
{
	n (DicID,Flag)
	s GenerFromPropID=##class(web.DHCCKBCommon).GetGeneralFromProp()   /// 药品带剂型通用名属性
	
	// 获取药品的带剂型通用名	
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,GenerFromPropID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg(^CT.CKB.PDSS.DicLinkAttrD(LinkID),4)
	.q:ItmDicID=""
	.i Flag=1 s $List(ListData,*+1)=ItmDicID
	.e  d
	..s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s Desc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s $List(ListData,*+1)=Desc
	
	Q ListData
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-6-9
/// Description:： 	获取药品的带剂型的通用名
/// Input:			DicID药品id, flag(1 取id, 0 取描述)
/// Other:	w ##class(web.DHCCKBCommon).GetGeneralFromNew(89329)
ClassMethod GetGeneralFromNew(DicID, Flag = 1) As %String
{
	n (DicID,Flag)
	s GenerFromPropID=81818 ;##class(web.DHCCKBCommon).GetGeneralFromProp()   /// 药品带剂型通用名属性
	
	// 获取药品的带剂型通用名	
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,GenerFromPropID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.i Flag=1 s $List(ListData,*+1)=ItmDicID
	.e  d
	..s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s Desc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s $List(ListData,*+1)=Desc
	
	Q ListData
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-6-9
/// Description:： 	获取药品的带剂型的通用名
/// Input:			DicID药品id, flag(1 取id, 0 取描述)
/// Other:	w ##class(web.DHCCKBCommon).GetGeneralFromNew(888922)
ClassMethod GetGeneralFromStr(DicID, Flag = 1) As %String
{
	n (DicID,Flag)
	s GenerFromPropID=81818 ;##class(web.DHCCKBCommon).GetGeneralFromProp()   /// 药品带剂型通用名属性
	
	// 获取药品的带剂型通用名	
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,GenerFromPropID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.i Flag=1 s ListData=ItmDicID
	.e  d
	..s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s Desc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s ListData=Desc
	
	Q ListData
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		通过药品的属性获取关联的药品(如：通过成分，分类,等获取药品)
/// Input:			PropId_属性id,ItmId_属性值,flag-(1取id,flag 0 取描述)
/// w ##Class(web.DHCCKBCommon).GetCommonDrugListByProp(38,"667")
ClassMethod GetCommonDrugListByProp(PropId As %String, ItmId, Flag = 1) As %String
{
	n (PropId,ItmId,Flag)
	
	q:+PropId=0 ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",ItmId,PropId)) ""
		
	k DrugList
	s DrugList=""	
	s count=0 
	s LinkId="" 
	f  s LinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",ItmId,PropId,LinkId)) q:LinkId=""  d
	.q:+LinkId=0
	.s DrugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkId)),2)
	.q:+DrugId=0    
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(DrugId))
	.q:0=##class(web.DHCCKBCommon).IsEnabled(DrugId)	// 过滤停用
	.if Flag=1 d
	..s $LIST(DrugList,*+1)=DrugId
	.else  d
	..s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),5)
	..i LinkDr="" s DrugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(DrugId)),3)
	..e  s DrugDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkDr)),3)
	..s:$g(DrugDesc)'="" $LIST(DrugList,*+1)=DrugDesc

	Q DrugList
}

/// Creator: 		qunianpeng  Sunhuiyong
/// CreateDate: 	2020-04-10   2021-01-19
/// Descript: 		通过药品的属性获取关联的药品(如：通过成分，分类,等获取药品)
/// Input:			PropId_属性id,ItmId_属性值,flag-(1取id)
/// w ##Class(web.DHCCKBCommon).GetCommonDrugListByPropStr(38,"667")
ClassMethod GetCommonDrugListByPropStr(PropId As %String, ItmId, Flag = 1) As %String
{
	n (PropId,ItmId,Flag)
	
	q:+PropId=0 ""
	q:+ItmId=0 ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",ItmId,PropId)) ""
		
	k DrugList
	s DrugList=""	
	s count=0 
	s LinkId="" 
	f  s LinkId=$o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",ItmId,PropId,LinkId)) q:LinkId=""  d
	.q:+LinkId=0
	.s DrugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkId)),2)
	.q:+DrugId=0    
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(DrugId))
	.q:0=##class(web.DHCCKBCommon).IsEnabled(DrugId)	// 过滤停用
	.if Flag=1 d
	..;s $LIST(DrugList,*+1)=DrugId
	..s:DrugList="" DrugList=DrugId
	..s:DrugList'="" DrugList=DrugList_"^"_DrugId

	Q DrugList
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		通过属性获取数据源的字典
/// Input:			属性描述,Flag(1 获取id ,0 获取描述)
/// w ##Class(web.DHCCKBCommon).GetDataListByProp("GenerNameProp","0")
ClassMethod GetDataListByProp(Prop, Flag = 1) As %String
{
	n (Prop,Flag)
	
	q:Prop="" ""
	s PropId=##class(web.DHCCKBCommon).GetDicIdByCode(Prop)
	s LinkPropDr=##class(web.DHCCKBCommon).GetLinkProp()    //关联属性
	s DataSoruce=##class(web.DHCCKBCommon).GetDataSource()
	
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",+PropId,DataSoruce)) ""
	
	s ListData=""
	s AttrDr=""
	f  s AttrDr=$o(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",+PropId,DataSoruce,AttrDr))  q:AttrDr=""  d
	.q:'$d(^CT.CKB.PDSS.CommonDictionD(AttrDr))
	.s RowID=""
	.f  s RowID=$o(^CT.CKB.PDSS.CommonDictionI("Parref",AttrDr,RowID))  q:RowID=""  d
	..s LinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),5)
	..s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(RowID)),3)
	..i LinkDr'="" s DicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(LinkDr)),3)
	..i Flag=1 d
	...s $list(ListData,*+1)=RowID
	..e  d
	...s $list(ListData,*+1)=DicDesc
	
	
	q ListData
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-10
/// Descript: 		通过药品获取药品拥有的属性值
/// Input:			属性描述,Flag(1 获取id ,0 获取描述)
/// w ##Class(web.DHCCKBCommon).GetProValueListByDrug(150,"ProNameProp","0")
ClassMethod GetProValueListByDrug(DicID, Prop, Flag = 1) As %String
{
	n (DicID,Prop,Flag)
	s PropId=##class(web.DHCCKBCommon).GetDicIdByCode(Prop)	// 属性
	q:+PropId=0 ""
	
	// 获取药品的属性值
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PropId,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.i Flag=1 s $List(ListData,*+1)=ItmDicID
	.e  d
	..s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s Desc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s $List(ListData,*+1)=Desc
	
	Q ListData
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-04-17
/// Descript: 		通过用药频率-转换因子
/// w ##class(web.DHCCKBCommon).GetChangeFactorProp()
ClassMethod GetChangeFactorProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChangeFactorProp")
}

/// Creator:sufan
/// Descript:取主键
/// w ##class(web.DHCCKBCommon).GetPrimaryKey()
ClassMethod GetPrimaryKey() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("PrimaryKey")
}

/// Creator:sufan
/// Descript:取中医疾病实体
/// w ##class(web.DHCCKBCommon).ChineseDisease()
ClassMethod ChineseDisease() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDisease")
}

/// Creator:sufan
/// Descript:取中医疾病字典
/// w ##class(web.DHCCKBCommon).ChineseDiseaseData()
ClassMethod ChineseDiseaseData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDiseaseData")
}

/// Creator:sufan
/// Descript:取中成药
/// w ##class(web.DHCCKBCommon).GetChineseDrug()
ClassMethod GetChineseDrug() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrug")
}

/// Creator:sufan
/// Descript:药品-通用名属性id
/// w ##class(web.DHCCKBCommon).GetGenerNameProp()
ClassMethod GetGenerNameProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("GenerNameProp")
}

/// Creator:sufan
/// Descript:药品-西药名称属性id
/// w ##class(web.DHCCKBCommon).GetMedDrugNameProp()
ClassMethod GetMedDrugNameProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("MedDrugNameProp")
}

/// Creator:sufan
/// Descript:药品-中药名称属性id
/// w ##class(web.DHCCKBCommon).GetChineseDrugNameProp()
ClassMethod GetChineseDrugNameProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugNameProp")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-07
/// Descript: 		中成药属性
/// w ##class(web.DHCCKBCommon).GetChineseDrugProp()
ClassMethod GetChineseDrugProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugProp")
}

/// Creator: 		sufan
/// CreateDate: 	2020-05-26
/// Descript:药品->用药指导属性id
ClassMethod GetMedGuidRemProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("MedGuidRemProp")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-25
/// Descript: 		获取知识库的项目属性值(如：药品的成分、商品等)
/// Input:			DicID:项目ID	Prop:属性代码	Flag:0取描述 1 取id  
/// w ##class(web.DHCCKBCommon).GetSysPropValue(150,38)
ClassMethod GetSysPropValue(DicID, Prop, Flag = 1) As %String
{
	n (DicID,Prop,Flag)
	q:(Prop="")||(+DicID=0) ""
	s PropID=##class(web.DHCCKBCommon).GetDicIdByCode(Prop)   /// 属性ID
		
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+DicID,+PropID)) ""
	
	// 获取药品的属性
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PropID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	.i Flag=1 d 
	..i $lf(ListData,ItmDicID)<=0 s $List(ListData,*+1)=ItmDicID
	..s:(+DicLinkDr'=0)&&($lf(ListData,DicLinkDr)<=0) $List(ListData,*+1)=DicLinkDr
	.e  d
	..s Desc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(+DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(+ItmDicID)),3))
	..q:$lf(ListData,Desc)>=0
	..s $List(ListData,*+1)=Desc
	
	Q ListData
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-29
/// Descript: 		获取目录下的规则类型
/// Other:					 默认是审查规则，主要是为了子规则和全局规则不能配置规则类型
/// w ##class(web.DHCCKBCommon).GetRuleType(72)
ClassMethod GetRuleType(libary) As %String
{
	n (libary)

	q:+libary=0 "CheckRule" 
	s ruleTypeID=##class(web.DHCCKBCommon).GetDicIdByCode("RuleType")
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",+libary,+ruleTypeID)) "CheckRule"
	
	s ruleType=""
	s linkID=""
	f  s linkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",libary,ruleTypeID,linkID))  q:linkID=""  d
	.s attrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+linkID)),"^",3)
	.q:+attrDr=0
	.s ruleType=$lg($g(^CT.CKB.PDSS.CommonDictionD(+attrDr)),2)
		
	q:ruleType="" "CheckRule"
	q ruleType
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-05-25
/// Descript: 		公式调用时机
/// w ##class(web.DHCCKBCommon).GetExecuteTime()
ClassMethod GetExecuteTime() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ExecuteTime")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:药品->单支溶质量id
ClassMethod GetSinSolMassProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SingleSolMass")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:药品->是否必用溶媒药品id
ClassMethod GetNeceSolMedProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("NeceSolMed")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:药品->单次医嘱对应溶媒量id
ClassMethod GetSinOrdVehVolProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SingleOrdVehVol")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:药品->是否必用溶液药品id
ClassMethod GetNeceSolDrugProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("NeceSolDrug")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:药品->单次医嘱对应溶液量id
ClassMethod GetSingleOrdCorProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SingleOrdCorQua")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:药品->辅助用药个数id
ClassMethod GetAuxDrugsNumProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("AuxDrugsNum")
}

/// Creator: 		sufan
/// CreateDate: 	2020-06-17
/// Descript:提醒字典id
ClassMethod GetTipsData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("TipsData")
}

/// Descript:用药指导
/// w ##class(web.DHCCKBCommon).GetDrugEduProp()
ClassMethod GetDrugEduProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")
}

/// Creator: 		sufan
/// CreateDate: 	2020-07-09
/// Descript:功能主治
ClassMethod GetFunIndicat() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetChineseDrugProp()
	s FunIndicat = ##class(web.DHCCKBCommon).GetDicIdByCode("FunIndicat")
	q:(+DrugProp=0)||(+FunIndicat=0) ""
	s FunIndicatPro=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",FunIndicat,DrugProp,""))
	q FunIndicatPro
}

/// Creator: 		sufan
/// CreateDate: 	2020-07-09
/// Descript:禁忌
ClassMethod GetDrugContra() As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetChineseDrugProp()
	s DrugContra = ##class(web.DHCCKBCommon).GetDicIdByCode("RuleContrTwo")
	q:(+DrugProp=0)||(+DrugContra=0) ""
	s DrugContrPro=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",DrugContra,DrugProp,""))
	q DrugContrPro
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-07-17
/// Descript:		规则中是否需要审核(如:不审核st用法，则规则中此分支忽略)	 2022-06-16 此方法不启用了，使用忽略配置替换
/// OutPut:			Y 需要审核 N不需要审核
/// w ##class(web.DHCCKBCommon).IsAudit(4096) // 4100
ClassMethod IsAudit(DicID) As %String
{
	n (DicID)
	q:+DicID=0 "Y"
	s IsAuditID = ##class(web.DHCCKBCommon).GetDicIdByCode("IsAudit")
	q:+IsAuditID=0 "Y"
	
	s ExistFlag="Y",LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,IsAuditID,LinkID))  q:(LinkID="")||(ExistFlag="N")  d
	.s AttrDr=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+LinkID)),"^",3)
	.s AttrDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+AttrDr)),2)
	.s ExistFlag=AttrDesc

	q ExistFlag
}

/// Creator:		qunianpeng
/// CreateDate: 	2020-08-03
/// Descript:		判断药品下的目录是否有规则
/// OutPut:			Y 有 N 没有
/// w ##class(web.DHCCKBCommon).IsExistLibaryRule(90639,72) // 4100
ClassMethod IsExistLibaryRule(DicID, LibID) As %String
{
	n (DicID,LibID)
	s ExistFlag="N"
	q:LibID=##class(web.DHCCKBCommon).GetDrugEduProp() "Y"		// 用药指导规则在子层上判断
	q:LibID=##class(web.DHCCKBCommon).GetSkinTestRuleProp() "Y"	 // 皮试药品目录不过滤
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByCode("RuleLimitCTLoc") "Y" // 限定科室不过滤 2020/12/3
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByCode("EighteenTaboo") "Y" // 十八反不过滤 2021/04/23
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByCode("NineteenTaboo") "Y" // 十九畏不过滤 2021/04/23
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByDesc("适应症") "Y"
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByDesc("禁忌症") "Y" 
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage") "Y"
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByDesc("配伍禁忌") "Y" 
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByCode("InterEach") "Y"
	q:LibID=##class(web.DHCCKBCommon).GetDicIdByDesc("液体配置") "Y" 
	q:(+DicID=0)||(+LibID=0) ExistFlag
	q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",+DicID)) ExistFlag
	
	
	s RuleDicID=""
	f  s RuleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",+DicID,RuleDicID))	q:(RuleDicID="")||(ExistFlag="Y")  d
	.s RuleID=$lg($g(^CT.CKB.PDSS.RuleDicD(+RuleDicID)),2)
	.i $d(^CT.CKB.PDSS.RuleDicI("RuleDic",+RuleID,+LibID)) s ExistFlag="Y"

	q ExistFlag
}

/// Descript:	获取用法目录的id
/// w ##class(web.DHCCKBCommon).GetComDosageProp()
ClassMethod GetComDosageProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ComDosage")
}

/// Creator:		qunianpeng
/// CreateDate: 	2020-11-09
/// Descript:	获取皮试用药目录的id
/// w ##class(web.DHCCKBCommon).GetSkinTestRuleProp()
ClassMethod GetSkinTestRuleProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SkinTestRule")
}

// 

/// Creator:		qunianpeng
/// CreateDate: 	2020-11-09
/// Descript:	获取皮试属性的id
/// w ##class(web.DHCCKBCommon).GetSkinTestDrugProp()
ClassMethod GetSkinTestDrugProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SkinTestDrugProp")
}

/// Creator:		sufan
/// CreateDate: 	2020-11-09
/// Descript:患者-体表面积属性
/// w ##class(web.DHCCKBCommon).GetBodySurAreaProp()
ClassMethod GetBodySurAreaProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("BodySurAreaProp")
}

/// Creator:		qunianpeng
/// CreateDate: 	2020-12-03
/// Descript:	获取西医疾病名称属性的id
/// w ##class(web.DHCCKBCommon).DiseaseDesc()
ClassMethod DiseaseDesc() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DiseaseDesc")
}

/// Creator:		qunianpeng
/// CreateDate: 	2020-12-03
/// Descript:	获取中医疾病疾病属性的id
/// w ##class(web.DHCCKBCommon).ChineseDiseaseName()
ClassMethod ChineseDiseaseName() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDiseaseName")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-01-16
/// Descript:		获取药学分类and上层分类
/// Input:			dicID 药品id, flag 1 取id,flag 0 取描述
/// w ##Class(web.DHCCKBCommon).GetPhCatWithParent("89329",0)
ClassMethod GetPhCatWithParent(DicID As %String, flag = 1) As %String
{
	n (DicID,flag)
	s PhCatID=##Class(web.DHCCKBCommon).GetPhCategory()   /// 药学分类
	q:DicID="" ""
	// 获取药品的分类
	k ListCat
	s ListCat=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PhCatID,LinkID))  q:LinkID=""  d
	.s ItmCatID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.d ..GetParentCat(.ListCat,ItmCatID,flag)						/// 获取分类的所有父分类
		
	Q ListCat
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-11-16
/// Descript:	获取带量采购同类药品分类id
/// w ##class(web.DHCCKBCommon).GetVolSimilarCat()
ClassMethod GetVolSimilarCat() As %String
{
	//带量采购同类药品
	q ##class(web.DHCCKBCommon).GetDicIdByDesc("带量采购同类药品")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-11-16
/// Descript:		获取带量采购属性的id
/// w ##class(web.DHCCKBCommon).GetVolPurchProp()
ClassMethod GetVolPurchProp() As %String
{
	s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("VolPurchProp")
	s propList =""
	s $list(propList,*+1) = propId
	s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(+propId)),5)
	i linkDr '="" s $list(propList,*+1) = linkDr
	
	q propList
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-11-16
/// Descript:	获取同类重复分类id
/// w ##class(web.DHCCKBCommon).GetSimilarRepeat()
ClassMethod GetSimilarRepeat() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByDesc("同类重复")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-11-16
/// Descript:	获取异类重复分类id
/// w ##class(web.DHCCKBCommon).GetDifferentRepeat()
ClassMethod GetDifferentRepeat() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByDesc("异类重复")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-11-16
/// Descript:	中药饮片属性id
/// w ##class(web.DHCCKBCommon).GetChinaHMedicineProp()
ClassMethod GetChinaHMedicineProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseHerbalMedicineProp")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-02-02
/// Descript:		获取国家基本药物属性的id
/// w ##class(web.DHCCKBCommon).GetEssDrugFlagProp()
ClassMethod GetEssDrugFlagProp() As %String
{
	s propId = ##class(web.DHCCKBCommon).GetDicIdByCode("EssDrugFlagProp")
	s propList =""
	s $list(propList,*+1) = propId
	s linkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(propId)),5)
	i linkDr '="" s $list(propList,*+1) = linkDr
	
	q propList
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-02-02
/// Descript:		获取国家基药目录分类id
/// w ##class(web.DHCCKBCommon).GetBaseDrugCat()
ClassMethod GetBaseDrugCat() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByDesc("国家基药目录")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-02-22
/// Descript:		药品-规格属性id
ClassMethod GetSpecificationProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("SpecificationProp")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-03-27
/// Descript:		判断药品是否有某个级别的规则
/// w ##class(web.DHCCKBCommon).IsExistWarnRule(251,"提1")
ClassMethod IsExistWarnRule(dicID, levels) As %String
{
	n (dicID,levels)
	q:'$d(^CT.CKB.PDSS.RuleDicI("Dic",dicID)) 0
	q:levels="" 1
	
	s isExistFlag = 0
	s ruleDicID=""
	f   s ruleDicID=$o(^CT.CKB.PDSS.RuleDicI("Dic",dicID,ruleDicID))  q:(ruleDicID="")||(isExistFlag=1)  d
	.s rule=$lg($g(^CT.CKB.PDSS.RuleDicD(+ruleDicID)),2)
	.q:+rule=0
	.q:'$d(^CT.CKB.PDSS.RuleDataI("Rule",rule))
	.s status = $lg($g(^CT.CKB.PDSS.RuleD(+rule)),4)
	.q:status'="Release"
	.s ruleDataID=""
	.f  s ruleDataID=$o(^CT.CKB.PDSS.RuleDataI("Rule",rule,ruleDataID)) q:(ruleDataID="")||(isExistFlag=1)  d
	..s rightDicID=$lg($g(^CT.CKB.PDSS.RuleDataD(+ruleDataID)),8)
	..q:+rightDicID=0
	..s rightDicDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+rightDicID)),3)
	..q:(levels="")||(rightDicDesc="")
	..i (levels'="")&(rightDicDesc'="")&(levels[rightDicDesc) s isExistFlag=1
	
	q isExistFlag
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-03-25
/// Descript: 		计算方向：用法用量是反向提示，不满足时提示， 禁忌症时正向向提示，满足时提示
/// Return:			0 反向 1 正向
/// w ##Class(web.DHCCKBCommon).GetCalcPathByDicID(74537)74536
/// 74537
ClassMethod GetCalcPathByDicID(DicID) As %String
{
	n (DicID)
	
	q:DicID="" 0
	
	s PathFlag=0  // 默认反向
	s CalcPath=##class(web.DHCCKBCommon).GetCalcPath()
	
	s ExistFlag=0
	i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,CalcPath)) d
	.s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,CalcPath,""),-1)
	.s CalcPathItm=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+LinkID)),"^",3)
	.s CalcPathDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+CalcPathItm)),2)
	.s PathFlag=$select(CalcPathDesc="isFalse":0,CalcPathDesc="isTrue":1,1:PathFlag)
	.s ExistFlag=1
	e  d
	.s TmpCalcPath=""	// 若是link类型的，属性的值是存在link的id上的
	.f  s TmpCalcPath=$o(^CT.CKB.PDSS.CommonDictionI("Link",CalcPath,TmpCalcPath))  q:(TmpCalcPath="")||(ExistFlag=1)  d
	..s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,TmpCalcPath,""),-1)
	..s CalcPathItm=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+LinkID)),"^",3)
	..s CalcPathDesc=$lg($g(^CT.CKB.PDSS.CommonDictionD(+CalcPathItm)),2)
	..s PathFlag=$select(CalcPathDesc="isFalse":0,CalcPathDesc="isTrue":1,1:PathFlag)
	..s ExistFlag=1

	q PathFlag
}

/// Descript:取属性值
/// CreateDate:2021-04-17
/// Creator:sufan
/// w ##Class(web.DHCCKBCommon).GetDrugAttrId("RuleUsage")
ClassMethod GetDrugAttrId(code) As %String
{
	s DrugProp=##class(web.DHCCKBCommon).GetDrugProp()
	s RuleIndic=##class(web.DHCCKBCommon).GetDicIdByCode(code)
	q RuleIndic
	q:(+DrugProp=0)||(+RuleIndic=0) ""
	s DrugIndic=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",RuleIndic,DrugProp,""))
	q DrugIndic
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-19
/// Descript: 		获取目录的管理级别
/// Return:			
/// w ##class(web.DHCCKBCommon).GetLibaryManLevelProp()
ClassMethod GetLibaryManLevelProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LibaryManLevel")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-25
/// Descript: 		获取十八反目录id
/// Return:			
/// w ##class(web.DHCCKBCommon).GetEighteenTaboo()
ClassMethod GetEighteenTaboo() As %String
{
	s DrugLibaryData = ..GetDrugLibaryData()
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EighteenTaboo",DrugLibaryData)
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-04-25
/// Descript: 		获取十九畏目录id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetNineteenTaboo()
ClassMethod GetNineteenTaboo() As %String
{
	
	s DrugLibaryData = ..GetDrugLibaryData()
	q ##class(web.DHCCKBCommon).GetDicIdByCode("NineteenTaboo",DrugLibaryData)
}

/// Creator:		qunianpeng
/// CreatDate:		2020-05-6
/// Description:： 	批准文号
/// w ##class(web.DHCCKBCommon).GetApprovalNumberProp()
ClassMethod GetApprovalNumberProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ApprovalNumberProp")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-05-07
/// Descript:		使用code,desc,parref获取药品id
/// w ##class(web.DHCCKBCommon).GetDicIDByCodeDesc("注射用青霉素钠80万U(华北制药股份有限公司) ","注射用青霉素钠80万U(华北制药股份有限公司) ",105)
ClassMethod GetDicIDByCodeDesc(code, desc, parref) As %String
{
	n (code, desc, parref)
	
	q:(code="")||(desc="")||(+parref=0) ""
	s code=$SYSTEM.Util.Collation(code,6)
	s desc=$SYSTEM.Util.Collation(desc,6)
	q:(code="")||(desc="") ""
	
	s ret=0
	s id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Code",code,id))	q:id=""  d
	.s tmpparref=$lg($g(^CT.CKB.PDSS.CommonDictionD(id)),4)
	.q:(parref'="")&(parref'=tmpparref)
	.s descId = ""
	.f  s descId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",desc,descId)) q:descId=""  d
	..s descParref=$lg($g(^CT.CKB.PDSS.CommonDictionD(descId)),4)
	..q:(parref'="")&(parref'=descParref)
	..i id = descId  s ret=id
	
	q ret
}

/// Creator: 		qunianpeng
/// CreateDate: 	2021-05-07
/// Descript: 		获取处方应付id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetPrescriptionCopeProp()
ClassMethod GetPrescriptionCopeProp() As %String
{
	
	s DrugLibaryData = ..GetDrugLibaryData()
	q ##class(web.DHCCKBCommon).GetDicIdByCode("PrescriptionCopeProp")
}

/// Creator:		qunianpeng
/// CreatDate:		2021-05-07
/// Description:： 	获取中药饮片的处方应付
/// Input:			DicID药品id, flag(1 取id, 0 取描述)
/// Other:	w ##class(web.DHCCKBCommon).GetPrescCopeData(112807,0)
ClassMethod GetPrescCopeData(DicID, Flag = 1) As %String
{
	n (DicID,Flag)
	s PrescCopePropID=##class(web.DHCCKBCommon).GetPrescriptionCopeProp()   /// 药品处方应付属性
	
	// 获取药品的处方应付	
	s ListData=""
	s LinkID=""
	f  s LinkID=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",DicID,PrescCopePropID,LinkID))  q:LinkID=""  d
	.s ItmDicID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(LinkID)),4)
	.q:ItmDicID=""
	.i Flag=1 s $List(ListData,*+1)=ItmDicID
	.e  d
	..s DicLinkDr=$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),5)
	..s Desc=$case(+DicLinkDr'=0,1:$lg($g(^CT.CKB.PDSS.CommonDictionD(DicLinkDr)),3),:$lg($g(^CT.CKB.PDSS.CommonDictionD(ItmDicID)),3))
	..s $List(ListData,*+1)=Desc
	
	Q ListData
}

/// Creator:		qunianpeng
/// CreatDate:		2021-05-19
/// Description:： 	中药经方字典
/// w ##class(web.DHCCKBCommon).GetChinaMedPrescData()
ClassMethod GetChinaMedPrescData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChinaMedPrescData")
}

/// Descript: 科室审查
/// w ##class(web.DHCCKBCommon).GetDrugLocList()
ClassMethod GetDrugLocList() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("单科室审查(测试)")
}

/// Creator:		sunhuiyong
/// CreateDate: 	2021-6-10
/// Descript:	  获取医保分类分类id
/// w ##class(web.DHCCKBCommon).GetYBRepeat()
ClassMethod GetYBRepeat() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByDesc("医保分类")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		饮片名称
/// w ##class(web.DHCCKBCommon).GetchHerbalMedName()
ClassMethod GetchHerbalMedName() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("chHerbalMedName")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		功能主治
/// w ##class(web.DHCCKBCommon).GetFunIndicat()
ClassMethod GetFunIndicatNew() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("FunIndicat")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		拉丁名
/// w ##class(web.DHCCKBCommon).LatinNameProp()
ClassMethod GetLatinNameProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LatinNameProp")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		功效
/// w ##class(web.DHCCKBCommon).GetEfficacyProp()
ClassMethod GetEfficacyProp() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("EfficacyProp")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		方剂组成
/// w ##class(web.DHCCKBCommon).GetPrescContent()
ClassMethod GetPrescContent() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("PrescContent")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		主治病证
/// w ##class(web.DHCCKBCommon).GetPrescTreatDisease()
ClassMethod GetPrescTreatDisease() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("PrescTreatDisease")
}

/// Creator:		yuliping
/// CreateDate: 	2021-06-16
/// Descript:		相关文献
/// w ##class(web.DHCCKBCommon).GetLiterSupData()
ClassMethod GetLiterSupData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiterSup")
}

/// Creator:		sunhuiyong
/// CreateDate: 	2021-06-19
/// Descript:		相关文献字典
/// w ##class(web.DHCCKBCommon).GetLiterSupDataData()
ClassMethod GetLiterSupDataData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiterSupData")
}

/// Creator:		sunhuiyong
/// CreateDate: 	2021-06-19
/// Descript:		链接
/// w ##class(web.DHCCKBCommon).GetUrlData()
ClassMethod GetUrlData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiteUrl")
}

/// Creator:		sunhuiyong
/// CreateDate: 	2021-06-19
/// Descript:		出处
/// w ##class(web.DHCCKBCommon).GetOriginData()
ClassMethod GetOriginData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiteOrigin")
}

/// Creator:		sunhuiyong
/// CreateDate: 	2021-06-19
/// Descript:		简介
/// w ##class(web.DHCCKBCommon).GetLiteShortDescData()
ClassMethod GetLiteShortDescData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiteShortDesc")
}

/// Creator:		sunhuiyong
/// CreateDate: 	2021-06-19
/// Descript:		发布日期
/// w ##class(web.DHCCKBCommon).GetLiteDateData()
ClassMethod GetLiteDateData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiteDate")
}

/// Descript: 医保分类
/// w ##class(web.DHCCKBCommon).GetHealthclass()
ClassMethod GetHealthclass() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("医保分类")
}

/// Creator:		qunianpeng
/// CreateDate: 	2021-05-29
/// Descript:		获取字典的显示名称
/// w ##class(web.DHCCKBCommon).GetShowName(74540)
ClassMethod GetShowName(dicID) As %String
{
	n (dicID)
	s showNameProp = ..GetDicIdByCode("ShowName")
	s dicLinkDr = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,showNameProp,""))
	s result = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+dicLinkDr)),5)
	i result'="" Q result
	e  q $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	// ^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",{DLA_Dic_Dr},{DLA_AttrCode}
	//q $lg($g(^CT.CKB.PDSS.CommonDictionD(+dicID)),3)
	q ""
}

/// Descript: 处方应付
/// w ##class(web.DHCCKBCommon).PrescriptionCopeData()
ClassMethod PrescriptionCopeData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("PrescriptionCopeData")
}

/// Description:	通过药品类型过滤掉其他类型药品字典。如入参是草药,不希望查到西药和中成药
/// Creator:		qunianpeng
/// CreateDate:		2021-06-24	
/// Input:			需要展示的药品类型,需要过滤掉药品类型		
/// Return:			1 过滤 0 不过滤
/// other:			
/// w ##class(web.DHCCKBCommon).CheckDrugType()
ClassMethod CheckDrugType(drugType, drugData) As %String
{
	n (drugType,drugData)
	
	s ret=0
	q:drugType=""||(drugData="") ret
	i drugType="Herbal" d	// 草药
	.i (drugData["药品")||(drugData["西药")||(drugData["中成药")||(drugData["通用名字典") s ret=1
	e  i drugType="WesternMed" d	// 西药
	.i (drugData["中药饮片")||(drugData["中成药") s ret=1
	e  i drugType="ChinaMed" d	//中成药
	.i (drugData["中药饮片")||(drugData["药品")||(drugData["西药") s ret=1
	
	q ret
}

/// Description:	中药饮片实体
/// Creator:		qunianpeng
/// CreateDate:		2021-06-24	
/// Input:			
/// Return:		
/// other:			
/// w ##class(web.DHCCKBCommon).GetChineseHerbalMedicine()
ClassMethod GetChineseHerbalMedicine() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseHerbalMedicine")
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-07-02
/// Description:： 	同源药品(中成药)
/// w ##class(web.DHCCKBCommon).GetComOrignDrugData()
ClassMethod GetComOrignDrugData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ComOriginDrug")
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-07-02
/// Description:： 	同源药品(西药)
/// w ##class(web.DHCCKBCommon).GetComOrignDrugDataXY()
ClassMethod GetComOrignDrugDataXY() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ComOriginDrug",19)
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-07-02
/// Description:： 	中成药规格
/// w ##class(web.DHCCKBCommon).GetChineseSpecData()
ClassMethod GetChineseSpecData() As %String
{
	s Chinese= ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugProp")
	s Spec = ##class(web.DHCCKBCommon).GetDicIdByCode("SpecificationProp")
	s Result=""
	s Result=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",Spec,Chinese,Result))
	q Result
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-07-02
/// Description:： 	中成药批准文号
/// w ##class(web.DHCCKBCommon).GetChineseAppData()
ClassMethod GetChineseAppData() As %String
{
	s Chinese= ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugProp")
	s App = ##class(web.DHCCKBCommon).GetApprovalNumberProp()
	s Result=""
	s Result=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",App,Chinese,Result))
	q Result
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-07-02
/// Description:： 	中成药通用名（带剂型）
/// w ##class(web.DHCCKBCommon).GetChineseGeneralFromProp()
ClassMethod GetChineseGeneralFromProp() As %String
{
	s Chinese= ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugProp")
	s App = ##class(web.DHCCKBCommon).GetGeneralFromProp()
	s Result=""
	s Result=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",App,Chinese,Result))
	q Result
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-07-02
/// Description:： 	中成药生产厂家
/// w ##class(web.DHCCKBCommon).GetChineseDrugManf()
ClassMethod GetChineseDrugManf() As %String
{
	s Chinese= ##class(web.DHCCKBCommon).GetDicIdByCode("ChineseDrugProp")
	s App = ##class(web.DHCCKBCommon).GetDrugManf()
	s Result=""
	s Result=$o(^CT.CKB.PDSS.CommonDictionI("LinkParrefDr",App,Chinese,Result))
	q Result
}

/// Creator:		qunianpeng
/// CreatDate:		2021-07-14
/// Description:： 	新编药物学分类
/// w ##class(web.DHCCKBCommon).GetNewDrugCatId()
ClassMethod GetNewDrugCatId() As %String
{
	q ..GetDicIdByCode("NewDrugCat")
}

/// Description:	判断字典维护界面核实人
/// Creator:		sunhuiyong
/// CreateDate:		2021-07-30	
/// Input:			dicID 
/// return:			"":无核实人记录  name： 核实人
/// other:			w ##class(web.DHCCKBCommon).GetConfirmPerson("27142")
ClassMethod GetConfirmPerson(dicID)
{
	n (dicID)
	q:+dicID=0 0
	s confirmPerson=""  //核实人
	s importDate="2021-08-02"
	s importDate=$zdh(importDate,3)
	s importName="方亮"
	s importUserId=$o(^SSU("SSUSR",0,"SSUSR_Name",importName,""))
	s glgID=""
	f  s glgID=$o(^CKB.PDSS.DicLogI("DLGDataDr",dicID,glgID),-1)  q:(glgID="")  d
	.s listData = $g(^CKB.PDSS.DicLogD(glgID))
	.s glgFunction= $lg(listData,4)   //功能
	.s glgOperator= $lg(listData,5)   //操作人
	.s glgDate= $lg(listData,6)      //操作日期
	.i (glgFunction="confirm")&&(glgOperator=1) d
	..s confirmPerson=confirmPerson_","_"姚(一批)"
	.e  d
	..i (glgFunction="confirm")&&(glgOperator=importUserId)&&(glgDate=importDate) d
	...s confirmPerson=confirmPerson_","_"方(二批)"
	..e  d
	...s:(glgFunction="confirm")&&(glgOperator'="")&&($p($g(^SSU("SSUSR",glgOperator)),"^",2)'="") confirmPerson=confirmPerson_","_$p($g(^SSU("SSUSR",glgOperator)),"^",2)
	s:$e(confirmPerson,1)="," $e(confirmPerson,1)=""
	q confirmPerson
}

/// Description:	判断数据映射界面导入核实标记（临时用）
/// Creator:		sunhuiyong
/// CreateDate:		2021-07-30	
/// Input:			consID
/// return:			0    1本次核实
/// other:			w ##class(web.DHCCKBCommon).GetConfirmConsFlag("560370")
ClassMethod GetConfirmConsFlag(consID)
{
	n (consID)
	q:+consID=0 0
	s confirmFlag=0
	s importDate="2021-08-02"
	s importDate=$zdh(importDate,3)
	s importName="方亮"
	s importUserId=$o(^SSU("SSUSR",0,"SSUSR_Name",importName,""))
	s glgID=""
	f  s glgID=$o(^CKB.PDSS.DicLogI("DLGDataDr",consID,glgID),-1)  q:(glgID="")||(confirmFlag'=0)  d
	.s listData = $g(^CKB.PDSS.DicLogD(glgID))
	.s glgFunction= $lg(listData,4)    //功能
	.s glgOperator= $lg(listData,5)    //操作人
	.s glgDate= $lg(listData,6)        //操作日期
	.;第二批导入取方工用户id，日期取2021-7-31  
	.i (glgFunction="add")&&(glgOperator=importUserId)&&(glgDate=importDate) d
	..s confirmFlag=1
	
	q confirmFlag
}

/// Descript:  文本域
/// w ##class(web.DHCCKBCommon).GetTextArea()
ClassMethod GetTextArea() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("textarea")
}

/// Descript:  下拉框
/// w ##class(web.DHCCKBCommon).GetCombobox()
ClassMethod GetCombobox() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("combobox")
}

/// Description:	判断his的代码和描述获取对照后的系统id
/// Creator:		qunianpeng
/// CreateDate:		2021-08-26	
/// Input:			
/// return:			id
/// other:			w ##class(web.DHCCKBCommon).GetDrugIdByHisCode("ZCY0000023","补中益气丸[200s 浓缩丸]")
ClassMethod GetDrugIdByHisCode(IncCode, IncDesc) As %String
{
	n (IncCode,IncDesc)
	s IncId = ""
	s IncIdList=##Class(web.DHCCKBPassNew).GetComDicIdNew(IncCode,"Drug","")	
    i $listlength(IncIdList)=1 s IncId=$listget(IncIdList)	
    q:IncId'="" IncId    
    i ($listlength(IncIdList)>1)&((IncCode="")||(IncDesc="")) s IncId=$listget(IncIdList,$listlength(IncIdList))
    q:IncId'="" IncId    
 	q:(IncCode="")||(IncDesc="") "" 
    s drugData = ##class(web.DHCCKBCommon).GetDrugData()
    s libStr = ##class(web.DHCCKBComContrast).GetSysConst(IncCode,IncDesc,drugData)
   	s libCode = $p(libStr,"^",1)
    s IncId = ##class(web.DHCCKBCommon).GetDicIdByCode(libCode,drugData)
    q:IncId'="" IncId
    s chinaDrugData = ##class(web.DHCCKBCommon).GetChineseDrugData()
    s libStr = ##class(web.DHCCKBComContrast).GetSysConst(IncCode,IncDesc,chinaDrugData)
    s libCode = $p(libStr,"^",1)
    s IncId = ##class(web.DHCCKBCommon).GetDicIdByCode(libCode,chinaDrugData)
	q:IncId'="" IncId
	
	q ""
}

/// Descript:  中药饮片-处方应付模板
/// w ##class(web.DHCCKBCommon).GetPrescriptionCopeMode()
ClassMethod GetPrescriptionCopeMode() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("中药饮片-处方应付模板")
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-04
/// Description:： 	判断规则是否修改
/// Input:	rule:规则id
/// Return: 1 修改过 0 未修改
/// Other:	w ##class(web.DHCCKBTest).IsRuleUpdateFlag()
ClassMethod IsRuleUpdateFlag(rule)
{
	
	n (rule)
	
	s count = 0 
	s flag = 0
	s ruleLogId=""	// 兜底规则修改过的不能删除
	f  s ruleLogId=$o(^CKB.PDSS.RuleLogI("Rule",rule,ruleLogId))  q:(ruleLogId="")||(count>2)  d
	.s count = count + 1
	.i count>2  s flag = 1
	.q:count>2
	
	q flag
}

/// Creator:		sunhuiyong
/// CreatDate:		2021-11-29
/// Description:： 	获取ICD来源
/// w ##class(web.DHCCKBCommon).GetICDResData()
ClassMethod GetICDResData() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("ICDSource")
}

/// Creator:		qunianpeng
/// CreatDate:		2021-11-04
/// Description:： 	通过实体代码获取外部代码表id
/// Input:			外部代码表code,医院id
/// Return: 		id或0
/// Other:			w ##class(web.DHCCKBCommon).GetExtDicIdByCode("DiseaseData","")
ClassMethod GetExtDicIdByCode(code, hospId = "") As %String
{
		n (code,hospId)
		s:hospId="" hospId=-100000000000000
		
		q:code="" 0
		q:'$d(^CKB.PDSS.ExtDictionI("Code",hospId,code)) 0
		q:'$d(^CKB.PDSS.ExtDictionI("Type",hospId,code)) 0
		//s code=$SYSTEM.Util.Collation(code,6)		
		//q:'$d(^CKB.PDSS.ExtDictionI("Code",hospId,$$ALPHAUP^SSUTIL4(code))) ""
		//q:'$d(^CKB.PDSS.ExtDictionI("Type",hospId,$$ALPHAUP^SSUTIL4(code))) ""
		s ret=0
		s id=""
		f  s id=$o(^CKB.PDSS.ExtDictionI("Code",hospId,code,id))	q:id=""  d
		.s ret=id
	
		q ret
}

/// Description:： 	使用代码和描述获取系统数据id
/// Creator:		qunianpeng
/// CreatDate:		2022-02-09
/// Input:			编码,描述
/// w ##class(web.DHCCKBCommon).GetDicIDByCodeAndDesc("ATC分类","ATC分类","")
ClassMethod GetDicIDByCodeAndDesc(code, desc, parref = "") As %String
{
	n (code,desc,parref)
	
	q:code="" ""
	s code=$SYSTEM.Util.Collation(code,6)
	q:code="" 0
	
	s desc=$SYSTEM.Util.Collation(desc,6)
	q:desc="" 0	
	
	s ret=0
	s codeId=""
	f  s codeId=$o(^CT.CKB.PDSS.CommonDictionI("Code",$$ALPHAUP^SSUTIL4(code),codeId))	q:(codeId="")||(ret'=0)  d
	.s tmpparref=$lg($g(^CT.CKB.PDSS.CommonDictionD(codeId)),4)
	.q:(parref'="")&(parref'=tmpparref)
	.// 使用名称查找	
	.s descId=""
	.f  s descId=$o(^CT.CKB.PDSS.CommonDictionI("Desc",$$ALPHAUP^SSUTIL4(desc),descId))	q:(descId="")||(ret'=0)  d
	..s tmpparref=$lg($g(^CT.CKB.PDSS.CommonDictionD(descId)),4)
	..q:(parref'="")&(parref'=tmpparref)
	..i descId=codeId  s ret = descId
	
	q ret
}

/// Descript:	获取同源药品(本源)
/// Creator:	qunianpeng
/// CreateDate:	2022-02-24
/// w ##Class(web.DHCCKBCommon).GetComOriginDrug(128110)
ClassMethod GetComOriginDrug(drugId)
{
	n (drugId)
	q:drugId="" ""
	s parref = ##class(web.DHCCKBCommon).GetDicIdByCode("DrugProp")
	s comOriginDrug = ##class(web.DHCCKBCommon).GetDicIdByCode("ComOriginDrug",parref)
	s:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",+drugId,+comOriginDrug)) comOriginDrug=##class(web.DHCCKBCommon).GetComOrignDrugData()
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("Reverse",+drugId,+comOriginDrug)) drugId
	s comID = ""
	s rowID = ""
	f  s rowID = $o(^CT.CKB.PDSS.DicLinkAttrI("Reverse",+drugId,+comOriginDrug,rowID)) q:(rowID="")||(comID'="")  d
	.s comID=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(+rowID)),2)
	
	q:+comID'=0 comID
	
	q drugId
}

/// Descript:	获取目录下的项目的提示级别
/// Creator:	qunianpeng
/// CreateDate:	2022-03-27
/// w ##Class(web.DHCCKBCommon).GetLabelItmLevel(91228,91370)
ClassMethod GetLabelItmLevel(label, itmId)
{
	
	n (label,itmId)	
	q:label="" ""
	s levelCode=""
	s prop=##class(web.DHCCKBCommon).GetCheckItmListProp()		  // 项目列表属性
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",label,prop)) ""
	q:'$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",label,prop,itmId)) ""
	s remindLevelId = ##class(web.DHCCKBCommon).GetDicIdByCode("LevelFlag") // 提醒消息级别id
	
	s link="" 
	f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",label,prop,link)) q:link=""  d
	.s attrDr = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+link)),4)
	.q:attrDr'=itmId	// 计算项目
	.
	.q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,remindLevelId))
	.s levelAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",link,remindLevelId,""))
	.s level="",levelCode=""
	.s:levelAttrId'="" level=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(levelAttrId)),4)
	.s:level'="" levelCode = $lg($g(^CT.CKB.PDSS.CommonDictionD(+level)),2)
	
	q levelCode
}

/// Descript:	获取有规则的计算目录(排序)
/// Creator:	qunianpeng
/// CreateDate:	2022-03-27
/// Input:		规则类型,用户信息,flag(0:输出id, 1:输出描述, 2: id,描述)
/// w ##Class(web.DHCCKBCommon).GetSortLibaryList(0)
ClassMethod GetSortLibaryList(ruleType = "", userInfo = 0, flag = 0)
{
	
	n (ruleType,userInfo,flag)
	
	k TmpArr
	s drugLibary=##class(web.DHCCKBCommon).GetDrugLibaryData()
	s calcOrderNum=##class(web.DHCCKBCommon).GetDicIdByCode("CalcOrderNum")
	
	s libaryList = "",count = 0, libaryExtList="", libaryUnionList=""
	s id="" 
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",drugLibary,id)) q:id=""  d
	.q:+id=0
	.q:0=##class(web.DHCCKBCommon).IsShow(id,"DHC_CKBCommonDiction",userInfo)	
	.q:'$d(^CT.CKB.PDSS.DrugLibaryRefI("LibaryRule",id))			// 目录下没有规则
	.s labRuleType=##class(web.DHCCKBCommon).GetRuleType(id)	// 规则类型
	.q:(ruleType'="")&(ruleType'=labRuleType)					// 区分审查规则和教育规则
	.s count = count + 1
	.s num=""
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",id,calcOrderNum))  d
	..s dlaRowID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",id,calcOrderNum,""))
	..s num = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(+dlaRowID)),5)
	..s:num="" num = 999+count
	.e  d
	..s num = 999+count
	.
	.s TmpArr("num",num) = id
	.s TmpArr("count")=count	
	.//i $lf(libaryList,id)=0 s $list(libaryList,*+1) = id 
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",id))  d
	..d ..GetLibaryTreeSubNode(.TmpArr,id,ruleType,userInfo)
	
	s index = ""
	f  s index = $o(TmpArr("num",index))  q:index=""  d
	.s id=$g(TmpArr("num",index))
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)
	.i $lf(libaryList,id)=0 s $list(libaryList,*+1) = id 
	.i (desc'="")&&($lf(libaryExtList,desc)=0) s $list(libaryExtList,*+1) = desc 
	.s tmp = id_"^"_desc
	.i (tmp'="")&&($lf(libaryUnionList,tmp)=0) s $list(libaryUnionList,*+1) = tmp 
	
	q:flag=0 libaryList
	q:flag=1 libaryExtList
	q:flag=2 libaryUnionList
	
	q libaryList
}

/// Descript:	获取目录的子层目录
/// Creator:	qunianpeng
/// CreateDate:	2022-03-27
/// w ##Class(web.DHCCKBCommon).GetLibaryTreeSubNode(120061,39)
ClassMethod GetLibaryTreeSubNode(TmpArr, parrefId, ruleType, userInfo = 0)
{
	n (TmpArr,parrefId,ruleType,userInfo)
	s count = $g(TmpArr("count"))
	s calcOrderNum=##class(web.DHCCKBCommon).GetDicIdByCode("CalcOrderNum")
	
	s subId = ""
	for  s subId = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefId,subId)) Q:subId=""  d
	.q:0=##class(web.DHCCKBCommon).IsShow(subId,"DHC_CKBCommonDiction",userInfo)	
	.q:'$d(^CT.CKB.PDSS.DrugLibaryRefI("LibaryRule",subId))		// 目录下没有规则
	.s labRuleType=##class(web.DHCCKBCommon).GetRuleType(subId)	// 规则类型
	.q:(ruleType'="")&(ruleType'=labRuleType)					// 区分审查规则和教育规则
	.s count = count + 1
	.i $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",subId,calcOrderNum))  d
	..s dlaRowID = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",subId,calcOrderNum,""))
	..s num = $lg($g(^CT.CKB.PDSS.DicLinkAttrD(dlaRowID)),5)
	..s:num="" num = 999+count
	.e  d
	..s num = 999+count
	.
	.s TmpArr("num",num) = subId
	.s TmpArr("count")=count
	.//i $lf(libaryList,subId)=0 s $list(libaryList,*+1) = subId 
	.i $d(^CT.CKB.PDSS.CommonDictionI("Parref",subId))  d
  	..d ..GetLibaryTreeSubNode(.libaryList,subId,userInfo)
  	
  	q ""
}

/// Creator: 		sufan
/// CreateDate: 	2022-04-25
/// Descript: 		获取适应症目录id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetRuleIndic()
ClassMethod GetRuleIndic() As %String
{
	
	s DrugLibaryData = ..GetDrugLibaryData()
	q ##class(web.DHCCKBCommon).GetDicIdByCode("RuleIndic",DrugLibaryData)
}

/// Creator: 		sufan
/// CreateDate: 	2022-04-25
/// Descript: 		获取成分累积量属性Id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetIngrSumDosage()
ClassMethod GetIngrSumDosage()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("IngrSumDosage")
}

/// Creator: 		sufan
/// CreateDate: 	2022-04-25
/// Descript: 		重复用药管理级别
/// Return:				
/// w ##class(web.DHCCKBCommon).GetRepeatDrugLevel()
ClassMethod GetRepeatDrugLevel()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("RepeatDrugLevel")
}

/// Creator: 		sufan
/// CreateDate: 	2022-05-19
/// Descript: 		获取相同通用名的药品，且为基本药物
/// Return:				
/// w ##class(web.DHCCKBCommon).GetDrugListByGenName()
ClassMethod GetDrugListByGenName(generIdList, hospitalId = "")
{
	n (generIdList,hospitalId)
	k DrugList
	s DrugList = ""
	Q:$listlength(generIdList)=0 DrugList
	s len = $listlength(generIdList)
	for i=1:1:len  d
	.s generId = $list(generIdList,i)
	.Q:'$d(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",generId))
	.s attrId = ""
	.for  s attrId = $o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttr",generId,attrId)) Q:attrId=""  d
	..s DrugId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),2)
	..Q:+DrugId=0    
	..Q:'$d(^CT.CKB.PDSS.CommonDictionD(DrugId))
	..Q:0=##class(web.DHCCKBCommon).IsEnabled(DrugId)	// 过滤停用
	..s conFlag = ##class(web.DHCCKBComContrast).IsSysContrast(DrugId,hospitalId)
	..Q:conFlag=0
	..s $LIST(DrugList,*+1)=DrugId
	Q DrugList
}

/// Creator: 		sufan
/// CreateDate: 	2022-06-24
/// Descript: 		获取用法用量目录id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetRuleUsage()
ClassMethod GetRuleUsage() As %String
{
	
	s DrugLibaryData = ..GetDrugLibaryData()
	q ##class(web.DHCCKBCommon).GetDicIdByCode("RuleUsage",DrugLibaryData)
}

/// Creator: 		sufan
/// CreateDate: 	2022-06-24
/// Descript: 		获取液体配置目录id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetLiquidConfig()
ClassMethod GetLiquidConfig() As %String
{
	
	s DrugLibaryData = ..GetDrugLibaryData()
	q ##class(web.DHCCKBCommon).GetDicIdByCode("LiquidConfig",DrugLibaryData)
}

/// Descript:知识来源
/// w ##class(web.DHCCKBCommon).GetKnowSource()
ClassMethod GetKnowSource() As %String
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("KnowSource")
}

/// Creator: 		qunianpeng
/// CreateDate: 	2022-08-29
/// Descript: 		权限类型分类(类别) 默认返回数组.需要字符串flag=1即可.返回格式:key1:value1,key2:value2
/// Return:				
/// w ##class(web.DHCCKBCommon).GetAuthCat()
ClassMethod GetAuthCat(flag = 0) As %String
{
	s authCatArr = []
	
	s authList = $lb("ModelFlag:实体","AttrFlag:属性","DictionFlag:字典","GeneralRule:普通规则","DictionRule:术语规则","GlobalRule:全局规则")
	q:flag=1 $listtostring(authList) // 需要字符串flag=1即可
	f i=1:1:$ll(authList)  d
	.s itemstr = $lg(authList,i)
	.s key = $p(itemstr,":",1)
	.s value = $p(itemstr,":",2)
	.s itmObj={}
	.d itmObj.%Set(key,value)
	.d authCatArr.%Push(itmObj)
	q authCatArr.%ToJSON()
}

/// Creator: 	    Shy
/// CreateDate: 	2022-11-03
/// Descript: 		获取只可配伍属性Id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetMustUse()
ClassMethod GetMustUse()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("MustUse")
}

/// Creator: 	    Shy
/// CreateDate: 	2022-11-03
/// Descript: 		获取禁止属性Id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetForbidProp()
ClassMethod GetForbidProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("forbid")
}

/// Creator: 	    Shy
/// CreateDate: 	2022-11-03
/// Descript: 		获取必须稀释后给药属性Id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetDiluteProp()
ClassMethod GetDiluteProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("DiluteProp")
}

/// Creator: 	    qunianpeng
/// CreateDate: 	2022-11-25
/// Descript: 		是否有用药指导规则
/// Input:			dicId(药品id)
/// Return:			1是 0否	
/// w ##class(web.DHCCKBCommon).IsExistGuideRule(154)
ClassMethod IsExistGuideRule(dicID)
{
	n (dicID)
	
	s ret = 0
	k TmpArr
	s guideId = ##class(web.DHCCKBCommon).GetDicIdByCode("用药指导")
	d ##class(web.DHCCKBRuleIndex).QueryAllCatDic(.TmpArr,guideId)

	s index = ""
	f  s index = $o(TmpArr(index))  q:(index="")||(ret=1)  d
	.i $d(^CT.CKB.PDSS.DrugLibaryRefI("DrugLibRule",dicID,index))  d
	..s ret = 1
	
	q ret
}

/// Creator: 	    Shy
/// CreateDate: 	2022-12-02
/// Descript: 		获取知识浏览属性Id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetInstruProp()
ClassMethod GetInstruProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("InstruProp")
}

/// Creator: 	    Shy
/// CreateDate: 	2022-12-02
/// Descript: 		获取知识浏览信息栏属性Id
/// Return:				
/// w ##class(web.DHCCKBCommon).GetInstruTitleProp()
ClassMethod GetInstruTitleProp()
{
	q ##class(web.DHCCKBCommon).GetDicIdByCode("InstruTitleProp")
}

/// Creator: 	    qunianpeng
/// CreateDate: 	2023-05-10
/// Descript: 		判断数据是不是字典
/// Return:			1是  0 否	
/// w ##class(web.DHCCKBCommon).CheckDictionFlag()
ClassMethod CheckDictionFlag(id) As %String
{
	n (id)
	
	s ret = 0
	s knowType=##class(web.DHCCKBCommon).GetKnowType() //知识类型
	s dictionFlag=##class(web.DHCCKBCommon).GetDictionFlag()  //字典类型
	
	q:$d(^CT.CKB.PDSS.DicLinkAttrI("DicAttr",id,knowType,dictionFlag)) 1
	
	q ret
}

/// Creator: 	    qunianpeng
/// CreateDate: 	2023-05-16
/// Descript: 		通过字典id,获取字典详细数据
/// Return:			字典数据list
/// w ##class(web.DHCCKBCommon).GetDataListByParref()
ClassMethod GetDataListByParref(parref) As %String
{
	n (parref)
	q:parref="" ""
	s listData="",id=""
	f  s id=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,id))  q:id=""  d
	.s code = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),2)
	.s desc = $lg($g(^CT.CKB.PDSS.CommonDictionD(+id)),3)
	.q:desc=""
	.s $list(listData,*+1)=desc
	
	q listData
}

}

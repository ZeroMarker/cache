/// 名称:基础数据平台组知识库数据导出。 
/// 编写者:基础数据平台组 - 谷雪萍
/// 编写日期:2017-2-13
Class web.DHCBL.BDP.ExportKBData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCBL.BDP.ExportKBData).GetSSUserTitle()
ClassMethod GetTitle(table As %String) As %String
{
	s str=""
	if (table="2")
	{
		s str="知识库标识代码&%知识库标识描述&%是否可用"
	}
	if (table="3")
	{
		s str="知识库目录代码&%知识库目录描述&%知识库标识&%顺序&%管理模式&%图标路径&%是否全部通过&%提示消息&%在药品通用名目录显示&%在商品通用名目录显示"
	}
	if (table="4")
	{
		s str="HIS库频率代码&%HIS库频率描述&%知识库代码&%知识库描述"
	}
	if (table="5")
	{
		s str="HIS库剂型代码&%HIS库剂型描述&%知识库剂型代码&%知识库剂型描述"
	}
	if (table="6")
	{
		s str="HIS库用法代码&%HIS库用法描述&%知识库代码&%知识库描述"
	}
	if (table="7")
	{
		s str="HIS库单位代码&%HIS库单位描述&%知识库单位代码&%知识库单位描述"
	}
	if (table="8")
	{
		s str="分类代码&%分类描述&%知识库标识&%上级分类&%级别&%是否可用&%是否系统标识"
	}
	if (table="9")
	{
		s str="HIS库诊断代码&%HIS库诊断描述&%知识库诊断代码&%知识库诊断描述&%类型&%关键字"
	}
	if (table="10")
	{
		s str="特殊人群代码&%特殊人群描述"
	}
	if (table="11")
	{
		s str="药品成分代码&%药品成分描述&%上级分类&%级别&%是否可用&%是否系统标识&%关系&%配液整组含量"
	}
	if (table="12")
	{
		s str="生理代码&%生理描述&%类型&%是否可用&%是否系统标识"
	}
	if (table="13")
	{
		s str="知识库病症代码&%知识库病症描述&%拼音码&%常用名&%常用名拼音码&%别名&%备注&%知识库icd代码"
	}
	if (table="14")
	{
		s str="年龄代码&%年龄描述&%最小值&%最大值&%单位&%是否可用&%系统标识"
	}
	if (table="15")
	{
		s str="过敏史代码&%过敏史描述&%别名"
	}
	if (table="16")
	{
		s str="既往史代码&%既往史描述&%别名"
	}
	if (table="17")
	{
		s str="HIS通用名代码&%HIS通用名描述&%知识库通用名代码&%知识库通用名描述&%别名&%剂型&%知识库标识&%ATC编码&%分类&%成分&%主要成分标识"
	}
	if (table="18")
	{
		s str="控制级别&%通用名&%剂型&%适应症&%年龄&%年龄限制&%性别&%描述说明&%提示（医生）&%备注&%病症体征&%治疗手术&%检验项目&%备注&%指标值范围&%指标值范围单位&%细菌&%菌属"
	}
	if (table="19")
	{
		s str="控制级别&%通用名&%剂型&%禁忌症&%年龄&%年龄限制&%既往史&%成分&%生理参数&%生理参数（下限-上限）&%性别&%特殊人群&%过敏史&%描述说明&%提示（医生）&%备注&%类型&%检验项目&%指标值范围&%指标值范围单位&%病症体征&%治疗手术"
	}
	if (table="20")
	{
		s str="控制级别&%通用名&%剂型&%给药途径&%年龄&%年龄限制&%禁用&%提示消息"
	}
	if (table="21")
	{
		s str="控制级别&%通用名&%剂型&%给药频次&%年龄&%年龄限制&%禁用&%提示消息"
	}
	if (table="22")
	{
		s str="控制级别&%通用名&%剂型&%年龄&%年龄限制&%病症&%性别&%特殊人群&%用法&%每日服药次数&%单次服药量&%单次服药量单位&%每日服药总量&%每日服药总量单位&%每次最大量&%每次最大量单位&%每日最大量&%每日最大量单位&%提示（医生）&%提示（护士患者）&%文本描述&%首次服药量&%首次服药量单位&%连用量&%连用量单位&%服药间隔&%服药间隔单位&%体重&%体表面积&%检验项目&%指标值范围&%指标值范围单位"
	}
	if (table="23")
	{
		s str="控制级别&%通用名&%剂型&%存在相互作用通用名&%存在相互作用分类&%本文描述&%医嘱标识"
	}
	if (table="24")
	{
		s str="通用名&%剂型&%不良反应"
	}
	if (table="25")
	{
		s str="通用名&%剂型&%注意事项"
	}
	if (table="26")
	{
		s str="HIS库商品名代码&%HIS库商品名描述&%知识库代码&%知识库描述&%剂型&%厂家&%通用名&%毒性"
	}
	if (table="27")
	{
		s str="代码&%描述&%是否可用"
	}
	if (table="28")
	{
		s str="商品名&%溶媒分类"
	}
	if (table="29")
	{
		s str="代码&%描述&%是否可用&%是否系统标识"
	}
	if (table="30")
	{
		s str="HIS库科室代码&%HIS库科室描述&%知识库科室代码&%知识库科室描述"
	}
	if (table="31")
	{
		s str="HIS库症状代码&%HIS库症状描述&%知识库症状代码&%知识库症状描述"
	}
	if (table="32")
	{
		s str="HIS库证型代码&%HIS库证型描述&%知识库证型代码&%知识库证型描述"
	}
	if (table="33")
	{
		s str="知识库通用名&%知识库剂型&%商品名&%溶媒分类&%最小值&%最大值&%单位&%描述&%级别"
	}
	if (table="34")
	{
		s str="知识库通用名&%知识库剂型&%商品名&%控制级别&%关联溶媒药品&%逻辑&%单支溶媒量&%单位&%描述&%浓度范围最小值&%浓度范围最大值"
	}
	if (table="35")
	{
		s str="知识库通用名&%知识库剂型&%商品名&%组号&%可配伍药品&%溶媒分类&%描述&%控制级别"
	}
	if (table="36")
	{
		s str="知识库通用名&%知识库剂型&%商品名&%单支药品成分&%单支成分含量&%单支成分含量单位&%整组液体量&%整组液体量&%描述"
	}
	if (table="37")
	{
		s str="知识库通用名&%知识库剂型&%商品名&%关联液体&%必用药品名称&%限定&%必用药品剂量&%单位&%描述"
	}
	if (table="38")
	{
		s str="知识库通用名&%知识库剂型&%商品名&%辅助用药个数&%描述"
	}
	if (table="39")
	{
		s str="代码&%描述&%是否可用"
	}
	if (table="40")
	{
		s str="知识库通用名&%知识库剂型&%商品名（通用名+规格）&%规则&%商品名（多选用/分开）&%级别&%描述&%控制级别"
	}
	if (table="41")
	{
		s str="控制级别&%通用名&%剂型&%配伍禁忌通用名&%配伍禁忌分类&%本文描述&%医嘱标识"
	}
	if (table="42")
	{
		s str="通用名&%剂型&%描述"
	}
	if (table="43")
	{
		s str="代码&%描述&%是否可用"
	}
	if (table="44")
	{
		s str="代码&%描述&%是否可用"
	}
	q str
}

/// w ##class(web.DHCBL.BDP.ExportKBData).GetCount("SS_User")
ClassMethod GetCount(table) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelCount()
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetInstLabelCount()
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtFreqCount()
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtFormCount()
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtInstrucCount()
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtUomCount()
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetLibCatCount()
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetIcdFeildCount()
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSpecialPopuCount()
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtIngrCount()
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetPhysiologyCount()
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseCount()
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAgeCount()
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAllergyCount()
	}
	if (table="16")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetHistoryCount()
	}
	if (table="17")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetGenericCount()
	}
	if (table="18")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseIndCount()
	}
	if (table="19")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseConCount()
	}
	if (table="20")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseUseCount()
	}
	if (table="21")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseFreqCount()
	}
	if (table="22")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetUsageDosageCount()
	}
	if (table="23")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInteractCount()
	}
	if (table="24")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDARCount()
	}
	if (table="25")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDMHACount()
	}
	if (table="26")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetProNameCount()
	}
	if (table="27")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMenstruumCatCount()
	}
	if (table="28")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMenstruumItmCount()
	}
	if (table="29")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtSqecCount()
	}
	if (table="30")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetHospLocCount()
	}
	if (table="31")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSymptomCount()
	}
	if (table="32")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSyndromeCount()
	}
	if (table="33")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMenstruumQtyCount()
	}
	if (table="34")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDrgSolventCount()
	}
	if (table="35")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDrgAloneCount()
	}
	if (table="36")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetEleConCount()
	}
	if (table="37")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMustDrugCount()
	}
	if (table="38")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAssDrugNumCount()
	}
	if (table="39")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetRepeatFeildCount()
	}
	if (table="40")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetRepeatItmCount()
	}
	if (table="41")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDrugContrainCount()
	}
	if (table="42")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetProcessingActCount()
	}
	if (table="43")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetPHManfCount()
	}
	if (table="44")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetPHToxicityCount()
	}
	q rs
}

/// w ##class(web.DHCBL.BDP.ExportKBData).GetName("SS_User")
ClassMethod GetName(table) As %String
{
	s rs=""
	if (table="2")
	{
		s rs="知识库标识字典"
	}
	if (table="3")
	{
		s rs="知识库目录字典"
	}
	if (table="4")
	{
		s rs="频率字典"
	}
	if (table="5")
	{
		s rs="剂型字典对照"
	}
	if (table="6")
	{
		s rs="用法字典对照"
	}
	if (table="7")
	{
		s rs="单位字典对照"
	}
	if (table="8")
	{
		s rs="分类类型字典"
	}
	if (table="9")
	{
		s rs="诊断字典对照"
	}
	if (table="10")
	{
		s rs="特殊人群字典"
	}
	if (table="11")
	{
		s rs="药品成分字典"
	}
	if (table="12")
	{
		s rs="生理字典"
	}
	if (table="13")
	{
		s rs="病症字典"
	}
	if (table="14")
	{
		s rs="年龄字典"
	}
	if (table="15")
	{
		s rs="过敏史"
	}
	if (table="16")
	{
		s rs="既往史"
	}
	if (table="17")
	{
		s rs="通用名"
	}
	if (table="18")
	{
		s rs="适应症"
	}
	if (table="19")
	{
		s rs="禁忌症"
	}
	if (table="20")
	{
		s rs="给药途径"
	}
	if (table="21")
	{
		s rs="给药频次"
	}
	if (table="22")
	{
		s rs="用法用量"
	}
	if (table="23")
	{
		s rs="相互作用"
	}
	if (table="24")
	{
		s rs="不良反应"
	}
	if (table="25")
	{
		s rs="注意事项"
	}
	if (table="26")
	{
		s rs="商品名字典"
	}
	if (table="27")
	{
		s rs="溶媒分类字典"
	}
	if (table="28")
	{
		s rs="溶媒分类明细"
	}
	if (table="29")
	{
		s rs="药品规格字典"
	}
	if (table="30")
	{
		s rs="科室字典"
	}
	if (table="31")
	{
		s rs="症状字典"
	}
	if (table="32")
	{
		s rs="证型字典"
	}
	if (table="33")
	{
		s rs="溶媒量"
	}
	if (table="34")
	{
		s rs="浓度"
	}
	if (table="35")
	{
		s rs="可配伍药品"
	}
	if (table="36")
	{
		s rs="成分含量（g）"
	}
	if (table="37")
	{
		s rs="联合用药"
	}
	if (table="38")
	{
		s rs="辅助用药个数"
	}
	if (table="39")
	{
		s rs="重复用药规则"
	}
	if (table="40")
	{
		s rs="重复用药（编辑器）"
	}
	if (table="41")
	{
		s rs="配伍禁忌"
	}
	if (table="42")
	{
		s rs="炮制作用"
	}
	if (table="43")
	{
		s rs="厂家字典"
	}
	if (table="44")
	{
		s rs="草药毒性字典"
	}
	q rs
}

/// w ##class(web.DHCBL.BDP.ExportKBData).GetInfo("SS_User",3)
ClassMethod GetInfo(table, i) As %String
{
	s rs=""
	if (table="2")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelInfo(i)
	}
	if (table="3")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetInstLabelInfo(i)
	}
	if (table="4")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtFreqInfo(i)
	}
	if (table="5")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtFormInfo(i)
	}
	if (table="6")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtInstrucInfo(i)
	}
	if (table="7")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtUomInfo(i)
	}
	if (table="8")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetLibCatInfo(i)
	}
	if (table="9")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetIcdFeildInfo(i)
	}
	if (table="10")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSpecialPopuInfo(i)
	}
	if (table="11")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtIngrInfo(i)
	}
	if (table="12")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetPhysiologyInfo(i)
	}
	if (table="13")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInfo(i)
	}
	if (table="14")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAgeInfo(i)
	}
	if (table="15")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAllergyInfo(i)
	}
	if (table="16")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetHistoryInfo(i)
	}
	if (table="17")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetGenericInfo(i)
	}
	if (table="18")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseIndInfo(i)
	}
	if (table="19")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseConInfo(i)
	}
	if (table="20")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseUseInfo(i)
	}
	if (table="21")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseFreqInfo(i)
	}
	if (table="22")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetUsageDosageInfo(i)
	}
	if (table="23")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInteractInfo(i)
	}
	if (table="24")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDARInfo(i)
	}
	if (table="25")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDMHAInfo(i)
	}
	if (table="26")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetProNameInfo(i)
	}
	if (table="27")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMenstruumCatInfo(i)
	}
	if (table="28")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMenstruumItmInfo(i)
	}
	if (table="29")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetExtSqecInfo(i)
	}
	if (table="30")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetHospLocInfo(i)
	}
	if (table="31")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSymptomInfo(i)
	}
	if (table="32")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetSyndromeInfo(i)
	}
	if (table="33")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMenstruumQtyInfo(i)
	}
	if (table="34")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDrgSolventInfo(i)
	}
	if (table="35")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDrgAloneInfo(i)
	}
	if (table="36")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetEleConInfo(i)
	}
	if (table="37")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetMustDrugInfo(i)
	}
	if (table="38")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetAssDrugNumInfo(i)
	}
	if (table="39")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetRepeatFeildInfo(i)
	}
	if (table="40")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetRepeatItmInfo(i)
	}
	if (table="41")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetDrugContrainInfo(i)
	}
	if (table="42")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetProcessingActInfo(i)
	}
	if (table="43")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetPHManfInfo(i)
	}
	if (table="44")
	{
		s rs=##class(web.DHCBL.BDP.ExportKBData).GetPHToxicityInfo(i)
	}
	q rs
}

/// 炮制作用
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetProcessingActCount()
ClassMethod GetProcessingActCount() As %String
{
	k ^TMPKBCOUNT("DHCPHProcessingAct")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="ProcessingAct") ;炮制作用
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHProcessingAct",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 炮制作用
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetProcessingActInfo("1")
ClassMethod GetProcessingActInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHProcessingAct",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHProcessingAct",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

/// 配伍禁忌
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDrugContrainCount()
ClassMethod GetDrugContrainCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDrugContrain")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Taboo") ;配伍禁忌
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrugContrain",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 配伍禁忌
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDrugContrainInfo("1")
ClassMethod GetDrugContrainInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDrugContrain",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDrugContrain",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	
	//
	s PDINTRowId=$o(^DHCPHDINTER(0,"Inst",PHINSTRowId,0))
	s igen="",iflag=""
	if (PDINTRowId'="")
	{
		//配伍禁忌通用名
		s PDINTGenDr = $p($g(^DHCPHDINTER(PDINTRowId)),"^",2)
		s:PDINTGenDr'="" igen=$p($g(^DHCPHEGEN(PDINTGenDr)),"^",2)
		
		//医嘱标识:1 组内 2组间 3全部
		s PDINTFlag=$p($g(^DHCPHDINTER(PDINTRowId)),"^",5)
		s:PDINTFlag="1" iflag="组内" 
		s:PDINTFlag="2" iflag="组间" 
		s:PDINTFlag="3" iflag="全部" 
		if ((iflag'="组内")&(iflag'="组间")&(iflag'="全部")){
			s iflag="全部"
		} 
		
		
	}
	
	//配伍禁忌分类
	s CATICatDr="",itype=""
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",PHINSTRowId,0))
	s:CATIRowId'="" CATICatDr=$p($g(^DHCLIBCATI(CATIRowId)),"^",2)
	s:CATICatDr'="" itype=$listGet($g(^User.DHCPHLibCatD(CATICatDr)),3)
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_igen_"&%"_itype_"&%"_PHINSTText_"&%"_iflag
  	q str
}

/// 重复用药
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetRepeatItmCount()
ClassMethod GetRepeatItmCount() As %String
{
	k ^TMPKBCOUNT("DHCPHRepeatItm")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Repeat") ;重复用药
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHRepeatItm",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Repeat") ;重复用药
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHRepeatItm",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 重复用药
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetRepeatItmInfo("1")
ClassMethod GetRepeatItmInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHRepeatItm",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHRepeatItm",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHRepeatItm",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}
	
	s PHRIRowId=0
	s drgs="",rule=""
	for
	{
		s PHRIRowId=$o(^DHCPHRITM("0","Inst",PHINSTRowId,PHRIRowId)) q:PHRIRowId=""
		//商品名（多选用/分开）
		s PHRIProDr=$p($g(^DHCPHRITM(PHRIRowId)),"^",2)
		if (PHRIProDr'="") 
		{
			if (drgs'="")
			{
				s drgs =$p($g(^DHCPHPNA(PHRIProDr)),"^",2)_"#&"_drgs
			}
			else
			{
				s drgs =$p($g(^DHCPHPNA(PHRIProDr)),"^",2)
			}
		} 
		s PHRIRuleDr = $p($g(^DHCPHRITM(PHRIRowId)),"^",3)
		s:PHRIRuleDr'="" rule = $p($g(^DHCPHRFE(PHRIRuleDr)),"^",2)
		
	}
	
	
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_rule_"&%"_drgs_"&%"_mode_"&%"_PHINSTText
  	q str
}

/// 重复用药规则
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetRepeatFeildCount()
ClassMethod GetRepeatFeildCount() As %String
{
	k ^TMPKBCOUNT("DHCPHRepeatFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHRFE(id)) q:id=""
		s Code=$p($g(^DHCPHRFE(id)),"^",1)       
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHRepeatFeild",count)=id
	}	
	q count
}

/// 重复用药规则
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetRepeatFeildInfo("2")
ClassMethod GetRepeatFeildInfo(i) As %String
{
	n (i)
	s str=""
	S myRowID=$g(^TMPKBCOUNT("DHCPHRepeatFeild",i))
	q:(myRowID="") ""
	s PHRFCode=$p($g(^DHCPHRFE(myRowID)),"^",1)
	s PHRFDesc=$p($g(^DHCPHRFE(myRowID)),"^",2)
	s PHRFActiveFlag=$p($g(^DHCPHRFE(myRowID)),"^",3)
	
			
  	s str=PHRFCode_"&%"_PHRFDesc_"&%"_PHRFActiveFlag
	q str
}

/// 辅助用药个数
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetAssDrugNumCount()
ClassMethod GetAssDrugNumCount() As %String
{
	k ^TMPKBCOUNT("DHCPHAssDrugNum")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="AssDrugNum") ;辅助用药个数
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHAssDrugNum",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="AssDrugNum") ;辅助用药个数
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHAssDrugNum",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 辅助用药个数
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetAssDrugNumInfo("1")
ClassMethod GetAssDrugNumInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHAssDrugNum",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHAssDrugNum",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHAssDrugNum",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}

	s PHADRowId=$o(^DHCPHADN(0,"Inst",PHINSTRowId,0))
	s PHADNum=""
	if (PHADRowId'="")
	{
		s PHADNum=$p($g(^DHCPHADN(PHADRowId)),"^",2)
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_PHADNum_"&%"_PHINSTText
  	q str
}

/// 联合用药
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMustDrugCount()
ClassMethod GetMustDrugCount() As %String
{
	k ^TMPKBCOUNT("DHCPHMustDrug")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="MustDrug") ;联合用药
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHMustDrug",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="MustDrug") ;联合用药
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHMustDrug",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 联合用药
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMustDrugInfo("1")
ClassMethod GetMustDrugInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHMustDrug",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHMustDrug",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHMustDrug",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}

	s PHMDRowId=$o(^DHCPHMD("0","Inst",PHINSTRowId,0))
	s assDrug="",mustDrug="",relation="",uom="",PHMDMustQty=""
	if (PHMDRowId'="")
	{
		//关联液体
		s PHMDAssDrugDr = $p($g(^DHCPHMD(PHMDRowId)),"^",2)
		s:PHMDAssDrugDr'="" assDrug=$p($g(^DHCPHPNA(PHMDAssDrugDr)),"^",2)
		//必用药品
		s PHMDMustDrugDr = $p($g(^DHCPHMD(PHMDRowId)),"^",3)
		s:PHMDMustDrugDr'="" mustDrug=$p($g(^DHCPHPNA(PHMDMustDrugDr)),"^",2)
		
		s PHMDRelation=$p($g(^DHCPHMD(PHMDRowId)),"^",4)
		s:PHMDRelation=">" relation="大于" 
		s:PHMDRelation="<" relation="小于" 
		s:PHMDRelation="=" relation="等于" 
		s:PHMDRelation="!>" relation="不大于" 
		s:PHMDRelation="!<" relation="不小于" 
		s:PHMDRelation="<>" relation="不等于" 
		if ((relation'="大于")&(relation'="小于")&(relation'="等于")&(relation'="不大于")&(relation'="不小于")&(relation'="不等于")){
			s relation=""
		}
		s PHMDMustQty=$p($g(^DHCPHMD(PHMDRowId)),"^",5)
		s PHMDMustUomDr = $p($g(^DHCPHMD(PHMDRowId)),"^",6) 
		s:PHMDMustUomDr'="" uom=$p($g(^DHCPHEUO(PHMDMustUomDr)),"^",2) 	
		
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_assDrug_"&%"_mustDrug_"&%"_relation_"&%"_PHMDMustQty_"&%"_uom_"&%"_PHINSTText
  	q str
}

/// 成分含量
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetEleConCount()
ClassMethod GetEleConCount() As %String
{
	k ^TMPKBCOUNT("DHCPHEleCon")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="EleCon") ;成分含量
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHEleCon",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="EleCon") ;成分含量
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHEleCon",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 成分含量
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetEleConInfo("1")
ClassMethod GetEleConInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHEleCon",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHEleCon",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHEleCon",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}
	
	s PHECRowId=$o(^DHCPHEC(0,"Inst",PHINSTRowId,0))
	s ingr="",relation="",uom="",PHECIngrQty="",PHECTotalQty=""
	if (PHECRowId'="")
	{
		//单支药品成分
		s PHECPHExtIngr = $p($g(^DHCPHEC(PHECRowId)),"^",2)
		s:PHECPHExtIngr'="" ingr=$listGet($g(^User.DHCPHExtIngrD(PHECPHExtIngr)),3)
		
		s PHECIngrQty=$p($g(^DHCPHEC(PHECRowId)),"^",3)
		s PHECUomDr = $p($g(^DHCPHEC(PHECRowId)),"^",4)
		s:PHECUomDr'="" uom=$p($g(^DHCPHEUO(PHECUomDr)),"^",2) 
		
		
		s PHECRelation=$p($g(^DHCPHEC(PHECRowId)),"^",5)
		s:PHECRelation=">" relation="大于" 
		s:PHECRelation="<" relation="小于" 
		s:PHECRelation="=" relation="等于" 
		s:PHECRelation="!>" relation="不大于" 
		s:PHECRelation="!<" relation="不小于" 
		s:PHECRelation="<>" relation="不等于" 
		if ((relation'="大于")&(relation'="小于")&(relation'="等于")&(relation'="不大于")&(relation'="不小于")&(relation'="不等于")){
			s relation=""
		}
		
		s PHECTotalQty=$p($g(^DHCPHEC(PHECRowId)),"^",6)
		
		
		
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_ingr_"&%"_PHECIngrQty_"&%"_uom_"&%"_relation_"&%"_PHECTotalQty_"&%"_PHINSTText
  	q str
}

/// 可配伍药品
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDrgAloneCount()
ClassMethod GetDrgAloneCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDrgAlone")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="DrgAlone") ;可配药品伍
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrgAlone",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="DrgAlone") ;可配伍药品
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrgAlone",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 可配伍药品
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDrgAloneInfo("1")
ClassMethod GetDrgAloneInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDrgAlone",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDrgAlone",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHDrgAlone",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}
	s PHDALRowId=0
	s drg="",cat="",PHDALGrpNo=""
	for
	{
		s PHDALRowId=$o(^DHCPHDAL(0,"Inst",PHINSTRowId,PHDALRowId)) q:PHDALRowId=""
		if (PHDALRowId'="")
		{
			//组号
			s PHDALGrpNo=$p($g(^DHCPHDAL(PHDALRowId)),"^",4)
			//可配伍药品
			s PHDALDrgDr=$p($g(^DHCPHDAL(PHDALRowId)),"^",1)
			if (PHDALDrgDr'="") 
			{
				if (drg'="")
				{
					s drg =$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2)_"#&"_drg
				}
				else
				{
					s drg =$p($g(^DHCPHPNA(PHDALDrgDr)),"^",2)
				}
			} 
			s PHDALCatDr = $p($g(^DHCPHDAL(PHDALRowId)),"^",5)
			s:PHDALCatDr'="" cat=$p($g(^DHCPHMCT(PHDALCatDr)),"^",2)
			
			
		}
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_PHDALGrpNo_"&%"_drg_"&%"_cat_"&%"_PHINSTText_"&%"_mode
  	q str
}

/// 浓度
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDrgSolventCount()
ClassMethod GetDrgSolventCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDrgSolvent")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Solvent") ;浓度
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrgSolvent",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Solvent") ;浓度
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrgSolvent",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 浓度
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDrgSolventInfo("1")
ClassMethod GetDrgSolventInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDrgSolvent",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDrgSolvent",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHDrgSolvent",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}
	
	s PDINTRowId=$o(^DHCPHDST(0,"Inst",PHINSTRowId,0))
	s drg="",relation="",uom="",PDINTDosage="",PDINTDosageMin="",PDINTDosageMax=""
	if (PDINTRowId'="")
	{
		//关联溶媒药品
		s PDINTDrgDr = $p($g(^DHCPHDST(PDINTRowId)),"^",2)
		s:PDINTDrgDr'="" drg=$p($g(^DHCPHPNA(PDINTDrgDr)),"^",2)
		
		s PDINTRelation=$p($g(^DHCPHDST(PDINTRowId)),"^",5)
		s:PDINTRelation=">" relation="大于" 
		s:PDINTRelation="<" relation="小于" 
		s:PDINTRelation="=" relation="等于" 
		s:PDINTRelation="!>" relation="不大于" 
		s:PDINTRelation="!<" relation="不小于" 
		s:PDINTRelation="<>" relation="不等于" 
		if ((relation'="大于")&(relation'="小于")&(relation'="等于")&(relation'="不大于")&(relation'="不小于")&(relation'="不等于")){
			s relation=""
		}
		 
		s PDINTDosage=$p($g(^DHCPHDST(PDINTRowId)),"^",4)
		s PDINTDosageMax=$p($g(^DHCPHDST(PDINTRowId)),"^",7)
		s PDINTDosageMin=$p($g(^DHCPHDST(PDINTRowId)),"^",8)
		s PDINTDosageMax=PDINTDosageMin_"-"_PDINTDosageMax
		
		s PDINTMustUomDr = $p($g(^DHCPHDST(PDINTRowId)),"^",6)
		s:PDINTMustUomDr'="" uom=$p($g(^DHCPHEUO(PDINTMustUomDr)),"^",2)
		
		
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_mode_"&%"_drg_"&%"_relation_"&%"_PDINTDosage_"&%"_uom_"&%"_PHINSTText_"&%"_PDINTDosageMin_"&%"_PDINTDosageMax
  	q str
}

/// 溶媒量
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMenstruumQtyCount()
ClassMethod GetMenstruumQtyCount() As %String
{
	k ^TMPKBCOUNT("DHCPHMenstruumQty")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Menstruum") ;溶媒量
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHMenstruumQty",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}
	}
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s GlPGenDr=id        //商品名DR
		s GlPPointer=0       //剂型DR
		s PointerType="ProName"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Menstruum") ;溶媒量
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHMenstruumQty",count)=id_"^"_PHINSTRowId_"^"_PointerType
			}
				
		}	
		
		
	}	
	q count
}

/// 溶媒量
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMenstruumQtyInfo("1")
ClassMethod GetMenstruumQtyInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHMenstruumQty",i)),"^",1)
		
	
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHMenstruumQty",i)),"^",2)	
	s PointerType=$p($g(^TMPKBCOUNT("DHCPHMenstruumQty",i)),"^",3)
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PHEGDesc="",PHEFDesc="",PHNDesc=""
	if (PointerType="Form")
	{
		s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 
		s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
		s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
	}
	else
	{
	   s PHNDesc=$p($g(^DHCPHPNA(GlPRowId)),"^",2)          //商品名
	   s GlPPointer=$p($g(^DHCPHPNA(GlPRowId)),"^",5)       //剂型DR 
	   s:GlPPointer'="" PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型	
		
	}
	
	s PHMQRowId=$o(^DHCPHMQ(0,"Inst",PHINSTRowId,0))
	s cat="",uom="",PHMQCatQtyMin="",PHMQCatQtyMax=""
	if (PHMQRowId'="")
	{
		//溶媒分类
		s PHMQCatDr = $p($g(^DHCPHMQ(PHMQRowId)),"^",2)
		s:PHMQCatDr'="" cat=$p($g(^DHCPHMCT(PHMQCatDr)),"^",2)
		
		s PHMQCatQtyMin=$p($g(^DHCPHMQ(PHMQRowId)),"^",3)
		s PHMQCatQtyMax=$p($g(^DHCPHMQ(PHMQRowId)),"^",4)
		s PHMQCatQtyUomDr = $p($g(^DHCPHMQ(PHMQRowId)),"^",5)
		s:PHMQCatQtyUomDr'="" uom=$p($g(^DHCPHEUO(PHMQCatQtyUomDr)),"^",2)
		
		
	}
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHNDesc_"&%"_cat_"&%"_PHMQCatQtyMin_"&%"_PHMQCatQtyMax_"&%"_uom_"&%"_PHINSTText_"&%"_mode
  	q str
}

/// 证型字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetSyndromeCount()
ClassMethod GetSyndromeCount() As %String
{
	k ^TMPKBCOUNT("DHCPHSyndrome")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHSYDRO(id)) q:id=""
		s Code=$p($g(^DHCPHSYDRO(id)),"^",1)       
		continue:Code=""
		if ($d(^DHCPHSYNCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHSYNCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHSYNCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHSyndrome",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHSyndrome",count)=id
		}

	}	
	q count
}

/// 证型字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetSyndromeInfo("1")
ClassMethod GetSyndromeInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHSyndrome",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHSYDRO(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHSYDRO(rowId)),"^",2)  //描述
	
	
  	s hiscode="",hisdesc=""
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHSYNCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHSYNCON(conid)),"^",4)
  		
	
  	}
  	s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	q str
}

/// 症状字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetSymptomCount()
ClassMethod GetSymptomCount() As %String
{
	k ^TMPKBCOUNT("DHCPHSymptom")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHSYMP(id)) q:id=""
		s Code=$p($g(^DHCPHSYMP(id)),"^",1)       
		continue:Code=""
		if ($d(^DHCPHSYMCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHSYMCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHSYMCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHSymptom",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHSymptom",count)=id
		}

	}	
	q count
}

/// 症状字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetSymptomInfo("1")
ClassMethod GetSymptomInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHSymptom",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHSYMP(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHSYMP(rowId)),"^",2)  //描述
	
	
  	s hiscode="",hisdesc=""
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHSYMCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHSYMCON(conid)),"^",4)
  		
	
  	}
  	s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	q str
}

/// 科室字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetHospLocCount()
ClassMethod GetHospLocCount() As %String
{
	k ^TMPKBCOUNT("DHCPHHospLoc")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHHLOC(id)) q:id=""
		s Code=$p($g(^DHCPHHLOC(id)),"^",1)       
		continue:Code=""
		if ($d(^DHCPHHLOCCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHHLOCCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHHLOCCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHHospLoc",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHHospLoc",count)=id
		}

	}	
	q count
}

/// 科室字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetHospLocInfo("1")
ClassMethod GetHospLocInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHHospLoc",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHHLOC(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHHLOC(rowId)),"^",2)  //描述
	
	
  	s hiscode="",hisdesc=""
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHHLOCCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHHLOCCON(conid)),"^",4)
  		
	
  	}
  	s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	q str
}

/// 药品规格字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtSqecCount()
ClassMethod GetExtSqecCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtSqec")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHESQE(id)) q:id=""
		s Code=$p($g(^DHCPHESQE(id)),"^",1)       
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHExtSqec",count)=id
	}	
	q count
}

/// 药品规格字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtSqecInfo("2")
ClassMethod GetExtSqecInfo(i) As %String
{
	n (i)
	s str=""
	S myRowID=$g(^TMPKBCOUNT("DHCPHExtSqec",i))
	q:(myRowID="") ""
	s PHSCode=$p($g(^DHCPHESQE(myRowID)),"^",1)
	s PHSDesc=$p($g(^DHCPHESQE(myRowID)),"^",2)
	s PHSActiveFlag=$p($g(^DHCPHESQE(myRowID)),"^",3)
	s PHSSysFlag=$p($g(^DHCPHESQE(myRowID)),"^",4)
			
  	s str=PHSCode_"&%"_PHSDesc_"&%"_PHSActiveFlag_"&%"_PHSSysFlag
	q str
}

/// 溶媒分类明细
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMenstruumItmCount()
ClassMethod GetMenstruumItmCount() As %String
{
	k ^TMPKBCOUNT("DHCPHMenstruumItm")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHMIT(id)) q:id=""
		s PHMIDrugDr=$p($g(^DHCPHMIT(id)),"^",1)
		s PHNDesc=""
		s:PHMIDrugDr'="" PHNDesc=$p($g(^DHCPHPNA(PHMIDrugDr)),"^",2) 
		continue:PHNDesc=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHMenstruumItm",count)=id
	}	
	q count
}

/// 溶媒分类明细
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMenstruumItmInfo("2")
ClassMethod GetMenstruumItmInfo(i) As %String
{
	n (i)
	s str=""
	S PHMIRowId=$g(^TMPKBCOUNT("DHCPHMenstruumItm",i))
	q:(PHMIRowId="") ""
	s PHMIDrugDr=$p($g(^DHCPHMIT(PHMIRowId)),"^",1)
	s PHNDesc=""
	s:PHMIDrugDr'="" PHNDesc=$p($g(^DHCPHPNA(PHMIDrugDr)),"^",2)
	
	s PHMIMentDr=$p($g(^DHCPHMIT(PHMIRowId)),"^",2)
	s PHMCDesc=""
	s:PHMIMentDr'="" PHMCDesc=$p($g(^DHCPHMCT(PHMIMentDr)),"^",2)  //描述
	
  	s str=PHNDesc_"&%"_PHMCDesc
	q str
}

/// 溶媒分类字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMenstruumCatCount()
ClassMethod GetMenstruumCatCount() As %String
{
	k ^TMPKBCOUNT("DHCPHMenstruumCat")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHMCT(id)) q:id=""
		s Code=$p($g(^DHCPHMCT(id)),"^",1)       
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHMenstruumCat",count)=id
	}	
	q count
}

/// 溶媒分类字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetMenstruumCatInfo("2")
ClassMethod GetMenstruumCatInfo(i) As %String
{
	n (i)
	s str=""
	S PHMCRowId=$g(^TMPKBCOUNT("DHCPHMenstruumCat",i))
	q:(PHMCRowId="") ""
	s PHMCCode=$p($g(^DHCPHMCT(PHMCRowId)),"^",1)  //代码
	s PHMCDesc=$p($g(^DHCPHMCT(PHMCRowId)),"^",2)  //描述
	s PHMCActive=$p($g(^DHCPHMCT(PHMCRowId)),"^",3)  //是否可用
	
  	s str=PHMCCode_"&%"_PHMCDesc_"&%"_PHMCActive
	q str
}

/// 商品名字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetProNameCount()
ClassMethod GetProNameCount() As %String
{
	k ^TMPKBCOUNT("DHCPHProName")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHPNA(id)) q:id=""
		s Code=$p($g(^DHCPHPNA(id)),"^",1)       
		continue:Code=""
		if ($d(^DHCPHPCO("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHPCO("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHPCO("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHProName",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHProName",count)=id
		}

	}	
	q count
}

/// 商品名字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetProNameInfo("1")
ClassMethod GetProNameInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHProName",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHPNA(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHPNA(rowId)),"^",2)  //描述
	
	s PHNFormDr=$p($g(^DHCPHPNA(rowId)),"^",5)  //剂型DR
	s form=""
	S:PHNFormDr'="" form=$p($g(^DHCPHEF(PHNFormDr)),"^",2) //剂型
	//s PHNFactory=$p($g(^DHCPHPNA(rowId)),"^",6)  //厂家
	
	s PHNGenericDr=$p($g(^DHCPHPNA(rowId)),"^",7)  //通用名DR
	s Generic=""
	S:PHNGenericDr'="" Generic=$p($g(^DHCPHEGEN(PHNGenericDr)),"^",2) //通用名
	
	//厂家
	s PHNManfDR=$p($g(^DHCPHPNA(rowId)),"^",10)  //厂家DR
	s PHNFactory=""
	S:PHNManfDR'="" PHNFactory=$p($g(^DHCPHMANF(PHNManfDR)),"^",2) //厂家
	
	//毒性
	s PHNToxicity=$p($g(^DHCPHPNA(rowId)),"^",8)  //毒性DR
	s Toxicity=""
	S:PHNToxicity'="" Toxicity=$p($g(^DHCPHTOX(PHNToxicity)),"^",2) //毒性
	
	
  	s hiscode="",hisdesc=""
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHPCO(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHPCO(conid)),"^",4)
  		
	
  	}
  	s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_form_"&%"_PHNFactory_"&%"_Generic_"&%"_Toxicity
	q str
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDMHACount()
ClassMethod GetDMHACount() As %String
{
	k ^TMPKBCOUNT("DHCPHDMHA")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="MatNeAt") ;注意事项
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDMHA",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 注意事项
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDMHAInfo("1")
ClassMethod GetDMHAInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDMHA",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDMHA",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

/// 不良反应
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDARCount()
ClassMethod GetDARCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDAR")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="AdvRea") ;不良反应
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDAR",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 不良反应
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDARInfo("1")
ClassMethod GetDARInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDAR",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDAR",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=PHEGDesc_"&%"_PHEFDesc_"&%"_PHINSTText
  	q str
}

/// 相互作用
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInteractCount()
ClassMethod GetDiseaseInteractCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDiseaseInteract")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="InterEach") ;相互作用
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDiseaseInteract",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 相互作用
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInteractInfo("1")
ClassMethod GetDiseaseInteractInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDiseaseInteract",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDiseaseInteract",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	
	//
	s PDINTRowId=$o(^DHCPHDINTER(0,"Inst",PHINSTRowId,0))
	s igen="",iflag=""
	if (PDINTRowId'="")
	{
		//存在相互作用通用名
		s PDINTGenDr = $p($g(^DHCPHDINTER(PDINTRowId)),"^",2)
		s:PDINTGenDr'="" igen=$p($g(^DHCPHEGEN(PDINTGenDr)),"^",2)
		
		//医嘱标识:1 组内 2组间 3全部
		s PDINTFlag=$p($g(^DHCPHDINTER(PDINTRowId)),"^",5)
		s:PDINTFlag="1" iflag="组内" 
		s:PDINTFlag="2" iflag="组间" 
		s:PDINTFlag="3" iflag="全部" 
		if ((iflag'="组内")&(iflag'="组间")&(iflag'="全部")){
			s iflag="全部"
		} 
		
		
	}
	
	//存在相互作用分类
	s CATICatDr="",itype=""
	s CATIRowId=$o(^DHCLIBCATI("0","Inst",PHINSTRowId,0))
	s:CATIRowId'="" CATICatDr=$p($g(^DHCLIBCATI(CATIRowId)),"^",2)
	s:CATICatDr'="" itype=$listGet($g(^User.DHCPHLibCatD(CATICatDr)),3)
	
	//本文描述
	s PHINSTText = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15) 
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_igen_"&%"_itype_"&%"_PHINSTText_"&%"_iflag
  	q str
}

/// 给药频次
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseFreqCount()
ClassMethod GetDiseaseFreqCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDiseaseFreq")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s TypeDr=$o(^DHCPHPINL("0","Code","FREQ",0))
		s PDFInstDr=0
		for 
		{
			//s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PDFInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GlPGenDr,PointerType,GlPPointer,PDFInstDr))	q:PDFInstDr=""
			//s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PDFInstDr),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Freq") ;给药途径
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDiseaseFreq",count)=id_"^"_PDFInstDr
			}
				
		}
		
		
	}	
	q count
}

/// 给药频次
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseFreqInfo("18")
ClassMethod GetDiseaseFreqInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDiseaseFreq",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型

	s PDFInstDr=$p($g(^TMPKBCOUNT("DHCPHDiseaseFreq",i)),"^",2)	
	q:PDFInstDr="" ""

	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PDFInstDr)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PDFRowId = $o(^DHCPHDISFR("0","Inst",PDFInstDr,0)) q:PDFRowId="" ""
	s PDFFreqDR=""  
	s:PDFRowId'="" PDFFreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)  //用药频率Dr
	s:PDFFreqDR'="" PHEFDesc1=$p($g(^DHCPHEFR(PDFFreqDR)),"^",2) //频率名称

	s PDFExcludeFlag=$p($g(^DHCPHDISFR(PDFRowId)),"^",3)  //禁忌 
	s PDFAlertMsg=$p($g(^DHCPHDISFR(PDFRowId)),"^",4)  //提示消息 
	s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDFInstDr,0)) //continue:PDARowId=""
	s agelimit="",PDAAgeDesc=""
	if (PDARowId'=""){
		s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
		s:PDAAgeDr'="" PDAAgeDesc=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2) //年龄描述
		s:PDAAgeDr="" PDAAgeDesc="" //年龄描述
		
		s PDAMinVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",3) //年龄限制最小值
		s PDAMaxVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",4) //年龄限制最大值
		s PDAUomDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",5) //年龄单位
		s:PDAUomDr'="" PHEUDesc=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)  //年龄单位描述
		s:PDAUomDr="" PHEUDesc="" //年龄单位描述
		S:PDAMinVal'="" agelimit=PDAMinVal
		S:PDAMaxVal'="" agelimit=agelimit_"-"_PDAMaxVal
		S:PHEUDesc'="" agelimit=agelimit_"/"_PHEUDesc
	}	

		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_PHEFDesc1_"&%"_PDAAgeDesc_"&%"_agelimit_"&%"_PDFExcludeFlag_"&%"_PDFAlertMsg
  	q str
}

/// 给药途径
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseUseCount()
ClassMethod GetDiseaseUseCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDiseaseUse")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s TypeDr=$o(^DHCPHPINL("0","Code","PREMET",0))
		s PDIInstDr=0
		for 
		{
			//s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PDIInstDr=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GlPGenDr,PointerType,GlPPointer,PDIInstDr))	q:PDIInstDr=""
			//s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PDIInstDr),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="PreMet") ;给药途径
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDiseaseUse",count)=id_"^"_PDIInstDr
			}
				
		}
		
		
	}	
	q count
}

/// 给药途径
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseUseInfo("18")
ClassMethod GetDiseaseUseInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDiseaseUse",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	s PDIInstDr=$p($g(^TMPKBCOUNT("DHCPHDiseaseUse",i)),"^",2)	
	q:PDIInstDr="" ""
	
	
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PDIInstDr)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	s PDIRowId = $o(^DHCPHDISUSE("0","Inst",PDIInstDr,0)) q:PDIRowId="" ""
	s PDIUseDR=""  
	s:PDIRowId'="" PDIUseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)  //给药途径Dr
	s:PDIUseDR'="" PHEINDesc=$p($g(^DHCPHEINSTR(PDIUseDR)),"^",2) //方法名称
	
	s PDIExcludeFlag=$p($g(^DHCPHDISUSE(PDIRowId)),"^",3)  //禁忌
	s PDIAlertMsg=$p($g(^DHCPHDISUSE(PDIRowId)),"^",4)  //提示消息
	s PDARowId = $o(^DHCPHDISAGE("0","Inst",PDIInstDr,0)) //continue:PDARowId=""
	s agelimit="",PDAAgeDesc=""
	if (PDARowId'=""){
		s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
		s:PDAAgeDr'="" PDAAgeDesc=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2) //年龄描述
		s:PDAAgeDr="" PDAAgeDesc="" //年龄描述
		
		s PDAMinVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",3) //年龄限制最小值
		s PDAMaxVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",4) //年龄限制最大值
		s PDAUomDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",5) //年龄单位
		s:PDAUomDr'="" PHEUDesc=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)  //年龄单位描述
		s:PDAUomDr="" PHEUDesc="" //年龄单位描述
		S:PDAMinVal'="" agelimit=PDAMinVal
		S:PDAMaxVal'="" agelimit=agelimit_"-"_PDAMaxVal
		S:PHEUDesc'="" agelimit=agelimit_"/"_PHEUDesc
	}	

		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_PHEINDesc_"&%"_PDAAgeDesc_"&%"_agelimit_"&%"_PDIExcludeFlag_"&%"_PDIAlertMsg
  	q str
}

/// 用法用量
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetUsageDosageCount()
ClassMethod GetUsageDosageCount() As %String
{
	k ^TMPKBCOUNT("DHCPHUsageDosage")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s TypeDr=$o(^DHCPHPINL("0","Code","USAGE",0))
		s PHINSTRowId=0
		for 
		{
			
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","TGP",TypeDr,GlPGenDr,PointerType,GlPPointer,PHINSTRowId))	q:PHINSTRowId=""
			//s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Usage") ;用法用量
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHUsageDosage",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
	}	
	q count
}

/// 用法用量
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetUsageDosageInfo("1")
ClassMethod GetUsageDosageInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHUsageDosage",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHUsageDosage",i)),"^",2)	
	q:PHINSTRowId="" ""
	
	
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	
	s PDARowId = $o(^DHCPHDISAGE("0","Inst",PHINSTRowId,0)) 
	s agelimit="",PDAAgeDesc=""
	if (PDARowId'=""){
		s PDAAgeDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",2) //年龄Dr 
		s:PDAAgeDr'="" PDAAgeDesc=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2) //年龄描述
		s:PDAAgeDr="" PDAAgeDesc="" //年龄描述
		
		s PDAMinVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",3) //年龄限制最小值
		s PDAMaxVal = $p($g(^DHCPHDISAGE(PDARowId)),"^",4) //年龄限制最大值
		s PDAUomDr = $p($g(^DHCPHDISAGE(PDARowId)),"^",5) //年龄单位
		s:PDAUomDr'="" PHEUDesc=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)  //年龄单位描述
		s:PDAUomDr="" PHEUDesc="" //年龄单位描述
		S:PDAMinVal'="" agelimit=PDAMinVal
		S:PDAMaxVal'="" agelimit=agelimit_"-"_PDAMaxVal
		S:PHEUDesc'="" agelimit=agelimit_"/"_PHEUDesc
	}	
	 
	
	//禁忌症、病症
	s dis=""
	s PHDDRowId=0
	s dis="",type=""
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",PHINSTRowId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (dis'="")
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
		
	}

	//性别
	s sex=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",9)
	s:sex="M" sex="男" 
	s:sex="F" sex="女" 
	s:sex="A" sex="全部" 
	s:sex="" sex="全部"
	
	//特殊人群
	s SPEPIRowId=0
	s popu=""
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",PHINSTRowId,SPEPIRowId)) q:SPEPIRowId=""	
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		if (SPEPISpecDr'="")
		{
			if (popu'="")
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)_"#&"_popu
			}
			else
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)
			}
		}	
	}
	
	//用法
	s use="",PDIUseDR=""
	s PDIRowId=$o(^DHCPHDISUSE(0,"Inst",PHINSTRowId,0)) 
	s:PDIRowId'="" PDIUseDR = $p(^DHCPHDISUSE(PDIRowId),"^",2)
	s:PDIUseDR'="" use=$p(^DHCPHEINSTR(PDIUseDR),"^",2)
	
	//用法用量
	s PHUSDORowId=$o(^DHCPHUSDO(0,"Inst",PHINSTRowId,0)) 
	if (PHUSDORowId'=""){
		s DayTimeMin = $p(^DHCPHUSDO(PHUSDORowId),"^",2)
		s DayTimeMax = $p(^DHCPHUSDO(PHUSDORowId),"^",3)
		s DayTime=DayTimeMin_"-"_DayTimeMax
		
		s OnceQty="", OnceQtyUom=""
		s OnceQtyMin = $p(^DHCPHUSDO(PHUSDORowId),"^",4)
		s OnceQtyMax = $p(^DHCPHUSDO(PHUSDORowId),"^",5)
		s OnceQty=OnceQtyMin_"-"_OnceQtyMax
		s OnceQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",6)
		s:OnceQtyUomDr'="" OnceQtyUom=$p($g(^DHCPHEUO(OnceQtyUomDr)),"^",2)
		
		s DayQty="", DayQtyUom=""
		s DayQtyMin = $p(^DHCPHUSDO(PHUSDORowId),"^",7)
		s DayQtyMax = $p(^DHCPHUSDO(PHUSDORowId),"^",8)
		s DayQty=DayQtyMin_"-"_DayQtyMax
		s DayQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",9)
		s:DayQtyUomDr'="" DayQtyUom=$p($g(^DHCPHEUO(DayQtyUomDr)),"^",2)
		
		s OnceMaxQty="", OnceMaxQtyUom=""
		s OnceMaxQty = $p(^DHCPHUSDO(PHUSDORowId),"^",10)
		s OnceMaxQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",11)
		s:OnceMaxQtyUomDr'="" OnceMaxQtyUom=$p($g(^DHCPHEUO(OnceMaxQtyUomDr)),"^",2)
		
		s DayMaxQty="", DayMaxQtyUom=""
		s DayMaxQty = $p(^DHCPHUSDO(PHUSDORowId),"^",12)
		s DayMaxQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",13)
		s:DayMaxQtyUomDr'="" DayMaxQtyUom=$p($g(^DHCPHEUO(DayMaxQtyUomDr)),"^",2)
		
		s FristTimeQty="", FristTimeQtyUom=""
		s FristTimeQtyMin = $p(^DHCPHUSDO(PHUSDORowId),"^",14)
		s FristTimeQtyMax = $p(^DHCPHUSDO(PHUSDORowId),"^",15)
		s FristTimeQty=FristTimeQtyMin_"-"_FristTimeQtyMax
		s FristTimeQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",16)
		s:FristTimeQtyUomDr'="" FristTimeQtyUom=$p($g(^DHCPHEUO(FristTimeQtyUomDr)),"^",2)
		
		s DurationQty="", DurationQtyUom=""
		s DurationQtyMin = $p(^DHCPHUSDO(PHUSDORowId),"^",17)
		s DurationQtyMax = $p(^DHCPHUSDO(PHUSDORowId),"^",18)
		s DurationQty=DurationQtyMin_"-"_DurationQtyMax
		s DurationQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",19)
		s:DurationQtyUomDr'="" DurationQtyUom=$p($g(^DHCPHEUO(DurationQtyUomDr)),"^",2)
		
		s SpaceQty="", SpaceQtyUom=""
		s SpaceQtyMin = $p(^DHCPHUSDO(PHUSDORowId),"^",20)
		s SpaceQtyMax = $p(^DHCPHUSDO(PHUSDORowId),"^",21)
		s SpaceQty=SpaceQtyMin_"-"_SpaceQtyMax
		s SpaceQtyUomDr=$p(^DHCPHUSDO(PHUSDORowId),"^",22)
		s:SpaceQtyUomDr'="" SpaceQtyUom=$p($g(^DHCPHEUO(SpaceQtyUomDr)),"^",2)
		

		s WeightMin = $p(^DHCPHUSDO(PHUSDORowId),"^",23)
		s WeightMax = $p(^DHCPHUSDO(PHUSDORowId),"^",24)
		s Weight=WeightMin_"-"_WeightMax
		
		s BodyAreaMin = $p(^DHCPHUSDO(PHUSDORowId),"^",25)
		s BodyAreaMax = $p(^DHCPHUSDO(PHUSDORowId),"^",26)
		s BodyArea=BodyAreaMin_"-"_BodyAreaMax
	}
	
	s PHINSTDocUseTips=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",11)
	s PHINSTNurseUseTips=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",10)
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//检验项目
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHINSTRowId,0))
	s Lab="",LABLimit="",LABIUom=""
	if (LABIRowId'="")
	{
		s LABILabDr=$p($g(^DHCLIBLABI(LABIRowId)),"^",2)
		s:LABILabDr'="" Lab=$p($g(^DHCPHEGEN(LABILabDr)),"^",2)
		
		//指标值范围
		s LABIMinVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s LABIMaxVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",3)
		s LABIRelation=$p($g(^DHCLIBLABI(LABIRowId)),"^",6)
		
		s:LABIRelation'="" LABLimit=LABIRelation
		s:LABIMinVal'="" LABLimit=LABLimit_LABIMinVal
		s:LABIMaxVal'="" LABLimit=LABLimit_"-"_LABIMaxVal
		
		//指标值单位
		s LABIUomDr = $p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s:LABIUomDr'="" LABIUom=$p($g(^DHCPHEUO(LABIUomDr)),"^",2)
		
	}
	if (PHUSDORowId'=""){
	  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_PDAAgeDesc_"&%"_agelimit_"&%"_dis_"&%"_sex_"&%"_popu_"&%"_use_"&%"_DayTime
	  	_"&%"_OnceQty_"&%"_OnceQtyUom_"&%"_DayQty_"&%"_DayQtyUom_"&%"_OnceMaxQty_"&%"_OnceMaxQtyUom_"&%"_DayMaxQty
	  	_"&%"_DayMaxQtyUom_"&%"_PHINSTDocUseTips_"&%"_PHINSTNurseUseTips_"&%"_PHINSTText
	  	_"&%"_FristTimeQty_"&%"_FristTimeQtyUom_"&%"_DurationQty_"&%"_DurationQtyUom_"&%"_SpaceQty_"&%"_SpaceQtyUom
	  	_"&%"_Weight_"&%"_BodyArea_"&%"_Lab_"&%"_LABLimit_"&%"_LABIUom
	}
	else{
		s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_PDAAgeDesc_"&%"_agelimit_"&%"_dis_"&%"_sex_"&%"_popu_"&%"_use_"&%&%&%&%"_PHINSTDocUseTips_"&%"_PHINSTNurseUseTips_"&%"_PHINSTText_"&%&%&%&%&%&%&%&%&%"_Lab_"&%"_LABLimit_"&%"_LABIUom	
	}
  	q str
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseConCount()
ClassMethod GetDiseaseConCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDrugDiseaseCon")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Contr") ;禁忌症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrugDiseaseCon",count)=id_"^"_PHINSTRowId
			}
				
		}
		
		
		
	}	
	q count
}

/// 禁忌症
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseConInfo("6")
ClassMethod GetDiseaseConInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDrugDiseaseCon",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDrugDiseaseCon",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	//禁忌症、病症
	s dis=""
	s PHDDRowId=0
	s dis="",type=""
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",PHINSTRowId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (dis'="")
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
		//类型
		s PHDDType=$p($g(^DHCPHDDIS(PHDDRowId)),"^",6)
		s:PHDDType="F" type="禁用" 
		s:PHDDType="C" type="慎用" 
		if ((type'="禁用")&(type'="慎用"))
		{
			s type="禁用"
		}
	}
	//年龄
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHINSTRowId,0))
	s age="",agelimit="",uom=""
	if (PDARowId'="")
	{
		s PDAAgeDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",2)
		s:PDAAgeDr'="" age=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2)
		 
		//年龄限制^DHCPHDISAGE
		s PDAMaxVal=$p($g(^DHCPHDISAGE(PDARowId)),"^",4)
		s PDAMinVal=$p($g(^DHCPHDISAGE(PDARowId)),"^",3)
		s PDAUomDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",5)
		s:PDAUomDr'="" uom=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)
		s:PDAMinVal'="" agelimit=PDAMinVal
		s:PDAMaxVal'="" agelimit=agelimit_"-"_PDAMaxVal
		s:uom'="" agelimit=agelimit_"/"_uom
	   
	}
	//既往史
	s LDHRowId=0
	s history=""
	for
	{
		s LDHRowId=$o(^DHCLIBDISHISI("0","Inst",PHINSTRowId,LDHRowId)) q:LDHRowId=""	
		s DhDr=$p($g(^DHCLIBDISHISI(LDHRowId)),"^",2)  //病症指针		
		if (DhDr'="")
		{
			if (history'="")
			{
				s history=$p($g(^DHCDISHISF(DhDr)),"^",2)_","_history
			}
			else
			{
				s history=$p($g(^DHCDISHISF(DhDr)),"^",2)
			}
		}			
	}
	//成分业务表^DHCPHINI，成分字典表^DHCPHEING
	s IngrRowId=$o(^DHCPHINI(0,"Inst",PHINSTRowId,0))
	s ingr=""
	if (IngrRowId'="")
	{
		s PHINIIngrDr=$P($g(^DHCPHINI(IngrRowId)),"^",2)
		s:PHINIIngrDr'="" ingr=$listGet($g(^User.DHCPHExtIngrD(PHINIIngrDr)),3)
	}
	//生理参数
	s PHYVRowId=$o(^DHCPHYVAL(0,"Inst",PHINSTRowId,0))
	s phy="", phylimit=""
	if (PHYVRowId'="")
	{
		s PHYVFeildDr=$p($g(^DHCPHYVAL(PHYVRowId)),"^",2)
		s:PHYVFeildDr'="" phy=$p($g(^DHCPHYSIF(PHYVFeildDr)),"^",2)
		 
		//生理参数范围
		s PHYVMinVal=$p($g(^DHCPHYVAL(PHYVRowId)),"^",5)
		s PHYVMaxVal=$p($g(^DHCPHYVAL(PHYVRowId)),"^",4)
		s:PHYVMinVal'="" phylimit=PHYVMinVal
		s:PHYVMaxVal'="" phylimit=phylimit_"-"_PHYVMaxVal
	   
	}
	
	//性别
	s sex=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",9)
	s:sex="M" sex="男" 
	s:sex="F" sex="女" 
	s:sex="A" sex="全部" 
	s:sex="" sex="全部" 
	
	//特殊人群
	s SPEPIRowId=0
	s popu=""
	for
	{
		s SPEPIRowId=$o(^DHCLIBSPEPI(0,"Inst",PHINSTRowId,SPEPIRowId)) q:SPEPIRowId=""	
		s SPEPISpecDr=$p(^DHCLIBSPEPI(SPEPIRowId),"^",2)
		if (SPEPISpecDr'="")
		{
			if (popu'="")
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)_"#&"_popu
			}
			else
			{
				s popu = $p($g(^DHCSPEP(SPEPISpecDr)),"^",2)
			}
		}	
	}
	//过敏史
	s LALCRowId=$o(^DHCLIBALLI(0,"Inst",PHINSTRowId,0))
	s allergy=""
	if (LALCRowId'="")
	{
		s LALCAllergyDr=$P($g(^DHCLIBALLI(LALCRowId)),"^",2)  
		s:LALCAllergyDr'="" allergy=$p($g(^DHCALLERGY(LALCAllergyDr)),"^",2)
		
	}
	
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//提示（医生）
	s PHINSTDocUseTips=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",11)
	
	//备注
	s PHINSTNote=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",12)
	
	
	
	//检验项目
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHINSTRowId,0))
	s Lab="",LABLimit="",LABIUom=""
	if (LABIRowId'="")
	{
		s LABILabDr=$p($g(^DHCLIBLABI(LABIRowId)),"^",2)
		s:LABILabDr'="" Lab=$p($g(^DHCPHEGEN(LABILabDr)),"^",2)
		
		//指标值范围
		s LABIMinVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s LABIMaxVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",3)
		s LABIRelation=$p($g(^DHCLIBLABI(LABIRowId)),"^",6)
		
		s:LABIRelation'="" LABLimit=LABIRelation
		s:LABIMinVal'="" LABLimit=LABLimit_LABIMinVal
		s:LABIMaxVal'="" LABLimit=LABLimit_"-"_LABIMaxVal
		
		//指标值单位
		s LABIUomDr = $p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s:LABIUomDr'="" LABIUom=$p($g(^DHCPHEUO(LABIUomDr)),"^",2)
		
	}
	//病症体征
	s RowId=0
	s key0=""
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (key0'="")
			{
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_"#&"_key0
			}
			else
			{
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	
	//治疗手术
	s RowId=0
	s key1=""
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (key1'="")
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_"#&"_key1
			}
			else
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_history_"&%"_ingr_"&%"_phy_"&%"_phylimit_"&%"_sex_"&%"_popu_"&%"_allergy_"&%"_PHINSTText_"&%"_PHINSTDocUseTips_"&%"_PHINSTNote_"&%"_type_"&%"_Lab_"&%"_LABLimit_"&%"_LABIUom_"&%"_key0_"&%"_key1
	q str
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseIndCount()
ClassMethod GetDiseaseIndCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDrugDiseaseInd")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCGENLINP(id)) q:id=""
		s GlPGenDr=$p($g(^DHCGENLINP(id)),"^",1)       //通用名DR
		s GlPPointer=$p($g(^DHCGENLINP(id)),"^",2)       //剂型DR
		s PointerType="Form"
		s PHINSTRowId=0
		for 
		{
			s PHINSTRowId=$o(^DHCPHINSTRUC("0","GP",GlPGenDr,PointerType,GlPPointer,PHINSTRowId)) q:PHINSTRowId=""
			s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
			s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
			if (PINLCode="Indic") ;适应症
			{
				s count=count+1
				s ^TMPKBCOUNT("DHCPHDrugDiseaseInd",count)=id_"^"_PHINSTRowId
			}
				
		}
	
		
	}	
	q count
}

/// 适应症
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseIndInfo("1")
ClassMethod GetDiseaseIndInfo(i) As %String
{
	n (i)
	s str=""
	S GlPRowId=$p($g(^TMPKBCOUNT("DHCPHDrugDiseaseInd",i)),"^",1)
	s GlPGenDr=$p($g(^DHCGENLINP(GlPRowId)),"^",1)       //通用名DR
	s GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)       //剂型DR 	
	s PointerType="Form"
	s PHINSTRowId=$p($g(^TMPKBCOUNT("DHCPHDrugDiseaseInd",i)),"^",2)	
	q:(PHINSTRowId="") ""
	
	s PHINSTTypeDr=$p(^DHCPHINSTRUC(PHINSTRowId),"^",1)
	s PINLCode=$p($g(^DHCPHPINL(PHINSTTypeDr)),"^",1)
	
	//控制级别
	s mode=""
	s PHINSTMode = $p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",14) 
	s:PHINSTMode="W" mode="警示" 
	s:PHINSTMode="C" mode="管控" 
	s:PHINSTMode="S" mode="统计" 
	if ((mode'="警示")&(mode'="管控" )&(mode'="统计"))
	{
		s mode="警示"
	}
	
	s PHEGDesc=$p($g(^DHCPHEGEN(GlPGenDr)),"^",2)        //通用名
	s PHEFDesc=$p($g(^DHCPHEF(GlPPointer)),"^",2)          //剂型
	
	//适应症、病症
	s dis=""
	s PHDDRowId=0
	for
	{
		s PHDDRowId=$o(^DHCPHDDIS(0,"Inst",PHINSTRowId,PHDDRowId)) q:PHDDRowId=""
		s PHDDDiseaDr=$p(^DHCPHDDIS(PHDDRowId),"^",3)
		if (PHDDDiseaDr'="") 
		{
			if (dis'="")
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)_"#&"_dis
			}
			else
			{
				s dis = $p(^DHCPHDISL(PHDDDiseaDr),"^",2)
			}
		} 
	}
	//年龄
	s PDARowId=$o(^DHCPHDISAGE(0,"Inst",PHINSTRowId,0))
	s age="",agelimit="",uom=""
	if (PDARowId'="")
	{
		s PDAAgeDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",2)
		s:PDAAgeDr'="" age=$p($g(^DHCPHPAGEL(PDAAgeDr)),"^",2)
		 
		//年龄限制
		s PDAMaxVal=$p($g(^DHCPHDISAGE(PDARowId)),"^",4)
		s PDAMinVal=$p($g(^DHCPHDISAGE(PDARowId)),"^",3)
		s PDAUomDr=$p($g(^DHCPHDISAGE(PDARowId)),"^",5)
		s:PDAUomDr'="" uom=$p($g(^DHCPHEUO(PDAUomDr)),"^",2)
		s:PDAMinVal'="" agelimit=PDAMinVal
		s:PDAMaxVal'="" agelimit=agelimit_"-"_PDAMaxVal
		s:uom'="" agelimit=agelimit_"/"_uom
	   
	}
	//性别
	s sex=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",9)
	s:sex="M" sex="男" 
	s:sex="F" sex="女" 
	s:sex="A" sex="全部" 
	//描述说明
	s PHINSTText=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",15)
	
	//提示（医生）
	s PHINSTDocUseTips=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",11)
	
	//备注
	s PHINSTNote=$p($g(^DHCPHINSTRUC(PHINSTRowId)),"^",12)
	
	//病症体征
	s RowId=0
	s key0=""
	for
	{
		s RowId=$o(^DHCPHSYM(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PSYMKeyWordDr=$p(^DHCPHSYM(RowId),"^",2)
		if (PSYMKeyWordDr'="") 
		{
			if (key0'="")
			{
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)_"#&"_key0
			}
			else
			{
				s key0 = $p(^DHCPHKW(PSYMKeyWordDr),"^",2)
			}
		} 
	}
	
	//治疗手术
	s RowId=0
	s key1=""
	for
	{
		s RowId=$o(^DHCPHCU(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PDCUKeyWordDr=$p(^DHCPHCU(RowId),"^",2)
		if (PDCUKeyWordDr'="") 
		{
			if (key1'="")
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)_"#&"_key1
			}
			else
			{
				s key1 = $p(^DHCPHKW(PDCUKeyWordDr),"^",2)
			}
		} 
	}
	//检验项目
	s LABIRowId=$o(^DHCLIBLABI(0,"Inst",PHINSTRowId,0))
	s Lab="",LABLimit="",LABIUom=""
	if (LABIRowId'="")
	{
		s LABILabDr=$p($g(^DHCLIBLABI(LABIRowId)),"^",2)
		s:LABILabDr'="" Lab=$p($g(^DHCPHEGEN(LABILabDr)),"^",2)
		
		//指标值范围
		s LABIMinVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s LABIMaxVal=$p($g(^DHCLIBLABI(LABIRowId)),"^",3)
		s LABIRelation=$p($g(^DHCLIBLABI(LABIRowId)),"^",6)
		
		s:LABIRelation'="" LABLimit=LABIRelation
		s:LABIMinVal'="" LABLimit=LABLimit_LABIMinVal
		s:LABIMaxVal'="" LABLimit=LABLimit_"-"_LABIMaxVal
		
		//指标值单位
		s LABIUomDr = $p($g(^DHCLIBLABI(LABIRowId)),"^",5)
		s:LABIUomDr'="" LABIUom=$p($g(^DHCPHEUO(LABIUomDr)),"^",2)
		
	}
	//细菌
	s RowId=0
	s organism=""
	for
	{
		s RowId=$o( ^DHCPHORGBUS(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PHORGOrgDr=$p(^DHCPHORGBUS(RowId),"^",2)
		if (PHORGOrgDr'="") 
		{
			if (organism'="")
			{
				s organism = $p(^DHCPHBTORG(PHORGOrgDr),"^",2)_"#&"_organism
			}
			else
			{
				s organism = $p(^DHCPHBTORG(PHORGOrgDr),"^",2)
			}
		} 
	}
	
	//菌属
	s RowId=0
	s genus=""
	for
	{
		s RowId=$o(^DHCPHGENUSBUS(0,"Inst",PHINSTRowId,RowId)) q:RowId=""
		s PHGENGenusDr=$p(^DHCPHGENUSBUS(RowId),"^",2)
		if (PHGENGenusDr'="") 
		{
			if (genus'="")
			{
				s genus = $p(^DHCPHBTGE(PHGENGenusDr),"^",2)_"#&"_genus
			}
			else
			{
				s genus = $p(^DHCPHBTGE(PHGENGenusDr),"^",2)
			}
		} 
	}
		
  	s str=mode_"&%"_PHEGDesc_"&%"_PHEFDesc_"&%"_dis_"&%"_age_"&%"_agelimit_"&%"_sex_"&%"_PHINSTText_"&%"_PHINSTDocUseTips_"&%"_PHINSTNote_"&%"_key0_"&%"_key1_"&%"_Lab_"&%"_LABLimit_"&%"_LABIUom_"&%"_organism_"&%"_genus
	q str
}

/// 知识库标识字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelCount()
ClassMethod GetLibaryLabelCount() As %String
{
	k ^TMPKBCOUNT("DHCPHLibaryLabel")
    s count=0
	s id=0,PHLICode=""
	for {
		s id=$o(^DHCPHLIBL(id)) q:id=""
		s PHLICode=$p($g(^DHCPHLIBL(id)),"^",1)       //工号
		continue:PHLICode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHLibaryLabel",count)=id
	}	
	q count
}

/// 知识库标识字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelInfo("2")
ClassMethod GetLibaryLabelInfo(i) As %String
{
	n (i)
	s str=""
	S PHLIRowId=$g(^TMPKBCOUNT("DHCPHLibaryLabel",i))
	q:(PHLIRowId="") ""
	s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
	s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
		
  	s str=PHLICode_"&%"_PHLIDesc_"&%"_PHLIActiveFlag
	q str
}

/// 知识库目录字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetInstLabelCount()
ClassMethod GetInstLabelCount() As %String
{
	k ^TMPKBCOUNT("DHCPHInstLabel")
    s count=0
	s id=0,PINLCode=""
	for {
		s id=$o(^DHCPHPINL(id)) q:id=""
		s PINLCode=$p($g(^DHCPHPINL(id)),"^",1)       //工号
		continue:PINLCode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHInstLabel",count)=id
	}	
	q count
}

/// 知识库目录字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelInfo("2")
ClassMethod GetInstLabelInfo(i) As %String
{
	n (i)
	s str=""
	S PINLRowID=$g(^TMPKBCOUNT("DHCPHInstLabel",i))
	q:(PINLRowID="") ""
	s PINLCode=$p($g(^DHCPHPINL(PINLRowID)),"^",1)
	s PINLDesc=$p($g(^DHCPHPINL(PINLRowID)),"^",2)
	s PINLOrderNum=$p($g(^DHCPHPINL(PINLRowID)),"^",3)
	s PINLManageMode=$p($g(^DHCPHPINL(PINLRowID)),"^",4)
	s PINLIcon=$p($g(^DHCPHPINL(PINLRowID)),"^",6)
	s PINLAllFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",7)
	s PHLIRowId=$p($g(^DHCPHPINL(PINLRowID)),"^",5)
	i PHLIRowId'="" {
		s PINLLabelDr=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	}
	else {
		s PINLLabelDr=""
	}
	s PINLAlertMsg=$p($g(^DHCPHPINL(PINLRowID)),"^",8)
	s PINLGenFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",9)
	s PINLProFlag=$p($g(^DHCPHPINL(PINLRowID)),"^",10)
		
  	s str=PINLCode_"&%"_PINLDesc_"&%"_PINLLabelDr_"&%"_PINLOrderNum_"&%"_PINLManageMode_"&%"_PINLIcon_"&%"_PINLAllFlag_"&%"_PINLAlertMsg_"&%"_PINLGenFlag_"&%"_PINLProFlag
	q str
}

/// 频率字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetExtFreqCount()
ClassMethod GetExtFreqCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtFreq")
    s count=0
	s id=0,PHEFCode=""
	for {
		s id=$o(^DHCPHEFR(id)) q:id=""
		s PHEFCode=$p($g(^DHCPHEFR(id)),"^",1)       //工号
		continue:PHEFCode=""
		if ($d(^DHCPHFRCON("0","Code",PHEFCode))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHFRCON("0","Code",PHEFCode,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHFRCON("0","Code",PHEFCode,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtFreq",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtFreq",count)=id
		}

	}	
	q count
}

/// 频率字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtFreqInfo("2")
ClassMethod GetExtFreqInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtFreq",i))
	s PHEFRowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(PHEFRowId="") ""
	s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)  //代码
	s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
  	s str="&%&%"_PHEFCode_"&%"_PHEFDesc
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHFRCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHFRCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_PHEFCode_"&%"_PHEFDesc
	
  	}
	q str
}

/// 剂型字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetExtFormCount()
ClassMethod GetExtFormCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtForm")
    s count=0
	s id=0,PHEFCode=""
	for {
		s id=$o(^DHCPHEF(id)) q:id=""
		s PHEFCode=$p($g(^DHCPHEF(id)),"^",1)       //工号
		continue:PHEFCode=""
		if ($d(^DHCPHFOCON("0","Code",PHEFCode))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHFOCON("0","Code",PHEFCode,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHFOCON("0","Code",PHEFCode,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtForm",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtForm",count)=id
		}

	}	
	q count
}

/// 剂型字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtFormInfo("2")
ClassMethod GetExtFormInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtForm",i))
	s PHEFRowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(PHEFRowId="") ""
	s PHEFCode=$p($g(^DHCPHEF(PHEFRowId)),"^",1)  //代码
	s PHEFDesc=$p($g(^DHCPHEF(PHEFRowId)),"^",2)  //描述
  	s str="&%&%"_PHEFCode_"&%"_PHEFDesc
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHFOCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHFOCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_PHEFCode_"&%"_PHEFDesc
	
  	}
	q str
}

/// 用法字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetExtInstrucCount()
ClassMethod GetExtInstrucCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtInstruc")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEINSTR(id)) q:id=""
		s Code=$p($g(^DHCPHEINSTR(id)),"^",1)       //工号
		continue:Code=""
		if ($d(^DHCPHINSTCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHINSTCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHINSTCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtInstruc",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtInstruc",count)=id
		}

	}	
	q count
}

/// 用法字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtInstrucInfo("2")
ClassMethod GetExtInstrucInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtInstruc",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEINSTR(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEINSTR(rowId)),"^",2)  //描述
  	s str="&%&%"_code_"&%"_desc
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHINSTCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHINSTCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	
  	}
	q str
}

/// 单位字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetExtUomCount()
ClassMethod GetExtUomCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtUom")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEUO(id)) q:id=""
		s Code=$p($g(^DHCPHEUO(id)),"^",1)       //工号
		continue:Code=""
		if ($d(^DHCPHUOCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHUOCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHUOCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtUom",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtUom",count)=id
		}

	}	
	q count
}

/// 单位字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtUomInfo("2")
ClassMethod GetExtUomInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtUom",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEUO(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEUO(rowId)),"^",2)  //描述
  	s str="&%&%"_code_"&%"_desc
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHUOCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHUOCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc
	
  	}
	q str
}

/// 分类类型字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetLibCatCount()
ClassMethod GetLibCatCount() As %String
{
	k ^TMPKBCOUNT("DHCPHLibCat")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^User.DHCPHLibCatD(id)) q:id=""
		s Code=$listGet($g(^User.DHCPHLibCatD(id)),2)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHLibCat",count)=id
	}	
	q count
}

/// 分类类型字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetLibaryLabelInfo("2")
ClassMethod GetLibCatInfo(i) As %String
{
	n (i)
	s str=""
	S myRowID=$g(^TMPKBCOUNT("DHCPHLibCat",i))
	q:(myRowID="") ""
	s PHICCode=$listGet($g(^User.DHCPHLibCatD(myRowID)),2)
	s PHICDesc=$listGet($g(^User.DHCPHLibCatD(myRowID)),3)
	s PHICLastLevel=$listGet($g(^User.DHCPHLibCatD(myRowID)),4)
	s:PHICLastLevel'="" PHICLastLevel=$listGet($g(^User.DHCPHLibCatD(PHICLastLevel)),3)
	s PHICLevel=$listGet($g(^User.DHCPHLibCatD(myRowID)),5)
	s PHICLibDr=$listGet($g(^User.DHCPHLibCatD(myRowID)),6)
	s:PHICLibDr'="" PHICLibDr=$p($g(^DHCPHLIBL(PHICLibDr)),"^",2)
	s PHICActiveFlag=$listGet($g(^User.DHCPHLibCatD(myRowID)),7)
	s PHICSysFlag=$listGet($g(^User.DHCPHLibCatD(myRowID)),8)
			
  	s str=PHICCode_"&%"_PHICDesc_"&%"_PHICLibDr_"&%"_PHICLastLevel_"&%"_PHICLevel_"&%"_PHICActiveFlag_"&%"_PHICSysFlag
	q str
}

/// 诊断字典
/// w ##class(web.DHCBL.BDP.ExportKBData).GetIcdFeildCount()
ClassMethod GetIcdFeildCount() As %String
{
	k ^TMPKBCOUNT("DHCExtIcdFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCEXTICD(id)) q:id=""
		s Code=$p($g(^DHCEXTICD(id)),"^",1)       //工号
		continue:Code=""
		if ($d(^DHCEXTICON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCEXTICON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCEXTICON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCExtIcdFeild",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCExtIcdFeild",count)=id
		}

	}	
	q count
}

/// 诊断字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetIcdFeildInfo("2")
ClassMethod GetIcdFeildInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCExtIcdFeild",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCEXTICD(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCEXTICD(rowId)),"^",2)  //描述
	
	//2类型（ICD9/ICD10/非ICD）
	s type=$p($g(^DHCEXTICD(rowId)),"^",3)
	s:type=9 type="ICD9"
	s:type=10 type="ICD10"
	s:type=99 type="非ICD"
	if ((type'="ICD9")&(type'="ICD10")&(type'="非ICD")&(type'="")){
		s type="ICD10"
	}
	//操作状态（放弃/确认）
	s OpStatus=$p($g(^DHCEXTICD(rowId)),"^",6)
	s:OpStatus=0 OpStatus="放弃"
	s:OpStatus=1 OpStatus="确认"
	if ((OpStatus'="放弃")&(OpStatus'="确认")&(OpStatus'="")){
		s OpStatus=""
	} 
	
	s ICDRemark=$p($g(^DHCEXTICD(rowId)),"^",7)
	s text ="",ICDText=""
	for {
		s text=$o(^DHCEXTICDKi(0,"ICDText",rowId,text)) q:text=""  
		s:ICDText'="" ICDText=ICDText_"#&"_text
		s:ICDText="" ICDText=text
	}	
  	s str="&%&%"_code_"&%"_desc_"&%"_type_"&%"_OpStatus_"&%"_ICDRemark_"&%"_ICDText
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCEXTICON(conid)),"^",2)
	  	s hisdesc=$p($g(^DHCEXTICON(conid)),"^",3)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_type_"&%"_OpStatus_"&%"_ICDRemark_"&%"_ICDText
	
  	}
	q str
}

/// 特殊人群字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetSpecialPopuCount()
ClassMethod GetSpecialPopuCount() As %String
{
	k ^TMPKBCOUNT("DHCSpecialPopu")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCSPEP(id)) q:id=""
		s Code=$p($g(^DHCSPEP(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCSpecialPopu",count)=id
	}	
	q count
}

/// 特殊人群字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetSpecialPopuInfo("2")
ClassMethod GetSpecialPopuInfo(i) As %String
{
	n (i)
	s str=""
	S SPERowId=$g(^TMPKBCOUNT("DHCSpecialPopu",i))
	q:(SPERowId="") ""
	s SPECode=$p($g(^DHCSPEP(SPERowId)),"^",1)
	s SPEDesc=$p($g(^DHCSPEP(SPERowId)),"^",2)
		
  	s str=SPECode_"&%"_SPEDesc
	q str
}

/// 药品成分字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtIngrCount()
ClassMethod GetExtIngrCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtIngr")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^User.DHCPHExtIngrD(id)) q:id=""
		s Code=$listGet($g(^User.DHCPHExtIngrD(id)),2)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHExtIngr",count)=id
	}	
	q count
}

/// 药品成分字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetExtIngrInfo("2")
ClassMethod GetExtIngrInfo(i) As %String
{
	n (i)
	s str=""
	S myRowID=$g(^TMPKBCOUNT("DHCPHExtIngr",i))
	q:(myRowID="") ""
	s PHEINGCode=$listGet($g(^User.DHCPHExtIngrD(myRowID)),2)
	s PHEINGDesc=$listGet($g(^User.DHCPHExtIngrD(myRowID)),3)
	s PHEINGLastLevel=$listGet($g(^User.DHCPHExtIngrD(myRowID)),4)
	s:PHEINGLastLevel'="" PHEINGLastLevel=$listGet($g(^User.DHCPHExtIngrD(PHEINGLastLevel)),3)
	s PHEINGLevel=$listGet($g(^User.DHCPHExtIngrD(myRowID)),5)
	s PHEINGActiveFlag=$listGet($g(^User.DHCPHExtIngrD(myRowID)),6)
	s PHEINGSysFlag=$listGet($g(^User.DHCPHExtIngrD(myRowID)),7)
	s PHEINGRelation=$listGet($g(^User.DHCPHExtIngrD(myRowID)),8)
	s PHEINGPivaTotalQty=$listGet($g(^User.DHCPHExtIngrD(myRowID)),9)
			
  	s str=PHEINGCode_"&%"_PHEINGDesc_"&%"_PHEINGLastLevel_"&%"_PHEINGLevel_"&%"_PHEINGActiveFlag_"&%"_PHEINGSysFlag_"&%"_PHEINGRelation_"&%"_PHEINGPivaTotalQty
	q str
}

/// 生理字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetPhysiologyCount()
ClassMethod GetPhysiologyCount() As %String
{
	k ^TMPKBCOUNT("DHCPhysiologyFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHYSIF(id)) q:id=""
		s Code=$p($g(^DHCPHYSIF(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPhysiologyFeild",count)=id
	}	
	q count
}

/// 生理字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetPhysiologyInfo("2")
ClassMethod GetPhysiologyInfo(i) As %String
{
	n (i)
	s str=""
	S PHYFRowId=$g(^TMPKBCOUNT("DHCPhysiologyFeild",i))
	q:(PHYFRowId="") ""
	s SPECode=$p($g(^DHCPHYSIF(PHYFRowId)),"^",1)
	s SPEDesc=$p($g(^DHCPHYSIF(PHYFRowId)),"^",2)
	s PHYFType=$p($g(^DHCPHYSIF(PHYFRowId)),"^",3)  //类型
	s PHYFActiveFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",4)  //是否可用
	s PHYFSysFlag=$p($g(^DHCPHYSIF(PHYFRowId)),"^",5)  //是否系统标识
  	s str=SPECode_"&%"_SPEDesc_"&%"_PHYFType_"&%"_PHYFActiveFlag_"&%"_PHYFSysFlag
	q str
}

/// 病症字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseCount()
ClassMethod GetDiseaseCount() As %String
{
	k ^TMPKBCOUNT("DHCPHDiseaseList")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHDISL(id)) q:id=""
		s Code=$p($g(^DHCPHDISL(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHDiseaseList",count)=id
	}	
	q count
}

/// 病症字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetDiseaseInfo("2")
ClassMethod GetDiseaseInfo(i) As %String
{
	n (i)
	s str=""
	S PHDISLRowId=$g(^TMPKBCOUNT("DHCPHDiseaseList",i))
	q:(PHDISLRowId="") ""
	s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
	s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
	s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
	s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
	s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
	s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",PHDISLRowId,0))
	s PHDISLKey=""
	s:keyid'="" PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
	s strAlias=##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias(PHDISLRowId,"A")
	s PHDISLAlias=$p(strAlias,"||",1)
	s PHDISLAlias=$tr(PHDISLAlias,",","#&")
	s aliasKey=$p(strAlias,"||",2)
	s strCom=##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias(PHDISLRowId,"C")
	s PHDISLCom=$p(strCom,"||",1)
	s PHDISLCom=$tr(PHDISLCom,",","#&")
	s comKey=$p(strCom,"||",2)	
	s comKey=$tr(comKey,",","#&")
	
	//关联的诊断
	s ICDCodeStr=""
	s DisRowId=PHDISLRowId,PHDISLIChildsub=0
	for {
		S PHDISLIChildsub=$o(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)) q:PHDISLIChildsub=""
		s PHDISLIRowId=DisRowId_"||"_PHDISLIChildsub
		s ICDRowId=$p($g(^DHCPHDISL(DisRowId,"ICD",PHDISLIChildsub)),"^",1)
		i ICDRowId'="" 
		{
			s ICDCode=$p($g(^DHCEXTICD(ICDRowId)),"^",1)
		}
		else 
		{
			s ICDCode=""
		}
		if (PHDISLIChildsub>0)&(ICDCode'="")
		{
			s:ICDCodeStr'="" ICDCodeStr=ICDCodeStr_"#&"_ICDCode
			s:ICDCodeStr="" ICDCodeStr=ICDCode
		}
		
	}
  	s str=PHDISLDiseaCode_"&%"_PHDISLDiseaDesc_"&%"_PHDISLKey_"&%"_PHDISLCom_"&%"_comKey_"&%"_PHDISLAlias_"&%"_PHDISLRemark_"&%"_ICDCodeStr
	q str
}

/// 年龄字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetAgeCount()
ClassMethod GetAgeCount() As %String
{
	k ^TMPKBCOUNT("DHCPHPatAgeList")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHPAGEL(id)) q:id=""
		s Code=$p($g(^DHCPHPAGEL(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHPatAgeList",count)=id
	}	
	q count
}

/// 年龄字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetAgeInfo("2")
ClassMethod GetAgeInfo(i) As %String
{
	n (i)
	s str=""
	S PDARowID=$g(^TMPKBCOUNT("DHCPHPatAgeList",i))
	q:(PDARowID="") ""
	s PDAAgeCode=$p($g(^DHCPHPAGEL(PDARowID)),"^",1)
	s PDAAgeDesc=$p($g(^DHCPHPAGEL(PDARowID)),"^",2)
	s PDAAgeMin=$p($g(^DHCPHPAGEL(PDARowID)),"^",3)
	s PDAAgeMax=$p($g(^DHCPHPAGEL(PDARowID)),"^",4)
	s PDAActiveFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",5)
	s PDASysFlag=$p($g(^DHCPHPAGEL(PDARowID)),"^",6)
	s UomRowId=$p($g(^DHCPHPAGEL(PDARowID)),"^",7)
	i UomRowId'="" {
		s PDAUomDr=$p($g(^DHCPHEUO(UomRowId)),"^",2)
	}
	else {
		s PDAUomDr=""
	}
  	s str=PDAAgeCode_"&%"_PDAAgeDesc_"&%"_PDAAgeMin_"&%"_PDAAgeMax_"&%"_PDAUomDr_"&%"_PDAActiveFlag_"&%"_PDASysFlag
	q str
}

/// 过敏史字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetAllergyCount()
ClassMethod GetAllergyCount() As %String
{
	k ^TMPKBCOUNT("DHCAllergyFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCALLERGY(id)) q:id=""
		s Code=$p($g(^DHCALLERGY(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCAllergyFeild",count)=id
	}	
	q count
}

/// 过敏史字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetAllergyInfo("2")
ClassMethod GetAllergyInfo(i) As %String
{
	n (i)
	s str=""
	S ALFRowId=$g(^TMPKBCOUNT("DHCAllergyFeild",i))
	q:(ALFRowId="") ""
	s ALFCode=$p($g(^DHCALLERGY(ALFRowId)),"^",1)  //代码
	s ALFDesc=$p($g(^DHCALLERGY(ALFRowId)),"^",2)  //描述
	s keys=""
	s upkey=""
	for  
	{	
		s upkey=$o(^DHCALLGYKEYi(0,"Key",ALFRowId,upkey)) q:upkey="" 
		s idd=$o(^DHCALLGYKEYi(0,"Key",ALFRowId,upkey,0))
		s ALKKey=""
		s:idd'="" ALKKey=$p($g(^DHCALLGYKEY(idd)),"^",2)  //关键字
		i (ALKKey'="")  //条件
		{
			s:keys'="" keys=keys_"#&"_ALKKey
			s:keys="" keys=ALKKey
		}		
	}
  	s str=ALFCode_"&%"_ALFDesc_"&%"_keys
	q str
}

/// 既往史字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetHistoryCount()
ClassMethod GetHistoryCount() As %String
{
	k ^TMPKBCOUNT("DHCDisHistoryFeild")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCDISHISF(id)) q:id=""
		s Code=$p($g(^DHCDISHISF(id)),"^",1)       //工号
		continue:Code=""
		s count=count+1
		s ^TMPKBCOUNT("DHCDisHistoryFeild",count)=id
	}	
	q count
}

/// 既往史字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetHistoryInfo("2")
ClassMethod GetHistoryInfo(i) As %String
{
	n (i)
	s str=""
	S DHIRowId=$g(^TMPKBCOUNT("DHCDisHistoryFeild",i))
	q:(DHIRowId="") ""
	s DHICode=$p($g(^DHCDISHISF(DHIRowId)),"^",1)  //代码
	s DHIDesc=$p($g(^DHCDISHISF(DHIRowId)),"^",2)  //描述
	s keys=""
	s upkey=""
	for  
	{	
		s upkey=$o(^DHCDISHISKi(0,"Key",DHIRowId,upkey)) q:upkey="" 
		s idd=$o(^DHCDISHISKi(0,"Key",DHIRowId,upkey,0))
		s key=""
		s:idd'="" key=$p($g(^DHCDISHISK(idd)),"^",2)  //关键字
		i (key'="")  //条件
		{
			s:keys'="" keys=keys_"#&"_key
			s:keys="" keys=key
		}		
	}
  	s str=DHICode_"&%"_DHIDesc_"&%"_keys
	q str
}

/// 通用名（药品）
/// w ##class(web.DHCBL.BDP.ExportKBData).GetGenericCount()
ClassMethod GetGenericCount() As %String
{
	k ^TMPKBCOUNT("DHCPHExtGeneric")
    s count=0
	s id=0,Code=""
	for {
		s id=$o(^DHCPHEGEN(id)) q:id=""
		s Code=$p($g(^DHCPHEGEN(id)),"^",1)       //工号
		s lib=""
		s PHEGLibDr=$p($g(^DHCPHEGEN(id)),"^",7) 
		s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
		continue:Code=""
		continue:lib'="药品"
		if ($d(^DHCPHGENCON("0","Code",Code))>0){
			s hiscode =""
			for {
				s hiscode=$o(^DHCPHGENCON("0","Code",Code,hiscode)) q:hiscode=""  
				s conid=$o(^DHCPHGENCON("0","Code",Code,hiscode,0))
				continue:conid=""
				s count=count+1	
				s ^TMPKBCOUNT("DHCPHExtGeneric",count)=id_"#"_conid
			}		
		}else{
			s count=count+1
			s ^TMPKBCOUNT("DHCPHExtGeneric",count)=id
		}

	}	
	q count
}

/// 通用名（药品）
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetGenericInfo("1")
ClassMethod GetGenericInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPKBCOUNT("DHCPHExtGeneric",i))
	s rowId=$p(idstr,"#",1)
	s conid=$p(idstr,"#",2)
	q:(rowId="") ""
	s code=$p($g(^DHCPHEGEN(rowId)),"^",1)  //代码
	s desc=$p($g(^DHCPHEGEN(rowId)),"^",2)  //描述
	s keys=""  //通用名别名
	s PHEGAlRowId=0
	for  
	{	
		s PHEGAlRowId=$o(^DHCPHEGALi(0,"Gen",rowId,PHEGAlRowId)) q:PHEGAlRowId="" 
		if (keys'="") 
		{
			s keys=keys_"#&"_$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}
		else
		{
			s keys=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",2)
		}		
	}
	//知识库通用名剂型
	s GlPRowId=$o(^DHCGENLINPi(0,"Gen",rowId,0))
	s GlPPointer=""
	s:GlPRowId'="" GlPPointer=$p($g(^DHCGENLINP(GlPRowId)),"^",2)
	s form=""
	s:GlPPointer'="" form=$p($g(^DHCPHEF(GlPPointer)),"^",2)
	
	//知识库标识
	s lib=""
	s PHEGLibDr=$p($g(^DHCPHEGEN(rowId)),"^",7) 
	s:PHEGLibDr'="" lib=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",2)
	
	//ATC编码
	s atc=""
	s PHGPRRowId=$o(^DHCPHDGPi(0,"Gen",rowId,0))
	s:PHGPRRowId'="" atc=$p($g(^DHCPHDGP(PHGPRRowId)),"^",2)
	
	//分类^User.DHCPHLibCatD
	s PHGPRCatDr=""
	s:PHGPRRowId'="" PHGPRCatDr=$p($g(^DHCPHDGP(PHGPRRowId)),"^",4)
	s type=""
	s:PHGPRCatDr'="" type=$listGet($g(^User.DHCPHLibCatD(PHGPRCatDr)),3)
	
	//成分
	s PHEGIRowId=$o(^DHCPHEGENINi(0,"GEN",rowId,0))
	s PHEGIIngrDr=""
	s:PHEGIRowId'="" PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)
	s ingr=""
	s:PHEGIIngrDr'="" ingr=$listGet($g(^User.DHCPHExtIngrD(PHEGIIngrDr)),3)
	
	s PHEGILevel=""
	s:PHEGIRowId'="" PHEGILevel=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",3)
	if (PHEGILevel'=""){
	 //主要成分标识（,一级,二级,三级） 
		s:PHEGILevel="1" leval="一级" 
		s:PHEGILevel="2" leval="二级" 
		s:PHEGILevel="3" leval="三级"  
	}
	else
	{
		s leval=""
	}	
  	s str="&%&%"_code_"&%"_desc_"&%"_keys_"&%"_form_"&%"_lib_"&%"_atc_"&%"_type_"&%"_ingr_"&%"_leval
  	
  	if (conid'="")
  	{
	  	s hiscode=$p($g(^DHCPHGENCON(conid)),"^",3)
	  	s hisdesc=$p($g(^DHCPHGENCON(conid)),"^",4)
  		s str=hiscode_"&%"_hisdesc_"&%"_code_"&%"_desc_"&%"_keys_"&%"_form_"&%"_lib_"&%"_atc_"&%"_type_"&%"_ingr_"&%"_leval
	
  	}
	q str
}

/// 厂家字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetPHManfCount()
ClassMethod GetPHManfCount() As %String
{
	k ^TMPKBCOUNT("DHCPHManf")
    s count=0
	s id=0,PHMACode=""
	for {
		s id=$o(^DHCPHMANF(id)) q:id=""
		s PHMACode=$p($g(^DHCPHMANF(id)),"^",1)       //工号
		continue:PHMACode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHManf",count)=id
	}	
	q count
}

/// 厂家字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetPHManfInfo("2")
ClassMethod GetPHManfInfo(i) As %String
{
	n (i)
	s str=""
	S PHMARowId=$g(^TMPKBCOUNT("DHCPHManf",i))
	q:(PHMARowId="") ""
	s PHMACode=$p($g(^DHCPHMANF(PHMARowId)),"^",1)
	s PHMADesc=$p($g(^DHCPHMANF(PHMARowId)),"^",2)
	s PHMAActiveFlag=$p($g(^DHCPHMANF(PHMARowId)),"^",3)
		
  	s str=PHMACode_"&%"_PHMADesc_"&%"_PHMAActiveFlag
	q str
}

/// 草药毒性字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetPHToxicityCount()
ClassMethod GetPHToxicityCount() As %String
{
	k ^TMPKBCOUNT("DHCPHToxicity")
    s count=0
	s id=0,ToxCode=""
	for {
		s id=$o(^DHCPHTOX(id)) q:id=""
		s ToxCode=$p($g(^DHCPHTOX(id)),"^",1)       //工号
		continue:ToxCode=""
		s count=count+1
		s ^TMPKBCOUNT("DHCPHToxicity",count)=id
	}	
	q count
}

/// 草药毒性字典
/// /w ##class(web.DHCBL.BDP.ExportKBData).GetPHToxicityInfo("2")
ClassMethod GetPHToxicityInfo(i) As %String
{
	n (i)
	s str=""
	S ToxRowId=$g(^TMPKBCOUNT("DHCPHToxicity",i))
	q:(ToxRowId="") ""
	s ToxCode=$p($g(^DHCPHTOX(ToxRowId)),"^",1)
	s ToxDesc=$p($g(^DHCPHTOX(ToxRowId)),"^",2)
	s ToxActiveFlag=$p($g(^DHCPHTOX(ToxRowId)),"^",3)
		
  	s str=ToxCode_"&%"_ToxDesc_"&%"_ToxActiveFlag
	q str
}

}

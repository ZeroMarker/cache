/// 名称:	EMR.OP.BL.LocTemplateRules
/// 描述:	门诊病历 科室模板规则业务类
/// 编写者：yejian
/// 编写日期: 2022-6-20
/// 产品组：电子病历产品组
Class EMR.OP.BL.LocTemplateRules Extends %RegisteredObject
{

/// Desc:       判断模板是否保存过
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      aEpisodeID:病人就诊号
/// 			aTemplateID 模板ID
/// OutPut:     -1 失败, 0 没有保存，保存返回实例id
/// Debug: 		w ##class(EMR.OP.BL.LocTemplateRules).GetFirstSavedID("67","43")   
ClassMethod GetFirstSavedID(aEpisodeID As %String, aTemplateID As %String) As %String
{
	s ReturnValue = "0"
	q:(aEpisodeID="")||(aTemplateID="") "-1"
	
	s curseq = ""
	s TILDocumentData = ##class(EMR.DAO.DocumentData).GetTureIndexLocation(aEpisodeID)
	//判断日志是否已保存过,修改增加状态判断，如果有日志，切不为删除状态。
	s RowID = ""
	for
	{
		s RowID = $o(@TILDocumentData@("IdxEpisodeTemplateStatus",aEpisodeID,aTemplateID,RowID))
		q:(RowID="")
		s objDoc = ##class(EMR.DAO.DocumentData).doOpenByID(RowID)
		q:(objDoc="")
		if (objDoc.EMRStatus'="")&&(objDoc.EMRStatus.Code '="deleted")
		{
	 		s ReturnValue=RowID
	 		q
		}
	}
	q ReturnValue
}

/// Desc:      判断模板是否适用于指定的病人
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      aLocTemID 模板ID
/// 			aPatInfo--病人信息列表（如 科室、性别等）
/// OutPut:     1--适用  0--不适用
/// Debug: 		w ##class(EMR.OP.BL.LocTemplateRules).CanTempAct("1","")
ClassMethod CanTempAct(aLocTemID As %String, aPatInfo As %Library.List) As %Status
{
	q:(($d(aLocTemID)=0) || (aLocTemID = "")) 0
 	q:(($d(aPatInfo)=0) || (aPatInfo = "")) 0
	s privResult = 0
 	set ruleID = ""
 	for 
 	{
		set ruleID = $o(^CF.EMR.DOC.LocTemplateRulesI("TemplateIDIdx",aLocTemID,ruleID)) //注：此处取得的 groupID 在左侧含有空格
		q:(ruleID="")
		
		//遍历该模板组下的规则，校验是否有规则适合
		s tempPrivResult = ..CheckPriv(ruleID, aPatInfo)
		if (tempPrivResult =  1)
		{
			s privResult = 1
			q
		}
 	}
 	q privResult
}

/// Desc:      判断当前病人是否符合某一条规则（parRestrictionId指定的规则）
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      pRuleId--规则的配置串(如 PATDEPT:129^PATTYPE:19);
/// 			aPatInfo--病人信息列表（如 科室、性别等）
/// OutPut:     1--适用  0--不适用
/// Debug:
ClassMethod CheckPriv(aRuleId As %String, aPatInfo As %Library.List) As %Status
{
	q:(($d(aRuleId)=0) || (aRuleId = "")) 0
 	q:(($d(aPatInfo)=0) || (aPatInfo = "")) 0
 	
 	//取出规则中的条件
 	s ruleCondition = $lg(^CF.EMR.DOC.LocTemplateRulesD(aRuleId), 3)
	q:(ruleCondition = "") 0
	
	s:(ruleCondition'["SSLAN") ruleCondition = ruleCondition_"^SSLAN:CH"
	
 	//根据规则的类型组合数据去判断权限的有效性
 	s privResult = 1
 	for i=1:1:$l(ruleCondition,"^")
 	{
		s strType = $p(ruleCondition,"^",i)
		q:(($d(strType)=0)||(strType = ""))
		s strTName = $p(strType,":",1)
		s strTValue = ..GetTypeValue(strTName,aPatInfo)
		s curType = strTName_":"_strTValue
		s:(curType '= strType) privResult=0
		q:(privResult = 0)
	}
	q privResult
}

/// Desc:      取出病人某一个单项的数据
/// Creator:    yejian
/// CreateDate: 2022-6-17
/// Table:		CF.EMR.DOC.TemplateRules
/// Input:      aType--规则单项的类型(如 PATDEPT)
/// 			aPatInfo--病人信息列表（如 科室、性别等）
/// OutPut:     1--适用  0--不适用
/// Debug:
ClassMethod GetTypeValue(aType As %String, aPatInfo As %Library.List) As %String
{
	q:(($d(aType)=0) || (aType = "")) ""
	
	s data = ""
	
	for j=1:1:$ll(aPatInfo) 
	{
		s PIItem=$li(aPatInfo,j)
		if ($p(PIItem,$c(2),1)=aType) 
		{
			s data=$p(PIItem,$c(2),2)
			quit
		}
	}
	q data
}

}

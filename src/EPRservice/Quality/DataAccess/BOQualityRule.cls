/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOQualityRule
/// * Description:	质控标准服务类
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOQualityRule Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityRuleInfo";

///  *****************************************************
///  功能：获取所有质控标准
///  *****************************************************
ClassMethod SelectAllQualityRules() As EPRservice.dataset.Quality.EQualityRuleDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.Quality.EQualityRuleDataset).%New()
	q result
}

///  *****************************************************
///  功能：根据RowId获取对应质控标准
///  入参：RowId为质控标准表QualityRule的ID
///  *****************************************************
ClassMethod GetQualityRuleByID(ARowId As %String) As EPRservice.entity.Quality.EQualityRule [ WebMethod ]
{
	s objQualityRule = ##class(EPRmeta.Quality.QualityRule).%OpenId(ARowId)
	q:(objQualityRule = "") ""
	
	s Result = ##class(EPRservice.entity.Quality.EQualityRule).%New()
	s Result.ID = ARowId
	s Result.Code = objQualityRule.Code
	s Result.Name = objQualityRule.Name
	s Result.StructDR = objQualityRule.StructDR
	s Result.IsActive = objQualityRule.IsActive
	s Result.ResumeText = objQualityRule.ResumeText
	
 	q Result
}

///  *****************************************************
///  功能：创建质控标准
///  *****************************************************
ClassMethod CreateQualityRule(AQualityRule As EPRservice.entity.Quality.EQualityRule) As %String [ WebMethod ]
{
	TSTART
	s objQualityRule = ##class(EPRmeta.Quality.QualityRule).%New()
	
	s flag = ##class(EPRmeta.Quality.QualityRule).CheckCodeUnique(AQualityRule.Code) 
	if '(flag = 0)
 	{ 
 		q "-1"
 	} 
	s objQualityRule.Code = AQualityRule.Code
	s objQualityRule.Name = AQualityRule.Name
	s objQualityRule.StructDR = AQualityRule.StructDR
	s objQualityRule.IsActive = AQualityRule.IsActive
	s objQualityRule.ResumeText = AQualityRule.ResumeText
	
	if '(objQualityRule.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q objQualityRule.%Id()
}

///  *****************************************************
///  功能：更新质控标准
///  *****************************************************
ClassMethod UpdateQualityRule(AQuaRule As EPRservice.entity.Quality.EQualityRule) As %String [ WebMethod ]
{
	TSTART
	s objQuaRule = ##class(EPRmeta.Quality.QualityRule).%OpenId(AQuaRule.ID)
	q:(objQuaRule = "") "ERROR"
	
	s objQuaRule.Code = AQuaRule.Code
	s objQuaRule.Name = AQuaRule.Name
	s objQuaRule.StructDR = AQuaRule.StructDR
	s objQuaRule.IsActive = AQuaRule.IsActive
	s objQuaRule.ResumeText = AQuaRule.ResumeText
	
	if '(objQuaRule.%Save())
 	{
 		TROLLBACK
 		q "0"
 	} 
 	TCOMMIT
 	q "1"
}

///  *****************************************************
///  功能：根据ID删除质控标准
///  *****************************************************
ClassMethod DeleteQualityRuleById(ARuleID As %String) As %Boolean [ WebMethod ]
{
	TSTART
 	s objQuaRule = ##class(EPRmeta.Quality.QualityRule).%OpenId(ARuleID)
	q:(objQuaRule ="") 0 

 	if '(objQuaRule.%DeleteId(ARuleID))
 	{
 		TROLLBACK
 		q 0
 	} 
 	TCOMMIT
 	q 1
}

/// Debug: w ##Class(EPRservice.Quality.DataAccess.BOQualityRule).BatchDeleteQualityRule()
ClassMethod BatchDeleteQualityRule(ARuleIDs As %String) As %String [ WebMethod ]
{
	s ret=0
	q:(ARuleIDs="") ret

	TStart
	s RuleIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleIDs,"|")
	for Ind=1:1:$listlength(RuleIDs) 
	{
		s RuleID = $listget(RuleIDs,Ind)
		continue:(RuleID="")
		
		s flag = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).BatchRemoveEntriesByRuleID(RuleID)
		if (flag<1)
		{
			TRollBack
			q	
		}
		
		s objRule = ##Class(EPRmeta.Quality.QualityRule).%OpenId(RuleID)
		continue:objRule=""
		
		if '(objRule.%DeleteId(RuleID))
		{
			TRollBack
			q	
		}
	}
	TCommit
	s ret=1
	q ret
}

/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityRule","GetQualityRules","","A^F^G")
Query GetQualityRules(ARuleDesc As %String, ARuleCodes As %String = "") As %Query(ROWSPEC = "RowID,RuleCode,RuleName")
{
}

ClassMethod GetQualityRulesExecute(ByRef qHandle As %Binary, ARuleDesc As %String, ARuleCodes As %String = "") As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	k ^CacheTemp("EPRQuality","QualityRules",repid)
	
	s RowID = ""
	for {
		s RowID = $o(^DHCEPRM.QualityRuleD(RowID))
		q:(RowID = "")
		
		s objRule = $g(^DHCEPRM.QualityRuleD(RowID))
		continue:(objRule = "")
		
		s IsActive = $list(objRule,4)	
		continue:(IsActive '= "Y")
		
		s RuleCode=$list(objRule,1)
		continue:(ARuleCodes '= "")&&(ARuleCodes '[ RuleCode)
		
		s RuleName=$list(objRule,2)
		continue:(ARuleDesc '= "")&&($$ALPHAUP^SSUTIL4(RuleName) '[ ARuleDesc)
		
		s ^CacheTemp("EPRQuality","QualityRules",repid,RuleCode) = $lb(RowID,RuleCode,RuleName)
	}
	
	q:('$d(^CacheTemp("EPRQuality","QualityRules",repid))) $$$OK
	
	s Code = ""
	for {
		s Code = $o(^CacheTemp("EPRQuality","QualityRules",repid,Code))
		q:(Code = "")
		
		s Data = $g(^CacheTemp("EPRQuality","QualityRules",repid,Code))
		s ^CacheTemp(repid,ind) = Data
		s ind = ind+1	
	}
	
	k ^CacheTemp("EPRQuality","QualityRules",repid)
	
	q $$$OK
}

ClassMethod GetQualityRulesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualityRulesExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	}
 	else {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetQualityRulesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQualityRulesExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Debug: w ##Class(EPRservice.Quality.DataAccess.BOQualityRule).GetQualityRulesByCodes("A^B")
ClassMethod GetQualityRulesByCodes(ARuleCodes As %String) As %String
{
	s ret = ""
	q:(ARuleCodes = "") ret
	
	s IsFirst = 0
	s UniqueKey = $i(^CacheTemp)
		
	s lstRuleCodes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ARuleCodes,"^")
	for i = 1:1:$listlength(lstRuleCodes)
	{
		s RuleCode = $listget(lstRuleCodes,i)
		continue:(RuleCode = "")
		
		s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode",RuleCode,""))
		continue:(RuleID = "")
		
		s objRule = $g(^DHCEPRM.QualityRuleD(RuleID))
		continue:(objRule = "")
		
		s IsActive = $list(objRule,4)
		continue:(IsActive '= "Y")
		
		s RuleName=$list(objRule,2)
		
		if (IsFirst = 0)
		{
			s ret = RuleID_"^"_RuleCode_"^"_RuleName
			s IsFirst = 1	
		}
		else
		{
			s ret = ret_"|"_RuleID_"^"_RuleCode_"^"_RuleName	
		}
	}
	
	q ret
}

}

/// 名称：		EMRservice.BOTemplateSignRuleList
/// 描述：		模板签名规则BO层
/// 编写者：	yejian
/// 编写时间：	2019-3-20
Class EMRservice.BOTemplateSignRuleList Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateSignRuleInfo";

/// Creator:	yejian
/// CreatDate:  2019-3-20
/// Desc:		根据模板ID和标题获取模板规则
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTempalteSignRuleList","SelectTemSignRule","1","")
ClassMethod SelectTemSignRule(aTemplateID As %String, aTitleCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTempalteSignRuleList:SelectTemSignRule")
	d result.SetArgs(aTemplateID,aTitleCode)
	q result
}

/// Creator:	yejian
/// CreatDate:  2019-3-20
/// Desc:		更新模板规则
ClassMethod SaveTemplateSignRule(aTemplateSignRule As EMRservice.entity.ETemplateSignRuleList) As %String [ WebMethod ]
{
	
	Set result=##class(EMRservice.BL.BLTempalteSignRuleList).SaveTemplateSignRule(aTemplateSignRule)	
	Quit result
}

}

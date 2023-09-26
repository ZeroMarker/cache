/// 名称：		EMRservice.BL.BLTitles
/// 描述：		待签BO层
/// 编写者：	yejian
/// 编写时间：	2018-12-5
Class EMRservice.BOTemplateSign Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateSignInfo";

ClassMethod getSignRole() As EMRservice.dataset.ESignRoleDataset [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.ESignRoleDataset).%New()
    Quit result
}

/// 获取模板版本签名数据
ClassMethod SelectSignData(aTemplateID As %String, aVersionNum As %String) As EMRservice.dataset.ETemplateSignDataSet [ WebMethod ]
{
	s result = ##Class(EMRservice.dataset.ETemplateSignDataSet).%New()
	d result.SetArgs(aTemplateID,aVersionNum)
	q result
}

/// 添加待签数据
ClassMethod AddTemplateSignS(aTemplateSign As EMRservice.entity.ETemplateSign, aSignS As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EMRservice.BL.BLTemplateSign).AddTemplateSignS(aTemplateSign,aSignS)	
	Quit result
}

/// 添加待签数据(根据版本)
ClassMethod AddTemSignSByVersion(aTemplateID As %String, aOVersion As %String, aNVersion As %String) As %String [ WebMethod ]
{
	
	Set result=##class(EMRservice.BL.BLTemplateSign).AddTemSignSByVersion(aTemplateID,aOVersion,aNVersion)	
	Quit result
}

/// 删除一个标题
ClassMethod DeleteSignByIDs(aSignIds As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateSign).DeleteSignByIDs(aSignIds)
}

/// 删除一个标题
ClassMethod DelTemSignSByVersion(aTemplateID As %String, aVersion As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateSign).DelTemSignSByVersion(aTemplateID,aVersion)
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		更新角色规则）
/// Input：     aTemplateID:模板ID，
ClassMethod GetTitleRelevance(aTemplateID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateSign).GetTitleRelevance(aTemplateID)
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		更新角色规则
/// Input：		aRoleRuleS数据格式为(格式为 RoleRuleCode^RoleRuleCode)
/// Return：	失败：0，成功：1
ClassMethod UpdateRoleRuleS(aTemplateSign As EMRservice.entity.ETemplateSign, aRoleRuleS As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateSign).UpdateRoleRuleS(aTemplateSign,aRoleRuleS)
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		跟新排序
/// Return：	失败：0，成功：1
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateSign).UpdateSequences(argStr)
}

}

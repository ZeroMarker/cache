/// 名称：		EMRservice.BOUserTemplateKBNode
/// 描述：		用户模板章节关联知识库BO层
/// 编写者：	yejian
/// 编写时间：	2017-11-9
Class EMRservice.BOUserTemplateKBNode Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "UserTemplateKBNodeInfo";

/// 根据用户模板编码获取知识库关联节点集
/// w ##Class(EMRservice.BOUserTemplateKBNode).GetTreeIDByBaseIDCtLocID("79","85")
ClassMethod GetTreeIDByBaseIDCtLocID(aKBBaseID As %String, aCTLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateKBNode).GetTreeIDByBaseIDCtLocID(aKBBaseID,aCTLocID)
}

//根据ID获取知识库关联

/// 根据科室ID获取用户模板
/// Debug: d ##class(EMRservice.BOUserTemplateKBNode).GetKBNodeSByUserTempCode("1")
ClassMethod GetKBNodeSByUserTempCode(aCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateKBNode:GetKBNodeSByUserTempCode")
	d result.SetArgs(aCode)
	q result
}

/// 添加用户模板知识库
ClassMethod AddUserTemplateKBNode(AUserTemplateKB As EMRservice.entity.EUserTemplateKBNode) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateKBNode).AddUserTemplateKBNode(AUserTemplateKB)
}

/// 修改用户模板知识库
ClassMethod ModUserTemplateKBNode(AUserTemplateKB As EMRservice.entity.EUserTemplateKBNode) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateKBNode).ModUserTemplateKBNode(AUserTemplateKB)
}

/// 设为无效
ClassMethod Delete(RowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateKBNode).Delete(RowID)
}

/// 清理临时global
ClassMethod ClearUserTemKBGlobal(aUserTemID As %String, aUserTKey As %String) [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateKBNode).ClearUserTemKBGlobal(aUserTemID,aUserTKey)
}

}

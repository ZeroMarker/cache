Class EMRservice.BOKBTreeTitlesRule Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBTreeTitlesRuleInfo";

ClassMethod SELECTALLBYKBTreeID(aKBTreeID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBTreeTitlesRule:SELECTALLBYKBTreeID")
	d result.SetArgs(aKBTreeID)
	q result
}

/// 增加一个章节
ClassMethod CreateKBTreeTitleRule(aEKBTreeTitleInfo As EMRservice.entity.EKBTreeTitlesRule) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBTreeTitlesRule).CreateKBTreeTitleRule(aETitleInfo)
}

/// 删除一个章节
ClassMethod DeleteKBTreeTitleRuleByID(aKBTreeTitlesRuleId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBTreeTitlesRule).DeleteKBTreeTitleRuleByID(aKBTreeTitlesRuleId)
}

/// 更新一个章节
ClassMethod UpdateKBTreeTitleRule(aEKBTreeTitleInfo As EMRservice.entity.EKBTreeTitlesRule) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBTreeTitlesRule).UpdateKBTreeTitleRule(aETitleInfo)
}

/// Creator:yejan
/// Return:1-保存成功 0-保存失败
/// Others:保存操作存在三种可能:1、新增操作:原先库里不存在该知识库节点的记录,直接插入数据
/// 	   2、更新操作:原先库里已经存在该知识库节点的记录,但该记录为失效状态,即ActiveFlag为0,更新数据,将ActiveFlag设置为1
/// 	   3、删除操作:原先库里已经存在该知识库节点的记录,且该记录为有效状态,即ActiveFlag为1,更新数据,将ActiveFlag设置为0
/// Debug:d ##class(EMRservice.BOKBTreeTitlesRule).SaveBindTitle(2695,"008^007^006")
ClassMethod SaveBindTitle(aKbTreeID As %String, aTitleCodeStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBTreeTitlesRule).SaveBindTitle(aKbTreeID,aTitleCodeStr)
}

}

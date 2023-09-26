/// 名称：		EMRservice.BOPrivRuleStore
/// 描述：		规则脚本仓库BO层
/// 编写者：	yejian
/// 编写时间：	2021-5-28
Class EMRservice.BOPrivRuleStore Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "PrivRuleStoreInfo";

/// Desc:       获取规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      
/// OutPut:     返回数据 %XML.DataSet,
/// Debug: d ##class(EMRservice.BOPrivRuleStore).GetPrivRuleStore("1")
ClassMethod GetPrivRuleStore() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivRuleStore:GetPrivRuleStore")
	d result.SetArgs()
	q result
}

/// Desc:       添加规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      aEPrivRuleStore 仓库对象
/// OutPut:     返回数据 成功 ID,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleStore).AddPrivRuleItem(aEPrivRuleStore)
ClassMethod AddPrivRuleItem(aEPrivRuleStore As EMRservice.entity.EPrivRuleStore) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleStore).AddPrivRuleItem(aEPrivRuleStore)
}

/// Desc:       修改规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      aEPrivRuleStore 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleStore).UpPrivRuleItem(aEPrivRuleStore)
ClassMethod UpPrivRuleItem(aEPrivRuleStore As EMRservice.entity.EPrivRuleStore) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleStore).UpPrivRuleItem(aEPrivRuleStore)
}

/// Desc:       删除规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleStore).DelPrivRuleItem("1")
ClassMethod DelPrivRuleItem(rowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleStore).DelPrivRuleItem(rowID)
}

/// Desc:       脚本仓库排序
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleStore).UpdateSequences("")
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleStore).UpdateSequences(argStr)
}

/// Desc:       测试脚本
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleStore).DelPrivRuleItem("1")
ClassMethod TestRuleItem(argEnviromentInfo As %String, aRuleCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleStore).TestRuleItem(argEnviromentInfo,aRuleCode)
}

}

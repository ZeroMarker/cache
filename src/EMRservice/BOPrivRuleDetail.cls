/// 名称：		EMRservice.BOPrivRuleDetail
/// 描述：		规则脚本BO层
/// 编写者：	yejian
/// 编写时间：	2021-5-28
Class EMRservice.BOPrivRuleDetail Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "PrivRuleDetailInfo";

/// Desc:       获取规则脚本
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      
/// OutPut:     返回数据 %XML.DataSet,
/// Debug: d ##class(EMRservice.BOPrivRuleDetail).GetPrivRuleStore("1")
ClassMethod GetPrivRuleDetail() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivRuleDetail:GetPrivRuleDetail")
	d result.SetArgs()
	q result
}

/// Desc:       获取规则脚本
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      
/// OutPut:     返回数据 EMRservice.entity.EPrivRuleDetail,
/// Debug: d ##class(EMRservice.BOPrivRuleDetail).GetDetailByID("1")
ClassMethod GetDetailByID(aID As %String) As EMRservice.entity.EPrivRuleDetail [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPrivRuleDetail).GetDetailByID(aID)
}

/// Desc:       修改规则脚本仓库
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      aEPrivRuleStore 仓库对象
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleDetail).UpPrivRuleItem(aEPrivRuleStore)
ClassMethod SavePrivRule(AHospGroupId As %String, APrivRuleType As %String, APrivRuleJsonString As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPrivRuleConfigView).SavePrivRule(AHospGroupId,APrivRuleType,APrivRuleJsonString)
}

/// Desc:       删除规则脚本
/// Creator:    yejian
/// CreateDate: 2021-5-28
/// Input:      rowID
/// OutPut:     返回数据 成功 1,失败 -1,
/// Debug: d ##class(EMRservice.BOPrivRuleDetail).DelPrivRuleItem("1")
ClassMethod DelPrivRuleItem(rowID As %String, AHospGroupId As %String, APrivRuleType As %String, APrivRuleJsonString As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLPrivRuleDetail).DelPrivRuleItem(rowID,AHospGroupId,APrivRuleType,APrivRuleJsonString)
}

}

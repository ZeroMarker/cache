/// 名称：		EMRservice.BOTemplateSignRuleList
/// 描述：		角色签名规则BO层
/// 编写者：	yejian
/// 编写时间：	2019-3-20
Class EMRservice.BORoleSignRuleList Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "RoleSignRuleInfo";

/// Creator:	yejian
/// CreatDate:  2019-3-20
/// Desc:		获取角色规则数据
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLRoleSignRuleList","SelectTemSignRule","")
ClassMethod SelectRoleSignRule() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLRoleSignRuleList:SelectRoleSignRule")
	d result.SetArgs()
	q result
}

}

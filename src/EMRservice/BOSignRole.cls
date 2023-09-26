/// 名称：		EMRservice.BOSignRole
/// 描述：		签名角色维护BO层
/// 编写者：	yejian
/// 编写时间：	2020-7-29
Class EMRservice.BOSignRole Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SignRoleInfo";

ClassMethod getSignRole() As EMRservice.dataset.ESignRole [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.ESignRole).%New()
    Quit result
}

/// Creator:	yejian
/// CreatDate:  2020-7-29
/// Desc:		更新签名角色属性
/// Input：		aSignRole签名角色对象
/// Return：	失败：0，成功：1
ClassMethod UpdateSignRole(aSignRole As EMRservice.entity.ESignRoleData) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSignRole).UpdateSignRole(aSignRole)
}

}

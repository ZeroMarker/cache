/// 名称:EMRmeta.PrivRuleType
/// 描述:持久化类EMRmeta.PrivRuleType的业务类 CRUD
/// 编写者:guozongtao
/// 编写日期:2010-05-10
Class EMRservice.BOPrivRuleType Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.BOPrivRuleType";

ClassMethod Add(argPrivRuleType As EMRservice.entity.EPrivRuleType) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleType).Add(argPrivRuleType)
}

ClassMethod Delete(argID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleType).Delete(argID)
}

ClassMethod Update(argPrivRuleType As EMRservice.entity.EPrivRuleType) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleType).Update(argPrivRuleType)
}

ClassMethod GetById(argID As %String) As EMRservice.entity.EPrivRuleType [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRuleType).GetById(argID)
}

ClassMethod SelectAll() As EMRservice.dataset.EPrivRuleTypeDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EPrivRuleTypeDataSet).%New()
 Quit result
}

}

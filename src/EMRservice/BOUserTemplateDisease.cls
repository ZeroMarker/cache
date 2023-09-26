/// 名称：		EMRservice.BOUserTemplateDisease
/// 描述：		科室模板病种BO层
/// 编写者：	yejian
/// 编写时间：	2019-7-31
Class EMRservice.BOUserTemplateDisease Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "UserTemplateDiseaseInfo";

/// Creator: yejian
/// CreatDate: 2019-8-1
/// Description：获取科室模板关联的所有病种
/// Input: aItemCode,
/// Return: 病种编码1^病种编码2^病种编码3
ClassMethod GetItemDisease(aItemCode As %String) As EMRservice.entity.EUserTemplateDisease [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateDisease).GetItemDisease(aItemCode)
}

/// Creator: yejian
/// CreatDate: 2019-8-1
/// Description：更新指定科室模板项关联的病种
/// Input: aItemCode-科室模板编码 sltDCodes--所有选中的病种Code串(格式为 Code1^Code2^Code3), unsltDCodes--所有未选中病种Code串(格式为 Code1^Code2^Code3)
/// Return: 1
ClassMethod ModifyDisease(aItemCode As %String, aUserTemDisease As EMRservice.entity.EUserTemplateDisease) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateDisease).ModifyDisease(aItemCode,aUserTemDisease)
}

/// Creator: yejian
/// CreatDate: 2019-8-1
/// Description：删除指定科室模板项关联的病种
/// Input: aDiseaseId 科室模板病种rowID
/// Return: 1
ClassMethod DeleteDiseaseByID(aItemCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateDisease).DeleteDiseaseByID(aItemCode)
}

}

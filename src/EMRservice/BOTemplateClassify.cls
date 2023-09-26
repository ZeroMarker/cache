Class EMRservice.BOTemplateClassify Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateClassifyService";

ClassMethod GetTemplateClassify(ctloc As %String) As %String [ WebMethod ]
{
	q "["_##Class(EMRservice.BL.BLTemplateClassify).GetTemplateClassify(ctloc)_"]"
}

ClassMethod Add(name As %String, parentID As %String, DocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTemplateClassify).Add(name, parentID, DocID)
}

/// 只能修改名字
ClassMethod Modify(id As %String, name As %String) [ WebMethod ]
{
	d ##Class(EMRservice.BL.BLTemplateClassify).Modify(id, name)
}

ClassMethod Remove(id As %String) [ WebMethod ]
{
	d ##Class(EMRservice.BL.BLTemplateClassify).Remove(id)
}

}

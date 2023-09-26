Class DHCDoc.Interface.Outside.Template.SynMethods Extends (%RegisteredObject, %XML.Adaptor, DHCDoc.Interface.Outside.Template.Public) [ ProcedureBlock ]
{

ClassMethod QueryDepartment() As %String
{
	s $ZTRAP="QueryDepartmentErr"
	;
	s InputObj=##Class(DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRq).%New()
	s InputObj.TradeCode="1012"
	s InputObj.ExtOrgCode="APP"
	s InputObj.ClientType="WEB"
	s InputObj.HospitalId="2"
	s InputObj.ExtUserID="reg"
	DO InputObj.XMLExportToString(.RequestXML,"Request")
	/*
	TODO:调用第三方webservice
	以下为示例，Service.Template视为第三方服务
	*/
	s SOAP=##Class(DHCDoc.Interface.Outside.Template.Service.Template).%New()
	s OutputObj=##Class(DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRp).%New()
	s OutputObj=SOAP.QueryDepartment(RequestXML)
	
	//d OutputObj.XMLNodeDeserialize(.OutputObj,"Request",ReponseXML)
	//DO OutputObj.XMLExportToString(.ReponseXML,"Response")
	if (+OutputObj.ResultCode'=0)||(+OutputObj.RecordCount=0){
		q -1_"^"_OutputObj.ResultContent
	}
	While (OutputObj.Departments.GetNext(.key)) {
		set Department=OutputObj.Departments.GetAt(key)
		/*
		w Department.DepartmentCode_","_Department.DepartmentName,!
		...Do Something
		*/
	}
	
	q 0
QueryDepartmentErr
	q "-100^QueryDepartment调用异常"_$ZERROR
}

ClassMethod QueryDepartmentJson() As %String
{
	s $ZTRAP="QueryDepartmentJsonErr"
	;
	s InputObj=##Class(DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRq).%New()
	s InputObj.TradeCode="1012"
	s InputObj.ExtOrgCode="APP"
	s InputObj.ClientType="WEB"
	s InputObj.HospitalId="2"
	s InputObj.ExtUserID="reg"
	s RequestJSON=..FromObjectJson(InputObj)
	
	/*
	TODO:调用第三方webservice
	以下为示例，Service.Template视为第三方服务
	*/
	s SOAP=##Class(DHCDoc.Interface.Outside.Template.Service.Template).%New()
	
	s Stream=SOAP.QueryDepartmentJson(RequestJSON)
	s sc=##Class(ext.util.JsonObject).JSONStreamToObject(Stream.Read(),.OutputObj,"DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRp")
	
	DO OutputObj.XMLExportToString(.ReponseXML,"Response")
	if (+OutputObj.ResultCode'=0)||(+OutputObj.RecordCount=0){
		q -1_"^"_OutputObj.ResultContent
	}
	While (OutputObj.Departments.GetNext(.key)) {
		set Department=OutputObj.Departments.GetAt(key)
		/*
		w Department.DepartmentCode_","_Department.DepartmentName,!
		...Do Something
		*/
	}
	
	q 0
QueryDepartmentJsonErr
	q "-100^QueryDepartment调用异常"_$ZERROR
}

}

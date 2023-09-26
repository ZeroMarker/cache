Class DHCExternalService.RegInterface.Entity.SelfReg.QueryPatListRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

Property infos As list Of DHCExternalService.RegInterface.Entity.SelfReg.List.QueryPatList(XMLITEMNAME = "QueList", XMLNAME = "QueLists");

/// , XMLPROJECTION = "COLLECTION"

}

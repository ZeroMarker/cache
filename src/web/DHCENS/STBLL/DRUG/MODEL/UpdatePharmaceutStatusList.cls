Class web.DHCENS.STBLL.DRUG.MODEL.UpdatePharmaceutStatusList Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String(TRUNCATE = 1);

Property ResultContent As %String(TRUNCATE = 1);

Property Status As list Of web.DHCENS.STBLL.DRUG.MODEL.UpdatePharmaceutStatus;

}

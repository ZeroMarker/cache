Class web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatusList Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "Request";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property OPSYSTEM As %String(TRUNCATE = 1, XMLNAME = "OPSYSTEM");

Property OPWINID As %String(TRUNCATE = 1, XMLNAME = "OPWINID");

Property OPTYPE As %String(TRUNCATE = 1, XMLNAME = "OPTYPE");

Property OPIP As %String(TRUNCATE = 1, XMLNAME = "OPIP");

Property OPMANNO As %String(TRUNCATE = 1, XMLNAME = "OPMANNO");

Property OPMANNAME As %String(TRUNCATE = 1, XMLNAME = "OPMANNAME");

Property CONSISPRESCMSTVW As list Of web.DHCENS.STBLL.DRUG.MODEL.PharmaceutStatus;

}

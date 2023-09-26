Class web.DHCEntity.Curve.PatientList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 科室ID
Property CTLocId As %String(TRUNCATE = 1);

/// 病人登记号
Property PatNo As %String(TRUNCATE = 1);

/// 床号 
Property BedNo As %String(TRUNCATE = 1);

}

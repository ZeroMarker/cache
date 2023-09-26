Class web.SSHL7Query Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "HL7QU_RowId";

Parameter SQLDESCRIPTION = "HL7QU_RowId";

Parameter SQLROWID = "HL7QU_RowId";

ClassMethod GetQueryStringDesc(code As %String = "") As %String
{
}

ClassMethod websysSave(compref As %String, code As %String = "")
{
}

}

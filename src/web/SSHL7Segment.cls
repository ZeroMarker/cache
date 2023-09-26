Class web.SSHL7Segment Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 79;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "HL7SEG_RowId";

Parameter SQLDESCRIPTION = "HL7SEG_RowId";

Parameter SQLROWID = "HL7SEG_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod getSegments(code As %Library.String = "") As %Library.String
{
}

ClassMethod websysSave(compref As %String, code As %String, strArray As %Library.String = "")
{
}

}

Class web.MRCClinPathwayStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 36;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetDescriptionFromCodeOrId(Code As %Library.String) As %Library.String
{
}

Parameter SQLCODE = "CLPS_Code";

Parameter SQLDESCRIPTION = "CLPS_Desc";

Parameter SQLROWID = "CLPS_RowId";

}

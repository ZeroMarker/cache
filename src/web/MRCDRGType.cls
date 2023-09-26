Class web.MRCDRGType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 22;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DRGTYP_Code";

Parameter SQLDESCRIPTION = "DRGTYP_Desc";

Parameter SQLROWID = "DRGTYP_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

}

Class web.OECUnitsCollected Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "UNITCOL_Code";

Parameter SQLDESCRIPTION = "UNITCOL_Desc";

Parameter SQLROWID = "UNITCOL_RowId";

}

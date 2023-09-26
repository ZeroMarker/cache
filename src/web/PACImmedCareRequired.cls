Include webimport

Class web.PACImmedCareRequired Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 80;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "IMCAR_Code";

Parameter SQLDESCRIPTION = "IMCAR_Desc";

Parameter SQLROWID = "IMCAR_RowId";

}

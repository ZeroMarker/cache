Class web.PACTriageSymptomsProb Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PROB_Code";

Parameter SQLDESCRIPTION = "PROB_Desc";

Parameter SQLROWID = "PROB_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}

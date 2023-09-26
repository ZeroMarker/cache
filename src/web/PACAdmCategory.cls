Include webimport

IncludeGenerator webimport

Class web.PACAdmCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 103;

Parameter SQLDATEFROM = "ADMCAT_DateFrom";

Parameter SQLDATETO = "ADMCAT_DateTo";

Parameter SQLCODE = "ADMCAT_Code";

Parameter SQLDESCRIPTION = "ADMCAT_Desc";

Parameter SQLROWID = "ADMCAT_RowId";

Parameter SQLFILTER = "((ADMCAT_DateFrom <= CURRENT_DATE OR ADMCAT_DateFrom IS NULL) AND (ADMCAT_DateTo >= CURRENT_DATE OR ADMCAT_DateTo IS NULL))";

Property dummy As %String(TRUNCATE = 1);

}

Include webimport

IncludeGenerator webimport

Class web.MRCHabitsQuantity Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 111;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

/// Find a combined habit-quantity code given either quantity's code or description. Uses habit as the parent.
/// 
ClassMethod GetIdFromCodeOrDescription(val As %Library.String, parentid As %Library.String) As %Library.String
{
}

Parameter SQLCODE = "QTY_Code";

Parameter SQLDESCRIPTION = "QTY_Desc";

Parameter SQLROWID = "QTY_RowId";

Query LookUpByHabit(desc As %String, habit As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Habit:%String,HIDDEN:%String")
{
SELECT QTY_Desc, QTY_ParRef->HAB_Desc, QTY_RowID
FROM MRC_HabitsQuantity
WHERE (QTY_Desc %STARTSWITH :desc) AND (QTY_ParRef->HAB_Desc %STARTSWITH :habit)
}

ClassMethod LookUpBrokerByHabit(itmjs As %Library.String = "", itmjsex As %Library.String = "", val1 As %Library.String = "", val2 As %Library.String = "")
{
}

}

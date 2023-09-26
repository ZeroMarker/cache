Class web.ORAnaestAgent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 91;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ANAGN_RowId";

Parameter SQLDESCRIPTION = "ANAGN_RowId";

Parameter SQLROWID = "ANAGN_RowId";

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String = "", id As %String = "")
{
}

ClassMethod CanAnaestAgentBeDeleted(AnaestAgentId As %Library.String) As %Library.Boolean
{
}

Query GetAgentsList(ID) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,ANAParRef,ANAGNAgentDesc,ANAGNMethodDesc")
{
SELECT ANAGN_RowId,ANA_Par_Ref,ANAGN_Agent_DR->ANAGN_Desc,ANAGN_Method_DR->ANMET_Desc
FROM SQLUser.OR_Anaest_Agent
WHERE ANA_Par_Ref->ANA_RowId=:ID
}

}

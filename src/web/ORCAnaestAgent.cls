Class web.ORCAnaestAgent Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Find the object id given either a code or a description.<br>
/// To provide control over the code that is generated the following parameters can be used:<br>
/// SQLROWID - specify the SQL field name to be returned from the function.<br>
/// SQLCODE - specify the SQL field name to be used in the search by code.<br>
/// SQLDESCRIPTION - specify the SQL field name to be used in the search by descripiton.<br>
/// <br>
/// NOTE that these same parameters are are in the generation of default lookups.<br>
ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpBrokerAgent(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "ANAGN_Code";

Parameter SQLDESCRIPTION = "ANAGN_RowId";

Parameter SQLROWID = "ANAGN_RowId";

Query LookUpAgent(desc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ANAGNCode,ANAGNDesc ")
{
SELECT ANAGN_Code, ANAGN_Desc 
FROM SQLUser.ORC_AnaestAgent
WHERE (%ALPHAUP ANAGN_Desc = %ALPHAUP :desc OR %ALPHAUP ANAGN_Desc %STARTSWITH %ALPHAUP :desc) 
OR (%ALPHAUP ANAGN_Code = %ALPHAUP :desc OR %ALPHAUP ANAGN_Code %STARTSWITH %ALPHAUP :desc)
}

}

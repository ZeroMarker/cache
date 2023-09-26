Class web.ORCBladeType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

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

ClassMethod LookUpBrokerBladeType(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "BLDTP_Code";

Parameter SQLDESCRIPTION = "BLDTP_RowId";

Parameter SQLROWID = "BLDTP_RowId";

Query LookUpBladeType(desc) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "BLDTPCode,BLDTPDesc")
{
SELECT BLDTP_Code, BLDTP_Desc 
FROM SQLUser.ORC_BladeType
WHERE (%ALPHAUP BLDTP_Desc = %ALPHAUP :desc OR %ALPHAUP BLDTP_Desc %STARTSWITH %ALPHAUP :desc) 
OR (%ALPHAUP BLDTP_Code = %ALPHAUP :desc OR %ALPHAUP BLDTP_Code %STARTSWITH %ALPHAUP :desc)
}

}

Class web.OECResultStatus Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 106;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerModified(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "RESST_Code";

Parameter SQLDESCRIPTION = "RESST_Desc";

Parameter SQLROWID = "RESST_RowId";

/// According to  Martin for log 23131 the customer has decided to do a search 
/// on all fields except Awaiting.   
/// 
/// // AmiN 4 Dec, 2002 Revisited this issue to clarify System Constraints as defined by Leon.  CPAAdm2 will generate information from the Result Table.  This table  contains results which already exist therefore will never contain the status of Awaiting.   Orders in VB with the status of Awaiting are an order with no results but are expected to come through.  Awaiting status is a Lab status, not a general system order or result status. 
Query LookUpModified(val As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
select RESST_Desc,RESST_RowId,RESST_Code 
from SQLUser.OEC_ResultStatus
WHERE (RESST_Code !='A')
 And ((%ALPHAUP RESST_Desc [%ALPHAUP  :val) 
 OR (%ALPHAUP RESST_Code [%ALPHAUP  :val))
}

}

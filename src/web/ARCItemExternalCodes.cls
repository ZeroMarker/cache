Class web.ARCItemExternalCodes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod ChangeRecLoc(EpisodeID As %Library.String = "")
{
}

Parameter SQLCODE = "EXT_Code";

Parameter SQLDATEFROM = "EXT_DateFrom";

Parameter SQLDATETO = "EXT_DateTo";

Parameter SQLDESCRIPTION = "EXT_RowId";

Parameter SQLROWID = "EXT_RowId";

Query FindOrderExternalCodes(OrderItem As %String, CurrentDate As %Date, ReceivingLoc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Desc:%String")
{
SELECT EXT_Code,EXT_Desc
FROM SQLUser.ARC_ItemExternalCodes
WHERE (EXT_ParRef = :OrderItem) AND (EXT_DateFrom <= :CurrentDate) AND((EXT_DateTo >= :CurrentDate) OR (EXT_DateTo IS NULL)) AND (EXT_CTLOC_DR = :ReceivingLoc)
}

}

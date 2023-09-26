Class web.RBCOutcomeOfAppoint Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 78;

Parameter SQLDATEFROM = "OUTC_DateFrom";

Parameter SQLDATETO = "OUTC_DateTo";

Parameter SQLCODE = "OUTC_Code";

Parameter SQLDESCRIPTION = "OUTC_Desc";

Parameter SQLROWID = "OUTC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// A routine to return the outcome that has the discharge flag set
ClassMethod GetDischargeOutcome() As %Library.String
{
}

ClassMethod GetIdFromAssociatedAction(AssociatedAction As %Library.String = "") As %Library.String
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean [ CodeMode = generator ]
{
}

ClassMethod LookUpBrokerWithDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", date As %String = "") As %Boolean
{
}

Query LookUpWithDate(desc As %String, date As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT OUTC_Desc,OUTC_RowID,OUTC_Code
FROM SQLUser.RBC_OutcomeOfAppoint
WHERE ((%ALPHAUP OUTC_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP OUTC_Code = %ALPHAUP :desc))
AND ((:date IS NULL) OR ((OUTC_DateFrom <= :date OR OUTC_DateFrom IS NULL) AND  (OUTC_DateTo IS NULL OR OUTC_DateTo >= :date)))
ORDER   BY OUTC_Desc
}

}

Class web.ORCOutcomeOfSurgery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 14;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "OUTS_Code";

Parameter SQLDATEFROM = "OUTS_DateFrom";

Parameter SQLDATETO = "OUTS_DateTo";

Parameter SQLDESCRIPTION = "OUTS_Desc";

Parameter SQLROWID = "OUTS_RowId";

ClassMethod LookUpBrokerNC(itmjs As %String = "", itmjsex As %String = "", val As %String = "", anaestflag As %String = "", operflag As %String = "") As %Boolean
{
}

Query LookUpNC(desc As %String, anaestflag As %String, operflag As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description,HIDDEN,Code")
{
SELECT	OUTS_Desc,OUTS_RowID,OUTS_Code
FROM	 SQLUser.ORC_OutcomeOfSurgery
WHERE	(OUTS_Desc %STARTSWITH :desc
OR      OUTS_Code=:desc)
AND (((:anaestflag IS NOT NULL) AND (OUTS_AnaestheticOutcome=:anaestflag)) OR ( :anaestflag IS NULL))
AND (((:operflag IS NOT NULL) AND (OUTS_OperationOutcome=:operflag)) OR ( :operflag IS NULL))
AND ((OUTS_DateFrom <= CURRENT_DATE OR OUTS_DateFrom IS NULL) AND (OUTS_DateTo >= CURRENT_DATE OR OUTS_DateTo IS NULL))
}

}

Class web.PACTriageSymptoms Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 43;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TRISYM_Code";

Parameter SQLDESCRIPTION = "TRISYM_Desc";

Parameter SQLROWID = "TRISYM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// ab 11.04.05 - 46451
Query FindProblems(SympID As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PROBDesc,PROBRowID,PROBCode,CTACURowID,CTACUDesc,CTACUCode")
{
SELECT PROB_Desc, PROB_RowID, PROB_Code,
PROB_Acuity_DR->CTACU_RowId,PROB_Acuity_DR->CTACU_Desc,PROB_Acuity_DR->CTACU_Code
FROM SQLUser.PAC_TriageSymptomsProb
WHERE (PROB_ParRef->TRISYM_RowId = :SympID)
ORDER BY PROB_Desc
}

ClassMethod OLDSaveTriageCat(EpisodeID As %String = "", CatID As %String = "")
{
}

ClassMethod SaveTriageCat(EpisodeID As %String = "", CatDesc As %String = "", SymProID As %String = "")
{
}

Query FindProblemsExtenzive(SympProID As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "PROBDesc,PROBRowID,PROBCode,CTACURowID,CTACUDesc,CTACUCode")
{
SELECT DISTINCT BY (PROB_RowID) 
 PROB_Desc, PROB_RowID, PROB_Code,
PROB_Acuity_DR->CTACU_RowId,PROB_Acuity_DR->CTACU_Desc,PROB_Acuity_DR->CTACU_Code
FROM SQLUser.PAC_TriageSymptomsProb
WHERE ({fn CONCAT( '@', {fn CONCAT((:SympProID),'@')})} [ {fn CONCAT( '@', {fn CONCAT((PROB_RowID),'@')})})
ORDER BY PROB_Desc
}

ClassMethod ResetSt(compref As %Library.String, TargetID As %String = "", IDString As %String = "")
{
}

}

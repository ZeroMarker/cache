Class web.PACWardBedAllocation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 283;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "WBALL_DateTo";

Parameter SQLCODE = "WBALL_RowId";

Parameter SQLDESCRIPTION = "WBALL_RowId";

Parameter SQLROWID = "WBALL_RowId";

Property dummy As %String(TRUNCATE = 1);

/// ab 25.03.04 - 42799 - builds an array of which beds are allocated to departments for a ward
/// (for when the system param 'assign depts to beds' is OFF)
ClassMethod GetDeptBedAry(ward As %String = "", status As %String = "", unavail As %String = "", ByRef DeptARY As %String)
{
}

/// ab 18.11.03 39247 - finds the bed statistics for a ward department based on allocation
ClassMethod GetDeptBedTotals(ward As %String = "", dep As %String = "") As %String
{
}

/// ab 4.06.03
/// returns if 'depts' string has a deptartment which ISNT in wards dept allocation
ClassMethod HasOutlierLoc(ward As %String = "", depts As %String = "") As %Library.String
{
}

/// KM 31-Jul-2002: Created for calling from epr.floorplan.csp (and its associated methods) and for any other place where
/// a check is required to find out if a patient is a boarder.
ClassMethod IsBoarder(EpisodeID As %Library.String = "", depsAllcToWard As %Library.String = "", PARAMS As %Library.String = "") As %Library.String
{
}

/// ab 14.03.03 32433 - check whether to show boarder icon
ClassMethod IsBoarderIcon(WardID As %Library.String = "", EpisodeID As %Library.String = "", PARAMS As %Library.String = "") As %Library.String
{
}

Query FindDeptByWard(WardID As %String, HistoryFlag As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Dept:%String,Beds:%String,DateFrom:%String,DateTo:%String")
{
SELECT  WBALL_CTLOC_DR->CTLOC_Desc, WBALL_Beds, WBALL_Date, WBALL_DateTo
FROM SQLUser.PAC_WardBedAllocation
WHERE WBALL_ParRef=:WardID
 AND ((:HistoryFlag='Y') OR ((WBALL_Date < CURRENT_DATE) AND (WBALL_DateTo > CURRENT_DATE OR WBALL_DateTo IS NULL)))
}

Query LookUpDept(locDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Desc:%String,Code:%String")
{
SELECT DISTINCT BY (WBALL_CTLOC_DR) WBALL_CTLOC_DR->CTLOC_Desc,WBALL_CTLOC_DR->CTLOC_Code
FROM SQLUser.PAC_WardBedAllocation
WHERE (WBALL_CTLOC_DR->CTLOC_Desc %STARTSWITH :locDesc OR :locDesc IS NULL)
ORDER BY WBALL_CTLOC_DR->CTLOC_Desc
}

}

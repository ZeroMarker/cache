Include webimport

IncludeGenerator webimport

/// Log 28554 - AI - 27-02-2003 : Created class to perform basic lookups.
Class web.PACAllergySeverity Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM = "ALRGSEV_DateFrom";

Parameter SQLDATETO = "ALRGSEV_DateTo";

Parameter SQLCODE = "ALRGSEV_Code";

Parameter SQLDESCRIPTION = "ALRGSEV_Desc";

Parameter SQLROWID = "ALRGSEV_RowId";

Parameter SQLFILTER = "((ALRGSEV_DateFrom <= CURRENT_DATE OR ALRGSEV_DateFrom IS NULL) AND (ALRGSEV_DateTo >= CURRENT_DATE OR ALRGSEV_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpAllergySeverity(desc As %String = "", date As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,LongDescription:%String")
{
 SELECT ALRGSEV_Desc, ALRGSEV_Code, ALRGSEV_LongDescription
 FROM SQLUser.PAC_AllergySeverity
 WHERE (%ALPHAUP ALRGSEV_Desc %STARTSWITH %ALPHAUP :desc)
  AND ((ALRGSEV_DateFrom <= CURRENT_DATE OR ALRGSEV_DateFrom IS NULL) AND (ALRGSEV_DateTo >= CURRENT_DATE OR ALRGSEV_DateTo IS NULL))
}

}

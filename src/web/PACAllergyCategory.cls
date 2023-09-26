Include webimport

IncludeGenerator webimport

/// Log 28554 - AI - 27-02-2003 : Created class to perform basic lookups.
Class web.PACAllergyCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

Parameter SQLDATEFROM = "ALRGCAT_DateFrom";

Parameter SQLDATETO = "ALRGCAT_DateTo";

Parameter SQLCODE = "ALRGCAT_Code";

Parameter SQLDESCRIPTION = "ALRGCAT_Desc";

Parameter SQLFILTER = "((ALRGCAT_DateFrom <= CURRENT_DATE OR ALRGCAT_DateFrom IS NULL) AND (ALRGCAT_DateTo >= CURRENT_DATE OR ALRGCAT_DateTo IS NULL))";

Parameter SQLROWID = "ALRGCAT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

}

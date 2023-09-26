Class web.PACAlertCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 50;

Parameter SQLDATEFROM = "ALERTCAT_DateFrom";

Parameter SQLDATETO = "ALERTCAT_DateTo";

Parameter SQLCODE = "ALERTCAT_Code";

Parameter SQLDESCRIPTION = "ALERTCAT_Desc";

Parameter SQLROWID = "ALERTCAT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// md 09/01/2003
/// Use this  method cause I have problems with generated
/// GetIDFromCodeOrDesciption method
ClassMethod GetIdfromDesc(val As %Library.String) As %Library.String
{
}

/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query Find(desc As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Categ")
{
 SELECT ALERTCAT_RowId
 FROM SQLUser.PAC_AlertCategory
 WHERE (((ALERTCAT_Desc %STARTSWITH :desc) OR (ALERTCAT_Code = :desc))
 AND ((ALERTCAT_DateFrom <= :date OR ALERTCAT_DateFrom IS NULL) AND (ALERTCAT_DateTo >= :date OR ALERTCAT_DateTo IS NULL)))
}

/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query FindA(desc As %Library.String, rid As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Categ")
{
 SELECT ALERTCAT_RowId
 FROM SQLUser.PAC_AlertCategory
 WHERE ((ALERTCAT_RowID= :rid)
 AND  ((ALERTCAT_Desc %STARTSWITH :desc) OR (ALERTCAT_Code = :desc))
 AND ((ALERTCAT_DateFrom <= :date OR ALERTCAT_DateFrom IS NULL) AND (ALERTCAT_DateTo >= :date OR ALERTCAT_DateTo IS NULL)))
}

}

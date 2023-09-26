Class web.SSGroupAlertCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 77;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ALC_RowId";

Parameter SQLDESCRIPTION = "ALC_RowId";

Parameter SQLROWID = "ALC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query Find(GroupID As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Categ")
{
 SELECT  ALC_Rowid, ALC_AlertCateg_DR
 FROM SQLUser.SS_GroupAlertCategory
 WHERE ((ALC_ParRef = :GroupID)AND (ALC_ReadOnly IS NULL)
 AND ((ALC_AlertCateg_DR->ALERTCAT_DateFrom <= :date OR ALC_AlertCateg_DR->ALERTCAT_DateFrom IS NULL) 
 AND (ALC_AlertCateg_DR->ALERTCAT_DateTo >= :date OR ALC_AlertCateg_DR->ALERTCAT_DateTo IS NULL)))
}

/// Log 42270 - AI - 12-02-2004 : Modified query to incorporate DateFrom and DateTo fields stored on MedTrak VB Codetable.
Query FindD(GroupID As %Library.String, val As %Library.String, date As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Categ,CategDesc")
{
 SELECT  ALC_Rowid, ALC_AlertCateg_DR, ALC_AlertCateg_DR->ALERTCAT_Desc
 FROM SQLUser.SS_GroupAlertCategory
 WHERE (ALC_ParRef = :GroupID)AND (ALC_ReadOnly IS NULL)
 AND (((ALC_AlertCateg_DR->ALERTCAT_Desc %STARTSWITH :val) OR (ALC_AlertCateg_DR->ALERTCAT_Code = :val))
 AND ((ALC_AlertCateg_DR->ALERTCAT_DateFrom <= :date OR ALC_AlertCateg_DR->ALERTCAT_DateFrom IS NULL)
 AND (ALC_AlertCateg_DR->ALERTCAT_DateTo >= :date OR ALC_AlertCateg_DR->ALERTCAT_DateTo IS NULL)))
}

/// Log 42797 - AI - 16-03-2004 : New query to find independently of Date restrictions. Called from web.PACPatientAlert.RestrictByCat.
Query FindEditable(GroupID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Categ")
{
 SELECT  ALC_Rowid, ALC_AlertCateg_DR
 FROM SQLUser.SS_GroupAlertCategory
 WHERE ((ALC_ParRef = :GroupID)AND (ALC_ReadOnly IS NULL))
}

}

Include webimport

IncludeGenerator webimport

Class web.PACAdmSource Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 113;

Parameter SQLCODE = "ADSOU_Code";

Parameter SQLDATEFROM = "ADSOU_DateFrom";

Parameter SQLDESCRIPTION = "ADSOU_Desc";

Parameter SQLDATETO = "ADSOU_DateTo";

Parameter SQLROWID = "ADSOU_RowId";

Parameter SQLFILTER = "((ADSOU_DateFrom <= CURRENT_DATE OR ADSOU_DateFrom IS NULL) AND (ADSOU_DateTo >= CURRENT_DATE OR ADSOU_DateTo IS NULL))";

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpEpisodeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "", cdate As %String = {+$h}) As %Library.Boolean
{
}

ClassMethod GetActiveIdByCodeOrDesc(val As %String = "", cdate As %String = {+$h}) As %Library.String
{
}

ClassMethod LookUpEpisodeBrokerOP(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "", cdate As %String = {+$h}, OrganProcurement As %Library.String = "") As %Library.Boolean
{
}

Query LookUpWithEpisodeType(desc As %String, admType As %String, cdate As %String = {+$h}) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "desc:%String,code:%String,HIDDEN:%String")
{
SELECT ADSOU_Desc,ADSOU_Code,ADSOU_EpisodeType
FROM SQLUser.PAC_AdmSource
WHERE    (((ADSOU_Desc %STARTSWITH :desc) OR (ADSOU_Code %STARTSWITH :desc) OR (:desc IS NULL))
AND    (ADSOU_DateFrom <= :cdate OR ADSOU_DateFrom IS NULL) 
AND    (ADSOU_DateTo >= :cdate OR ADSOU_DateTo IS NULL)
AND    ((ADSOU_EpisodeType =:admType OR ADSOU_EpisodeType IS NULL) OR (:admType IS NULL)))
ORDER BY ADSOU_Desc
}

ClassMethod LookUpEpisodeBrokerNC(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", admType As %Library.String = "", cdate As %String = {+$h}) As %Library.Boolean
{
}

Query LookUpWithEpisodeTypeNC(desc As %String, admType As %String, cdate As %String = {+$h}) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "desc:%String,code:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT ADSOU_Desc,ADSOU_Code,ADSOU_EpisodeType,ADSOU_NationalCode
FROM SQLUser.PAC_AdmSource
WHERE    (((ADSOU_Desc %STARTSWITH :desc) OR (ADSOU_Code %STARTSWITH :desc) OR (:desc IS NULL))
AND    (ADSOU_DateFrom <= :cdate OR ADSOU_DateFrom IS NULL) 
AND    (ADSOU_DateTo >= :cdate OR ADSOU_DateTo IS NULL)
AND    ((ADSOU_EpisodeType =:admType OR ADSOU_EpisodeType IS NULL) OR (:admType IS NULL)))
ORDER BY ADSOU_Desc
}

}

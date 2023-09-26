Include webimport

IncludeGenerator webimport

Class web.PACEpisodeSubType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 135;

Parameter SQLCODE = "SUBT_Code";

Parameter SQLDATEFROM = "SUBT_DateFrom";

Parameter SQLDATETO = "SUBT_DateTo";

Parameter SQLDESCRIPTION = "SUBT_Desc";

Parameter SQLROWID = "SUBT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetCodeFromEpisodeId(episodeId As %String) As %String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByType(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", PAADMType As %String = "", date As %String = "") As %Library.Boolean
{
}

Query LookUpByType(desc As %String, PAADMType As %String, date As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT SUBT_Desc,SUBT_RowId,SUBT_Code
FROM SQLUser.PAC_EpisodeSubType
WHERE ((%ALPHAUP SUBT_Desc %STARTSWITH %ALPHAUP :desc) OR (%ALPHAUP SUBT_Code = %ALPHAUP :desc) OR (:desc IS NULL))
AND ((SUBT_AdmType=:PAADMType) OR (:PAADMType IS NULL))
AND	((SUBT_DateFrom IS NULL) OR (SUBT_DateFrom<= :date))
AND	((SUBT_DateTo IS NULL) OR (SUBT_DateTo>= :date))
ORDER BY SUBT_Desc
}

ClassMethod LookUpByTypeBClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByTypeBFetch ]
{
}

ClassMethod LookUpByTypeBExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, PAADMType As %Library.String, vdate As %Date = "", Location As %Library.String = "", HidCodes As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByTypeBFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByTypeBExecute ]
{
}

Query LookUpByTypeB(desc As %String, PAADMType As %String, date As %Date = "", Location As %Library.String = "", HidCodes As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "SEDesc:%String,HIDDEN:%String,SECode:%String")
{
}

ClassMethod LookUpBrokerByTypeB(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", PAADMType As %String = "", date As %String = "", Location As %Library.String = "", HidCodes As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetSepAdmType(PAADMType As %String = "") As %Library.String
{
}

}

Include webimport

IncludeGenerator webimport

Class web.MRCICDDx Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 856;

Parameter SQLCODE = "MRCID_Code";

Parameter SQLDATEFROM = "MRCID_DateActiveFrom";

Parameter SQLDATETO = "MRCID_DateActiveTo";

Parameter SQLDESCRIPTION = "MRCID_Desc";

Parameter SQLROWID = "MRCID_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetAlias(icd As %Library.String) As %Library.String
{
}

ClassMethod Get2ndCodeInPairs(codeinpair As %Library.String) As %Library.String
{
}

/// KM 27-Sept-2001: Called from RBAppointment.websysSaveApptStatus
/// Once the LookUpBroker method works for this class then should only need method GetCodeFromDescription
/// cjb 30/04/2004 39707 - using indexes is much faster than sql
ClassMethod GetCodeFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

/// KM 27-Sept-2001: Called from RBAppointment.websysSaveApptStatus
/// Once the LookUpBroker method works for this class then should only need method GetCodeFromDescription
ClassMethod GetCodeFromCodeOrDescriptionOLD(val As %Library.String) As %Library.String
{
}

ClassMethod GetIdFromCodeOrDescription(code As %Library.String) As %Library.String
{
}

ClassMethod GetIdFromAlphaCodeOrDescription(code As %Library.String) As %Library.String
{
}

ClassMethod GetIdFromAliasDescription(val As %Library.String, locID As %Library.String, ver As %Library.String = "") As %Library.String
{
}

/// Author - JH
/// This method was put in to get exact matches for codes like A01.1 so they ingored to A011 due to the 
/// $$ALPHAUP in the index global 
ClassMethod GetIdFromCode(code As %Library.String)
{
}

/// KK 3/May/04 L:43697
ClassMethod GetIdFromCodeandDate(code As %String = "", dischdate As %String = "") As %String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// Log 50771 - AI - 18-05-2006 : Created a new version of the LookUpBrokerWithAlias,
///     : that will use the LookUpWithAlias Query/Execute/Fetch/Close to get its data.
ClassMethod LookUpBrokerWithAlias(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %String = "", val2 As %String = "", val3 As %String = "", DiagSaveLvl As %String = "") As %Library.Boolean
{
}

/// cjb 27/07/2004 44078 - re-written the broker so it uses %Library.ResultSet
ClassMethod LookUpBrokerCancer(itmjs As %Library.String = "", itmjsex As %Library.String = "", TSRTITM As %Library.String = "", TSRTORD As %Library.String = "", Code As %Library.String = "", Desc As %Library.String = "", Date As %Library.String = "", Cancer As %Library.String = "", Meta As %Library.String = "", Morp As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCancerClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCancerFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCancerExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, Code As %Library.String, Desc As %Library.String, Date As %String, Cancer As %Library.String = "", Meta As %Library.String = "", Morph As %Library.String = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCancerFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCancerExecute ]
{
}

ClassMethod LookUpWithAliasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithAliasFetch ]
{
}

ClassMethod LookUpWithAliasExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, loc As %Library.String = "", ver1 As %Library.String = "1", DiagSaveLvl As %String = "") As %Library.Status
{
}

ClassMethod LookUpWithAliasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithAliasExecute ]
{
}

ClassMethod LookUpWithBodyAreaClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithBodyAreaFetch ]
{
}

ClassMethod LookUpWithBodyAreaExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, loc As %Library.String) As %Library.Status
{
}

ClassMethod LookUpWithBodyAreaFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithBodyAreaExecute ]
{
}

/// cjb 12/10/2005 55794 - returns all the valid editions for the date in the ValidICDEdition array
ClassMethod GetEdition(date As %Library.Date) As %Library.String
{
}

ClassMethod LookUpWithEditionClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpWithEditionFetch ]
{
}

/// rqg 27545 :Added to include search for ICD Edition
/// cjb 16/08/2005 54889 - reducing the number of global hits
ClassMethod LookUpWithEditionExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, loc As %Library.String, dischdate As %Library.Date, ver As %Library.String = "1") As %Library.Status
{
}

/// cjb 16/08/2005 54889 - recucing the number of global hits
ClassMethod LookUpWithEditionFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpWithEditionExecute ]
{
}

ClassMethod LookUpFreeAliasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpFreeAliasFetch ]
{
}

ClassMethod LookUpFreeAliasExecute(ByRef QHandle As %Library.Binary, code As %Library.String, desc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpFreeAliasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpFreeAliasExecute ]
{
}

ClassMethod findInjuryPoisoning(id As %Library.String) As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// cjb 16/08/2005 54889 - recucing the number of global hits
/// cjb 13/10/2005 55794 - rewritten to use the LookUpWithEdition query, so it can validate against more than one edition
ClassMethod LookUpBrokerWithEdition(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val2 As %Library.String = "", val3 As %Library.String = "") As %Library.Boolean
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCIDCode:%String,MRCIDDesc:%String")
{
SELECT MRCID_RowId, MRCID_Code, MRCID_Desc
FROM MRC_ICDDx
WHERE MRCID_RowId = :ID
ORDER BY MRCID_Code
}

Query Find(Code As %String, Desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,MRCIDCode:%String,MRCIDDesc:%String")
{
SELECT MRCID_RowId, MRCID_Code, MRCID_Desc
FROM MRC_ICDDx
WHERE (MRCID_Code %STARTSWITH :Code) AND (MRCID_Desc %STARTSWITH :Desc)
ORDER BY MRCID_Code
}

Query LookUpByCancer(TSRTITM As %Library.String, TSRTORD As %Library.String, Code As %String, Desc As %String, Date As %String, Cancer As %String, Meta As %String, Morph As %String) As %Query(CONTAINID = 0, ROWSPEC = "MRCIDCode:%String,MRCIDDesc:%String,cancerflag:%String,HIDDEN:%String")
{
}

/// KK 29/Mar/2004 L:43034 LookUp query is for the field MRCIDCodeF and MRCIDCodeT in webcommon.DateFromTo.Custom component.
///               Need to check %UPPER to split difference between A01.1 and A011.
Query LookUpOnCode(val As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "desc:%String,HIDDEN:%String,code:%String")
{
SELECT MRCID_Desc,MRCID_RowId, MRCID_Code
FROM SQLUser.MRC_ICDDx
WHERE (%UPPER MRCID_Code %STARTSWITH %UPPER :val)
ORDER BY MRCID_Code
}

/// Log 55623 - AI - 10-10-2005 : Lookup Broker for the fields MRCIDCodeF and MRCIDCodeT in webcommon.DateFromTo.Custom component.
///                               Need to check %UPPER to split difference between A01.1 and A011.
ClassMethod LookUpBrokerOnCode(itmjs As %String = "", itmjsex As %String = "", val As %String = "") As %Boolean
{
}

Query LookUpWithAlias(desc As %String, loc As %String, ver1 As %String, DiagSaveLvl As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,HIDDEN:%String,code:%String,HIDDEN:%String")
{
}

Query LookUpWithBodyArea(desc, loc) As %Library.Query(CONTAINID = 0, ROWSPEC = "ICDCode:%String,BodyArea:%String,SysProbStatus:%String")
{
SELECT MRCID_Desc, MRCID_BodyArea_DR->BODAR_Desc, MRCID_BodySysProbStat_DR->STAT_Desc
FROM MRC_ICDDx
WHERE MRCID_Desc %STARTSWITH :desc
ORDER BY MRCID_Desc
}

/// rqg,Log27545: This lookup was made to display the ICDCodes relative to the ICD
/// Edition. ICDEdition code is first retrieved against the discharge date. Then ICD Codes
/// which have edition defined against them and are active as at the discharge date are
/// returned from the lookup. If a situation exists where there is no ICD Edition retrieved,
/// then date from and dateto of ICD Codes will be checked against the discharge date.
/// 
Query LookUpWithEdition(desc As %String, loc As %String, dischdate As %Date, ver As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,HIDDEN:%String,code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// md 29/06/2005 Log 53228
Query LookUpFreeAlias(code As %String, desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Alias Text:%String")
{
}

Query LookUpByConsult(ConsultID As %String, val As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpByConsultClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByConsultFetch ]
{
}

/// ab 13.09.06 60406 -restrict to only those ICD's against consult - using DIAGCons index
ClassMethod LookUpByConsultExecute(ByRef QHandle As %Library.Binary, ConsultID As %Library.String, val As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByConsultFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByConsultExecute ]
{
}

ClassMethod LookUpByConsultBroker(itmjs As %String = "", itmjsex As %String = "", ConsultID As %String = "", val As %String = "") As %Boolean
{
}

}

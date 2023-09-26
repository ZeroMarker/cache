Class web.RTMaster Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 667;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "RTMAS_MRNo";

Parameter SQLDESCRIPTION = "RTMAS_MRNo";

Parameter SQLROWID = "RTMAS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// cjb 31/07/2003 33208
ClassMethod DisableNew(UserID As %Library.String) As %Library.String
{
}

ClassMethod DisableNewBySecGrp(UserGroup As %Library.String) As %Library.String
{
	quit $$$OK
}

ClassMethod Delete(ID As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMRNumberClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMRNumberFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMRNumberExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMRNumberFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMRNumberExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMRTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindMRTypeFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMRTypeExecute(ByRef QHandle As %Library.Binary, PatientID As %String = "") As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindMRTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindMRTypeExecute ]
{
}

ClassMethod GetDefaultMR() As %Library.String
{
}

/// cjb 25/08/2003 38372
/// method called from various places in rtmaster
ClassMethod GetLinkedTypes(mrtid As %Library.String)
{
}

ClassMethod GetMRNNumber(PatientID As %Library.String = "") As %Library.String
{
	quit ""
}

ClassMethod GetMRNNumberAll(PatientID As %Library.String = "") As %Library.String
{
}

/// cjb 21/04/2004 40817 called from PAPerson.Banner - BANNERMedicalRecord
/// returns the MR Types linked to the logon hospital (in the sys param CT)
/// aji 03/03/04 - Added extra param, since we use it in routines. 
ClassMethod GetMRNNumberForHospital(PatientID As %Library.String = "", LogonLoc As %Library.String = "") As %Library.String
{
}

/// by wuqk 2011-06-20 
/// User.RTMaster中没有数据
ClassMethod GetMRType(PatientID As %Library.String) As %Library.String
{
	quit ""
}

/// by wuqk 2011-06-17 
/// User.RTMaster中没有数据
ClassMethod GetMRTypeFromLocation(loc As %Library.String) As %Library.String
{
	quit ""
}

ClassMethod GetUserGroup(userid As %Library.String) As %Library.String
{
}

ClassMethod LookUpMRNClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpMRNFetch ]
{
}

/// cjb 19/01/2006 55848 - rewritten as execute/fetch
ClassMethod LookUpMRNExecute(ByRef QHandle As %Library.Binary, MRN As %Library.String) As %Library.Status
{
}

ClassMethod LookUpMRNFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpMRNExecute ]
{
}

ClassMethod LookUpMRNBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String) [ CodeMode = generator ]
{
}

ClassMethod DelReqByReqVolID(reqvolid As %Library.String)
{
}

/// save the status
ClassMethod websysSaveActive(compref As %String, id As %String)
{
}

ClassMethod websysSaveType(compref As %String, id As %String)
{
}

ClassMethod ValidateUserandPin(compref As %String) As %Boolean
{
}

Query FindMRNumber(TSRTITM As %Library.String, TSRTORD As %Library.String, PatientID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "mrnumber,rowid,Active,Type")
{
}

Query FindMRType(PatientID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,TYPDesc:%String,RTMASMRNo:%String,RTMAVDateCreated:%String,RTMAVTimeCreated:%String,RTMAVCreatedByUser:%String,active:%String,hosplist:%String,SysParamHosplist:%String,CreateLoc:%String")
{
}

Query GetPatIDByTypeandNum(Type As %Library.String, Number As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,PatientID")
{
 SELECT RTMAS_ROWID,RTMAS_PatNo_DR
 FROM SQLUser.RT_Master
 WHERE RTMAS_MRNo=:Number
 AND RTMAS_MRType_DR->TYP_Desc=:Type
}

Query GetTypeByPatientID(PatientID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,RTMAS_MRType_DR,TYP_Desc")
{
 SELECT RTMAS_ROWID,RTMAS_MRType_DR,RTMAS_MRType_DR->TYP_Desc
 FROM SQLUser.RT_Master
 WHERE RTMAS_PatNo_DR=:PatientID
}

Query LookUpMRN(MRN As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "mrn,rego,HIDDEN,Surname,Forename,HIDDEN")
{
}

/// cjb 19/04/2005 51549 - replaced = with %STARTSWITH.  Also added order by RTMAS_MRNo
Query LookUpMRNOLD(MRN As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "mrn,rego,HIDDEN,Surname,Forename,HIDDEN")
{
SELECT RTMAS_MRNo, RTMAS_PatNo_DR->PAPMI_No, RTMAS_PatNo_DR, RTMAS_PatNo_DR->PAPMI_Name, RTMAS_PatNo_DR->PAPMI_Name2, RTMAS_PatNo_DR->PAPMI_VIPFlag
FROM SQLUser.RT_Master
where (RTMAS_MRNo %STARTSWITH :MRN)
order by RTMAS_MRNo
}

}

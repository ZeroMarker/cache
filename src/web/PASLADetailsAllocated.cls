Class web.PASLADetailsAllocated Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 883;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod BatchTransfer(OldSAID As %Library.String, NewSAID As %Library.String, IP As %Library.String, OP As %Library.String, WL As %Library.String, WA As %Library.String, DC As %Library.String, Current As %Library.String)
{
}

ClassMethod BatchTransferCounter(OldSAID As %Library.String, NewSAID As %Library.String, IP As %Library.String, OP As %Library.String, WL As %Library.String, WA As %Library.String, DC As %Library.String, Current As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAID1Close(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSAID1Fetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAID1Execute(ByRef QHandle As %Library.Binary, Said As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAID1Fetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSAID1Execute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAIDClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSAIDFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAIDExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, Said As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, PatientNo As %Library.String, CommissionerCode As %Library.String, TrustCode As %Library.String, EpisodeType As %Library.String, ServiceGroup As %Library.String, Specialty As %Library.String, AdminCat As %Library.String, HRG As %Library.String, HARString As %Library.String, HARExclude As %Library.String, HiddenFindParam As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAIDFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSAIDExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSAIDInitParams(HiddenFindParam As %Library.String) As %Status
{
}

ClassMethod GetCurrentGP(GP As %Library.String)
{
}

ClassMethod GetDetails(SaidID As %Library.String)
{
}

ClassMethod LookUpBrokerRegion(itmjs As %Library.String = "", itmjsex As %Library.String = "", Region As %String)
{
}

ClassMethod ReAllocationOK(SaidID As %Library.String)
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSave(compref As %String, id As %String)
{
}

Parameter SQLCODE = "SLAD_RowId";

Parameter SQLDESCRIPTION = "SLAD_RowId";

Parameter SQLROWID = "SLAD_RowId";

Query FindSAID(TSRTITM As %Library.String, TSRTORD As %Library.String, Said As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, PatientNo As %Library.String, CommissionerCode As %Library.String, TrustCode As %Library.String, EpisodeType As %Library.String, ServiceGroup As %Library.String, Specialty As %Library.String, AdminCat As %Library.String, HRG As %Library.String, HARString As %Library.String, HARExclude As %Library.String, HiddenFindParam) As %Library.Query(CONTAINID = 0, ROWSPEC = "said,episodedate,allocateddate,allocatedtime,surname,forename,comment,rowid,patientno,manalloc,commissionercode,commissionerdesc,paperpapmidr,trustcode,trustdesc,episodetype,servicegroup,specialty,admincat,proc,hrg,har,allocated,paperdr,gp,valid,cons,harrowid,IntMan,reallocate,serial,episodeid,id")
{
}

Query FindSAID1(Said As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "episodedate")
{
}

Query LookUpRegion(Region As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HcrCode:%String,HcrDesc:%String")
{
SELECT HCR_Code, HCR_Desc
INTO :HcrCode, :HcrDesc
FROM SQLUser.CT_HealthCareRegion
WHERE (HCR_Desc %STARTSWITH :Region) AND (HCR_Desc IS NOT NULL)
}

}

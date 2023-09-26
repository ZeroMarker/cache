/// SMR Batch header
Class web.PASMRExtractBuild Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 508;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SMREB_RowId";

Parameter SQLDESCRIPTION = "SMREB_RowId";

Parameter SQLROWID = "SMREB_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod BatchCount(ExtractBuild As %Library.String)
{
}

ClassMethod ExtractCount(ExtractBuild As %Library.String) As %Library.Integer
{
}

/// -------------------------------------------------
/// Default implementation of LookUp Query.
ClassMethod FindSMRClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindSMRFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSMRExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, RunDate As %Library.Date, UserName As %Library.String, RecordType As %Library.String, HiddenFindParam As %Library.String, SelHospital As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindSMRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindSMRExecute ]
{
}

ClassMethod SendToISD(Send As %Library.String, RecordType As %Library.String, Status As %Library.String)
{
}

/// aji 5/09/03 - log 34918
ClassMethod CheckDefaultHospital() As %Library.String
{
}

/// aji - log 34930
ClassMethod SendExtract(Send As %Library.String, Status As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, HospitalID As %Library.String)
{
}

/// aji - log 34930
ClassMethod AcceptExtract(Send As %Library.String, Status As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date)
{
}

/// aji - log 34930
ClassMethod RejectExtract(Send As %Library.String, Status As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date)
{
}

/// aji - log 34930
ClassMethod ReverseAcceptedExtract(Send As %Library.String, Status As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date)
{
}

ClassMethod websysDelete(id As %Library.String)
{
}

ClassMethod xxFind(StartDate As %Library.String, EndDate As %Library.String, RunDate As %Library.String, User As %Library.String, SMR00 As %Library.String, SMR01 As %Library.String)
{
}

Query FindSMR(TSRTITM As %Library.String, TSRTORD As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, RunDate As %Library.Date, UserName As %Library.String, RecordType As %Library.String, HiddenFindParam As %Library.String, SelHospital As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "id,startdate,enddate,rundate,runtime,userid,recordtype,lastsent,sentby,batchnumber,accrejuser,accrejdate,accrejtime,accrejhosp,hospital,lastUserHosp,status,batchcount,extractcount")
{
}

}

Class web.MRPictures Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 256;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "PIC_RowId";

Parameter SQLDESCRIPTION = "PIC_Desc";

Parameter SQLROWID = "PIC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// cjb 16/03/2006 58601 - this method is called from csps accessing tkImageScan.dll
/// THIS IS NOT USED!  GET THE REAL CODE FROM SCANNING.CSP!!!!!!!
/// !!!!!!!!!!!!!!!!!!!!!
/// 
ClassMethod tkImageScan() As %Library.String
{
}

/// KM 6-Aug-2001: Called From Component MRPictures.ListEPR
ClassMethod GetDataFromIdAndType(id As %Library.String) As %Library.String
{
}

ClassMethod FindPicRowIdsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindPicRowIdsExecute ]
{
}

/// Log 59371 - AI - 15-06-2006 : Change from straight SQL Query to Execute/Fetch/Close.
///                             : Copy the Across Episodes logic from MRNursingNotes - ListEPR.
ClassMethod FindPicRowIdsExecute(ByRef QHandle As %Binary, mradm As %Library.String = "") As %Status
{
}

ClassMethod FindPicRowIdsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPicRowIdsExecute ]
{
}

/// Log 59371 - AI - 15-06-2006 : Change from straight SQL Query to Execute/Fetch/Close.
/// Query FindPicRowIds(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MRPicRowId,MRCPicDR,PicDesc,FileName,Date,Time,SSUSRName")
/// {
/// select PIC_RowId,PIC_MRCPict_DR,PIC_MRCPict_DR->PIC_Desc,PIC_MRCPict_DR->PIC_FileName,PIC_DateCreated,PIC_TimeCreated,PIC_UserCreated->SSUSR_Name
/// from SQLUser.MR_Pictures
/// where (PIC_ParRef=:mradm)
/// AND (PIC_MRCPict_DR IS NOT NULL)
/// }
Query FindPicRowIds(mradm As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "MRPicRowId,MRCPicDR,PicDesc,FileName,Date,Time,SSUSRName")
{
}

ClassMethod ListEPRClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ListEPRFetch ]
{
}

ClassMethod ListEPRExecute(ByRef QHandle As %Library.Binary, RequestID As %Library.String = "", ComponentID As %Library.String = "") As %Library.Status
{
}

ClassMethod ListEPRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ListEPRExecute ]
{
}

/// Default save method used for updating the database for Components of type Edit.
/// The compref is the  component reference which is the string from which we can deduce the instance of websysComponent
/// websysComponentItem
/// id is the id for the instance of class we wish to update.
ClassMethod websysSaveNew(compref As %String, id As %String)
{
}

/// Log 32090 - AI - 17-04-2003 : Called from Component MRPictures.ListEPR.
Query ListEPR(mradm As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PIC_RowId,PIC_Desc,PIC_DateCreated,PIC_LeftCoord,PIC_Path,PIC_TimeCreated,PIC_TopCoord,PIC_Type,PIC_Visible,SSUSR_Name,PIC_MRCPict_DR,PIC_FileName,UpdateDate:%Date,UpdateTime:%Time,UpdateUserName:%String,UpdateHospitalDesc:%String,PICInactive:%String,PICDocType:%String")
{
}

}

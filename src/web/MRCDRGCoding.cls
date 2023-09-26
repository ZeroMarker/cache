Class web.MRCDRGCoding Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 449;

Parameter SQLCODE = "DRGCOD_RowId";

Parameter SQLDATEFROM = "DRGCOD_DateFrom";

Parameter SQLDESCRIPTION = "DRGCOD_RowId";

Parameter SQLDATETO = "DRGCOD_DateTo";

Parameter SQLROWID = "DRGCOD_RowId";

/// KK 17/Apr/2003 Log 32794 - AutoCoding
ClassMethod AutoCodeEpisodes(compref As %Library.String = "")
{
}

ClassMethod CheckforAgeandSex(ICDs As %String = "", ProcIDs As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
}

/// LOG 54058 MD 27/07/2005 
ClassMethod CheckAutoCodingValidations(ICDs As %String = "", ProcIDs As %String = "", PatientID As %String = "", EpisodeID As %String = "") As %String
{
}

ClassMethod LookUpCodeSetBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", epid As %Library.String = "", dischdate As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpCodeSetClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCodeSetFetch ]
{
}

/// KK 14/4/2003 Log 32794
/// To get DRG and corresponding Diagnosis and Procedure codes.
ClassMethod LookUpCodeSetExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", epid As %Library.String = "", dischdate As %Library.String = "") As %Library.Status
{
}

/// KK 14/4/2003 Log 32794
/// To get DRG and corresponding Diagnosis and Procedure codes.
ClassMethod LookUpCodeSetFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCodeSetExecute ]
{
}

/// KK 3/Apr/2003 Log 32776
ClassMethod LookUpDRGBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", val1 As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpDRGClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDRGFetch ]
{
}

/// KK 1/Apr/2003 - Log 32776
ClassMethod LookUpDRGExecute(ByRef QHandle As %Library.Binary, DRGCode As %Library.String = "", EpisodeID As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpDRGFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDRGExecute ]
{
}

/// KK 14/4/2003 Log 32794
/// To get DRG and corresponding Diagnosis and Procedure codes.
/// Lookup for "DRGCodeSet" Field in PAAdm.DRGCoding screen
Query LookUpCodeSet(val As %String = "", epid As %String = "", dischdate As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "desc,code,hidden,hidden")
{
}

/// KK 1/4/2003 Log 32776
/// To get DRG and corresponding Diagnosis and Procedure codes.
/// Lookup for "DRGCoding" Field in PAAdm.DRGCoding screen
Query LookUpDRG(DRGCode, EpisodeID) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc,code,hidden,hidden")
{
}

}

Class web.PATumor Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 266;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "TUM_RowId";

Parameter SQLDESCRIPTION = "TUM_RowId";

Parameter SQLROWID = "TUM_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// CJB 10/12/2002 - 26379
/// Purpose - To return a string of 0 and 1 respresenting if there is information behind the links.  The pieces 
/// are as follows - 
/// 1 - Histort of treatment
ClassMethod BoldLinks(tumor As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod FindTumorByCancerRegClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindTumorByCancerRegFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindTumorByCancerRegExecute(ByRef QHandle As %Library.Binary, CancerReg As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindTumorByCancerRegFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindTumorByCancerRegExecute ]
{
}

ClassMethod GetLinkedAdmDetails(Tumor As %Library.String, CancerReg As %Library.String)
{
}

ClassMethod websysDeleteTumor(id As %Library.String)
{
}

ClassMethod websysSaveTumor(compref As %Library.String, id As %Library.String, cancerreg As %Library.String)
{
}

/// KK 30/01/04 L:41881 - called from SuburbandPostCode hidden field in PATumor.Edit
ClassMethod SuburbandPostCodeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", pid As %Library.String = "") As %Library.Boolean
{
}

/// cjb 22/07/2004 44078 - method called from the update button on PATumor.List
/// cjb 06/10/2004 44078 - re-written the method to use the ICD rowid's instead of the Codes.  Also using cache to get the ICDEdition from the discharge date as SQL wasn't working.
ClassMethod ValidateList(compref As %Library.String, PatientID As %Library.String)
{
}

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod ValidateDates(compid As %String, id As %String) As %String
{
}

ClassMethod ValidateCodeTableDates(compid As %String, id As %String) As %String
{
}

Query FindTumorByCancerReg(CancerReg As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "comments,rowid,patientid,cancerreg,primarysite,tumortype,firstdiagdate,estimate,diagmethod,currenttreatment,firstdiagplace,histdeliv,histsite,histtreatment,meta,morph,specify,treatingdoc,localdoc,primicdcode,morphicdcode,differentiation,extent,datemeta,daterec,later,primrowid,morphrowid")
{
}

}

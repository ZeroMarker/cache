Class web.PASMR Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 500;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SMR_RowId";

Parameter SQLDESCRIPTION = "SMR_RowId";

Parameter SQLROWID = "SMR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod Confirm(id As %Library.String, type As %Library.String, ISDRef As %Library.String)
{
}

/// Default implementation of LookUp Query.
ClassMethod FindEpisodeFromISDRefClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEpisodeFromISDRefFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindEpisodeFromISDRefExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, ISDRef As %Library.String, SMR00 As %Library.String, SMR01 As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindEpisodeFromISDRefFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEpisodeFromISDRefExecute ]
{
}

ClassMethod RequestSMR(StartDate As %Library.String, EndDate As %Library.String, SMR00 As %Library.String, SMR01 As %Library.String, UKExtract1 As %Library.String, UKExtract2 As %Library.String, UKExtract3 As %Library.String, UKExtract4 As %Library.String, UKExtract5 As %Library.String, UKExtract6 As %Library.String, UKExtract7 As %Library.String, UKExtract8 As %Library.String, UKExtract9 As %Library.String, UKExtract10 As %Library.String)
{
}

/// Aji - Log 34918,34930 : this method is used by QHME, needs to be different from RequestSMR 
/// because this one needs to be password protected
/// can accept multi hospitals
/// 
ClassMethod RunExtract(compref As %Library.String, StartDate As %Library.String, EndDate As %Library.String)
{
}

Query FindEpisodeFromISDRef(TSRTITM As %Library.String, TSRTORD As %Library.String, ISDRef As %Library.String, SMR00 As %Library.String, SMR01 As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "type,rego,surname,forename,dob,sex,paperid,episodeid,visstat,stdate,sttime,enddate,endtime,cons,spc,ward,rowid,ISDRef")
{
}

}

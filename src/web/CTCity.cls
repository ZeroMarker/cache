Include webimport

IncludeGenerator webimport

Class web.CTCity Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 126;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "CTCIT_Code";

Parameter SQLDATEFROM = "CTCIT_DateFrom";

Parameter SQLDATETO = "CTCIT_DateTo";

Parameter SQLDESCRIPTION = "CTCIT_Desc";

Parameter SQLROWID = "CTCIT_RowId";

/// cjb 30/01/2003 30989: Auto correction of suburb.
ClassMethod Translate(city As %Library.String)
{
}

ClassMethod LookUpExtDOBClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpExtDOBFetch ]
{
}

/// cjb 15/04/2005 51411 - new query.  written in cache, sets date variable and runs LookUpExtDate
/// called from PAPerson.Edit, City of Birth [CTCITDescBirth] field, where date is patient DOB
ClassMethod LookUpExtDOBExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, date As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpExtDOBFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpExtDOBExecute ]
{
}

/// cjb 15/04/2005 51411 - new broker.
/// called from PAPerson.Edit, City of Birth [CTCITDescBirth] field, where date is patient DOB
ClassMethod LookUpExtDOBBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String, date As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerExt(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/*Query LookUpWithProv(ProvinceDR As %String, desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,HIDDEN:%String,Prov:%String")
{
SELECT	CTCIT_Desc,CTCIT_RowId,CTCIT_Code,CTCIT_Province_DR->PROV_Desc
FROM	CT_City
WHERE	((CTCIT_Desc=:desc)
OR	    (CTCIT_Desc [ :desc))
AND     ((:ProvinceDR is null) OR (CTCIT_Province_DR=:ProvinceDR))
AND ((CTCIT_DateFrom IS NULL) OR (CTCIT_DateFrom <= CURRENT_DATE))
	AND ((CTCIT_DateTo IS NULL) OR (CTCIT_DateTo >= CURRENT_DATE))
}*/
Query LookUpExt(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Prov:%String,FiscalPrefix:%String")
{
SELECT	CTCIT_Desc,CTCIT_RowId,CTCIT_Code,CTCIT_Province_DR->PROV_Desc,CTCIT_FiscalPrefix
FROM	CT_City
WHERE	((CTCIT_Code=:desc)
OR	    (CTCIT_Desc %STARTSWITH :desc))
AND ((CTCIT_DateFrom IS NULL) OR (CTCIT_DateFrom <= CURRENT_DATE))
	AND ((CTCIT_DateTo IS NULL) OR (CTCIT_DateTo >= CURRENT_DATE))
}

/// cjb 15/04/2005 51411 - new query.  copied from LookUpExt, but a date is passed.  added order by CTCIT_Desc
Query LookUpExtDate(desc As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Prov:%String,FiscalPrefix:%String")
{
SELECT	CTCIT_Desc,CTCIT_RowId,CTCIT_Code,CTCIT_Province_DR->PROV_Desc,CTCIT_FiscalPrefix
FROM	CT_City
WHERE	((CTCIT_Code=:desc)
OR	    (CTCIT_Desc %STARTSWITH :desc))
AND ((CTCIT_DateFrom IS NULL) OR (CTCIT_DateFrom <= :date))
	AND ((CTCIT_DateTo IS NULL) OR (CTCIT_DateTo >= :date))
order by CTCIT_Desc
}

/// cjb 15/04/2005 51411 - new query.  written in cache, sets date variable and runs LookUpExtDate
Query LookUpExtDOB(desc As %String, date As %Date = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,Prov:%String,FiscalPrefix:%String")
{
}

Query LookUpWithProv(ProvinceDR As %String, desc As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Description:%String,HIDDEN:%String,HIDDEN:%String,Prov:%String")
{
}

ClassMethod LookUpWithProvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpWithProvExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpWithProvExecute(ByRef qHandle As %Binary, ProvinceDR As %String, desc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 //CTCIT_Desc,CTCIT_RowId,CTCIT_Code,CTCIT_Province_DR->PROV_Desc,CTCIT_FiscalPrefix
 s ^scl("llok")=ProvinceDR_","_desc
 s desc=$$ALPHAUP^SSUTIL4(desc)
 s CTCITRowId=0
 f  s CTCITRowId=$o(^CT("CIT",CTCITRowId)) q:CTCITRowId=""  d
 .s CTCITDesc=$p(^CT("CIT",CTCITRowId),"^",2)
 .q:(desc'="")&&(($$ALPHAUP^SSUTIL4(CTCITDesc)'[desc))
 .s CTCITCode=$p(^CT("CIT",CTCITRowId),"^",1)
 .s CTCITProvinceDR=$p(^CT("CIT",CTCITRowId),"^",4)
 .q:(CTCITProvinceDR'=ProvinceDR)&&(ProvinceDR'="")
 .s PROVDesc=$p(^CT("PROV",CTCITProvinceDR),"^",2)
 .s CTCITFiscalPrefix=$p(^CT("CIT",CTCITRowId),"^",3)
 .s Active=$p(^CT("CIT",CTCITRowId),"^",11)
 .q:Active'="Y"
 .s DateActiveFrom=$p(^CT("CIT",CTCITRowId),"^",5)
 .s DateActiveTo=$p(^CT("CIT",CTCITRowId),"^",6)
 .q:(DateActiveFrom>+$h)&&(DateActiveFrom'="")
 .q:(DateActiveTo<+$h)&&(DateActiveTo'="")
 .do OutputRow3 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
	set Data=$lb(CTCITDesc,CTCITRowId,PROVDesc,CTCITFiscalPrefix)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	Quit
}

ClassMethod LookUpWithProvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpWithProvExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	
	    // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

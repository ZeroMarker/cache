Include webimport

IncludeGenerator webimport

Class web.CTProvinceNew Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*Query LookUp(defaultCountryDR As %String, desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,HIDDEN:%String,Prov:%String")
{
SELECT	PROV_Desc,PROV_RowId,PROV_Code,PROV_Region_DR->CTRG_Country_DR->CTCOU_Desc
FROM	CT_Province
WHERE	((PROV_Desc=:desc)
OR	    (PROV_Desc [:desc))
AND     ((:defaultCountryDR is null) OR (PROV_Region_DR->CTRG_Country_DR=:defaultCountryDR))
AND ((PROV_DateFrom IS NULL) OR (PROV_DateFrom <= CURRENT_DATE))
	AND ((PROV_DateTo IS NULL) OR (PROV_DateTo >= CURRENT_DATE))
}*/
Query LookUp(defaultCountryDR As %String, lookDefaultProvinceDR As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Description:%String,HIDDEN:%String,HIDDEN:%String,Prov:%String")
{
}

ClassMethod LookUpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LookUpExecute(ByRef qHandle As %Binary, defaultCountryDR As %String, lookDefaultProvinceDR As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s ^scl("llok")=defaultCountryDR_","_lookDefaultProvinceDR
 s PROVRowId=0
 f  s PROVRowId=$o(^CT("PROV",PROVRowId)) q:PROVRowId=""  d
 .s lookDefaultProvinceDR=$$ALPHAUP^SSUTIL4(lookDefaultProvinceDR)
 .s PROVDesc=$p(^CT("PROV",PROVRowId),"^",2)
 .s PROVCode=$p(^CT("PROV",PROVRowId),"^",1)
 .q:(lookDefaultProvinceDR'="")&&(($$ALPHAUP^SSUTIL4(PROVDesc)'[lookDefaultProvinceDR))
 .s PROVDateFrom=$p(^CT("PROV",PROVRowId),"^",4)
 .q:(PROVDateFrom'="")&&(PROVDateFrom>+$h)
 .s PROVDateTo=$p(^CT("PROV",PROVRowId),"^",5)
 .q:(PROVDateTo'="")&&(PROVDateTo<=+$h)
 .s PROVRegionDR=$p(^CT("PROV",PROVRowId),"^",3)
 .s CTRGCountryDR=$p(^CT("RG",PROVRegionDR),"^",4)
 .q:(defaultCountryDR'="")&&(CTRGCountryDR'=defaultCountryDR)
 .s Active=$p(^CT("PROV",PROVRegionDR),"^",10)
 .q:Active'="Y"
 .s CTCOUDesc=$p(^CT("COU",CTRGCountryDR),"^",2)
 .do OutputRow3 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
	set Data=$lb(PROVDesc,PROVRowId,PROVCode,CTCOUDesc)
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	Quit
}

ClassMethod LookUpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpExecute ]
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

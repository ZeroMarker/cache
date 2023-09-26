Class web.CTHospital Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 326;

Parameter SQLCODE = "HOSP_Code";

Parameter SQLDATEFROM = "HOSP_DateFrom";

Parameter SQLDESCRIPTION = "HOSP_Desc";

Parameter SQLDATETO = "HOSP_DateTo";

Parameter SQLROWID = "HOSP_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// ab 13.06.03 - used on PAPerson.List, returns list of hospitals searched
/// ab 28.09.04 - hidden flag will return a list in format hosp1|hosp2|hosp3
/// by wuqk 2011-06-25
ClassMethod GetSearchedHosp(hosps As %String = "", hidden As %String = "") As %String
{
	s hospsDesc=""
	if hosps'=""{
		for index=1:1:$l(hosps,"|"){
			continue:$p(hosps,"|",index)=""
			set hospdesc=$p(^CT("HOSP",+$p(hosps,"|",index)),"^",2)
			set hospsDesc=hospsDesc_hospdesc_"|"
		}
	}
	set:hospsDesc'="" hospsDesc=$e(hospsDesc,1,$l(hospsDesc)-1) 
	quit hospsDesc
}

ClassMethod FindReciprocalHospBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "", HospitalDR As %String = "") As %Boolean
{
}

/// by wuqk 2011-06-02
ClassMethod GetDescFromRowId(hospID As %Library.String) As %Library.String
{
	quit:hospID="" ""
	quit $p($g(^CT("HOSP",hospID)),"^",2)
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", HCARowID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpAnyHospitalBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", date As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpHospByHCABroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", desc As %Library.String = "", HCARowID As %Library.String = "") As %Library.Boolean
{
}

/// aji 4.9.03 - L34918
/// aji 3.11.03 - L34918 : added a parameter to indicate whether logon hosp. should be used
ClassMethod LookUpHospitalBySSGPBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", useLogonHosp As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpHospbyHCAClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpHospbyHCAFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod LookUpHospbyHCAExecute(ByRef QHandle As %Library.Binary, desc As %String, HCARowID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s date=+$h
	;wanghc
	s zid=0 for  s zid=$o(^CT("HOSP",zid)) q:zid=""  d
	.s zdesc=$p(^CT("HOSP",zid),"^",2)
	.q:(desc'="")&&('(zdesc[desc))
	.s from=$p(^CT("HOSP",zid),"^",9)		
	.q:(from'="")&&(date'="")&&(date<from)
	.s to=$p(^CT("HOSP",zid),"^",10)	
	.q:(to'="")&&(date>to)&&(date'="")
	.s zcode=$p(^CT("HOSP",zid),"^",1)
	.s trustdr=$p(^CT("HOSP",zid),"^",6)
	.s hcadr=""
	.s:trustdr'="" hcadr=$p(^PAC("TRUST",trustdr),"^",5)
	.q:(HCARowID'="")&&(hcadr'=HCARowID)
	.s ^CacheTemp(repid,ind)=$lb(zdesc,zid,zcode)
	.s ind=ind+1
	quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod LookUpHospbyHCAFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpHospbyHCAExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// select desc code by date and desc
ClassMethod LookupAnyHospitalExecute(ByRef QHandle As %Library.Binary, desc As %String = "", date As %String = "") As %Library.Status
{
	;wanghc
	//Description:%String,HIDDEN(zid):%String,Code:%String,HIDDEN(datefrom):%String
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s zid=0 for  s zid=$o(^CT("HOSP",zid)) q:zid=""  d
	.s zdesc=$p(^CT("HOSP",zid),"^",2)
	.q:(desc'="")&&('(zdesc[desc))
	.s from=$p(^CT("HOSP",zid),"^",9)		
	.q:(from'="")&&(date'="")&&(date<from)
	.s to=$p(^CT("HOSP",zid),"^",10)	
	.q:(to'="")&&(date>to)&&(date'="")
	.s zcode=$p(^CT("HOSP",zid),"^",1)
	.s ^CacheTemp(repid,ind)=$lb(zdesc,zid,zcode,from)
	.s ind=ind+1
	quit $$$OK
}

ClassMethod LookupAnyHospitalFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupAnyHospitalExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookupAnyHospitalClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupAnyHospitalFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpHospitalBySSGPClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpHospitalBySSGPFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpHospitalBySSGPExecute(ByRef QHandle As %Library.Binary, desc As %Library.String = "", useLogonHosp As %Library.Boolean = "") As %Library.Status
{
	//wanghc
	//"HIDDEN:%String,Description:%String,Code:%String"
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	//by wuqk 2011-06-18 全输出，未判断条件
	s rowid=0 f  s rowid=$o(^CT("HOSP",rowid)) q:rowid=""  d
	.s zdesc=$p(^CT("HOSP",rowid),"^",2)
	.s zcode=$p(^CT("HOSP",rowid),"^",1)
	.s ^CacheTemp(repid,ind)=$lb(rowid,zdesc,zcode)
	.s ind=ind+1
	
	//s ^CacheTemp(repid,ind)=$lb("","","")
	s ind=ind+1
	quit $$$OK
}

ClassMethod LookUpHospitalBySSGPFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpHospitalBySSGPExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpHospitalOnTrustBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpHospitalOnTrustClose(ByRef QHandle As %Binary) As %Library.Status [ PlaceAfter = LookUpHospitalOnTrustExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LookUpHospitalOnTrustExecute(ByRef QHandle As %Binary, val As %String = "") As %Library.Status
{
	//HIDDEN:%String,Desc:%String,Code:%String
	;wanghc
	s repid=$I(^CacheTemp)
	s ind=1
	s date=+$h
	s QHandle=$lb(0,repid,0)
	s rowid="" f  s rowid=$o(^CT("HOSP",rowid)) q:rowid=""  d
	.s trust=$p(^CT("HOSP",rowid),"^",6)
	.q:(val'="")&&(val'=trust)
	.s from=$p(^CT("HOSP",zid),"^",9)		
	.q:(from'="")&&(date'="")&&(date<from)
	.s to=$p(^CT("HOSP",zid),"^",10)	
	.q:(to'="")&&(date>to)&&(date'="")
	.s zdesc=$p(^CT("HOSP",rowid),"^",2)
	.s zcode=$p(^CT("HOSP",rowid),"^",1)
	.s ^CacheTemp(repid,ind)=$lb(roiwd,zdesc,zcode)
	.s ind=ind+1
	quit $$$OK
}

ClassMethod LookUpHospitalOnTrustFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Library.Status [ PlaceAfter = LookUpHospitalOnTrustExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpPRS2ESISBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpPRS2ESISClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpPRS2ESISFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpPRS2ESISExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpPRS2ESISFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpPRS2ESISExecute ]
{
}

/// AI 18-Jun 2002: This is called from the OEOrder.Edit.Profile.csp page and the epr.Chart.csp page.
/// It receives no values as input but returns a delimited string of All Hospital Values and All Hospital Text.
/// by wuqk 2011-06-05
ClassMethod getHospital() As %Library.String
{
	set hospCode="",hospDesc=""
	set hospid=$o(^CT("HOSP", 0))
	while hospid'=""{
		set hospCode=hospCode_$p($g(^CT("HOSP", hospid)),"^",1)_","
		set hospDesc=hospDesc_$p($g(^CT("HOSP", hospid)),"^",1)_"^"
		set hospid=$o(^CT("HOSP", hospid))
	}
	set:hospCode'="" hospCode=$e(hospCode,1,$l(hospCode)-1)
	set:hospDesc'="" hospDesc=$e(hospDesc,1,$l(hospCode)-1)
	quit hospCode_"|"_hospDesc
}

/// zhaocz  2011-05-25 
ClassMethod getTrustId(hospid As %Library.String) As %Library.String
{
	s mytrustId=""
	q:(hospid="") mytrustId
	
	s mytrustId=$p(^CT("HOSP", hospid), "^", 6)
	q mytrustId
}

ClassMethod LookupAnyHospitalWODateBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookupAnyHospitalWODateClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookupAnyHospitalWODateFetch ]
{
}

ClassMethod LookupAnyHospitalWODateExecute(ByRef QHandle As %Library.Binary, desc As %String = "") As %Library.Status
{
}

ClassMethod LookupAnyHospitalWODateFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookupAnyHospitalWODateExecute ]
{
}

ClassMethod LookUpByHospitalorIDBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", hospid As %Library.String = "", date As %Library.Date = "") As %Library.Boolean
{
}

Query FindReciprocalHosp(Desc As %String, HospitalDR As %String = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,HOSPCode:%String,HOSPDesc:%String")
{
SELECT 	DISTINCT HOSP_RowId, HOSP_Desc, HOSP_Code
FROM 	SQLUser.CT_Hospital
WHERE	(HOSP_Desc %STARTSWITH :Desc)
AND	SQLUser.CT_Hospital.HOSP_RowId IN (
	SELECT REC_Hospital_DR 
	FROM  SQLUser.CT_HospitalReciprocalHosp
	WHERE REC_ParRef=:HospitalDR)
OR	((HOSP_RowId=:HospitalDR) AND (HOSP_Desc %STARTSWITH :Desc))
ORDER	BY  HOSP_Desc
}

Query List() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "HOSPRowId:%String,HOSPCode:%String,HOSPDesc:%String")
{
SELECT HOSP_RowId, HOSP_Code, HOSP_Desc
FROM SQLUser.CT_Hospital
}

Query LookUpHospbyHCA(desc As %Library.String = "", HCARowID As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "HospDesc,HIDDEN,HospCode")
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpHospital(desc As %String, HCARowID As %Library.String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
SELECT HOSP_Desc, HOSP_RowId, HOSP_Code, HOSP_MandatoryRefHospital
FROM SQLUser.CT_Hospital
WHERE ((HOSP_Desc %STARTSWITH :desc) OR (HOSP_Code %STARTSWITH :desc) OR (:desc is NULL))
AND ((:HCARowID is null) OR (HOSP_Trust_DR->TRUST_HCA_DR=:HCARowID))
ORDER BY HOSP_Desc
}

/// AND (((:date is not null)AND(HOSP_DateTo>=:date)) OR (:date is null))
Query LookUpByHospitalorID(desc As %String, hospid As %Library.String = "", date As %Library.Date = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
	
SELECT HOSP_Desc, HOSP_RowId, HOSP_Code
FROM SQLUser.CT_Hospital
WHERE (((:hospid is not null) AND (HOSP_RowId=:hospid)) OR (:hospid is  null))
 AND ((HOSP_DateTo>=:date) OR (:date is null) OR (HOSP_DateTo is null))
 AND ((HOSP_DateFrom<=:date) OR (:date is null) OR (HOSP_DateFrom is null))
 AND ((HOSP_Desc %STARTSWITH :desc) OR (HOSP_Code=:desc))
ORDER BY HOSP_Desc
}

Query LookUpHospitalBySSGP(desc As %String, useLogonHosp As %Boolean) As %Library.Query(CONTAINID = 0, ROWSPEC = "HIDDEN:%String,Description:%String,Code:%String")
{
}

Query LookUpPRS2ESIS(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// standard query for simple hospital lookup
Query LookupAnyHospital(desc As %String, date As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
}

Query LookupAnyHospitalWODate(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
}

/// query hospital by HOSP_Trust_DR
/// return id,desc,code
Query LookUpHospitalOnTrust(val As %String = "") As %Library.Query(ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
}

Query LookUpESIS(desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod LookUpESISClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpESISFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpESISExecute(ByRef QHandle As %Library.Binary, desc As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpESISFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpESISExecute ]
{
}

ClassMethod LookUpESISBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

}

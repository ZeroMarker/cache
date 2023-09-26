Class web.CTLocationList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 209;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "LL_Code";

Parameter SQLDESCRIPTION = "LL_Desc";

Parameter SQLROWID = "LL_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindLocDetailsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindLocDetailsFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindLocDetailsExecute(ByRef QHandle As %Library.Binary, RetType As %String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1	
	;componentName=PACWard.FindWardBedStat.Preferences
	s GroupID=%session.Get("LOGON.GROUPID")
	s LocListID=$p($g(^SSU("SSGRP",GroupID)),"^",36)
	;Departments
	;&sql(select link_parref->ctloc_desc,link_parref from SQLUser.CT_LocLinkLocation where link_ctloc_dr->ctloc_type='W')
	i RetType="dept" d
	.s parref=0 f  s parref=$o(^CTLOC(parref)) q:parref=""  d
	..s (val,desc)=""
	..s sub=0 f  s sub=$o(^CTLOC(parref,"LINK",sub)) q:(sub="")||(val'="")  d
	...s locdr=$p(^CTLOC(parref,"LINK",sub),"^",1)	
	...s type=$p(^CTLOC(locdr),"^",13)
	...q:type'="W"
	...s val=$p(^CTLOC(parref),"^",1)
	...s desc=$p(^CTLOC(parref),"^",2)		
	...d outrow
	;Responsible Units
	;&sql(select * from CT_ResponsibleUnit)
	i RetType="ru" d
	.s rowid=0 f  s rowid=$O(^CT("RU",rowid)) q:rowid=""  d
	..s val=$p(^CT("RU",rowid),"^",1)
	..s desc=$p(^CT("RU",rowid),"^",2)
	..d outrow
	;Hospitals
	i RetType="hosp" d
	.s (val,desc)=""
	.s rowid=0 f  s rowid=$o(^CTLOC(0,"Hosp",rowid)) q:rowid=""  d
	..s val=$p(^CT("HOSP",rowid),"^",1)
	..s desc=$p(^CT("HOSP",rowid),"^",2)
	..d outrow
	;Health Care Area
	;&sql(select * from CT_HealthCareArea)
	i RetType="hca" d
	.s (val,desc)=""
	.s rowid=0 f  s rowid=$o(^CT("HCA",rowid)) q:rowid=""  d
	..s val=$p(^CT("HCA",rowid),"^",1)
	..s desc=$p(^CT("HCA",rowid),"^",2)
	..d outrow

	;Health Care Region
	;CT_HealthCareRegion
	i RetType="hcr" d
	.s (val,desc)=""
	.s rowid=0 f  s rowid=$o(^CT("HCR",rowid)) q:rowid=""  d
	..s val=$p(^CT("HCR",rowid),"^",1)
	..s desc=$p(^CT("HCR",rowid),"^",2)
	..d outrow
	;Trust
	i RetType="trust" d
	.s (val,desc)=""
	.s rowid=0 f  s rowid=$o(^PAC("TRUST",rowid)) q:rowid=""  d
	..s val=$p(^PAC("TRUST",rowid),"^",1)
	..s desc=$p(^PAC("TRUST",val),"^",2)
	..d outrow
	s QHandle=$lb(0,repid,0)
	q $$$OK
outrow
	s ^CacheTemp(repid,ind)=$lb(val,desc)
	s ind=ind+1
	q
}

ClassMethod FindLocDetailsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindLocDetailsExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindLocDetails(RetType As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "val,desc")
{
}

/// ab 15.12.03 rewrote this as the above query.. since broker has some strange behavior
/// 
/// returns the codes/descriptions for responsible units, departments or hospitals linked to the locations in a location list
/// called by hidden broker in PACWard.FindWardBedStat.Preferences
ClassMethod zzFindLocationDetails(itmjs As %Library.String = "", itmjsex As %Library.String = "", LocListID As %Library.String = "", RetType As %Library.String = "") As %Library.Boolean
{
}

/// This returns description,id,code (this is to be consitent with lookups)
ClassMethod GetDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod GetLocationIDs(ListID As %Library.String) As %Library.String
{
}

}

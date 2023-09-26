Import SQLUser

Class web.DHCLocSpec Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DeleteLocSpecByID(id As %String)
{
	set result=##class(User.DHCLocSpec).%DeleteId(id)
		
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "0"
		
	}
	else
	{
		quit "1"	
	}
}

ClassMethod InsertLocSpec(loc As %String, spec As %String, serviceGroup As %String)
{
	set count=0
	&sql(select count(DHCLS_Loc_DR) into :count from SQLUSER.DHC_LocSpec where DHCLS_Loc_DR=:loc and DHCLS_CG_DR=:spec and DHCLS_CGS_DR=:serviceGroup)
	if (count>0)
	{
		quit "2"
	}
	set locspec=##class(User.DHCLocSpec).%New()
	Do locspec.DHCLSLocDRSetObjectId(loc)
	Do locspec.DHCLSCGDRSetObjectId(spec)
	Do locspec.DHCLSCGSDRSetObjectId(serviceGroup)
	//set locspec.DHCLSLocDR=##class(User.CTLoc).%OpenId(loc)
	//set locspec.DHCLSCGDR=##class(User.RBCClinicGroup).%OpenId(spec)
	
	set result=locspec.%Save()
	
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "0"
	}
	else
	{
		quit "1"	
	}
}

ClassMethod UpdateLocSpec(id As %String, loc As %String, spec As %String, serviceGroup As %String)
{
	set count=0
	&sql(select count(DHCLS_Loc_DR) into :count from SQLUSER.DHC_LocSpec where DHCLS_Loc_DR=:loc and DHCLS_CG_DR=:spec and DHCLS_CGS_DR=:serviceGroup and %id!=:id)
	if (count>0)
	{
		quit "2"
	}
	
	set locspec=##class(User.DHCLocSpec).%OpenId(id)
	set locspec.DHCLSLocDR=##class(User.CTLoc).%OpenId(loc)
	set locspec.DHCLSCGDR=##class(User.RBCClinicGroup).%OpenId(spec)
	set locspec.DHCLSCGSDR=##class(User.RBCClinicServiceGroup).%OpenId(serviceGroup)
	
	set result=locspec.%Save()
	
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "0"
		
	}
	else
	{
		quit "1"	
	}
}

Query GetAllLocSpec(LocRowID As %String, ClinicRowID As %String, ServiceGroupId As %String) As %SQLQuery
{
SELECT %id AS ID,DHCLS_Loc_DR->CTLOC_Desc AS LocName,DHCLS_CG_DR->CLGRP_Desc AS ClinicName,DHCLS_Loc_DR AS locid,DHCLS_CG_DR AS clinicid,DHCLS_CGS_DR As ClinicService FROM SQLUSER.DHC_LocSpec 
where (DHCLS_Loc_DR %STARTSWITH :LocRowID) and (DHCLS_CG_DR %STARTSWITH :ClinicRowID) and (DHCLS_CGS_DR %STARTSWITH :ServiceGroupId)
}

/// d ##class(%ResultSet).RunQuery("web.DHCLocSpec","GetAllLocSpecNew","LocRowID","ClinicRowID")
Query GetAllLocSpecNew(LocRowID As %String, ClinicRowID As %String, ServiceGroupId As %String, HospId As %String = "") As %Query(ROWSPEC = "ID:%String,LocName:%String,ClinicName:%String,locid:%String,clinicid:%String,TimeOutFlag:%String,ClinicService:%String,ClinicServiceId:%String,ServiceTimeOut:%String")
{
}

ClassMethod GetAllLocSpecNewExecute(ByRef QHandle As %Binary, LocRowID As %String, ClinicRowID As %String, ServiceGroupId As %String, HospId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s DHCLSRowid=0 f  s DHCLSRowid=$o(^DHCLocSubject(DHCLSRowid)) q:DHCLSRowid=""  d
	.s locid=$p(^DHCLocSubject(DHCLSRowid),"^",1)
	.s clinicid=$p(^DHCLocSubject(DHCLSRowid),"^",2)
	.s ClinicServiceId=$p(^DHCLocSubject(DHCLSRowid),"^",3)
	.q:(locid'=LocRowID)&&(LocRowID'="")
	.q:(clinicid'=ClinicRowID)&&(ClinicRowID'="")
	.q:(ClinicServiceId'=ServiceGroupId)&&(ServiceGroupId'="")
	.s ClinicName=$p(^RBC("CLGRP",clinicid),"^",2)
	.s ShowDataFlag=##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicGroup",clinicid,HospId)
	.//Q:(HospId'="")&&(ShowDataFlag="N")
	.i (ShowDataFlag="N")&&(HospId'="") s ClinicName=ClinicName_"<font color='red'> (未授权)</font>"
	.s LocName=$p(^CTLOC(locid),"^",2)
	.s LocHosp=$p(^CTLOC(locid),"^",22)
	.Q:(HospId'="")&&(HospId'=LocHosp)
	.s DateFrom=$p(^RBC("CLGRP",clinicid),"^",3)
	.s DateTo=$p(^RBC("CLGRP",clinicid),"^",4)
	.s TimeOut="",date=..%SysDate()
	.i (DateFrom>date)!((date>DateTo)&&(DateTo'="")) s TimeOut="Y"
	.s:TimeOut="Y" ClinicName=ClinicName_"<font color='red'> (已过期)</font>"
	.s ServiceTimeOut="",date=..%SysDate()
	.i ClinicServiceId'="" d
	..s ClinicService=$p($g(^RBC("CLSGRP",ClinicServiceId)),"^",2)
	..s ShowDataFlag=##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicServiceGroup",ClinicServiceId,HospId)
	..i (ShowDataFlag="N")&&(HospId'="") s ClinicService=ClinicService_"<font color='red'> (未授权)</font>"
	..s DateFrom=$p(^RBC("CLSGRP",ClinicServiceId),"^",3)
	..s DateTo=$p(^RBC("CLSGRP",ClinicServiceId),"^",4)
	..i (DateFrom>date)!((date>DateTo)&&(DateTo'="")) s ServiceTimeOut="Y"
	..s:ServiceTimeOut="Y" ClinicService=ClinicService_"<font color='red'> (已过期)</font>"
	.e  d 
	..s ClinicService=""
	.s Data=$lb(DHCLSRowid,LocName,ClinicName,locid,clinicid,TimeOut,ClinicService,ClinicServiceId,ServiceTimeOut)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
}

ClassMethod GetAllLocSpecNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetAllLocSpecNewExecute ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllLocSpecNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllLocSpecNewExecute ]
{
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

}

/// 得到 参数的纪录
Class web.DHCBL.Configure.PrefParas Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetYesNoInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYesNoInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetCTLoc(Code As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CTLOC_Desc, CTLOC_Code, CTLOC_RowID 
FROM SQLUser.CT_Loc
where (%ALPHAUP CTLOC_Desc %STARTSWITH %ALPHAUP :Code) or (%ALPHAUP CTLOC_Code %STARTSWITH %ALPHAUP :Code)
order by CTLOC_Desc
}

ClassMethod GetYesNoInfoExecute(ByRef qHandle As %Binary) As %Status
{
	New repid, index
	Set repid=$I(^CacheTemp)
	;d ##class(%ResultSet).RunQuery("web.DHCBL.Configure.PrefParas")
	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s YNDesc="No"
	s YNValue="N"
	d Output
	
	s YNDesc="Yes"
	s YNValue="Y"
	d Output
		
	Quit $$$OK
ResetVariables
	s (YNDesc, YNValue)=""
	quit
Output
	s Data=$lb(YNValue, YNDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

Query GetGroup(Code As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT SSGRP_Desc, SSGRP_Rowid
FROM SQLUser.SS_Group
WHERE (%ALPHAUP SSGRP_Desc %STARTSWITH %ALPHAUP :Code)
ORDER BY SSGRP_Desc
}

ClassMethod GetYesNoInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYesNoInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetUser(Code As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT SSUSR_Name,SSUSR_Initials, SSUSR_Group->SSGRP_Desc,SSUSR_DefaultDept_DR->CTLOC_Desc, SSUSR_RowID
FROM SQLUser.SS_User 
where ((%ALPHAUP SSUSR_Initials %STARTSWITH %ALPHAUP :Code) or (%ALPHAUP SSUSR_Name %STARTSWITH  %ALPHAUP :Code))
 and  SSUSR_Active='Y' and  ((SSUSR_DateTo>=+$h) or SSUSR_DateTo is null ) and ((SSUSR_DateFrom<=+$h) or SSUSR_DateFrom is null)
order by SSUSR_Name
}

// w ##class(%ResultSet).RunQuery(" web.DHCBL.Configure.PrefParas","GetHospital")

Query GetHospital(Code As %String = "") As %SQLQuery(CONTAINID = 1)
{

SELECT HOSP_Desc, HOSP_RowId, HOSP_Code
FROM SQLUser.CT_hospital
where (%ALPHAUP HOSP_Code %STARTSWITH %ALPHAUP :Code) or (%ALPHAUP HOSP_Desc %STARTSWITH  %ALPHAUP :Code)
order by HOSP_Desc
}

Query GetYesNoInfo() As %Query(ROWSPEC = "Value:%String,Desc:%String")
{
}

}

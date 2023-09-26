Class DHCEPRRBAC.BL.BLUser Extends %RegisteredObject [ ProcedureBlock ]
{

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLUser","GetExistUser")
Query GetExistUser() As %Query(ROWSPEC = "ID:%String,Name:%String,Code:%String,CTLocID:%String,SSGroupID:%String,CTLOC:%String,SSGroup:%String")
{
}

ClassMethod GetExistUserExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	s userID = ""
	for	{
		s userID = $o(^DHCEPRRBAC.INST.UserRoleI("IdxUserID"," DHC", userID))
		q:(userID = "")
		
		s rset = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLUser:SelectByUserID")
		s sc = rset.Execute($TR(userID," ",""))		
	
		while (rset.Next())
		{
			s SSUserID = rset.Data("ID")
			s UserName = rset.Data("Name")
			s UserCode = rset.Data("Code")
			s CTLocID = rset.Data("CTLocID")
			s SSGroupID = rset.Data("SSGroupID")
			s CTLoc = rset.Data("CTLOC") 
			s SSGroup = rset.Data("SSGroup")	

			s ^CacheTemp(repid,ind) = $lb(SSUserID,UserName,UserCode,CTLocID,SSGroupID,CTLoc,SSGroup)
	    	s ind=ind+1	
   		}	
   }	
   Quit $$$OK
}

ClassMethod GetExistUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExistUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetExistUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExistUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLUser","GetUser","","","","")
Query GetUser(AUserName As %String, AUserCode As %String, AGroupID As %String, ACTLocID As %String) As %Query(ROWSPEC = "SSUserID:%String,UserName:%String,UserCode:%String,CTLocID:%String,SSGroupID:%String,CTLoc:%String,SSGroup:%String,RoleID:%String,RoleName:%String,RoleCode:%String,RoleDesc:%String")
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary, AUserName As %String, AUserCode As %String, AGroupID As %String, ACTLocID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s:(AUserName = $c(0)) AUserName = ""
	s:(AUserCode = $c(0)) AUserCode = ""
	s:(AGroupID = $c(0)) AGroupID = ""
	s:(ACTLocID = $c(0)) ACTLocID = ""
	
	if (AUserName '= "")
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLUser:SelectByUserName")
		s sc = rset.Execute("%"_AUserName_"%")		
	}
	elseif (AUserCode '= "")
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLUser:SelectByUserCode")
		s sc = rset.Execute(AUserCode)
	}
	elseif (AGroupID '= "")
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLUser:SelectBySSGroupID")
		s sc = rset.Execute(AGroupID)	
	}
	elseif (ACTLocID '= "")
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLUser:SelectByCTLocID")
		s sc = rset.Execute(ACTLocID)
	}
	else
	{
		s rset = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLUser:GetExistUser")
		s sc = rset.Execute()
	}
	
	while (rset.Next())
	{
		s SSUserID = rset.Data("ID")
		s UserName = rset.Data("Name")
		s UserCode = rset.Data("Code")
		s CTLocID = rset.Data("CTLocID")
		continue:((ACTLocID '= "") && (ACTLocID '= CTLocID))
		s SSGroupID = rset.Data("SSGroupID")
		continue:((AGroupID '= "") && (AGroupID '= SSGroupID))
		s CTLoc = rset.Data("CTLOC") 
		s SSGroup = rset.Data("SSGroup")
		
		s rowID = ""
		s roleID = ""
		s roleName = ""
		s roleCode = ""
		s roleDesc = ""
		for {
			s rowID = $o(^DHCEPRRBAC.INST.UserRoleI("IdxUserID"," DHC"," "_SSUserID,rowID))	
			q:(rowID = "")
			s obj = ##class(DHCEPRRBAC.INST.UserRole).%OpenId(rowID)
			s oneRoleID = obj.RoleID
			s roleObj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(oneRoleID)
			if (roleID = "")
			{
				s roleID = oneRoleID
				s roleName = roleObj.RoleName
				s roleCode = roleObj.RoleCode
				s roleDesc = roleObj.RoleDesc
			}
			else
			{
				s roleID = roleID_"^"_oneRoleID	
				s roleName = roleName_"^"_roleObj.RoleName
				s roleCode = roleCode_"^"_roleObj.RoleCode
				s roleDesc = roleDesc_"^"_roleObj.RoleDesc
			}
		}
		s ^CacheTemp(repid,ind) = $lb(SSUserID,UserName,UserCode,CTLocID,SSGroupID,CTLoc,SSGroup,roleID,roleName,roleCode,roleDesc)
	    s ind=ind+1	
   }	
   Quit $$$OK
}

ClassMethod GetUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

Query SelectByCTLocID(ACTLocID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User  
	where SSUSR_DefaultDept_DR = :ACTLocID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserName(AUserName As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Name like :AUserName and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserCode(AUserCode As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_Initials = :AUserCode and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectByUserID(AUserID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
	from SQLUser.SS_User
	where SSUSR_RowId = :AUserID and (SSUSR_Active='Y' or SSUSR_Active='Yes') 
	order by SSUSR_name
}

Query SelectBySSGroupID(ASSGroupID As %String) As %SQLQuery
{
  	select SSUSR_RowId as ID, SSUSR_Name as Name, SSUSR_Initials as Code, SSUSR_DefaultDept_DR as CTLocID, SSUSR_Group as SSGroupID, SSUSR_DefaultDept_DR->CTLOC_Desc as CTLOC, SSUSR_Group->SSGRP_Desc as SSGroup
  	from SQLUser.SS_User
	where SSUSR_Group = :ASSGroupID and (SSUSR_Active='Y' or SSUSR_Active='Yes')
	order by SSUSR_name
}

Query GetAllSSGroup() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	order by SSGRP_RowId
}

Query GetSSGroupByName(argGroupName As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSGRP_RowId:%String,SSGRP_Desc:%String")
{
	select SSGRP_RowId,SSGRP_Desc 
	from SQLUser.SS_Group 
	where SSGRP_Desc like :argGroupName
}

}

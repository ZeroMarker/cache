Class EPRservice.dao.DPrivCTLocUser Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("EPRservice.dao.DPrivCTLocUser","SelectCTLocUser")
/// added by Jiangew on 2012-11-19
Query SelectCTLocUser() As %SQLQuery
{
	
     select a.SSUSR_initials, a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_RowId,
 	        a.SSUSR_Name,a.SSUSR_Initials, c.Description as UserLevel,b.ID, 
 	        d.Description as UserPos
 	from SQLUser.SS_User as a 
 	  left join EPRmeta_Privilege.PowerUser as b on (a.SSUSR_RowId=b.UserID) 
 	  left join EPRmeta.UserLevel c on (b.UserLevel = c.Name)
 	  left join EPRmeta.UserPost d on (b.UserPos = d.Name)
    where a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// d ##class(%ResultSet).RunQuery("EPRservice.dao.DPrivCTLocUser","SelectCTLocUserByCTLocName","bjek-保健二科")
Query SelectCTLocUserByCTLocName(CTLocName As %String) As %SQLQuery
{
  	select a.SSUSR_Group->SSGRP_Desc, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, 
  	       a.SSUSR_Name, a.SSUSR_Initials, c.Description as UserLevel, b.ID, d.Description as UserPos 
	from SQLUser.SS_User as a 
	   left join EPRmeta_Privilege.PowerUser as b on (a.SSUSR_RowId=b.UserID)
 	   left join EPRmeta.UserLevel c on (b.UserLevel = c.Name)
 	   left join EPRmeta.UserPost d on (b.UserPos = d.Name)	   
	where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and a.SSUSR_Active='Y' order by a.SSUSR_name
}

Query SelectCTLocUserByUserName(CTLocUser As %String) As %SQLQuery
{
  	select a.SSUSR_Group->SSGRP_Desc, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, 
  	a.SSUSR_Name, a.SSUSR_Initials, c.Description as UserLevel, b.ID, d.Description as UserPos
	from SQLUser.SS_User as a 
	   left join EPRmeta_Privilege.PowerUser as b on (a.SSUSR_RowId=b.UserID) 
	   left join EPRmeta.UserLevel c on (b.UserLevel = c.Name)
 	   left join EPRmeta.UserPost d on (b.UserPos = d.Name)	
	where (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

Query SelectCTLocUserByName(CTLocName As %String, CTLocUser As %String) As %SQLQuery
{
  	select a.SSUSR_Group->SSGRP_Desc, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, 
  	       a.SSUSR_Name, a.SSUSR_Initials, c.Description as UserLevel, b.ID, d.Description as UserPos
	from SQLUser.SS_User as a 
	   left join EPRmeta_Privilege.PowerUser as b on (a.SSUSR_RowId=b.UserID) 
	   left join EPRmeta.UserLevel c on (b.UserLevel = c.Name)
 	   left join EPRmeta.UserPost d on (b.UserPos = d.Name)		
	where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by Jiangew on 2012-11-21
Query SelectCTLocUserSub() As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByCTLocName(CTLocName As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID 
	from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b 
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByUserName(CTLocUser As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b 
	on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByName(CTLocName As %String, CTLocUser As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EPRmeta_Privilege.PowerUser as b
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y'
}

}

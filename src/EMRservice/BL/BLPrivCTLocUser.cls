Class EMRservice.BL.BLPrivCTLocUser Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Output：EMRservice.dataset.EPrivCTLocUserDataset
/// added by Jiangew on 2012-11-15
ClassMethod GetCTLocUserList() As EMRservice.dataset.EPrivCTLocUserDataset
{
	Set ds=##class(EMRservice.dataset.EPrivCTLocUserDataset).%New()
	Quit ds
}

/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPrivCTLocUser","SelectCTLocUser")
/// added by Jiangew on 2012-11-19
Query SelectCTLocUser() As %SQLQuery
{
	
     select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc,a.SSUSR_DefaultDept_DR->CTLOC_Desc,a.SSUSR_RowId,
 	        a.SSUSR_Name,a.SSUSR_Initials, c.Description as UserLevel,b.ID, 
 	        d.Description as UserPos
 	from SQLUser.SS_User as a 
 	  left join EMRmeta.PowerUser as b on (a.SSUSR_RowId=b.UserID) 
 	  left join EMRmeta.UserLevel c on (b.UserLevel = c.Name)
 	  left join EMRmeta.UserPost d on (b.UserPos = d.Name)
    where a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// 修改为依据RB_Resource 的科室关连关系过滤数据
/// d ##class(%ResultSet).RunQuery("EMRservice.BL.BLPrivCTLocUser","SelectCTLocUserByCTLocName","bjek-保健二科")
Query SelectCTLocUserByCTLocName(CTLocName As %String) As %SQLQuery
{
  	select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, 
  	       a.SSUSR_Name, a.SSUSR_Initials, c.Description as UserLevel, b.ID, d.Description as UserPos 
	FROM SQLUser.RB_Resource AS k 
		LEFT JOIN SQLUser.CT_CareProv AS l ON (k.RES_CTPCP_DR = l.CTPCP_RowId1)
		LEFT JOIN SQLUser.SS_User AS a ON (l.CTPCP_Code = a.SSUSR_Initials) 
		left join EMRmeta.PowerUser as b on (a.SSUSR_RowId=b.UserID)
		left join EMRmeta.UserLevel c on (b.UserLevel = c.Name)
		left join EMRmeta.UserPost d on (b.UserPos = d.Name)  
	where k.RES_CTLOC_DR->CTLOC_Desc like :CTLocName and a.SSUSR_Active='Y' order by a.SSUSR_name
}

Query SelectCTLocUserByUserName(CTLocUser As %String) As %SQLQuery
{
  	select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, 
  	a.SSUSR_Name, a.SSUSR_Initials, c.Description as UserLevel, b.ID, d.Description as UserPos
	from SQLUser.SS_User as a 
	   left join EMRmeta.PowerUser as b on (a.SSUSR_RowId=b.UserID) 
	   left join EMRmeta.UserLevel c on (b.UserLevel = c.Name)
 	   left join EMRmeta.UserPost d on (b.UserPos = d.Name)	
	where (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

Query SelectCTLocUserByName(CTLocName As %String, CTLocUser As %String) As %SQLQuery
{
  	select a.SSUSR_Group,a.SSUSR_Group->SSGRP_Desc, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, 
  	       a.SSUSR_Name, a.SSUSR_Initials, c.Description as UserLevel, b.ID, d.Description as UserPos
	from SQLUser.SS_User as a 
	   left join EMRmeta.PowerUser as b on (a.SSUSR_RowId=b.UserID) 
	   left join EMRmeta.UserLevel c on (b.UserLevel = c.Name)
 	   left join EMRmeta.UserPost d on (b.UserPos = d.Name)		
	where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y' order by a.SSUSR_name
}

/// added by Jiangew on 2012-11-21
Query SelectCTLocUserSub() As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByCTLocName(CTLocName As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID 
	from SQLUser.SS_User as a left join EMRmeta.PowerUser as b 
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByUserName(CTLocUser As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EMRmeta.PowerUser as b 
	on (a.SSUSR_RowId=b.UserID) where (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y'
}

Query SelectCTLocUserSubByName(CTLocName As %String, CTLocUser As %String) As %SQLQuery
{
	select a.SSUSR_Group, a.SSUSR_DefaultDept_DR->CTLOC_Desc, a.SSUSR_RowId, a.SSUSR_Name, a.SSUSR_Initials, b.ChildUsers, b.ID
	from SQLUser.SS_User as a left join EMRmeta.PowerUser as b
	on (a.SSUSR_RowId=b.UserID) where a.SSUSR_DefaultDept_DR->CTLOC_Desc like :CTLocName and (SSUSR_Name like :CTLocUser or SSUSR_Initials like :CTLocUser) and a.SSUSR_Active='Y'
}

}

Class DHCEPRRBAC.BL.BLDefaultRole Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加隐私域角色与安全组关联

ClassMethod CreateDefaultRole(aDefaultRole As DHCEPRRBAC.Entity.EDefaultRole) As %String
{
		
	s obj = ##class(DHCEPRRBAC.INST.DefaultRole).%New()
	s obj.RoleID = aDefaultRole.RoleID
	s obj.SSGroupID = aDefaultRole.SSGroupID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
	   q obj.%Id()
	}
	else
	{		
		q "-1"
	}
}

//更新隐私域角色与安全组关联

ClassMethod UpdateDefaultRole(aDefaultRole As DHCEPRRBAC.Entity.EDefaultRole) As %String
{
		
	s obj = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(aDefaultRole.ID)
	s obj.RoleID = aDefaultRole.RoleID
	s obj.SSGroupID = aDefaultRole.SSGroupID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
	   q obj.%Id()
	}
	else
	{		
		q "-1"
	}
}

//删除隐私域角色与安全组关联

ClassMethod DeleteDefaultRole(aDefaultRoleID As %String) As %String
{
	   
	q:(aDefaultRoleID ="") "-1"	
	s obj = ##Class(DHCEPRRBAC.INST.DefaultRole).%OpenId(aDefaultRoleID)
	q:(obj="") "-1"
	s sc = ##class(DHCEPRRBAC.INST.DefaultRole).%DeleteId(aDefaultRoleID)	
	if ($$$ISOK(sc))
	{
		q aDefaultRoleID
	}
	else
	{
		q "-1"
	}
}

/// 获取角色与安全组关联列表
/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLDefaultRole","GetDefaultRoleByRoleID")
Query GetDefaultRoleByRoleID(aRoleID As %String) As %Query(ROWSPEC = "ID:%String,RoleID:%String,SSGroupID:%String,SSGroupName:%String")
{
}

ClassMethod GetDefaultRoleByRoleIDExecute(ByRef qHandle As %Binary, aRoleID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for	{		
		s rowID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxRoleID"," "_aRoleID,rowID))		
		q:(rowID = "")

		s obj = ##class(DHCEPRRBAC.INST.DefaultRole).%OpenId(rowID)
		
		s RoleID = obj.RoleID
		s SSGroupID = obj.SSGroupID
		s SSGroupName=..GetSSGroupName(SSGroupID)
		
		s ^CacheTemp(repid,ind) = $lb(rowID,RoleID,SSGroupID,SSGroupName)
	    s ind=ind+1		
   }
   Quit $$$OK
}

ClassMethod GetDefaultRoleByRoleIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDefaultRoleByRoleIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDefaultRoleByRoleIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDefaultRoleByRoleIDExecute ]
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

ClassMethod GetSSGroupName(SSGroupID As %String) As %String
{
	
	s SSGRPDesc=""
	&SQL(select SSGRP_Desc into :SSGRPDesc from SQLUser.SS_Group where SSGRP_RowId=:SSGroupID)
	q SSGRPDesc
}

//检查隐角色、安全组关联是否添加

ClassMethod CheckDefaultRole(SSGroupID As %String, RoleID As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupRoleID"," "_SSGroupID," "_RoleID,rowID))
	q rowID
}

}

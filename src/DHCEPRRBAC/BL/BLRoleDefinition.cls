Class DHCEPRRBAC.BL.BLRoleDefinition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加隐私域角色

ClassMethod CreateRoleDefinition(aRoleDefinition As DHCEPRRBAC.Entity.ERoleDefinition) As %String
{
		
	s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%New()
	s obj.DefaultRole = aRoleDefinition.DefaultRole
	s obj.RoleActive = aRoleDefinition.RoleActive
	s obj.RoleCode = aRoleDefinition.RoleCode
	s obj.RoleDesc = aRoleDefinition.RoleDesc
	s obj.RoleName = aRoleDefinition.RoleName
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

//更新隐私域角色

ClassMethod UpdateRoleDefinition(aRoleDefinition As DHCEPRRBAC.Entity.ERoleDefinition) As %String
{
		
	s obj = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(aRoleDefinition.ID)
	s obj.DefaultRole = aRoleDefinition.DefaultRole
	s obj.RoleActive = aRoleDefinition.RoleActive
	s obj.RoleCode = aRoleDefinition.RoleCode
	s obj.RoleDesc = aRoleDefinition.RoleDesc
	s obj.RoleName = aRoleDefinition.RoleName
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

//删除隐私域角色

ClassMethod DeleteRoleDefinition(aRoleDefinitionID As %String) As %String
{
	q:(aRoleDefinitionID ="") "-1"	
	s obj = ##Class(DHCEPRRBAC.META.RoleDefinition).%OpenId(aRoleDefinitionID)
	q:(obj="") "-1"
	s sc = ##class(DHCEPRRBAC.META.RoleDefinition).%DeleteId(aRoleDefinitionID)	
	if ($$$ISOK(sc))
	{
		q aRoleDefinitionID
	}
	else
	{
		q "-1"
	}
}

//检查隐私域角色是否添加

ClassMethod CheckRoleDefinitionCode(aRoleCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.META.RoleDFI("IdxMain"," "_aRoleCode,rowID))
	q rowID
}

}

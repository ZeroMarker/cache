Class DHCEPRRBAC.BL.BLPermission Extends %RegisteredObject [ ProcedureBlock ]
{

/// debug: w ##class(DHCEPRRBAC.BL.BLPermission).GetPermissionByUserID()
ClassMethod GetPermissionByUserID(AUserID As %String) As %String
{
	s ret = ""
	s roleIDs = ##class(DHCEPRRBAC.BL.BLRole).GetRoleIDByUserID(AUserID)
	q:(roleIDs = "") ret
	for index=1:1:$l(roleIDs,"^")
	{
		s roleID = $p(roleIDs,"^",index)	
		s permissionIDs = ..GetPermissionByRoleID(roleID)	
		if (ret = "")
		{
			s ret = permissionIDs
		}
		else
		{
			s ret = ret_"^"_permissionIDs		
		}
	}
	q ret
}

ClassMethod GetPermissionByRoleID(ARoleID As %String) As %String
{
	s ret = ""	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRRBAC.INST.RolePerI("IdxRole"," "_ARoleID,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRRBAC.INST.RolePermission).%OpenId(rowID)
		s permissionID = obj.PermissionID
		if (ret = "")
		{
			s ret = permissionID	
		}	
		else
		{
			s ret = ret_"^"_permissionID	
		}
	}
	q ret
}

}

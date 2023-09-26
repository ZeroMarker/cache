Class DHCEPRRBAC.web.eprajax.Role Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s roleID = $g(%request.Data("RoleID",1),"")
	s roleName = $g(%request.Data("RoleName",1),"")
	s roleCode = $g(%request.Data("RoleCode",1),"")
	s roleDesc = $g(%request.Data("RoleDesc",1),"")
	
	s opID = $g(%request.Data("OpID",1),"")
	s privateDomainIDList = $g(%request.Data("PrivateDomainIDList",1),"")
	s resourceItemIDList = $g(%request.Data("ResourceItemIDList",1),"")
	
	s ssgroupIDS = $g(%request.Data("SSGroupIDS",1),"")
	s ssgroupID = $g(%request.Data("SSGroupID",1),"")
	
	if (action = "rolelist")
	{
		d ..GetRoleListJSON(startRow,endRow)
	}
	elseif (action = "rolelistdetail")
	{
		d ..GetRoleListDetailJSON(roleID)
	}
	elseif (action = "addrole")
	{
		d ..AddRole(roleName,roleCode,roleDesc)
	}
	elseif (action = "modifyrole")
	{
		d ..ModifyRole(roleID,roleName,roleCode,roleDesc)
	}
	elseif (action = "getroleitem")
	{
		d ..GetRoleItemJSON(roleID)
	}
	elseif (action = "getroleitempage")
	{
		d ..GetRoleItemPageJSON(roleID,startRow,endRow)
	}
	elseif (action = "addroleitem")
	{
		d ..AddRoleItem(roleID,opID,privateDomainIDList,resourceItemIDList)
	}
	elseif (action = "defaultrolessgroup")
	{
		d ..DefaultRoleSSGroup(roleID,ssgroupIDS)
	}
	elseif (action = "deletessgrouprole")
	{
		d ..DeleteSSGroupRole(roleID,ssgroupID)
	}
	elseif (action = "defaultrole")
	{
		d ..DefaultRole(roleID)
	}
	
	Quit $$$OK
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).DefaultRole("2")
ClassMethod DefaultRole(ARoleID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLRole).DefaultRole(ARoleID)
	w ret
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).DeleteSSGroupRole("2","29")
ClassMethod DeleteSSGroupRole(ARoleID As %String, ASSGroupID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLRole).DeleteSSGroupRole(ARoleID,ASSGroupID)
	w ret
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).DefaultRoleSSGroup("2","29")
ClassMethod DefaultRoleSSGroup(ARoleID As %String, ASSGroupID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLRole).DefaultRoleSSGroup(ARoleID,ASSGroupID)
	w ret
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).AddRoleItem("","","","")
ClassMethod AddRoleItem(ARoleID As %String, AOpID As %String, APrivateDomainIDList As %String, AResourceItemIDList As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLRole).AddRoleItem(ARoleID,AOpID,APrivateDomainIDList,AResourceItemIDList)
	w ret
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).AddRole("HigherViewer","nv002","高级查询")
ClassMethod AddRole(ARoleName As %String, ARoleCode As %String, ARoleDesc As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLRole).AddRole(ARoleName,ARoleCode,ARoleDesc)
	w ret
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).ModifyRole("2","HigherViewer","nv002","高级查询")
ClassMethod ModifyRole(ARoleID As %String, ARoleName As %String, ARoleCode As %String, ARoleDesc As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.BLRole).ModifyRole(ARoleID,ARoleName,ARoleCode,ARoleDesc)
	w ret
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).GetRoleListJSON("1","20")
ClassMethod GetRoleListJSON(AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLRole:GetRole")
	s sc = result.Execute()
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RoleID"":"""_$g(result.Data("RoleID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RoleName"":"""_$g(result.Data("RoleName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RoleCode"":"""_$g(result.Data("RoleCode"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RoleDesc"":"""_$g(result.Data("RoleDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""DefaultRole"":"""_$g(result.Data("DefaultRole"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).GetRoleListDetailJSON("1")
ClassMethod GetRoleListDetailJSON(ARoleID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLRole:GetRoleDetail")
	s sc = result.Execute(ARoleID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""RoleID"":"""_$g(result.Data("RoleID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""SSGroupID"":"""_$g(result.Data("SSGroupID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""SSGroupName"":"""_$g(result.Data("SSGroupName"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).GetRoleItemJSON("1")
ClassMethod GetRoleItemJSON(ARoleID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLRole:GetRoleItem")
	s sc = result.Execute(ARoleID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationID"":"""_$g(result.Data("OperationID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationCode"":"""_$g(result.Data("OperationCode"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationDesc"":"""_$g(result.Data("OperationDesc"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainID"":"""_$g(result.Data("PrivateDomainID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainDesc"":"""_$g(result.Data("PrivateDomainDesc"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainLevel"":"""_$g(result.Data("PrivateDomainLevel"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ResourceItemID"":"""_$g(result.Data("ResourceItemID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemID"":"""_$g(result.Data("ItemID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemType"":"""_$g(result.Data("ItemType"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemTypeDesc"":"""_$g(result.Data("ItemTypeDesc"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRRBAC.web.eprajax.Role).GetRoleItemPageJSON("1",1,20)
ClassMethod GetRoleItemPageJSON(ARoleID As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLRole:GetRoleItem")
	s sc = result.Execute(ARoleID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationID"":"""_$g(result.Data("OperationID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationCode"":"""_$g(result.Data("OperationCode"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationDesc"":"""_$g(result.Data("OperationDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainID"":"""_$g(result.Data("PrivateDomainID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainDesc"":"""_$g(result.Data("PrivateDomainDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainLevel"":"""_$g(result.Data("PrivateDomainLevel"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ResourceItemID"":"""_$g(result.Data("ResourceItemID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemID"":"""_$g(result.Data("ItemID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemType"":"""_$g(result.Data("ItemType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemTypeDesc"":"""_$g(result.Data("ItemTypeDesc"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

}

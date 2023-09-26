/// 权限列表
Class DHCEPRFS.BL.BLRoleFunction Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc:功能列表数据
/// Creator:Candyxu
/// CreateDate: 2013-07-22
Query GetAllDic() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,FuncName:%String,FuncDesc:%String,ParentID:%String,Type:%String,Notes:%String")
{
	SELECT ID,FuncName,FuncDesc,ParentID,Type,Notes
	FROM DHCEPRFS_META.CTFunction
	ORDER BY ID
}

/// Desc: 角色列表
/// Creator: Candyxu
/// CreateDate:2013-07-22 
Query GetAllRole() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,RoleName:%String,RoleDesc:%String")
{
	SELECT ID,RoleName,RoleDesc
	FROM DHCEPRFS_META.UserRole
	ORDER BY ID
}

/// Desc: 增加角色
/// Creator：Candyxu
/// CreatDate: 2013-07-22：        
/// Input：roleName: 角色名称 , roleDesc :角色扫描     
/// Output：1：保存成功， -1:保存不成功       
/// Debug: d ##Class(DHCEPRFS.BL.BLRoleFunction).AddRole("","")
ClassMethod AddRole(roleName As %String, roleDesc As %String) As %String
{
    s obj = ##Class(DHCEPRFS.META.UserRole).%New()
    s obj.RoleDesc = roleDesc
    s obj.RoleName = roleName
    s sc = obj.%Save()
    d obj.%Close()
    if ($$$ISOK(sc))
    {
	    q "1"
	}else
	{
		q "-1"
	}
}

/// Desc: 角色权限列表
/// Creator:Candyxu
/// CreateDate: 2013-07-22
/// Input:ARoleID 角色ID
/// Output: RowID 表iD,RoleID 角色ID,FuncName 功能名称
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLRoleFunction","GetRoleFunction",3)
Query GetRoleFunction(ARoleID As %String) As %Query(ROWSPEC = "RowID:%String,RoleID:%String,FuncName:%String")
{
}

ClassMethod GetRoleFunctionExecute(ByRef qHandle As %Binary, ARoleID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s RowID = ""
 	for {
	    s RowID = $o(^DHCEPRFS.META.RoleFunctionI("IdxRoleID"," "_ARoleID,RowID)) 	
	 	q:(RowID = "")
	 	s obj = ##Class(DHCEPRFS.META.RoleFunction).%OpenId(RowID)
	  	s data = $lb(RowID,ARoleID,obj.FuncName)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1 	
	}
	Quit $$$OK
}

ClassMethod GetRoleFunctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleFunctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRoleFunctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleFunctionExecute ]
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

}

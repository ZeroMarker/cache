/// Desc:角色功能
/// Creator:Candy
Class DHCEPRFS.BL.BLQueryRoleFunction Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc:角色增加
/// Creator：Candy
/// Input:	ID ,RoleName 角色名称, RoleDesc 角色描述
/// Output：-1 不成功 ,1 成功
/// d ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddRole("","test6","test6","test2")
ClassMethod AddRole(ID As %String, RoleName As %String, RoleDesc As %String, ParentName As %String = "") As %String
{
	s result = -1
	if ((ID = "") || (ID = $c(0)))
	{
		s obj = ##Class(DHCEPRFS.META.QueryRole).%New()
		s obj.RoleName = RoleName
		s obj.RoleDesc = RoleDesc
		s:(ParentName = $c(0)) ParentName = ""
		if (ParentName = "")
		{
			s obj.ParentID = ParentName
		}
		else
		{
			s ParentID = ""
			S ParentName = $ZCVT(ParentName,"U")
			s ParentID = $o(^DHCEPRFS.META.QueryRoleI("IdxRoleName"," "_ParentName,""))
			q:(ParentID = "")
			s obj.ParentID = ParentID
		}
		
		
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = obj.%Id()
		d obj.%Close()
		q result
	}
	else
	{
		q result
	}
}

/// Desc:角色保存
/// Creator：Candy
/// Input:	ID ,RoleName 角色名称, RoleDesc 角色描述
/// Output：-1 不成功 ,1 成功
ClassMethod SaveRole(ID As %String, RoleName As %String, RoleDesc As %String, ParentName As %String = "") As %String
{
	s result = -1
	if ((ID = "") || (ID = $c(0)))
	{
		q result
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.QueryRole).%OpenId(ID)
		s obj.RoleName = RoleName
		s obj.RoleDesc = RoleDesc
		s:(ParentName = $c(0)) ParentName = ""
		if (ParentName '= "")
		{
			s ParentID = ""
			for i = 1:1:$L(ParentName,"^")
			{
				s parentNameOne = $p(ParentName,"^",i)
				S parentNameOne = $ZCVT(parentNameOne,"U")
				s rowID = $o(^DHCEPRFS.META.QueryRoleI("IdxRoleName"," "_parentNameOne,""))
				q:(rowID = "")
				if (ParentID '= "")
				{
					s ParentID = ParentID_"^"_rowID
				}
				else
				{
					s ParentID = rowID
				}
			}
			
		}
		else
		{
			s ParentID = ParentName
		}
		s obj.ParentID = ParentID
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = obj.%Id()
		d obj.%Close()
		q result
	}
}

/// Desc:获取所有角色
/// Creator:Candy
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryRoleFunction","GetAllRole")
Query GetAllRole() As %Query(ROWSPEC = "ID:%String,RoleName:%String,RoleDesc:%String,ParentName:%String")
{
}

ClassMethod GetAllRoleExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s rowID = ""
 	for {
	 	s rowID = $o(^DHCEPRFS.META.QueryRoleD(rowID))
	 	q:(rowID = "")
	 	s obj = ##class(DHCEPRFS.META.QueryRole).%OpenId(rowID)
	 	s RoleName = obj.RoleName
	 	s RoleDesc = obj.RoleDesc
	 	s ParentID = obj.ParentID
	 	if ((ParentID = "") || (ParentID = $c(0)))
	 	{
		 	s ParentName = ""
	 	}
	 	else
	 	{
		 	s ParentName = ""
		 	for i = 1:1:$L(ParentID,"^")
			{
				s PatID = $p(ParentID,"^",i)
				s objParent = ##class(DHCEPRFS.META.QueryRole).%OpenId(PatID)
				if (ParentName '= "")
				{
					s ParentName  = ParentName_"^"_objParent.RoleName
					d objParent.%Close()
				}
				else
				{
					s ParentName = objParent.RoleName
					d objParent.%Close()
				}
	 		}
		}
		d obj.%Close()
	   	s data = $lb(rowID,RoleName,RoleDesc,ParentName)
	  	s ^CacheTemp(repid,ind)=data
	   	s ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod GetAllRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllRoleExecute ]
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

/// Desc:获取所有父角色ID
/// Creator:LiuShuang
Query GetAllParentID() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,RoleName:%String")
{
	SELECT ID,RoleName
	FROM DHCEPRFS_META.QueryRole 
	WHERE ParentID is null
	ORDER BY ID
}

/// Desc:获取RoleID
/// Creator:LiuShuang
ClassMethod GetRoleID(AParentID As %String) As %String
{
	s rowID = ""
	S parentsRoleName = $ZCVT(AParentID,"U")
	s rowID = $o(^DHCEPRFS.META.QueryRoleI("IdxRoleName"," "_parentsRoleName,""))
	q rowID
}

/// Desc：获取页面功能字典
/// Creator:Candy
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryRoleFunction","GetAllDicFunction")
Query GetAllDicFunction() As %Query(ROWSPEC = "ID:%String,FuncName:%String,FuncDesc:%String,ParentID:%String,Notes:%String")
{
}

ClassMethod GetAllDicFunctionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s rowID = 0
	for {
	   s rowID = $o(^DHCEPRFS.META.QueryFunctionD(rowID))
	   q:(rowID = "")
	   s obj = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(rowID)
	   s FuncName = obj.FuncName
	   s FuncDesc = obj.FuncDesc
	   s ParentID = obj.ParentID
	   s isAvailable = obj.IsAvailable
	   s Notes = obj.Notes
	   d obj.%Close()
	   if (isAvailable '= "N")
	   {
	   	   s data = $lb(rowID,FuncName,FuncDesc,ParentID,Notes)
	   	   s ^CacheTemp(repid,ind)=data
	       s ind=ind+1 
	   } 	
	}
	Quit $$$OK
}

ClassMethod GetAllDicFunctionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllDicFunctionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllDicFunctionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllDicFunctionExecute ]
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

/// Desc:添加功能资源
/// Debug: d ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddFunction("Menu_Query_tab_Query","查询界面",1,"Group")
ClassMethod AddFunction(FuncName As %String, FuncDesc As %String, ParentID As %String) As %String
{
	s result = -1
	s obj = ##Class(DHCEPRFS.META.QueryFunction).%New()
	s obj.FuncName = FuncName
	s obj.FuncDesc = FuncDesc
	s obj.ParentID = ParentID
	s sc = obj.%Save()
    s:($$$ISOK(sc)) result = 1
    q result
}

/// Desc:添加角色权限
/// Debug: d ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddRoleFunc(1,"9^10^11")
ClassMethod AddRoleFunc(RoleID As %String, FuncIDs As %String) As %String
{
	s result = -1
	s rowID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID"," "_RoleID,""))
	if (rowID '= "")
	{
		s obj = ##Class(DHCEPRFS.META.QueryRoleFun).%OpenId(rowID)
		s obj.FuncID = FuncIDs
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = rowID
		d obj.%Close()
		q result	
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.QueryRoleFun).%New()
		s obj.RoleID = RoleID
		s obj.FuncID = FuncIDs
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = obj.%Id()
		d obj.%Close()
		q result
	}
}

/// Desc:添加角色权限顺序(Deprecated)
/// Debug: d ##Class(DHCEPRFS.BL.BLQueryRoleFunction).AddRoleFunc(1,"9^10^11")
ClassMethod AddRoleFuncSEQ(RoleID As %String, FuncIDSEQ As %String) As %String
{
	s result = -1
	s rowID = $o(^DHCEPRFS.META.QueryRoleFunSEQI("IdxRoleID"," "_RoleID,""))
	if (rowID '= "")
	{
		s obj = ##Class(DHCEPRFS.META.QueryRoleFunSEQ).%OpenId(rowID)
		s obj.AllFuncID = FuncIDSEQ
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = rowID
		d obj.%Close()
		q result	
	}
	else
	{
		s obj = ##Class(DHCEPRFS.META.QueryRoleFunSEQ).%New()
		s obj.RoleID = RoleID
		s obj.AllFuncID = FuncIDSEQ
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = obj.%Id()
		d obj.%Close()
		q result
	}
}

/// Desc：获取角色权限
/// Creator：Candy
Query GetAllRoleFunc() As %Query(ROWSPEC = "RoleID:%String,FuncIDs:%String")
{
}

ClassMethod GetAllRoleFuncExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	s rowID = 0
	for {
		s rowID = $o(^DHCEPRFS.META.QueryRoleFunD(rowID))
		q:(rowID = "")
		s obj = ##Class(DHCEPRFS.META.QueryRoleFun).%OpenId(rowID)
		s RoleID = obj.RoleID
		s FuncIDs = obj.FuncID
		d obj.%Close()
	    s ^CacheTemp(repid,ind)=$lb(RoleID,FuncIDs)
	    s ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetAllRoleFuncClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllRoleFuncExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllRoleFuncFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllRoleFuncExecute ]
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

/// Desc:通过用户的userID，得到此用户的权限
/// Desc:对此方法做了修改，以前返回的权限会有重复的情况，现在做了排重处理，而且对权限的排序做了处理。
/// Creator：liushuang  2017.2.22
/// Debug: w ##class(DHCEPRFS.BL.BLQueryRoleFunction).GetUserFuncByUserID(132)
ClassMethod GetUserFuncByUserID(AUserID As %String) As %String
{
 	q:(AUserID = "") ""
 	
 	s userRoleRowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_$zcvt(AUserID,"U"),""))
 	s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleRowID)
 	s roleID = userRoleObj.RoleID
 	q:(roleID = "") ""
 	
 
 	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQueryRoleFunction:GetAllRoleItems")
	s sc = result.Execute(roleID)
	
	s ret = "" 		
	While (result.Next())
	{
		s functionID =$g(result.Data("RoleID"))
		s obj = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(functionID)

		s funcName = obj.FuncName	
		if (ret = "")
		{
			s ret = funcName	
		}
		else
		{
			s ret = ret_"^"_funcName	
		}
	}
	q ret
 	
 	/*
 	s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 	s ParentID = queryRoleObj.ParentID
 	if (ParentID '= "")&&(ParentID '= $c(0))
 	{
	 	s roleID = roleID_"^"_ParentID
 	}
 	s ret = ""
 	for index=1:1:$l(roleID,"^")
	{
		s roleIDOne = $p(roleID,"^",index)
 		s roleFunRowID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID", " "_roleIDOne,""))
 		continue:(roleFunRowID = "")
 		s roleFunObj = ##class(DHCEPRFS.META.QueryRoleFun).%OpenId(roleFunRowID)
 		s funcIDs = roleFunObj.FuncID
 		s:(funcIDs = $c(0)) funcIDs = ""
 		continue:(funcIDs = "")
 		for i=1:1:$l(funcIDs,"^")
 		{
	 		s rowID = $p(funcIDs,"^",i)
	 		s:(rowID = $c(0)) rowID = ""
	 		continue:(rowID = "")
			s obj = ##Class(DHCEPRFS.META.QueryFunction).%OpenId(rowID) 
			
			s funcName = obj.FuncName	
			if (ret = "")
			{
				s ret = funcName	
			}
			else
			{
				s ret = ret_"^"_funcName	
			}
		}
	}
	q ret
	*/
}

/// 获取某个用户是否含有某个基角色
ClassMethod IsUserHasBaseRole(AUserID As %String, ARoleName) As %String
{
 	q:(AUserID = "") "0"
 	
 	s userRoleRowID = $o(^DHCEPRFS.META.QueryUserRoleI("IdxUserID"," "_$zcvt(AUserID,"U"),""))
 	s userRoleObj = ##class(DHCEPRFS.META.QueryUserRole).%OpenId(userRoleRowID)
 	s roleID = userRoleObj.RoleID
 	q:(roleID = "") "0"
 	s queryRoleObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
 	s ParentID = queryRoleObj.ParentID
 	if (ParentID '= "")&&(ParentID '= $c(0))
 	{
	 	s roleID = roleID_"^"_ParentID
 	}
 	d queryRoleObj.%Close()
 	s ret = "0"
 	for index=1:1:$l(roleID,"^")
	{
		s roleIDOne = $p(roleID,"^",index)
		s roleOneObj = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleIDOne)
		if (roleOneObj.RoleName = ARoleName)
		{
			s ret = "1"
			q 	
		}
	}
	q ret
}

/// Desc：通过角色的roleID得到此角色的权限，同事对这些权限加上了顺序的要素。
/// Creator：LiuShuang  2017.2.22
/// do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQueryRoleFunction","GetAllRoleItems","25")
Query GetAllRoleItems(ARoleID As %String = "") As %Query(ROWSPEC = "RoleID:%String,FuncDesc:%String,ParentID:%String,ParentRole:%String")
{
}

ClassMethod GetAllRoleItemsExecute(ByRef qHandle As %Binary, ARoleID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s roleIDS = ARoleID
 	s objRole = ##class(DHCEPRFS.META.QueryRole).%OpenId(ARoleID)
 	s parentRoleID = objRole.ParentID
 	if ((parentRoleID '= "0") && (parentRoleID '= "") && (parentRoleID '= $c(0)))
 	{
	 	s roleIDS = roleIDS_"^"_parentRoleID
	}
	
	for index=1:1:$l(roleIDS,"^")
	{
		s roleID = $p(roleIDS,"^",index)
		s functionID = ""
		for {
			s functionID = $o(^DHCEPRFS.META.QueryRoleFunI("IdxRoleID"," "_roleID,functionID))
			q:(functionID = "")
			s objRoleFun = ##class(DHCEPRFS.META.QueryRoleFun).%OpenId(functionID)
			s FuncID = objRoleFun.FuncID

			q:((FuncID = "") || (FuncID = $c(0)))
			for j = 1:1:$l(FuncID,"^")
			{
				s FuncRoleID = $p(FuncID,"^",j)
				s objFunction = ##class(DHCEPRFS.META.QueryFunction).%OpenId(FuncRoleID)
				s isAvailable = objFunction.IsAvailable
				if (isAvailable = "N")
				{
					continue
				}
				
				s functionDesc = objFunction.FuncDesc
				s functionParentID = objFunction.ParentID
				s objRoleIn = ##class(DHCEPRFS.META.QueryRole).%OpenId(roleID)
				if (roleID = ARoleID)
				{
					s roleName = ""	
				}
				else
				{
					s roleName = objRoleIn.RoleName
				}
				if (functionParentID '= "0")
				{
					s data = $lb(FuncRoleID,functionDesc,functionParentID,roleName)
					s ^CacheTemp(repid,ind)=data
	   				s ind=ind+1	
				}
		  	}
	   	}	
	}
	Quit $$$OK
}

ClassMethod GetAllRoleItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllRoleItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAllRoleItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllRoleItemsExecute ]
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

Class DHCEPRRBAC.BL.BLResourceRoleItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加隐私域、角色、操作关联关系

ClassMethod CreateResourceRoleItem(aResourceRoleItem As DHCEPRRBAC.Entity.EResourceRoleItem) As %String
{
		
	s obj = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%New()
	s obj.OperationID = aResourceRoleItem.OperationID
	s obj.PrivateDomainID = aResourceRoleItem.PrivateDomainID
	s obj.ResourceItemID = aResourceRoleItem.ResourceItemID
	s obj.RoleID = aResourceRoleItem.RoleID
	s obj.Sequence = aResourceRoleItem.Sequence
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

//更新隐私域、角色、操作关联关系

ClassMethod UpdateResourceRoleItem(aResourceRoleItem As DHCEPRRBAC.Entity.EResourceRoleItem) As %String
{
		
	s obj = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%OpenId(aResourceRoleItem.ID)
	s obj.OperationID = aResourceRoleItem.OperationID
	s obj.PrivateDomainID = aResourceRoleItem.PrivateDomainID
	s obj.ResourceItemID = aResourceRoleItem.ResourceItemID
	s obj.RoleID = aResourceRoleItem.RoleID
	s obj.Sequence = aResourceRoleItem.Sequence
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

//删除隐私域、角色、操作关联关系

ClassMethod DeleteResourceRoleItem(aResourceRoleItemID As %String) As %String
{
	
	q:(aResourceRoleItemID ="") "-1"	
	s obj = ##Class(DHCEPRRBAC.INST.ResourceRoleItem).%OpenId(aResourceRoleItemID)
	q:(obj="") "-1"
	s sc = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%DeleteId(aResourceRoleItemID)	
	if ($$$ISOK(sc))
	{
		q aResourceRoleItemID
	}
	else
	{
		q "-1"
	}
}

//检查隐私域、角色、操作关联关系

ClassMethod CheckResourceRoleItem(RoleID As %String, OperationID As %String) As %String
{
	
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdexRoleOperation"," "_RoleID," "_OperationID,rowID))
	q rowID
}

/// ///  获取所有隐私域、角色、操作关联关系
/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLResourceRoleItem","GetResourceRoleItem")
Query GetResourceRoleItem() As %Query(ROWSPEC = "ID:%String,RoleName:%String,RoleID:%String,OpName:%String,OperationID:%String,RPDName:%String,PrivateDomainID:%String")
{
}

ClassMethod GetResourceRoleItemExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.INST.ResourceRItemD(rowID))
		q:(rowID = "")

		s obj = ##class(DHCEPRRBAC.INST.ResourceRoleItem).%OpenId(rowID)
		q:(obj = "")
		
		s OperationID=obj.OperationID
		s objOperation = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(OperationID)
		q:(objOperation = "")
		s OpName=objOperation.OpName
		
		s RoleID=obj.RoleID
		s objRole = ##class(DHCEPRRBAC.META.RoleDefinition).%OpenId(RoleID)
		q:(objRole = "")
		s RoleName=objRole.RoleName
		
		s PrivateDomainID=obj.PrivateDomainID
		s objPrivateDomain = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(PrivateDomainID)
		q:(objPrivateDomain = "")
		s RPDName=objPrivateDomain.RPDName		
		
		s ^CacheTemp(repid,ind) = $lb(rowID,RoleName,RoleID,OpName,OperationID,RPDName,PrivateDomainID)
	    s ind=ind+1		
   }
   Quit $$$OK
}

ClassMethod GetResourceRoleItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceRoleItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResourceRoleItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceRoleItemExecute ]
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

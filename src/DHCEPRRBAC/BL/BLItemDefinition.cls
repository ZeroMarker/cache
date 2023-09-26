Class DHCEPRRBAC.BL.BLItemDefinition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加隐私域项目

ClassMethod CreateItemDefinition(aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String
{
	
	s obj = ##class(DHCEPRRBAC.META.ItemDefinition).%New()
	s obj.ItemActive = aEItemDefinitionn.ItemActive
	s obj.ItemCode = aEItemDefinitionn.ItemCode
	s obj.ItemDesc = aEItemDefinitionn.ItemDesc
	s obj.ItemName = aEItemDefinitionn.ItemName
	s obj.ItemType = aEItemDefinitionn.ItemType
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

//更新隐私域项目

ClassMethod UpdateItemDefinition(aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String
{
	s obj = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(aEItemDefinitionn.ID)
	s obj.ItemActive = aEItemDefinitionn.ItemActive
	s obj.ItemCode = aEItemDefinitionn.ItemCode
	s obj.ItemDesc = aEItemDefinitionn.ItemDesc
	s obj.ItemName = aEItemDefinitionn.ItemName
	s obj.ItemType = aEItemDefinitionn.ItemType
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q aEItemDefinitionn.ID
	}
	else
	{		
		q "-1"
	}
}

//删除隐私域项目

ClassMethod DeleteItemDefinition(APrivateDomainID As %String, aItemDefinitionID As %String) As %String
{
	
	TStart
	q:(aItemDefinitionID ="") "-1"	
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.INST.ResourceItemI("IdxPrivateDomainItemID"," "_APrivateDomainID," "_aItemDefinitionID,rowID))
	q:(rowID = "")
	s objResourceItem = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
	q:(objResourceItem="") "-1"
	s scitem = ##class(DHCEPRRBAC.INST.ResourceItem).%DeleteId(rowID)
    if ($$$ISOK(scitem))
	  {
		  TCommit
		  q aItemDefinitionID
	  }
	else
	  {
		  TRollback
		  q "-1"
	  }
}

//检查隐私项CODE是否添加

ClassMethod CheckItemDefinitionCode(ItemType As %String, aItemCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.META.ItemDFI("IdxMain"," "_ItemType," "_aItemCode,rowID))
	q rowID
}

/// 通过项目ID获取隐私域ID
ClassMethod GetPrivateDomainIDByItemID(aItemID As %String) As %String
{
	
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.INST.ResourceItemI("IdxItem"," Y"," "_aItemID,rowID))
	q:(rowID = "") ""
	s objResourceItem = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
	q:(objResourceItem="") ""
	q objResourceItem.PrivateDomainID
}

/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLItemDefinition","GetItemDefinition")
Query GetItemDefinition() As %Query(ROWSPEC = "ID:%String,ItemName:%String,ItemCode:%String,ItemDesc:%String,ItemType:%String,ItemActive:%String")
{
}

ClassMethod GetItemDefinitionExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s rowID = ""
	for	{
		s rowID = $o(^DHCEPRRBAC.META.ItemDFD(rowID))
		q:(rowID = "")

		s obj = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(rowID)
		s ItemActive = obj.ItemActive		
		s ItemName = obj.ItemName
		s ItemCode = obj.ItemCode
		s ItemDesc = obj.ItemDesc
		s ItemType = obj.ItemType	
		
		s ^CacheTemp(repid,ind) = $lb(rowID,ItemName,ItemCode,ItemDesc,ItemType,ItemActive)
	    s ind=ind+1		
   }
   Quit $$$OK
}

ClassMethod GetItemDefinitionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemDefinitionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemDefinitionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemDefinitionExecute ]
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

Class DHCEPRRBAC.BL.BLResourceItem Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加隐私域项目关联

ClassMethod CreateDomainItemRelation(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition, aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String
{
	
	    s objResourceItem = ##class(DHCEPRRBAC.INST.ResourceItem).%New()
	    s objResourceItem.IsActive = aEItemDefinitionn.ItemActive
	    s objResourceItem.ItemID = aEItemDefinitionn.ID
	    s objResourceItem.PrivateDomainID = aEPrivateDomain.ID	   
	    s scResourceItem = objResourceItem.%Save()
	    if ($$$ISOK(scResourceItem))
	    {		   
		    q objResourceItem.%Id()
	    }
	    else
	    {		   
		    q "-1"
	    }
}

//更新隐私域项目关联

ClassMethod UpdateDomainItemRelation(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition, aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String
{
	
	    s rowID = ""
		s rowID = $o(^DHCEPRRBAC.INST.ResourceItemI("IdxItem"," Y"," "_aEItemDefinitionn.ID,rowID))
		q:(rowID = "")
		s objResourceItem = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
	    s objResourceItem.IsActive = aEItemDefinitionn.ItemActive
	    s objResourceItem.ItemID = aEItemDefinitionn.ID
	    s objResourceItem.PrivateDomainID = aEPrivateDomain.ID	     
	    s scResourceItem = objResourceItem.%Save()
	    if ($$$ISOK(scResourceItem))
	    {		   
		    q rowID
	    }
	    else
	    {		   
		    q "-1"
	    }
}

//检查隐私域项目关联是否添加

ClassMethod CheckResourceItem(PrivateDomainID As %String, ItemID As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.INST.ResourceItemI("IdxPrivateDomainItemID"," "_PrivateDomainID," "_ItemID,rowID))
	q rowID
}

}

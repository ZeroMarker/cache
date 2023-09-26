Class DHCEPRRBAC.BL.BLElementDefinition Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//添加项目术语

ClassMethod CreateElementDefinition(aPrivateDomainID As %String, aElementID As %String, aElementDefinition As DHCEPRRBAC.Entity.EElementDefinition) As %String
{
	TStart
	s aCheckElementID=..CheckElementDefinitionCode(aElementDefinition.ElementCode)
	if (aCheckElementID'="")
	{
		s objResourceElement = ##class(DHCEPRRBAC.INST.ResourceElement).%New()
	    s objResourceElement.ItemID = aElementID
	    s objResourceElement.ElementID = aCheckElementID
	    s objResourceElement.PrivateDomainID = aPrivateDomainID  	  
	    s scResourceElement = objResourceElement.%Save()
	    if ($$$ISOK(scResourceElement))
	    {
		    TCommit
		    q objResourceElement.%Id()
	    }
	    else
	    {
		    TRollback
		    q "-1"
	    }
	}
	else
	{
	s obj = ##class(DHCEPRRBAC.META.ElementDefinition).%New()
	s obj.ElementActive = aElementDefinition.ElementActive
	s obj.ElementCode = aElementDefinition.ElementCode
	s obj.ElementCodeType = aElementDefinition.ElementCodeType
	s obj.ElementDesc = aElementDefinition.ElementDesc
	s obj.ElementName = aElementDefinition.ElementName
	s obj.ElementType = aElementDefinition.ElementType
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s objResourceElement = ##class(DHCEPRRBAC.INST.ResourceElement).%New()
	    s objResourceElement.ItemID = aElementID
	    s objResourceElement.ElementID = obj.%Id()
	    s objResourceElement.PrivateDomainID = aPrivateDomainID  	  
	    s scResourceElement = objResourceElement.%Save()
	    if ($$$ISOK(scResourceElement))
	    {
		    TCommit
		    q objResourceElement.%Id()
	    }
	    else
	    {
		    TRollback
		    q "-1"
	    }
	}
	else
	{
		TRollback
		q "-1"
	}
   }
}

/// 删除术语项
ClassMethod DeleteElementDefinition(APrivateDomainID As %String, aItemID As %String) As %String
{
	
	s rowID = ""
	for	{
		   TStart		  	
		   s rowID = $o(^DHCEPRRBAC.INST.RSRCElementI("IdexPrivateDomainItemElementID"," "_APrivateDomainID," "_aItemID,rowID))
		   q:(rowID = "")		  	
	       s obj = ##Class(DHCEPRRBAC.INST.ResourceElement).%OpenId(rowID)	      
	       q:(obj="")
	       
	       s sc = ##class(DHCEPRRBAC.INST.ResourceElement).%DeleteId(rowID)	
	       if ($$$ISOK(sc))
	       {
		      TCommit		        
	       }
	       else
	       {
		      TRollback  
	       }
	       
	    }
	 q 1
}

//检查术语项是否添加

ClassMethod CheckElementDefinitionCode(aElementCode As %String) As %String
{
	s rowID = ""
    s rowID = $o(^DHCEPRRBAC.META.ElementDFI("IdxElementCode"," "_aElementCode,rowID))
	q rowID
}

/// DoTest
ClassMethod DoTest() As %String
{
	
	s obj = ##class(DHCEPRRBAC.META.ElementDefinition).%New()
	q:(obj = "") 1
	s obj.ElementActive ="Y"
	s obj.ElementCode = "HDSD00.13.002"
	s obj.ElementCodeType = "V"
	s obj.ElementDesc = "患者住院期间，所住病房对应的编号"
	s obj.ElementName = "HDSD00.13.002 病房号"
	s obj.ElementType = "GLOSSARY"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		//
		q 1
	}
	else
	{
		q -1
	}
}

}

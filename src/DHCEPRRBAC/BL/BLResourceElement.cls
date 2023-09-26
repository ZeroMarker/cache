Class DHCEPRRBAC.BL.BLResourceElement Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: w ##class(DHCEPRRBAC.BL.BLResourceElement).GetElementLevel("HDSD00.11.110")
ClassMethod GetElementLevel(AElementCode As %String, AElementCodeType As %String) As %String
{
	s elementLevel = ""
	
	s elementID = ""
	s elementID = $o(^DHCEPRRBAC.META.ElementDFI("IdxMain"," GLOSSARY"," "_AElementCodeType," "_AElementCode, ""))
	q:(elementID = "") ""
	
	s resourceElementID = ""
	for {
		s resourceElementID = $o(^DHCEPRRBAC.INST.RSRCElementI("IdxElement", " "_elementID, resourceElementID))
		q:(resourceElementID = "")
		
		s resourceElement = ##class(DHCEPRRBAC.INST.ResourceElement).%OpenId(resourceElementID)
		s pdID = resourceElement.PrivateDomainID
		s pdObj = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(pdID)
		if (elementLevel = "")
		{
			s elementLevel = pdObj.RPDLevel
		}
		else
		{
			s elementLevel = elementLevel_"^"_pdObj.RPDLevel
		}
	}
	q elementLevel
}

}

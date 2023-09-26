Class EPRservice.BOTplPrivacy Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TplPrivacyService";

/// w ##Class(EPRservice.BOTplPrivacy).GetPrivacyItem("5","1","S001^S002^S003"
ClassMethod GetPrivacyItem(APrivacyLevel, ATemplateID, AItemCodeList) As %String [ WebMethod ]
{
	q AItemCodeList
	s retList = ""
	
	s hasGlossary = $o(^DHCEPRM.GlossaryItemI("IdxLink", ATemplateID,""))
	q:(hasGllossary="") ""
	
	s itemCount = $L(AItemCodeList,"^")
	for i = 1:1:itemCount
	{
		s itemCode = $P(AItemCodeList,"^",i)
		
		s glossaryID = ..GetGlossayID(ATemplateID,itemCode)
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		s internalID = objGlossary.InternalID
		continue:(internalID="")
		
		s priLev = ##class(DHCEPRRBAC.BL.BLResourceElement).GetElementLevel(internalID,"V")
		s:(priLev = $c(0)) priLev = ""
		
		continue:(priLev="")
		
		if (retList = "")
		{
			s retList = itemCode
		}
		else
		{
			s retList = retList_"^"_itemCode
		}	
	}
	
	q retList
}

ClassMethod GetGlossayID(ATemplateID As %String, AItemCode As %String) As %String
{
	s glossaryID = ""
	
	s AValueType = ""
	for {
		s AValueType = $o(^DHCEPRM.GlossaryItemI("IdxLink", ATemplateID, " "_AItemCode, " "_AValueType))
		q:(AValueType="")
	
		s glossaryID = $o(^DHCEPRM.GlossaryItemI("IdxLink", ATemplateID, " "_AItemCode, " "_AValueType, glossaryID))
		q:(glossaryID'="")
	}
	
	q glossaryID
}

}

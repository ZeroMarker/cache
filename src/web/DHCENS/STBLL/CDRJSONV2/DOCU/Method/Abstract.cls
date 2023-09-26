Class web.DHCENS.STBLL.CDRJSONV2.DOCU.Method.Abstract Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Method.Abstract).getAbstract()
ClassMethod getAbstract(id As %String) As %GlobalCharacterStream
{
	set main=##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.Request).%New()
	set header=##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.Header).%New()
	set body=##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.Body).%New()
	set DocuRt=##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.RegisterDocumentRt).%New()
	try{
		set data=^Busi.ENS.EnsHOSDocumentD(id)
		set DocuRt=##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.RegisterDocumentRt).%New()
		set DocumentID=				$lg(data,2)
		set relrowid=$o(^Busi.ENS.EnsRelOrderDocumentI("RelODDocumentIDIndex",DocumentID,""))
		set reldata=^Busi.ENS.EnsRelOrderDocumentD(relrowid)
		set DocuRt.DocumentFormat="xml"
		set DocuRt.DocumentID=				DocumentID
		set DocuRt.DocumentType=			$lg(data,9)
		set DocuRt.OEORIOrderItemID=		$lg(data,9)
		set DocuRt.OrganizationCode=		""
		set DocuRt.PAADMVisitNumber=		$lg(data,6)
		set DocuRt.PATPatientID=			$lg(data,5)
		set DocuRt.RISRExamID=				$lg(reldata,7)
		set DocuRt.SpecimenID=				$lg(reldata,8)
		set DocuRt.UpdateUserCode=			$lg(data,14)
		d body.hosDocuments.Insert(DocuRt) 
	}catch{
		set DocuRt=##class(web.DHCENS.STBLL.CDRJSONV2.DOCU.Model.RegisterDocumentRt).%New()
		d body.hosDocuments.Insert(DocuRt) 
	}
	set main.header=header
	set main.body=body
	d main.XMLExportToStream(.stream)
	quit stream
}

}

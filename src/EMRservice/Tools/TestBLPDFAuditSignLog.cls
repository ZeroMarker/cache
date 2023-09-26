Class EMRservice.Tools.TestBLPDFAuditSignLog Extends %RegisteredObject
{

/// d ##Class(EMRservice.BL.BLPDFAuditSignLog).Test()
ClassMethod Test()
{
	s obj = ##Class(EMRinstance.PDF.AuditSignLog).%OpenId(3)
	
	s ret = ##Class(EMRservice.BL.BLPDFAuditSignLog).PushToSignPDF(obj.PDFBase64,obj.KeyWord,obj.InstanceID,obj.EpisodeID,obj.UsrID)
	w ret
}

/// d ##Class(EMRservice.BL.BLPDFAuditSignLog).TestLoad("8595812||2")
ClassMethod TestLoad(instanceID)
{
	s s1=##Class(%GlobalBinaryStream).%New()
	s o1=##Class(%GlobalBinaryStream).%New()
	s i1=##class(%ArrayOfDataTypes).%New()
	d i1.SetAt(instanceID,"1")
	w ##Class(EMRservice.BL.BLPDFAuditSignLog).LoadDocument(.o1,i1,.s1)
}

}

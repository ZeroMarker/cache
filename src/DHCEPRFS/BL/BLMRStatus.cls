Class DHCEPRFS.BL.BLMRStatus Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug:	w ##Class(DHCEPRFS.BL.BLMRStatus).GetDesc("CONFIRMED")
/// 			w ##Class(DHCEPRFS.BL.BLMRStatus).GetDesc("SCANNED")
ClassMethod GetDesc(AMRStatusCode As %String) As %String
{
	q:(AMRStatusCode="") ""
	s id = $O(^DHCEPRFS.META.MRStatusI("IdxMain"," "_AMRStatusCode,""))
	q:(id="") ""
	s obj = ##Class(DHCEPRFS.META.MRStatus).%OpenId(id)
	q obj.StatusName
}

}

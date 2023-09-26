Class EPRservice.BLAdmType Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

ClassMethod GetAdmType(APatientID As %String, AEpisodeID As %String) As %String
{
  	s AdmType = ""
	for {
	    s AdmType = $o(^PAPERdr(APatientID,"ADM",AdmType))
	    q:(AdmType = "")
	    s PAAdm = ""
	    for {
		     s PAAdm = $o(^PAPERdr(APatientID,"ADM",AdmType,PAAdm))
		     q:(PAAdm = "")
		     q:(PAAdm = AEpisodeID) 
	    }
	    q:(PAAdm = AEpisodeID)
	}
	if (AdmType = "") s AdmType = "I"
	q AdmType
}

}

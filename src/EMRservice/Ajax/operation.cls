Class EMRservice.Ajax.operation Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s id = $Get(%request.Data("ID",1),"")
	s patientId = $Get(%request.Data("PatientID",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s data = $Get(%request.Data("Data",1),"")
	d ..SetData(id,patientId,episodeId,data)
	Quit $$$OK
}

/// Debug: d ##Class(EMRservice.Ajax.operation).SetData("",48,76,"")
ClassMethod SetData(AID As %String, APatientID As %String, AEpisodeID As %String, AData As %String)
{
	s data = ##Class(%GlobalBinaryStream).%New()
	d data.Write(AData)
	w ##Class(EMRservice.BL.Event.BLOperation).SetData(AID,APatientID,AEpisodeID,data)
}

}

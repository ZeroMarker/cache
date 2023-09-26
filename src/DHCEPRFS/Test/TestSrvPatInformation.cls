Class DHCEPRFS.Test.TestSrvPatInformation Extends %RegisteredObject
{

/// d ##Class(DHCEPRFS.Test.TestSrvPatInformation).GetPatientInfo()
ClassMethod GetPatientInfo()
{
	s para = ##Class(DHCEPRFS.Entity.EPatientInfoQueryPara).%New()
	s para.PatientID = "0000000016"
	
	Set rset = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLPatientInfo:GetPatientInfo")
	Set columns = rset.GetColumnCount()

	Set sc = rset.Execute(para)

	// Now fetch the results
	While (rset.Next()) {
	Write "------------------------",!
	For col = 1:1:columns {
	Write rset.GetColumnName(col),": "
	Write rset.GetData(col),!
	}
	Write "------------------------"
	}
	Do rset.Close()
}

}

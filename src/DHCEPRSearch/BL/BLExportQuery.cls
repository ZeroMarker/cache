Class DHCEPRSearch.BL.BLExportQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Add(AUserID As %String, AResultColumnsName As %String, AResultXMLString As %GlobalCharacterStream, AMedRecordNoS As %String, AConditions As %GlobalCharacterStream, ADisLocID As %String, AStartDisDate As %String, AEndDisDate As %String, AResultColumns As %String, AMREpisodeIDS As %String) As %String
{
	s ^AAA("debug","search","input") = AUserID_"^"_AResultColumnsName_"^"_AMedRecordNoS_"^"_ADisLocID_"^"_AStartDisDate_"^"_AEndDisDate_"^"_AResultColumns
	s ^AAA("debug","search","AConditions") = AConditions
	s ^AAA("debug","search","AResultXMLString") = AResultXMLString
	
	s obj = ##Class(DHCEPRSearch.INST.ExportQuery).%New()
	s obj.UserID = AUserID
	s obj.MedRecordNoS = AMedRecordNoS
	s obj.Conditions = AConditions
	s obj.DisLocID = ADisLocID
	s obj.MREpisodeIDS = AMREpisodeIDS
	if ((AStartDisDate '= "") && (AStartDisDate '= $c(0)))
	{
		s obj.StartDisDate = $zdh(AStartDisDate,3)
	}
	if ((AEndDisDate '= "") && (AEndDisDate '= $c(0)))
	{
		s obj.EndDisDate = $zdh(AEndDisDate,3)
	}
	s obj.ExportDate = $p($h,",",1)
	s obj.ExportTime = $p($h,",",2)
	s obj.ResultColumns = AResultColumns
	s obj.ResultColumnsName = AResultColumnsName
	s obj.ResultXMLStream = AResultXMLString
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// debug: w ##class(DHCEPRSearch.BL.BLExportQuery).Test()
ClassMethod Test() As %String
{
	b "s"
	
	s obj = ##Class(DHCEPRSearch.INST.ExportQuery).%New()
	//s obj.UserID = AUserID
	//s obj.MedRecordNoS = AMedRecordNoS
	//s obj.Conditions = AConditions
	//s obj.DisLocID = ADisLocID
	//s obj.StartDisDate = $zdt(AStartDisDate,3)
	//s obj.EndDisDate = $zdt(AEndDisDate,3)
	s obj.ExportDate = $p($h,",",1)
	s obj.ExportTime = $p($h,",",2)
	//s obj.ResultColumns = AResultColumns
	//s obj.ResultColumnsName = AResultColumnsName
	//s obj.ResultXMLStream = AResultXMLString
	s obj.UserID = $p(^AAA("debug","search","input"),"^",1)
	s obj.MedRecordNoS = $p(^AAA("debug","search","input"),"^",3)
	s obj.Conditions = ^AAA("debug","search","AConditions")
	s obj.DisLocID = $p(^AAA("debug","search","input"),"^",4)
	s AStartDisDate = $p(^AAA("debug","search","input"),"^",5)
	if ((AStartDisDate '= "") && (AStartDisDate '= $c(0)))
	{
		s obj.StartDisDate = $zdh(AStartDisDate,3)
	}
	s AEndDisDate = $p(^AAA("debug","search","input"),"^",6)
	if ((AEndDisDate '= "") && (AEndDisDate '= $c(0)))
	{
		s obj.AEndDisDate = $zdh(AEndDisDate,3)
	}
	s obj.ResultColumns = $p(^AAA("debug","search","input"),"^",7)
	s obj.ResultColumnsName = $p(^AAA("debug","search","input"),"^",2)
	s obj.ResultXMLStream = ^AAA("debug","search","AResultXMLString")
	
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

}

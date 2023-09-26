Class CHSSWeb.Report.PersonHealthRecordReportXML Extends %CSP.Page [ ClassType = "", Not ProcedureBlock ]
{

Parameter CONTENTTYPE = "text/xml";

///  Creator：wangbo
///  CreatDate：2009-12-29
///  Description: 根据id生成xml文件
///  Table：
///  Input：id-任意值
///  Output：
///  Return：错误返回错误信息，正确返回正确信息
///  Others：如果传的参数为空，则报错
ClassMethod OnPage() As %Status
{
	Write "<?xml version=""1.0"" ?>",!

	Set id=$G(%request.Data("Id",1))
	If (id=""){
	    Set status=id
	    Do $system.OBJ.DisplayError(status)
    	Quit status
		}
	Set reportData = ..GenPersonReportData(id,0,5,"","","")
	Set status = reportData.XMLExport()
    If ($system.Status.IsError(status)) {
    	Do $system.OBJ.DisplayError(status)
    	Quit status
    }
         
    Quit $system.Status.OK()
}

ClassMethod GenPersonReportData(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, searchField As %String, searchValue As %String) As CHSSWeb.Report.PersonHealthRecordReportData
{
		n (communityCode, start, limit, sort)
		
		Set communityCode=$G(communityCode)
		Set reportReportData = ##class(CHSSWeb.Report.PersonHealthRecordReportData).%New()
		s communityCode=" "_communityCode
		Set start=$G(start)
		Set limit=$G(limit)
		Set sort=$G(sort)
		Set count=0
		Set resultString = ""
		Set end = start+limit
		Set json = ##class(Code.JsonObj).%New()
		set PersonRowId = 0
		
		For  Set PersonRowId=$O(^CHSS.PersonHealthRecordMainI("CommunityCodeIndex",communityCode,PersonRowId)) q:PersonRowId=""  d
		.s tempPerson=##class(CHSS.PersonHealthRecordMain).%OpenId(PersonRowId)
		.s reportData = ##class(CHSSWeb.Report.PersonHealthRecordReportObj).%New()
		.;初始化
		.s reportData.PersonRowId = " "
		.s reportData.PersonCode = " "
		.s reportData.PersonName = " "
		.s reportData.SexName = " "
		.s reportData.Birth = " "
		.s reportData.RelationHourseHoldName = " "
		.s reportData.FamilyAddress = " "
		.s reportData.LinkManPhone = " "
		.;读取数据
		.s reportData.PersonRowId = PersonRowId
		.s reportData.PersonCode = tempPerson.PersonCode
		.s reportData.PersonName = tempPerson.PersonName
		.
		.s SexDR = ""
		.set SexName = ""
		.i tempPerson.SexDR '= "" d
		..set SexDR = tempPerson.SexDR.%Id()
		..set reportData.SexName = tempPerson.SexDR.CTSEXDesc
		.set Birth = tempPerson.Birth
		.i Birth '= "" d
		..s reportData.Birth = $zd(Birth,3)
		.
		.s RelationHourseHoldDR = tempPerson.RelationHourseHoldDR
		.
		.set RelationHourseHoldDR = ""
		.set RelationHourseHoldName = ""
		.i tempPerson.RelationHourseHoldDR '= "" d
		..set RelationHourseHoldDR = tempPerson.RelationHourseHoldDR.%Id()
		..set reportData.RelationHourseHoldName = tempPerson.RelationHourseHoldDR.Description
		.e  d
		..s reportData.RelationHourseHoldName = " "
		.s FamilyRowId = ""
		.s HouseHoldName = ""
		.i tempPerson.FamilyRowId '= "" d
		..s FamilyRowId = tempPerson.FamilyRowId.%Id()
		..s HouseHoldName = tempPerson.FamilyRowId.HouseHoldName
		.
	    .s FamilyAddress = ""
	    .i FamilyRowId '= "" d
	    ..s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
	    ..i tempFamily.ProvinceDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.ProvinceDR.Description
	    ..i tempFamily.CityDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.CityDR.Description
	    ..i tempFamily.SectionDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.SectionDR.Description
	    ..i tempFamily.StreetDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.StreetDR.Description
		..i tempFamily.VillageDR '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageDR.Description
	    ..e  d
	    ...s FamilyAddress = FamilyAddress_tempFamily.VillageName
	    ..i tempFamily.DoorPlate '= "" d
	    ...s FamilyAddress = FamilyAddress_tempFamily.DoorPlate
	    .i FamilyAddress '= "" d
	    ..s reportData.FamilyAddress = FamilyAddress
	    .i tempPerson.LinkManPhone '= "" d
		..s reportData.LinkManPhone = tempPerson.LinkManPhone
		.d reportReportData.PersonReportList.Insert(reportData)
		.
	 	
		Quit reportReportData
}

}

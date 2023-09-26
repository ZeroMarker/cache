Class CHSSWeb.PersonBookingCheckService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-12-
/// Description: 预约管理信息
/// Table：PersonBookingCheck
/// Input: PersonBookingCheck
/// Output：
/// Return：
/// Others：	
ClassMethod List(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
	Set communityCode=$G(communityCode)
	
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select distinct booking.BookingRowId, person.PersonRowId, person.PersonName, person.SexDR, person.Birth, person.Address, person.FamilyRowId, person.LinkManPhone, booking.HDFPRecord, booking.BookingType, booking.DateOfBooking, booking.CheckStatus from CHSS.PersonHealthRecordMain person, CHSS.PersonBookingCheck booking where person.PersonRowId = booking.PersonRowId and person.CommunityCode = '"_communityCode_"' "_whereStr
	
	s sqlStr = sqlStr_" and isnull(booking.CheckStatus,0) = 0 order by booking.CheckStatus,booking.DateOfBooking desc"
    ;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
			
	s BookingRowId = result.Data("BookingRowId")	
	s PersonRowId = result.Data("PersonRowId")
	s PersonName = result.Data("PersonName")
		
	set SexDR = result.Data("SexDR")
	set SexName = ""
	i SexDR '= "" d
	.s sexobj=##class(User.CTSex).%OpenId(SexDR)
	.s SexName=sexobj.CTSEXDesc
		
	s Birth = result.Data("Birth")
	i (Birth'="") d
	.s Birth = $zd(Birth,3)
	
	s Address = ""
	s FamilyRowId = result.Data("FamilyRowId")
	i FamilyRowId '= "" d
    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
    .i tempFamily '= "" d
    ..i tempFamily.ProvinceDR '= "" d
    ...s Address = Address_tempFamily.ProvinceDR.Description
    ..i tempFamily.CityDR '= "" d
    ...s Address = Address_tempFamily.CityDR.Description
    ..i tempFamily.SectionDR '= "" d
    ...s Address = Address_tempFamily.SectionDR.Description
    ..i tempFamily.StreetDR '= "" d
    ...s Address = Address_tempFamily.StreetDR.Description
    ..i tempFamily.VillageDR '= "" d
    ...;s Address = Address_tempFamily.VillageDR
    ...;s Address = Address_tempFamily.VillageDR.Description
    ..i tempFamily.DoorPlate '= "" d
    ...s Address = Address_tempFamily.DoorPlate
		
	///s Address = result.Data("Address")
	s LinkManPhone = result.Data("LinkManPhone")
	s HDFPRecord = result.Data("HDFPRecord")
	
	s BookingType = result.Data("BookingType")
	s BookingTypeName = ""
	i BookingType '= "" d
	.i BookingType = 1 d
	..s BookingTypeName = "高血压"
	.e  i BookingType = 2 d
	..s BookingTypeName = "糖尿病"
	.e  i BookingType = 3 d
	..s BookingTypeName = "老年人"
	.e  i BookingType = 4 d
	..s BookingTypeName = "妇女保健"
	.e  i BookingType = 5 d
	..s BookingTypeName = "儿童保健"
	.e  i BookingType = 6 d
	..s BookingTypeName = "乙肝"
	.e  i BookingType = 7 d
	..s BookingTypeName = "结核"
	
	s DateOfBooking = result.Data("DateOfBooking")
	i (DateOfBooking'="") d
	.s DateOfBooking = $zd(DateOfBooking,3)
	
	s CheckStatus = result.Data("CheckStatus")
	s CheckStatusName = ""
	i CheckStatus = "" d
	.s CheckStatusName = "<font color=red><b>未检查</b></font>"
	i CheckStatus '= "" d
	.i CheckStatus = 1 d
	..s CheckStatusName = "<font color=green><b>已检查</b></font>"
	.e  d
	..s CheckStatusName = "<font color=red><b>未检查</b></font>"

	s tmp=BookingRowId_"^"_PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_Address_"^"_LinkManPhone_"^"_HDFPRecord_"^"_BookingType_"^"_BookingTypeName_"^"_DateOfBooking_"^"_CheckStatus
	s tmp=tmp_"^"_CheckStatusName
	
	
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("BookingRowId^PersonRowId^PersonName^SexDR^SexName^Birth^Address^LinkManPhone^HDFPRecord^BookingType^BookingTypeName^DateOfBooking^CheckStatus^CheckStatusName",count)
	
	k json
	d result.Close()
	q resultString
}

/// Creator: wangbo
/// CreatDate：2009-12-16
/// Description: 预约管理信息(根据老年人等级来查询)
/// Table：PersonBookingCheck
/// Input: PersonBookingCheck
/// Output：
/// Return：
/// Others：	
ClassMethod ListElder(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String, ElderType As %String) As %String
{
	Set communityCode=$G(communityCode)
	
	i ElderType = "31" d
	.s ElderType = "一级"
	e  i ElderType = "32" d
	.s ElderType = "二级"
	e  i ElderType = "33" d
	.s ElderType = "三级"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = " select distinct booking.BookingRowId, person.PersonRowId, person.PersonName, person.SexDR, person.Birth, person.Address, person.FamilyRowId, person.LinkManPhone, booking.HDFPRecord, booking.BookingType, booking.DateOfBooking, booking.CheckStatus from CHSS.PersonBookingCheck booking  "
	s sqlStr = sqlStr_"left join CHSS.PersonHealthRecordMain person on person.PersonRowId = booking.PersonRowId left join CHSS.ElerlyBaseInfo elder on person.PersonRowId = elder.PersonRowId "
	s sqlStr = sqlStr_" where person.PersonRowId = booking.PersonRowId  and person.CommunityCode = '"_communityCode_"' "_whereStr
	
	s sqlStr = sqlStr_"  and isnull(booking.CheckStatus,0) = 0 and booking.BookingType = 3 and elder.ElerlyGrade = '"_ElderType_"' order by booking.CheckStatus,booking.DateOfBooking desc"
	;w sqlStr	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{
			
	s BookingRowId = result.Data("BookingRowId")	
	s PersonRowId = result.Data("PersonRowId")
	s PersonName = result.Data("PersonName")
		
	set SexDR = result.Data("SexDR")
	set SexName = ""
	i SexDR '= "" d
	.s sexobj=##class(User.CTSex).%OpenId(SexDR)
	.s SexName=sexobj.CTSEXDesc
		
	s Birth = result.Data("Birth")
	i (Birth'="") d
	.s Birth = $zd(Birth,3)
	
	s Address = ""
	s FamilyRowId = result.Data("FamilyRowId")
	i FamilyRowId '= "" d
    .s tempFamily=##class(CHSS.FamilyHealthRecord).%OpenId(FamilyRowId)
    .i tempFamily '= "" d
    ..i tempFamily.ProvinceDR '= "" d
    ...s Address = Address_tempFamily.ProvinceDR.Description
    ..i tempFamily.CityDR '= "" d
    ...s Address = Address_tempFamily.CityDR.Description
    ..i tempFamily.SectionDR '= "" d
    ...s Address = Address_tempFamily.SectionDR.Description
    ..i tempFamily.StreetDR '= "" d
    ...s Address = Address_tempFamily.StreetDR.Description
    ..i tempFamily.VillageDR '= "" d
    ...;s Address = Address_tempFamily.VillageDR
    ...;s Address = Address_tempFamily.VillageDR.Description
    ..i tempFamily.DoorPlate '= "" d
    ...s Address = Address_tempFamily.DoorPlate
		
	///s Address = result.Data("Address")
	s LinkManPhone = result.Data("LinkManPhone")
	s HDFPRecord = result.Data("HDFPRecord")
	
	s BookingType = result.Data("BookingType")
	s BookingTypeName = ""
	i BookingType '= "" d
	.i BookingType = 1 d
	..s BookingTypeName = "高血压"
	.e  i BookingType = 2 d
	..s BookingTypeName = "糖尿病"
	.e  i BookingType = 3 d
	..s BookingTypeName = "老年人"
	.e  i BookingType = 4 d
	..s BookingTypeName = "妇女保健"
	.e  i BookingType = 5 d
	..s BookingTypeName = "儿童保健"
	.e  i BookingType = 6 d
	..s BookingTypeName = "乙肝"
	.e  i BookingType = 7 d
	..s BookingTypeName = "结核"
	
	s DateOfBooking = result.Data("DateOfBooking")
	i (DateOfBooking'="") d
	.s DateOfBooking = $zd(DateOfBooking,3)
	
	s CheckStatus = result.Data("CheckStatus")
	s CheckStatusName = ""
	i CheckStatus = "" d
	.s CheckStatusName = "<font color=red><b>未检查</b></font>"
	i CheckStatus '= "" d
	.i CheckStatus = 1 d
	..s CheckStatusName = "<font color=green><b>已检查</b></font>"
	.e  d
	..s CheckStatusName = "<font color=red><b>未检查</b></font>"
		
	s tmp=BookingRowId_"^"_PersonRowId_"^"_PersonName_"^"_SexDR_"^"_SexName_"^"_Birth_"^"_Address_"^"_LinkManPhone_"^"_HDFPRecord_"^"_BookingType_"^"_BookingTypeName_"^"_DateOfBooking_"^"_CheckStatus
	s tmp=tmp_"^"_CheckStatusName
	
	
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("BookingRowId^PersonRowId^PersonName^SexDR^SexName^Birth^Address^LinkManPhone^HDFPRecord^BookingType^BookingTypeName^DateOfBooking^CheckStatus^CheckStatusName",count)
	
	k json
	d result.Close()
	q resultString
}

/// Creator: lyy
/// CreatDate：2009—12-
/// Description:添加/更新预约信息
/// Table：PersonBookingCheck
/// Input: PersonBookingCheck
/// Output：
/// Return：
/// Others：
ClassMethod Insert(PersonRowId As %Integer, BookingType As %Integer, HDFPRecord As %Integer, DateOfBooking As %Date, CheckStatus As %Integer) As %String
{
    ;q:(DateOfBooking = "") ""
	s ReturnCode=..existHDFPRecord(PersonRowId, BookingType, HDFPRecord)
	i (ReturnCode'="0") d
	.i DateOfBooking '= "" d
	..s DateOfBooking=$zdh(DateOfBooking,3)
	..&sql(update CHSS.PersonBookingCheck set DateOfBooking=:DateOfBooking, CheckStatus=:CheckStatus where PersonRowId=:PersonRowId and BookingType=:BookingType and HDFPRecord=:HDFPRecord)	
	.e  d
	..s SQLCODE=..DeleteBooking(PersonRowId, BookingType, HDFPRecord)
	e  d
	.i DateOfBooking '= "" d
	..s DateOfBooking=$zdh(DateOfBooking,3)
	..&sql(update CHSS.PersonBookingCheck set CheckStatus = 1 where PersonRowId = :PersonRowId and BookingType = :BookingType)
	..&sql(insert into CHSS.PersonBookingCheck (PersonRowId, BookingType, HDFPRecord, DateOfBooking, CheckStatus) values(:PersonRowId,:BookingType,:HDFPRecord,:DateOfBooking,:CheckStatus))
	.e  d
	..&sql(update CHSS.PersonBookingCheck set CheckStatus = 1 where PersonRowId = :PersonRowId and BookingType = :BookingType)
	.;&sql(insert into CHSS.PersonBookingCheck (PersonRowId, BookingType, HDFPRecord, DateOfBooking, CheckStatus) values(:PersonRowId,:BookingType,:HDFPRecord,:DateOfBooking,:CheckStatus))
	
	s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s resultString = "{""success"":""true"",""info"":"_SQLCODE_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

/// Creator: lyy
/// CreatDate：2009-12-
/// Description:更新预约信息
/// Table：PersonBookingCheck
/// Input: BookingRowId
/// Output：
/// Return：
/// Others：
ClassMethod update(BookingRowId As %Integer, DateOfBooking As %Date) As %String
{
	q:(BookingRowId="") "code-rep"
	i DateOfBooking '= "" d
	.s DateOfBooking=$zdh(DateOfBooking,3)
	&sql(update CHSS.PersonBookingCheck set DateOfBooking=:DateOfBooking where %ID=:BookingRowId)
	
	s result=SQLCODE
    Set resultString = ""
      
    i result = "0" d
    .s resultString = "{""success"":""true"",""info"":"_BookingRowId_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
      
    q resultString
}

//判断code是否存在,-1入参为空，1重复，0不重复

ClassMethod existHDFPRecord(PersonRowId As %Integer, BookingType As %Integer, HDFPRecord As %Integer) As %String
{
	
	q:PersonRowId="" "-1"
	q:HDFPRecord="" "-1"
	
	q:$d(^CHSS.PersonBookingCheckI("HDFPRecordIndex",PersonRowId,BookingType,HDFPRecord)) "1"
	q "0"
}

/// Creator: lyy
/// CreatDate：2009-12-
/// Description:删除预约信息
/// Table：PersonBookingCheck
/// Input: BookingRowId
/// Output：
/// Return：
/// Others：
ClassMethod Delete(BookingRowId As %String) As %String
{
      &sql(delete from CHSS.PersonBookingCheck where %ID=:BookingRowId)
      s result=SQLCODE
      Set resultString = ""
      
      i result = "0" d
      .s resultString = "{""success"":""true"",""info"":"_BookingRowId_"}"
      e  d
      .s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      
      q resultString
}

/// Creator: lyy
/// CreatDate：2009-12-
/// Description:删除预约信息
/// Table：PersonBookingCheck
/// Input: BookingRowId
/// Output：
/// Return：
/// Others：
ClassMethod DeleteBooking(PersonRowId As %Integer, BookingType As %Integer, HDFPRecord As %Integer) As %String
{
      Set resultString = ""
      s ReturnCode=..existHDFPRecord(PersonRowId, BookingType, HDFPRecord)
	  i (ReturnCode'="0") d
      .&sql(delete from CHSS.PersonBookingCheck where PersonRowId=:PersonRowId and BookingType=:BookingType and HDFPRecord=:HDFPRecord)
      .s result=SQLCODE
          
      .i result = "0" d
      ..s resultString = "{""success"":""true"",""info"":"_SQLCODE_"}"
      .e  d
      ..s resultString = "{""success"":""false"",""info"":""数据删除出错!""}"
      e  d
      .s SQLCODE="-1"
      
      q SQLCODE
}

/// Creator: wangbo
/// CreatDate：2009-12-12
/// Description: 返回预约人数
/// Table：PersonBookingCheck
/// Input: PersonBookingCheck
/// Output：
/// Return：
/// Others：	
ClassMethod GetBookingCount(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
	Set communityCode=$G(communityCode)
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	s BookingCount = "0"
	s womenCount = "0"
	s childCount = "0"
	s oldmanCount = "0"
	s chronicCount = "0"
	s infectionCount = "0"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select count(*) countnums,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0 order by CHSS.PersonBookingCheck.DateOfBooking desc"
	;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()

	
	While(result.Next())
	{	
		s BookingCount = result.Data("countnums")
		;break
	}
	
	d result.Close()
	s resultString = "{""success"":""true"",""info"":"_BookingCount_"}"
	q resultString
}

ClassMethod GetBookingCountList(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String
{
	Set communityCode=$G(communityCode)
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	s BookingTitle = "预约到期人数为"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select count(*) countnums,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0 order by CHSS.PersonBookingCheck.DateOfBooking desc"

	s BookingCount = "0"
	s tmp=""
	Set json = ##class(Code.JsonObj).%New()

	s BookingCount = ..GetBookingCountWithSql(sqlStr)
	
	;womenCount
	s womenCount = 0
	s sqlStr = "select count(*) countnums,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0 and CHSS.PersonBookingCheck.BookingType in (4) order by CHSS.PersonBookingCheck.DateOfBooking desc"
	;w sqlStr,!
	s womenCount = ..GetBookingCountWithSql(sqlStr)
	
	;childCount
	s childCount = 0
	s sqlStr = "select count(*) countnums,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0 and CHSS.PersonBookingCheck.BookingType in (5) order by CHSS.PersonBookingCheck.DateOfBooking desc"
	;w sqlStr,!
	s childCount = ..GetBookingCountWithSql(sqlStr)
	
	;oldmanCount
	s oldmanCount = 0
	s sqlStr = "select count(*) countnums,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0 and CHSS.PersonBookingCheck.BookingType in (3,31,32)  order by CHSS.PersonBookingCheck.DateOfBooking desc"
	;w sqlStr,!
	s oldmanCount = ..GetBookingCountWithSql(sqlStr)
	
	;chronicCount
	Set chronicCount=0
	s sqlStr = "select count(*) countnums,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0  and CHSS.PersonBookingCheck.BookingType in (1,2) order by CHSS.PersonBookingCheck.DateOfBooking desc"
	;w sqlStr,!
	s chronicCount = ..GetBookingCountWithSql(sqlStr)
	
	;infectionCount
	Set infectionCount=0
	s sqlStr = "select count(*) infectionCount,CHSS.PersonBookingCheck.BookingRowId,CHSS.PersonHealthRecordMain.CommunityCode, CHSS.PersonBookingCheck.DateOfBooking ,CHSS.PersonBookingCheck.CheckStatus from CHSS.PersonHealthRecordMain, CHSS.PersonBookingCheck where CHSS.PersonHealthRecordMain.PersonRowId = CHSS.PersonBookingCheck.PersonRowId and CHSS.PersonHealthRecordMain.CommunityCode = '"_communityCode_"' "_whereStr
	s sqlStr = sqlStr_" and isnull(CHSS.PersonBookingCheck.CheckStatus,0) = 0  and CHSS.PersonBookingCheck.BookingType in (6,7) order by CHSS.PersonBookingCheck.DateOfBooking desc"
	;w sqlStr,!
	s infectionCount = ..GetBookingCountWithSql(sqlStr)
	
	s tmp=BookingTitle_"^"_BookingCount_"^"_womenCount_"^"_childCount_"^"_oldmanCount_"^"_chronicCount_"^"_infectionCount
	;w tmp
	s count = count+1
	i (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	
	Set resultString = json.getJsonData("BookingTitle^BookingCount^WomenCount^ChildCount^OldmanCount^ChronicCount^InfectionCount",1)
	k json
	d result.Close()
	q resultString
}

ClassMethod GetBookingCountWithSql(SqlStr As %String) As %String
{
	Set count=0
	Set resultString = ""
	Set end = 1
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = SqlStr
	;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s BookingCount = "0"
	While(result.Next())
	{	
	
		s BookingCount = result.Data("countnums")
		
	}
	d result.Close()
	q BookingCount
}

Storage Default
{
<Data name="PersonBookingCheckServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonBookin9EFD</DataLocation>
<DefaultData>PersonBookingCheckServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonBookin9EFD</IdLocation>
<IndexLocation>^CHSSWeb.PersonBookin9EFI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonBookin9EFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class web.DHCRbResByMonth Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetMonthStr() As %String
{
 Set Str=""
 Set NowMonth=$ZD($h,8)
 Set Month=$EXTRACT(NowMonth,5,6)
 Set NowYear=$EXTRACT(NowMonth,1,4)
 For i=0:1:12 d
 .Set NewMonth=Month+i
 .If NewMonth>12 Set NewMonth=NewMonth-12 ,Year=NowYear+1
 .Else  Set Year=NowYear
 .;w Year_"-"_NewMonth_"-"_"01",!
 .Set ListDate=Year_"-"_NewMonth_"-"_"01"
 .Set ListDesc=Year_"年"_NewMonth_"月"
 .If Str'="" Set Str=Str_"^"_$zdh(ListDate,3)_$c(1)_ListDesc
 .Else  Set Str=$zdh(ListDate,3)_$c(1)_ListDesc
 Q Str
}

ClassMethod GetResDocMethod(val As %String) As %String
{
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val)
		 If 'Status Quit
		 While rs.Next() {
			 Set DocCode=rs.GetData(2)
			 Set DocRowid=rs.GetData(3)
			 Set DocDesc=rs.GetData(1)
			 Set ResRowid=rs.GetData(4)
			 If desc="" Set desc=ResRowid_$c(1)_DocDesc
			 Else  Set desc=desc_"^"_ResRowid_$c(1)_DocDesc
		 }
	}
	Q desc
}

ClassMethod GetMonthDays(SelDate As %String) As %String
{
   Set NowDate=$zd(SelDate,3)
   Set NowMonth=$p(NowDate,"-",2)
   Set NowYear=$p(NowDate,"-",1)
   Set NowMonth=NowMonth+1
   If NowMonth>12 Set NowMonth=NowMonth-12,NowYear=NowYear+1
   Set NextDate=NowYear_"-"_NowMonth_"-"_"01"
   Set LastDate=$zdh(NextDate,3)-1
   Quit LastDate_"^"_$zd(SelDate,3)
}

ClassMethod InsertDocToMonth(SelectDay As %String, LocID As %String, DocId As %String) As %String
{
   ;w ##class(web.DHCRbResByMonth).InsertDocToMonth("61482","486","1268")
   Set SelectYear=$P($zd(SelectDay,3),"-",1)
   Set SelectMonth=$P($zd(SelectDay,3),"-",2)
   Set Flag=0
   Set MonthRowid="" f  Set MonthRowid=$O(^DHCRBMON("DepDay",LocID,SelectYear,+SelectMonth,SelectDay,MonthRowid)) q:MonthRowid=""  d
   .Set MonthDocid=$P(^DHCRBMON(MonthRowid),"^",3)
   .If MonthDocid=DocId Set Flag=1
   Q:(Flag=1) "Already Inserted"
   if (MonthRowid'="") d
   &sql(insert into SQLUSER.DHC_RBDocResByMonth set DHCMon_Depid=:LocID,DHCMon_docid=:DocId,DHCMon_Year=:SelectYear,DHCMon_Month=:SelectMonth,DHCMon_Date=:SelectDay) 
   Quit "0"
}

ClassMethod GetDocRBByDay(SelectDay As %String, LocID As %String) As %String
{
   Set RetStr=""
   Set SelectYear=$P($zd(SelectDay,3),"-",1)
   Set SelectMonth=$P($zd(SelectDay,3),"-",2)
   Set MonthRowid="" f  Set MonthRowid=$O(^DHCRBMON("DepDay",LocID,SelectYear,+SelectMonth,SelectDay,MonthRowid)) q:MonthRowid=""  d
   .Set MonthDocid=$P(^DHCRBMON(MonthRowid),"^",3)
   .Set Docid=$p(^RB("RES",MonthDocid),"^",2)
   .Set DocName=$P($G(^CTPCP(Docid,1)),"^",2)
   .If RetStr="" Set RetStr=MonthRowid_"^"_DocName
   .Else  Set RetStr=RetStr_$c(1)_MonthRowid_"^"_DocName
   Q RetStr
}

ClassMethod GetDocInfo(MonthRowid As %String) As %String
{
   Set RetStr=""
   If '$D(^DHCRBMON(MonthRowid)) Q ""
   Set MonthDocid=$P(^DHCRBMON(MonthRowid),"^",3)
   Set Docid=$p(^RB("RES",MonthDocid),"^",2)
   Set DocName=$P($G(^CTPCP(Docid,1)),"^",2)
   Set DepDr=$P(^DHCRBMON(MonthRowid),"^",2)
   Set DepDesc=$P(^CTLOC(DepDr),"^",2)
   Set DepDesc=$P(DepDesc,"-",2)
   Set SetDate=$P(^DHCRBMON(MonthRowid),"^",6)
   Set SetDate=$ZD(SetDate,3)
   Set RetStr=DocName_"^"_DepDesc_"^"_SetDate_"^"_DepDr_"^"_MonthDocid
   Q RetStr
}

ClassMethod GetTimeRang() As %String
{
  Set RetStr=""
  Set Flag=0
  Set TimeRangeRowid="" f  s TimeRangeRowid=$O(^DHCTimeRange(TimeRangeRowid)) q:TimeRangeRowid=""  d
  .Set TimeRangEndDate=$P(^DHCTimeRange(TimeRangeRowid),"^",8)
  .If (TimeRangEndDate'="") d
  ..if TimeRangEndDate<+$h Set Flag=1
  .Q:(Flag=1)
  .Set TimeRangeDesc=$P(^DHCTimeRange(TimeRangeRowid),"^",2)
  .Set TimeRangeStartTime=$P(^DHCTimeRange(TimeRangeRowid),"^",3)
  .Set TimeRangeStartTime=$zt(TimeRangeStartTime,1)
  .Set TimeRangeEndTime=$P(^DHCTimeRange(TimeRangeRowid),"^",4)
  .Set TimeRangeEndTime=$zt(TimeRangeEndTime,1)
  .If RetStr'="" Set RetStr=RetStr_$c(1)_TimeRangeDesc_"^"_TimeRangeRowid_"^"_TimeRangeStartTime_"^"_TimeRangeEndTime
  .Else  Set RetStr=TimeRangeDesc_"^"_TimeRangeRowid_"^"_TimeRangeStartTime_"^"_TimeRangeEndTime
  Q RetStr
}

ClassMethod GetRoomStr() As %String
{
	Set rset=##class(%ResultSet).%New("web.DHCRbResByMonth:LookUpRoom")
	do rset.Execute("")
	Set columns = rset.GetColumnCount()
	set ret=""
	While (rset.Next()) {
		s RowId=rset.GetData(3)
		s Alias=$P(^CTLOC(RowId),"^",43)
		s Desc=rset.GetData(1)
		s TRData=RowId_$C(1)_Desc_"-"_rset.GetData(2)
		i ret="" s ret=TRData
		e  s ret=ret_"^"_TRData
	}
	Q ret
}

Query LookUpRoom(desc As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
	SELECT CTLOC_Desc,CTLOC_Code,CTLOC_RowId FROM SQLUser.CT_LOC 
	WHERE (CTLOC_Desc %STARTSWITH :desc or CTLOC_Code=:desc ) and CTLOC_Type='OR'
	ORDER BY CTLOC_Code
}

ClassMethod GetSessionTypeStr() As %String
{
	s ret=""
	S RowId=0 f  s RowId=$O(^RBC("SESS",RowId)) Q:(RowId="")  d
	.s Desc=$P(^RBC("SESS",RowId),"^",2)
	.i ret="" s ret=RowId_$C(1)_Desc
	.e  s ret=ret_"^"_RowId_$C(1)_Desc
	Q ret
}

ClassMethod GetClinicGroupStr(DepRowid As %String) As %String
{
	;w ##class(web.DHCRBResSession).GetClinicGroupStr(28)
	s ret=""
	S RowId=0 f  s RowId=$O(^DHCLocSubject(RowId)) Q:(RowId="")  d
	.s LocRowid=$P(^DHCLocSubject(RowId),"^",1)
	.Q:LocRowid'=DepRowid
	.s CLGRPRowId=$P(^DHCLocSubject(RowId),"^",2)
	.s Desc=$P(^RBC("CLGRP",CLGRPRowId),"^",2)
	.i ret="" s ret=CLGRPRowId_$C(1)_Desc
	.e  s ret=ret_"^"_CLGRPRowId_$C(1)_Desc
	Q ret
}

ClassMethod GetAvailRA(ResRowId As %String, AdmDate As %Date, AdmTime As %Time, TimeRangeRowId As %String) As %String
{
	;w ##class(web.DHCRbResByMonth).GetAvailRA(1014,"2009-05-05","","29")
	s ASRowIdStr="",ASRowId="",RoomDR="",SessionTypeCode="",RetStr=""
	s AdmDate=$ZDH(AdmDate,3)
	s ASSessStartTime=0 f  s ASSessStartTime=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime)) q:(ASSessStartTime="")  d
	.s ASChildSub=0  f  s ASChildSub=$O(^RBAS(ResRowId,0,"DateSTime",AdmDate,ASSessStartTime,ASChildSub)) q:(ASChildSub="")  d
	..s StartTime=ASSessStartTime
	..s EndTime=$P($G(^RBAS(ResRowId,ASChildSub)),"^",5)
	..s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	..s RESEPMarkFlag=##class(web.DHCRBResource).GetEPMarkFlag(ResRowId)
	..Q:(("!"_TimeRangeRowId_"!")'[("!"_TRRowId_"!"))
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	..s ASRowId=ResRowId_"||"_ASChildSub
	..s RoomDR=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",5)
	..s SessionTypeDr=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",6)
	..s SessionTypeDr=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC")),"^",6)
	..s SessionTypeCode=""
	..i SessionTypeDr'="" s SessionTypeCode=$P($G(^RBC("SESS",SessionTypeDr)),"^",1)
	..s SessionTypeCode=SessionTypeCode_$e("0000",1,4-$l(ResRowId))
	..s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
	..s Load=$P($G(^RBAS(ResRowId,ASChildSub)),"^",8)
	..;预约限额
	..s AppLoad=$P($G(^RBAS(ResRowId,ASChildSub)),"^",2)
	..s AppLoad="" Set AppLoad=0
	..s WinMethodAppLoad=##class(web.DHCRBApptScheduleAppQty).GetAPPMethodQty(ASRowId,"WIN")
	..s AppLoad=WinMethodAppLoad
	..;加号限额
	..s AddLoad=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",3)
	..i AddLoad="" Set AddLoad=0
	..s ClinicGroupDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",7)
	..s ClinicGroupDesc=""
	..i ClinicGroupDr'="" s ClinicGroupDesc=$P($G(^RBC("CLGRP",ClinicGroupDr)),"^",2)
	..s SessionTypeDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",6)
	..s SessionTypeDesc=""
	..i SessionTypeDr'="" s SessionTypeDesc=$P($G(^RBC("SESS",SessionTypeDr)),"^",2)
	..s status=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",10)
	..s statuscode="",statusDesc=""
	..i status d
	...s statuscode=$P(^DHCRBCASStatus(status),"^",1)
	...s statusDesc=$P(^DHCRBCASStatus(status),"^",2)  
	..s statusreason=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",11)
	.. ;取可用排号和预约排号,加号排号
	..s AvailSeqNoStr=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"NOR")
	..s AvailAddSeqNo=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"ADD")
	..s AvailAppSeqNo=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"APP")
    ..s AvailNorSeqNo=##class(web.DHCRBApptSchedule).GetAvailSeqNoStr(ASRowId,"NORN")
    ..s UsedSeqNoCount=##class(web.DHCRBApptSchedule).GetUsedSeqNoCount(ASRowId)
    ..s RegedCount=$P(UsedSeqNoCount,"^",1)
	..s AppedCount=$P(UsedSeqNoCount,"^",2)
	..s AddedCount=$P(UsedSeqNoCount,"^",3)
	..s RoomDr=$P($G(^RBAS(ResRowId,ASChildSub,"DHC")),"^",5)
	..s RoomDesc=""
	..i RoomDr'="" Set RoomDesc=$p(^CTLOC(RoomDr),"^",2) 
	..//输出的参数格式 
	..Set RetStr=TimeRangeRowId_"^"_statuscode_"^"_statusDesc_"^"_SessionTypeDr_"^"_SessionTypeDesc
	..Set RetStr=RetStr_"^"_ASRowId_"^"_Load_"^"_AppLoad_"^"_AddLoad
	..Set RetStr=RetStr_"^"_ClinicGroupDr_"^"_ClinicGroupDesc_"^"_RoomDr_"^"_RoomDesc
	Q RetStr
}

ClassMethod ResDocListBroker(val As %Library.String = "")
{
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val)
		 If 'Status Quit
		 While rs.Next() {
			 Set DocCode=rs.GetData(2)
			 Set DocRowid=rs.GetData(3)
			 Set DocDesc=rs.GetData(1)
			 Set ResRowid=rs.GetData(4)
			 If desc="" Set desc=ResRowid_$c(1)_DocDesc
			 Else  Set desc=desc_"^"_ResRowid_$c(1)_DocDesc
		 }
	}
	Q:desc="" 1
    Q desc
	Q 1
}

ClassMethod GetResDetail(ResRowId As %String) As %String
{
	;w ##class(web.DHCRBResSession).GetResDetail("1158")
	s ClinicGroupDR="",SessionTypeDR=""
	s SessLoad="",SessNoApptSlot="",SessNumberOfWeeks="",SessNoOverbookAll=""
	s object=##class(User.DHCRBResource).%OpenId(ResRowId)
	if $IsObject(object){
		if $IsObject(object.RESClinicGroupDR) s ClinicGroupDR=object.RESClinicGroupDR.%Id()
		if $IsObject(object.RESSessionTypeDR) s SessionTypeDR=object.RESSessionTypeDR.%Id()
		s SessLoad=object.RESLoad
		s SessNoApptSlot=object.RESAppLoad
		s SessNoOverbookAll=object.RESAddLoad
		s SessNumberOfWeeks=object.RESAppStartNum
	}
	Q ClinicGroupDR_"^"_SessionTypeDR_"^"_SessLoad_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll
	
	s DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
	Q:DateRowId="" ""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	S SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",0))
	i SessRowId'="" d
	.Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
	.S SessLoad=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
	.S SessNoApptSlot=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
	.S SessNumberOfWeeks=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
	.S SessNoOverbookAll=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
	Q ClinicGroupDR_"^"_SessionTypeDR_"^"_SessLoad_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll
}

ClassMethod FindResEffectDate(ResRowId As %String) As %String
{
   Set DateRowId=0 f  s DateRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId)) q:(DateRowId="")  d
   .Set DateFrom=$P(^RB("RES",ResRowId,"DATE",DateRowId),"^",1)
   .Set DateFromStr=$ZD(DateFrom)
   .Set RowId=ResRowId_"||"_DateRowId
   Q $g(RowId)
}

ClassMethod ResSessionListBroker(itmjs As %Library.String = "", val As %Library.String = "")
{
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRbResByMonth:GetResSessions")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val)
		 If 'Status Quit
		 While rs.Next() {
			;sessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,
			;SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,
			;SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,
			;SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid
			Set SessRowid=rs.GetData(1)
			Set SessDOW=rs.GetData(2)
			Set SessTimeStart=rs.GetData(3)
			Set SessTimeEnd=rs.GetData(4)
			Set SessSlotLength=rs.GetData(5)
			Set SessLoad=rs.GetData(6)
			Set SessNoSlots=rs.GetData(7)
			Set SessNoApptSlot=rs.GetData(8)
			Set SessNumberOfWeeks=rs.GetData(9)
			Set SessNoOverbookAll=rs.GetData(10)
			Set SessRoom=rs.GetData(11)
			Set SessType=rs.GetData(12)
			Set SessClinicGroup=rs.GetData(13)
			Set SessPatientType=rs.GetData(14)
			Set SessRoomRowid=rs.GetData(15)
			Set SessTypeRowid=rs.GetData(16)
			Set SessClinicGroupRowid=rs.GetData(17)
			Set SessDOWRowid=rs.GetData(18)
			Set SessNo=rs.GetData(19)
			Set SessNoCode=rs.GetData(20)
			Set SessScheduleGenerFlag=rs.GetData(21)

			Set SessDOW=SessDOWRowid_$C(1)_SessDOW
			Set SessRoom=SessRoomRowid_$C(1)_SessRoom
			Set SessType=SessTypeRowid_$C(1)_SessType
			Set SessClinicGroup=SessClinicGroupRowid
			Set SessNo=SessNoCode_$C(1)_SessNo
			
			s val=SessRowid_"^"_SessDOW_"^"_SessTimeStart_"^"_SessTimeEnd_"^"_SessSlotLength_"^"_SessLoad_"^"_SessNoSlots_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll_"^"_SessRoom_"^"_SessType_"^"_SessClinicGroup_"^"_SessPatientType_"^"_SessNo_"^"_SessScheduleGenerFlag
			s retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
			&javascript<#(retval)#>
			 ;If desc="" Set desc=ResDateRowid_$c(1)_DateDesc
			 ;Else  Set desc=desc_"^"_ResDateRowid_$c(1)_DateDesc
		 }
	}
	Q 1
}

Query GetResSessions(ResDateRowId As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "SessRowid:%String,SessDOW:%String,SessTimeStart:%String,SessTimeEnd:%String,SessSlotLength:%String,SessLoad:%String,SessNoSlots:%String,SessNoApptSlot:%String,SessNumberOfWeeks:%String,SessNoOverbookAll:%String,SessRoom:%String,SessType:%String,SessClinicGroup:%String,SessPatientType:%String,SessRoomRowid:%String,SessTypeRowid:%String,SessClinicGroupRowid:%String,SessDOWRowid:%String,SessNo:%String,SessNoCode:%String,SessScheduleGenerFlag:%String")
{
}

ClassMethod GetResSessionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResSessionsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResSessionsExecute(ByRef qHandle As %Binary, ResDateRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ResDateRowId="" {
		do ResetVariables3
		Do OutputRow3
	}else{
		do ResetVariables3
		;sessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,
		;SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,
		;SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,
		;SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid
		S ResRowId=$P(ResDateRowId,"||",1)
		S DateRowId=$P(ResDateRowId,"||",2)
		S SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) Q:(SessRowId="")  d
		.Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
		.S SessRowid=ResDateRowId_"||"_SessRowId
		.S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
		.i SessDOWRowid'="" s SessDOW=$P(^CT("DOW",1,SessDOWRowid),"^",1)
		.S SessTimeStart=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
		.s SessTimeStartNum=SessTimeStart
		.i SessTimeStart'="" s SessTimeStart=$ZT(SessTimeStart)
		.S SessTimeEnd=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
		.i SessTimeEnd'="" s SessTimeEnd=$ZT(SessTimeEnd)
		.S SessSlotLength=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",7)
		.S SessLoad=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
		.S SessNoSlots=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",6)
		.S SessNoApptSlot=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
		.S SessNumberOfWeeks=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
		.S SessNoOverbookAll=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
		.s SessRoom=""
		.S SessRoomRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",19)
		.i SessRoomRowid'="" s SessRoom=$p(^CTLOC(SessRoomRowid),"^",2)
		.s SessType=""
		.S SessTypeRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",9)
		.i SessTypeRowid'="" s SessType=$P(^RBC("SESS",SessTypeRowid),"^",2)
		.s SessClinicGroup=""
		.S SessClinicGroupRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",35)
		.i SessClinicGroupRowid'="" s SessClinicGroup=$P(^RBC("CLGRP",SessClinicGroupRowid),"^",2)
		.S SessPatientType=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",11)
		.;SessNo代表上午,下午,晚上等的时间分段
		.S TRRowId=..GetTimeRangeByTime(SessTimeStartNum)
		.s SpecAllStr=..GetSpeciality(ResRowId_"||"_DateRowId_"||"_SessRowId)
		.s SpecialityAll=$p(SpecAllStr,"^",1)
		.s SpecialityAllDesc=$p(SpecAllStr,"^",2)
		.s SessClinicGroup=SpecialityAllDesc
		.s SessClinicGroupRowid=SpecialityAll
		.if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
		.e  s TRDesc="其他"
		.S SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",16)
		.d OutputRow3

 } 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(SessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid,SessDOWRowid,TRDesc,TRRowId,SessScheduleGenerFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables3
	set (SessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid,SessDOWRowid,TRDesc,TRRowId,SessScheduleGenerFlag)=""
	quit
}

ClassMethod GetResSessionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResSessionsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTimeRangeByTime(SessTime As %String) As %String
{
	s find=0,ret=""
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")!(find=1)  d
	.s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.i (SessTime'<StartTime)&&(SessTime'>EndTime) d
	..s find=1
	..s ret=TRRowId
	.Q:find=1
	Q ret
}

ClassMethod CheckDocRes(CheckStr As %String) As %String
{
}

ClassMethod InsertEffDate(ResRowId As %String, Para As %String) As %String
{
  ;w ##class(web.DHCRBResSession).InsertEffDate(1095,"12/11/2007")
  ;n (ResDateRowid,Para)
  k PLIST
  set EffDate=$ZDH(Para,1)
  Set PLIST(0)=ResRowId
  Set PLIST(3)=EffDate
	
  &SQL(Insert Into SQLUser.RB_ResEffDate values :PLIST())
  Q SQLCODE
}

ClassMethod GetClinicGroup(CellClinicGroupValue As %String) As %String
{
   //w ##class(web.DHCRbResByMonth).GetClinicGroup("耳科,喉科,鼻科")
   Set RetStr=""
   Set StrLen=$L(CellClinicGroupValue,",")
   For I=1:1:StrLen d
   .Set ClinicGroupRowid=""
   .Set ClinicGroup=$P(CellClinicGroupValue,",",I)
   .Set ClinicGroupRowid=$O(^RBC("CLGRP",0,"Desc",ClinicGroup,-1))
   .If (ClinicGroupRowid'="")&(RetStr="") Set RetStr=ClinicGroupRowid
   .Else  Set RetStr=RetStr_$c(1)_ClinicGroupRowid 	
   Q RetStr
}

ClassMethod GetSpeciality(ResSessRowId As %String) As %String
{
	// w ##class(web.DHCRBResSession).GetSpeciality("1489||1||2")
	s SpecialityAll=""
	s SpecialityAllDesc=""
	s ResRowId=$P(ResSessRowId,"||",1)
	s DateRowId=$P(ResSessRowId,"||",2)
	s SessRowId=$P(ResSessRowId,"||",3)
	s SpecRowId=0
	f  s SpecRowId=$o(^RB("RES",ResRowId,"Date",DateRowId,"SESS",SessRowId,"SPEC",SpecRowId)) q:SpecRowId=""  d 
	.s Speciality=$p($g(^RB("RES",ResRowId,"Date",DateRowId,"SESS",SessRowId,"SPEC",SpecRowId)),"^",1)
	.i SpecialityAll=""  s SpecialityAll=Speciality
	.e  s SpecialityAll=SpecialityAll_$C(1)_Speciality
	.s SpecialityDesc=$p($g(^RBC("CLGRP",Speciality)),"^",2)
	.i SpecialityAllDesc=""  s SpecialityAllDesc=SpecialityDesc
	.e  s SpecialityAllDesc=SpecialityAllDesc_","_SpecialityDesc 
	q SpecialityAllDesc
}

ClassMethod CheckRes(SessDOW As %String, SessNo As %String, ResNo As %String) As %String
{
  Set DayOfWeek=$p(SessDOW,$c(1),1)
  Set SessionTimeType=$p(SessNo,$c(1),1)
  Set ResRowId=$P(ResNo,"||",1)
  Set DateRowId=$P(ResNo,"||",2)
  Set flag=0
  Set SessRowId=0
  For  Set SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) q:SessRowId=""  d
  .Set DayRowid=$P(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
  .Set SessionRowid=$P(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",3)
  .If (DayRowid=DayOfWeek)&(SessionTimeType=SessionRowid) Set flag=1
  Q flag
}

ClassMethod GetResourceById(DocId As %String, js As %String)
{
	set reource = ##Class(User.DHCRBResource).%OpenId(DocId)
	set result =""
	if ($IsObject(reource.RESClinicGroupDR)){
		set result=reource.RESClinicGroupDR.CLGRPDesc
	}
	
	if ($IsObject(reource.RESSessionTypeDR)){
		set result=result_"^"_reource.RESSessionTypeDR.%Id()
 	}else{
		set result=result_"^"_""
	}
	set result=result_"^"_reource.RESLoad
	set result=result_"^"_reource.RESAppLoad
	set result=result_"^"_reource.RESAppStartNum
	set result=result_"^"_reource.RESAddLoad
	set result=result_"^"_reource.RESDiagnosCatStr
	set result=result_"^"_reource.RESFeeType
	set result=result_"^"_reource.RESReAdmFeeFlag
	set result=result_"^"_reource.RESEPMarkFlag
	q result
}

}

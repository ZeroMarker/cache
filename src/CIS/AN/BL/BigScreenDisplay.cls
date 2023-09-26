Class CIS.AN.BL.BigScreenDisplay Extends %RegisteredObject
{

// 插入大屏显示的显示字幕

// w ##class(CIS.AN.BL.BigScreenDisplay).SetScreenText("请张三到护士站")

ClassMethod SetScreenText(patName As %String) As %String
{
	s Id=""
	s Id=$o(^DHCANC("ScreenText",Id),-1)+1
	s screenText="请"_patName_"家属到护士站"
	s ^DHCANC("ScreenText",Id)=screenText_"^"_$p($h,",",1)_"^"_$p($h,",",2)
	q 0
}

// 获取要显示的大屏字幕

// w ##class(CIS.AN.BL.BigScreenDisplay).GetScreenText("")

ClassMethod GetScreenText(second As %String = "10") As %String
{
	s GetScreenText="",ToId="",Id=""
	s ToId=$g(^DHCANC("ScreenTextTo"))
	q:ToId="" ""
	;s ToId=7
	s Id=$o(^DHCANC("ScreenText",ToId))
	q:Id="" ""
	s GetScreenTextDate=$p($g(^DHCANC("ScreenText",Id)),"^",2)
	s GetScreenTextTime=$p($g(^DHCANC("ScreenText",Id)),"^",3)
	i (GetScreenTextDate=+$h)&&($p($h,",",2)-GetScreenTextTime<60) s GetScreenText=$p($g(^DHCANC("ScreenText",Id)),"^",1)
	s ^DHCANC("ScreenTextTo")=Id
	q GetScreenText
}

// w ##class(CIS.AN.BL.BigScreenDisplay).GetScreenTextNew("1")

ClassMethod GetScreenTextNew(floorId As %String) As %String
{
	set messageType="通知家属到谈话间",message="",messageId=""
	set todayH=+$h,nowH=$p($h,",",2),today=##class(CIS.AN.COM.DateTime).ConvertToDate(todayH)
	set rset=##class(%ResultSet).%New("CIS.AN.BL.TransMessage:FindTransMessages")
	set sc=rset.Execute(today,today,"",messageType)
	set todayNowH=todayH+(nowH/100000)
	set screenText=""
	while(rset.%Next())
	{
		set messageId=rset.Get("RowId")
		set message=##class(CIS.AN.TransferMessage).%OpenId(messageId)
		continue:(message.OperSchedule="")
		set operRoom=message.OperSchedule.OperRoom
		continue:(operRoom="")
		set operFloor=message.OperSchedule.OperRoom.OperFloor
		continue:(operFloor="")
		set operFloorId=message.OperSchedule.OperRoom.OperFloor.%Id()
		continue:(operFloorId'=floorId)
		set releaseDTH=message.TransDate+(message.TransTime/100000)
		set durationH=(todayNowH-releaseDTH)
		set durationDateH=$p(durationH,".",1),durationTimeH=$p(durationH,".",2)
		set duration=durationDateH*86400+durationTimeH
		continue:(duration>60)
		set screenText=message.Message
		quit:(screenText'="")	
	}
	quit screenText
}

/// 
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.BigScreenDisplay","GetAnOpList","2018-12-17","2018-12-17",29)
Query GetAnOpList(startDate As %String, endDate As %String, userDeptID As %String, floorId As %String = "") As %Query(ROWSPEC = "OpDateStr,OpRoom,Loc,MedCareNo,Status,Screenstate,PatName,OpName,OpDoc,Assistant,AnMethod,AnDoc,ScrubNurse,CirculNurse") [ SqlProc ]
{
}

ClassMethod GetAnOpListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, userDeptID As %String, floorId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	s rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
	do rset.Execute(startDate,endDate, userDeptID,"","","","Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaIn^AreaOut")
	while (rset.Next()) {
		s operRoomId=rset.GetDataByName("OperRoom")
		if (##class(CF.AN.Location).%ExistsId(operRoomId)=1)
		{
			set operRoom=##class(CF.AN.Location).%OpenId(operRoomId)
			set roomFloorId=""
			set:(operRoom.OperFloor'="") roomFloorId=operRoom.OperFloor.%Id()
			continue:(floorId'="")&(floorId'=roomFloorId)	
		}
		s opDateStr=rset.GetDataByName("OperDate"),opRoom=rset.GetDataByName("RoomDesc")
		s loc=rset.GetDataByName("AppDeptDesc"),medCareNo=rset.GetDataByName("MedcareNo")
		s status=rset.GetDataByName("OperStatusDesc"),screenstate=rset.GetDataByName("OperStatusDesc")
		s patName=rset.GetDataByName("PatName"),opName=rset.GetDataByName("OperationDesc")
		s opDoc=rset.GetDataByName("SurgeonDesc"),assistant=rset.GetDataByName("Assistant")
		s anMethod=rset.GetDataByName("PrevAnaMethodDesc"),anDoc=rset.GetDataByName("AnesthesiologistDesc")
		s scrubNurse=rset.GetDataByName("ScrubNurseDesc"),circulNurse=rset.GetDataByName("CircualNurseDesc")
		s rowId=rset.Get("RowId")
		s operNurseSignDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(rowId,"PatientHandOver","OperNurseSignDT")
		s theatreInDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(rowId,"OperCount","TheatreInTime")
		s patSend=##class(CIS.AN.BL.OperData).GetOperDataByCode(rowId,"OperCount","PostOperation")
		s theatreOutDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(rowId,"OperCount","TheatreOutTime")
		if (theatreOutDT'="")
		{
			s theatreOutDate=##class(CIS.AN.COM.DateTime).ConvertToDateH($p(theatreOutDT," ",1),"")
			s theatreOutTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH($p(theatreOutDT," ",2),"")
			s theatreOutDTH=theatreOutDate+(theatreOutTime/100000)
			s today=$p($h,",",1),now=$p($h,",",2)
			s todayNowH=today+(now/100000)
			s durationH=todayNowH-theatreOutDTH
			s durDateH=$p(durationH,".",1),durTimeH=$p(durationH,".",2)
			s duration=(durDateH*86400+durTimeH)/60
			s:(patSend="PACU") status="苏醒中",screenstate="苏醒中",opRoom="恢复室"
			s:(patSend'="PACU") status="术毕",screenstate="术毕"
			continue:(duration>30)&(patSend="PACU")
			continue:(duration>10)&(patSend'="PACU")	
		}
		elseif (theatreInDT'="")
		{
			s status="手术中",screenstate="手术中"	
		}
		elseif (operNurseSignDT'="")
		{
			s status="准备中",screenstate="准备中"
			s opRoom="准备间"	
		}
		s:status="术中" screenstate="手术中",status="手术中"
		continue:(status="安排")
		s ret=$lb(opDateStr,opRoom,loc,medCareNo,status,screenstate,patName,opName,opDoc,assistant,anMethod,anDoc,scrubNurse,circulNurse)
		d OutputRow
	}
	d rset.Close()
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
 	Set ^CacheTemp(repid,ind)=ret
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.UDHCANOPArrange).OPStartEndscreen()

/// 手术显示屏幕状态
ClassMethod GetScreenState(opsId)
{
	s state="",anaId="",OrderId="",OPTimeStr="",str="",subchl="",opEndDate="",opEndTime="",anaTheatreInDate="",anaTheatreInTime="",anaStartDate="",anaStartTime="",opStDate="",opStTime="",anaTheatreOutDate="",anaTheatreOutTime="",opstate=""
	i opaId'="" s opstate=$P(^DHCANOPArrange(opaId),"^",27)
	s OrderId=""
	////入室时间
	f  s OrderId=$o(^DHCANOrder(0,"CommOrd",15,opaId,OrderId)) q:OrderId=""  d
	.s ANOEditFlag1=$p(^DHCANOrder(OrderId),"^",25) 
	.i ANOEditFlag1="N" s Flag1="Y"
	.i (Flag1="Y")&&(opstate="I") s state="入室"
	////麻醉开始时间
	s OrderId=""
	f  s OrderId=$o(^DHCANOrder(0,"CommOrd",16,opaId,OrderId)) q:OrderId=""  d
	.s ANOEditFlag1=$p(^DHCANOrder(OrderId),"^",25) 
	.i ANOEditFlag1="N" s Flag1="Y"
	.i (Flag1="Y")&&(opstate="I") s state="麻醉中"
		
	////手术开始时间
	s OrderId=""
	f  s OrderId=$o(^DHCANOrder(0,"CommOrd",17,opaId,OrderId)) q:OrderId=""  d
	.s ANOEditFlag1=$p(^DHCANOrder(OrderId),"^",25) 
	.i ANOEditFlag1="N" s Flag1="Y"
	.i (Flag1="Y")&&(opstate="I") s state="手术中"
	////手术结束时间
	s OrderId=""
	f  s OrderId=$o(^DHCANOrder(0,"CommOrd",18,opaId,OrderId)) q:OrderId=""  d
	.s ANOEditFlag1=$p(^DHCANOrder(OrderId),"^",25) 
	.i ANOEditFlag1="N" s Flag1="Y"
	.i (Flag1="Y")&&(opstate="I") s state="麻醉复苏中"
	
	////出室时间
	s OrderId=""
	f  s OrderId=$o(^DHCANOrder(0,"CommOrd",20,opaId,OrderId)) q:OrderId=""  d
	.s ANOEditFlag1=$p(^DHCANOrder(OrderId),"^",25) 
	.i ANOEditFlag1="N" s Flag1="Y"
	.i (Flag1="Y")&&(opstate="I") s state="出室"
	q state
}

}

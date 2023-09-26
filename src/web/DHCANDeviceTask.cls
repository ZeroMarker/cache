Import SQLUser

Class web.DHCANDeviceTask Extends web.DHCClinicCom
{

ClassMethod StartTask(devId)
{
	s cmd="StartEq"
	q ..ExcuteTask(devId,cmd)
}

ClassMethod StopTask(devId)
{
	s cmd="StopEq"
	q ..ExcuteTask(devId,cmd)
}

ClassMethod ExcuteTask(devId, cmd)
{
	s device=##class(User.DHCANDevice).%OpenId(devId)
	s source="A"
	s equipId=devId
	s patientId=""
	s IP=device.Ip
	s port=device.Port
	s interval=device.IntervalTime
	d device.CollectInterfaceId.%Open()
	s devType=device.CollectInterfaceId.ANCCTCode
	s extInfo=""
	d device.%Close()
	s retStr=##class(web.DHCCLDevTool).ExcuteDevTask(source,equipId,patientId,patientId,"",IP,port,interval,devType,extInfo,cmd)
	q retStr
}

ClassMethod ExcuteByOpaId(opaId, cmd = "StartEq")
{
	// w ##class(web.DHCANDeviceTask).ExcuteByOpaId(opaId,"StartEq")
	s arrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	s roomId=""
	i arrange.OPAOpRoomDr s roomId=arrange.OPAOpRoomDr.%Id()
	d arrange.%Close()
	
	q:roomId="" "No Config"
	b
	s sub="" 
	For {
		s sub=$O(^User.DHCANRoomDeviceD(sub))
		q:sub=""
		s curRoomId=$List(^User.DHCANRoomDeviceD(sub),2)
		
		if (curRoomId=roomId) {
		   s devId=$List(^User.DHCANRoomDeviceD(sub),3)
		   if devId'="" {
		   w "Start:",..ExcuteTask(devId,cmd),!
		  }
		}
	}
	q "0"
}

/// Creator：      	邓体进
/// CreatDate：    	2016-11-17
/// Description： 	添加某时间点的数据
/// Table：        	
/// Input：        	cmd: StopEq/StartEq
/// Output：        入库情况
/// Return：       	0: 正常 
/// 
ClassMethod StartAllTask(cmd = "StartEq")
{
	// w ##class(web.DHCANDeviceTask).StartAllTask()
	// w ##class(web.DHCANDeviceTask).StartAllTask("StopEq")
	s sub="" 
	For {
		s sub=$O(^User.DHCANDeviceD(sub))
		q:sub=""
		w "sub:",sub,!
		
		w ..ExcuteTask(sub,cmd),!
	}
	q "Finish"
}

ClassMethod StartOldAllTask(cmd = "StartEq", department = "") As %String
{
	// w ##class(web.DHCANDeviceTask).StartOldAllTask("StopEq",1)
	// w ##class(web.DHCANDeviceTask).StartOldAllTask("StartEq",1)
	s equipId=0,retStr=0
	f  s equipId=$o(^DHCANRoomEquip(equipId)) q:equipId=""  d
	.s RoomId=$p(^DHCANRoomEquip(equipId),"^",1)
	.i RoomId=$c(0) s RoomId=""
	.s interval=$p(^DHCANRoomEquip(equipId),"^",6)
	.s devInterface=$p(^DHCANRoomEquip(equipId),"^",5)
	.s bStat=$p(^DHCANRoomEquip(equipId),"^",8)
	.s curDepartment=$p(RoomId,"||",1)
	.
	.q:devInterface'=36
	.q:((department'="")&&(curDepartment'=department))
	.w "RoomId:",RoomId,"::=>",equipId,! 
	.
	.
	.i RoomId'="" d
	..s ANaId=$o(^DHCANArrange(0,"RoomStatus",RoomId,"M",""))
	..q:ANaId=""
	..q:'$d(^DHCANArrange(0,"RoomStatus",RoomId,"M"))
	..s retStr=##class(web.DHCANCom).ExcuteTask(equipId,ANaId,cmd)
	.e  d
	..; AN共享设备
	..s retStr=##class(web.DHCANCom).ExcuteTask(equipId,"",cmd)
	..
	q "Over"
}

ClassMethod GetPatInfo(opaId As %String, equipId) As %String
{
	// ##class(web.DHCANDeviceTask).GetPatInfo(ANaId,equipId)
	if (equipId'="") {
	&sql(select OPA_RowId into:ANaId from DHC_AN_OPArrange 
	where OPA_Status='M' and OPA_OpRoom_Dr=
	(select RoomId from DHC_AN_RoomDevice where DeviceId=:equipId))
	}
	if (ANaId'="") {
		s arrange=##class(User.DHCANOPArrange).%OpenId(opaId)
		s EpisodeID= arrange.OPAAdmDr // $p(^DHCANArrange(ANaId),"^",1)
		s papmiId=+^PAADM(+EpisodeID)
		s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
		s patName=$p(^PAPER(papmiId,"ALL"),"^",1)
		s RoomObj=##class(User.DHCANCOperRoom).%OpenId(arrange.OPAOpRoomDr)
		q patName_"^"_regNo_"^"_RoomObj.OPRCode
	}
	q "NotFound"
}

}

Class CIS.AN.BL.CollectTask Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.CollectTask).StartAllTask()
ClassMethod StartAllTask(cmd = "StartEq")
{
	// w ##class(CIS.AN.BL.CollecteTask).StartAllTask()
	Set equipId="",IP="",port="",devType="" 
	&sql(DECLARE EmpCursor CURSOR FOR 
	select Equip->RowId,TcpipAddress,ComPort,Program 
	into:equipId,:IP,:port,:devType
	from CF_AN.EquipCollection)
	&sql(OPEN EmpCursor)
    For { 
	    &sql(FETCH EmpCursor)
	    Quit:SQLCODE  
	    // 启动任务
	    Set source="A"
	    Set interval=60000
	    Set curTime=$PIECE($HOROLOG,",",2)
	    Set res=##class(web.DHCCLDevTool).ExcuteDevTask(source, equipId, "", IP, port, interval,devType, "", cmd)
	    Set span=$PIECE($HOROLOG,",",2)-curTime
	    If ((span>5)&&($IO'["TNT"))
	    {
		    // 如果不是在Terminal中运行且执行时间超过5s则不再执行其他任务
		    Quit
	    }
	    Write "Start",equipId,":",res,!
    }
    &sql(Close EmpCursor)
	Quit "Over"
}

// w ##class(CIS.AN.BL.CollectTask).ImportFromRoomEquip()

// 导入旧表数据

ClassMethod ImportFromRoomEquip()
{
	Set id=""
	For
	{
		Set id=$ORDER(^DHCANRoomEquip(id))
		Quit:id=""
		Set equip=##class(User.DHCANRoomEquip).%OpenId(id)
		If (equip)
		{
			Set ip=equip.ANRETcpipAddress
			Set port=equip.ANREPort
			Set taskId=""
			&sql(SELECT Equip->RowId into:taskId FROM CF_AN.EquipCollection 
			WHERE TcpipAddress=:ip AND ComPort=:port)
			Set devType=##class(User.DHCANCCollectType).%OpenId(equip.ANREInterfaceProgram)
			Set devTypeCode=devType.ANCCTCode
			// ip和端口不存在，且采集代码不为空时导入
			If (taskId=""&&(devType'=""))
			{
				Set device=##class(CF.AN.DeptEquip).%New()
				Set device.EquipCode="监护设备"_equip.ANRERoomDr.OPRCode
				Set device.EquipDesc="监护设备"_equip.ANRERoomDr.OPRCode
				Set device.ActiveDate=+$HOROLOG
				Set device.Dept="麻醉科"
				
				Do device.%Save()
				Set collectDevice=##class(CF.AN.EquipCollection).%New()
				Set devType=##class(User.DHCANCCollectType).%OpenId(equip.ANREInterfaceProgram)
				Set collectDevice.Program=devTypeCode
				Set collectDevice.ComPort=port
				Set collectDevice.TcpipAddress=ip
				Set collectDevice.Equip=device Break
				Do collectDevice.%Save()
				Write collectDevice.%Id()
				
				Do device.%Close()
				Do collectDevice.%Close()
			}
			Do equip.%Close()
		}
	}
	Quit
}

// w ##class(CIS.AN.BL.CollectTask).GetPatInfo(taskId)

ClassMethod GetPatInfo(taskId) As %String
{

 set roomId=""

 &sql(SELECT Equip->LocationStr,Equip->LocationStr->Description into :roomId,:roomDesc FROM CF_AN.EquipCollection

 where Equip->RowId=:taskId)

 if (roomId="")

 {

  return "rommId=null"

 }

 set opsId=""

 &sql(select top 1 A.RowId into :opsId

 from CIS_AN.OperSchedule as A

 where OperRoom=:roomId and Status->Code in ('RoomIn','RoomOut')

 order by OperDate desc,OperTime desc)

 if (opsId="")

 {

  return "UnKown"

 }

 set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)

 s papmiId=+^PAADM(operScheduleObj.EpisodeID)

 s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)

 s patName=$p(^PAPER(papmiId,"ALL"),"^",1)

 q patName_"^"_regNo_"^"_roomDesc_"^opsId:"_opsId
}

}

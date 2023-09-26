Import SQLUser

Class web.DHCICUDeviceTask Extends %RegisteredObject
{

ClassMethod StartTask(devId, icuaId)
{
	s cmd="StartEq"
	q ..ExcuteTask(devId,icuaId,cmd)
}

ClassMethod StopTask(devId, icuaId = "")
{
	s cmd="StopEq"
	q ..ExcuteTask(devId,cmd)
}

ClassMethod ExcuteTask(devId, icuaId, cmd)
{
	s ^TMPdev("icuaId")=devId
	s device=##class(User.DHCICUDevice).%OpenId(devId)
	s source="I"
	s equipId=devId
	s patientId=icuaId
	s IP=device.Ip
	s port=device.Port
	s interval=device.IntervalTime
	d device.CollectInterfaceId.%Open()
	s devType=device.CollectInterfaceId.ANCCTCode
	s customSrvIP=device.CollectSrvIP
	
	s extInfo=""
	d device.%Close()
	s retStr=##class(web.DHCCLDevTool).ExcuteDevTask(source,equipId,patientId,IP,port,interval,devType,extInfo,cmd,customSrvIP)
	q retStr
}

// w ##class(web.DHCICUDeviceTask).StartByIcuaId(22,"StartEq")

ClassMethod StartByIcuaId(icuaId, cmd = "StartEq")
{
	q:icuaId="" "icuaId is NULL"
	b ;9
	s arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	s bedId=arrange.ICUABedDr
	d arrange.%Close()
	q:bedId="" "未安排床位"
	&sql(Declare c Cursor for 
	select BedId,DeviceId into bedId,deviceId 
	from DHC_ICU_BedDevice
	where BedId=:bedId)
	&sql(open c)
	s res=""
	For{
		&sql(Fetch c)
		quit:SQLCODE
		w "Task:",bedId,deviceId,icuaId,!
		
		s res=..ExcuteTask(deviceId,icuaId, cmd)
	}
	&sql(Close c)
	q 0
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
	// w ##class(web.DHCICUDeviceTask).StartAllTask()
	// w ##class(web.DHCICUDeviceTask).StartAllTask("StopEq")
	s sub="" 
	For {
		s sub=$O(^User.DHCICUDeviceD(sub))
		q:sub=""
		s icuaId=..GetCurIcuaIdByDeviceId(sub)
		w cmd_":",sub," ",icuaId,!
		w ..ExcuteTask(sub,icuaId,cmd),!
	}
	q "Finish"
}

ClassMethod StartOldAllTask(cmd = "StartEq", department = "") As %String
{
	// w ##class(web.DHCICUDeviceTask).StartOldAllTask("StopEq",1)
	// w ##class(web.DHCICUDeviceTask).StartOldAllTask("StartEq",1)
	s equipId=0,retStr=0
	f  s equipId=$o(^DHCICUBedEquip(equipId)) q:equipId=""  d
	.s bedId=$p(^DHCICUBedEquip(equipId),"^",1)
	.i bedId=$c(0) s bedId=""
	.s interval=$p(^DHCICUBedEquip(equipId),"^",6)
	.s devInterface=$p(^DHCICUBedEquip(equipId),"^",5)
	.s bStat=$p(^DHCICUBedEquip(equipId),"^",8)
	.s curDepartment=$p(bedId,"||",1)
	.
	.q:devInterface'=36
	.q:((department'="")&&(curDepartment'=department))
	.w "bedId:",bedId,"::=>",equipId,! 
	.
	.
	.i bedId'="" d
	..s icuaId=$o(^DHCICUArrange(0,"BedStatus",bedId,"M",""))
	..q:icuaId=""
	..q:'$d(^DHCICUArrange(0,"BedStatus",bedId,"M"))
	..s retStr=##class(web.DHCICUCom).ExcuteTask(equipId,icuaId,cmd)
	.e  d
	..; ICU共享设备
	..s retStr=##class(web.DHCICUCom).ExcuteTask(equipId,"",cmd)
	..
	q "Over"
}

ClassMethod GetCurIcuaIdByDeviceId(devId)
{
	// w ##class(web.DHCICUDeviceTask).GetCurIcuaIdByDeviceId(4)
	s icuaId=""
	if (devId'=""){
		&sql(select ICUA_RowId into:icuaId from DHC_ICU_Arrange
		where ICUA_Status='M' and ICUA_Bed_Dr=
		(select BedId from DHC_ICU_BedDevice where DeviceId=:devId))
	}
	q icuaId
}

ClassMethod GetPatInfo(icuaId As %String, equipId) As %String
{
	// w ##class(web.DHCICUDeviceTask).GetPatInfo("",1)
	if (equipId'=""){
		s icuaId=..GetCurIcuaIdByDeviceId(equipId)
	}
	if (icuaId'=""){
		s arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
		q:arrange="" "NotFound"
		s episodeId=arrange.ICUAAdmDr
		q:episodeId="" "NotFound"
		s papmiId=+^PAADM(+episodeId)
		s regNo=$p(^PAPER(papmiId,"PAT",1),"^",1)
		s patName=$p(^PAPER(papmiId,"ALL"),"^",1)
		s bedObj=##class(User.PACBed).%OpenId(arrange.ICUABedDr)
		q patName_"^"_regNo_"^"_bedObj.BEDCode
	}
	q "NotFound"
}

ClassMethod LoadOldConfigToNew(deptId) As %String
{
   // w ##class(web.DHCICUDeviceTask).LoadOldConfigToNew(92)
	s index=1
	s sub=0 f  s sub=$O(^DHCICUBedEquip(sub)) q:sub=""  d
	.s obj=##class(User.DHCICUBedEquip).%OpenId(sub)
	.s curDeptId=$p(obj.ICUBEBedDr,"||",1)
	.
	.q:curDeptId'=deptId
	.;q:obj.ICUBEInterfaceProgram'=36
	.w sub_":"_obj.ICUBEBedDr_","_obj.ICUBETcpipAddress_","_obj.ICUBEPort_","_obj.ICUBEInterfaceProgram,!
	.s bedObj=##class(User.PACBed).%OpenId(obj.ICUBEBedDr)
	.s deviceName="ICU1"+bedObj.BEDCode
	.s departmentId=deptId
	.s deviceNumber=deptId*10000+index
	.s collectInterfaceId=obj.ICUBEInterfaceProgram
	.s ip=obj.ICUBETcpipAddress
	.s port=obj.ICUBEPort
	.s macAddr=""
	.s serialNumber=""
	.s collectSrvIP=""
	.
	.s rowId=##class(web.DHCICUDevice).AddIcuDevice(deviceNumber,deviceName, departmentId , collectInterfaceId, ip, port, macAddr, serialNumber, collectSrvIP,60)
	.
	.s bedDedId=##class(web.DHCICUBedDevice).AddBedDevice(obj.ICUBEBedDr,rowId,bedObj.BEDCode)
	.d bedObj.%Close()
	.s index=index+1
	q "Over"
}

//  注意: 该方法只在上前可以调用

/// 清除DHC_ICU_Device和DHC_ICU_BedDevice数据
ClassMethod ClearDeviceData()
{
	b // 注意: 该方法只在上前可以调用,退出请按Ctrl+c
	m ^TmpIcuDebug($h,"User.DHCICUDeviceD")=^User.DHCICUDeviceD
	m ^TmpIcuDebug($h,"User.DHCICUDeviceI")=^User.DHCICUDeviceI
	m ^TmpIcuDebug($h,"User.DHCICUBedDeviceD")=^User.DHCICUBedDeviceD
	m ^TmpIcuDebug($h,"User.DHCICUBedDeviceD")=^User.DHCICUBedDeviceD
	k ^User.DHCICUDeviceD
	k ^User.DHCICUDeviceI
	k ^User.DHCICUBedDeviceD
	k ^User.DHCICUBedDeviceI
	q "Over"
}

ClassMethod GenConfiData()
{
	// w ##class(web.DHCICUDeviceTask).GenConfiData()
	s fromIndex=1
	f i=1:1:24  d
	.s DepartmentId=26
	.s bedCode="Bed"_i
	.s DeviceNumber="监护仪"_i
	.s DeviceName=DeviceNumber
	.s Ip="202.114.4."_i
	.s MacAddress=""
	.s SerialNumber=DeviceName
	.s CollectSrvIP="192.9.206.43"
	.s IntervalTime=60
	.s Port=4601
	.s devId=##class(web.DHCICUDevice).AddIcuDevice(DeviceNumber, DeviceName, DepartmentId, 20, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
	.w "Add Device:",devId,!
	.s BedId="26||"_i
	.s bedDeviceId=##class(web.DHCICUBedDevice).AddBedDevice(BedId, devId, bedCode)
	.w "Bed Device:",devId,!
	q "Over"
}

}

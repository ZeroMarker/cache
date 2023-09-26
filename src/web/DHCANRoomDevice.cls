Import SQLUSER

Class web.DHCANRoomDevice Extends %RegisteredObject
{

// d ##class(%ResultSet).RunQuery("web.DHCANRoomDevice","FindANRoomDeviceByRoomId","55||1")

Query FindANRoomDevice(locId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    Select RowId,DeviceId,Note,DeviceId->DeviceNumber As DeviceNumber,DeviceId->DeviceName As DeviceName,RoomId,RoomId->OPR_Desc As Room,RoomId->OPR_Ctloc_Dr As DepartmentId,DeviceId->DepartmentId->CTLOC_Desc As Department
    from DHC_AN_RoomDevice
    where :locId is null or RoomId->OPR_Ctloc_Dr=:locId
}

// d ##class(%ResultSet).RunQuery("web.DHCANRoomDevice","FindANRoomDeviceByOpaId",16)

Query FindANRoomDeviceByOpaId(opaId) As %Query(ROWSPEC = "RowId,DeviceId,Note,DeviceNumber,DeviceName,RoomId,Room,DepartmentId,Department") [ SqlProc ]
{
}

ClassMethod FindANRoomDeviceByOpaIdExecute(ByRef qHandle As %Binary, opaId) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	b
	s arrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	s roomId=""
	i arrange.OPAOpRoomDr s roomId=arrange.OPAOpRoomDr.%Id()
	d arrange.%Close()
	&sql(Declare c Cursor for
	 Select RowId,DeviceId,Note,DeviceId->DeviceNumber As DeviceNumber,DeviceId->DeviceName As DeviceName,RoomId,RoomId->OPR_Desc As Room,RoomId->OPR_Ctloc_Dr As DepartmentId,RoomId->OPR_Ctloc_Dr As Department
	into RowId,DeviceId,Note,DeviceNumber,DeviceName,RoomId,Room,DepartmentId,Department
    from DHC_AN_RoomDevice
    where RoomId=:roomId)
    &sql(open c)
    For {
	    &sql(Fetch c)
	    quit:SQLCODE
	    d OutputRow
	}
	&sql(Close c)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,DeviceId,Note,DeviceNumber,DeviceName,RoomId,Room,DepartmentId,Department)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANRoomDeviceByOpaIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANRoomDeviceByOpaIdExecute ]
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

ClassMethod FindANRoomDeviceByOpaIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindANRoomDeviceByRoomId(roomId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    Select RowId,DeviceId,Note,DeviceId->DeviceNumber As DeviceNumber,DeviceId->DeviceName As DeviceName,RoomId,RoomId->OPR_desc As Room,RoomId->OPR_Ctloc_Dr As DepartmentId,RoomId->OPR_Ctloc_Dr As Department
    from DHC_AN_RoomDevice
    where RoomId=:roomId
}

// d ##class(%ResultSet).RunQuery("web.DHCANRoomDevice","FindANRoomDevice","23")

/*
Query FindANRoomDevice(departmentId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
    Select RowId,DeviceNumber,DeviceName
    from DHC_AN_Device
}
*/

// where DepartmentId=:departmentId

//    OR :departmentId IS null

/// w ##class(web.DHCANRoomDevice).FindLoc("1")
ClassMethod FindLoc(Department)
{
    &SQL(select CTLOC_RowID,CTLOC_Desc,CTLOC_Code into :ctlocId,:ctlocDesc,:ctlocCode from CT_Loc where CTLOC_RowID=:Department)
    q ctlocId_":"_ctlocDesc_":"_ctlocCode
}

// 增加设备(报错)

ClassMethod AddRoomDevice(RoomId, Device, Note)
{
	
	&SQL(insert into DHC_AN_RoomDevice (RoomId,DeviceId,Note)
	values(:RoomId,:Device,:Note))
	q SQLCODE
}

/// 更新
ClassMethod UpdateRoomDevice(RowId, RoomId, Device, Note, isForceSet = "false") As %String
{
	
	s oldRoomId="",oldRoomDesc=""
	i Device'="" d
	.s oldRoomId=..GetRoomIdByDeviceId(Device,RoomId)
	..
	i oldRoomId'="" d
	.s oldRoomDesc=$p(^DHCANC("OPRoom",oldRoomId),"^",2)
	q:(isForceSet="false")&&(oldRoomId'="") oldRoomDesc_"正在使用该设备"
	
	
	i isForceSet="true"&&(Device>0) d
	.
	.s res=..ClearRoomOfDevice(Device)
	&SQL(update DHC_AN_RoomDevice set RoomId=:RoomId,DeviceId=:Device,Note=:Note  where RowId=:RowId)
	
	q SQLCODE
}

/// 更新
ClassMethod ModifyRoomDevice(RowId, DeviceId)
{
	&SQL(update DHC_AN_RoomDevice set DeviceId=:DeviceId  where RowId=:RowId)
	
	q SQLCODE
}

// 删除

ClassMethod DeleteRoomDevice(rw As %String)
{
	q:rw="" -1
	&SQL(Delete from DHC_AN_RoomDevice where RowId=:rw)
	q SQLCODE
}

ClassMethod ClearRoomOfDevice(devId)
{
	// 根据设备号清空手术间
	&sql(update DHC_AN_RoomDevice set DeviceId="" where DeviceId=:devId)
	b
	q 0
}

ClassMethod GetRoomIdByDeviceId(devId, roomId)
{
	//s roomId=""
	/*&sql(select top 1 RoomId into:roomId from DHC_AN_RoomDevice
	where  DeviceId=:devId and ( RoomId<>:curRoomId)) // 用SQL查询出错，为什么??
	*/
	s res=""
	//&sql(select top 1 RowId,RoomId into :rowId,:roomId from DHC_AN_RoomDevice where RowId is not null and DeviceId=16 and RoomId<>7)
	s sub="" f  s sub=$O(^User.DHCANRoomDeviceD(sub)) q:sub=""  d
	.s curDevId=$List(^User.DHCANRoomDeviceD(sub),3)
	.s curRoomId=$List(^User.DHCANRoomDeviceD(sub),2)
	.q:curRoomId=""
	.i (curDevId=devId)&&(curRoomId'=roomId) d
	..s res=curRoomId 
	q res
}

// d ##class(%ResultSet).RunQuery("web.DHCANRoomDevice","FindRoom","","5")

Query FindRoom(locId, filterStr) As %SQLQuery(CONTAINID = 1)
{
	select OPR_RowId As Id,	OPR_Desc As Code from DHC_ANC_OperRoom
	where OPR_Ctloc_Dr=:locId
}

// w ##class(web.DHCANRoomDevice).LoadOldData()

ClassMethod LoadOldData()
{
	s sub=0 f  s sub=$O(^DHCANRoomEquip(sub)) q:sub=""  d
	.s equipObj=##class(User.DHCANRoomEquip).%OpenId(sub)
	.s DeviceNumber="00000"_sub, DeviceName="00000"_sub
	.s DepartmentId=equipObj.ANRERoomDr.OPRCtlocDr, CollectInterfaceId=equipObj.ANREInterfaceProgram
	.s Ip=equipObj.ANRETcpipAddress, Port=equipObj.ANREPort, SerialNumber="", CollectSrvIP="", IntervalTime=60
	.s MacAddress=""
	.q:equipObj.ANRERoomDr=""
	.s deviceId=##class(web.DHCANDevice).AddANDevice(DeviceNumber, DeviceName, DepartmentId, CollectInterfaceId, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
	.w "deviceId:",sub,!
	.
	.q:deviceId<0 
	.s roomId=equipObj.ANRERoomDr.%Id()
	.d ##class(web.DHCANRoomDevice).AddRoomDevice(roomId,deviceId,"")
	.d equipObj.%Close()
	q "Over"
}

}

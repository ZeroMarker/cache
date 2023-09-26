Import SQLUSER

Class web.DHCANDevice Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANDevice","FindANDevice","")
Query FindANDevice(departmentId As %String = "", filter = "") As %SQLQuery(CONTAINID = 1)
{
    select RowId,DeviceNumber,DeviceName,DepartmentId,DepartmentId->CTLOC_Desc As Department,CollectInterfaceId,
	CollectInterfaceId->ANCCT_Desc As CollectInterface,Ip,Port,MacAddress,SerialNumber,CollectSrvIP,IntervalTime
	from DHC_AN_Device
    where ( ((departmentId<>'') and (DepartmentId=:departmentId) OR
     (:departmentId='' OR :departmentId IS null)) ) AND 
     ((:filter is NULL) OR (DeviceName[:filter))
}

// w ##class(web.DHCANDevice).AddANDevice("AN003","PhilipsMp20","AN3","PhilipsMp","192.168.3.125","5201","FB:CD:AD","NB4567","现位于三床")

ClassMethod AddANDevice(DeviceNumber, DeviceName, DepartmentId, CollectInterfaceId, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
{
	s ^dhccllog("DeviceNumber")=DeviceNumber
	&SQL(insert into DHC_AN_Device (DeviceNumber,DeviceName,DepartmentId,CollectInterfaceId,Ip,
	Port,MacAddress,SerialNumber,CollectSrvIP,IntervalTime)
	values(:DeviceNumber,:DeviceName,:DepartmentId,:CollectInterfaceId,:Ip,
	:Port,:MacAddress,:SerialNumber,:CollectSrvIP,:IntervalTime))
	s res=""
	i SQLCODE=0 s res=%ROWID
	e  s res=SQLCODE
	q res
}

//增加设备

//s ^DHCANDevice(3) = "AN003"_"^"_"PhilipsMp20"_"^"_"AN3"_"^"_"PhilipsMp"_"^"_"192.168.3.125"_"^"_"5201"_"^"_"FB:CD:AD"_"^"_"NB4567"_"^"_"现位于三床"

// w ##class(web.DHCANDevice).AddANDevice("AN003","PhilipsMp20","AN3","PhilipsMp","192.168.3.125","5201","FB:CD:AD","NB4567","现位于三床")

//更新

ClassMethod UpdateANDevice(RowId, DeviceNumber, DeviceName, DepartmentId, CollectInterfaceId, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
{
	&SQL(update DHC_AN_Device set DeviceNumber=:DeviceNumber,DeviceName=:DeviceName,DepartmentId=:DepartmentId,
	CollectInterfaceId=:CollectInterfaceId,Ip=:Ip,Port=:Port,MacAddress=:MacAddress,SerialNumber=:SerialNumber,
	CollectSrvIP=:CollectSrvIP,IntervalTime=:IntervalTime
	where RowId=:RowId)
	q SQLCODE
}

//删除

ClassMethod DeleteANDevice(rw As %String)
{
	q:rw="" -1
	&SQL(Delete from DHC_AN_Device where RowId=:rw)
	q SQLCODE
}

// d ##class(%ResultSet).RunQuery("web.DHCANDevice","FindLoc","")

Query FindLoc(filterStr) As %SQLQuery(CONTAINID = 1)
{
	select top 20 CTLOC_RowID As Id,CTLOC_Code As Code,CTLOC_Desc As Text from CT_Loc
	where ((:filterStr<>'') AND CTLOC_Desc[:filterStr) OR (:filterStr is NULL)
}

}

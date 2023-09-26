Import SQLUSER

Class web.DHCICUDevice Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCICUDevice","FindIcuDevice","")
Query FindIcuDevice(departmentId As %String = "", filter = "") As %SQLQuery(CONTAINID = 1)
{
    select RowId,DeviceNumber,DeviceName,DepartmentId,DepartmentId->WARD_Desc As Department,CollectInterfaceId,
	CollectInterfaceId->ANCCT_Desc As CollectInterface,Ip,Port,MacAddress,SerialNumber,CollectSrvIP,IntervalTime
	from DHC_ICU_Device
    where ( ((departmentId<>'') and (DepartmentId=:departmentId) OR
     (:departmentId='' OR :departmentId IS null)) ) AND 
     ((:filter is NULL) OR (DeviceName[:filter))
}

// w ##class(web.DHCICUDevice).AddIcuDevice("ICU003","PhilipsMp20","ICU3","PhilipsMp","192.168.3.125","5201","FB:CD:AD","NB4567","现位于三床")

ClassMethod AddIcuDevice(DeviceNumber, DeviceName, DepartmentId, CollectInterfaceId, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
{
	s ^dhccllog("DeviceNumber")=DeviceNumber
	s rowId=$$Find(DeviceNumber)
	if rowId'="" d
	.d ..UpdateIcuDevice(rowId, DeviceNumber, DeviceName, DepartmentId, CollectInterfaceId, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
    else  d
    .s rowId=$$Add()
    q rowId
Add()
    &SQL(insert into DHC_ICU_Device (DeviceNumber,DeviceName,DepartmentId,CollectInterfaceId,Ip,Port,MacAddress,SerialNumber,CollectSrvIP,IntervalTime)
	values(:DeviceNumber,:DeviceName,:DepartmentId,:CollectInterfaceId,:Ip,:Port,:MacAddress,:SerialNumber,:CollectSrvIP,:IntervalTime))
	
	q:SQLCODE=0 $g(%ROWID)
	q SQLCODE
Find(DeviceNumber)
    s rowId=""
    &sql(select RowId into:rowId 
    from DHC_ICU_Device 
    where DeviceNumber=:DeviceNumber)
    q rowId
}

// 增加设备

// s ^DHCICUDevice(3) = "ICU003"_"^"_"PhilipsMp20"_"^"_"ICU3"_"^"_"PhilipsMp"_"^"_"192.168.3.125"_"^"_"5201"_"^"_"FB:CD:AD"_"^"_"NB4567"_"^"_"现位于三床"

// w ##class(web.DHCICUDevice).AddIcuDevice("ICU003","PhilipsMp20","ICU3","PhilipsMp","192.168.3.125","5201","FB:CD:AD","NB4567","现位于三床")

// 更新

ClassMethod UpdateIcuDevice(RowId, DeviceNumber, DeviceName, DepartmentId, CollectInterfaceId, Ip, Port, MacAddress, SerialNumber, CollectSrvIP, IntervalTime)
{
	&SQL(update DHC_ICU_Device set DeviceNumber=:DeviceNumber,DeviceName=:DeviceName,DepartmentId=:DepartmentId,
	CollectInterfaceId=:CollectInterfaceId,Ip=:Ip,Port=:Port,MacAddress=:MacAddress,SerialNumber=:SerialNumber,
	CollectSrvIP=:CollectSrvIP,IntervalTime=:IntervalTime
	where RowId=:RowId)
	q SQLCODE
}

// 删除

ClassMethod DeleteIcuDevice(rw As %String)
{
	q:rw="" -1
	&SQL(Delete from DHC_ICU_Device where RowId=:rw)
	q SQLCODE
}

// d ##class(%ResultSet).RunQuery("web.DHCICUDevice","FindWard","")

Query FindWard(filterStr) As %SQLQuery(CONTAINID = 1)
{
	select top 20 WARD_RowID As Id,WARD_Code As Code,WARD_Desc As Text from PAC_Ward
	where ((:filterStr<>'') AND WARD_Desc[:filterStr) OR (:filterStr is NULL)
}

}

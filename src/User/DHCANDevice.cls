Class User.DHCANDevice Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_AN_Device ]
{

//	科室ID/设备编号/设备名称/采集代码/IP地址/端口号/MAC地址/序列号

// departmentId/deviceNumber/deviceName/CollectInterfaceId/IpAddr/port/MACAddress/seqNo

Property DepartmentId As User.CTLoc [ Required ];

// 设备编号医院指定(是否可以给定一个默认的?)

Property DeviceNumber As %String;

// 设备名称,如重症迈瑞监护仪

Property DeviceName As %String;

// 采集代码索引

Property CollectInterfaceId As User.DHCANCCollectType [ Required ];

// IP 地址

Property Ip As %String [ Required ];

// 端口号

Property Port As %String [ Required ];

// 采集间隔

Property IntervalTime As %String [ Required ];

// MAC地址

Property MacAddress As %String;

// S/N号

Property SerialNumber As %String;

// 自定义采集服务器IP地址

Property CollectSrvIP As %String;

Index DepartmentIndex On DepartmentId As Plus;

Storage Default
{
<Data name="DHCANDeviceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DepartmentId</Value>
</Value>
<Value name="3">
<Value>DeviceNumber</Value>
</Value>
<Value name="4">
<Value>DeviceName</Value>
</Value>
<Value name="5">
<Value>CollectInterfaceId</Value>
</Value>
<Value name="6">
<Value>Ip</Value>
</Value>
<Value name="7">
<Value>MacAddress</Value>
</Value>
<Value name="8">
<Value>SerialNumber</Value>
</Value>
<Value name="9">
<Value>Port</Value>
</Value>
<Value name="10">
<Value>CollectSrvIP</Value>
</Value>
<Value name="11">
<Value>IntervalTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCANDeviceD</DataLocation>
<DefaultData>DHCANDeviceDefaultData</DefaultData>
<IdLocation>^User.DHCANDeviceD</IdLocation>
<IndexLocation>^User.DHCANDeviceI</IndexLocation>
<StreamLocation>^User.DHCANDeviceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

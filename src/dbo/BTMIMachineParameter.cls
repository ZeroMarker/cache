/// 检验仪器
Class dbo.BTMIMachineParameter Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineParameter, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexDeviceCode On (HospitalDR, DeviceCode) [ SqlName = Index_DeviceCode, Type = index ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexWorkGroupMachine On WorkGroupMachineDR [ SqlName = Index_WorkGroupMachine, Type = index ];

/// DDL Primary Key Specification
Index PKBTMIMACHINEPARAMETER On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINEPARAMETER, Type = index, Unique ];

/// Foreign Key FKMachineDevice created via DDL
ForeignKey FKMachineDevice(RegisterDeviceDR) References dbo.BTRegisterDevice(PKBTREGISTERDEVICE) [ SqlName = FK_MachineDevice ];

/// Foreign Key FKMachineHospital created via DDL
ForeignKey FKMachineHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_MachineHospital ];

/// Foreign Key FKMachineRoom created via DDL
ForeignKey FKMachineRoom(RoomDR) References dbo.BTRoom(PKBTROOM) [ SqlName = FK_MachineRoom ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKMachineWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineWorkGroup ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 全称  
Property LName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 房间  
Property RoomDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 设备  
Property RegisterDeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// IP地址  
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 端口号  
Property PortNo As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 11 ];

/// 通讯方式  
Property CommDirection As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 12 ];

/// 项目分隔符  
Property DelimiterForTests As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

/// 结果分隔符  
Property DelimiterForResults As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 14 ];

/// DelimiterForAnt  
Property DelimiterForAnt As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// DelimiterForSen  
Property DelimiterForSen As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 16 ];

/// 接口程序  
Property IFProgram As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 17 ];

/// 串口号  
Property ComPort As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 波特率  
Property BaudRate As %Library.String(COLLATION = "Exact", MAXLEN = 6) [ SqlColumnNumber = 19 ];

/// 数据位  
Property DataBits As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 20 ];

/// 停止位  
Property StopBits As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 21 ];

/// 校验位  
Property Parity As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 22 ];

/// 仪器对照码  
Property DeviceCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 23 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 状态  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 25 ];

/// IsStart  {1:true,0:false}
Property IsStart As %Library.Boolean [ SqlColumnNumber = 26 ];

/// OpMessage  
Property OpMessage As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 27 ];

/// JobID  
Property JobID As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 28 ];

/// Serialnumber  
Property Serialnumber As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 29 ];

/// LicenseKey  
Property LicenseKey As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 30 ];

/// 查看质控图类型  {0:L-J图,1:Z分数图,2:WestGard图}
Property ViewQcMap As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 31 ];

/// 是否发送危机值  {1:true,0:false}
Property IsSendPanic As %Library.Boolean [ SqlColumnNumber = 32 ];

/// 自动接收用户      
Property AutoAcceptUserDR As %Library.Integer [ SqlColumnNumber = 33 ];

/// 自动初审用户      
Property AutoEntryUserDR As %Library.Integer [ SqlColumnNumber = 34 ];

/// 自动审核用户    
Property AutoAuthUserDR As %Library.Integer [ SqlColumnNumber = 35 ];

/// 是否转换流水号  {1:true,0:false}
Property IsChgTranEpis As %Library.Integer [ SqlColumnNumber = 36 ];

/// 关联工作组小组  
Property LinkWGMachines As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 37 ];

/// 启动地址  
Property StartWebService As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 38 ];

/// 最后启动IP  
Property LastStartIP As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 39 ];

/// 自动发送临时报告
Property AutoSendMidReport As %Library.Boolean [ SqlColumnNumber = 40 ];

/// 是否上传已上机状态项目
Property IsAllowScanedTC As %Library.Boolean [ SqlColumnNumber = 41 ];

/// 是标识暂存，否或者空直接存入仪器结果表
Property IsTempSave As %Library.Boolean [ SqlColumnNumber = 42 ];

/// 仪器核收开始流水号  
Property EpisNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 43 ];

Storage Default
{
<Data name="BTMIMachineParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>LName</Value>
</Value>
<Value name="6">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="7">
<Value>RoomDR</Value>
</Value>
<Value name="8">
<Value>RegisterDeviceDR</Value>
</Value>
<Value name="9">
<Value>IPAddress</Value>
</Value>
<Value name="10">
<Value>PortNo</Value>
</Value>
<Value name="11">
<Value>CommDirection</Value>
</Value>
<Value name="12">
<Value>DelimiterForTests</Value>
</Value>
<Value name="13">
<Value>DelimiterForResults</Value>
</Value>
<Value name="14">
<Value>DelimiterForAnt</Value>
</Value>
<Value name="15">
<Value>DelimiterForSen</Value>
</Value>
<Value name="16">
<Value>IFProgram</Value>
</Value>
<Value name="17">
<Value>ComPort</Value>
</Value>
<Value name="18">
<Value>BaudRate</Value>
</Value>
<Value name="19">
<Value>DataBits</Value>
</Value>
<Value name="20">
<Value>StopBits</Value>
</Value>
<Value name="21">
<Value>Parity</Value>
</Value>
<Value name="22">
<Value>DeviceCode</Value>
</Value>
<Value name="23">
<Value>Sequence</Value>
</Value>
<Value name="24">
<Value>Active</Value>
</Value>
<Value name="25">
<Value>IsStart</Value>
</Value>
<Value name="26">
<Value>OpMessage</Value>
</Value>
<Value name="27">
<Value>JobID</Value>
</Value>
<Value name="28">
<Value>Serialnumber</Value>
</Value>
<Value name="29">
<Value>LicenseKey</Value>
</Value>
<Value name="30">
<Value>ViewQcMap</Value>
</Value>
<Value name="31">
<Value>IsSendPanic</Value>
</Value>
<Value name="32">
<Value>AutoAcceptUserDR</Value>
</Value>
<Value name="33">
<Value>AutoEntryUserDR</Value>
</Value>
<Value name="34">
<Value>AutoAuthUserDR</Value>
</Value>
<Value name="35">
<Value>IsChgTranEpis</Value>
</Value>
<Value name="36">
<Value>LinkWGMachines</Value>
</Value>
<Value name="37">
<Value>StartWebService</Value>
</Value>
<Value name="38">
<Value>LastStartIP</Value>
</Value>
<Value name="39">
<Value>AutoSendMidReport</Value>
</Value>
<Value name="40">
<Value>IsAllowScanedTC</Value>
</Value>
<Value name="41">
<Value>IsTempSave</Value>
</Value>
<Value name="42">
<Value>EpisNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineParameterD</DataLocation>
<DefaultData>BTMIMachineParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineParameterD</IdLocation>
<IndexLocation>^dbo.BTMIMachineParameterI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

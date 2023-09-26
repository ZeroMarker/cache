/// BTFridge
Class dbo.BTFridge Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Fridge, StorageStrategy = Default ]
{

/// Foreign Key FKFridgeDevice created via DDL
ForeignKey FKFridgeDevice(DeviceDR) References dbo.BTDevice(PKBTDEVICE) [ SqlName = FK_FridgeDevice ];

/// Foreign Key FKFridgeHospital created via DDL
ForeignKey FKFridgeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_FridgeHospital ];

/// Foreign Key FKFridgeRoom created via DDL
ForeignKey FKFridgeRoom(RoomDR) References dbo.BTRoom(PKBTROOM) [ SqlName = FK_FridgeRoom ];

/// Foreign Key FKTempDeviceWorkGroup created via DDL
ForeignKey FKFridgeWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_FridgeWorkGroup ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKBTFRIDGE On RowID [ PrimaryKey, SqlName = PK_BT_FRIDGE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 层数  
Property Layers As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 设备  
Property DeviceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 房间  
Property RoomDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 标本类型  
Property SpecType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 11 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BTFridgeDefaultData">
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
<Value>Layers</Value>
</Value>
<Value name="6">
<Value>DeviceDR</Value>
</Value>
<Value name="7">
<Value>RoomDR</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>SpecType</Value>
</Value>
<Value name="11">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFridgeD</DataLocation>
<DefaultData>BTFridgeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTFridgeD</IdLocation>
<IndexLocation>^dbo.BTFridgeI</IndexLocation>
<StreamLocation>^dbo.BTFridgeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

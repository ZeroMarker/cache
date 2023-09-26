/// 仪器图片结果
Class dbo.RPMachineImage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_MachineImage, StorageStrategy = Default ]
{

/// Foreign Key FKMachineImageMachine created via DDL
ForeignKey FKMachineImageMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineImageMachine ];

/// Foreign Key FKMachineImageWGMachine created via DDL
ForeignKey FKMachineImageWGMachine(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_MachineImageWGMachine ];

Index IndexMaster On (WorkGroupMachineDR, ReceiveDate, AssayNo, ImageClass, ImageOrder) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAssayNo On (AssayNo, WorkGroupMachineDR, ImageClass, ImageOrder) [ SqlName = Index_AssayNo, Type = index ];

/// DDL Primary Key Specification
Index PKRPMACHINEIMAGE On RowID [ PrimaryKey, SqlName = PK_RP_MACHINEIMAGE, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 检测号  
Property AssayNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 5 ];

/// 图像类别  
Property ImageClass As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 6 ];

/// 图像序号  
Property ImageOrder As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 文件名称  
Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 8 ];

/// 检测仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 图像  
Property Caption As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 显示系数  
Property DisplayRatio As %Library.Float [ SqlColumnNumber = 11 ];

/// 高度  
Property Height As %Library.Float [ SqlColumnNumber = 12 ];

/// 宽度  
Property Width As %Library.Float [ SqlColumnNumber = 13 ];

/// 显示序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="RPMachineImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="3">
<Value>ReceiveDate</Value>
</Value>
<Value name="4">
<Value>AssayNo</Value>
</Value>
<Value name="5">
<Value>ImageClass</Value>
</Value>
<Value name="6">
<Value>ImageOrder</Value>
</Value>
<Value name="7">
<Value>FileName</Value>
</Value>
<Value name="8">
<Value>MachineParameterDR</Value>
</Value>
<Value name="9">
<Value>Caption</Value>
</Value>
<Value name="10">
<Value>DisplayRatio</Value>
</Value>
<Value name="11">
<Value>Height</Value>
</Value>
<Value name="12">
<Value>Width</Value>
</Value>
<Value name="13">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMachineImageD</DataLocation>
<DefaultData>RPMachineImageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPMachineImageD</IdLocation>
<IndexLocation>^dbo.RPMachineImageI</IndexLocation>
<StreamLocation>^dbo.RPMachineImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

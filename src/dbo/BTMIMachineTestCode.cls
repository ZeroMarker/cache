/// 仪器关联项目
Class dbo.BTMIMachineTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineTestCode, StorageStrategy = Default ]
{

Index IndexMaster On (MachineParameterDR, TestCodeDR, ResultChannel) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexResultChannel On (MachineParameterDR, ResultChannel) [ SqlName = Index_ResultChannel, Type = index ];

Index IndexUPChannel On (MachineParameterDR, TestCodeDR, UPChannel) [ SqlName = Index_UPChannel, Type = index ];

/// DDL Primary Key Specification
Index PKBTMIMACHINETESTCODE On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINETESTCODE, Type = index, Unique ];

/// Foreign Key FKMachineTestCode created via DDL
ForeignKey FKMachineTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineTestCode ];

/// Foreign Key FKMachineTestCodeMach created via DDL
ForeignKey FKMachineTestCodeMach(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineTestCodeMach ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 上传通道号  
Property UPChannel As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5 ];

/// 结果通道号  
Property ResultChannel As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 6 ];

/// 备注  
Property Scale As %Library.Float [ SqlColumnNumber = 7 ];

/// 激活状态  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 是否排除质控  {1:true,0:false}
Property IsNotQC As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 1:定量,2:定性 
Property QCType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="BTMIMachineTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineParameterDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>UPChannel</Value>
</Value>
<Value name="5">
<Value>ResultChannel</Value>
</Value>
<Value name="6">
<Value>Scale</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>IsNotQC</Value>
</Value>
<Value name="9">
<Value>QCType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineTestCodeD</DataLocation>
<DefaultData>BTMIMachineTestCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineTestCodeD</IdLocation>
<IndexLocation>^dbo.BTMIMachineTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

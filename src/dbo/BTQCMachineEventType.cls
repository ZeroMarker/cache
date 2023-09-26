Class dbo.BTQCMachineEventType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_MachineEventType ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTQCMACHINEEVENTTYPE On RowID [ PrimaryKey, SqlName = PK_BT_QCMACHINEEVENTTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 编码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 4 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTQCMachineEventTypeDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCMachineEventTypeD</DataLocation>
<DefaultData>BTQCMachineEventTypeDefaultData</DefaultData>
<IdLocation>^dbo.BTQCMachineEventTypeD</IdLocation>
<IndexLocation>^dbo.BTQCMachineEventTypeI</IndexLocation>
<StreamLocation>^dbo.BTQCMachineEventTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

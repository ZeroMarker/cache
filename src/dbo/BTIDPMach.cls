/// 鉴定仪器
Class dbo.BTIDPMach Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTIDP_Mach ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// Foreign Key FKBTIDPMachMachineParameterDR created via DDL
ForeignKey FKBTIDPMachMachineParameterDR(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTIDPMachMachineParameterDR ];

/// DDL Primary Key Specification
Index PKBTIDPMACH On RowID [ PrimaryKey, SqlName = PK_BTIDP_MACH, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 4 ];

/// 检验仪器
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTIDPMachDefaultData">
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
<Value>MachineParameterDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.BTIDPMachD</DataLocation>
<DefaultData>BTIDPMachDefaultData</DefaultData>
<IdLocation>^dbo.BTIDPMachD</IdLocation>
<IndexLocation>^dbo.BTIDPMachI</IndexLocation>
<StreamLocation>^dbo.BTIDPMachS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

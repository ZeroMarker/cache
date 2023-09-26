/// 系统参数 
Class dbo.SYSParameter Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_Parameter, StorageStrategy = Default ]
{

Index IndexCode On (Code, ParaType, ParaTypeCode) [ SqlName = Index_Code, Type = index ];

Index IndexSequence On Sequence [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKSYSPARAMETER On RowID [ PrimaryKey, SqlName = PK_SYS_PARAMETER, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 类型 {"SYS":"SYS","HOS":"HOS","WG":"WG","WGM":"WGM","LOC":"LOC","USR":"USR"}
Property ParaType As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 类型对象代码
Property ParaTypeCode As %Library.String(MAXLEN = 50) [ Required, SqlColumnNumber = 5 ];

/// 值
Property ParaValue As %Library.String(MAXLEN = 4000) [ SqlColumnNumber = 6 ];

/// 值域
Property ParaList As %Library.String(MAXLEN = 8000) [ SqlColumnNumber = 7 ];

/// 描述
Property Description As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 系统参数组
Property ParaGroup As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="SYSParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ParaType</Value>
</Value>
<Value name="4">
<Value>ParaTypeCode</Value>
</Value>
<Value name="5">
<Value>ParaValue</Value>
</Value>
<Value name="6">
<Value>ParaList</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>ParaGroup</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSParameterD</DataLocation>
<DefaultData>SYSParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSParameterD</IdLocation>
<IndexLocation>^dbo.SYSParameterI</IndexLocation>
<StreamLocation>^dbo.SYSParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

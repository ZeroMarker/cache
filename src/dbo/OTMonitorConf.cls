/// 监听配置
Class dbo.OTMonitorConf Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_MonitorConf, StorageStrategy = Default ]
{

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSPARAMETER On RowID [ PrimaryKey, SqlName = PK_SYS_PARAMETER, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 配置串  
Property ParaList As %Library.String(COLLATION = "Exact", MAXLEN = 8000) [ SqlColumnNumber = 4 ];

/// 描述  
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 5 ];

///       
Property Manufacturers As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

///       
Property Model As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

///       
Property InterfaceType As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 8 ];

///       
Property InterfaceDoc As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="OTMonitorConfDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>ParaList</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Manufacturers</Value>
</Value>
<Value name="6">
<Value>Model</Value>
</Value>
<Value name="7">
<Value>InterfaceType</Value>
</Value>
<Value name="8">
<Value>InterfaceDoc</Value>
</Value>
</Data>
<DataLocation>^dbo.OTMonitorConfD</DataLocation>
<DefaultData>OTMonitorConfDefaultData</DefaultData>
<IdLocation>^dbo.OTMonitorConfD</IdLocation>
<IndexLocation>^dbo.OTMonitorConfI</IndexLocation>
<StreamLocation>^dbo.OTMonitorConfS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

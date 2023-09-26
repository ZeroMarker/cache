Class User.DHCCLCLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = CLCLOG_RowId, SqlTableName = DHC_CLC_Log, StorageStrategy = CacheStorage ]
{

Property CLCLOGCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLCLOG_Code ];

Property CLCLOGDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLCLOG_Desc ];

Property CLCLOGType As %String(DISPLAYLIST = ",AN,ICU", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A,I") [ SqlColumnNumber = 4, SqlFieldName = CLCLOG_Type ];

Property CLCLOGValueList As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CLCLOG_ValueList ];

Property CLCLOGValueListDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CLCLOG_ValueListDesc ];

Property CLCLOGIfAddInfo As %Boolean [ SqlColumnNumber = 7, SqlFieldName = CLCLOG_IfAddInfo ];

Property CLCLOGDefault As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CLCLOG_Default ];

Property CLCLOGSortNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CLCLOG_SortNo ];

Storage CacheStorage
{
<Data name="DHCCLCLogClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="DHCCLCLogDefaultData">
<Value name="1">
<Value>CLCLOGCode</Value>
</Value>
<Value name="2">
<Value>CLCLOGDesc</Value>
</Value>
<Value name="3">
<Value>CLCLOGType</Value>
</Value>
<Value name="4">
<Value>CLCLOGValueList</Value>
</Value>
<Value name="5">
<Value>CLCLOGValueListDesc</Value>
</Value>
<Value name="6">
<Value>CLCLOGIfAddInfo</Value>
</Value>
<Value name="7">
<Value>CLCLOGDefault</Value>
</Value>
<Value name="8">
<Value>CLCLOGSortNo</Value>
</Value>
</Data>
<DataLocation>^DHCCLC("Log")</DataLocation>
<DefaultData>DHCCLCLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLC("Log")</IdLocation>
<IndexLocation>^DHCCLCI("Log")</IndexLocation>
<SqlRowIdName>CLCLOG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCCLCLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

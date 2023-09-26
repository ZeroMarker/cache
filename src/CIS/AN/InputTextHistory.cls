Class CIS.AN.InputTextHistory Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = InputTextHistory ]
{

/// 模块
Property DataModule As CT.AN.DataModule [ Required, SqlColumnNumber = 2 ];

/// 字段
Property Field As %String [ Required, SqlColumnNumber = 3 ];

/// 文字描述
Property Text As %String [ Required, SqlColumnNumber = 4 ];

/// 计数
Property Counter As %Integer [ SqlColumnNumber = 5 ];

/// 数据模块索引
Index IModule On DataModule;

/// 模块字段索引
Index IModuleField On (DataModule, Field);

/// 数据模块、字段、文字描述索引
Index IModuleText On (DataModule, Field, Text);

Storage Default
{
<Data name="InputTextHistoryDefaultData">
<Value name="1">
<Value>DataModule</Value>
</Value>
<Value name="2">
<Value>Field</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
<Value name="4">
<Value>Counter</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.InputTextHistoryD</DataLocation>
<DefaultData>InputTextHistoryDefaultData</DefaultData>
<IdLocation>^CIS.AN.InputTextHistoryD</IdLocation>
<IndexLocation>^CIS.AN.InputTextHistoryI</IndexLocation>
<StreamLocation>^CIS.AN.InputTextHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

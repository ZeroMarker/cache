/// 打印模板
Class CT.AN.PrintTemplate Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PrintTemplate ]
{

/// 数据模块
Property DataModule As CT.AN.DataModule [ Required, SqlColumnNumber = 2 ];

Property JSONData As %String(MAXLEN = 1000000) [ SqlColumnNumber = 3 ];

Property UpdateUser As %String [ SqlColumnNumber = 4 ];

Property UpdateDate As %Date [ SqlColumnNumber = 5 ];

Property UpdateTime As %Time [ SqlColumnNumber = 6 ];

Property JSONDataStream As %GlobalCharacterStream(LOCATION = "^CT.AN.PrintTemplateS") [ SqlColumnNumber = 7 ];

Property JScriptData As %GlobalCharacterStream(LOCATION = "^CT.AN.PrintTemplateS") [ SqlColumnNumber = 8 ];

Index IDataModule On DataModule;

/// 数据项外键约束
ForeignKey FKDataModule(DataModule) References CT.AN.DataModule() [ OnDelete = cascade ];

Storage Default
{
<Data name="PrintTemplateDefaultData">
<Value name="1">
<Value>DataModule</Value>
</Value>
<Value name="2">
<Value>JSONData</Value>
</Value>
<Value name="3">
<Value>UpdateUser</Value>
</Value>
<Value name="4">
<Value>UpdateDate</Value>
</Value>
<Value name="5">
<Value>UpdateTime</Value>
</Value>
<Value name="6">
<Value>JSONDataStream</Value>
</Value>
<Value name="7">
<Value>JScriptData</Value>
</Value>
</Data>
<DataLocation>^CT.AN.PrintTemplateD</DataLocation>
<DefaultData>PrintTemplateDefaultData</DefaultData>
<IdLocation>^CT.AN.PrintTemplateD</IdLocation>
<IndexLocation>^CT.AN.PrintTemplateI</IndexLocation>
<StreamLocation>^CT.AN.PrintTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

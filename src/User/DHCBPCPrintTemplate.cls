/// 血透表单模板
Class User.DHCBPCPrintTemplate Extends %Library.Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_BPC_PrintTemplate ]
{

/// 数据模块
Property DataModule As User.DHCBPCModule [ Required, SqlColumnNumber = 2 ];

Property JSONData As %String(MAXLEN = 1000000) [ SqlColumnNumber = 3 ];

Property UpdateUser As %String [ SqlColumnNumber = 4 ];

Property UpdateDate As %Date [ SqlColumnNumber = 5 ];

Property UpdateTime As %Time [ SqlColumnNumber = 6 ];

Property JSONDataStream As %GlobalCharacterStream(LOCATION = "^User.DHCBPCPrintTemplateS") [ SqlColumnNumber = 7 ];

Property JScriptData As %GlobalCharacterStream(LOCATION = "^User.DHCBPCPrintTemplateS") [ SqlColumnNumber = 8 ];

Index IDataModule On DataModule;

/// 数据项外键约束
ForeignKey FKDataModule(DataModule) References User.DHCBPCModule() [ OnDelete = cascade ];

Storage Default
{
<Data name="DHCBPCPrintTemplateDefaultData">
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
<DataLocation>^User.DHCBPCPrintTemplateD</DataLocation>
<DefaultData>DHCBPCPrintTemplateDefaultData</DefaultData>
<IdLocation>^User.DHCBPCPrintTemplateD</IdLocation>
<IndexLocation>^User.DHCBPCPrintTemplateI</IndexLocation>
<StreamLocation>^User.DHCBPCPrintTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

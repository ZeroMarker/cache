/// 重症功能模块
Class User.DHCICUCModule Extends %Library.Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICUC_Module ]
{

Property Code As %String [ Required, SqlColumnNumber = 2 ];

Property Description As %String [ Required, SqlColumnNumber = 3 ];

Property Url As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

Property Icon As %String [ SqlColumnNumber = 5 ];

Property Params As %String(MAXLEN = 500) [ SqlColumnNumber = 6 ];

Property Active As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

Property ParentModule As User.DHCICUCModule [ SqlColumnNumber = 8 ];

Property SeqNo As %Integer [ SqlColumnNumber = 9 ];

Index ICode On Code [ Unique ];

Storage Default
{
<Data name="DHCICUCModuleDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Url</Value>
</Value>
<Value name="4">
<Value>Icon</Value>
</Value>
<Value name="5">
<Value>Params</Value>
</Value>
<Value name="6">
<Value>ArchiveCode</Value>
</Value>
<Value name="7">
<Value>ParentModule</Value>
</Value>
<Value name="8">
<Value>SeqNo</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCModuleD</DataLocation>
<DefaultData>DHCICUCModuleDefaultData</DefaultData>
<IdLocation>^User.DHCICUCModuleD</IdLocation>
<IndexLocation>^User.DHCICUCModuleI</IndexLocation>
<StreamLocation>^User.DHCICUCModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

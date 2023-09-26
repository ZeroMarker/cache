/// 表单记录版本
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormRecordVersion Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormRecordVersion ]
{

Property parrRef As User.DHCAdvFormRecord [ SqlColumnNumber = 2, SqlFieldName = parrRef ];

Property version As %String [ SqlColumnNumber = 3, SqlFieldName = version ];

Property formName As User.DHCAdvFormName [ SqlColumnNumber = 4, SqlFieldName = formName ];

Storage Default
{
<Data name="DHCAdvFormRecordVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>parrRef</Value>
</Value>
<Value name="3">
<Value>version</Value>
</Value>
<Value name="4">
<Value>formName</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormRecordVersionD</DataLocation>
<DefaultData>DHCAdvFormRecordVersionDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormRecordVersionD</IdLocation>
<IndexLocation>^User.DHCAdvFormRecordVersionI</IndexLocation>
<StreamLocation>^User.DHCAdvFormRecordVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexRecordForm On (parrRef, formName);

}

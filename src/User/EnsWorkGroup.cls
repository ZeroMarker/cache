Class User.EnsWorkGroup Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_WorkGroup ]
{

Index workGroupCodeIndex On workGroupCode;

Index workGroupDescIndex On workGroupDesc;

/// 系统代码
Property workGroupCode As %String(COLLATION = "EXACT", MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = workGroup_Code ];

/// 系统描述
Property workGroupDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = workGroup_Desc ];

Storage Default
{
<Data name="EnsWorkGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>workGroupCode</Value>
</Value>
<Value name="3">
<Value>workGroupDesc</Value>
</Value>
</Data>
<DataLocation>^Code.ENS.EnsWorkGroupD</DataLocation>
<DefaultData>EnsWorkGroupDefaultData</DefaultData>
<IdLocation>^Code.ENS.EnsWorkGroupD</IdLocation>
<IndexLocation>^Code.ENS.EnsWorkGroupI</IndexLocation>
<StreamLocation>^Code.ENS.EnsWorkGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

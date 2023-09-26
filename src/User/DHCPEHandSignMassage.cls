Class User.DHCPEHandSignMassage Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPEHandSignMassage";

/// 代码
Property Code As %String;

/// 标题
Property Title As %String;

/// 内容
Property Massage As %String(MAXLEN = 999999);

/// 代码 ID对应的索引
Index CodeIndex On Code As AlphaUp;

Storage Default
{
<Data name="DHCPEHandSignMassageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Massage</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEHandSignMassageD</DataLocation>
<DefaultData>DHCPEHandSignMassageDefaultData</DefaultData>
<IdLocation>^User.DHCPEHandSignMassageD</IdLocation>
<IndexLocation>^User.DHCPEHandSignMassageI</IndexLocation>
<StreamLocation>^User.DHCPEHandSignMassageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

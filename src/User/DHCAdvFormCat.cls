/// 表单分类表
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormCat Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormCat ]
{

// 表单分类code 

Property code As %String [ SqlColumnNumber = 2, SqlFieldName = code ];

// 表单分类名称

Property name As %String [ SqlColumnNumber = 3, SqlFieldName = name ];

// 医院

Property hospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = hospDr ];

Storage Default
{
<Data name="DHCAdvFormCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>code</Value>
</Value>
<Value name="3">
<Value>name</Value>
</Value>
<Value name="4">
<Value>hospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormCatD</DataLocation>
<DefaultData>DHCAdvFormCatDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormCatD</IdLocation>
<IndexLocation>^User.DHCAdvFormCatI</IndexLocation>
<StreamLocation>^User.DHCAdvFormCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexCode On code As AlphaUp;

}

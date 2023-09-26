/// 表单名称表
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormName Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormName ]
{

// 表单code

Property code As %String;

// 表单名称

Property name As %String;

// 表单版本号

Property version As %String;

// 表单引用js

Property jsPath As %String;

// 表单类型

// Y:表单

// 其他:布局表单

Property type As %String;

// 表单分类

Property cat As User.DHCAdvFormCat;

// 是否可用

Property active As %String;

// 表单全局宽度

Property width As %String;

// 医院

Property hospdr As User.CTHospital;

/// code索引
Index IndexCode On code As AlphaUp;

Storage Default
{
<Data name="DHCAdvFormNameDefaultData">
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
<Value>version</Value>
</Value>
<Value name="5">
<Value>jsPath</Value>
</Value>
<Value name="6">
<Value>type</Value>
</Value>
<Value name="7">
<Value>cat</Value>
</Value>
<Value name="8">
<Value>active</Value>
</Value>
<Value name="9">
<Value>width</Value>
</Value>
<Value name="10">
<Value>hospdr</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormNameD</DataLocation>
<DefaultData>DHCAdvFormNameDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormNameD</IdLocation>
<IndexLocation>^User.DHCAdvFormNameI</IndexLocation>
<StreamLocation>^User.DHCAdvFormNameS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// 分类索引
Index IndexCat On cat;

}

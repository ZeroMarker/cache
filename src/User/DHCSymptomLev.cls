/// 名称: DHC_SymptomLev
/// 描述: 症状分级表
/// 编写者：谷雪萍
/// 编写日期: 2016-05-13
Class User.DHCSymptomLev Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = DHC_SymptomLev ]
{

Property SYLCode As %String(MAXLEN = 200);

Property SYLDesc As %String(MAXLEN = 200);

/// 父节点
Property SYLLastRowid As User.DHCSymptomLev;

/// 级别 0是根目录，1,一级，2二级,3三级
Property SYLLevel As %String;

/// 顺序
Property SYLSequence As %String;

Index CodeIndex On SYLCode [ Unique ];

Index DescIndex On SYLDesc [ Unique ];

Index ParIdx On SYLLastRowid;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (SYLLastRowid, SYLSequence);

/// 父菜单+级别生成的索引
Index ParLevIdx On (SYLLastRowid, SYLLevel);

Storage Default
{
<Data name="DHCSymptomLevDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SYLCode</Value>
</Value>
<Value name="3">
<Value>SYLDesc</Value>
</Value>
<Value name="4">
<Value>SYLLastRowid</Value>
</Value>
<Value name="5">
<Value>SYLLevel</Value>
</Value>
<Value name="6">
<Value>SYLSequence</Value>
</Value>
</Data>
<DataLocation>^User.DHCSymptomLevD</DataLocation>
<DefaultData>DHCSymptomLevDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCSymptomLevD</IdLocation>
<IndexLocation>^User.DHCSymptomLevI</IndexLocation>
<StreamLocation>^User.DHCSymptomLevS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

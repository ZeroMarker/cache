/// 名称:	CT.EMR.DOC.Tooth
/// 描述:	牙码表
/// 编写者：yejian
/// 编写日期: 2023-3-21
/// 产品组：电子病历产品组
Class CT.EMR.DOC.Tooth Extends %Persistent
{

Index IdxCode On Code;

Index IdxType On Type;

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙类型(Permanent:恒牙，Deciduous:乳牙)
Property Type As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙类型描述
Property TypeDes As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="ToothDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>TypeDes</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.ToothD</DataLocation>
<DefaultData>ToothDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.ToothD</IdLocation>
<IndexLocation>^CT.EMR.DOC.ToothI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.ToothS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

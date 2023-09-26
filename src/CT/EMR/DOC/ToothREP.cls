/// 名称:	CT.EMR.DOC.ToothREP
/// 描述:	牙位表示法表
/// 编写者：yejian
/// 编写日期: 2021-10-11
/// 产品组：电子病历产品组
Class CT.EMR.DOC.ToothREP Extends %Persistent
{

Index IdxCode On Code;

/// 代码
Property Code As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准代码
Property SystemCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准名称
Property SystemName As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="ToothREPDefaultData">
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
<Value>SystemCode</Value>
</Value>
<Value name="5">
<Value>SystemName</Value>
</Value>
</Data>
<DataLocation>^CT.EMR.DOC.ToothREPD</DataLocation>
<DefaultData>ToothREPDefaultData</DefaultData>
<IdLocation>^CT.EMR.DOC.ToothREPD</IdLocation>
<IndexLocation>^CT.EMR.DOC.ToothREPI</IndexLocation>
<StreamLocation>^CT.EMR.DOC.ToothREPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

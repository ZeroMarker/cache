/// 名称: EMRmeta.ToothRepresentItem
/// 描述: 牙位对应不同标识法的标识
/// 编写者：yn
/// 编写日期: 2020-7-22
Class EMRmeta.ToothRepresentItem Extends %Persistent
{

Index IdxRepresent On ToothRepresent;

/// 牙位代码
Property ToothPCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙位标识
Property ToothPDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙象限
Property ToothPQuadrant As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙位标识法
Property ToothRepresent As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="ToothRepresentItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ToothPCode</Value>
</Value>
<Value name="3">
<Value>ToothPDes</Value>
</Value>
<Value name="4">
<Value>ToothPQuadrant</Value>
</Value>
<Value name="5">
<Value>ToothRepresent</Value>
</Value>
</Data>
<DataLocation>^EMRmeta.ToothRepresentItemD</DataLocation>
<DefaultData>ToothRepresentItemDefaultData</DefaultData>
<IdLocation>^EMRmeta.ToothRepresentItemD</IdLocation>
<IndexLocation>^EMRmeta.ToothRepresentItemI</IndexLocation>
<StreamLocation>^EMRmeta.ToothRepresentItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

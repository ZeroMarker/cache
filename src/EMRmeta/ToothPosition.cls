/// 名称: 牙位表
/// 描述: 牙位表
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRmeta.ToothPosition Extends %Persistent
{

Index IdxCode On ToothPCode;

/// 代码
Property ToothPCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothPDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property ToothPDefine As %String(MAXLEN = 300, TRUNCATE = 1);

/// 牙象限
Property ToothPQuadrant As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型Permanent:恒牙，Deciduous:乳牙
Property ToothType As %String(MAXLEN = 300, TRUNCATE = 1);

Storage Default
{
<Data name="ToothPositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Define</Value>
</Value>
<Value name="5">
<Value>ToothPCode</Value>
</Value>
<Value name="6">
<Value>ToothPDes</Value>
</Value>
<Value name="7">
<Value>ToothPDefine</Value>
</Value>
<Value name="8">
<Value>ToothType</Value>
</Value>
<Value name="9">
<Value>ToothPQuadrant</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ToothPositionD</DataLocation>
<DefaultData>ToothPositionDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ToothPositionD</IdLocation>
<IndexLocation>^DHCEMRM.ToothPositionI</IndexLocation>
<StreamLocation>^DHCEMRM.ToothPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

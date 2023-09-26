/// 名称: 牙面表
/// 描述: 牙面表
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRmeta.ToothSurfaceItem Extends %Persistent
{

Index IdxCode On ToothSICode;

Index IdxPCodeSICode On (ToothPCode, ToothSICode);

/// 牙位代码
Property ToothPCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 牙面代码
Property ToothSICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothSIDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property ToothSIDefine As %String(MAXLEN = 300, TRUNCATE = 1);

/// 上标：SuperScript，下标：SubScript
Property ScriptMode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型Permanent:恒牙，Deciduous:乳牙
Property ToothType As %String(MAXLEN = 300, TRUNCATE = 1);

Storage Default
{
<Data name="ToothSurfaceItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ToothPCode</Value>
</Value>
<Value name="3">
<Value>ToothSICode</Value>
</Value>
<Value name="4">
<Value>ToothSIDes</Value>
</Value>
<Value name="5">
<Value>ToothSIDefine</Value>
</Value>
<Value name="6">
<Value>ScriptMode</Value>
</Value>
<Value name="7">
<Value>ToothType</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ToothSurfaceItemD</DataLocation>
<DefaultData>ToothSurfaceItemDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ToothSurfaceItemD</IdLocation>
<IndexLocation>^DHCEMRM.ToothSurfaceItemI</IndexLocation>
<StreamLocation>^DHCEMRM.ToothSurfaceItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

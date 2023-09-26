/// 名称: 牙面表
/// 描述: 牙面表
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRmeta.ToothSurface Extends %Persistent
{

Index IdxCode On ToothSCode;

/// 代码
Property ToothSCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property ToothSDes As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property ToothSDefine As %String(MAXLEN = 300, TRUNCATE = 1);

Storage Default
{
<Data name="ToothSurfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ToothSCode</Value>
</Value>
<Value name="3">
<Value>ToothSDes</Value>
</Value>
<Value name="4">
<Value>ToothSDefine</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ToothSurfaceD</DataLocation>
<DefaultData>ToothSurfaceDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ToothSurfaceD</IdLocation>
<IndexLocation>^DHCEMRM.ToothSurfaceI</IndexLocation>
<StreamLocation>^DHCEMRM.ToothSurfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

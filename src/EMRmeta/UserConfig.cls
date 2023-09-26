/// Desc:       用户个性化配置表
/// Creator:    Candy
/// CreateDate: 2017-11-2
Class EMRmeta.UserConfig Extends (%Persistent, %XML.Adaptor)
{

Index UserLocTypeIndex On (UserID, LocID, Type) [ Unique ];

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property LocID As %String(TRUNCATE = 1);

/// 个性配置值
Property Config As %String(TRUNCATE = 1);

/// 配置类型
Property Type As %String(TRUNCATE = 1);

Storage Default
{
<Data name="UserConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>LocID</Value>
</Value>
<Value name="4">
<Value>Config</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.UserConfigD</DataLocation>
<DefaultData>UserConfigDefaultData</DefaultData>
<IdLocation>^DHCEMRM.UserConfigD</IdLocation>
<IndexLocation>^DHCEMRM.UserConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.UserConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Desc:       用户收藏夹目录
/// Creator:    Candy
/// CreateDate: 2014-11-20
Class EMRinstance.Favorites.FavUser Extends (%Persistent, %XML.Adaptor)
{

/// 用户ID
Property UserID As %String;

/// 用户代码
Property UserCode As %String;

/// 用户名称
Property UserName As %String;

/// 用户科室ID
Property UserLocID As %String;

/// 用户科室描述
Property UserLocDesc As %String;

/// 安全组
Property UserGorupID As %String;

/// 安全组描述
Property UserGorupDesc As %String;

/// 类型 Share/Private
Property Type As %String;

Index IdxUserID On UserID;

Index IdxType On Type;

Storage Default
{
<Data name="FavUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>UserCode</Value>
</Value>
<Value name="4">
<Value>UserName</Value>
</Value>
<Value name="5">
<Value>UserLocID</Value>
</Value>
<Value name="6">
<Value>UserLocDesc</Value>
</Value>
<Value name="7">
<Value>UserGorupID</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>UserGorupDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRF.FavUserD</DataLocation>
<DefaultData>FavUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRF.FavUserD</IdLocation>
<IndexLocation>^DHCEMRF.FavUserI</IndexLocation>
<StreamLocation>^DHCEMRF.FavUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

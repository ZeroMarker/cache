/// Desc:       用户收藏夹目录
/// Creator:    bianshuai
/// CreateDate: 2016-10-11
Class User.DHCPHFavUser Extends (%Persistent, %XML.Adaptor, User.Abstract)
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
<Value>UserGorupDesc</Value>
</Value>
<Value name="9">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCPHF.FavUserD</DataLocation>
<DefaultData>FavUserDefaultData</DefaultData>
<IdLocation>^DHCPHF.FavUserD</IdLocation>
<IndexLocation>^DHCPHF.FavUserI</IndexLocation>
<StreamLocation>^DHCPHF.FavUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

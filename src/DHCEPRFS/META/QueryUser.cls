/// Desc: 查询用户
Class DHCEPRFS.META.QueryUser Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 代码
Property UserCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 名称
Property UserName As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 密码
Property PassWord As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 是否可用
Property IsAvailable As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 有效开始时间
Property StartDate As %Date [ SqlColumnNumber = 6 ];

/// 有效结束时间
Property EndDate As %Date [ SqlColumnNumber = 7 ];

/// 类型，TEMP-临时，HIS-HIS用户
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

/// SSUser的ID
Property SSUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Index IdxTypeUserCode On (Type, UserCode);

Index IdxTypeUserName On (Type, UserName);

Index IdxTypeEndDate On (Type, EndDate);

Index IdxSSUserID On SSUserID;

Storage Default
{
<Data name="QueryUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>IsAvailable</Value>
</Value>
<Value name="4">
<Value>PassWord</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>UserCode</Value>
</Value>
<Value name="7">
<Value>UserName</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>SSUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserD</DataLocation>
<DefaultData>QueryUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

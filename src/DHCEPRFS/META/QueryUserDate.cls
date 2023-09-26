/// Desc: 查询日期
/// Creator:Candy
Class DHCEPRFS.META.QueryUserDate Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 开始日期
Property StartDate As %Date [ SqlColumnNumber = 2 ];

/// 结束时间
Property EndDate As %Date [ SqlColumnNumber = 3 ];

/// 查询用户ID
Property QueryUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 有无结束时间 Y或者空
Property NoExpirationDate As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Index IdxQueryUserID On QueryUserID;

Storage Default
{
<Data name="QueryUserDateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>QueryUserID</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>NoExpirationDate</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserDateD</DataLocation>
<DefaultData>QueryUserDateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserDateD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserDateI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserDateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

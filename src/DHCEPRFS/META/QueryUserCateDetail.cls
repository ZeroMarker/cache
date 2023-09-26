/// Desc:查询病历查看目录
/// Creaotr:Candy 
Class DHCEPRFS.META.QueryUserCateDetail Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 查询用户ID
Property QueryUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 归档病历大类ID
Property MRCategoryID As %String [ SqlColumnNumber = 3 ];

/// 归档病历子类ID
Property MRSubCateogryID As %String [ SqlColumnNumber = 4 ];

/// 病历项目ID
Property MRItemID As %String [ SqlColumnNumber = 5 ];

Index IdxQueryUserID On QueryUserID;

Storage Default
{
<Data name="QueryUserCateDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryUserID</Value>
</Value>
<Value name="3">
<Value>MRCategoryID</Value>
</Value>
<Value name="4">
<Value>MRSubCateogryID</Value>
</Value>
<Value name="5">
<Value>MRItemID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserCateDtD</DataLocation>
<DefaultData>QueryUserCateDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserCateDtD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserCateDtI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserCaDA41S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

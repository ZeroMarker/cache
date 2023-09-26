/// Desc:查询病历查看目录
/// Creaotr:Candy 
Class DHCEPRFS.META.QueryUserCate Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 代码 格式：目录#子目录#项目^目录#子目录#项目
Property CateCode As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 查询用户ID
Property QueryUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Index IdxQueryUserID On QueryUserID;

Storage Default
{
<Data name="QueryUserCateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CateCode</Value>
</Value>
<Value name="3">
<Value>QueryUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserCateD</DataLocation>
<DefaultData>QueryUserCateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserCateD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserCateI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserCateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

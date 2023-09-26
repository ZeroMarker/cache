/// Desc:病案号
/// Creator:Candy
Class DHCEPRFS.META.QueryUserMedNo Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 查看病案号 格式 MedNo1^MedNo2
Property MedNos As %String(MAXLEN = 200, TRUNCATE = 1);

/// 查询用户ID
Property QueryUserID As %String(TRUNCATE = 1);

Index IdxQueryUserID On QueryUserID;

Storage Default
{
<Data name="QueryUserMedNoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MedNos</Value>
</Value>
<Value name="3">
<Value>QueryUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserMedNoD</DataLocation>
<DefaultData>QueryUserMedNoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserMedNoD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserMedNoI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserMedNoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Desc:用户拥有的病案号权限表
/// Creator:杨鹏 
Class DHCEPRFS.META.QueryUserMedRecord Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 查询用户ID
Property QueryUserID As %String(TRUNCATE = 1);

/// 病案号
Property MedRecordNO As %String(TRUNCATE = 1);

Index IdxQueryUserID On QueryUserID;

Index IdxUnique On (QueryUserID, MedRecordNO) [ Unique ];

Storage Default
{
<Data name="QueryUserMedRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryUserID</Value>
</Value>
<Value name="3">
<Value>MedRecordNO</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserMedRcdD</DataLocation>
<DefaultData>QueryUserMedRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserMedRcdD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserMedRcdI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserMeA812S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class User.DHCCRMFUSGroup Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = SG_RowId, SqlTableName = DHC_CRM_FUSGroup ]
{

Parameter ClassName = "User.DHCCRMFUSGroup";

/// 主题问卷
Property SGSubjectDr As User.DHCCRMFUSubject [ SqlColumnNumber = 2, SqlFieldName = SG_Subject_Dr ];

/// 安全组
Property SGGroupDr As User.SSGroup [ SqlColumnNumber = 3, SqlFieldName = SG_Group_Dr ];

/// 可读
Property SGRead As %Library.String [ SqlColumnNumber = 4, SqlFieldName = SG_Read ];

/// 可写
Property SGWrite As %Library.String [ SqlColumnNumber = 5, SqlFieldName = SG_Write ];

Index SGSubjectIndex On SGSubjectDr;

Storage Default
{
<Data name="DHCCRMFUSGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SGSubjectDr</Value>
</Value>
<Value name="3">
<Value>SGGroupDr</Value>
</Value>
<Value name="4">
<Value>SGRead</Value>
</Value>
<Value name="5">
<Value>SGWrite</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMFUSGroupD</DataLocation>
<DefaultData>DHCCRMFUSGroupDefaultData</DefaultData>
<IdLocation>^User.DHCCRMFUSGroupD</IdLocation>
<IndexLocation>^User.DHCCRMFUSGroupI</IndexLocation>
<StreamLocation>^User.DHCCRMFUSGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

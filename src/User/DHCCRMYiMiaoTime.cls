Class User.DHCCRMYiMiaoTime Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = YMT_RowId, SqlTableName = DHC_CRM_YiMiaoTime ]
{

Relationship YMTParRef As User.DHCCRMYiMiaoRecord [ Cardinality = parent, Inverse = ChildDHCCRMYiMiaoTime ];

/// 更新人
Property YMTUpdateUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = YMT_UpdateUserDR ];

/// 更新日期
Property YMTUpdateDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = YMT_UpdateDate ];

/// 下次日期
Property YMTNextDate As %Library.Date [ SqlColumnNumber = 5, SqlFieldName = YMT_NextDate ];

Storage Default
{
<Data name="DHCCRMYiMiaoTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>YMTUpdateUserDR</Value>
</Value>
<Value name="3">
<Value>YMTUpdateDate</Value>
</Value>
<Value name="4">
<Value>YMTNextDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCCRMYiMiaoTime")</DataLocation>
<DefaultData>DHCCRMYiMiaoTimeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCCRMYiMiaoRecordC("ChildDHCCRMYiMiaoTime")</IdLocation>
<IndexLocation>^User.DHCCRMYiMiaoTimeI</IndexLocation>
<StreamLocation>^User.DHCCRMYiMiaoTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

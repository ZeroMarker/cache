/// 问卷量表（主题）定义
Class User.DHCHMCQDSubject Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CQDSubject ]
{

Parameter ClassName = "User.DHCHMCQDSubject";

Relationship ChildDtl As User.DHCHMCQDSubjectDtl [ Cardinality = children, Inverse = QDSDParRef ];

Relationship ChildCat As User.DHCHMCQDSubjectCat [ Cardinality = children, Inverse = QDSCParRef ];

/// 编码
Property QDSCode As %String [ Required, SqlFieldName = QDS_Code ];

/// 描述
Property QDSDesc As %String(MAXLEN = 300) [ Required, SqlFieldName = QDS_Desc ];

/// 激活
Property QDSActive As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ Required, SqlFieldName = QDS_Active ];

/// 更新日期
Property QDSUpdateDate As %Date [ SqlFieldName = QDS_UpdateDate ];

/// 更新时间
Property QDSUpdateTime As %Time [ SqlFieldName = QDS_UpdateTime ];

/// 更新人 指向SS_User
Property QDSUpdateUserDR As %String [ SqlFieldName = QDS_UpdateUser_DR ];

/// 备注信息
Property QDSRemark As %String(MAXLEN = 200) [ SqlFieldName = QDS_Remark ];

Index IndexCode On QDSCode [ Unique ];

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QDSCode</Value>
</Value>
<Value name="3">
<Value>QDSDesc</Value>
</Value>
<Value name="4">
<Value>QDSActive</Value>
</Value>
<Value name="5">
<Value>QDSUpdateDate</Value>
</Value>
<Value name="6">
<Value>QDSUpdateTime</Value>
</Value>
<Value name="7">
<Value>QDSUpdateUserDR</Value>
</Value>
<Value name="8">
<Value>QDSRemark</Value>
</Value>
</Data>
<DataLocation>^CT.PE.HM.CQDSubjectD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.PE.HM.CQDSubjectD</IdLocation>
<IndexLocation>^CT.PE.HM.CQDSubjectI</IndexLocation>
<StreamLocation>^User.DHCHMCQDSubjectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

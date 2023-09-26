/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断就诊表
/// Table：User.SDSAdm
Class User.SDSAdm Extends (%Persistent, User.Abstract) [ SqlRowIdName = SDSADM_RowId, SqlTableName = SDS_Adm ]
{

/// 就诊号
Property SDSADMNo As %String [ SqlColumnNumber = 2, SqlFieldName = SDSADM_No ];

/// 患者指向
Property SDSADMPMIDR As SDSPatMas [ SqlColumnNumber = 3, SqlFieldName = SDSADM_PMI_DR ];

Index ADMNoIndex On SDSADMNo As Exact;

Index ADMPMIIndex On SDSADMPMIDR;

Storage Default
{
<Data name="SDSAdmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSADMNo</Value>
</Value>
<Value name="3">
<Value>SDSADMPMIDR</Value>
</Value>
</Data>
<DataLocation>^User.SDSAdmD</DataLocation>
<DefaultData>SDSAdmDefaultData</DefaultData>
<IdLocation>^User.SDSAdmD</IdLocation>
<IndexLocation>^User.SDSAdmI</IndexLocation>
<StreamLocation>^User.SDSAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

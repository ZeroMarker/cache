/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断患者表
/// Table：User.SDSPatMas
Class User.SDSPatMas Extends (%Persistent, User.Abstract) [ SqlRowIdName = SDSPMI_RowId, SqlTableName = SDS_PatMas ]
{

/// 登记号
Property SDSPMINo As %String [ SqlColumnNumber = 2, SqlFieldName = SDSPMI_No ];

Index PMINoIndex On SDSPMINo As Exact;

Storage Default
{
<Data name="SDSPatMasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSPMINo</Value>
</Value>
</Data>
<DataLocation>^User.SDSPatMasD</DataLocation>
<DefaultData>SDSPatMasDefaultData</DefaultData>
<IdLocation>^User.SDSPatMasD</IdLocation>
<IndexLocation>^User.SDSPatMasI</IndexLocation>
<StreamLocation>^User.SDSPatMasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

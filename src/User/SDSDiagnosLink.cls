/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断关联表
/// Table：User.SDSDiagnosLink
Class User.SDSDiagnosLink Extends (%Persistent, User.Abstract) [ SqlTableName = SDS_DiagnosLink ]
{

/// 指向医生站诊断表 
Property SDSDiagnosDR As %String [ SqlColumnNumber = 2, SqlFieldName = SDS_Diagnos_DR ];

/// 指向结构化诊断表
Property SDSStructDR As SDSDiagnos [ SqlColumnNumber = 3, SqlFieldName = SDS_Struct_DR ];

/// 就诊指向
Property SDSAdmDR As SDSAdm [ SqlColumnNumber = 4, SqlFieldName = SDS_Adm_DR ];

Index StructIndex On SDSStructDR;

Index DiagnosIndex On SDSDiagnosDR As Exact;

Index AdmStructIndex On (SDSAdmDR, SDSStructDR);

Storage Default
{
<Data name="SDSDiagnosLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSDiagnosDR</Value>
</Value>
<Value name="3">
<Value>SDSStructDR</Value>
</Value>
<Value name="4">
<Value>SDSAdmDR</Value>
</Value>
</Data>
<DataLocation>^User.SDSDiagnosLinkD</DataLocation>
<DefaultData>SDSDiagnosLinkDefaultData</DefaultData>
<IdLocation>^User.SDSDiagnosLinkD</IdLocation>
<IndexLocation>^User.SDSDiagnosLinkI</IndexLocation>
<StreamLocation>^User.SDSDiagnosLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Description： 结构化诊断及数据处理工厂审核数据表
/// Creator：石萧伟
/// Date： 2019-06-18
Class User.MKBDataReviewed Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_DataReviewed ]
{

/// 诊断名dr
Property MKBDRDiagDr As %String [ SqlFieldName = MKBDR_Diag_Dr ];

/// 诊断名
Property MKBDRDiag As %String(MAXLEN = "") [ SqlFieldName = MKBDR_Diag ];

/// 指向就诊表 MRAdm
Property MKBDRMRADMDR As %String [ Required, SqlFieldName = MKBDR_MRADM_DR ];

/// 诊断表达式中心词指向
Property MKBDRTermDR As User.MKBTerm [ SqlFieldName = MKBDR_Term_DR ];

/// 结构化结果ID
Property MKBDRStructResultID As %String(MAXLEN = "") [ SqlFieldName = MKBDR_StructResultID ];

/// 补充诊断
Property MKBDRSupplement As %String(MAXLEN = "") [ SqlFieldName = MKBDR_Supplement ];

/// MRC ICD代码
Property MKBDRMRCDr As %String(MAXLEN = "") [ SqlFieldName = MKBDR_MRCDr ];

/// ICD中文描述
Property MKBDRICDDesc As %String [ SqlFieldName = MKBDR_ICDDesc ];

/// 上报理由类型（缺诊断短语A，诊断短语不正确B，缺诊断表达式C，诊断表达式不正确D，缺ICDE，ICD不正确F）
Property MKBDRReson As %String(MAXLEN = "") [ SqlFieldName = MKBDR_Reson ];

/// 备注
Property MKBDRNote As %String(MAXLEN = "") [ SqlFieldName = MKBDR_Note ];

/// 审核状态
Property MKBDRStatus As %String(DISPLAYLIST = ",已审核,未审核,审核未通过", VALUELIST = ",Y,N,G") [ SqlFieldName = MKBDR_Status ];

/// 其他描述
Property MKBDROtherDesc As %String(MAXLEN = "") [ SqlFieldName = MKBDR_OtherDesc ];

/// 界面标识  SD 数据数据处理工厂  ICD 各版本icd对照界面
Property MKBDRType As %String(MAXLEN = "") [ SqlFieldName = MKBDR_Type ];

Index MRAdmIndex On MKBDRMRADMDR;

Index ICDDiaResultIndex On (MKBDRDiag As Exact, MKBDRICDDesc As Exact, MKBDRStructResultID As Exact);

Storage Default
{
<Data name="MKBDataReviewedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBDRDiagDr</Value>
</Value>
<Value name="3">
<Value>MKBDRDiag</Value>
</Value>
<Value name="4">
<Value>MKBDRMRADMDR</Value>
</Value>
<Value name="5">
<Value>MKBDRTermDR</Value>
</Value>
<Value name="6">
<Value>MKBDRStructResultID</Value>
</Value>
<Value name="7">
<Value>MKBDRSupplement</Value>
</Value>
<Value name="8">
<Value>MKBDRMRCDr</Value>
</Value>
<Value name="9">
<Value>MKBDRICDDesc</Value>
</Value>
<Value name="10">
<Value>MKBDRReson</Value>
</Value>
<Value name="11">
<Value>MKBDRNote</Value>
</Value>
<Value name="12">
<Value>MKBDRStatus</Value>
</Value>
<Value name="13">
<Value>MKBDROtherDesc</Value>
</Value>
<Value name="14">
<Value>MKBDRType</Value>
</Value>
</Data>
<DataLocation>^User.MKBDataReviewedD</DataLocation>
<DefaultData>MKBDataReviewedDefaultData</DefaultData>
<IdLocation>^User.MKBDataReviewedD</IdLocation>
<IndexLocation>^User.MKBDataReviewedI</IndexLocation>
<StreamLocation>^User.MKBDataReviewedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

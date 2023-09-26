/// ICD映射、诊断关系表：MKB_ICDRelation
/// 编写者：基础数据平台组-丁亚男
/// 编写日期: 2018-3-26
Class User.MKBICDRelation Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBICDR_RowId, SqlTableName = MKB_ICDRelation ]
{

/// 诊断表达式
Property MKBICDRDiag As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBICDR_Diag1 ];

/// ICD北京版
Property MKBICDRBJDr As User.MKBTerm [ SqlColumnNumber = 3, SqlFieldName = MKBICDR_BJ_Dr ];

/// ICD国际码1
Property MKBICDRInterCode1 As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBICDR_InterCode1 ];

/// ICD国际码2
Property MKBICDRInterCode2 As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBICDR_InterCode2 ];

/// 北京版备注
Property MKBICDRBJNote As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBICDR_BJ_Note ];

/// 北京版对照状态
Property MKBICDRBJState As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBICDR_BJ_State ];

/// His icd 代码（MRC_ICDDx）
Property MKBICDRHisCode As %String(MAXLEN = "") [ SqlColumnNumber = 12, SqlFieldName = MKBICDR_His_Code ];

/// His icd10 代码（MRC_ICDDx）
Property MKBICDRHis10Code As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = MKBICDR_His_10Code ];

/// His icd10 描述（MRC_ICDDx）
Property MKBICDRHisDesc As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBICDR_His_Desc ];

/// His版备注
Property MKBICDRHisNote As %String [ SqlColumnNumber = 10, SqlFieldName = MKBICDR_His_Note ];

/// His版对照状态
Property MKBICDRHisState As %String [ SqlColumnNumber = 11, SqlFieldName = MKBICDR_His_State ];

Index DiagIndex On MKBICDRDiag;

Index BJIndex On MKBICDRBJDr As Exact;

Storage Default
{
<Data name="MKBICDRelationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBICDRDiag</Value>
</Value>
<Value name="3">
<Value>MKBICDRBJDr</Value>
</Value>
<Value name="4">
<Value>MKBICDRInterCode1</Value>
</Value>
<Value name="5">
<Value>MKBICDRInterCode2</Value>
</Value>
<Value name="6">
<Value>MKBICDRBJNote</Value>
</Value>
<Value name="7">
<Value>MKBICDRBJState</Value>
</Value>
<Value name="8">
<Value>MKBICDRHis10Code</Value>
</Value>
<Value name="9">
<Value>MKBICDRHisDesc</Value>
</Value>
<Value name="10">
<Value>MKBICDRHisNote</Value>
</Value>
<Value name="11">
<Value>MKBICDRHisState</Value>
</Value>
<Value name="12">
<Value>MKBICDRHisCode</Value>
</Value>
</Data>
<DataLocation>^User.MKBICDRelationD</DataLocation>
<DefaultData>MKBICDRelationDefaultData</DefaultData>
<IdLocation>^User.MKBICDRelationD</IdLocation>
<IndexLocation>^User.MKBICDRelationI</IndexLocation>
<StreamLocation>^User.MKBICDRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

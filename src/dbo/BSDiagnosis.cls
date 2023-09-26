Class dbo.BSDiagnosis Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_Diagnosis ]
{

Index IndexMaster On (HospDR, DateTypeId, TypeDate, TypeClassId, TypeClassDR, AdmId) [ SqlName = Index_Master, Type = index ];

Index IndexAdmId On (AdmId, HospDR, DateTypeId, TypeDate, TypeClassId, TypeClassDR) [ SqlName = Index_AdmId, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKDiagnosisId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property HospDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

/// 日期类型 CHARGE：出院日期，MEDICAL：病案归档
Property DateTypeId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 日期
Property TypeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 统计类型  1:申请科室 LOC,2:病房 WARD 3:医生 DOC 
Property TypeClassId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 6 ];

/// 统计类型DR
Property TypeClassDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 诊断类型
Property ICDType As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 8 ];

/// 诊断编码
Property ICDCode As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 9 ];

/// 诊断名称
Property ICDName As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ Required, SqlColumnNumber = 10 ];

/// 就诊号
Property AdmId As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BSDiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>DateTypeId</Value>
</Value>
<Value name="4">
<Value>TypeDate</Value>
</Value>
<Value name="5">
<Value>TypeClassId</Value>
</Value>
<Value name="6">
<Value>TypeClassDR</Value>
</Value>
<Value name="7">
<Value>ICDType</Value>
</Value>
<Value name="8">
<Value>ICDCode</Value>
</Value>
<Value name="9">
<Value>ICDName</Value>
</Value>
<Value name="10">
<Value>AdmId</Value>
</Value>
<Value name="11">
<Value>HospDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSDiagnosisD</DataLocation>
<DefaultData>BSDiagnosisDefaultData</DefaultData>
<IdLocation>^dbo.BSDiagnosisD</IdLocation>
<IndexLocation>^dbo.BSDiagnosisI</IndexLocation>
<StreamLocation>^dbo.BSDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

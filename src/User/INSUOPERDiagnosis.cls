/// 手术诊断
Class User.INSUOPERDiagnosis Extends %Persistent [ Not ProcedureBlock ]
{

Parameter EXTENTSIZE = 250;

/// 1 手术代码	OPER_Code
Property OPERCode As %String(CAPTION = "手术代码", MAXLEN = 30) [ SqlColumnNumber = 2 ];

/// 2 手术名称	OPER_Desc
Property OPERDesc As %String(CAPTION = "手术名称", MAXLEN = 100) [ SqlColumnNumber = 3 ];

/// 3 拼音简称	OPER_xmrj
Property OPERxmrj As %String(CAPTION = "拼音简称", MAXLEN = 30) [ SqlColumnNumber = 4 ];

/// 4 手术分级	OPER_Category
Property OPERCategory As %String(CAPTION = "手术分级", MAXLEN = 30) [ SqlColumnNumber = 5 ];

/// 5 数据来源	OPER_Source
Property OPERSource As %String(CAPTION = "数据来源", MAXLEN = 30) [ SqlColumnNumber = 6 ];

/// 6 插入日期	OPER_UpdateDate
Property OPERUpdateDate As %Library.Date(CAPTION = "插入日期") [ SqlColumnNumber = 7 ];

/// 7 插入用户	OPER_User_Dr
Property OPERUserDr As User.SSUser(CAPTION = "插入用户") [ SqlColumnNumber = 8 ];

/// 8 生效日期	OPER_ActiveDate
Property OPERActiveDate As %Library.Date(CAPTION = "生效日期") [ SqlColumnNumber = 9 ];

/// 9 失效日期	OPER_ExpiryDate
Property OPERExpiryDate As %Library.Date(CAPTION = "失效日期") [ SqlColumnNumber = 10 ];

/// 10 预留串1	OPER_Str01
Property OPERStr01 As %String(CAPTION = "预留串1", MAXLEN = 30) [ SqlColumnNumber = 11 ];

/// 11 预留串2	OPER_Str02
Property OPERStr02 As %String(CAPTION = "预留串2", MAXLEN = 30) [ SqlColumnNumber = 12 ];

/// 12 预留串3	OPER_Str03
Property OPERStr03 As %String(CAPTION = "预留串3", MAXLEN = 30) [ SqlColumnNumber = 13 ];

/// 13 预留串4	OPER_Str04
Property OPERStr04 As %String(CAPTION = "预留串4", MAXLEN = 30) [ SqlColumnNumber = 14 ];

/// 14 预留串5	OPER_Str05
Property OPERStr05 As %String(CAPTION = "预留串5", MAXLEN = 30) [ SqlColumnNumber = 15 ];

/// 15 医院ID	OPER_HospDr
Property OPERHospDr As %String(CAPTION = "医院ID", MAXLEN = 30) [ SqlColumnNumber = 16 ];

/// 手术代码索引
Index IdxOPERCode On OPERCode As Exact;

/// 手术名称索引
Index IdxOPERDesc On OPERDesc As Exact;

/// 数据来源索引
Index IdxOPERSource On OPERSource As Exact;

/// 插入日期索引
Index IdxOPERUpdateDate On OPERUpdateDate As Exact;

/// 生效日期索引
Index IdxOPERActiveDate On OPERActiveDate As Exact;

/// 失效日期索引
Index IdxOPERExpiryDate On OPERExpiryDate As Exact;

/// 院区索引
Index IdxOPERHospDr On OPERHospDr As Exact;

Storage Default
{
<Data name="INSUOPERDiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPERCode</Value>
</Value>
<Value name="3">
<Value>OPERDesc</Value>
</Value>
<Value name="4">
<Value>OPERxmrj</Value>
</Value>
<Value name="5">
<Value>OPERCategory</Value>
</Value>
<Value name="6">
<Value>OPERSource</Value>
</Value>
<Value name="7">
<Value>OPERUpdateDate</Value>
</Value>
<Value name="8">
<Value>OPERUserDr</Value>
</Value>
<Value name="9">
<Value>OPERActiveDate</Value>
</Value>
<Value name="10">
<Value>OPERExpiryDate</Value>
</Value>
<Value name="11">
<Value>OPERStr01</Value>
</Value>
<Value name="12">
<Value>OPERStr02</Value>
</Value>
<Value name="13">
<Value>OPERStr03</Value>
</Value>
<Value name="14">
<Value>OPERStr04</Value>
</Value>
<Value name="15">
<Value>OPERStr05</Value>
</Value>
<Value name="16">
<Value>OPERHospDr</Value>
</Value>
</Data>
<DataLocation>^User.INSUOPERDiagnosisD</DataLocation>
<DefaultData>INSUOPERDiagnosisDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^User.INSUOPERDiagnosisD</IdLocation>
<IndexLocation>^User.INSUOPERDiagnosisI</IndexLocation>
<StreamLocation>^User.INSUOPERDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

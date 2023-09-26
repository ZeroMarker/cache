Class User.MKBGlobal Extends %Persistent [ SqlRowIdName = MKBG_RowId, SqlTableName = MKB_Global ]
{

Relationship ChildGloAlias As User.MKBGloAlias [ Cardinality = children, Inverse = ParRef ];

// Relationship MKBGBTDDiaLoc As User.MKBGBTDDiaDataLoc [ Cardinality = children, Inverse = MKBGBTDDiaData ];

/// 父表指向科室频次子表字段
/// 编码
Property MKBGCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBG_Code ];

/// 中心词
Property MKBGDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBG_Desc ];

/// 英文
Property MKBGEnName As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBG_EnName ];

/// 备注
Property MKBGNote As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBG_Note ];

/// 拼音码
Property MKBGPYCode As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBG_PYCode ];

/// 所属层级
Property MKBGLastLevel As %String [ SqlColumnNumber = 7, SqlFieldName = MKBT_LastLevel ];

/// 状态（在用、封闭、删除、合并）
Property MKBGState As %String(DISPLAYLIST = ",在用,封闭,删除,合并", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",U,S,D,M") [ InitialExpression = "U", SqlColumnNumber = 8, SqlFieldName = MKBG_State ];

/// 是否确认
Property MKBGConfirm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MKBG_Confirm ];

/// 中心词标识
Property MKBGMark As %String(MAXLEN = "");

/// 诊断开立总频次
Property MKBGDiaTotalFreq As %String(MAXLEN = "");

Index CodeIndex On MKBGCode [ Unique ];

Index DescIndex On MKBGDesc;

Index PYCodeIndex On MKBGPYCode;

Index EnNameIndex On MKBGEnName;

Index MKBGMarkIndex On MKBGMark;

Index MKBGFreqIndex On MKBGDiaTotalFreq As PLUS;

Storage Default
{
<Data name="MKBGlobalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBGCode</Value>
</Value>
<Value name="3">
<Value>MKBGDesc</Value>
</Value>
<Value name="4">
<Value>MKBGEnName</Value>
</Value>
<Value name="5">
<Value>MKBGNote</Value>
</Value>
<Value name="6">
<Value>MKBGPYCode</Value>
</Value>
<Value name="7">
<Value>MKBGLastLevel</Value>
</Value>
<Value name="8">
<Value>MKBGState</Value>
</Value>
<Value name="9">
<Value>MKBGConfirm</Value>
</Value>
<Value name="10">
<Value>MKBGMark</Value>
</Value>
<Value name="11">
<Value>MKBGDiaTotalFreq</Value>
</Value>
</Data>
<DataLocation>^User.MKBGlobalD</DataLocation>
<DefaultData>MKBGlobalDefaultData</DefaultData>
<IdLocation>^User.MKBGlobalD</IdLocation>
<IndexLocation>^User.MKBGlobalI</IndexLocation>
<StreamLocation>^User.MKBGlobalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

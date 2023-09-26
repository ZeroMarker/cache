Class User.MKBICDRely Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBIR_RowId, SqlTableName = MKB_ICDRely ]
{

/// HISICD对照表子表ID
Property MKBIRICRId As User.MKBHISICDContrastResult [ SqlColumnNumber = 2, SqlFieldName = MKBIR_ICRId ];

/// 排序调整后的诊断表达式
Property MKBIRTerm As User.MKBTerm [ SqlColumnNumber = 3, SqlFieldName = MKBIR_Term ];

/// 排序调整后的诊断表达式
Property MKBIRSortValue As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBIR_SortValue ];

Index ICRIdIndex On MKBIRICRId As Exact;

Index TermIndex On (MKBIRTerm As Exact, MKBIRICRId As Exact);

Index SortIndex On (MKBIRSortValue As Exact, MKBIRICRId As Exact);

Index ExpsIndex On (MKBIRTerm As Exact, MKBIRSortValue As Exact, MKBIRICRId As Exact);

Storage Default
{
<Data name="MKBICDRelyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBIRMBId</Value>
</Value>
<Value name="3">
<Value>MKBIRTerm</Value>
</Value>
<Value name="4">
<Value>MKBIRMDId</Value>
</Value>
<Value name="5">
<Value>MKBIRSortValue</Value>
</Value>
<Value name="6">
<Value>MKBIRICRId</Value>
</Value>
</Data>
<DataLocation>^User.MKBICDRelyD</DataLocation>
<DefaultData>MKBICDRelyDefaultData</DefaultData>
<IdLocation>^User.MKBICDRelyD</IdLocation>
<IndexLocation>^User.MKBICDRelyI</IndexLocation>
<StreamLocation>^User.MKBICDRelyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

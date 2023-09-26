Class User.PHAINFreq Extends (%Persistent, User.Abstract) [ SqlRowIdName = PIF_RowId, SqlTableName = PHAIN_Freq ]
{

Index IndexFreq On PIFFreqDR As Exact;

/// 频次
Property PIFFreqDR As User.PHCFreq [ Required, SqlColumnNumber = 2, SqlFieldName = PIF_Freq_DR ];

/// 转换系数
Property PIFFactor As %Integer [ Required, SqlColumnNumber = 3, SqlFieldName = PIF_Factor ];

/// 是否有效
Property PIFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = PIF_ActiveFlag ];

Storage Default
{
<Data name="PHAINFreqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PIFFreqDR</Value>
</Value>
<Value name="3">
<Value>PIFFactor</Value>
</Value>
<Value name="4">
<Value>PIFActiveFlag</Value>
</Value>
</Data>
<DataLocation>^CF.PHA.IN.Freq</DataLocation>
<DefaultData>PHAINFreqDefaultData</DefaultData>
<IdLocation>^CF.PHA.IN.Freq</IdLocation>
<IndexLocation>^CF.PHA.IN.Freqi</IndexLocation>
<SqlIdExpression>$i(^CF.PHA.IN.Freq)</SqlIdExpression>
<StreamLocation>^User.PHAINFreqS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

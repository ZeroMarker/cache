Class User.MKBMappingRely Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_MappingRely ]
{

/// MappingBase类ID
Property MKBMRMBId As User.MKBKLMappingBase [ SqlColumnNumber = 2, SqlFieldName = MKBMSR_MBId ];

/// MappingDetail类ID
Property MKBMRMDId As User.MKBKLMappingDetail [ SqlColumnNumber = 3, SqlFieldName = MKBMSR_MDId ];

/// 诊断表达式
Property MKBMRSortValue As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBMSR_SortValue ];

/// 诊断术语ID
Property MKBMRTermDr As User.MKBTerm [ SqlColumnNumber = 5, SqlFieldName = MKBMTR_TermDr ];

Index SortIndex On (MKBMRMBId As Exact, MKBMRSortValue As Exact, MKBMRMDId As Exact);

Index TermIndex On (MKBMRMBId As Exact, MKBMRTermDr As Exact, MKBMRMDId As Exact);

Index AllIndex On (MKBMRMBId As Exact, MKBMRTermDr As Exact, MKBMRSortValue As Exact, MKBMRMDId As Exact);

Index MDIndex On MKBMRMDId As Exact;

Storage Default
{
<Data name="MKBMappingRelyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBMRMBId</Value>
</Value>
<Value name="3">
<Value>MKBMRMDId</Value>
</Value>
<Value name="4">
<Value>MKBMRSortValue</Value>
</Value>
<Value name="5">
<Value>MKBMRTermDr</Value>
</Value>
</Data>
<DataLocation>^User.MKBMappingRelyD</DataLocation>
<DefaultData>MKBMappingRelyDefaultData</DefaultData>
<IdLocation>^User.MKBMappingRelyD</IdLocation>
<IndexLocation>^User.MKBMappingRelyI</IndexLocation>
<StreamLocation>^User.MKBMappingRelyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

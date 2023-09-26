/// 李欣 20180905
/// 映射管理相关业务依赖表，存储顺序调整后的诊断表达式值
Class User.MKBMappingSortRely Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBMSR_RowId, SqlTableName = MKB_MappingSortRely ]
{

/// MappingBase类ID
Property MKBMSRMBId As User.MKBKLMappingBase [ SqlColumnNumber = 2, SqlFieldName = MKBMSR_MBId ];

/// 排序调整后的诊断表达式
Property MKBMSRSortValue As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBMSR_SortValue ];

/// MappingDetail类ID
Property MKBMSRMDId As User.MKBKLMappingDetail [ SqlColumnNumber = 4, SqlFieldName = MKBMSR_MDId ];

Index SortIndex On (MKBMSRMBId As Exact, MKBMSRSortValue As Exact, MKBMSRMDId As Exact);

Storage Default
{
<Data name="MKBMappingSortRelyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBMSRMBId</Value>
</Value>
<Value name="3">
<Value>MKBMSRSortValue</Value>
</Value>
<Value name="4">
<Value>MKBMSRMDId</Value>
</Value>
</Data>
<DataLocation>^User.MKBMappingSortRelyD</DataLocation>
<DefaultData>MKBMappingSortRelyDefaultData</DefaultData>
<IdLocation>^User.MKBMappingSortRelyD</IdLocation>
<IndexLocation>^User.MKBMappingSortRelyI</IndexLocation>
<StreamLocation>^User.MKBMappingSortRelyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

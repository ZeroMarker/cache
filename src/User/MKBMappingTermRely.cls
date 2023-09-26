/// 李欣 20180905
/// 映射管理相关业务依赖表，存储诊断表达式中的TermId
Class User.MKBMappingTermRely Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBMTR_RowId, SqlTableName = MKB_MappingTermRely ]
{

/// MappingBase类ID
Property MKBMTRMBId As User.MKBKLMappingBase [ SqlColumnNumber = 2, SqlFieldName = MKBMTR_MBId ];

/// 排序调整后的诊断表达式
Property MKBMTRTerm As User.MKBTerm [ SqlColumnNumber = 3, SqlFieldName = MKBMTR_Term ];

/// MappingDetail类ID
Property MKBMTRMDId As User.MKBKLMappingDetail [ SqlColumnNumber = 4, SqlFieldName = MKBMTR_MDId ];

Index TermIndex On (MKBMTRMBId As Exact, MKBMTRTerm As Exact, MKBMTRMDId As Exact);

Storage Default
{
<Data name="MKBMappingTermRelyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBMTRMBId</Value>
</Value>
<Value name="3">
<Value>MKBMTRTerm</Value>
</Value>
<Value name="4">
<Value>MKBMTRMDId</Value>
</Value>
</Data>
<DataLocation>^User.MKBMappingTermRelyD</DataLocation>
<DefaultData>MKBMappingTermRelyDefaultData</DefaultData>
<IdLocation>^User.MKBMappingTermRelyD</IdLocation>
<IndexLocation>^User.MKBMappingTermRelyI</IndexLocation>
<StreamLocation>^User.MKBMappingTermRelyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

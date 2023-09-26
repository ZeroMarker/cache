/// 职业病字典数据对照表
Class User.DHCPEOccuDictionaryCode Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_DictionaryCode ]
{

Parameter ClassName = "User.DHCPEOccuDictionaryCode";

/// 代码
Property ODCCode As %String [ Required, SqlFieldName = ODC_Code ];

/// 描述
Property ODCDesc As %String(MAXLEN = 127) [ Required, SqlFieldName = ODC_Desc ];

/// 类型
Property ODCType As %String [ Required, SqlFieldName = ODC_Type ];

/// 关联
Property ODCRelation As User.DHCPEOccuDictionaryCode [ SqlFieldName = ODC_Relation ];

/// 激活，Y，N
Property ODCActive As %String(MAXLEN = 1) [ SqlFieldName = ODC_Active ];

/// 子节点标志，Y，N
Property ODCExFlag As %String(MAXLEN = 1) [ SqlFieldName = ODC_ExFlag ];

/// 扩展信息
Property ODCExpInfo As %String(MAXLEN = 127) [ SqlFieldName = ODC_ExpInfo ];

/// 备注
Property ODCRemark As %String(MAXLEN = 255) [ SqlFieldName = ODC_Remark ];

/// 平台代码 用于和其他平台数据对照
Property ODCPlatformCode As %String [ SqlFieldName = ODC_PlatformCode ];

/// 自定义数据1
Property ODCCustomData1 As %String(MAXLEN = 255) [ SqlFieldName = ODC_CustomData1 ];

/// 自定义数据2
Property ODCCustomData2 As %String(MAXLEN = 255) [ SqlFieldName = ODC_CustomData2 ];

/// 自定义数据3
Property ODCCustomData3 As %String(MAXLEN = 255) [ SqlFieldName = ODC_CustomData3 ];

/// 类型，代码索引
Index TypeCodeIndex On (ODCType, ODCCode) [ Unique ];

/// 类型，关联
Index TypeRelationIndex On (ODCType, ODCRelation);

/// 类型索引
Index TypeIndex On ODCType;

Storage Default
{
<Data name="DHCPEOccuDictionaryCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ODCCode</Value>
</Value>
<Value name="3">
<Value>ODCDesc</Value>
</Value>
<Value name="4">
<Value>ODCType</Value>
</Value>
<Value name="5">
<Value>ODCRelation</Value>
</Value>
<Value name="6">
<Value>ODCActive</Value>
</Value>
<Value name="7">
<Value>ODCExFlag</Value>
</Value>
<Value name="8">
<Value>ODCExpInfo</Value>
</Value>
<Value name="9">
<Value>ODCRemark</Value>
</Value>
<Value name="10">
<Value>ODCPlatformCode</Value>
</Value>
<Value name="11">
<Value>ODCCustomData1</Value>
</Value>
<Value name="12">
<Value>ODCCustomData2</Value>
</Value>
<Value name="13">
<Value>ODCCustomData3</Value>
</Value>
</Data>
<DataLocation>^CT.PE.OccuDictionaryCodeD</DataLocation>
<DefaultData>DHCPEOccuDictionaryCodeDefaultData</DefaultData>
<IdLocation>^CT.PE.OccuDictionaryCodeD</IdLocation>
<IndexLocation>^CT.PE.OccuDictionaryCodeI</IndexLocation>
<StreamLocation>^CT.PE.OccuDictionaryCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

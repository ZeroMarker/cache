/// Creator:谷雪萍
/// CreatDate:2018-05-05
/// Description：知识点映射注册表
/// Table：User.MKBKLMappingBase
Class User.MKBKLMappingBase Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_KLMappingBase ]
{

Relationship ChildField As User.MKBKLMappingBaseField [ Cardinality = children, Inverse = ParRef ];

/// 代码
Property MKBKMBCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBKMB_Code ];

/// 标题
Property MKBKMBDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBKMB_Desc ];

/// 映射关系
Property MKBKMBMappingRelation As %String(DISPLAYLIST = ",单向映射(从1到2),单向映射(从2到1),双向映射", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",1,2,3") [ SqlColumnNumber = 4, SqlFieldName = MKBKMB_MappingRelation ];

/// 知识点1
Property MKBKMBKnowledge1 As %String [ SqlColumnNumber = 5, SqlFieldName = MKBKMB_Knowledge1 ];

/// 知识点2
Property MKBKMBKnowledge2 As %String [ SqlColumnNumber = 6, SqlFieldName = MKBKMB_Knowledge2 ];

/// 备注
Property MKBKMBNote As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBKMB_Note ];

/// 右键菜单标识
Property MKBKMBFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MKBKMB_Flag ];

/// 顺序
Property MKBKMBSequence As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBKMB_Sequence ];

/// 知识库标识 同义诊断(SD),鉴别诊断(DD),文献对照(LC),推荐评估表(RF),科室常用诊断(CD),科室专业诊断(PD) 
Property MKBKMBIdentify As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = MKBKMB_Identify ];

/// 知识库标识索引
Index IdenIndex On MKBKMBIdentify [ Unique ];

/// 代码索引
Index CodeIndex On MKBKMBCode [ Unique ];

/// 描述索引
Index DescIndex On MKBKMBDesc [ Unique ];

/// 右键菜单标识索引
Index FlagIndex On MKBKMBFlag;

/// 顺序索引
Index SeqIndex On MKBKMBSequence As Exact;

Storage Default
{
<Data name="MKBKLMappingBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBKMBCode</Value>
</Value>
<Value name="3">
<Value>MKBKMBDesc</Value>
</Value>
<Value name="4">
<Value>MKBKMBMappingRelation</Value>
</Value>
<Value name="5">
<Value>MKBKMBKnowledge1</Value>
</Value>
<Value name="6">
<Value>MKBKMBKnowledge2</Value>
</Value>
<Value name="7">
<Value>MKBKMBNote</Value>
</Value>
<Value name="8">
<Value>MKBKMBFlag</Value>
</Value>
<Value name="9">
<Value>MKBKMBSequence</Value>
</Value>
<Value name="10">
<Value>MKBKMBIdentify</Value>
</Value>
</Data>
<DataLocation>^User.MKBKLMappingBaseD</DataLocation>
<DefaultData>MKBKLMappingBaseDefaultData</DefaultData>
<IdLocation>^User.MKBKLMappingBaseD</IdLocation>
<IndexLocation>^User.MKBKLMappingBaseI</IndexLocation>
<StreamLocation>^User.MKBKLMappingBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：医用知识库术语注册属性表
/// Table：User.MKBTermBaseProperty
Class User.MKBTermBaseProperty Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTBP_RowId, SqlTableName = MKB_TermBaseProperty ]
{

Relationship ChildExt As User.MKBTermBaseExtendPro [ Cardinality = children, Inverse = ParRef ];

/// 属性代码
Property MKBTBPCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBTBP_Code ];

/// 属性描述
Property MKBTBPDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBTBP_Desc ];

/// 属性格式
Property MKBTBPType As %String(DISPLAYLIST = ",文本,多行文本框,单选框,复选框,下拉框,列表,树形,表单,引用术语,知识应用模板,引用属性内容,映射,引用单节点,文本编辑器", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",TX,TA,R,CB,C,L,T,F,S,P,SD,M,SS,ETX") [ SqlColumnNumber = 4, SqlFieldName = MKBTBP_Type ];

/// 术语库注册指针
Property MKBTBPBaseDr As User.MKBTermBase [ SqlColumnNumber = 5, SqlFieldName = MKBTBP_Base_Dr ];

/// 配置项
Property MKBTBPConfig As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBTBP_Config ];

/// 主列名
Property MKBTBPName As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBTBP_Name ];

/// 标识
Property MKBTBPFlag As %String(DISPLAYLIST = ",诊断展示名,常用名/别名列表,知识应用模板,其他描述", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",S,AL,DT,OD") [ SqlColumnNumber = 8, SqlFieldName = MKBTBP_Flag ];

/// 字段顺序
Property MKBTBPSequence As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBTBP_Sequence ];

/// 起始节点
Property MKBTBPDefinedNode As User.MKBTerm [ SqlColumnNumber = 10, SqlFieldName = MKBTBP_DefinedNode ];

/// 是否在纵向展示栏展示
Property MKBTBPIsShowInLeft As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MKBTBP_IsShowInLeft ];

/// 编码规则
Property MKBTBPCodeRules As %String(MAXLEN = "") [ Required, SqlColumnNumber = 12, SqlFieldName = MKBTBP_CodeRules ];

/// 医为百科展示方式2020-06-20
Property MKBTBPWikiShow As %String [ SqlColumnNumber = 13, SqlFieldName = MKBTBP_WikiShow ];

Index TermBaseIdx On MKBTBPBaseDr As Exact;

Index CodeIndex On (MKBTBPBaseDr, MKBTBPCode) [ Unique ];

Index DescIndex On (MKBTBPBaseDr, MKBTBPDesc) [ Unique ];

Index FlagIndex On (MKBTBPBaseDr, MKBTBPFlag) [ Unique ];

Index SeqIndex On (MKBTBPBaseDr, MKBTBPSequence As Exact);

Index ShowIndex On (MKBTBPBaseDr, MKBTBPIsShowInLeft As Exact);

Index CodeRulesIndex On (MKBTBPBaseDr, MKBTBPCodeRules) [ Unique ];

Storage Default
{
<Data name="MKBTermBasePropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTBPCode</Value>
</Value>
<Value name="3">
<Value>MKBTBPDesc</Value>
</Value>
<Value name="4">
<Value>MKBTBPType</Value>
</Value>
<Value name="5">
<Value>MKBTBPBaseDr</Value>
</Value>
<Value name="6">
<Value>MKBTBPConfig</Value>
</Value>
<Value name="7">
<Value>MKBTBPName</Value>
</Value>
<Value name="8">
<Value>MKBTBPFlag</Value>
</Value>
<Value name="9">
<Value>MKBTBPSequence</Value>
</Value>
<Value name="10">
<Value>MKBTBPDefinedNode</Value>
</Value>
<Value name="11">
<Value>MKBTBPIsShowInLeft</Value>
</Value>
<Value name="12">
<Value>MKBTBPCodeRules</Value>
</Value>
<Value name="13">
<Value>MKBTBPWikiShow</Value>
</Value>
</Data>
<DataLocation>^User.MKBTermBasePropertyD</DataLocation>
<DefaultData>MKBTermBasePropertyDefaultData</DefaultData>
<IdLocation>^User.MKBTermBasePropertyD</IdLocation>
<IndexLocation>^User.MKBTermBasePropertyI</IndexLocation>
<StreamLocation>^User.MKBTermBasePropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

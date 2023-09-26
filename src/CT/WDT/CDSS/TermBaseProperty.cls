/// Creator:高姗姗
/// CreatDate:2021-09-03
/// Description：CDSS知识库术语注册属性表
/// Table：CT.WDT.CDSS.TermBaseProperty
Class CT.WDT.CDSS.TermBaseProperty Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTBP_RowId, SqlTableName = TermBaseProperty ]
{

Relationship ChildExt As CT.WDT.CDSS.TermBaseExtendPro [ Cardinality = children, Inverse = ParRef ];

/// 属性代码
Property MKBTBPCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBTBP_Code ];

/// 属性描述
Property MKBTBPDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBTBP_Desc ];

/// 属性格式
Property MKBTBPType As %String(DISPLAYLIST = ",文本,多行文本框,单选框,复选框,下拉框,列表,树形,表单,引用术语,知识应用模板,引用属性内容,映射,引用单节点,文本编辑器", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",TX,TA,R,CB,C,L,T,F,S,P,SD,M,SS,ETX") [ SqlColumnNumber = 4, SqlFieldName = MKBTBP_Type ];

/// 术语库注册指针
Property MKBTBPBaseDr As CT.WDT.CDSS.TermBase [ SqlColumnNumber = 5, SqlFieldName = MKBTBP_Base_Dr ];

/// 配置项
Property MKBTBPConfig As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBTBP_Config ];

/// 主列名
Property MKBTBPName As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBTBP_Name ];

/// 标识
Property MKBTBPFlag As %String(DISPLAYLIST = ",诊断展示名,常用名/别名列表,知识应用模板,其他描述", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",S,AL,DT,OD") [ SqlColumnNumber = 8, SqlFieldName = MKBTBP_Flag ];

/// 字段顺序
Property MKBTBPSequence As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBTBP_Sequence ];

/// 起始节点
Property MKBTBPDefinedNode As CT.WDT.CDSS.Term [ SqlColumnNumber = 10, SqlFieldName = MKBTBP_DefinedNode ];

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
<Data name="TermBasePropertyDefaultData">
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
<DataLocation>^CT.WDT.CDSS.TermBasePropertyD</DataLocation>
<DefaultData>TermBasePropertyDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TermBasePropertyD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TermBasePropertyI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TermBasePropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

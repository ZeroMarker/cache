/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：医用知识库术语属性表
/// Table：CT.WDT.CDSS.MKBTermProperty
Class CT.WDT.CDSS.TermProperty Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTP_RowId, SqlTableName = TermProperty ]
{

Relationship ChildExtPro As CT.WDT.CDSS.TermExtendPro [ Cardinality = children, Inverse = ParRef ];

/// 属性代码
Property MKBTPCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBTP_Code ];

/// 属性描述
Property MKBTPDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBTP_Desc ];

/// 属性格式
Property MKBTPType As %String(DISPLAYLIST = ",文本,多行文本框,单选框,复选框,下拉框,列表,树形,文本编辑器", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",TX,TA,R,CB,C,L,T,ETX") [ SqlColumnNumber = 4, SqlFieldName = MKBTP_Type ];

/// 配置项
Property MKBTPConfig As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBTP_Config ];

/// 术语id
Property MKBTPTermDr As CT.WDT.CDSS.Term [ SqlColumnNumber = 6, SqlFieldName = MKBTP_Term_Dr ];

/// 主列名
Property MKBTPName As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBTP_Name ];

/// 标识
Property MKBTPFlag As %String(DISPLAYLIST = "常用名/别名列表", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",AL") [ SqlColumnNumber = 8, SqlFieldName = MKBTP_Flag ];

/// 公有属性标识
Property MKBTPPublic As %String(DISPLAYLIST = ",是,否", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MKBTP_Public ];

/// 起始节点
Property MKBTPDefinedNode As CT.WDT.CDSS.Term [ SqlColumnNumber = 10, SqlFieldName = MKBTP_DefinedNode ];

/// 顺序
Property MKBTPSequence As %String(MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = MKBTP_Sequence ];

/// 编码规则
Property MKBTPCodeRules As %String(MAXLEN = "") [ Required, SqlColumnNumber = 12, SqlFieldName = MKBTP_CodeRules ];

Index TermIndex On MKBTPTermDr As Exact;

Index SeqIndex On (MKBTPTermDr As Exact, MKBTPSequence As Exact);

Index CodeIndex On (MKBTPTermDr, MKBTPCode) [ Unique ];

Index DescIndex On (MKBTPTermDr, MKBTPDesc) [ Unique ];

Index FlagIndex On (MKBTPTermDr, MKBTPFlag) [ Unique ];

Index CodeRulesIndex On (MKBTPTermDr, MKBTPCodeRules) [ Unique ];

Storage Default
{
<Data name="TermPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTPCode</Value>
</Value>
<Value name="3">
<Value>MKBTPDesc</Value>
</Value>
<Value name="4">
<Value>MKBTPType</Value>
</Value>
<Value name="5">
<Value>MKBTPConfig</Value>
</Value>
<Value name="6">
<Value>MKBTPTermDr</Value>
</Value>
<Value name="7">
<Value>MKBTPName</Value>
</Value>
<Value name="8">
<Value>MKBTPFlag</Value>
</Value>
<Value name="9">
<Value>MKBTPPublic</Value>
</Value>
<Value name="10">
<Value>MKBTPDefinedNode</Value>
</Value>
<Value name="11">
<Value>MKBTPSequence</Value>
</Value>
<Value name="12">
<Value>MKBTPCodeRules</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TermPropertyD</DataLocation>
<DefaultData>TermPropertyDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TermPropertyD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TermPropertyI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TermPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

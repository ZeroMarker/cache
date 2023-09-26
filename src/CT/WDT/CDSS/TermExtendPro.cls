/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：医用知识库术语扩展属性表
/// Table：CT.WDT.CDSS.TermExtendPro
Class CT.WDT.CDSS.TermExtendPro Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTEP_RowId, SqlTableName = TermExtendPro ]
{

Relationship ParRef As CT.WDT.CDSS.TermProperty [ Cardinality = parent, Inverse = ChildExtPro ];

/// 扩展属性名称
Property MKBTEPName As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBTEP_Name ];

/// 字段分类
Property MKBTEPType As %String(DISPLAYLIST = ",文本,多行文本框,单选框,复选框,下拉框,日期", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",TX,TA,R,CB,C,D") [ SqlColumnNumber = 4, SqlFieldName = MKBTEP_Type ];

/// 字段配置项
Property MKBTEPConfig As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBTEP_Config ];

/// 顺序字段
Property MKBTEPSequence As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBTEP_Sequence ];

Index NameIndex On (ParRef As Exact, MKBTEPName);

Index SeqIndex On (ParRef As Exact, MKBTEPSequence As Exact);

Storage Default
{
<Data name="TermExtendProDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTEPName</Value>
</Value>
<Value name="3">
<Value>MKBTEPType</Value>
</Value>
<Value name="4">
<Value>MKBTEPConfig</Value>
</Value>
<Value name="5">
<Value>MKBTEPSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExtPro")</DataLocation>
<DefaultData>TermExtendProDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TermPropertyC("ChildExtPro")</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TermExtendProI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TermExtendProS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

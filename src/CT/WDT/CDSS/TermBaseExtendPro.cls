/// Creator:高姗姗
/// CreatDate:2021-09-03
/// Description：CDSS知识库术语注册扩展属性表
/// Table：CT.WDT.CDSS.TermBaseExtendPro
Class CT.WDT.CDSS.TermBaseExtendPro Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTBEP_RowId, SqlTableName = TermBaseExtendPro ]
{

Relationship ParRef As CT.WDT.CDSS.TermBaseProperty [ Cardinality = parent, Inverse = ChildExt ];

/// 扩展属性名称
Property MKBTBEPName As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBTBEP_Name ];

/// 字段分类
Property MKBTBEPType As %String(DISPLAYLIST = ",文本,引用,单选框,复选框,下拉框,多行文本框,引用属性内容,日期", VALUELIST = ",TX,S,R,CB,C,TA,SD,D") [ SqlColumnNumber = 3, SqlFieldName = MKBTBEP_Type ];

/// 字段配置项
Property MKBTBEPConfig As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBTBEP_Config ];

/// 顺序字段
Property MKBTBEPSequence As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = MKBTBEP_Sequence ];

Index NameIndex On (ParRef As Exact, MKBTBEPName As Exact);

Index ParIndex On ParRef As Exact;

Index SeqIndex On (ParRef As Exact, MKBTBEPSequence As Exact);

Storage Default
{
<Data name="TermBaseExtendProDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTBEPName</Value>
</Value>
<Value name="3">
<Value>MKBTBEPType</Value>
</Value>
<Value name="4">
<Value>MKBTBEPConfig</Value>
</Value>
<Value name="5">
<Value>MKBTBEPSequence</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExt")</DataLocation>
<DefaultData>TermBaseExtendProDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TermBasePropertyC("ChildExt")</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TermBaseExtendProI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TermBaseExtendProS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

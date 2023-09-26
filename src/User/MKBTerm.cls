/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：医用知识库术语维护表
/// Table：User.MKBTerm
Class User.MKBTerm Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBT_RowId, SqlTableName = MKB_Term ]
{

/// 术语代码
Property MKBTCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBT_Code ];

/// 术语中心词
Property MKBTDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBT_Desc ];

/// 所属术语库
Property MKBTBaseDR As User.MKBTermBase [ SqlColumnNumber = 4, SqlFieldName = MKBT_Base_DR ];

/// 上一级分类
Property MKBTLastLevel As User.MKBTerm [ SqlColumnNumber = 5, SqlFieldName = MKBT_LastLevel ];

/// 术语检索码
Property MKBTPYCode As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MKBT_PYCode ];

/// 术语备注
Property MKBTNote As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBT_Note ];

/// 顺序
Property MKBTSequence As %String(MAXLEN = "") [ SqlColumnNumber = 8, SqlFieldName = MKBT_Sequence ];

/// 是否激活
Property MKBTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = MKBT_ActiveFlag ];

/// 知识数量
Property MKBTDetailCount As %String(MAXLEN = "") [ InitialExpression = "0", SqlColumnNumber = 10, SqlFieldName = MKBT_DetailCount ];

Index CodeIndex On (MKBTBaseDR, MKBTCode) [ Unique ];

Index DescIndex On (MKBTBaseDR, MKBTDesc);

Index ParentIndex On (MKBTBaseDR, MKBTLastLevel);

Index SeqIndex On (MKBTBaseDR, MKBTSequence As Exact);

Index ParSeqIndex On (MKBTBaseDR, MKBTLastLevel, MKBTSequence As Exact);

Index BaseIndex On MKBTBaseDR;

Index DCountIndex On (MKBTBaseDR, MKBTDetailCount As Exact);

Storage Default
{
<Data name="MKBTermDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTCode</Value>
</Value>
<Value name="3">
<Value>MKBTDesc</Value>
</Value>
<Value name="4">
<Value>MKBTBaseDR</Value>
</Value>
<Value name="5">
<Value>MKBTLastLevel</Value>
</Value>
<Value name="6">
<Value>MKBTPYCode</Value>
</Value>
<Value name="7">
<Value>MKBTNote</Value>
</Value>
<Value name="8">
<Value>MKBTSequence</Value>
</Value>
<Value name="9">
<Value>MKBTActiveFlag</Value>
</Value>
<Value name="10">
<Value>MKBTDetailCount</Value>
</Value>
</Data>
<DataLocation>^User.MKBTermD</DataLocation>
<DefaultData>MKBTermDefaultData</DefaultData>
<IdLocation>^User.MKBTermD</IdLocation>
<IndexLocation>^User.MKBTermI</IndexLocation>
<StreamLocation>^User.MKBTermS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

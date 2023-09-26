/// Creator:丁亚男
/// CreatDate:2021-09-02
/// Description：医用知识库术语维护表
/// Table：CT.WDT.CDSS.Term
Class CT.WDT.CDSS.Term Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBT_RowId, SqlTableName = Term ]
{

/// 术语代码
Property MKBTCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBT_Code ];

/// 术语中心词
Property MKBTDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBT_Desc ];

/// 所属术语库
Property MKBTBaseDR As CT.WDT.CDSS.TermBase [ SqlColumnNumber = 4, SqlFieldName = MKBT_Base_DR ];

/// 上一级分类
Property MKBTLastLevel As CT.WDT.CDSS.Term [ SqlColumnNumber = 5, SqlFieldName = MKBT_LastLevel ];

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

/// 最后操作时间
Property UpdateDate As %TimeStamp;

/// 责任人（编辑人）
Property ResponUser As %String;

/// 审核人
Property ReviewUser As %String;

/// 状态(编辑中0，已弃用1，已审核2，待审核3)
Property Status As %String;

Index CodeIndex On (MKBTBaseDR, MKBTCode) [ Unique ];

Index DescIndex On (MKBTBaseDR, MKBTDesc);

Index ParentIndex On (MKBTBaseDR, MKBTLastLevel);

Index SeqIndex On (MKBTBaseDR, MKBTSequence As Exact);

Index ParSeqIndex On (MKBTBaseDR, MKBTLastLevel, MKBTSequence As Exact);

Index BaseIndex On MKBTBaseDR;

Index DCountIndex On (MKBTBaseDR, MKBTDetailCount As Exact);

Index DateIndex On UpdateDate;

Index BaseDateIndex On (MKBTBaseDR, UpdateDate);

Index DDescIndex On MKBTDesc;

Storage Default
{
<Data name="TermDefaultData">
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
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>ResponUser</Value>
</Value>
<Value name="13">
<Value>ReviewUser</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.TermD</DataLocation>
<DefaultData>TermDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TermD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TermI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TermS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

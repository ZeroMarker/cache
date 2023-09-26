/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：医用知识库术语扩展属性明细表
/// Table：User.MKBTermExtendProVal
Class User.MKBTermExtendProVal Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTEPV_RowId, SqlTableName = MKB_TermExtendProVal ]
{

/// 术语属性明细表指针
Property MKBTEPVDetailDr As User.MKBTermProDetail [ SqlColumnNumber = 2, SqlFieldName = MKBTEPV_Detail_Dr ];

/// 术语扩展属性表指针
Property MKBTEPVExtendDr As User.MKBTermExtendPro [ SqlColumnNumber = 3, SqlFieldName = MKBTEPV_Extend_Dr ];

/// 扩展属性值
Property MKBTEPVValue As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBTEPV_Value ];

Index DetailIndex On MKBTEPVDetailDr As Exact;

Index ExtendIndex On MKBTEPVExtendDr As Exact;

Index ValIndex On (MKBTEPVDetailDr As Exact, MKBTEPVExtendDr As Exact);

Storage Default
{
<Data name="MKBTermExtendProValDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTEPVDetailDr</Value>
</Value>
<Value name="3">
<Value>MKBTEPVExtendDr</Value>
</Value>
<Value name="4">
<Value>MKBTEPVValue</Value>
</Value>
</Data>
<DataLocation>^User.MKBTermExtendProValD</DataLocation>
<DefaultData>MKBTermExtendProValDefaultData</DefaultData>
<IdLocation>^User.MKBTermExtendProValD</IdLocation>
<IndexLocation>^User.MKBTermExtendProValI</IndexLocation>
<StreamLocation>^User.MKBTermExtendProValS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

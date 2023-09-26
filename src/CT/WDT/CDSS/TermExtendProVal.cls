/// Creator:谷雪萍
/// CreatDate:2021-09-08
/// Description：CDSS-医用知识库术语扩展属性明细表
/// Table：CT.WDT.CDSS.TermExtendProVal
Class CT.WDT.CDSS.TermExtendProVal Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTEPV_RowId, SqlTableName = TermExtendProVal ]
{

/// 术语属性明细表指针
Property MKBTEPVDetailDr As CT.WDT.CDSS.TermProDetail [ SqlColumnNumber = 2, SqlFieldName = MKBTEPV_Detail_Dr ];

/// 术语扩展属性表指针
Property MKBTEPVExtendDr As CT.WDT.CDSS.TermExtendPro [ SqlColumnNumber = 3, SqlFieldName = MKBTEPV_Extend_Dr ];

/// 扩展属性值
Property MKBTEPVValue As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = MKBTEPV_Value ];

Index DetailIndex On MKBTEPVDetailDr As Exact;

Index ExtendIndex On MKBTEPVExtendDr As Exact;

Index ValIndex On (MKBTEPVDetailDr As Exact, MKBTEPVExtendDr As Exact);

Storage Default
{
<Data name="TermExtendProValDefaultData">
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
<DataLocation>^CT.WDT.CDSS.TermExtendProValD</DataLocation>
<DefaultData>TermExtendProValDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.TermExtendProValD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.TermExtendProValI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.TermExtendProValS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creator:谷雪萍
/// CreatDate:2018-03-26
/// Description：医用知识库术语属性明细表
/// Table：User.MKBTermProperty
Class User.MKBTermProDetail Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBTPD_RowId, SqlTableName = MKB_TermProDetail ]
{

/// 代码
Property MKBTPDCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = MKBTPD_Code ];

/// 描述
Property MKBTPDDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = MKBTPD_Desc ];

/// 上级分类
Property MKBTPDLastLevel As User.MKBTermProDetail [ SqlColumnNumber = 4, SqlFieldName = MKBTPD_LastLevel ];

/// 级别
Property MKBTPDLevel As %String [ SqlColumnNumber = 5, SqlFieldName = MKBTPD_Level ];

/// 属性id
Property MKBTPDProDR As User.MKBTermProperty [ SqlColumnNumber = 6, SqlFieldName = MKBTPD_Pro_DR ];

/// 备注
Property MKBTPDRemark As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = MKBTPD_Remark ];

/// 是否可用
Property MKBTPDActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MKBTPD_ActiveFlag ];

/// 顺序
Property MKBTPDSequence As %String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = MKBTPD_Sequence ];

/// 检索码
Property MKBTPDPYCode As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = MKBTPD_PYCode ];

Index ProIdx On MKBTPDProDR As Exact;

Index CodeIndex On (MKBTPDProDR, MKBTPDCode) [ Unique ];

Index ProParIndex On (MKBTPDProDR, MKBTPDLastLevel);

Index SeqIndex On (MKBTPDProDR, MKBTPDSequence As Exact);

Index ParIndex On MKBTPDLastLevel As Exact;

Index ProParSeqIndex On (MKBTPDProDR, MKBTPDLastLevel, MKBTPDSequence As Exact);

Storage Default
{
<Data name="MKBTermProDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBTPDCode</Value>
</Value>
<Value name="3">
<Value>MKBTPDDesc</Value>
</Value>
<Value name="4">
<Value>MKBTPDLastLevel</Value>
</Value>
<Value name="5">
<Value>MKBTPDLevel</Value>
</Value>
<Value name="6">
<Value>MKBTPDProDR</Value>
</Value>
<Value name="7">
<Value>MKBTPDRemark</Value>
</Value>
<Value name="8">
<Value>MKBTPDActiveFlag</Value>
</Value>
<Value name="9">
<Value>MKBTPDSequence</Value>
</Value>
<Value name="10">
<Value>MKBTPDPYCode</Value>
</Value>
</Data>
<DataLocation>^User.MKBTermProDetailD</DataLocation>
<DefaultData>MKBTermProDetailDefaultData</DefaultData>
<IdLocation>^User.MKBTermProDetailD</IdLocation>
<IndexLocation>^User.MKBTermProDetailI</IndexLocation>
<StreamLocation>^User.MKBTermProDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

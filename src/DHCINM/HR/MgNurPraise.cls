Class DHCINM.HR.MgNurPraise Extends %Persistent
{

/// 人员档案id
Property PerDR As %String [ SqlColumnNumber = 2, SqlFieldName = PerDR ];

/// 表扬来源
Property PraiseFrom As %String [ SqlColumnNumber = 3, SqlFieldName = Praise_From ];

/// 发生时间
Property PraiseDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Praise_Date ];

/// 事件描述
Property PraiseDesc As %String [ SqlColumnNumber = 5, SqlFieldName = Praise_Desc ];

/// 记录人
Property PraiseRecorder As %String [ SqlColumnNumber = 6, SqlFieldName = Praise_Recorder ];

/// 状态 N:保存 S：提交 A：审核 B：驳回
Property PraiseStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Praise_Status ];

/// 记录时间
Property PraiseRecordDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Praise_RecordDate ];

/// 证书图片
Property CertPic As list Of %String(MAXLEN = 2000) [ SqlColumnNumber = 9, SqlFieldName = CertPic ];

Index ssid On PerDR;

Storage Default
{
<Data name="MgNurPraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerDR</Value>
</Value>
<Value name="3">
<Value>PraiseFrom</Value>
</Value>
<Value name="4">
<Value>PraiseDate</Value>
</Value>
<Value name="5">
<Value>PraiseDesc</Value>
</Value>
<Value name="6">
<Value>PraiseRecorder</Value>
</Value>
<Value name="7">
<Value>PraiseStatus</Value>
</Value>
<Value name="8">
<Value>PraiseRecordDate</Value>
</Value>
<Value name="9">
<Value>CertPic</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgNurPraiseD</DataLocation>
<DefaultData>MgNurPraiseDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurPraiseD</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurPraiseI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurPraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

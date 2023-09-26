/// Creator:wangcc
/// Descriptions:投诉批评
/// Date:2021-01-25
Class DHCINM.HR.MgNurCritic Extends %Persistent
{

/// 人员档案id
Property PerDR As %String [ SqlColumnNumber = 2, SqlFieldName = PerDR ];

/// 批评来源
Property CriticFrom As %String [ SqlColumnNumber = 3, SqlFieldName = Critic_From ];

/// 发生时间
Property CriticDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Critic_Date ];

/// 事件描述
Property CriticDesc As %String [ SqlColumnNumber = 5, SqlFieldName = Critic_Desc ];

/// 记录人
Property CriticRecorder1 As %String [ SqlColumnNumber = 6, SqlFieldName = Critic_Recorder1 ];

/// 状态 N:保存 S：提交 A：审核 B：驳回
Property CriticStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Critic_Status ];

/// 记录时间
Property CriticRecordDate1 As %Date [ SqlColumnNumber = 8, SqlFieldName = Critic_RecordDate1 ];

/// 整改措施
Property CriticRectifAction As %String [ SqlColumnNumber = 9, SqlFieldName = Critic_RectifAction ];

/// 整改效果
Property CriticRectifEffect As %String [ SqlColumnNumber = 10, SqlFieldName = Critic_RectifEffect ];

/// 记录人
Property CriticRecorder2 As %String [ SqlColumnNumber = 11, SqlFieldName = Critic_Recorder2 ];

/// 记录时间
Property CriticRecordDate2 As %Date [ SqlColumnNumber = 12, SqlFieldName = Critic_RecordDate2 ];

/// 反馈人
Property CriticBack As %String [ SqlColumnNumber = 13, SqlFieldName = Critic_Back ];

/// 处理结果
Property CriticDeal As %String [ SqlColumnNumber = 14, SqlFieldName = Critic_Deal ];

/// 证书图片
Property CertPic As list Of %String(MAXLEN = 2000) [ SqlColumnNumber = 15, SqlFieldName = CertPic ];

Index ssid On PerDR;

Storage Default
{
<Data name="MgNurCriticDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerDR</Value>
</Value>
<Value name="3">
<Value>CriticFrom</Value>
</Value>
<Value name="4">
<Value>CriticDate</Value>
</Value>
<Value name="5">
<Value>CriticDesc</Value>
</Value>
<Value name="6">
<Value>CriticRecorder1</Value>
</Value>
<Value name="7">
<Value>CriticStatus</Value>
</Value>
<Value name="8">
<Value>CriticRecordDate1</Value>
</Value>
<Value name="9">
<Value>CriticRectifAction</Value>
</Value>
<Value name="10">
<Value>CriticRectifEffect</Value>
</Value>
<Value name="11">
<Value>CriticRecorder2</Value>
</Value>
<Value name="12">
<Value>CriticRecordDate2</Value>
</Value>
<Value name="13">
<Value>CriticBack</Value>
</Value>
<Value name="14">
<Value>CriticDeal</Value>
</Value>
<Value name="15">
<Value>CertPic</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgNurCriticD</DataLocation>
<DefaultData>MgNurCriticDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurCriticD</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurCriticI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurCriticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

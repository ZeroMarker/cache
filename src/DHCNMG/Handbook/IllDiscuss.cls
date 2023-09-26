/// Creater:lwz
/// Descriptions:病例讨论
/// Date:2018-08-22
Class DHCNMG.Handbook.IllDiscuss Extends %Persistent [ SqlTableName = IllDiscuss ]
{

/// 创建人
Property Creater As %String [ SqlColumnNumber = 2, SqlFieldName = Creater ];

/// 创建日期	
Property CreatDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 3, SqlFieldName = CreatDate ];

/// 创建时间	
Property CreatTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 4, SqlFieldName = CreatTime ];

/// 病区
Property WardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = WardDR ];

/// 备注
Property Remarks As %String(MAXLEN = 10000) [ SqlColumnNumber = 6, SqlFieldName = Remarks ];

/// 讨论日期
Property DiscussDate As %Date [ SqlColumnNumber = 7, SqlFieldName = DiscussDate ];

/// 病例种类【疑难H 死亡D 其他O】	
Property CaseType As %String [ SqlColumnNumber = 8, SqlFieldName = CaseType ];

/// 病案号
Property DiseaseNumber As %String [ SqlColumnNumber = 9, SqlFieldName = DiseaseNumber ];

/// 主持者
Property Host As %String [ SqlColumnNumber = 10, SqlFieldName = Host ];

/// 参加者
Property Participant As %String [ SqlColumnNumber = 11, SqlFieldName = Participant ];

/// 患者 PA_Adm
Property Patient As %String [ SqlColumnNumber = 12, SqlFieldName = Patient ];

/// 诊断
Property Diagnosis As %String [ SqlColumnNumber = 13, SqlFieldName = Diagnosis ];

/// 状态
Property Status As %String [ SqlColumnNumber = 14, SqlFieldName = Status ];

/// 提交日期	
Property SubmitDate As %Date [ SqlColumnNumber = 15, SqlFieldName = SubmitDate ];

/// 提交时间	
Property SubmitTime As %Time [ SqlColumnNumber = 16, SqlFieldName = SubmitTime ];

/// 讨论记录
Property Notes As %String [ SqlColumnNumber = 17, SqlFieldName = Notes ];

/// 审核日期	
Property CheckDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CheckDate ];

/// 审核时间	
Property CheckTime As %Time [ SqlColumnNumber = 19, SqlFieldName = CheckTime ];

/// 驳回日期	
Property RejectDate As %Date [ SqlColumnNumber = 20, SqlFieldName = RejectDate ];

/// 驳回时间	
Property RejectTime As %Time [ SqlColumnNumber = 21, SqlFieldName = RejectTime ];

/// 驳回原因	
Property RejectOpinion As %String [ SqlColumnNumber = 22, SqlFieldName = RejectOpinion ];

/// 驳回人 
Property Rejector As %String [ SqlColumnNumber = 23, SqlFieldName = Rejector ];

/// 审核意见	
Property CheckOpinion As %String [ SqlColumnNumber = 24, SqlFieldName = CheckOpinion ];

/// 审核人	
Property Checker As %String [ SqlColumnNumber = 25, SqlFieldName = Checker ];

Index StatusDiscussDate On (Status, DiscussDate);

Storage Default
{
<Data name="IllDiscussDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Creater</Value>
</Value>
<Value name="3">
<Value>CreatDate</Value>
</Value>
<Value name="4">
<Value>CreatTime</Value>
</Value>
<Value name="5">
<Value>WardDR</Value>
</Value>
<Value name="6">
<Value>Remarks</Value>
</Value>
<Value name="7">
<Value>DiscussDate</Value>
</Value>
<Value name="8">
<Value>CaseType</Value>
</Value>
<Value name="9">
<Value>DiseaseNumber</Value>
</Value>
<Value name="10">
<Value>Host</Value>
</Value>
<Value name="11">
<Value>Participant</Value>
</Value>
<Value name="12">
<Value>Patient</Value>
</Value>
<Value name="13">
<Value>Diagnosis</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>SubmitDate</Value>
</Value>
<Value name="16">
<Value>SubmitTime</Value>
</Value>
<Value name="17">
<Value>Notes</Value>
</Value>
<Value name="18">
<Value>CheckDate</Value>
</Value>
<Value name="19">
<Value>CheckTime</Value>
</Value>
<Value name="20">
<Value>RejectDate</Value>
</Value>
<Value name="21">
<Value>RejectTime</Value>
</Value>
<Value name="22">
<Value>RejectReason</Value>
</Value>
<Value name="23">
<Value>Rejector</Value>
</Value>
<Value name="24">
<Value>CheckOpinion</Value>
</Value>
<Value name="25">
<Value>Checker</Value>
</Value>
<Value name="26">
<Value>RejectOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.IllDiscussD</DataLocation>
<DefaultData>IllDiscussDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.IllDiscussD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.IllDiscussI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.IllDiscussS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// Creater:lwz
/// Descriptions:业务查房
/// Date:2018-08-22
Class DHCNMG.Handbook.WardRound Extends %Persistent [ SqlTableName = WardRound ]
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

/// 查房日期
Property CheckRoomDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CheckRoomDate ];

/// 主题
Property Theme As %String [ SqlColumnNumber = 8, SqlFieldName = Theme ];

/// 主持者
Property Host As %String [ SqlColumnNumber = 9, SqlFieldName = Host ];

/// 参加者
Property Participant As %String [ SqlColumnNumber = 10, SqlFieldName = Participant ];

/// 患者 PA_Adm
Property Patient As %String [ SqlColumnNumber = 11, SqlFieldName = Patient ];

/// 床号
Property BedNumber As %String [ SqlColumnNumber = 12, SqlFieldName = BedNumber ];

/// 诊断
Property Diagnosis As %String [ SqlColumnNumber = 13, SqlFieldName = Diagnosis ];

/// 状态
Property Status As %String [ SqlColumnNumber = 14, SqlFieldName = Status ];

/// 提交日期	
Property SubmitDate As %Date [ SqlColumnNumber = 15, SqlFieldName = SubmitDate ];

/// 提交时间	
Property SubmitTime As %Time [ SqlColumnNumber = 16, SqlFieldName = SubmitTime ];

/// 审核日期	
Property CheckDate As %Date [ SqlColumnNumber = 17, SqlFieldName = CheckDate ];

/// 审核时间	
Property CheckTime As %Time [ SqlColumnNumber = 18, SqlFieldName = CheckTime ];

/// 驳回日期	
Property RejectDate As %Date [ SqlColumnNumber = 19, SqlFieldName = RejectDate ];

/// 驳回时间	
Property RejectTime As %Time [ SqlColumnNumber = 20, SqlFieldName = RejectTime ];

/// 驳回原因	
Property RejectOpinion As %String [ SqlColumnNumber = 21, SqlFieldName = RejectOpinion ];

/// 驳回人 
Property Rejector As %String [ SqlColumnNumber = 22, SqlFieldName = Rejector ];

/// 审核意见	
Property CheckOpinion As %String [ SqlColumnNumber = 23, SqlFieldName = CheckOpinion ];

/// 审核人	
Property Checker As %String [ SqlColumnNumber = 24, SqlFieldName = Checker ];

Index StatusCheckRoomDate On (Status, CheckRoomDate);

Storage Default
{
<Data name="WardRoundDefaultData">
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
<Value>CheckDate</Value>
</Value>
<Value name="8">
<Value>Theme</Value>
</Value>
<Value name="9">
<Value>Host</Value>
</Value>
<Value name="10">
<Value>Participant</Value>
</Value>
<Value name="11">
<Value>Patient</Value>
</Value>
<Value name="12">
<Value>BedNumber</Value>
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
<Value>CheckRoomDate</Value>
</Value>
<Value name="18">
<Value>CheckTime</Value>
</Value>
<Value name="19">
<Value>RejectDate</Value>
</Value>
<Value name="20">
<Value>RejectTime</Value>
</Value>
<Value name="21">
<Value>RejectReason</Value>
</Value>
<Value name="22">
<Value>Rejector</Value>
</Value>
<Value name="23">
<Value>CheckOpinion</Value>
</Value>
<Value name="24">
<Value>Checker</Value>
</Value>
<Value name="25">
<Value>RejectOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.WardRoundD</DataLocation>
<DefaultData>WardRoundDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.WardRoundD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.WardRoundI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.WardRoundS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

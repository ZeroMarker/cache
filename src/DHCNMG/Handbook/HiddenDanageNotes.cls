/// Creater:lwz
/// Descriptions:隐患分析记录
/// Date:2018-08-22
Class DHCNMG.Handbook.HiddenDanageNotes Extends %Persistent [ SqlTableName = HiddenDanageNotes ]
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

/// 记录日期
Property NotesDate As %Date [ SqlColumnNumber = 7, SqlFieldName = NotesDate ];

/// 主持人
Property Host As %String [ SqlColumnNumber = 8, SqlFieldName = Host ];

/// 记录
Property Notes As %String [ SqlColumnNumber = 9, SqlFieldName = Notes ];

/// 参加者
Property Participant As %String [ SqlColumnNumber = 10, SqlFieldName = Participant ];

/// 状态
Property Status As %String [ SqlColumnNumber = 11, SqlFieldName = Status ];

/// 提交日期	
Property SubmitDate As %Date [ SqlColumnNumber = 12, SqlFieldName = SubmitDate ];

/// 提交时间	
Property SubmitTime As %Time [ SqlColumnNumber = 13, SqlFieldName = SubmitTime ];

/// 审核日期	
Property CheckDate As %Date [ SqlColumnNumber = 14, SqlFieldName = CheckDate ];

/// 审核时间	
Property CheckTime As %Time [ SqlColumnNumber = 15, SqlFieldName = CheckTime ];

/// 驳回日期	
Property RejectDate As %Date [ SqlColumnNumber = 16, SqlFieldName = RejectDate ];

/// 驳回时间	
Property RejectTime As %Time [ SqlColumnNumber = 17, SqlFieldName = RejectTime ];

/// 驳回原因	
Property RejectOpinion As %String [ SqlColumnNumber = 18, SqlFieldName = RejectOpinion ];

/// 驳回人 
Property Rejector As %String [ SqlColumnNumber = 19, SqlFieldName = Rejector ];

/// 审核意见	
Property CheckOpinion As %String [ SqlColumnNumber = 20, SqlFieldName = CheckOpinion ];

/// 审核人	
Property Checker As %String [ SqlColumnNumber = 21, SqlFieldName = Checker ];

Index StatusNotesDate On (Status, NotesDate);

Storage Default
{
<Data name="HiddenDanageNotesDefaultData">
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
<Value>NotesDate</Value>
</Value>
<Value name="8">
<Value>Host</Value>
</Value>
<Value name="9">
<Value>Participant</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>SubmitDate</Value>
</Value>
<Value name="12">
<Value>SubmitTime</Value>
</Value>
<Value name="13">
<Value>Notes</Value>
</Value>
<Value name="14">
<Value>CheckDate</Value>
</Value>
<Value name="15">
<Value>CheckTime</Value>
</Value>
<Value name="16">
<Value>RejectDate</Value>
</Value>
<Value name="17">
<Value>RejectTime</Value>
</Value>
<Value name="18">
<Value>RejectOpinion</Value>
</Value>
<Value name="19">
<Value>Rejector</Value>
</Value>
<Value name="20">
<Value>CheckOpinion</Value>
</Value>
<Value name="21">
<Value>Checker</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.HiddenDNotesD</DataLocation>
<DefaultData>HiddenDanageNotesDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.HiddenDNotesD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.HiddenDNotesI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.HiddenDNotesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

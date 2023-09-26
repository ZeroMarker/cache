/// 附加工作
Class CIS.AN.AdditionalWork Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AdditionalWork ]
{

/// 医护人员所在的科室
Property Dept As %String [ Required, SqlColumnNumber = 2 ];

/// 工作的医护人员
Property Worker As %String [ Required, SqlColumnNumber = 3 ];

/// 工作时长(min)
Property Duration As %String [ SqlColumnNumber = 4 ];

/// 工作开始日期
Property StartDate As %Date [ SqlColumnNumber = 5 ];

/// 工作开始时间
Property StartTime As %Time [ SqlColumnNumber = 6 ];

/// 工作结束日期
Property EndDate As %Date [ SqlColumnNumber = 7 ];

/// 工作结束时间
Property EndTime As %Time [ SqlColumnNumber = 8 ];

/// 工作描述
Property Description As %String(MAXLEN = 500) [ SqlColumnNumber = 9 ];

/// 工作说明
Property Note As %String(MAXLEN = 500) [ SqlColumnNumber = 10 ];

/// 工作创建用户
Property CreateUser As %String [ SqlColumnNumber = 11 ];

/// 工作创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12 ];

/// 工作创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 13 ];

/// 工作审核用户
Property AuditUser As %String [ SqlColumnNumber = 14 ];

/// 工作审核日期
Property AuditDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 16 ];

/// 工作审核时间
Property AuditTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 17 ];

/// 工作状态
Property Status As %String(DISPLAYLIST = ",新建,已审核", VALUELIST = ",N,A") [ SqlColumnNumber = 18 ];

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 19 ];

Index IOPS On OperSchedule;

Index IDept On Dept;

Index IWorker On Worker;

Storage Default
{
<Data name="AdditionalWorkDefaultData">
<Value name="1">
<Value>Dept</Value>
</Value>
<Value name="2">
<Value>Worker</Value>
</Value>
<Value name="3">
<Value>Duration</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>EndTime</Value>
</Value>
<Value name="8">
<Value>Description</Value>
</Value>
<Value name="9">
<Value>Note</Value>
</Value>
<Value name="10">
<Value>CreateUser</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateTime</Value>
</Value>
<Value name="13">
<Value>AuditUser</Value>
</Value>
<Value name="14">
<Value>AuditDate</Value>
</Value>
<Value name="15">
<Value>AuditTime</Value>
</Value>
<Value name="16">
<Value>Status</Value>
</Value>
<Value name="17">
<Value>OperSchedule</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AdditionalWorkD</DataLocation>
<DefaultData>AdditionalWorkDefaultData</DefaultData>
<IdLocation>^CIS.AN.AdditionalWorkD</IdLocation>
<IndexLocation>^CIS.AN.AdditionalWorkI</IndexLocation>
<StreamLocation>^CIS.AN.AdditionalWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

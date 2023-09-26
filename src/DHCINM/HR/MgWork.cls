Class DHCINM.HR.MgWork Extends %Persistent
{

/// 人员档案id
Property WorkPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Work_PerDR ];

/// 开始日期
Property WorkStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Work_StDate ];

/// 结束日期
Property WorkEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Work_EndDate ];

/// 工作单位
Property WorkUnit As %String [ SqlColumnNumber = 5, SqlFieldName = Work_Unit ];

/// 担任职务
Property WorkPost As %String [ SqlColumnNumber = 6, SqlFieldName = Work_Post ];

/// 岗位职称
Property WorkDuty As %String [ SqlColumnNumber = 7, SqlFieldName = Work_Duty ];

/// 备注
Property WorkRemark As %String [ SqlColumnNumber = 8, SqlFieldName = Work_Remark ];

/// 状态【A：已审核 N：未提交 Y:提交】
Property WorkStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Work_Status ];

Index ssid On WorkPerDR;

Index date On (WorkStDate, WorkPerDR);

Index Status On (WorkStatus, WorkPerDR);

Storage Default
{
<Data name="MgWorkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkPerDR</Value>
</Value>
<Value name="3">
<Value>WorkStDate</Value>
</Value>
<Value name="4">
<Value>WorkEndDate</Value>
</Value>
<Value name="5">
<Value>WorkUnit</Value>
</Value>
<Value name="6">
<Value>WorkPost</Value>
</Value>
<Value name="7">
<Value>WorkDuty</Value>
</Value>
<Value name="8">
<Value>WorkRemark</Value>
</Value>
<Value name="9">
<Value>WorkStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgWorkD</DataLocation>
<DefaultData>MgWorkDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgWorkD</IdLocation>
<IndexLocation>^DHCINM.HR.MgWorkI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

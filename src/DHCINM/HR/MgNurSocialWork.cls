Class DHCINM.HR.MgNurSocialWork Extends %Persistent
{

/// 人员档案id
Property WorkPerDR As %String [ SqlColumnNumber = 2, SqlFieldName = Work_PerDR ];

/// 开始日期
Property WorkStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Work_StDate ];

/// 结束日期
Property WorkEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Work_EndDate ];

/// 工作单位
Property WorkUnit As %String [ SqlColumnNumber = 5, SqlFieldName = Work_Unit ];

/// 担任职务
Property WorkPost As %String [ SqlColumnNumber = 6, SqlFieldName = Work_Post ];

/// 备注
Property WorkRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Work_Remark ];

/// 状态【A：已审核 N：未提交 Y:提交  B:驳回】
Property WorkStatus As %String [ SqlColumnNumber = 8, SqlFieldName = Work_Status ];

/// 兼职类型
Property WorkType As %String [ SqlColumnNumber = 9, SqlFieldName = Work_Type ];

/// 兼职级别
Property WorkLevel As %String [ SqlColumnNumber = 10, SqlFieldName = work_Level ];

/// 级别明细
Property WorkLevelRemark As %String [ SqlColumnNumber = 11, SqlFieldName = Work_LevelRemark ];

Index ssid On WorkPerDR;

Index type On WorkType;

Storage Default
{
<Data name="MgNurSocialWorkDefaultData">
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
<Value>WorkRemark</Value>
</Value>
<Value name="8">
<Value>WorkStatus</Value>
</Value>
<Value name="9">
<Value>WorkType</Value>
</Value>
<Value name="10">
<Value>WorkLevel</Value>
</Value>
<Value name="11">
<Value>WorkLevelRemark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgNurSocialWorkD</DataLocation>
<DefaultData>MgNurSocialWorkDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurSocialWorkD</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurSocialWorkI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurSocialWorkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

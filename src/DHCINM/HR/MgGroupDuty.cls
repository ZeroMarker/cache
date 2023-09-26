/// Descriptions:组内职称
Class DHCINM.HR.MgGroupDuty Extends %Persistent
{

/// 人员档案id
Property GroupPerDR As %String [ SqlColumnNumber = 2, SqlFieldName = Group_PerDR ];

/// 组名
Property GroupName As %String [ SqlColumnNumber = 3, SqlFieldName = Group_Name ];

/// 职称
Property GroupDuty As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Duty ];

/// 聘任开始日期
Property GroupStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Group_StDate ];

/// 聘任截止日期
Property GroupEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Group_EndDate ];

/// 备注
Property GroupRemark As %String [ SqlColumnNumber = 7, SqlFieldName = Group_Remark ];

/// 状态【A：已审核 N：未提交 Y:提交 B:驳回】
Property GroupStatus As %String [ SqlColumnNumber = 8, SqlFieldName = Group_Status ];

Index ssid On GroupPerDR;

Storage Default
{
<Data name="MgGroupDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupPerDR</Value>
</Value>
<Value name="3">
<Value>GroupName</Value>
</Value>
<Value name="4">
<Value>GroupDuty</Value>
</Value>
<Value name="5">
<Value>GroupStDate</Value>
</Value>
<Value name="6">
<Value>GroupEndDate</Value>
</Value>
<Value name="7">
<Value>GroupRemark</Value>
</Value>
<Value name="8">
<Value>GroupStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgGroupDutyD</DataLocation>
<DefaultData>MgGroupDutyDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgGroupDutyD</IdLocation>
<IndexLocation>^DHCINM.HR.MgGroupDutyI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgGroupDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

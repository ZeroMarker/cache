/// Creator:
/// Descriptions:职务
/// Date:2017-08-23
/// 
Class DHCNMG.HR.MgPostDuty Extends %Persistent
{

/// 人员档案id
Property PostPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Post_PerDR ];

/// 职务名称
Property PostDuty As %String [ SqlColumnNumber = 3, SqlFieldName = Post_Duty ];

/// 任命开始日期
Property PostStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Post_StDate ];

/// 任命截止日期
Property PostEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Post_EndDate ];

/// 备注
Property PostRemark As %String [ SqlColumnNumber = 6, SqlFieldName = Post_Remark ];

/// 状态【A：已审核 N：未提交 Y:提交 B:驳回】
Property PostStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Post_Status ];

Index ssid On PostPerDR;

Index date On (PostStDate, PostPerDR);

Index PostDate On (PostPerDR, PostStDate);

Storage Default
{
<Data name="MgPostDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PostPerDR</Value>
</Value>
<Value name="3">
<Value>PostDuty</Value>
</Value>
<Value name="4">
<Value>PostStDate</Value>
</Value>
<Value name="5">
<Value>PostEndDate</Value>
</Value>
<Value name="6">
<Value>PostRemark</Value>
</Value>
<Value name="7">
<Value>PostStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgPostDutyD</DataLocation>
<DefaultData>MgPostDutyDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgPostDutyD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgPostDutyI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgPostDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

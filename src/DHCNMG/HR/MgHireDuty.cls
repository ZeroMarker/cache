/// Creator:
/// Descriptions:聘任职称
/// Date:2017-08-22
/// 
Class DHCNMG.HR.MgHireDuty Extends %Persistent
{

/// 人员档案id
Property HirePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Hire_PerDR ];

/// 聘任职称
Property HireDuty As %String [ SqlColumnNumber = 3, SqlFieldName = Hire_Duty ];

/// 聘任开始日期
Property HireStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Hire_StDate ];

/// 聘任截止日期
Property HireEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Hire_EndDate ];

/// 备注
Property HireRemark As %String [ SqlColumnNumber = 6, SqlFieldName = Hire_Remark ];

/// 证书图片
Property CertPic As list Of %String [ SqlColumnNumber = 7, SqlFieldName = CertPic ];

/// 状态【A：已审核 N：未提交 Y:提交 B:驳回】
Property HireStatus As %String [ SqlColumnNumber = 8, SqlFieldName = Hire_Status ];

Index ssid On HirePerDR;

Index date On (HireStDate, HirePerDR);

Index HireDate On (HirePerDR, HireStDate);

Storage Default
{
<Data name="MgHireDutyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HirePerDR</Value>
</Value>
<Value name="3">
<Value>HireDuty</Value>
</Value>
<Value name="4">
<Value>HireStDate</Value>
</Value>
<Value name="5">
<Value>HireEndDate</Value>
</Value>
<Value name="6">
<Value>HireRemark</Value>
</Value>
<Value name="7">
<Value>CertPic</Value>
</Value>
<Value name="8">
<Value>HireStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgHireDutyD</DataLocation>
<DefaultData>MgHireDutyDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgHireDutyD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgHireDutyI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgHireDutyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

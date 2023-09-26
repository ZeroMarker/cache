Class DHCINM.HR.MgSupport Extends %Persistent
{

/// 人员档案id
Property SupportPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Support_PerDR ];

/// 年度（年）
Property SupportYear As %Date [ SqlColumnNumber = 3, SqlFieldName = Support_Year ];

/// 帮扶机构
Property SupportAgency As %String [ SqlColumnNumber = 4, SqlFieldName = Support_Agency ];

/// 开始日期
Property SupportStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Support_StDate ];

/// 结束日期
Property SupportEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Support_EndDate ];

/// 状态
Property SupportStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Support_Status ];

Property SupportUser As %String [ SqlColumnNumber = 8, SqlFieldName = Support_User ];

Index ssid On SupportPerDR;

Index date On (SupportYear, SupportPerDR);

Storage Default
{
<Data name="MgSupportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SupportPerDR</Value>
</Value>
<Value name="3">
<Value>SupportYear</Value>
</Value>
<Value name="4">
<Value>SupportAgency</Value>
</Value>
<Value name="5">
<Value>SupportStDate</Value>
</Value>
<Value name="6">
<Value>SupportEndDate</Value>
</Value>
<Value name="7">
<Value>SupportStatus</Value>
</Value>
<Value name="8">
<Value>SupportUser</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgSupportD</DataLocation>
<DefaultData>MgSupportDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgSupportD</IdLocation>
<IndexLocation>^DHCINM.HR.MgSupportI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgSupportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

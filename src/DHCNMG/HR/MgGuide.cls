/// 
/// 指导研究生毕业
/// 
Class DHCNMG.HR.MgGuide Extends %Persistent
{

/// 人员档案id
Property GuidePerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Guide_PerDR ];

/// 姓名
Property GuideName As %String [ SqlColumnNumber = 3, SqlFieldName = Guide_Name ];

/// 学校
Property GuideSchool As %String [ SqlColumnNumber = 4, SqlFieldName = Guide_School ];

/// 专业
Property GuideProfession As %String [ SqlColumnNumber = 5, SqlFieldName = GuideProfession ];

/// 开始日期
Property GuideStDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Guide_StDate ];

/// 结束日期
Property GuideEndDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Guide_EndDate ];

/// 性质
Property GuideType As %String [ SqlColumnNumber = 8, SqlFieldName = Guide_Type ];

/// 状态
Property GuideStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Guide_Status ];

Property GuideUser As %String [ SqlColumnNumber = 10, SqlFieldName = Guide_User ];

Index ssid On GuidePerDR;

Storage Default
{
<Data name="MgGuideDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GuidePerDR</Value>
</Value>
<Value name="3">
<Value>GuideName</Value>
</Value>
<Value name="4">
<Value>GuideSchool</Value>
</Value>
<Value name="5">
<Value>GuideProfession</Value>
</Value>
<Value name="6">
<Value>GuideStDate</Value>
</Value>
<Value name="7">
<Value>GuideEndDate</Value>
</Value>
<Value name="8">
<Value>GuideType</Value>
</Value>
<Value name="9">
<Value>GuideStatus</Value>
</Value>
<Value name="10">
<Value>GuideUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgGuideD</DataLocation>
<DefaultData>MgGuideDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgGuideD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgGuideI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgGuideS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

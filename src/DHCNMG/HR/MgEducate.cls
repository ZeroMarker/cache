/// Creator:
/// Descriptions:教育经历
/// Date:2017-08-30
/// 
Class DHCNMG.HR.MgEducate Extends %Persistent
{

/// 人员档案id
Property EduPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Edu_PerDR ];

/// 开始日期
Property EduStDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Edu_StDate ];

/// 结束日期
Property EduEndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Edu_EndDate ];

/// 毕业院校
Property EduSchool As %String [ SqlColumnNumber = 5, SqlFieldName = Edu_School ];

/// 学历
Property EduAcademic As %String [ SqlColumnNumber = 6, SqlFieldName = Edu_Academic ];

/// 学位
Property EduDegree As %String [ SqlColumnNumber = 7, SqlFieldName = Edu_Degree ];

/// 教育性质
Property EduRadio As %String [ SqlColumnNumber = 8, SqlFieldName = Edu_Radio ];

/// 专业
Property EduProfession As %String [ SqlColumnNumber = 9, SqlFieldName = Edu_Profession ];

/// 证书图片
Property CertPic As list Of %String [ SqlColumnNumber = 10, SqlFieldName = CertPic ];

/// 学位取得日期
Property EduDegreeDate As %Date [ SqlColumnNumber = 11, SqlFieldName = Edu_DegreeDate ];

/// 状态【A：已审核 N：未提交 Y:提交 B: 驳回】
Property EduStatus As %String [ SqlColumnNumber = 12, SqlFieldName = Edu_Status ];

Index ssid On EduPerDR;

Index date On (EduStDate, EduPerDR);

Index flag On (EduPerDR, EduStDate);

Storage Default
{
<Data name="MgEducateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EduPerDR</Value>
</Value>
<Value name="3">
<Value>EduStDate</Value>
</Value>
<Value name="4">
<Value>EduEndDate</Value>
</Value>
<Value name="5">
<Value>EduSchool</Value>
</Value>
<Value name="6">
<Value>EduAcademic</Value>
</Value>
<Value name="7">
<Value>EduDegree</Value>
</Value>
<Value name="8">
<Value>EduRadio</Value>
</Value>
<Value name="9">
<Value>EduProfession</Value>
</Value>
<Value name="10">
<Value>CertPic</Value>
</Value>
<Value name="11">
<Value>EduDegreeDate</Value>
</Value>
<Value name="12">
<Value>EduStatus</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgEducateD</DataLocation>
<DefaultData>MgEducateDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgEducateD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgEducateI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgEducateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

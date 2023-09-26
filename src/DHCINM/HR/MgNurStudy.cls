Class DHCINM.HR.MgNurStudy Extends %Persistent
{

/// 人员档案id
Property PerDR As %String [ SqlColumnNumber = 2, SqlFieldName = PerDR ];

/// 进修专业
Property StudyProfession As %String [ SqlColumnNumber = 3, SqlFieldName = Study_Project ];

/// 进修开始时间
Property StudyStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Study_StDate ];

/// 进修结束时间
Property StudyEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Study_EndDate ];

/// 期限
Property StudyLength As %String [ SqlColumnNumber = 6, SqlFieldName = Study_Length ];

/// 状态 N:保存 S：提交 A：审核 B：驳回
Property StudyStatus As %String [ SqlColumnNumber = 7, SqlFieldName = Study_Status ];

/// 进修医院
Property StudyHospital As %String [ SqlColumnNumber = 8, SqlFieldName = Study_Hospital ];

Index ssid On PerDR;

Storage Default
{
<Data name="MgNurStudyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PerDR</Value>
</Value>
<Value name="3">
<Value>StudyProfession</Value>
</Value>
<Value name="4">
<Value>StudyStDate</Value>
</Value>
<Value name="5">
<Value>StudyEndDate</Value>
</Value>
<Value name="6">
<Value>StudyLength</Value>
</Value>
<Value name="7">
<Value>StudyStatus</Value>
</Value>
<Value name="8">
<Value>StudyHospital</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgNurStudyD</DataLocation>
<DefaultData>MgNurStudyDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurStudyD</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurStudyI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurStudyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

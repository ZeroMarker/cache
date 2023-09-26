/// Creator:guozj
/// Descriptions:护理信息（学术会议）
/// Date:2018-07-16
Class DHCINM.HR.MgAcadMeeting Extends %Persistent
{

/// 人员档案id
Property AcadPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Acad_PerDR ];

/// 年度
Property AcadYear As %Date [ SqlColumnNumber = 3, SqlFieldName = Acad_Year ];

/// 会议名称
Property AcadTitle As %String [ SqlColumnNumber = 4, SqlFieldName = AcadTitle ];

/// 会议日期
Property AcadDate As %Date [ SqlColumnNumber = 5, SqlFieldName = AcadDate ];

/// 举办单位
Property AcadUnit As %String [ SqlColumnNumber = 6, SqlFieldName = AcadUnit ];

/// 举办地点
Property AcadPlace As %String [ SqlColumnNumber = 7, SqlFieldName = AcadPlace ];

/// 参会人数
Property AcadNurNum As %Integer [ SqlColumnNumber = 8, SqlFieldName = AcadNurNum ];

/// 状态
Property AcadStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Acad_Status ];

Property AcadUser As %String [ SqlColumnNumber = 10, SqlFieldName = Acad_User ];

Index ssid On AcadPerDR;

Index date On (AcadYear, AcadPerDR);

Storage Default
{
<Data name="MgAcadMeetingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AcadPerDR</Value>
</Value>
<Value name="3">
<Value>AcadYear</Value>
</Value>
<Value name="4">
<Value>AcadTitle</Value>
</Value>
<Value name="5">
<Value>AcadDate</Value>
</Value>
<Value name="6">
<Value>AcadUnit</Value>
</Value>
<Value name="7">
<Value>AcadPlace</Value>
</Value>
<Value name="8">
<Value>AcadNurNum</Value>
</Value>
<Value name="9">
<Value>AcadStatus</Value>
</Value>
<Value name="10">
<Value>AcadUser</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgAcadMeetingD</DataLocation>
<DefaultData>MgAcadMeetingDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgAcadMeetingD</IdLocation>
<IndexLocation>^DHCINM.HR.MgAcadMeetingI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgAcadMeetingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

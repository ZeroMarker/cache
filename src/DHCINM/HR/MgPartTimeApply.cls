/// Creator:wangcc
/// Descriptions:兼职护士认领记录
/// Date:
Class DHCINM.HR.MgPartTimeApply Extends %Persistent
{

/// 兼职科室表
Property WardDr As %String [ SqlColumnNumber = 2, SqlFieldName = PTApp_Ward ];

/// 兼职岗位表
Property PostDr As %String [ SqlColumnNumber = 3, SqlFieldName = PTApp_PostDr ];

/// 认领日期
Property AppDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PTApp_Date ];

/// 护士
Property NurseId As %String [ SqlColumnNumber = 5, SqlFieldName = PTApp_NurseId ];

/// 是否缺勤 Y  N
Property IsOnPost As %String [ SqlColumnNumber = 6, SqlFieldName = PTApp_IsOnPost ];

/// 缺勤备注
Property Remark As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = PTApp_Remark ];

Index date On (WardDr, PostDr, AppDate);

Index ssid On (WardDr, PostDr, AppDate, NurseId);

Index perDate On (NurseId, AppDate);

Index isOnPost On (IsOnPost, WardDr, PostDr, AppDate, NurseId);

Storage Default
{
<Data name="MgPartTimeApplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardDr</Value>
</Value>
<Value name="3">
<Value>PostDr</Value>
</Value>
<Value name="4">
<Value>AppDate</Value>
</Value>
<Value name="5">
<Value>NurseId</Value>
</Value>
<Value name="6">
<Value>IsOnPost</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgPartTimeApplyD</DataLocation>
<DefaultData>MgPartTimeApplyDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgPartTimeApplyD</IdLocation>
<IndexLocation>^DHCINM.HR.MgPartTimeApplyI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgPartTimeApplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

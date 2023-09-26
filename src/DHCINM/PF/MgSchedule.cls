/// Creater:lulin
/// Descriptions:工作台-我的日程
/// Date:2021-04-27
Class DHCINM.PF.MgSchedule Extends %Persistent
{

/// 人员
Property DataUser As %Integer [ SqlColumnNumber = 2, SqlFieldName = Data_User ];

/// 日期
Property DataDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Data_Date ];

/// 标题
Property DataTitle As %String(MAXLEN = 10000) [ SqlColumnNumber = 4, SqlFieldName = Data_Title ];

/// 备忘记
Property DataContext As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Data_Context ];

/// 颜色
Property DataColor As %String [ SqlColumnNumber = 6, SqlFieldName = Data_Color ];

Index PerDate On (DataUser, DataDate);

Storage Default
{
<Data name="MgScheduleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataUser</Value>
</Value>
<Value name="3">
<Value>DataDate</Value>
</Value>
<Value name="4">
<Value>DataTitle</Value>
</Value>
<Value name="5">
<Value>DataContext</Value>
</Value>
<Value name="6">
<Value>DataColor</Value>
</Value>
</Data>
<DataLocation>^DHCINM.PF.MgScheduleD</DataLocation>
<DefaultData>MgScheduleDefaultData</DefaultData>
<IdLocation>^DHCINM.PF.MgScheduleD</IdLocation>
<IndexLocation>^DHCINM.PF.MgScheduleI</IndexLocation>
<StreamLocation>^DHCINM.PF.MgScheduleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

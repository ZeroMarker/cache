/// 院内调岗申请表
Class DHCINM.Trans.MgTransPositionApp Extends %Persistent
{

/// 申请日期
Property AppDate As %Date [ SqlColumnNumber = 2, SqlFieldName = App_Date ];

/// 状态【N:已保存 Y:已提交 HZ：护士长审核  KH：科护士长审核 B：驳回 A:审核通过】
Property AppStatus As %String [ SqlColumnNumber = 3, SqlFieldName = App_Status ];

/// 申请人
Property CreateUser As %String [ SqlColumnNumber = 4, SqlFieldName = Create_User ];

/// 申请变动岗位原因
Property AppReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = App_Reason ];

/// 所在病区
Property AppWard As %String [ SqlColumnNumber = 6, SqlFieldName = App_Ward ];

/// 申请岗位
Property AppPosition As %String [ SqlColumnNumber = 7, SqlFieldName = App_Position ];

Index ward On AppWard;

Storage Default
{
<Data name="MgTransPositionAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AppDate</Value>
</Value>
<Value name="3">
<Value>AppStatus</Value>
</Value>
<Value name="4">
<Value>CreateUser</Value>
</Value>
<Value name="5">
<Value>AppReason</Value>
</Value>
<Value name="6">
<Value>AppWard</Value>
</Value>
<Value name="7">
<Value>AppPosition</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgTransPosiD</DataLocation>
<DefaultData>MgTransPositionAppDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgTransPosiD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgTransPosiI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgTransPosiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

/// 术后随访
Class CIS.AN.OperFollowup Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperFollowup, StorageStrategy = Default ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 随访次数
Property FollowupNo As %String [ Required, SqlColumnNumber = 3 ];

/// 随访日期
Property FollowupDate As %Date [ Required, SqlColumnNumber = 4 ];

/// 随访时间
Property FollowupTime As %Time [ Required, SqlColumnNumber = 5 ];

/// 随访类型
Property Type As %String [ SqlColumnNumber = 6 ];

/// 随访人员
Property UserId As %String [ Required, SqlColumnNumber = 7 ];

/// 随访状态
Property Status As %String [ Required, SqlColumnNumber = 8 ];

Index ISchedule On OperSchedule;

Storage Default
{
<Data name="OperFollowupDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>FollowupNo</Value>
</Value>
<Value name="3">
<Value>FollowupDate</Value>
</Value>
<Value name="4">
<Value>FollowupTime</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>UserId</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperFollowupD</DataLocation>
<DefaultData>OperFollowupDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperFollowupD</IdLocation>
<IndexLocation>^CIS.AN.OperFollowupI</IndexLocation>
<StreamLocation>^CIS.AN.OperFollowupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

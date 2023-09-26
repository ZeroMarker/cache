Class EPRinstance.InstanceLog Extends %Library.SerialObject [ ClassType = serial, ProcedureBlock ]
{

Property Action As %String(TRUNCATE = 1);

Property OperateDate As %String(TRUNCATE = 1);

Property FinalStatus As %String(TRUNCATE = 1);

Property InitStatus As %String(TRUNCATE = 1);

Property OperateTime As %String(TRUNCATE = 1);

Property OperateUserID As %String(TRUNCATE = 1);

Property OperateMachineIP As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property RealOperateUserID As %String(TRUNCATE = 1) [ Calculated ];

Property OperateUserName As %String(TRUNCATE = 1) [ Calculated ];

Index UniqueIdx On (OperateDate, OperateTime, OperateUserID, Action) [ Unique ];

/*
Method OperateUserIDSet(argUserId As %String) As %Status
{
	s user=""
	s user=##class(User.SSUser).%OpenId(argUserId)
	if (user="") {s i%OperateUserID=argUserId}
	else{s i%OperateUserID = user.SSUSRInitials}
	q $$$OK
}
*/

/*
Method OperateUserIDGet() As %String
{
	s user=""
	s user=##class(User.SSUser).%OpenId(i%OperateUserID)
	q:(user="") i%OperateUserID
	q user.SSUSRName ;_"("_user.SSUSRInitials_")"
}
*/
Method RealOperateUserIDGet() As %String
{
	Quit i%OperateUserID
}

Method OperateUserNameGet() As %String
{
	//q ..GetUserName(i%OperateUserID)
	s userID = i%OperateUserID 
	s user=""
	s user=##class(User.SSUser).%OpenId(userID)
	q:(user="") userID
	q user.SSUSRName ;_"("_user.SSUSRInitials_")"
}

ClassMethod GetUserName(userID As %String)
{
	s user=""
	s user=##class(User.SSUser).%OpenId(userID)
	q:(user="") userID
	q user.SSUSRName ;_"("_user.SSUSRInitials_")"
}

Storage Default
{
<Data name="InstanceLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionStr</Value>
</Value>
</Data>
<Data name="InstanceLogState">
<Subscript>"EPRinstance.InstanceLog"</Subscript>
<Value name="1">
<Value>OperateDate</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>FinalStatus</Value>
</Value>
<Value name="4">
<Value>InitStatus</Value>
</Value>
<Value name="5">
<Value>OperateTime</Value>
</Value>
<Value name="6">
<Value>OperateUserID</Value>
</Value>
<Value name="7">
<Value>OperateMachineIP</Value>
</Value>
<Value name="8">
<Value>TemplateID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.InstanceLogD</DataLocation>
<DefaultData>InstanceLogDefaultData</DefaultData>
<IdLocation>^DHCEPRI.InstanceLogD</IdLocation>
<IndexLocation>^DHCEPRI.InstanceLogI</IndexLocation>
<State>InstanceLogState</State>
<StreamLocation>^DHCEPRI.InstanceLogS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}

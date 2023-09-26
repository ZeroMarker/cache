Class ext.websys.Lock Extends (%Persistent, ext.websys.Abstract) [ Inheritance = right, Owner = {_SYSTEM} ]
{

Parameter MAJORVERSION;

Parameter MINORVERSION;

Parameter SQLFILTER;

Parameter BUILD = 47;

Parameter SQLCODE = "ID";

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

Property ClassName As %Library.String(COLLATION = "EXACT", TRUNCATE = 1);

Property Computer As %Library.String(TRUNCATE = 1);

Property ComputerName As %Library.String(TRUNCATE = 1);

/// Referenced Id of persistant class ClassName
Property Id As %Library.String(COLLATION = "EXACT", TRUNCATE = 1);

/// Date Stamp
Property LockDate As %Library.Date [ InitialExpression = {+$H} ];

Property LockTime As %Library.Time [ InitialExpression = {$p($H,",",2)} ];

Property LoginLocation As %Library.String(TRUNCATE = 1);

Property SessionId As %Library.String(COLLATION = "EXACT", TRUNCATE = 1);

Property UserDR As %Library.String(TRUNCATE = 1);

/// Inputs: <br>
/// oid - persistent class oid.<br>
/// ID+ TableName 锁数据
/// Outputs: <br>
/// msg.Information message if lock fails<br>
/// Return value:<br>
/// 1 - lock successful<br>
/// 0 - lock fails<br>
ClassMethod Lock(oid As %Library.String, sessionid As %Library.String, userid As %Library.String, ByRef returnmsg As %Library.String, loginlocation As %Library.String = "") As %Library.Boolean
{
	q ##class(websys.Lock).Lock(oid,sessionid,userid,.returnmsg,loginlocation)
}

ClassMethod LockClear(oid As %Library.String, sessionid As %Library.String)
{
	d ##class(websys.Lock).LockClear(oid,sessionid)
}

/// Clears the locks from the current computer.
/// Original called for the logon screen just to make sure the computer hasn't locked any patients.
ClassMethod LockClearComputer(comp As %Library.String)
{
	q
	d ##class(websys.Lock).LockClearComputer(comp)
}

/// Delete all locks for a session.
/// e.g. when a session timeout occurs.
ClassMethod LockClearSession(session As %Library.String)
{
	d ##Class(websys.Lock).LockClearSession(session)
}

Storage Default
{
<Data name="LockDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Computer</Value>
</Value>
<Value name="4">
<Value>ComputerName</Value>
</Value>
<Value name="5">
<Value>Id</Value>
</Value>
<Value name="6">
<Value>LockDate</Value>
</Value>
<Value name="7">
<Value>LockTime</Value>
</Value>
<Value name="8">
<Value>LoginLocation</Value>
</Value>
<Value name="9">
<Value>SessionId</Value>
</Value>
<Value name="10">
<Value>UserDR</Value>
</Value>
</Data>
<DataLocation>^ext.websys.LockD</DataLocation>
<DefaultData>LockDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ext.websys.LockD</IdLocation>
<IndexLocation>^ext.websys.LockI</IndexLocation>
<StreamLocation>^ext.websys.LockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

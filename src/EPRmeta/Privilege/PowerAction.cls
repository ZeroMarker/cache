Class EPRmeta.Privilege.PowerAction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Parameter TraceYes = "Y";

Parameter TraceNo = "N";

Property Alias As %Library.String(TRUNCATE = 1);

Property Code As %Library.String(TRUNCATE = 1);

Property BeforeStatus As %Library.String(TRUNCATE = 1);

Property AfterStatus As %Library.String(TRUNCATE = 1);

Property Description As %Library.String(TRUNCATE = 1);

/// value: TraceYes, TraceNo
Property TraceTrigger As %Library.String(TRUNCATE = 1);

ClassMethod checkTraceTrigger() As %Library.Integer
{
 k %msql
 s Num=0,traceYes=..#TraceYes
 &sql(SELECT count(*) into :Num FROM EPRmeta_Privilege.PowerAction WHERE TraceTrigger=:traceYes)
 Quit Num
}

/// ,BeforeStatus,AfterStatus
/// BeforeStatus:%Library.String,AfterStatus:%Library.String,
Query selectAll() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Alias:%Library.String,Code:%Library.String,Description:%Library.String,TraceTrigger:%Library.String,BeforeStatus:%Library.String,AfterStatus:%Library.String")
{
SELECT ID, Alias, Code, Description, TraceTrigger ,BeforeStatus,AfterStatus
FROM EPRmeta_Privilege.PowerAction
}

/// ,BeforeStatus,AfterStatus
Query selectByDesc(argDescription As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Alias,Code,Description,TraceTrigger,BeforeStatus,AfterStatus
 FROM EPRmeta_Privilege.PowerAction
 WHERE (Description = :argDescription)
}

Query selectStatusExist(argStatusID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "BeforeStatus:%Library.String")
{
SELECT BeforeStatus 
FROM EPRmeta_Privilege.PowerAction
where BeforeStatus like :argStatusID
}

Storage Default
{
<Data name="PowerActionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActionAfterStatus</Value>
</Value>
<Value name="3">
<Value>ActionAlias</Value>
</Value>
<Value name="4">
<Value>ActionBeforeStatus</Value>
</Value>
<Value name="5">
<Value>ActionCode</Value>
</Value>
<Value name="6">
<Value>ActionDesc</Value>
</Value>
<Value name="7">
<Value>ActionTraceTrigger</Value>
</Value>
<Value name="8">
<Value>AfterStatus</Value>
</Value>
<Value name="9">
<Value>Alias</Value>
</Value>
<Value name="10">
<Value>BeforeStatus</Value>
</Value>
<Value name="11">
<Value>Code</Value>
</Value>
<Value name="12">
<Value>Description</Value>
</Value>
<Value name="13">
<Value>TraceTrigger</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PowerActionD</DataLocation>
<DefaultData>PowerActionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PowerActionD</IdLocation>
<IndexLocation>^DHCEPRM.PowerActionI</IndexLocation>
<StreamLocation>^DHCEPRM.PowerActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

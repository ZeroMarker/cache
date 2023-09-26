Class EMRmeta.CustomQuery Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ClassName As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryName As %String(TRUNCATE = 1);

Property SingleResult As %String(TRUNCATE = 1);

ClassMethod SelectIDByClassName(AClassName As %String, AQueryName As %String) As %String
{
 New CountID
 New Result
 &sql(SELECT Count(ID)
 Into :CountID
 FROM EMRmeta.CustomQuery
 where QueryName= :AQueryName
 and ClassName =:AClassName)
 if (CountID=0)
 {s Result="" }
 elseif (CountID >=0)
 {
 &sql(SELECT ID
 Into :Result
 FROM EMRmeta.CustomQuery
 where QueryName= :AQueryName
 and ClassName =:AClassName)

	 }
 QUIT Result
}

Query SelectAllQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,ClassName:%String,QueryName:%String,Description:%String,SingleResult:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CustomQuery_SELECTALLQuery, SqlProc ]
{
 SELECT ID,Name, ClassName, QueryName, Description,SingleResult
 FROM EMRmeta.CustomQuery
 ORDER BY ID
}

Query Selectttt(AName As %String, AID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,ClassName:%String,QueryName:%String,Description:%String,SingleResult:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CustomQuery_SELECTttt, SqlProc ]
{
 SELECT ID,Name, ClassName, QueryName, Description,SingleResult
 FROM EMRmeta.CustomQuery
 where Name= :AName
 and ID =:AID
 ORDER BY ID
}

Storage Default
{
<Data name="CustomQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>QueryName</Value>
</Value>
<Value name="6">
<Value>SingleResult</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CustomQueryD</DataLocation>
<DefaultData>CustomQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CustomQueryD</IdLocation>
<IndexLocation>^DHCEMRM.CustomQueryI</IndexLocation>
<StreamLocation>^DHCEMRM.CustomQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

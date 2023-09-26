Class EPRmeta.BindQuery Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property ClassName As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryName As %String(TRUNCATE = 1);

Property SingleResult As %String(TRUNCATE = 1);

//1:为术语集需要的处方数据

Property Mark As %String(TRUNCATE = 1);

ClassMethod SelectIDByClassName(AClassName As %String, AQueryName As %String) As %String
{
 New CountID
 New Result
 &sql(SELECT Count(ID)
 Into :CountID
 FROM EPRmeta.BindQuery
 where QueryName= :AQueryName
 and ClassName =:AClassName)
 if (CountID=0)
 {s Result="" }
 elseif (CountID >=0)
 {
 &sql(SELECT ID
 Into :Result
 FROM EPRmeta.BindQuery
 where QueryName= :AQueryName
 and ClassName =:AClassName)

	 }
 QUIT Result
}

Query SelectAllQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,ClassName:%String,QueryName:%String,Description:%String,SingleResult:%String,Mark:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindQuery_SELECTALLQuery, SqlProc ]
{
 SELECT ID,Name, ClassName, QueryName, Description,SingleResult,Mark
 FROM EPRmeta.BindQuery
 ORDER BY ID
}

Query Selectttt(AName As %String, AID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,ClassName:%String,QueryName:%String,Description:%String,SingleResult:%String,Mark:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindQuery_SELECTttt, SqlProc ]
{
 SELECT ID,Name, ClassName, QueryName, Description,SingleResult,Mark
 FROM EPRmeta.BindQuery
 where Name= :AName
 and ID =:AID
 ORDER BY ID
}

Storage Default
{
<Data name="BindQueryDefaultData">
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
<Value>QueryName</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>SingleResult</Value>
</Value>
<Value name="7">
<Value>Mark</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.BindQueryD</DataLocation>
<DefaultData>BindQueryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.BindQueryD</IdLocation>
<IndexLocation>^DHCEPRM.BindQueryI</IndexLocation>
<StreamLocation>^DHCEPRM.BindQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

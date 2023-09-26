Class EPRmeta.CTProperty Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property PropertyDesc As %String(TRUNCATE = 1);

Property PropertyName As %String(TRUNCATE = 1);

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 new Result
 &sql(SELECT Count(ID)
 into :Result 
 FROM EPRmeta.CTProperty
 WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,PropertyName:%String,PropertyDesc:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CTProperty_SELECTALL, SqlProc ]
{
 SELECT ID, PropertyName,  PropertyDesc
 FROM EPRmeta.CTProperty
 ORDER BY ID
}

Storage Default
{
<Data name="CTPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PropertyDesc</Value>
</Value>
<Value name="3">
<Value>PropertyName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CTPropertyD</DataLocation>
<DefaultData>CTPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CTPropertyD</IdLocation>
<IndexLocation>^DHCEPRM.CTPropertyI</IndexLocation>
<StreamLocation>^DHCEPRM.CTPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

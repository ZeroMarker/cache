Class EPRmeta.CategoryType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property TypeDescription As %String(TRUNCATE = 1);

Property TypeName As %String(TRUNCATE = 1);

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 new Result
 &sql(SELECT Count(ID)
 into :Result 
 FROM EPRmeta.CategoryType
 WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TypeName:%String,TypeDescription:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CategoryType_SELECTALL, SqlProc ]
{
 SELECT ID, TypeName,  TypeDescription
 FROM EPRmeta.CategoryType
 ORDER BY ID
}

Storage Default
{
<Data name="CategoryTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeDescription</Value>
</Value>
<Value name="3">
<Value>TypeName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.CategoryTypeD</DataLocation>
<DefaultData>CategoryTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.CategoryTypeD</IdLocation>
<IndexLocation>^DHCEPRM.CategoryTypeI</IndexLocation>
<StreamLocation>^DHCEPRM.CategoryTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

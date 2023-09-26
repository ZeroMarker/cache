Class EPRmeta.UnitType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CHSName As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property ENGName As %String(TRUNCATE = 1);

ClassMethod CheckTypeCodeUnique(ACode As %String) As %Integer
{
 new Result
 &sql(SELECT Count(Code)
 into :Result 
 FROM EPRmeta.UnitType
 WHERE Code = :ACode)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SelectAllType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,ENGName:%String,CHSName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_UnitType_SELECTALL, SqlProc ]
{
SELECT ID,Code,ENGName,CHSName FROM UnitType
 ORDER BY Code
}

Storage Default
{
<Data name="UnitTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CHSName</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>ENGName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.UnitTypeD</DataLocation>
<DefaultData>UnitTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.UnitTypeD</IdLocation>
<IndexLocation>^DHCEPRM.UnitTypeI</IndexLocation>
<StreamLocation>^DHCEPRM.UnitTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

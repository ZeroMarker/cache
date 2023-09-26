Class EPRmeta.Unit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property CHSMeasurementName As %String(TRUNCATE = 1);

Property Code As %String(TRUNCATE = 1);

Property Coefficient As %String(TRUNCATE = 1);

Property Conversion As %String(TRUNCATE = 1);

Property DefaultUnit As %String(TRUNCATE = 1);

Property ENGMeasurementName As %String(TRUNCATE = 1);

Property Symbol As %String(TRUNCATE = 1);

ClassMethod CheckUniqueUnit(ACode As %String) As %Integer
{
 new Result
 &sql(SELECT Max(DefaultUnit)
 into :Result 
 FROM eprmeta.Unit
 WHERE Code = :ACode)
 if Result=""
 {s Result=0 }

 QUIT Result
}

ClassMethod UpdateCode(AOldCode As %String, ANewCode As %String)
{
 &sql(update eprmeta.Unit
 set Code = :ANewCode
 WHERE Code = :AOldCode)
}

Query SELECTALLUNIT() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,ENGMeasurementName:%String,CHSMeasurementName:%String,Symbol:%String,DefaultUnit:%String,Conversion:%String,Coefficient:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Unit_SELECTALL, SqlProc ]
{
SELECT %ID,Code,ENGMeasurementName,CHSMeasurementName,Symbol,DefaultUnit,Conversion,Coefficient
 FROM eprmeta.Unit
 ORDER BY Code
}

Query SELECTALLUNITByCode(ACode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,ENGMeasurementName:%String,CHSMeasurementName:%String,Symbol:%String,DefaultUnit:%String,Conversion:%String,Coefficient:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Unit_SELECTALLByCode, SqlProc ]
{
SELECT %ID,Code,ENGMeasurementName,CHSMeasurementName,Symbol,DefaultUnit,Conversion,Coefficient
 FROM eprmeta.Unit
 WHERE Code = :ACode
 ORDER BY Code
}

Storage Default
{
<Data name="UnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CHSMeasurementName</Value>
</Value>
<Value name="3">
<Value>CodeID</Value>
</Value>
<Value name="4">
<Value>ENGMeasurementName</Value>
</Value>
<Value name="5">
<Value>Expression</Value>
</Value>
<Value name="6">
<Value>Coefficient</Value>
</Value>
<Value name="7">
<Value>Conversion</Value>
</Value>
<Value name="8">
<Value>DefaultUnit</Value>
</Value>
<Value name="9">
<Value>Sign</Value>
</Value>
<Value name="10">
<Value>Symbol</Value>
</Value>
<Value name="11">
<Value>Code</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.UnitD</DataLocation>
<DefaultData>UnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.UnitD</IdLocation>
<IndexLocation>^DHCEPRM.UnitI</IndexLocation>
<StreamLocation>^DHCEPRM.UnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

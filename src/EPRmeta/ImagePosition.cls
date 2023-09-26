Class EPRmeta.ImagePosition Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Data As %GlobalCharacterStream(LOCATION = "^DHCEPRM.ImagePositionS");

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_ImagePosition_SELECTALL, SqlProc ]
{
 SELECT ID,Code,Name,Description 
 FROM EPRmeta.ImagePosition
 ORDER BY ID
}

ClassMethod GetIdByCode(ACode As %String) As %String
{
 new Result	 
 New NumCount
 &sql(SELECT Count(ID)
 into :NumCount
 FROM EPRmeta.ImagePosition
 WHERE Code = :ACode
  )
 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.ImagePosition
 WHERE Code = :ACode ) 
 QUIT Result	  
	  }
 elseif (NumCount=0)
 {
	Quit "" 	 }
}

Storage Default
{
<Data name="ImagePositionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>MetaData</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.ImagePositionD</DataLocation>
<DefaultData>ImagePositionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ImagePositionD</IdLocation>
<IndexLocation>^DHCEPRM.ImagePositionI</IndexLocation>
<StreamLocation>^DHCEPRM.ImagePositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

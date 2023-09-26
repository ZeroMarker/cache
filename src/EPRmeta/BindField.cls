Class EPRmeta.BindField Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property FieldType As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

//关联字典ID

Property DicID As %String(TRUNCATE = 1);

ClassMethod DelFieldByQueryId(AQueryID As %String)
{
 &sql(
 Delete 
 from EPRmeta.BindField 
 Where QueryID =:AQueryID )
}

Query SelectAllField() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,QueryID:%String,FieldName:%String,FieldType:%String,Description:%String,DicID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindField_SELECTAllField, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description, DicID
 FROM EPRmeta.BindField
 ORDER BY ID
}

Query SelectFieldByQID(AQID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String, QueryID:%String,FieldName:%String,FieldType:%String,Description:%String,DicID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_BindField_SELECTFieldByQID, SqlProc ]
{
 SELECT ID,Name, QueryID, FieldName,FieldType, Description, DicID
 FROM EPRmeta.BindField
 Where QueryID =:AQID 
 ORDER BY ID
}

Storage Default
{
<Data name="BindFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>FieldName</Value>
</Value>
<Value name="4">
<Value>FieldType</Value>
</Value>
<Value name="5">
<Value>QueryID</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>DicID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.BindFieldD</DataLocation>
<DefaultData>BindFieldDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.BindFieldD</IdLocation>
<IndexLocation>^DHCEPRM.BindFieldI</IndexLocation>
<Property name="Description">
<Selectivity>3.8462%</Selectivity>
</Property>
<Property name="FieldName">
<Selectivity>4.1667%</Selectivity>
</Property>
<Property name="FieldType">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Name">
<Selectivity>3.8462%</Selectivity>
</Property>
<Property name="QueryID">
<Selectivity>100.0000%</Selectivity>
</Property>
<StreamLocation>^DHCEPRM.BindFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

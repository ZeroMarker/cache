Class EPRservice.Util.CdataItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CdataSignNum As %String(TRUNCATE = 1);

Property CdataNum As %Integer;

Property CDATAStream As %GlobalCharacterStream(LOCATION = "^DHCEPRI.CdataItemS");

//Relationship TheCdataAggr As EPRservice.Util.CdataAggr [ Cardinality = parent, Inverse = CDataItems ];

ClassMethod DeleteCdataItems(ASessionSign As %String)
{
 &sql(Delete  FROM EPRservice_Util.CdataItem
 WHERE CdataSignNum = :ASessionSign)
}

ClassMethod GetCdataItemId(ACdataNum As %String, ACdataSignNum As %String) As %String
{
	
	New ResultCount
    new ResultID 
	&sql(select Count(ID) 
	into :ResultCount
	 FROM EPRservice_Util.CdataItem
	 where CdataSignNum = :ACdataSignNum
	 and CdataNum = :ACdataNum
	) 
 if ((ResultCount="")!(ResultCount=0))
 {
 s ResultCount=0
 s ResultID="0"
 }
 elseif '(ResultCount=0) 
 { &Sql(select ID
	    into :ResultID
	    FROM EPRservice_Util.CdataItem
	    where CdataSignNum = :ACdataSignNum
	    and CdataNum = :ACdataNum)
 }	 
 Q ResultID
}

Storage Default
{
<Data name="CdataItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDATAStream</Value>
</Value>
<Value name="3">
<Value>CdataCount</Value>
</Value>
<Value name="4">
<Value>CdataNum</Value>
</Value>
<Value name="5">
<Value>CdataSignNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.CdataItemI</DataLocation>
<DefaultData>CdataItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.CdataItemD</IdLocation>
<IndexLocation>^DHCEPRI.CdataItemI</IndexLocation>
<StreamLocation>^DHCEPRI.CdataItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

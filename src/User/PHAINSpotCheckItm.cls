Class User.PHAINSpotCheckItm Extends %Persistent [ SqlRowIdName = INSCI_RowId, SqlTableName = PHAIN_SpotCheckItm ]
{

Relationship INSCIItmParRef As User.PHAINSpotCheck [ Cardinality = parent, Inverse = ChildPHAINSpotCheckItm, SqlFieldName = INSCI_ItmParRef ];

/// 库存项id
Property INSCIInciDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = INSCI_Inci_DR ];

/// 抽检结果(是否合格)
Property INSCICheckFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = INSCI_CheckFlag ];

/// 结果描述
Property INSCICheckDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INSCI_CheckDesc ];

Storage Default
{
<Data name="PHAINSpotCheckItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>INSCIInciDR</Value>
</Value>
<Value name="3">
<Value>INSCICheckFlag</Value>
</Value>
<Value name="4">
<Value>INSCICheckDesc</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("I")</DataLocation>
<DefaultData>PHAINSpotCheckItmDefaultData</DefaultData>
<IdLocation>^BS.PHA.IN.SpotCheck($s($d(%d(0)):%d(0),$d(i%INSCIItmParRef):i%INSCIItmParRef),"I")</IdLocation>
<IndexLocation>^BS.PHA.IN.SpotChecki</IndexLocation>
<StreamLocation>^BS.PHA.IN.SpotChecks</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

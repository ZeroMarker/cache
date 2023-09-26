Class User.DHCICUUnderlyingDisease Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ICUCUD_RowId, SqlTableName = DHC_ICU_UnderlyingDisease, StorageStrategy = CacheStorage ]
{

Index UDisease On (ICUCUDCLCUDDr As Exact, ICUCUDICUADr As Exact);

Index ICUA On ICUCUDICUADr As Exact;

Property ICUCUDICUADr As User.DHCICUArrange [ SqlColumnNumber = 2, SqlFieldName = ICUCUD_ICUA_Dr ];

Property ICUCUDCLCUDDr As User.DHCCLCUnderlyingDisease [ SqlColumnNumber = 3, SqlFieldName = ICUCUD_CLCUD_Dr ];

Storage CacheStorage
{
<Data name="DHCICUUnderDiseaseClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCICUUnderDiseaseDefaultData">
<Value name="1">
<Value>ICUCUDICUADr</Value>
</Value>
<Value name="2">
<Value>ICUCUDCLCUDDr</Value>
</Value>
</Data>
<DataLocation>^DHCICUUnderlyingDisease</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCICUUnderlyingDisease</IdLocation>
<IndexLocation>^DHCICUUnderlyingDisease(0)</IndexLocation>
<SqlRowIdName>ICUCUD_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUUnderlyingDiseaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

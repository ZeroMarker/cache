Class User.DHCANROperComplication Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANROC_RowId, SqlTableName = DHC_ANR_OperComplication, StorageStrategy = CacheStorage ]
{

Relationship ANROCParref As User.DHCANRRisk [ Cardinality = parent, Inverse = ChildDHCANROperComplication, SqlFieldName = ANROC_Parref ];

Property ANROCClccDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANROC_Clcc_Dr ];

Storage CacheStorage
{
<Data name="ANROperComplicationClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="ANROperComplicationDefaultData">
<Value name="1">
<Value>ANROCClccDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OC")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("OC")</IdLocation>
<IndexLocation>{%%PARENT}("OC",0)</IndexLocation>
<SqlChildSub>ANROC_ChildSub</SqlChildSub>
<StreamLocation>^User.DHCANROperComplicationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

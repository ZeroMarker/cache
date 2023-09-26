Class User.DHCANCStockCat Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_ANC_StockCat, StorageStrategy = CacheStorage ]
{

Property ANCSCCode As %String [ SqlFieldName = ANCSC_Code ];

Property ANCSCDesc As %String [ SqlFieldName = ANCSC_Desc ];

Storage CacheStorage
{
<Data name="DHCANCStockCatClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANCStockCatDefaultData">
<Value name="1">
<Value>ANCSCCode</Value>
</Value>
<Value name="2">
<Value>ANCSCDesc</Value>
</Value>
</Data>
<DataLocation>^DHCANC("StockCat")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANC("StockCat")</IdLocation>
<IndexLocation>^DHCANC("StockCat",0)</IndexLocation>
<StreamLocation>^User.DHCANCStockCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

Class User.DHCANOPArrangeStock Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANOPAS_RowId, SqlTableName = DHC_AN_OPArrangeStock, StorageStrategy = CacheStorage ]
{

Property ANOPASANArrangeDr As %String [ SqlColumnNumber = 2, SqlFieldName = ANOPAS_ANArrange_Dr ];

Property ANOPASANCSIDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANOPAS_ANCSI_Dr ];

Property ANOPASQty As %Float [ SqlColumnNumber = 4, SqlFieldName = ANOPAS_Qty ];

Property ANOPASPreQty As %Float [ SqlColumnNumber = 5, SqlFieldName = ANOPAS_PreQty ];

Property ANOPASStockAdjQty As %Float [ SqlColumnNumber = 6, SqlFieldName = ANOPAS_StockAdjQty ];

Property ANOPASUpdateUserDr As %String [ SqlColumnNumber = 7, SqlFieldName = ANOPAS_UpdateUser_Dr ];

Property ANOPASUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = ANOPAS_UpdateDate ];

Property ANOPASUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = ANOPAS_UpdateTime ];

Property ANOPASBarCode As %String [ SqlColumnNumber = 10, SqlFieldName = ANOPAS_BarCode ];

Property ANOPASUnitQty As %String [ SqlColumnNumber = 11, SqlFieldName = ANOPAS_UnitQty ];

Property ANOPASTotalCost As %Float [ SqlColumnNumber = 12, SqlFieldName = ANOPAS_TotalCost ];

Index BarCode On ANOPASBarCode As Exact;

Index OPArrStockItem On (ANOPASANArrangeDr As Exact, ANOPASANCSIDr As Exact);

Storage CacheStorage
{
<Data name="DHCANOPArrangeStockClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANOPArrangeStockDefaultData">
<Value name="1">
<Value>ANOPASANArrangeDr</Value>
</Value>
<Value name="2">
<Value>ANOPASANCSIDr</Value>
</Value>
<Value name="3">
<Value>ANOPASQty</Value>
</Value>
<Value name="4">
<Value>ANOPASPreQty</Value>
</Value>
<Value name="5">
<Value>ANOPASStockAdjQty</Value>
</Value>
<Value name="6">
<Value>ANOPASUpdateUserDr</Value>
</Value>
<Value name="7">
<Value>ANOPASUpdateDate</Value>
</Value>
<Value name="8">
<Value>ANOPASUpdateTime</Value>
</Value>
<Value name="9">
<Value>ANOPASBarCode</Value>
</Value>
<Value name="10">
<Value>ANOPASUnitQty</Value>
</Value>
<Value name="11">
<Value>ANOPASTotalCost</Value>
</Value>
</Data>
<DataLocation>^DHCANOPArrangeStock</DataLocation>
<DefaultData>DHCANOPArrangeStockDefaultData</DefaultData>
<IdLocation>^DHCANOPArrangeStock</IdLocation>
<IndexLocation>^DHCANOPArrangeStock(0)</IndexLocation>
<StreamLocation>^User.DHCANOPArrangeStockS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

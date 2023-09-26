Class User.DHCICUTotalIOItem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ICUTIOI_RowId, SqlTableName = DHC_ICU_TotalIOItem, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUTIOIParref As User.DHCICUTotalIO [ Cardinality = parent, Inverse = ChildDHCICUTotalIOItem, Required, SqlFieldName = ICUTIOI_Parref ];

/// For P8 ///Property ICUTIOIChildSub As %Float [ InitialExpression = {$i(^DHCICUTotalIO($p($s($d(p1):p1,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUTIOI_ChildSub ];
Property ICUTIOIChildSub As %Float [ InitialExpression = {$i(^DHCICUTotalIO($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUTIOI_ChildSub ];

Index ICUTIOIChildSubIndex On ICUTIOIChildSub [ IdKey, PrimaryKey, Unique ];

Property ICUTIOIICUCIODr As User.DHCICUCIOItem [ SqlColumnNumber = 3, SqlFieldName = ICUTIOI_ICUCIO_Dr ];

Property ICUTIOIQty As %Numeric [ SqlColumnNumber = 4, SqlFieldName = ICUTIOI_Qty ];

Property ICUTIOIUomDr As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ICUTIOI_Uom_Dr ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUTIOI_ICUCIO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUTIOI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUTIOI_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCICUTotalIO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_TotalIO.ICUTIO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUTIOI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_TotalIO.ICUTIO_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUTIOI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUTotalIOItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

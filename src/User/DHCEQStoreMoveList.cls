Class User.DHCEQStoreMoveList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SML_RowID, SqlTableName = DHC_EQStoreMoveList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SML_BatchFlag
Property SMLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SML_BatchFlag ];

/// SML_EquipDR
Property SMLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = SML_EquipDR ];

/// SML_EquipName
Property SMLEquipName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SML_EquipName ];

/// SML_Hold1
Property SMLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SML_Hold1 ];

/// SML_Hold2
Property SMLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SML_Hold2 ];

/// SML_Hold3
Property SMLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SML_Hold3 ];

/// SML_Hold4
Property SMLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = SML_Hold4 ];

/// SML_Hold5
Property SMLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = SML_Hold5 ];

/// SML_InStockListDR
Property SMLInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 5, SqlFieldName = SML_InStockListDR ];

/// SML_LocationDR
Property SMLLocationDR As User.DHCEQCLocation [ SqlColumnNumber = 13, SqlFieldName = SML_LocationDR ];

/// SML_ManuFactoryDR
Property SMLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = SML_ManuFactoryDR ];

/// SML_ModelDR
Property SMLModelDR As User.DHCEQCModel [ SqlColumnNumber = 10, SqlFieldName = SML_ModelDR ];

/// SML_OriginalFee
Property SMLOriginalFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SML_OriginalFee ];

/// SML_QuantityNum
Property SMLQuantityNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = SML_QuantityNum ];

/// SML_Remark
Property SMLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SML_Remark ];

/// SML_StoreMoveDR
Property SMLStoreMoveDR As User.DHCEQStoreMove [ SqlColumnNumber = 2, SqlFieldName = SML_StoreMoveDR ];

/// SML_UnitDR
Property SMLUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SML_UnitDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQStoreMoveList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SML_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SML_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SML_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SML_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SML_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SML_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SML_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="SML_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="SML_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SML_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SML_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SML_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SML_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SML_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SML_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SML_StoreMoveDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SML_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQStoreMoveList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SML_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQStoreMoveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SML_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQStoreMoveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SML_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStoreMove">
<Global>^DHCEQStoreMoveList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SML_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StoreMove"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SML_StoreMoveDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SML_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQStoreMoveListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

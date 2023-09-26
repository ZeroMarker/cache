Class User.DHCEQInStockList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ISL_RowID, SqlTableName = DHC_EQInStockList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ISL_InStockDR
Property ISLInStockDR As User.DHCEQInStock [ SqlColumnNumber = 2, SqlFieldName = ISL_InStockDR ];

/// ISL_EquipDR
Property ISLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = ISL_EquipDR ];

/// ISL_BatchFlag
Property ISLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ISL_BatchFlag ];

/// ISL_BuyPlanListDR
Property ISLBuyPlanListDR As User.DHCEQBuyPlanList [ SqlColumnNumber = 5, SqlFieldName = ISL_BuyPlanListDR ];

/// ISL_EquipName
Property ISLEquipName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ISL_EquipName ];

/// ISL_ManuFactoryDR
Property ISLManuFactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 7, SqlFieldName = ISL_ManuFactoryDR ];

/// ISL_OriginalFee
Property ISLOriginalFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ISL_OriginalFee ];

/// ISL_QuantityNum
Property ISLQuantityNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ISL_QuantityNum ];

/// ISL_ModelDR
Property ISLModelDR As User.DHCEQCModel [ SqlColumnNumber = 10, SqlFieldName = ISL_ModelDR ];

/// ISL_UnitDR
Property ISLUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ISL_UnitDR ];

/// ISL_Hold1
Property ISLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = ISL_Hold1 ];

/// ISL_Remark
Property ISLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ISL_Remark ];

/// ISL_AppendFee
Property ISLAppendFee As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = ISL_AppendFee ];

/// ISL_EquipCatDR
Property ISLEquipCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 15, SqlFieldName = ISL_EquipCatDR ];

/// ISL_LimitYearsNum
Property ISLLimitYearsNum As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = ISL_LimitYearsNum ];

/// ISL_ItemDR
Property ISLItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 17, SqlFieldName = ISL_ItemDR ];

/// ISL_StatCatDR
Property ISLStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 18, SqlFieldName = ISL_StatCatDR ];

/// ISL_SourceType
Property ISLSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = ISL_SourceType ];

/// ISL_SourceID
Property ISLSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = ISL_SourceID ];

/// ISL_Hold2
Property ISLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ISL_Hold2 ];

/// ISL_Hold3
Property ISLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = ISL_Hold3 ];

/// ISL_Hold4
Property ISLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ISL_Hold4 ];

/// ISL_Hold5
Property ISLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = ISL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInStockList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ISL_AppendFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ISL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ISL_BuyPlanListDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ISL_EquipCatDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ISL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ISL_EquipName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ISL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ISL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ISL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ISL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ISL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ISL_InStockDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ISL_ItemDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ISL_LimitYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ISL_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ISL_ModelDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ISL_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ISL_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ISL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ISL_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ISL_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ISL_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ISL_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQInStockList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ISL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyPlanList">
<Global>^DHCEQInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyPlanList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISL_BuyPlanListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStock">
<Global>^DHCEQInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InStock"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ISL_InStockDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQInStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ISL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ISL_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ISL_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ISL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInStockListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

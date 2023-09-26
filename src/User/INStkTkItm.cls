/// IN Stock Take Item      (INSTI,294)
Class User.INStkTkItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_StkTkItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INSTIChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref To INST
Relationship INSTIINSTParRef As INStkTk [ Cardinality = parent, Inverse = ChildINStkTkItm, Required, SqlFieldName = INSTI_INST_ParRef ];

/// INSTI Childsub (New Key)
Property INSTIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INST($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"STI",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INSTI_ChildSub ];

/// Des Ref to INCLB
Property INSTIINCLBDR As INCItmLcBt [ Required, SqlColumnNumber = 3, SqlFieldName = INSTI_INCLB_DR ];

/// Quantity when Freeze Stock
Property INSTIFreezeQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 5, SqlFieldName = INSTI_FreezeQty ];

/// Date When Freeze Stock
Property INSTIFreezeDate As %Date [ SqlColumnNumber = 6, SqlFieldName = INSTI_FreezeDate ];

/// Time when Freeze Stock
Property INSTIFreezeTime As %Time [ SqlColumnNumber = 7, SqlFieldName = INSTI_FreezeTime ];

/// Stock Count Quantity(1)
Property INSTICount1Qty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 8, SqlFieldName = INSTI_Count1Qty ];

/// Stock Count Date(1)
Property INSTICount1Date As %Date [ SqlColumnNumber = 9, SqlFieldName = INSTI_Count1Date ];

/// Stock Count Time(1)
Property INSTICount1Time As %Time [ SqlColumnNumber = 10, SqlFieldName = INSTI_Count1Time ];

/// Des Ref to SSUSR
Property INSTICount1PersonDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = INSTI_Count1Person_DR ];

/// Stock Take Variance(1)
Property INSTIVariance1 As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 12, SqlFieldName = INSTI_Variance1 ];

/// Remarks
Property INSTIRemarks As %String(COLLATION = "AlphaUp", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = INSTI_Remarks ];

/// Status-(F)reeze,(E)ntered,(V)ariance,(A)dj
Property INSTIStatus As %String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = INSTI_Status ];

/// Count Date(2)
Property INSTICount2Date As %Date [ SqlColumnNumber = 16, SqlFieldName = INSTI_Count2Date ];

/// Count Time(2)
Property INSTICount2Time As %Time [ SqlColumnNumber = 17, SqlFieldName = INSTI_Count2Time ];

/// Count Quantity(2)
Property INSTICount2Qty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 18, SqlFieldName = INSTI_Count2Qty ];

/// Count User(2)
Property INSTICount2PersonDR As SSUser [ SqlColumnNumber = 19, SqlFieldName = INSTI_Count2Person_DR ];

/// Variance(2)
Property INSTIVariance2 As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 20, SqlFieldName = INSTI_Variance2 ];

/// Des Ref to CTUOM
Property INSTICTUOMDR As CTUOM [ SqlColumnNumber = 21, SqlFieldName = INSTI_CTUOM_DR ];

/// Des Ref INCI
Property INSTIINCIDR As INCItm [ SqlColumnNumber = 22, SqlFieldName = INSTI_INCI_DR ];

/// BatchNo
Property INSTIBatchNo As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = INSTI_BatchNo ];

/// ExpiryDate
Property INSTIExpiryDate As %Date [ SqlColumnNumber = 24, SqlFieldName = INSTI_ExpiryDate ];

/// Des Ref CTLOC
Property INSTICTLOCDR As CTLoc [ SqlColumnNumber = 25, SqlFieldName = INSTI_CTLOC_DR ];

/// Des Ref INADI
Property INSTIINADIDR As INAdjItm [ SqlColumnNumber = 26, SqlFieldName = INSTI_INADI_DR ];

/// Stock Code
Property INSTIStockCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = INSTI_StockCode ];

/// Stock Desc
Property INSTIStockDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = INSTI_StockDesc ];

/// Stock BarCode
Property INSTIStockBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = INSTI_StockBarCode ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INStkTkItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTkItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INStkTkItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTkItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INStkTkItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTkItm","OnBeforeDelete")
 d VALINS^at294
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INStkTkItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTkItm","OnBeforeUpdate")
 d VALUPD^at294
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTkItm","OnBeforeInsert")
 d VALINS^at294
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INStkTkItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTkItm","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINSTI">
<Data name="INSTI_BatchNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INSTI_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INSTI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INSTI_Count1Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSTI_Count1Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSTI_Count1Qty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSTI_Count1Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSTI_Count2Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSTI_Count2Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSTI_Count2Qty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSTI_Count2Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSTI_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INSTI_FreezeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSTI_FreezeQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSTI_FreezeTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSTI_INADI_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INSTI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INSTI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSTI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INSTI_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSTI_StockBarCode">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INSTI_StockCode">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INSTI_StockDesc">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INSTI_Variance1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSTI_Variance2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^INST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_StkTk.INST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarcode">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INSTI_StockBarCode})_"Z"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INSTI_StockCode})_"Z"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLBDR">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"STI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INSTI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemLocation">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ItemLoc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocBarCode">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LocCode"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({INSTI_StockBarCode})_"Z"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocCode">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LocCode"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({INSTI_StockCode})_"Z"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDesc">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LocDesc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({INSTI_StockDesc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSTI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdesc">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_StkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INSTI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_StkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STI1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INSTI_StockDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSTI_INCI_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INSTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INSTI_RowId</SqlRowIdName>
<StreamLocation>^User.INStkTkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

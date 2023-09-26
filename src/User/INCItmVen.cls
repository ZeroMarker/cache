/// Vendors who supply Inv(1060)
Class User.INCItmVen Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmVen, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INCVChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildINCItmVenDiscount As INCItmVenDiscount [ Cardinality = children, Inverse = DISCParRef ];

Relationship ChildINCItmVenCommItems As INCItmVenCommItems [ Cardinality = children, Inverse = COMMParRef ];

/// INC_Itm Parent Reference
Relationship INCVParRef As INCItm [ Cardinality = parent, Inverse = ChildINCItmVen, Required, SqlFieldName = INCV_ParRef ];

/// Childsub
Property INCVChildsub As %Float [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"VE",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INCV_Childsub ];

/// Des Ref to APCVM
Property INCVAPCVMDR As APCVendor [ SqlColumnNumber = 3, SqlFieldName = INCV_APCVM_DR ];

/// Order Lead Time
Property INCVLeadTime As %Float [ SqlColumnNumber = 4, SqlFieldName = INCV_Lead_Time ];

/// Unit Cost
Property INCVUnitCost As %Float [ SqlColumnNumber = 5, SqlFieldName = INCV_UnitCost ];

/// Date Used
Property INCVDate As %Date [ SqlColumnNumber = 6, SqlFieldName = INCV_Date ];

/// Des Ref CTUOM
Property INCVCTUOMDR As CTUOM [ SqlColumnNumber = 7, SqlFieldName = INCV_CTUOM_DR ];

/// Category
Property INCVCategory As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = INCV_Category ];

/// Code
Property INCVCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = INCV_Code ];

/// StockCode
Property INCVStockCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INCV_StockCode ];

/// Stock Description
Property INCVStockDesc As %String(COLLATION = "AlphaUp", MAXLEN = 120, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INCV_StockDesc ];

/// PO Type
Property INCVPOType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = INCV_POType ];

/// Preferent
Property INCVPreferent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INCV_Preferent ];

/// Agreed Price
Property INCVAgreedPrice As %Float [ SqlColumnNumber = 14, SqlFieldName = INCV_AgreedPrice ];

/// StockBarCode
Property INCVStockBarCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = INCV_StockBarCode ];

/// Des Ref ServiceTax
Property INCVServiceTaxDR As ARCServTax [ SqlColumnNumber = 16, SqlFieldName = INCV_ServiceTax_DR ];

/// Include GST
Property INCVIncludeGST As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INCV_IncludeGST ];

/// Claimable
Property INCVClaimable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = INCV_Claimable ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INCItmVen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INCItmVen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INCItmVen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnBeforeDelete")
 &sql(DELETE FROM INC_ItmVenDiscount WHERE DISC_ParRef=:%d(1))
 &sql(DELETE FROM INC_ItmVenCommItems WHERE COMM_ParRef=:%d(1))
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INCItmVen).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnBeforeUpdate")
 d VALUPD^at1060
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnBeforeInsert")
 d VALINS^at1060
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INCItmVen).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmVen","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INCV_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCV_AgreedPrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INCV_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INCV_Category">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INCV_Claimable">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INCV_Code">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INCV_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INCV_IncludeGST">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INCV_Lead_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INCV_POType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INCV_Preferent">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INCV_ServiceTax_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INCV_StockBarCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INCV_StockCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INCV_StockDesc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INCV_UnitCost">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBarCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VendorCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INCV_StockBarCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCV_Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INCV_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{INCV_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPOTypeCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POVendorCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCV_POType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INCV_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPOVendorDesc">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POVendorDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCV_POType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INCV_StockDesc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPOtypeVendorBarCod">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POVendorCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INCV_POType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INCV_StockBarCode})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor1">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendorStockCode">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VendorCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INCV_StockCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendorStockDesc">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INCV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VendorDesc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INCV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INCV_StockDesc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INCV_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCV_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmVenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

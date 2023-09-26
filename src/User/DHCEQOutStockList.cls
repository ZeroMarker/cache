Class User.DHCEQOutStockList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OSL_RowID, SqlTableName = DHC_EQOutStockList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OSL_OutStockDR
Property OSLOutStockDR As User.DHCEQOutStock [ SqlColumnNumber = 2, SqlFieldName = OSL_OutStockDR ];

/// OSL_BatchFlag
Property OSLBatchFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = OSL_BatchFlag ];

/// OSL_InStockListDR
Property OSLInStockListDR As User.DHCEQInStockList [ SqlColumnNumber = 4, SqlFieldName = OSL_InStockListDR ];

/// OSL_EquipDR
Property OSLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 5, SqlFieldName = OSL_EquipDR ];

/// OSL_OutQtyNum
Property OSLOutQtyNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = OSL_OutQtyNum ];

/// OSL_OutFee
Property OSLOutFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = OSL_OutFee ];

/// OSL_DealFee
Property OSLDealFee As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = OSL_DealFee ];

/// OSL_InvoiceNo
Property OSLInvoiceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = OSL_InvoiceNo ];

/// OSL_OutReasonDR
Property OSLOutReasonDR As User.DHCEQCOutReason [ SqlColumnNumber = 10, SqlFieldName = OSL_OutReasonDR ];

/// OSL_Remark
Property OSLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OSL_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQOutStockList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OSL_BatchFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OSL_DealFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OSL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OSL_InStockListDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OSL_InvoiceNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OSL_OutFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OSL_OutQtyNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OSL_OutReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OSL_OutStockDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OSL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQOutStockList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OSL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQOutStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OSL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInStockList">
<Global>^DHCEQOutStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InStockList"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OSL_InStockListDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutStock">
<Global>^DHCEQOutStockList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OSL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OutStock"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OSL_OutStockDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OSL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQOutStockListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

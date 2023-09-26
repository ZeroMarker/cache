Class User.DHCIPMealBillDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMBD_RowID, SqlTableName = DHC_IPMealBillDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCMBDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_IPMealBill Parent Reference
Relationship DHCMBDDHCMBParref As User.DHCIPMealBill [ Cardinality = parent, Inverse = ChildDHCIPMealBillDetail, Required, SqlFieldName = DHCMBD_DHCMB_Parref ];

/// DHCMBD_ChildSub
Property DHCMBDChildSub As %Library.Float [ InitialExpression = {$i(^DHCIPMEALBILL($p(%d(0),$c(1),1),"D",0))}, SqlColumnNumber = 2, SqlFieldName = DHCMBD_ChildSub ];

/// DHCMBD_DHCMO_Dr
Property DHCMBDDHCMODr As User.DHCIPMealOrdItem [ SqlColumnNumber = 3, SqlFieldName = DHCMBD_DHCMO_Dr ];

/// DHCMBD_Price
Property DHCMBDPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DHCMBD_Price ];

/// DHCMBD_Qty
Property DHCMBDQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DHCMBD_Qty ];

/// DHCMBD_TotalAmount
Property DHCMBDTotalAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DHCMBD_TotalAmount ];

/// DHCMBD_CurLoc_Dr
Property DHCMBDCurLocDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DHCMBD_CurLoc_Dr ];

/// DHCMBD_CurWard_Dr
Property DHCMBDCurWardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCMBD_CurWard_Dr ];

/// DHCMBD_BillDate
Property DHCMBDBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCMBD_BillDate ];

/// DHCMBD_BillTime
Property DHCMBDBillTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCMBD_BillTime ];

Property DHCMBDOEORIDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DHCMBD_OEORI_Dr ];

Property DHCMBDImportFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = DHCMBD_ImportFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCMBD_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCMBD_BillTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCMBD_CurLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMBD_CurWard_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMBD_DHCMO_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMBD_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCMBD_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCMBD_Price">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMBD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCMBD_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCIPMEALBILL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_IPMealBill.DHCMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCMBD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillDate">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BillDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMBD_BillDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillDateLoc">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMBD_BillDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCMBD_CurLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBillDateWard">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealBill.DHCMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMBD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMBD_CurWard_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDHCMBDDHCMODr">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealBill.DHCMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMBD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMBD_DHCMO_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexImportFlag">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealBill.DHCMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMBD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ImportFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMBD_ImportFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEOrdItemDr">
<Global>^DHCIPMEALBILL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_IPMealBill.DHCMB_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCMBD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCMBD_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_IPMealBill.DHCMB_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCMBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCIPMealBillDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

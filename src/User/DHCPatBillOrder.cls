/// Order Item Bill
Class User.DHCPatBillOrder Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBO_RowId, SqlTableName = DHC_PatBillOrder, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PBOChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PatientBill Parent Reference
Relationship PBOPBParRef As User.DHCPatientBill [ Cardinality = parent, Inverse = ChildDHCPatBillOrder, Required, SqlFieldName = PBO_PB_ParRef ];

Relationship ChildDHCPatBillDetails As User.DHCPatBillDetails [ Cardinality = children, Inverse = PBDPBOParRef ];

/// PBO_ChildSub
Property PBOChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPB($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"O",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PBO_ChildSub ];

/// Arcim Reference
Property PBOARCIMDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = PBO_ARCIM_DR ];

/// PBO_OEORI_DR
Property PBOOEORIDR As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = PBO_OEORI_DR ];

/// PBO_UnitPrice
Property PBOUnitPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PBO_UnitPrice ];

/// PBO_BillQty
Property PBOBillQty As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PBO_BillQty ];

/// RefundQty
Property PBORefundQty As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PBO_RefundQty ];

/// Order Item Amount
Property PBOToTalAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PBO_ToTalAmount ];

/// Discount Amount
Property PBODiscAmount As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PBO_DiscAmount ];

/// Insurance Share
Property PBOPayorShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PBO_PayorShare ];

/// Patient Share
Property PBOPatientShare As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PBO_PatientShare ];

/// Order Date
Property PBOOrderDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PBO_OrderDate ];

/// PBO_OrderTime
Property PBOOrderTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PBO_OrderTime ];

/// PBO_RefundFlag
Property PBORefundFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PBO_RefundFlag ];

/// PBO_OriginalBill_DR
Property PBOOriginalBillDR As User.DHCPatBillOrder [ SqlColumnNumber = 15, SqlFieldName = PBO_OriginalBill_DR ];

/// Order Billed Status Before Paid
Property PBOBillStatus As %Library.String(DISPLAYLIST = ",Billed,Refunded,To Bill,Ignore", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",B,R,TB,I") [ SqlColumnNumber = 16, SqlFieldName = PBO_BillStatus ];

/// PBO_UnitPrice
Property PBODiscPrice As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = PBO_DiscPrice ];

/// PBO_UnitPrice
Property PBOInsPrice As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PBO_InsPrice ];

/// PBO_UnitPrice
Property PBOPatPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PBO_PatPrice ];

/// PBO_OrdExec_DR
Property PBOOrdExecDR As User.OEOrdExec [ SqlColumnNumber = 20, SqlFieldName = PBO_OrdExec_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PBO_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBO_BillQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PBO_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PBO_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBO_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PBO_DiscPrice">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PBO_InsPrice">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PBO_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBO_OrdExec_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PBO_OrderDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PBO_OrderTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PBO_OriginalBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PBO_PB_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBO_PatPrice">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PBO_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PBO_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PBO_RefundFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PBO_RefundQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PBO_ToTalAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PBO_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PBO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PBO_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXARCIM">
<Global>^DHCPBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PBO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PBO_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PBO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXOEORI">
<Global>^DHCPBi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PBO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PBO_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PBO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdExc">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEEXC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBO_OrdExec_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPatBillOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

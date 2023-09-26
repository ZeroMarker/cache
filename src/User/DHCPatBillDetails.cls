/// DHC Bill Detail
Class User.DHCPatBillDetails Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBD_RowId, SqlTableName = DHC_PatBillDetails, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PBDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PatBillOrder Parent Reference
Relationship PBDPBOParRef As User.DHCPatBillOrder [ Cardinality = parent, Inverse = ChildDHCPatBillDetails, Required, SqlFieldName = PBD_PBO_ParRef ];

/// PBD_ChildSub
Property PBDChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPB($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"O",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"D",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PBD_ChildSub ];

/// PBD_TARI_DR
Property PBDTARIDR As User.DHCTarItem [ SqlColumnNumber = 3, SqlFieldName = PBD_TARI_DR ];

/// Tariff Item Unit Price
Property PBDUnitPrice As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PBD_UnitPrice ];

/// Bill Tariff Item Qty
Property PBDBillQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PBD_BillQty ];

/// Discount Rate
Property PBDDiscPerc As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PBD_DiscPerc ];

/// Tariff Item Total
Property PBDTotalAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PBD_TotalAmount ];

/// Discount Amount
Property PBDDiscAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PBD_DiscAmount ];

/// Insurance Share
Property PBDPayorShare As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PBD_PayorShare ];

/// PBD_PatientShare
Property PBDPatientShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PBD_PatientShare ];

/// Bill Date
Property PBDBillDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PBD_BillDate ];

/// PBD_BillTime
Property PBDBillTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PBD_BillTime ];

/// PBD_BillStatus
Property PBDBillStatus As %Library.String(DISPLAYLIST = ",Billed,Paid,Refund,RefundPaid", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",B,P,R,RP") [ SqlColumnNumber = 13, SqlFieldName = PBD_BillStatus ];

/// PBD_CreateDate
Property PBDCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PBD_CreateDate ];

/// PBD_CreateTime
Property PBDCreateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PBD_CreateTime ];

/// PBD_BillUser
Property PBDBillUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = PBD_BillUser ];

/// PBD_ExecDept_DR
Property PBDExecDeptDR As User.CTLoc [ SqlColumnNumber = 17, SqlFieldName = PBD_ExecDept_DR ];

/// PBD_DiscPrice
Property PBDDiscPrice As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PBD_DiscPrice ];

/// PBD_InsPrice
Property PBDInsPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PBD_InsPrice ];

/// PBD_PatPrice
Property PBDPatPrice As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = PBD_PatPrice ];

/// PBD_DSP_DR 药品的退药记录指针
Property PBDDSPDR As User.DHCOEDispensing [ SqlColumnNumber = 21, SqlFieldName = PBD_DSP_DR ];

/// PBD_ExtralFlag 补录的收费项目
Property PBDExtralFlag As %Library.String [ SqlColumnNumber = 22, SqlFieldName = PBD_ExtralFlag ];

/// PBD_Original_DR 取消收费项目的原指针(负记录对应原记录指针)
Property PBDOriginalDR As User.DHCPatBillDetails [ SqlColumnNumber = 23, SqlFieldName = PBD_Original_DR ];

/// PBD_ExtralComment 补录或取消收费项目的原指针
Property PBDExtralComment As %Library.String [ SqlColumnNumber = 24, SqlFieldName = PBD_ExtralComment ];

/// PBD_ARTI_Disc 新版申请单收费项折扣系数
Property PBDARTIDisc As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = PBD_ARTI_Disc ];

/// PBD_ARTI_DR	新版申请单中间表指针
Property PBDARTIDR As User.DHCAppRepTarItm [ SqlColumnNumber = 26, SqlFieldName = PBD_ARTI_DR ];

/// PBD_DSPB_DR	执行打包明细表DHC_OEDispBatch
Property PBDDSPBDR As User.DHCOEDispBatch [ SqlColumnNumber = 27, SqlFieldName = PBD_DSPB_DR ];

/// PBD_OldPBD_DR
Property PBDOldPBDDR As User.DHCPatBillDetails [ SqlColumnNumber = 28, SqlFieldName = PBD_OldPBD_DR ];

/// PBD_OrderLinkTar_DR ZhYW 医嘱项关联收费项关联表Id
Property PBDOrderLinkTarDR As User.DHCOrderLinkTar [ SqlColumnNumber = 29, SqlFieldName = PBD_OrderLinkTar_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PBD_ARTI_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PBD_ARTI_Disc">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PBD_BillDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PBD_BillQty">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PBD_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PBD_BillTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PBD_BillUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PBD_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBD_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PBD_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PBD_DSPB_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PBD_DSP_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PBD_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PBD_DiscPerc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PBD_DiscPrice">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PBD_ExecDept_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PBD_ExtralComment">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PBD_ExtralFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PBD_InsPrice">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PBD_OldPBD_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PBD_OrderLinkTar_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PBD_Original_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PBD_PBO_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBD_PatPrice">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PBD_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PBD_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PBD_TARI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBD_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PBD_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PatBillOrder.PBO_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PBD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"O"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatBillOrder.PBO_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{PBD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillDate">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PatBillOrder.PBO_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PBD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"BILLDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PBD_BillDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatBillOrder.PBO_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDSPBDR">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PatBillOrder.PBO_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PBD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DSPBDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PBD_DSPB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatBillOrder.PBO_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOriginalDR">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OriginalDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBD_Original_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PatBillOrder.PBO_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPBBillDate">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_PatientBill.PB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PatBillOrder.PBO_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>PBD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PBBILLDATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBD_BillDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PatBillOrder.PBO_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTariItm">
<Global>^DHCPB</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"TARI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PBD_TARI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatientBill.PB_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_PatBillOrder.PBO_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{PBD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPatBillDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}

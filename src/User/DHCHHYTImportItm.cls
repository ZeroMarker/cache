/// HHYT child table
Class User.DHCHHYTImportItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHII_RowID, SqlTableName = DHC_HHYTImportItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHIIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_HHImport Parent Reference
Relationship DHIIParref As User.DHCHHImport [ Cardinality = parent, Inverse = ChildDHCHHYTImportItm, Required, SqlFieldName = DHII_Parref ];

/// child sub
Property DHIIChildSub As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHII_ChildSub ];

/// inci code
Property DHIIincicode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHII_incicode ];

/// inci bar code
Property DHIIincibarcode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHII_incibarcode ];

/// uom desc
Property DHIIuomdesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHII_uomdesc ];

/// DHII_batno
Property DHIIbatno As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DHII_batno ];

/// DHII_rprice
Property DHIIrprice As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DHII_rprice ];

/// DHII_poqty
Property DHIIpoqty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DHII_poqty ];

/// DHII_realqty
Property DHIIrealqty As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DHII_realqty ];

/// DHII_date
Property DHIIdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DHII_date ];

/// DHII_invno
Property DHIIinvno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHII_invno ];

/// DHII_invdate
Property DHIIinvdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DHII_invdate ];

/// DHII_expdate
Property DHIIexpdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DHII_expdate ];

/// DHII_invamt
Property DHIIinvamt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DHII_invamt ];

/// DHII_pprice
Property DHIIpprice As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DHII_pprice ];

/// DHII_sprice
Property DHIIsprice As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DHII_sprice ];

/// DHII_disp
Property DHIIdisp As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DHII_disp ];

/// DHII_manfdesc
Property DHIImanfdesc As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHII_manfdesc ];

/// DHII_vendordesc
Property DHIIvendordesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHII_vendordesc ];

/// DHII_Vendor_DR
Property DHIIVendorDR As User.APCVendor [ SqlColumnNumber = 20, SqlFieldName = DHII_Vendor_DR ];

/// DHIT_ProduceDate
Property DHITProduceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = DHIT_ProduceDate ];

/// DHII_InvCode
Property DHIIInvCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DHII_InvCode ];

/// DHII_TaxRate
Property DHIITaxRate As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = DHII_TaxRate ];

/// in_purplanitm
Property DHIIPPIDr As User.INPurPlanItm [ SqlColumnNumber = 24, SqlFieldName = DHII_PPI_Dr ];

/// 单位id
Property DHIIUomDr As User.CTUOM [ SqlColumnNumber = 25, SqlFieldName = DHII_Uom_Dr ];

/// 厂商id
Property DHIIManfDr As User.PHManufacturer [ SqlColumnNumber = 26, SqlFieldName = DHII_Manf_Dr ];

/// 外部系统ID,第三方明细ID
Property DHIIExtPoID As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DHII_ExtPoID ];

/// 是否入库
Property DHIIRecFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = DHII_RecFlag ];

/// HIS订单子表ID
Property DHIIPoDr As User.INPOItm [ SqlColumnNumber = 29, SqlFieldName = DHII_Po_Dr ];

/// DHII_Remark
Property DHIIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DHII_Remark ];

/// 请求科室id
Property DHIIReqLocDr As User.CTLoc [ SqlColumnNumber = 31, SqlFieldName = DHII_ReqLoc_Dr ];

/// 入库接收确认人 第三方传
Property DHIICheckUserCode As %Library.String [ SqlColumnNumber = 32, SqlFieldName = DHII_CheckUserCode ];

/// 入库子表id
Property DHIIIngrDr As User.DHCINGdRecItm [ SqlColumnNumber = 33, SqlFieldName = DHII_Ingr_Dr ];

/// 箱号 很长
Property DHIIPackageNo As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = DHII_PackageNo ];

/// 基本单位条码串 很长
Property DHIIBaseBarCodeStr As %Library.String(COLLATION = "Exact", MAXLEN = 90000, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = DHII_BaseBarCodeStr ];

/// 实际收货数量
Property DHIIFaceScanQty As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = DHII_FaceScanQty ];

/// 随行单号
Property DHIISXNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = DHII_SXNo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHII_BaseBarCodeStr">
<Node>"BaseBarCode"</Node>
</Data>
<Data name="DHII_CheckUserCode">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHII_ExtPoID">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHII_FaceScanQty">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHII_Ingr_Dr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHII_InvCode">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHII_Manf_Dr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHII_PPI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHII_PackageNo">
<Node>"PackNo"</Node>
</Data>
<Data name="DHII_Po_Dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHII_RecFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHII_Remark">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHII_ReqLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHII_SXNo">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHII_TaxRate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHII_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHII_Vendor_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHII_batno">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHII_date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHII_disp">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHII_expdate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHII_incibarcode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHII_incicode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHII_invamt">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHII_invdate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHII_invno">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHII_manfdesc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHII_poqty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHII_pprice">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHII_realqty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHII_rprice">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHII_sprice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHII_uomdesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHII_vendordesc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHIT_ProduceDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCHI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_HHImport.DHI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHII_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_HHImport.DHI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHII_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDHIIVendorDR">
<Global>^DHCHI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_HHImport.DHI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DHII_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"VendorID"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHII_Vendor_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_HHImport.DHI_RowID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHII_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIngrItm">
<Global>^DHCHI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_HHImport.DHI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHII_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Ingritm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHII_Ingr_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_HHImport.DHI_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHII_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPI">
<Global>^DHCHI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_HHImport.DHI_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHII_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHII_PPI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_HHImport.DHI_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHII_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCHHYTImportItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

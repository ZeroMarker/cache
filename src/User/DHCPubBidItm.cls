Class User.DHCPubBidItm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCPBI_Rowid, SqlTableName = DHC_PubBidItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCPBIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PublicBiddingList Parent Reference
Relationship DHCPBIPBParref As User.DHCPublicBiddingList [ Cardinality = parent, Inverse = ChildDHCPubBidItm, Required, SqlFieldName = DHCPBI_PB_Parref ];

/// DHCPBI_GeneralDesc
Property DHCPBIGeneralDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DHCPBI_GeneralDesc ];

/// DHCPBI_GoodsDesc
Property DHCPBIGoodsDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DHCPBI_GoodsDesc ];

/// DHCPBI_DrugForm
Property DHCPBIDrugForm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCPBI_DrugForm ];

/// DHCPBI_INCI_DR
Property DHCPBIINCIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCPBI_INCI_DR ];

/// DHCPBI_QualityLevel
Property DHCPBIQualityLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCPBI_QualityLevel ];

/// DHCPBI_Package
Property DHCPBIPackage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCPBI_Package ];

/// DHCPBI_PackMaterial
Property DHCPBIPackMaterial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCPBI_PackMaterial ];

/// DHCPBI_TradeMark
Property DHCPBITradeMark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCPBI_TradeMark ];

/// DHCPBI_UOM
Property DHCPBIUOM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DHCPBI_UOM ];

/// DHCPBI_PurchPrice
Property DHCPBIPurchPrice As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DHCPBI_PurchPrice ];

/// DHCPBI_SP
Property DHCPBISP As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = DHCPBI_SP ];

/// DHCPBI_SP_Max
Property DHCPBISPMax As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DHCPBI_SP_Max ];

/// DHCPBI_SP_Type
Property DHCPBISPType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCPBI_SP_Type ];

/// DHCPBI_VendorDesc
Property DHCPBIVendorDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DHCPBI_VendorDesc ];

/// DHCPBI_Manf
Property DHCPBIManf As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCPBI_Manf ];

/// DHCPBI_Carrier
Property DHCPBICarrier As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCPBI_Carrier ];

/// DHCPBI_Fittings
Property DHCPBIFittings As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCPBI_Fittings ];

/// DHCPBI_PurchQty
Property DHCPBIPurchQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DHCPBI_PurchQty ];

/// DHCPBI_PurchWavyRate
Property DHCPBIPurchWavyRate As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = DHCPBI_PurchWavyRate ];

/// DHCPBI_EffDateFrom
Property DHCPBIEffDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = DHCPBI_EffDateFrom ];

/// DHCPBI_EffDateTo
Property DHCPBIEffDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = DHCPBI_EffDateTo ];

/// DHCPBI_Remark
Property DHCPBIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DHCPBI_Remark ];

/// DHPBI_ChildSub
Property DHCPBIChildSub As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = DHCPBI_ChildSub ];

/// DHCPBI_APCVM_DR
Property DHCPBIAPCVMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = DHCPBI_APCVM_DR ];

/// DHCPBI_MANF_DR
Property DHCPBIMANFDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DHCPBI_MANF_DR ];

/// DHCPBI_CTUOM_DR
Property DHCPBICTUOMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = DHCPBI_CTUOM_DR ];

/// DHCPBI_CARR_DR
Property DHCPBICARRDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = DHCPBI_CARR_DR ];

/// DHCPBI_PrePurPrice
Property DHCPBIPrePurPrice As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = DHCPBI_PrePurPrice ];

/// DHCPBI_PreSP
Property DHCPBIPreSP As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = DHCPBI_PreSP ];

/// DHCPBI_Number
Property DHCPBINumber As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = DHCPBI_Number ];

/// DHCPBI_Marker
Property DHCPBIMarker As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = DHCPBI_Marker ];

/// DHCPBI_PurBack
Property DHCPBIPurBack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 34, SqlFieldName = DHCPBI_PurBack ];

/// DHCPBI_MR_Dr
Property DHCPBIMRDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = DHCPBI_MR_Dr ];

/// DHCPBI_PurOrder
Property DHCPBIPurOrder As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = DHCPBI_PurOrder ];

/// DHCPBI_WTF_DR
Property DHCPBIWTFDR As User.DHCWinTenderFlag [ SqlColumnNumber = 37, SqlFieldName = DHCPBI_WTF_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPubBidItm">
<Data name="DHCPBI_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCPBI_CARR_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHCPBI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCPBI_Carrier">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCPBI_DrugForm">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPBI_EffDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCPBI_EffDateTo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCPBI_Fittings">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCPBI_GeneralDesc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPBI_GoodsDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPBI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPBI_MANF_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCPBI_MR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHCPBI_Manf">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCPBI_Marker">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHCPBI_Number">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHCPBI_PackMaterial">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCPBI_Package">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPBI_PrePurPrice">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHCPBI_PreSP">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHCPBI_PurBack">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHCPBI_PurOrder">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHCPBI_PurchPrice">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCPBI_PurchQty">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCPBI_PurchWavyRate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCPBI_QualityLevel">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPBI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCPBI_SP">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCPBI_SP_Max">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCPBI_SP_Type">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCPBI_TradeMark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCPBI_UOM">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCPBI_VendorDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCPBI_WTF_DR">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Global>^DHCPBLIST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PublicBiddingList.DHCPBL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCPBI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PublicBiddingList.DHCPBL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCPBI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApcVendor">
<Global>^DHCPBLIST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PublicBiddingList.DHCPBL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCPBI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"APCVENDOR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PublicBiddingList.DHCPBL_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCPBI_APCVM_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHCPBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCPBLIST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PublicBiddingList.DHCPBL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHCPBI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PublicBiddingList.DHCPBL_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCPBI_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHCPBI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPubBidItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

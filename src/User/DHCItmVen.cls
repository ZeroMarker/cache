Class User.DHCItmVen Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCIV_Rowid, SqlTableName = DHC_ItmVen, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCIV_INCI_DR
Property DHCIVINCIDR As User.INCItm [ SqlColumnNumber = 2, SqlFieldName = DHCIV_INCI_DR ];

/// DHCIV_PurPrice
Property DHCIVPurPrice As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = DHCIV_PurPrice ];

/// DHCIV_APCVM_DR
Property DHCIVAPCVMDR As User.APCVendor [ SqlColumnNumber = 4, SqlFieldName = DHCIV_APCVM_DR ];

/// DHCIV_StartDate
Property DHCIVStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCIV_StartDate ];

/// DHCIV_EndDate
Property DHCIVEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCIV_EndDate ];

/// DHCIV_MANF_DR
Property DHCIVMANFDR As User.PHManufacturer [ SqlColumnNumber = 7, SqlFieldName = DHCIV_MANF_DR ];

/// DHCIV_Carrier_DR
Property DHCIVCarrierDR As User.DHCCarrier [ SqlColumnNumber = 8, SqlFieldName = DHCIV_Carrier_DR ];

/// DHCIV_PBL_DR
Property DHCIVPBLDR As User.DHCPublicBiddingList [ SqlColumnNumber = 9, SqlFieldName = DHCIV_PBL_DR ];

/// DHCIV_SalePrice
Property DHCIVSalePrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DHCIV_SalePrice ];

/// DHCIV_SP_Max
Property DHCIVSPMax As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = DHCIV_SP_Max ];

/// DHCIV_QualityLevel
Property DHCIVQualityLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DHCIV_QualityLevel ];

/// DHCIV_Remark
Property DHCIVRemark As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DHCIV_Remark ];

/// DHCIV_PrePurPrice
Property DHCIVPrePurPrice As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DHCIV_PrePurPrice ];

/// DHCIV_PreSP
Property DHCIVPreSP As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DHCIV_PreSP ];

/// DHCIV_Number
Property DHCIVNumber As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DHCIV_Number ];

/// DHCIV_Marker
Property DHCIVMarker As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DHCIV_Marker ];

/// DHCIV_PurBack
Property DHCIVPurBack As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = DHCIV_PurBack ];

/// DHCIV_PBI_DR
Property DHCIVPBLIDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DHCIV_PBLI_DR ];

/// DHCIV_ItmType
Property DHCIVItmType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DHCIV_ItmType ];

/// DHCIV_MR_Dr
Property DHCIVMRDr As User.DHCMarkRule [ SqlColumnNumber = 21, SqlFieldName = DHCIV_MR_Dr ];

/// DHCIV_PurOrder
Property DHCIVPurOrder As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = DHCIV_PurOrder ];

/// DHCIV_WTF_DR
Property DHCIVWTFDR As User.DHCWinTenderFlag [ SqlColumnNumber = 23, SqlFieldName = DHCIV_WTF_DR ];

/// DHCIV_WinType_DR
Property DHCIVWinTypeDR As User.DHCWinType [ SqlColumnNumber = 24, SqlFieldName = DHCIV_WinType_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCIV)</SqlIdExpression>
<SQLMap name="DataMasterDHCItmVen">
<Data name="DHCIV_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCIV_Carrier_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCIV_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCIV_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCIV_ItmType">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCIV_MANF_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCIV_MR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCIV_Marker">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCIV_Number">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCIV_PBLI_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCIV_PBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCIV_PrePurPrice">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCIV_PreSP">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCIV_PurBack">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCIV_PurOrder">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCIV_PurPrice">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCIV_QualityLevel">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCIV_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCIV_SP_Max">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCIV_SalePrice">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCIV_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCIV_WTF_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCIV_WinType_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCIV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCIV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCIV_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIV_Rowid</Field>
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
<Expression>{DHCIV_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCIV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInciMarker">
<Global>^DHCIV</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCIV_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InciMarker"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIV_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCIV_Marker}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCIV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCIV_ItmType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCIV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendor">
<Global>^DHCIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCIV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"VEN"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCIV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCIV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmVenS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCIV)
	s oldI = +$g(^mdata("DHCITMVEN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCIV = maxI
	s ^mdata("DHCITMVEN") = maxI
}

}

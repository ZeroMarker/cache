/// IN Issue/Transfer Item(DHCINIT,373)
Class User.DHCInIsTrfItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INITI_RowId, SqlTableName = DHC_InIsTrfItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Index RowIDBasedIDKeyIndex On INITIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_InIsTrf Parent Reference
Relationship INITIINITParRef As User.DHCInIsTrf [ Cardinality = parent, Inverse = ChildDHCInIsTrfItm, Required, SqlFieldName = INITI_INIT_ParRef ];

/// INITI_AckQty
Property INITIAckQty As %Library.Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 2, SqlFieldName = INITI_AckQty ];

/// INITI_ChildSub
Property INITIChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCINIT($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"ITI",0))}, SqlColumnNumber = 3, SqlFieldName = INITI_ChildSub ];

/// INITI_DateAcknow
Property INITIDateAcknow As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = INITI_DateAcknow ];

/// INITI_INCLB_DR
Property INITIINCLBDR As User.INCItmLcBt [ Required, SqlColumnNumber = 5, SqlFieldName = INITI_INCLB_DR ];

/// INITI_INRQI_DR
Property INITIINRQIDR As User.INReqItm [ InitialExpression = {$g(INRQIrow)}, SqlColumnNumber = 6, SqlFieldName = INITI_INRQI_DR ];

/// INITI_Qty
Property INITIQty As %Library.Float(MAXVAL = 999999999999, MINVAL = -9999999999) [ Required, SqlColumnNumber = 7, SqlFieldName = INITI_Qty ];

/// INITI_ScanFlag
Property INITIScanFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = INITI_ScanFlag ];

/// INITI_TimeAcknow
Property INITITimeAcknow As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = INITI_TimeAcknow ];

/// INITI_ToLoc_DR
Property INITIToLocDR As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = INITI_ToLoc_DR ];

/// INITI_Type
Property INITIType As %Library.String(DISPLAYLIST = ",Issue,Transfer", MAXLEN = 8, SELECTIVITY = "50.0000%", VALUELIST = ",I,T") [ Required, SqlColumnNumber = 11, SqlFieldName = INITI_Type ];

/// INITI_UCost
Property INITIUCost As %Library.Float(MAXVAL = 999999999999, MINVAL = -9999999999) [ SqlColumnNumber = 12, SqlFieldName = INITI_UCost ];

/// INITI_UserAck_DR
Property INITIUserAckDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = INITI_UserAck_DR ];

/// INITI_CTUOM_DR
Property INITICTUOMDR As User.CTUOM [ SqlColumnNumber = 14, SqlFieldName = INITI_CTUOM_DR ];

/// DHCITI_PPAmount
Property DHCITIPPAmount As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DHCITI_PPAmount ];

/// DHCITI_PurPrice
Property DHCITIPurPrice As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = DHCITI_PurPrice ];

/// DHCITI_RealPrice
Property DHCITIRealPrice As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = DHCITI_RealPrice ];

/// DHCITI_RPAmount
Property DHCITIRPAmount As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = DHCITI_RPAmount ];

/// DHCITI_SalePrice
Property DHCITISalePrice As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = DHCITI_SalePrice ];

/// DHCITI_SPAmount
Property DHCITISPAmount As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = DHCITI_SPAmount ];

/// pointer to Is_TrfItm
Property INITIIsTrfItmDR As User.INIsTrfItm [ SqlColumnNumber = 23, SqlFieldName = INITI_IsTrfItm_DR ];

/// INITI_AdjSpFlag
Property INITIAdjSpFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INITI_AdjSpFlag ];

/// DHCITI_NewSp
Property DHCITINewSp As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = DHCITI_NewSp ];

/// DHCITI_NewSpAmt
Property DHCITINewSpAmt As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = DHCITI_NewSpAmt ];

/// DHCITI_State
Property DHCITIState As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = DHCITI_State ];

/// DHCITI_Remark
Property DHCITIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DHCITI_Remark ];

/// DHCITI_TrfReason
Property DHCITITrfReason As User.DHCReasonForTrfIn [ SqlColumnNumber = 29, SqlFieldName = DHCITI_TrfReason ];

/// INITI_INGRI_DR
Property INITIINGRIDR As User.DHCINGdRecItm [ SqlColumnNumber = 30, SqlFieldName = INITI_INGRI_DR ];

/// INITI_SpecList
Property INITISpecList As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INITI_SpecList ];

/// INITI_ITI_DR
Property INITIITIDR As User.DHCInIsTrfItm [ SqlColumnNumber = 32, SqlFieldName = INITI_ITI_DR ];

/// INITI_UserOutAck_DR
Property INITIUserOutAckDR As User.SSUser [ SqlColumnNumber = 33, SqlFieldName = INITI_UserOutAck_DR ];

/// 加工方式
Property INITIProcessMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INITI_ProcessMode ];

/// 加工费用
Property INITIProcessCost As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = INITI_ProcessCost ];

/// 冷链温度
Property INITIColdChainTemp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INITI_ColdChainTemp ];

/// 建议数量
Property INITIProQty As %Library.Float(MAXVAL = 999999999, MINVAL = 0) [ SqlColumnNumber = 37, SqlFieldName = INITI_ProQty ];

/// 库存项ID
ClassMethod Inci(Inclb)
{
	q:Inclb="" ""
	q +Inclb
}

/// 供给科室ID
ClassMethod FrLoc(Inclb)
{
	q:Inclb="" ""
	s Inci=+Inclb
	s il=$P(Inclb,"||",2)
	q:'$D(^INCI(Inci,"IL",il)) ""
	q $P(^INCI(Inci,"IL",il),"^",1)
}

/// 检查库存项是否是麻醉精一药品
ClassMethod CheckPoison(Inci)
{
	s MTIfExist = ##class(%Dictionary.MethodDefinition).%ExistsId("web.DHCST.Common.DrugInfoCommon||CheckPoisonForVendor")
	q:MTIfExist=0 "N"
	q ##Class(web.DHCST.Common.DrugInfoCommon).CheckPoisonForVendor(Inci)
}

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SQLMap name="DataMasterDHCINITI">
<Data name="DHCITI_NewSp">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCITI_NewSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCITI_PPAmount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCITI_PurPrice">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCITI_RPAmount">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCITI_RealPrice">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCITI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCITI_SPAmount">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCITI_SalePrice">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCITI_State">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCITI_TrfReason">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INITI_AckQty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INITI_AdjSpFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INITI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INITI_ColdChainTemp">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INITI_DateAcknow">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INITI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INITI_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INITI_INRQI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INITI_ITI_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INITI_IsTrfItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INITI_ProQty">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INITI_ProcessCost">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INITI_ProcessMode">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INITI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INITI_ScanFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INITI_SpecList">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INITI_TimeAcknow">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INITI_ToLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INITI_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INITI_UCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INITI_UserAck_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INITI_UserOutAck_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Global>^DHCINIT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ITI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INITI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInclb">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INITI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIngri">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INGRI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INITI_INGRI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIniti">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INITI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INITI_ITI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIsTrfItmDr">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INISTRFITM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INITI_IsTrfItm_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOnStateDateLoc">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Statei"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCITI_State}</Expression>
</Subscript>
<Subscript name="4">
<Expression>..FrLoc({INITI_INCLB_DR})</Expression>
</Subscript>
<Subscript name="5">
<Expression>..Inci({INITI_INCLB_DR})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INITI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutsItem">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutsINCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{INITI_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoison">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POISON"</Expression>
</Subscript>
<Subscript name="3">
<Expression>..CheckPoison(+{INITI_INCLB_DR})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReqItm">
<Global>^DHCINIT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InIsTrf.INIT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INITI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RQI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INITI_INRQI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InIsTrf.INIT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INITI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInIsTrfItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCPEPreIOrdItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIOI_RowId, SqlTableName = DHC_PE_PreIOrdItem, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIOrdItem";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PIOIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPEPreIOrdItemFee As User.DHCPEPreIOrdItemFee [ Cardinality = children, Inverse = PIOIFParRef ];

Relationship ChildDHCPEPreIOrdItemTarItem As User.DHCPEPreIOrdItemTarItem [ Cardinality = children, Inverse = PIOITParRef ];

/// DHC_PE_PreIADM Parent Reference
Relationship PIOIParRef As User.DHCPEPreIADM [ Cardinality = parent, Inverse = ChildDHCPEPreIOrdItem, Required, SqlFieldName = PIOI_ParRef ];

/// PIOI_ChildSub
Property PIOIChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEPreIADM($p(%d(0),$c(1),1),"ORDITEM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PIOI_ChildSub ];

/// PIOI_ItmMast_DR
Property PIOIItmMastDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PIOI_ItmMast_DR ];

/// PIOI_OrdEnt_DR
Property PIOIOrdEntDR As User.DHCPEPreIOrdEnt [ SqlColumnNumber = 4, SqlFieldName = PIOI_OrdEnt_DR ];

/// PIOI_ARCOS_DR
Property PIOIARCOSDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PIOI_ARCOS_DR ];

/// PIOI_GTOI_DR
Property PIOIGTOIDR As User.DHCPEPreGTOrdItem [ SqlColumnNumber = 6, SqlFieldName = PIOI_GTOI_DR ];

/// PIOI_AddOrdItem
Property PIOIAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = PIOI_AddOrdItem ];

/// PIOI_FactAmount
Property PIOIFactAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 8, SqlFieldName = PIOI_FactAmount ];

/// PIOI_PrivilegeMode
Property PIOIPrivilegeMode As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PIOI_PrivilegeMode ];

/// PIOI_Privilege
Property PIOIPrivilege As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PIOI_Privilege ];

/// PIOI_AsCharged
Property PIOIAsCharged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PIOI_AsCharged ];

/// PIOI_PAudit_DR
Property PIOIPAuditDR As User.DHCPEPreAudit [ SqlColumnNumber = 12, SqlFieldName = PIOI_PAudit_DR ];

/// PIOI_UpdateUser_DR
Property PIOIUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PIOI_UpdateUser_DR ];

/// PIOI_UpdateDate
Property PIOIUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 14, SqlFieldName = PIOI_UpdateDate ];

/// PIOI_UpdateTime
Property PIOIUpdateTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PIOI_UpdateTime ];

/// PIOI_AccountAmount
Property PIOIAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 16, SqlFieldName = PIOI_AccountAmount ];

/// PIOI_Type
Property PIOIType As %Library.String(DISPLAYLIST = ",PreReg,AddOrder", MAXLEN = 8, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",PRE,ADD") [ SqlColumnNumber = 17, SqlFieldName = PIOI_Type ];

/// PIOI_ItemStat
Property PIOIItemStat As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PIOI_ItemStat ];

/// PIOI_ItemRecLoc_DR
Property PIOIItemRecLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PIOI_ItemRecLoc_DR ];

/// 延期标志
Property PIOIPostponedFlag As %String [ SqlColumnNumber = 20, SqlFieldName = PIOI_PostponedFlag ];

/// 延期原因（01客户要求、02暂不满足检查条件、03其他原因）
Property PIOIPostponedReason As %String [ SqlColumnNumber = 21, SqlFieldName = PIOI_PostponedReason ];

/// 延期日期
Property PIOIPostponedDate As %Date [ SqlColumnNumber = 22, SqlFieldName = PIOI_PostponedDate ];

/// 延期人 指向SS_User
Property PIOIPostponedUser As %String [ SqlColumnNumber = 23, SqlFieldName = PIOI_PostponedUser ];

/// 【新加】科室站点项目扩展表ID（注：科室站点项目扩展表->站点项目组合表【医嘱项ID】与本表中【PIOIItmMastDR】字段对应）
Property PIOISTOrderSetDR As User.DHCPEStationOrderSet [ SqlColumnNumber = 24, SqlFieldName = PIOI_STOrderSetDR ];

/// 【新加】体检项目开单科室 指向CT_Loc
Property PIOIOrderLocDR As %String [ SqlColumnNumber = 25, SqlFieldName = PIOI_OrderLocDR ];

/// PIOI_SpecType  标本类型
Property PIOISpecType As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = PIOI_SpecType ];

/// PIOI_SpecType   his医嘱id
Property PIOIOEOrdItemID As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PIOI_OEOrdItemID ];

/// CRMO_BillStatus  已付费、未付费、视同收费标记
Property PIOIBillStatus As %Library.String(DISPLAYLIST = ",NoPaid,OnCredit,Paid,PartPaid", MAXLEN = 8, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",NP,OC,P,PP") [ SqlColumnNumber = 28, SqlFieldName = PIOI_BillStatus ];

/// PIOI_CurAccountAmount  当前收费项对应的项目金额
Property PIOICurAccountAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 29, SqlFieldName = PIOI_CurAccountAmount ];

/// 【新加】PIOI_DoseQty 剂量
Property PIOIDoseQty As %Float [ SqlColumnNumber = 30, SqlFieldName = PIOI_DoseQty ];

/// 【新加】PIOI_UOM_DR 剂量单位
Property PIOIUOMDR As CTUOM [ SqlColumnNumber = 31, SqlFieldName = PIOI_UOM_DR ];

/// 【新加】PIOI_Freq_DR 频次
Property PIOIFreqDR As PHCFreq [ SqlColumnNumber = 32, SqlFieldName = PIOI_Freq_DR ];

/// 【新加】PIOI_Durat_DR 疗程
Property PIOIDuratDR As PHCDuration [ SqlColumnNumber = 33, SqlFieldName = PIOI_Durat_DR ];

/// 【新加】PIOI_Instruc_DR 用法
Property PIOIInstrucDR As PHCInstruc [ SqlColumnNumber = 34, SqlFieldName = PIOI_Instruc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEPreIADM">
<Data name="PIOI_ARCOS_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIOI_AccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PIOI_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIOI_AsCharged">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIOI_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PIOI_CurAccountAmount">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PIOI_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PIOI_Durat_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PIOI_FactAmount">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIOI_Freq_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PIOI_GTOI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIOI_Instruc_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PIOI_ItemRecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PIOI_ItemStat">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PIOI_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIOI_OEOrdItemID">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PIOI_OrdEnt_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIOI_OrderLocDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PIOI_PAudit_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIOI_PostponedDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PIOI_PostponedFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PIOI_PostponedReason">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PIOI_PostponedUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PIOI_Privilege">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIOI_PrivilegeMode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIOI_STOrderSetDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PIOI_SpecType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PIOI_Type">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PIOI_UOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PIOI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIOI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PIOI_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCPEPreIADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ORDITEM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCOS">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCOS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOI_ARCOS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGTOI">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GTOI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOI_GTOI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItmMast">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOI_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdEnt">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrdEnt"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOI_OrdEnt_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPIOIPAType">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PIOIPAType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIOI_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDateTime">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PE_PreIADM.PIADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PIOI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIOI_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIOI_UpdateTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_PreIADM.PIADM_RowId}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PIOI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

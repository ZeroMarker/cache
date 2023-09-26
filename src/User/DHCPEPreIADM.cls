Class User.DHCPEPreIADM Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIADM_RowId, SqlTableName = DHC_PE_PreIADM, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreIADM";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEPreIOrdEnt As User.DHCPEPreIOrdEnt [ Cardinality = children, Inverse = PIOEParRef ];

Relationship ChildDHCPEPreIOrdItem As User.DHCPEPreIOrdItem [ Cardinality = children, Inverse = PIOIParRef ];

Relationship ChildDHCPEPreIEndanger As User.DHCPEPreIEndanger [ Cardinality = children, Inverse = PIOEDParRef ];

/// PIADM_AddOrdItem
Property PIADMAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PIADM_AddOrdItem ];

/// PIADM_AddOrdItemAmount
Property PIADMAddOrdItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 13, SqlFieldName = PIADM_AddOrdItemAmount ];

/// PIADM_AddOrdItemLimit
Property PIADMAddOrdItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PIADM_AddOrdItemLimit ];

/// PIADM_AddPhcItem
Property PIADMAddPhcItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PIADM_AddPhcItem ];

/// PIADM_AddPhcItemAmount
Property PIADMAddPhcItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 16, SqlFieldName = PIADM_AddPhcItemAmount ];

/// PIADM_AddPhcItemLimit
Property PIADMAddPhcItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = PIADM_AddPhcItemLimit ];

/// PIADM_AsCharged
Property PIADMAsCharged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PIADM_AsCharged ];

/// PIADM_BookDateBegin
Property PIADMBookDateBegin As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 5, SqlFieldName = PIADM_BookDateBegin ];

/// PIADM_BookDateEnd
Property PIADMBookDateEnd As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = PIADM_BookDateEnd ];

/// PIADM_BookTime
Property PIADMBookTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PIADM_BookTime ];

/// PIADM_DelayDate
Property PIADMDelayDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 20, SqlFieldName = PIADM_DelayDate ];

/// PIADM_DepCode_DR
Property PIADMDepCodeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PIADM_DepCode_DR ];

/// PIADM_DisChargedMode
Property PIADMDisChargedMode As %Library.String(DISPLAYLIST = ",GDischarged,IDischarged", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GD,ID") [ SqlColumnNumber = 18, SqlFieldName = PIADM_DisChargedMode ];

/// PIADM_IReportSend
Property PIADMIReportSend As %Library.String(DISPLAYLIST = ",AsCharged,Discharged,GSend,ISend", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",AC,DC,GS,IS") [ SqlColumnNumber = 17, SqlFieldName = PIADM_IReportSend ];

/// PIADM_PEDeskClerk_DR
Property PIADMPEDeskClerkDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PIADM_PEDeskClerk_DR ];

/// PIADM_PGADM_DR
Property PIADMPGADMDR As User.DHCPEPreGADM [ SqlColumnNumber = 3, SqlFieldName = PIADM_PGADM_DR ];

/// PIADM_PGTeam_DR
Property PIADMPGTeamDR As User.DHCPEPreGTeam [ SqlColumnNumber = 4, SqlFieldName = PIADM_PGTeam_DR ];

/// PIADM_PIBI_DR
Property PIADMPIBIDR As User.DHCPEPreIBaseInfo [ SqlColumnNumber = 2, SqlFieldName = PIADM_PIBI_DR ];

/// PIADM_Remark
Property PIADMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PIADM_Remark ];

/// PIADM_Sales_DR
Property PIADMSalesDR As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = PIADM_Sales_DR ];

/// PIADM_Status
Property PIADMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PIADM_Status ];

/// PIADM_Type
Property PIADMType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PIADM_Type ];

/// PIADM_UpdateDate
Property PIADMUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 23, SqlFieldName = PIADM_UpdateDate ];

/// PIADM_UpdateTime
Property PIADMUpdateTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = PIADM_UpdateTime ];

/// PIADM_UpdateUser_DR
Property PIADMUpdateUserDR As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = PIADM_UpdateUser_DR ];

/// PIADM_Vip
Property PIADMVip As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PIADM_Vip ];

/// PIADMHPNo
Property PIADMHPNo As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PIADM_HPNo ];

/// PIADMReCheckFlag
Property PIADMReCheckFlag As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PIADM_ReCheckFlag ];

/// PIADMReCheckRecord 复查记录
Property PIADMReCheckRecord As %Library.String [ SqlColumnNumber = 30, SqlFieldName = PIADM_ReCheckRecord ];

/// PIADM_DetailId  排班ID
Property PIADMDetailId As %Library.String [ SqlColumnNumber = 31, SqlFieldName = PIADM_DetailId ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEPreIADM)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEPreIADM">
<Data name="PIADM_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIADM_AddOrdItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIADM_AddOrdItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIADM_AddPhcItem">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PIADM_AddPhcItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PIADM_AddPhcItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PIADM_AsCharged">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIADM_BookDateBegin">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIADM_BookDateEnd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIADM_BookTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIADM_DelayDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PIADM_DepCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PIADM_DetailId">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PIADM_DisChargedMode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PIADM_HPNo">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PIADM_IReportSend">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PIADM_PEDeskClerk_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIADM_PGADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIADM_PGTeam_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIADM_PIBI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIADM_ReCheckFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PIADM_ReCheckRecord">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PIADM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PIADM_Sales_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PIADM_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIADM_Type">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PIADM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PIADM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PIADM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PIADM_Vip">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPEPreIADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBookDateTime">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"BookDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_BookDateBegin}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_BookDateEnd}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIADM_BookTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelayDate">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DelayDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_DelayDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepCode">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DepCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_DepCode_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDetailID">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DetailID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIADM_DetailId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHPNO">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HPNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIADM_HPNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPEDeskClerk">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PEDeskClerk"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_PEDeskClerk_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPGADM">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PGADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_PGADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPGTeam">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PGTeam"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_PGTeam_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPIBI">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PIBI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_PIBI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexReCheckRecord">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReCheckRecord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIADM_ReCheckRecord}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSales">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Sales"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_Sales_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateDate">
<Global>^DHCPEPreIADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PIADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PIADM_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PIADM_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PIADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreIADMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

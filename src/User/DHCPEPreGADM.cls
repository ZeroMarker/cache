Class User.DHCPEPreGADM Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGADM_RowId, SqlTableName = DHC_PE_PreGADM, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreGADM";

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPEPreGTeam As User.DHCPEPreGTeam [ Cardinality = children, Inverse = PGTParRef ];

/// PGADM_PGBI_DR
Property PGADMPGBIDR As User.DHCPEPreGBaseInfo [ SqlColumnNumber = 2, SqlFieldName = PGADM_PGBI_DR ];

/// PGADM_BookDateBegin
Property PGADMBookDateBegin As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = PGADM_BookDateBegin ];

/// PGADM_BookDateEnd
Property PGADMBookDateEnd As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = PGADM_BookDateEnd ];

/// PGADM_BookTime
Property PGADMBookTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PGADM_BookTime ];

/// PGADM_PEDeskClerk_DR
Property PGADMPEDeskClerkDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PGADM_PEDeskClerk_DR ];

/// PGADM_Status
Property PGADMStatus As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PGADM_Status ];

/// PGADM_AsCharged
Property PGADMAsCharged As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PGADM_AsCharged ];

/// PGADM_AddOrdItem
Property PGADMAddOrdItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PGADM_AddOrdItem ];

/// PGADM_AddOrdItemLimit
Property PGADMAddOrdItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PGADM_AddOrdItemLimit ];

/// PGADM_AddOrdItemAmount
Property PGADMAddOrdItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 11, SqlFieldName = PGADM_AddOrdItemAmount ];

/// PGADM_AddPhcItem
Property PGADMAddPhcItem As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PGADM_AddPhcItem ];

/// PGADM_AddPhcItemLimit
Property PGADMAddPhcItemLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PGADM_AddPhcItemLimit ];

/// PGADM_AddPhcItemAmount
Property PGADMAddPhcItemAmount As %Library.Numeric(SCALE = 2) [ SqlColumnNumber = 14, SqlFieldName = PGADM_AddPhcItemAmount ];

/// PGADM_GReportSend
Property PGADMGReportSend As %Library.String(DISPLAYLIST = ",AsCharged,Discharged", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",AC,DC") [ SqlColumnNumber = 15, SqlFieldName = PGADM_GReportSend ];

/// PGADM_IReportSend
Property PGADMIReportSend As %Library.String(DISPLAYLIST = ",GSend,ISend", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GS,IS") [ SqlColumnNumber = 16, SqlFieldName = PGADM_IReportSend ];

/// PGADM_DisChargedMode
Property PGADMDisChargedMode As %Library.String(DISPLAYLIST = ",GDischarged,IDischarged", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",GD,ID") [ SqlColumnNumber = 17, SqlFieldName = PGADM_DisChargedMode ];

/// PGADM_DelayDate
Property PGADMDelayDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 18, SqlFieldName = PGADM_DelayDate ];

/// PGADM_Remark
Property PGADMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PGADM_Remark ];

/// PGADM_UpdateUser_DR
Property PGADMUpdateUserDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = PGADM_UpdateUser_DR ];

/// PGADM_UpdateDate
Property PGADMUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 21, SqlFieldName = PGADM_UpdateDate ];

/// PGADM_UpdateTime
Property PGADMUpdateTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = PGADM_UpdateTime ];

/// PGADM_Sales_DR
Property PGADMSalesDR As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = PGADM_Sales_DR ];

/// PGADM_DepCode_DR
Property PGADMDepCodeDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = PGADM_DepCode_DR ];

/// PGADM_HPCode
Property PGADMHPCode As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = PGADM_HPCode ];

/// 合同ID
Property GADMContractDR As User.DHCPEContract [ SqlColumnNumber = 26, SqlFieldName = PGADM_Contract_DR ];

/// PGADM_PreRebate  预约折扣率
Property PGADMPreRebate As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PGADM_PreRebate ];

/// PGADM_AddRebate  加项折扣率
Property PGADMGAddRebate As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = PGADM_GAddRebate ];

/// PGADM_IAddRebate  自费加项折扣率
Property PGADMIAddRebate As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = PGADM_IAddRebate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEPreGADM)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEPreGADM">
<Data name="PGADM_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PGADM_AddOrdItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PGADM_AddOrdItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PGADM_AddPhcItem">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PGADM_AddPhcItemAmount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PGADM_AddPhcItemLimit">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PGADM_AsCharged">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGADM_BookDateBegin">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGADM_BookDateEnd">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGADM_BookTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGADM_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PGADM_DelayDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PGADM_DepCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PGADM_DisChargedMode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PGADM_GAddRebate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PGADM_GReportSend">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PGADM_HPCode">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PGADM_IAddRebate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PGADM_IReportSend">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PGADM_PEDeskClerk_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGADM_PGBI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGADM_PreRebate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PGADM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PGADM_Sales_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PGADM_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGADM_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PGADM_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PGADM_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCPEPreGADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PGADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBookDateBegin">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PGADM_RowId</Field>
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
<Expression>{PGADM_BookDateBegin}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_BookDateEnd}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PGADM_BookTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContract">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PGADM_Contract_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PGADM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDelayDate">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGADM_RowId</Field>
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
<Expression>{PGADM_DelayDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDepCode">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGADM_RowId</Field>
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
<Expression>{PGADM_DepCode_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPEDeskClerk">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGADM_RowId</Field>
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
<Expression>{PGADM_PEDeskClerk_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPGBI">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGADM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PGBI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGADM_PGBI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSales">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGADM_RowId</Field>
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
<Expression>{PGADM_Sales_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEPreGADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGADM_RowId</Field>
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
<Expression>{PGADM_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreGADMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

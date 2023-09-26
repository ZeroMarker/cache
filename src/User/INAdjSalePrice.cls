Class User.INAdjSalePrice Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = IN_AdjSalePrice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IN_AdjSalePrice Row ID
Property INASPRowid As %Library.Numeric(SCALE = 0, SELECTIVITY = 1) [ InitialExpression = {$i(^INASP)}, Required, SqlFieldName = INASP_Rowid ];

/// INASP_Date
Property INASPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = INASP_Date ];

/// INASP_ExecuteDate
Property INASPExecuteDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INASP_ExecuteDate ];

/// INASP_SSUSR_DR
Property INASPSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = INASP_SSUSR_DR ];

/// INASP_INCI_DR
Property INASPINCIDR As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = INASP_INCI_DR ];

/// INASP_NO
Property INASPNO As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INASP_NO ];

/// INASP_PriorSP
Property INASPPriorSP As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INASP_PriorSP ];

/// INASP_ResultSP
Property INASPResultSP As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INASP_ResultSP ];

/// INASP_INCSC_DR
Property INASPINCSCDR As User.INCStkCat [ SqlColumnNumber = 9, SqlFieldName = INASP_INCSC_DR ];

/// INASP_Status
Property INASPStatus As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INASP_Status ];

/// INASP_CTUOM_DR
Property INASPCTUOMDR As User.CTUOM [ SqlColumnNumber = 11, SqlFieldName = INASP_CTUOM_DR ];

/// INASP_CTUOM_Price
Property INASPCTUOMPrice As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INASP_CTUOM_Price ];

/// INASP_WarrentNO
Property INASPWarrentNO As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INASP_WarrentNO ];

/// INASP_Remark
Property INASPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INASP_Remark ];

/// INASP_CTUOM_Rp
Property INASPCTUOMRp As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INASP_CTUOM_Rp ];

/// INASP_PriorRP
Property INASPPriorRP As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INASP_PriorRP ];

/// NASP_ResultRP
Property INASPResultRP As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INASP_ResultRP ];

/// INASP_PreExeDate
Property INASPPreExeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = INASP_PreExeDate ];

/// INASP_INVOICE
Property INASPINVOICE As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INASP_INVOICE ];

/// INASP_INVODATE
Property INASPINVODATE As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INASP_INVODATE ];

/// INASP_HOSP_Dr
Property INASPHospitalDr As User.CTHospital [ SqlColumnNumber = 21, SqlFieldName = INASP_Hospital_Dr ];

/// INASP_AuditUser
Property INASPAuditUser As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = INASP_AuditUser ];

/// INASP_WNODate
Property INASPWNODate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INASP_WNODate ];

/// INASP_Time
Property INASPTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = INASP_Time ];

/// INASP_AuditDate
Property INASPAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = INASP_AuditDate ];

/// INASP_Audittime
Property INASPAudittime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = INASP_Audittime ];

/// INASP_StartDate
Property INASPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = INASP_StartDate ];

/// INASP_StartTime
Property INASPStartTime As %Library.Time [ SqlColumnNumber = 28, SqlFieldName = INASP_StartTime ];

/// INASP_REASON_DR
Property INASPREASONDR As User.DHCReasonForAdjustPrice [ SqlColumnNumber = 29, SqlFieldName = INASP_REASON_DR ];

/// INASP_BackupSp
Property INASPBackupSp As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = INASP_BackupSp ];

/// INASP_StartUser_dr
Property INASPStartUserdr As User.SSUser [ SqlColumnNumber = 31, SqlFieldName = INASP_StartUser_dr ];

/// 辅助价格，收费用
Property INASPAuxPrice As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = INASP_AuxPrice ];

/// 调价类型
Property INASPCat As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INASP_Cat ];

/// INASP_CTUOM_SaleDisc
Property INASPCTUOMSaleDisc As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = INASP_CTUOM_SaleDisc ];

/// NASP_ResultSaleDisc
Property INASPResultSaleDisc As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = INASP_ResultSaleDisc ];

Index RowIDBasedIDKeyIndex On INASPRowid [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterINASP">
<Data name="INASP_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INASP_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INASP_Audittime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INASP_AuxPrice">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INASP_BackupSp">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INASP_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INASP_CTUOM_Price">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INASP_CTUOM_Rp">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INASP_CTUOM_SaleDisc">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INASP_Cat">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INASP_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INASP_ExecuteDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INASP_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INASP_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INASP_INCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INASP_INVODATE">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INASP_INVOICE">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INASP_NO">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INASP_PreExeDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INASP_PriorRP">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INASP_PriorSP">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INASP_REASON_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INASP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INASP_ResultRP">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INASP_ResultSP">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INASP_ResultSaleDisc">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INASP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INASP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INASP_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INASP_StartUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INASP_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INASP_Time">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INASP_WNODate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INASP_WarrentNO">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^INASP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INASP_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INASP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DATESTATUS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INASP_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INASP_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INASP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExecDate">
<Global>^INASP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EXECDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INASP_ExecuteDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INASP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHOSPINCIExec">
<Global>^INASP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INASP_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INASP_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INASP_ExecuteDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INASP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospExec">
<Global>^INASP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INASP_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INASP_ExecuteDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INASP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIExecuteDate">
<Global>^INASP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INASP_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INASP_ExecuteDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INASP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^INASP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INASP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ASPNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INASP_NO})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INASP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INAdjSalePriceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^INASP)
	s oldI = +$g(^mdata("INADJSALEPRICE"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^INASP = maxI
	s ^mdata("INADJSALEPRICE") = maxI
}

}

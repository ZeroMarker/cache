Class User.INAdjPriceBatch Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INAPB_RowID, SqlTableName = IN_AdjPriceBatch, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Hospital
Property INAPBHospitalDr As User.CTHospital [ SqlColumnNumber = 2, SqlFieldName = INAPB_Hospital_Dr ];

/// INAPB_No
Property INAPBNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INAPB_No ];

/// INAPB_Status
Property INAPBStatus As %Library.String(DISPLAYLIST = ",No,Complete,Audit,Yes", MAXLEN = 8, SELECTIVITY = "20.0000%", VALUELIST = ",N,C,A,Y") [ SqlColumnNumber = 4, SqlFieldName = INAPB_Status ];

/// INAPB_Incib_Dr
Property INAPBIncibDr As User.INCItmBat [ SqlColumnNumber = 5, SqlFieldName = INAPB_Incib_Dr ];

/// INAPB_Uom_Dr
Property INAPBUomDr As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = INAPB_Uom_Dr ];

/// INAPB_PriorRpUom
Property INAPBPriorRpUom As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = INAPB_PriorRpUom ];

/// INAPB_ResultRpUom
Property INAPBResultRpUom As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INAPB_ResultRpUom ];

/// INAPB_PriorSpUom
Property INAPBPriorSpUom As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INAPB_PriorSpUom ];

/// INAPB_ResultSpUom
Property INAPBResultSpUom As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INAPB_ResultSpUom ];

/// INAPB_PriorRp
Property INAPBPriorRp As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INAPB_PriorRp ];

/// INAPB_ResultRp
Property INAPBResultRp As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INAPB_ResultRp ];

/// INAPB_PriorSp
Property INAPBPriorSp As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INAPB_PriorSp ];

/// INAPB_ResultSp
Property INAPBResultSp As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INAPB_ResultSp ];

/// INAPB_PreExeDate
Property INAPBPreExeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = INAPB_PreExeDate ];

/// INAPB_PreExeTime
Property INAPBPreExeTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = INAPB_PreExeTime ];

/// INAPB_ExecuteDate
Property INAPBExecuteDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INAPB_ExecuteDate ];

/// INAPB_ExecuteTime
Property INAPBExecuteTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INAPB_ExecuteTime ];

/// INAPB_SSUSR_Dr
Property INAPBSSUSRDr As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = INAPB_SSUSR_Dr ];

/// INAPB_Date
Property INAPBDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = INAPB_Date ];

/// INAPB_Time
Property INAPBTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = INAPB_Time ];

/// INAPB_AuditUser
Property INAPBAuditUser As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = INAPB_AuditUser ];

/// INAPB_AuditDate
Property INAPBAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INAPB_AuditDate ];

/// INAPB_Audittime
Property INAPBAuditTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = INAPB_AuditTime ];

/// INAPB_StartUser_dr
Property INAPBStartUserdr As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = INAPB_StartUser_dr ];

/// INAPB_StartDate
Property INAPBStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = INAPB_StartDate ];

/// INAPB_StartTime
Property INAPBStartTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = INAPB_StartTime ];

/// INAPB_WarrentNO
Property INAPBWarrentNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INAPB_WarrentNO ];

/// INAPB_WNODate
Property INAPBWNODate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = INAPB_WNODate ];

/// INAPB_REASON_DR
Property INAPBREASONDR As User.DHCReasonForAdjustPrice [ SqlColumnNumber = 30, SqlFieldName = INAPB_REASON_DR ];

/// INAPB_BackupSp
Property INAPBBackupSp As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = INAPB_BackupSp ];

/// INAPB_Remark
Property INAPBRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INAPB_Remark ];

/// 调前价格发票号
Property INAPBPriorInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INAPB_PriorInvNo ];

/// 调后价格发票号
Property INAPBResultInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INAPB_ResultInvNo ];

/// 财务审核人
Property INAPBTreasurerUser As User.SSUser [ SqlColumnNumber = 35, SqlFieldName = INAPB_TreasurerUser ];

/// 财务审核日期
Property INAPBTreasurerDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 36, SqlFieldName = INAPB_TreasurerDate ];

/// 财务审核时间
Property INAPBTreasurerTime As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = INAPB_TreasurerTime ];

/// 调价类型
Property INAPBCat As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INAPB_Cat ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSTINAPB)</SqlIdExpression>
<SQLMap name="DataMasterINAPB">
<Data name="INAPB_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INAPB_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INAPB_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INAPB_BackupSp">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INAPB_Cat">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INAPB_Date">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INAPB_ExecuteDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INAPB_ExecuteTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INAPB_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INAPB_Incib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INAPB_No">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INAPB_PreExeDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INAPB_PreExeTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INAPB_PriorInvNo">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INAPB_PriorRp">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INAPB_PriorRpUom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INAPB_PriorSp">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INAPB_PriorSpUom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INAPB_REASON_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INAPB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INAPB_ResultInvNo">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INAPB_ResultRp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INAPB_ResultRpUom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INAPB_ResultSp">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INAPB_ResultSpUom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INAPB_SSUSR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INAPB_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INAPB_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INAPB_StartUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INAPB_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INAPB_Time">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INAPB_TreasurerDate">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INAPB_TreasurerTime">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INAPB_TreasurerUser">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INAPB_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INAPB_WNODate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INAPB_WarrentNO">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCSTINAPB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_Time}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExecDateExecTime">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"EXECDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_ExecuteDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_ExecuteTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospDate">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HOSPDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_Time}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospEDateETime">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HOSPE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_ExecuteDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_ExecuteTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospIncibExec">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HOSPINCIB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Incib_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INAPB_ExecuteDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_ExecuteTime}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospStatusPreDat">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"HOSPSTATUSPRE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_PreExeDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_PreExeTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIncibExecDate">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCIB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Incib_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_ExecuteDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_ExecuteTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ASPNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({INAPB_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusAdjDate">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STATUSDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_Time}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusPreDate">
<Global>^DHCSTINAPB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INAPB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"STATUSPRE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INAPB_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INAPB_PreExeDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>+{INAPB_PreExeTime}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INAPB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INAdjPriceBatchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCSTINAPB)
	s oldI = +$g(^mdata("INADJPRICEBATCH"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCSTINAPB = maxI
	s ^mdata("INADJPRICEBATCH") = maxI
}

}

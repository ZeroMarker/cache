/// User.DHCPhaRetRequest
Class User.DHCPhaRetRequest Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RETRQ_Rowid, SqlTableName = DHC_PhaRetRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPhaRetRequestItm As User.DHCPhaRetRequestItm [ Cardinality = children, Inverse = RETRQIRETRQParRef ];

/// RETRQ_ReqNo
Property RETRQReqNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RETRQ_ReqNo ];

/// RETRQ_RecLoc_DR
Property RETRQRecLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = RETRQ_RecLoc_DR ];

/// RETRQ_Papmi_DR
Property RETRQPapmiDR As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = RETRQ_Papmi_DR ];

/// RETRQ_PAADM_DR
Property RETRQPAADMDR As User.PAAdm [ SqlColumnNumber = 6, SqlFieldName = RETRQ_PAADM_DR ];

/// RETRQ_Doctor_DR
Property RETRQDoctorDR As User.CTCareProv [ SqlColumnNumber = 7, SqlFieldName = RETRQ_Doctor_DR ];

/// RETRQ_Dept_DR,如果是病区退药，存病区科室，如果是特殊科室退药，存医生科室
Property RETRQDeptDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = RETRQ_Dept_DR ];

/// RETRQ_Bed_DR
Property RETRQBedDR As User.PACBed [ SqlColumnNumber = 9, SqlFieldName = RETRQ_Bed_DR ];

/// RETRQ_Status
Property RETRQStatus As %Library.String(MAXLEN = 7, SELECTIVITY = "25.0000%", VALUELIST = ",Prove,Execute,Ignore,Refuse") [ SqlColumnNumber = 15, SqlFieldName = RETRQ_Status ];

/// RETRQ_OperUser_DR
Property RETRQOperUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = RETRQ_OperUser_DR ];

/// RETRQ_OperDate
Property RETRQOperDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = RETRQ_OperDate ];

/// RETRQ_OperTime
Property RETRQOperTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = RETRQ_OperTime ];

/// RETRQ_UpdateUser_DR
Property RETRQUpdateUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = RETRQ_UpdateUser_DR ];

/// RETRQ_UpdateDate
Property RETRQUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = RETRQ_UpdateDate ];

/// RETRQ_UpdateTime
Property RETRQUpdateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = RETRQ_UpdateTime ];

/// RETRQ_WardLoc_DR,病区科室（支持病区退特殊科室药需要用）
Property RETRQWardLocDR As User.CTLoc [ SqlColumnNumber = 22, SqlFieldName = RETRQ_WardLoc_DR ];

Property RETRQSendFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 23, SqlFieldName = RETRQ_SendFlag ];

Property RETRQAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 24, SqlFieldName = RETRQ_AuditFlag ];

Property RETRQAuditUser As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = RETRQ_AuditUser ];

Property RETRQAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = RETRQ_AuditDate ];

Property RETRQAuditTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = RETRQ_AuditTime ];

Property RETRQPrintFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 28, SqlFieldName = RETRQ_PrintFlag ];

Property RETRQGreenRecFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 29, SqlFieldName = RETRQ_GreenRecFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^RETRQ)</SqlIdExpression>
<SQLMap name="DataMasterRETRQ">
<Data name="RETRQ_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="RETRQ_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="RETRQ_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="RETRQ_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="RETRQ_Bed_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RETRQ_Dept_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RETRQ_Doctor_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RETRQ_GreenRecFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="RETRQ_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RETRQ_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RETRQ_OperUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RETRQ_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RETRQ_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RETRQ_PrintFlag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="RETRQ_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RETRQ_ReqNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RETRQ_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RETRQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RETRQ_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RETRQ_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RETRQ_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RETRQ_WardLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^RETRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RETRQ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RETRQ_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RETRQ_Rowid</Field>
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
<Expression>{RETRQ_OperDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNO">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RETRQ_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RETRQNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RETRQ_ReqNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecStatusDept">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RETRQ_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RECSTDEPT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Status}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Dept_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexPatNo">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RETRQ_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Papmi_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Dept_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexRecloc">
<Global>^RETRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RETRQ_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RECLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_OperDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{RETRQ_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaRetRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^RETRQ)
	s oldI = +$g(^mdata("DHCPHARETREQUEST"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^RETRQ = maxI
	s ^mdata("DHCPHARETREQUEST") = maxI
}

}

Class User.DHCInDisp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDS_Rowid, SqlTableName = DHC_InDisp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCInDispItm As User.DHCInDispItm [ Cardinality = children, Inverse = INDSIINDSParref ];

/// INDS_No
Property INDSNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INDS_No ];

/// INDS_Date
Property INDSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INDS_Date ];

/// INDS_SSUSR_DR
Property INDSTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = INDS_Time ];

/// INDS_SSUSR_DR
Property INDSSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = INDS_SSUSR_DR ];

/// INDS_ReasonAdjustment
Property INDSReasonAdjustment As User.INCReasonForAdjustment [ SqlColumnNumber = 6, SqlFieldName = INDS_ReasonAdjustment ];

/// INDS_StOutType_DR
Property INDSStOutTypeDR As User.INCStockOutType [ SqlColumnNumber = 7, SqlFieldName = INDS_StOutType_DR ];

/// INDS_Type
Property INDSType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDS_Type ];

/// INDS_Remarks
Property INDSRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDS_Remarks ];

/// INDS_CTLOC_DR
Property INDSCTLOCDR As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = INDS_CTLOC_DR ];

/// INDS_AckDate
Property INDSAckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = INDS_AckDate ];

/// INDS_AckTime
Property INDSAckTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = INDS_AckTime ];

/// INDS_SSUSR_Ack_DR
Property INDSSSUSRAckDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = INDS_SSUSR_Ack_DR ];

/// INDS_Stat
Property INDSStat As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INDS_Stat ];

/// INDS_Completed
Property INDSCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INDS_Completed ];

/// INDS_SCG_DR
Property INDSSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 16, SqlFieldName = INDS_SCG_DR ];

/// INDS_StkType
Property INDSStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 17, SqlFieldName = INDS_StkType ];

/// INDS_AckFlag
Property INDSAckFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = INDS_AckFlag ];

/// INDS_DispMode -0:按组发放,1:按人发放
Property INDSDispMode As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INDS_DispMode ];

/// INDS_DispUser_DR
Property INDSDispUserDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = INDS_DispUser_DR ];

/// INDS_DispUserGrp_DR
Property INDSDispUserGrpDR As User.DHCSubLocUserGroup [ SqlColumnNumber = 21, SqlFieldName = INDS_DispUserGrp_DR ];

/// INDS_RQ_DR
Property INDSRQDR As User.DHCINDispReq [ SqlColumnNumber = 22, SqlFieldName = INDS_RQ_DR ];

/// INDS_ToLOC_DR(接收科室,协和)
Property INDSTOLOCDR As User.CTLoc [ SqlColumnNumber = 23, SqlFieldName = INDS_TOLOC_DR ];

Property INDSPAAdmDR As User.PAAdm [ SqlColumnNumber = 24, SqlFieldName = INDS_PAAdm_DR ];

/// INDS_Template  - 模板标志
Property INDSTemplate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = INDS_Template ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDS)</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="INDS_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDS_AckFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INDS_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDS_Completed">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDS_DispMode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INDS_DispUserGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INDS_DispUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INDS_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDS_PAAdm_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INDS_RQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INDS_ReasonAdjustment">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDS_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDS_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INDS_SSUSR_Ack_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDS_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDS_StOutType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDS_Stat">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDS_StkType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INDS_TOLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INDS_Template">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INDS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDS_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCINDS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDS_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCINDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDS_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INDS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCINDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({INDS_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAAdm">
<Global>^DHCINDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDS_PAAdm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRQ">
<Global>^DHCINDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"RQ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INDS_RQ_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INDS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINDS)
	s oldI = +$g(^mdata("DHCINDISP"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINDS = maxI
	s ^mdata("DHCINDISP") = maxI
}

}

Class User.INPurPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INPP_Rowid, SqlTableName = IN_PurPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000;

Relationship ChildINPurPlanItm As User.INPurPlanItm [ Cardinality = children, Inverse = INPPIParref ];

/// INPP_No
Property INPPNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INPP_No ];

/// INPP_Date
Property INPPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = INPP_Date ];

/// INPP_SSUSR_DR
Property INPPSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = INPP_SSUSR_DR ];

/// INPP_AuditDate
Property INPPAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = INPP_AuditDate ];

/// INPP_AuditSSUSR_DR
Property INPPAuditSSUSRDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = INPP_AuditSSUSR_DR ];

/// INPP_PoFlag
Property INPPPoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INPP_PoFlag ];

/// INPP_CTLOC_DR
Property INPPCTLOCDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = INPP_CTLOC_DR ];

/// INPP_Complete
Property INPPComplete As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = INPP_Complete ];

/// INPP_Time
Property INPPTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = INPP_Time ];

/// INPP_AuditTime
Property INPPAuditTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = INPP_AuditTime ];

/// INPP_AuditFlag
Property INPPAuditFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = INPP_AuditFlag ];

/// INPP_SCG_DR
Property INPPSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 13, SqlFieldName = INPP_SCG_DR ];

/// INPP_StkType
Property INPPStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 14, SqlFieldName = INPP_StkType ];

/// 采购类型
Property INPPOperateType As User.DHCOperateType [ SqlColumnNumber = 15, SqlFieldName = INPP_OperateType ];

/// INPP_UrgentFlag
Property INPPUrgentFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INPP_UrgentFlag ];

/// INPP_Remarks
Property INPPRemarks As list Of %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INPP_Remarks, SqlListType = SUBNODE ];

/// INPP_RefuseCase 拒绝原因
Property INPPRefuseCase As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INPP_RefuseCase ];

/// INPP_IFRECFLAG 是否是补录，烟台中医院瑞康接口使用
Property INPPIFRECFLAG As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = INPP_IFRECFLAG ];

/// 计划要求到货日期
Property INPPDateNeeded As %Date [ SqlColumnNumber = 20, SqlFieldName = INPP_DateNeeded ];

/// 模板标志
Property INPPMouldFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INPP_MouldFlag ];

/// INPP_ConsumeStDate  	依据消耗开始日期  --
Property INPPConsumeStDate As %Library.Date [ SqlColumnNumber = 22, SqlFieldName = INPP_ConsumeStDate ];

/// INPP_ConsumeEdDate   依据消耗结束日期  --
Property INPPConsumeEdDate As %Library.Date [ SqlColumnNumber = 23, SqlFieldName = INPP_ConsumeEdDate ];

/// INPP_PlanDay --计划天数
Property INPPPlanDay As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = INPP_PlanDay ];

/// INPP_PurSSUSR_DR
Property INPPPurSSUSRDR As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = INPP_PurSSUSR_DR ];

Property INPPExecuteDate As %Library.Date [ SqlColumnNumber = 26, SqlFieldName = INPP_ExecuteDate ];

Property INPPExecuteSSUSRDR As User.SSUser [ SqlColumnNumber = 27, SqlFieldName = INPP_ExecuteSSUSR_DR ];

Property INPPExecuteFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = INPP_ExecuteFlag ];

Index INPPNoUnqIdx1 On INPPNo;

Storage SQLStorage
{
<ExtentSize>25000</ExtentSize>
<SqlIdExpression>$i(^INPP)</SqlIdExpression>
<SQLMap name="DataMasterINPP">
<Data name="INPP_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPP_AuditFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPP_AuditSSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPP_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPP_Complete">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPP_ConsumeEdDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INPP_ConsumeStDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INPP_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPP_DateNeeded">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INPP_ExecuteDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INPP_ExecuteFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INPP_ExecuteSSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INPP_IFRECFLAG">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INPP_MouldFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INPP_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPP_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPP_PlanDay">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INPP_PoFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPP_PurSSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INPP_RefuseCase">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPP_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INPP_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPP_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPP_StkType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPP_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPP_UrgentFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^INPP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INPP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INPP_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPP_Rowid</Field>
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
<Expression>{INPP_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInPPNO">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INPP_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocAuditDate">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INPP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCAUDITDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPP_AuditDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDateNeeded">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INPP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOCDATENEEDED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPP_DateNeeded}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocMould">
<Global>^INPP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INPP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocModule"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INPP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INPP_MouldFlag}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexpurloc">
<Global>^INPP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PURLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPP_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INPurPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^INPP)
	s oldI = +$g(^mdata("INPURPLAN"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^INPP = maxI
	s ^mdata("INPURPLAN") = maxI
}

}

Class User.DHCINAdj Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INAD_RowId, SqlTableName = DHC_INAdj, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1250;

Relationship ChildDHCINAdjItm As User.DHCINAdjItm [ Cardinality = children, Inverse = INADIINADParRef ];

/// INAD_Remarks
Property INADRemarks As list Of %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INAD_Remarks, SqlListType = SUBNODE ];

/// INAD_INST_DR
Property INADINSTDR As User.INStkTk [ SqlColumnNumber = 3, SqlFieldName = INAD_INST_DR ];

/// INAD_SSUSR_DR
Property INADSSUSRDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = INAD_SSUSR_DR ];

/// INAD_Date
Property INADDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = INAD_Date ];

/// INAD_No
Property INADNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INAD_No ];

/// INAD_Time
Property INADTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INAD_Time ];

/// INAD_ReasonAdj_DR
Property INADReasonAdjDR As User.INCReasonForAdjustment [ SqlColumnNumber = 8, SqlFieldName = INAD_ReasonAdj_DR ];

/// Adj State
Property INADState As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INAD_State ];

/// INAD_ChkDate
Property INADChkDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = INAD_ChkDate ];

/// INAD_ChkTime
Property INADChkTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = INAD_ChkTime ];

/// INAD_ChkUSR_DR
Property INADChkUSRDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = INAD_ChkUSR_DR ];

/// Not Use
Property INADAdjDR As User.INAdj [ SqlColumnNumber = 13, SqlFieldName = INAD_Adj_DR ];

/// INAD_SCG_DR
Property INADSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 14, SqlFieldName = INAD_SCG_DR ];

/// INAD_Completed
Property INADCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INAD_Completed ];

/// INAD_ChkFlag
Property INADChkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INAD_ChkFlag ];

/// INAD_StkType
Property INADStkType As %Library.String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 17, SqlFieldName = INAD_StkType ];

/// INAD_CTLOC_DR
Property INADCTLOCDR As User.CTLoc [ SqlColumnNumber = 18, SqlFieldName = INAD_CTLOC_DR ];

/// 退货科室(科室结余药)
Property INADRetLocDR As User.CTLoc [ SqlColumnNumber = 19, SqlFieldName = INAD_RetLoc_DR ];

/// 财务审核人
Property INADSSUSRTreasurerDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = INAD_SSUSR_Treasurer_DR ];

/// 财务审核日期
Property INADTreasureDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = INAD_Treasure_Date ];

/// 财务审核时间
Property INADTreasureTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = INAD_Treasure_Time ];

/// 登记号(积水潭非常业务使用)
Property INADPatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INAD_PatNo ];

/// 姓名(积水潭非常业务使用)
Property INADPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INAD_PatName ];

/// 年龄(积水潭非常业务使用)
Property INADPatAge As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INAD_PatAge ];

/// 性别(积水潭非常业务使用)
Property INADSex As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INAD_Sex ];

/// 病人类型(积水潭非常业务使用)
Property INADPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INAD_PatType ];

/// 原因(积水潭非常业务使用)
Property INADDspreason As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INAD_Dspreason ];

/// 类型(1发药，2退药)(积水潭非常业务使用)
Property INADUndspflag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INAD_Undspflag ];

/// INAD_StkCat_DR库存分类
Property INADStkCatDR As User.INCStkCat [ SqlColumnNumber = 30, SqlFieldName = INAD_StkCat_DR ];

Storage SQLStorage
{
<ExtentSize>1250</ExtentSize>
<SqlIdExpression>$i(^DHCINAD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INAD_Adj_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INAD_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INAD_ChkDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INAD_ChkFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INAD_ChkTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INAD_ChkUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INAD_Completed">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INAD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INAD_Dspreason">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INAD_INST_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INAD_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INAD_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INAD_PatName">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INAD_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INAD_PatType">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INAD_ReasonAdj_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INAD_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INAD_RetLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INAD_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INAD_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INAD_SSUSR_Treasurer_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INAD_Sex">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INAD_State">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INAD_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INAD_StkType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INAD_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INAD_Treasure_Date">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INAD_Treasure_Time">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INAD_Undspflag">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DHCINAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateAdjDr">
<Global>^DHCINAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INADJ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAD_Adj_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINADDate">
<Global>^DHCINAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAD_RowId</Field>
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
<Expression>{INAD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINADNo">
<Global>^DHCINAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INAD_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStateDate">
<Global>^DHCINAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StateDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INAD_State}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAD_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINAdjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINAD)
	s oldI = +$g(^mdata("DHCINADJ"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINAD = maxI
	s ^mdata("DHCINADJ") = maxI
}

}

Class User.DHCDocPilotProSettle Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPSET_RowId, SqlTableName = DHC_DocPilotProSettle, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPSETChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPSETPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProSettle, Required, SqlFieldName = PPSET_PP_ParRef ];

///  PPSET_ChildSub
Property PPSETChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPSET(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPSET_ChildSub ];

/// PPSET_Date：结算日期
Property PPSETDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PPSET_Date ];

/// PPSET_Type:分配类型 E:结账分配 ,1,2,3,...n第几次结账分配
Property PPSETType As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPSET_Type ];

/// PPSET_Distribution:分配比例 O:旧比例，N：新比例
Property PPSETDistribution As %Library.String(DISPLAYLIST = ",Old,New", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",O,N") [ SqlColumnNumber = 5, SqlFieldName = PPSET_Distribution ];

/// PPSET_CheckFee :检查费
Property PPSETCheckFee As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPSET_CheckFee ];

/// PPSET_CheckFee :管理费
Property PPSETManageFee As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPSET_ManageFee ];

/// PPSET_ObservationFee :观察费
Property PPSETObservationFee As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PPSET_ObservationFee ];

/// PPSET_DesignFee 设计总结费
Property PPSETDesignFee As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPSET_DesignFee ];

/// 伦理委员会审评费
Property PPSETEthicsMeetReviewFee As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PPSET_EthicsMeetReviewFee ];

/// 支出合计
Property PPSETTotalPay As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPSET_TotalPay ];

/// V000001入账金额
Property PPSETManageFeePart1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PPSET_ManageFeePart1 ];

/// T160入账金额
Property PPSETManageFeePart2 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PPSET_ManageFeePart2 ];

/// 管理费计划分配次数
Property PPSETPlanNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PPSET_PlanNo ];

/// 管理费此为第几次
Property PPSETNowNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PPSET_NowNo ];

/// 管理费分配金额
Property PPSETDMoney As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PPSET_DMoney ];

/// 管理费入科研账
Property PPSETReSearchAcc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PPSET_ReSearchAcc ];

/// 管理费入科研账账号
Property PPSETReSearchAccNum As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PPSET_ReSearchAccNum ];

/// 观察费计划分配次数
Property PPSETPlanNo1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PPSET_PlanNo1 ];

/// 观察费此为第几次
Property PPSETNowNo1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PPSET_NowNo1 ];

/// 管理费分配金额
Property PPSETDMoney1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PPSET_DMoney1 ];

/// 付款信息
Property PPSETRems As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PPSET_Rems ];

/// 备注
Property PPSETRemark1 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PPSET_Remark1 ];

Property PPSETRemark2 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PPSET_Remark2 ];

Property PPSETRemark3 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PPSET_Remark3 ];

Property PPSETRemark4 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PPSET_Remark4 ];

Property PPSETRemark5 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PPSET_Remark5 ];

Property PPSETRemark6 As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PPSET_Remark6 ];

Property PPSETStatus As %Library.String(DISPLAYLIST = ",New,vertify", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,V") [ SqlColumnNumber = 29, SqlFieldName = PPSET_Status ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPSET_CheckFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPSET_DMoney">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPSET_DMoney1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PPSET_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPSET_DesignFee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPSET_Distribution">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPSET_EthicsMeetReviewFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPSET_ManageFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPSET_ManageFeePart1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PPSET_ManageFeePart2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PPSET_NowNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPSET_NowNo1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PPSET_ObservationFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPSET_PlanNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPSET_PlanNo1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PPSET_ReSearchAcc">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPSET_ReSearchAccNum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PPSET_Remark1">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PPSET_Remark2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PPSET_Remark3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PPSET_Remark4">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PPSET_Remark5">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PPSET_Remark6">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PPSET_Rems">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PPSET_Status">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PPSET_TotalPay">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPSET_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocPPSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPSET_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPSET_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProSettleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

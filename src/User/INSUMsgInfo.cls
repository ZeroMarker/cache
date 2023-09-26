Class User.INSUMsgInfo Extends (%Library.Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = INMSG_Rowid, SqlTableName = INSU_MsgInfo, StorageStrategy = NewStorage1 ]
{

/// 操作员
Property INMSGUserCode As %String(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = INMSG_UserCode ];

/// 客户端IP
Property INMSGIPAdress As %String(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = INMSG_IPAdress ];

/// MAC
Property INMSGIPMAC As %String(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = INMSG_IPMAC ];

/// 登记号
Property INMSGRegNo As %String(MAXLEN = 30) [ SqlColumnNumber = 5, SqlFieldName = INMSG_RegNo ];

/// 医保号
Property INMSGInsuNo As %String(MAXLEN = 30) [ SqlColumnNumber = 6, SqlFieldName = INMSG_InsuNo ];

/// 就诊号
Property INMSGAdmDr As %String(MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = INMSG_Adm_Dr ];

/// 发票Dr
Property INMSGInvPrtDr As %String(MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = INMSG_InvPrt_Dr ];

/// 账单
Property INMSGPBDr As %String(MAXLEN = 30) [ SqlColumnNumber = 9, SqlFieldName = INMSG_PB_Dr ];

/// 插入日期
Property INMSGDate As %Date [ SqlColumnNumber = 10, SqlFieldName = INMSG_Date ];

/// 插入时间
Property INMSGTime As %Time [ SqlColumnNumber = 11, SqlFieldName = INMSG_Time ];

/// 客户端日期
Property INMSGCliDate As %Date [ SqlColumnNumber = 12, SqlFieldName = INMSG_CliDate ];

/// 客户端时间
Property INMSGCliTime As %Time [ SqlColumnNumber = 13, SqlFieldName = INMSG_CliTime ];

/// 业务类型
Property INMSGYWLX As %String(MAXLEN = 30) [ SqlColumnNumber = 14, SqlFieldName = INMSG_YWLX ];

/// 客户端名称
Property INMSGCliName As %String(MAXLEN = 30) [ SqlColumnNumber = 15, SqlFieldName = INMSG_CliName ];

/// 解决标记
Property INMSGSolveFlag As %String(MAXLEN = 5) [ SqlColumnNumber = 16, SqlFieldName = INMSG_SolveFlag ];

/// 解决人
Property INMSGSolveUser As %String(MAXLEN = 30) [ SqlColumnNumber = 17, SqlFieldName = INMSG_SolveUser ];

/// 解决日期
Property INMSGSolveDate As %Date [ SqlColumnNumber = 18, SqlFieldName = INMSG_SolveDate ];

/// 解决时间
Property INMSGSolveTime As %Time [ SqlColumnNumber = 19, SqlFieldName = INMSG_SolveTime ];

/// 解决办法
Property INMSGResolvent As %String(MAXLEN = 300) [ SqlColumnNumber = 20, SqlFieldName = INMSG_Resolvent ];

/// 错误信息
Property INMSGMsg As %String(MAXLEN = 300) [ SqlColumnNumber = 21, SqlFieldName = INMSG_Msg ];

/// 产品线
Property INMSGProductLine As %String(MAXLEN = 30) [ SqlColumnNumber = 22, SqlFieldName = INMSG_ProductLine ];

/// 院区
Property INMSGHospDr As %String(MAXLEN = 30) [ SqlColumnNumber = 23, SqlFieldName = INMSG_HospDr ];

/// 业务数据Id
Property INMSGBusinessId As %String(MAXLEN = 30) [ SqlColumnNumber = 24, SqlFieldName = INMSG_BusinessId ];

/// 参数类型 入参I、出参O
Property INMSGParamType As %String(MAXLEN = 30) [ SqlColumnNumber = 25, SqlFieldName = INMSG_ParamType ];

Storage NewStorage1
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINMSG)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INMSG_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INMSG_BusinessId">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INMSG_CliDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INMSG_CliName">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INMSG_CliTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INMSG_Date">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INMSG_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INMSG_IPAdress">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INMSG_IPMAC">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INMSG_InsuNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INMSG_InvPrt_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INMSG_Msg">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INMSG_PB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INMSG_ParamType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INMSG_ProductLine">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INMSG_RegNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INMSG_Resolvent">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INMSG_SolveDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INMSG_SolveFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INMSG_SolveTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INMSG_SolveUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INMSG_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INMSG_UserCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INMSG_YWLX">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCINMSG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPAdress">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPAdress"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_IPAdress}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPMAC">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPMAC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_IPMAC}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsuNo">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InsuNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_InsuNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvPrtDr">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InvPrtDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_InvPrt_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPBDr">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PBDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_PB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParamType">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParamType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_ParamType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexProductLine">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ProductLine"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_ProductLine}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRegNo">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RegNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_RegNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserCode">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_UserCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexYWLX">
<Global>^DHCINMSGi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMSG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"YWLX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMSG_YWLX}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMSG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUMsgInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

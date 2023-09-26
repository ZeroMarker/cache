Class User.DHCVendorInv Extends (%Persistent, User.Abstract) [ SqlRowIdName = INV_RowId, SqlTableName = DHC_VendorInv, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCVendorInvItm As User.DHCVendorInvItm [ Cardinality = children, Inverse = INVIINVParRef ];

/// 发票组合流水号
Property INVAssemNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INV_AssemNo ];

/// 供应商Rowid
Property INVAPCVMDR As User.APCVendor [ SqlColumnNumber = 3, SqlFieldName = INV_APCVM_DR ];

/// 类组Rowid
Property INVSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 4, SqlFieldName = INV_SCG_DR ];

/// 制单人
Property INVCreateUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = INV_CreateUser ];

/// 制单日期(组合单据产生发票记录日期)
Property INVCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INV_CreateDate ];

/// 制单时间
Property INVCreateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INV_CreateTime ];

/// 科室
Property INVCTLOCDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = INV_CTLOC_DR ];

/// 进价金额
Property INVRpAmt As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = INV_RpAmt ];

/// 售价金额
Property INVSpAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INV_SpAmt ];

/// 发票号
Property INVInvNo As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INV_InvNo ];

/// 组合完成标志
Property INVUserCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = INV_UserCompleted ];

/// 发票到位标志
Property INVFilled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = INV_Filled ];

/// 发票进价金额
Property INVInvRpAmt As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INV_InvRpAmt ];

/// 发票售价金额
Property INVInvSpAmt As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INV_InvSpAmt ];

/// 发票日期
Property INVInvDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = INV_InvDate ];

/// 发票代码
Property INVInvCode As %Library.String [ SqlColumnNumber = 17, SqlFieldName = INV_InvCode ];

/// 付款方式
Property INVPayMode As %Library.String [ SqlColumnNumber = 18, SqlFieldName = INV_PayMode ];

/// 审核人
Property INVAuditUserDr As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = INV_AuditUser_Dr ];

/// 审核日期
Property INVAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = INV_AuditDate ];

/// 审核时间
Property INVAuditTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = INV_AuditTime ];

/// 更新人
Property INVUpdateUser As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = INV_UpdateUser ];

/// 更新日期(补充发票信息日期)
Property INVUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INV_UpdateDate ];

/// 更新时间
Property INVUpdateTime As %Library.Time [ SqlColumnNumber = 24, SqlFieldName = INV_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>50</ExtentSize>
<SqlIdExpression>$i(^DHCVendorInv)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INV_APCVM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INV_AssemNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INV_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INV_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INV_AuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INV_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INV_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INV_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INV_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INV_Filled">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INV_InvCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INV_InvDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INV_InvNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INV_InvRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INV_InvSpAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INV_PayMode">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INV_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INV_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INV_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INV_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INV_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INV_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INV_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCVendorInv</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{INV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCodeNo">
<Global>^DHCVendorInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CodeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INV_InvCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INV_InvNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInvNo">
<Global>^DHCVendorInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"InvNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INV_InvNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCVendorInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INV_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INV_CreateDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{INV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVendorScg">
<Global>^DHCVendorInv</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Vendor"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{INV_APCVM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INV_CreateDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{INV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INV_RowId</SqlRowIdName>
<StreamLocation>^User.DHCVendorInvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCVendorInv)
	s oldI = +$g(^mdata("DHCVENDORINV"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCVendorInv = maxI
	s ^mdata("DHCVENDORINV") = maxI
}

Parameter EXTENTSIZE = 50;

}

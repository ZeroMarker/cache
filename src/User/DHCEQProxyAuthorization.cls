Class User.DHCEQProxyAuthorization Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PA_RowID, SqlTableName = DHC_EQProxyAuthorization, StorageStrategy = SQLStorage ]
{

/// PA_ManufactoryDR
Property PAManufactoryDR As User.DHCEQCVendor [ SqlColumnNumber = 2, SqlFieldName = PA_ManufactoryDR ];

/// PA_Authorizer
Property PAAuthorizer As User.DHCEQCVendor [ SqlColumnNumber = 3, SqlFieldName = PA_Authorizer ];

/// PA_Authorized
Property PAAuthorized As User.DHCEQCVendor [ SqlColumnNumber = 4, SqlFieldName = PA_Authorized ];

/// PA_Desc
Property PADesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PA_Desc ];

/// PA_No
Property PANo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PA_No ];

/// PA_AuthorizDate
Property PAAuthorizDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PA_AuthorizDate ];

/// PA_AvailableFromDate
Property PAAvailableFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PA_AvailableFromDate ];

/// PA_AvailableToDate
Property PAAvailableToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PA_AvailableToDate ];

/// PA_Context
Property PAContext As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PA_Context ];

/// PA_Remark
Property PARemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PA_Remark ];

/// PA_LimitFlag
Property PALimitFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = PA_LimitFlag ];

/// PA_ActiveFlag
Property PAActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PA_ActiveFlag ];

/// PA_InvalidFlag
Property PAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = PA_InvalidFlag ];

/// PA_UpdateUserDR
Property PAUpdateUserDR As User.DHCEQCVendor [ SqlColumnNumber = 15, SqlFieldName = PA_UpdateUserDR ];

/// PA_UpdateDate
Property PAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = PA_UpdateDate ];

/// PA_UpdateTime
Property PAUpdateTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = PA_UpdateTime ];

/// PA_Status
Property PAStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 4, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 18, SqlFieldName = PA_Status ];

/// PA_Hold1
Property PAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PA_Hold1 ];

/// PA_Hold2
Property PAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PA_Hold2 ];

/// PA_Hold3
Property PAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PA_Hold3 ];

/// PA_Hold4
Property PAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PA_Hold4 ];

/// PA_Hold5
Property PAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQProxyAuthorization("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PA_AuthorizDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PA_Authorized">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PA_Authorizer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_AvailableFromDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PA_AvailableToDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PA_Context">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PA_LimitFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PA_ManuFactoryDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_No">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PA_Status">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PA_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQProxyAuthorization</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuthoriz">
<Global>^DHCEQProxyAuthorization</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ProxyAuthoriz"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_ManuFactoryDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Authorizer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Authorized}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQProxyAuthorizationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

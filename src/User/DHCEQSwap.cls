Class User.DHCEQSwap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = S_RowID, SqlTableName = DHC_EQSwap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// S_SwapNo
Property SSwapNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = S_SwapNo ];

/// S_Type
Property SType As %Library.String(DISPLAYLIST = ",销毁,更换", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 3, SqlFieldName = S_Type ];

/// S_LocDR
Property SLocDR As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = S_LocDR ];

/// S_RequestLocDR
Property SRequestLocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = S_RequestLocDR ];

/// S_RequestDate
Property SRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = S_RequestDate ];

/// S_RequestUserDR
Property SRequestUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = S_RequestUserDR ];

/// S_QuantityNum
Property SQuantityNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = S_QuantityNum ];

/// S_StartDate
Property SStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = S_StartDate ];

/// S_EndDate
Property SEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = S_EndDate ];

/// S_Status
Property SStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 11, SqlFieldName = S_Status ];

/// S_UpdateUserDR
Property SUpdateUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = S_UpdateUserDR ];

/// S_UpdateDate
Property SUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = S_UpdateDate ];

/// S_UpdateTime
Property SUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = S_UpdateTime ];

/// S_SubmitUserDR
Property SSubmitUserDR As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = S_SubmitUserDR ];

/// S_SubmitDate
Property SSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = S_SubmitDate ];

/// S_SubmitTime
Property SSubmitTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = S_SubmitTime ];

/// S_AuditUserDR
Property SAuditUserDR As User.SSUser [ SqlColumnNumber = 18, SqlFieldName = S_AuditUserDR ];

/// S_AudiDate
Property SAudiDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = S_AudiDate ];

/// S_AuditTime
Property SAuditTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = S_AuditTime ];

/// S_Hold1
Property SHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = S_Hold1 ];

/// S_Hold2
Property SHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = S_Hold2 ];

/// S_Hold3
Property SHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = S_Hold3 ];

/// S_Hold4
Property SHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = S_Hold4 ];

/// S_Hold5
Property SHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = S_Hold5 ];

/// S_InvalidFlag
Property SInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = S_InvalidFlag ];

Index SSwapNoUnqIdx1 On SSwapNo [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSwap("0"))</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="S_AudiDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="S_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="S_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="S_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="S_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="S_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="S_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="S_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="S_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="S_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="S_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="S_QuantityNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="S_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="S_RequestLocDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="S_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="S_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="S_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="S_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="S_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="S_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="S_SwapNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="S_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="S_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="S_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="S_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQSwap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCEQSwap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{S_AudiDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEndDate">
<Global>^DHCEQSwap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EndDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{S_EndDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQSwap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
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
<Expression>{S_SwapNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequestLoc">
<Global>^DHCEQSwap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RequestLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{S_RequestLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartDate">
<Global>^DHCEQSwap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>S_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"StartDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{S_StartDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{S_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSwapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

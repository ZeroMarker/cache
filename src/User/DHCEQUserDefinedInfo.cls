Class User.DHCEQUserDefinedInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UDI_RowID, SqlTableName = DHC_EQUserDefinedInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UDI_SourceType
Property UDISourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = UDI_SourceType ];

/// UDI_SourceID
Property UDISourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = UDI_SourceID ];

/// UDI_Status
Property UDIStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 4, SqlFieldName = UDI_Status ];

/// UDI_UserDefinedDR
Property UDIUserDefinedDR As User.DHCEQCUserDefined [ SqlColumnNumber = 5, SqlFieldName = UDI_UserDefinedDR ];

/// UDI_AddUser
Property UDIAddUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UDI_AddUser ];

/// UDI_AddDate
Property UDIAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = UDI_AddDate ];

/// UDI_AddTime
Property UDIAddTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = UDI_AddTime ];

/// UDI_UpdateUser
Property UDIUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UDI_UpdateUser ];

/// UDI_UpdateDate
Property UDIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = UDI_UpdateDate ];

/// UDI_UpdateTime
Property UDIUpdateTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = UDI_UpdateTime ];

/// UDI_SubmitUser
Property UDISubmitUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = UDI_SubmitUser ];

/// UDI_SubmitDate
Property UDISubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = UDI_SubmitDate ];

/// UDI_SubmitTime
Property UDISubmitTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = UDI_SubmitTime ];

/// UDI_AuditUser
Property UDIAuditUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = UDI_AuditUser ];

/// UDI_AuditDate
Property UDIAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = UDI_AuditDate ];

/// UDI_AuditTime
Property UDIAuditTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = UDI_AuditTime ];

/// UDI_InvalidFlag
Property UDIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = UDI_InvalidFlag ];

/// UDI_Remark
Property UDIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = UDI_Remark ];

/// UDI_Hold1
Property UDIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = UDI_Hold1 ];

/// UDI_Hold2
Property UDIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = UDI_Hold2 ];

/// UDI_Hold3
Property UDIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = UDI_Hold3 ];

/// UDI_Hold4
Property UDIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = UDI_Hold4 ];

/// UDI_Hold5
Property UDIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = UDI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUserDefinedInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UDI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UDI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UDI_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UDI_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UDI_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UDI_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UDI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UDI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UDI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UDI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UDI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UDI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UDI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UDI_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UDI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UDI_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UDI_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UDI_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UDI_SubmitUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UDI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UDI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UDI_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UDI_UserDefinedDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQUserDefinedInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UDI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{UDI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQUserDefinedInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>UDI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UDI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UDI_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UDI_UserDefinedDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQUserDefinedInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UDI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UDI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUserDefinedInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEQBenefitSummary Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQBenefitSummary, StorageStrategy = SQLStorage ]
{

/// BS_Year
Property BSYear As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BS_Year ];

/// BS_Summary
Property BSSummary As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BS_Summary ];

/// BS_UserDR
Property BSUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BS_UserDR ];

/// BS_Date
Property BSDate As %Date [ SqlColumnNumber = 5, SqlFieldName = BS_Date ];

/// BS_Status
Property BSStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 6, SqlFieldName = BS_Status ];

/// BS_UpdateUser
Property BSUpdateUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BS_UpdateUser ];

/// BS_UpdateDate
Property BSUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BS_UpdateDate ];

/// BS_UpdateTime
Property BSUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BS_UpdateTime ];

/// BS_SubmitUser
Property BSSubmitUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BS_SubmitUser ];

/// BS_SubmitDate
Property BSSubmitDate As %Date [ SqlColumnNumber = 11, SqlFieldName = BS_SubmitDate ];

/// BS_SubmitTime
Property BSSubmitTime As %Time [ SqlColumnNumber = 12, SqlFieldName = BS_SubmitTime ];

/// BS_AuditUser
Property BSAuditUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BS_AuditUser ];

/// BS_AuditDate
Property BSAuditDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BS_AuditDate ];

/// BS_AuditTime
Property BSAuditTime As %Time [ SqlColumnNumber = 15, SqlFieldName = BS_AuditTime ];

/// BS_InvalidFlag
Property BSInvalidFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BS_InvalidFlag ];

/// BS_Hold1
Property BSHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BS_Hold1 ];

/// BS_Hold2
Property BSHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BS_Hold2 ];

/// BS_Hold3
Property BSHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BS_Hold3 ];

/// BS_Hold4
Property BSHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BS_Hold4 ];

/// BS_Hold5
Property BSHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BS_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQBenefitSummary("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BS_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BS_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BS_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BS_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BS_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BS_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BS_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BS_SubmitUser">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BS_Summary">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BS_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BS_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BS_Year">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQBenefitSummary</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQBenefitSummary</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BS_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BS_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQBenefitSummaryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

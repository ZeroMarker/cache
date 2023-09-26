Class User.DHCEQMergeOrder Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = M_RowID, SqlTableName = DHC_EQMergeOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// M_MergeOrderNo
Property MMergeOrderNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = M_MergeOrderNo ];

/// M_SourceType
Property MSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = M_SourceType ];

/// M_SubType
Property MSubType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = M_SubType ];

/// M_Remark
Property MRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = M_Remark ];

/// M_UpdateUser
Property MUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = M_UpdateUser ];

/// M_UpdateDate
Property MUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = M_UpdateDate ];

/// M_UpdateTime
Property MUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = M_UpdateTime ];

/// M_SubmitUser
Property MSubmitUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = M_SubmitUser ];

/// M_SubmitDate
Property MSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = M_SubmitDate ];

/// M_SubmitTime
Property MSubmitTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = M_SubmitTime ];

/// M_AuditUser
Property MAuditUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = M_AuditUser ];

/// M_AuditDate
Property MAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = M_AuditDate ];

/// M_AuditTime
Property MAuditTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = M_AuditTime ];

/// M_Status
Property MStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 1, SELECTIVITY = "25.0000%", VALUELIST = ",0,1,2") [ SqlColumnNumber = 15, SqlFieldName = M_Status ];

/// M_InvalidFlag
Property MInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = M_InvalidFlag ];

/// M_Hold1
Property MHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = M_Hold1 ];

/// M_Hold2
Property MHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = M_Hold2 ];

/// M_Hold3
Property MHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = M_Hold3 ];

/// M_Hold4
Property MHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = M_Hold4 ];

/// M_Hold5
Property MHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = M_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMergeOrder("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="M_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="M_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="M_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="M_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="M_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="M_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="M_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="M_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="M_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="M_MergeOrderNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="M_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="M_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="M_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="M_SubType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="M_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="M_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="M_SubmitUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="M_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="M_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="M_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQMergeOrder</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{M_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQMergeOrder</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{M_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{M_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMergeOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

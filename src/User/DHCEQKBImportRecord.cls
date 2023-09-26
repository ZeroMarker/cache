Class User.DHCEQKBImportRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IR_RowID, SqlTableName = DHC_EQKBImportRecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// IR_KBType
Property IRKBType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IR_KBType ];

/// IR_HospDR
Property IRHospDR As User.DHCEQKBHospital [ SqlColumnNumber = 3, SqlFieldName = IR_HospDR ];

/// IR_TotalNum
Property IRTotalNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IR_TotalNum ];

/// IR_AddNum
Property IRAddNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = IR_AddNum ];

/// IR_UpdateNum
Property IRUpdateNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IR_UpdateNum ];

/// IR_Times
Property IRTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IR_Times ];

/// IR_Remark
Property IRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IR_Remark ];

/// IR_AddDate
Property IRAddDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IR_AddDate ];

/// IR_AddTime
Property IRAddTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IR_AddTime ];

/// IR_AddUser
Property IRAddUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IR_AddUser ];

/// IR_Hold1
Property IRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = IR_Hold1 ];

/// IR_Hold2
Property IRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IR_Hold2 ];

/// IR_Hold3
Property IRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IR_Hold3 ];

/// IR_Hold4
Property IRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IR_Hold4 ];

/// IR_Hold5
Property IRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IR_Hold5 ];

/// IR_Hold6
Property IRHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IR_Hold6 ];

/// IR_Hold7
Property IRHold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = IR_Hold7 ];

/// IR_Hold8
Property IRHold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = IR_Hold8 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<IdExpression>$i(^DHCEQKB("DHCEQKBImportRecord",0))</IdExpression>
<SQLMap name="DataMaster">
<Data name="IR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IR_AddNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IR_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IR_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IR_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IR_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IR_HospDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IR_KBType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IR_Times">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IR_TotalNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IR_UpdateNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQKB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBImportRecord"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospDR">
<Global>^DHCEQKB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQKBImportRecord"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HospDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IR_HospDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQKBImportRecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEQGroupList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GL_RowID, SqlTableName = DHC_EQGroupList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GL_GroupDR
Property GLGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GL_GroupDR ];

/// GL_EquipDR
Property GLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = GL_EquipDR ];

/// GL_MainFlag
Property GLMainFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GL_MainFlag ];

/// GL_Sort
Property GLSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = GL_Sort ];

/// GL_Remark
Property GLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = GL_Remark ];

/// GL_FromDate
Property GLFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = GL_FromDate ];

/// GL_ToDate
Property GLToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = GL_ToDate ];

/// GL_IncomeRate
Property GLIncomeRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = GL_IncomeRate ];

/// GL_ExpendRate
Property GLExpendRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = GL_ExpendRate ];

/// GL_UpdateDate
Property GLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = GL_UpdateDate ];

/// GL_UpdateTime
Property GLUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = GL_UpdateTime ];

/// GL_UpdateUserDR
Property GLUpdateUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = GL_UpdateUserDR ];

/// GL_InvalidFlag
Property GLInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = GL_InvalidFlag ];

/// GL_Hold1
Property GLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = GL_Hold1 ];

/// GL_Hold2
Property GLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = GL_Hold2 ];

/// GL_Hold3
Property GLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = GL_Hold3 ];

/// GL_Hold4
Property GLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = GL_Hold4 ];

/// GL_Hold5
Property GLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = GL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQGroupList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GL_ExpendRate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GL_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GL_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="GL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="GL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="GL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="GL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="GL_IncomeRate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="GL_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="GL_MainFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GL_Sort">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GL_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQGroupList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{GL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQGroupList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCEQGroupList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GL_GroupDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQGroupListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

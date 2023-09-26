Class User.DHCEQPartList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PL_RowID, SqlTableName = DHC_EQPartList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PL_EquipDR
Property PLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = PL_EquipDR ];

/// PL_PartDR
Property PLPartDR As User.DHCEQCPart [ SqlColumnNumber = 3, SqlFieldName = PL_PartDR ];

/// PL_Remark
Property PLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PL_Remark ];

/// PL_AddUserDR
Property PLAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PL_AddUserDR ];

/// PL_AddDate
Property PLAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PL_AddDate ];

/// PL_AddTime
Property PLAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PL_AddTime ];

/// PL_UpdateUserDR
Property PLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PL_UpdateUserDR ];

/// PL_UpdateDate
Property PLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PL_UpdateDate ];

/// PL_UpdateTime
Property PLUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PL_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPartList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PL_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PL_PartDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQPartList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQPartList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPartListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

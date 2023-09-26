Class User.DHCEQFittintList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FL_RowID, SqlTableName = DHC_EQFittintList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FL_EquipDR
Property FLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = FL_EquipDR ];

/// FL_FittingDR
Property FLFittingDR As User.DHCEQCFittings [ SqlColumnNumber = 3, SqlFieldName = FL_FittingDR ];

/// FL_Remark
Property FLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = FL_Remark ];

/// FL_AddUserDR
Property FLAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = FL_AddUserDR ];

/// FL_AddDate
Property FLAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = FL_AddDate ];

/// FL_AddTime
Property FLAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = FL_AddTime ];

/// FL_UpdateUserDR
Property FLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = FL_UpdateUserDR ];

/// FL_UpdateDate
Property FLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = FL_UpdateDate ];

/// FL_UpdateTime
Property FLUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = FL_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQFittintList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FL_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FL_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FL_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FL_FittingDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQFittintList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQFittintList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQFittintListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

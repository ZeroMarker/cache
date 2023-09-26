Class User.DHCEQEquipRangeList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ERL_RowID, SqlTableName = DHC_EQEquipRangeList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ERL_AccessFlag
Property ERLAccessFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ERL_AccessFlag ];

/// ERL_EquipRangeDR
Property ERLEquipRangeDR As User.DHCEQCManageLimit [ SqlColumnNumber = 2, SqlFieldName = ERL_EquipRangeDR ];

/// ERL_Type
Property ERLType As %Library.String(DISPLAYLIST = ",类组,类型,分类,科室,设备,设备项", MAXLEN = 5, SELECTIVITY = "14.2857%", VALUELIST = ",1,2,3,4,5,6") [ SqlColumnNumber = 3, SqlFieldName = ERL_Type ];

/// ERL_Value
Property ERLValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ERL_Value ];

/// ERL_SubValue
Property ERLSubValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ERL_SubValue ];

/// ERL_Hold1
Property ERLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ERL_Hold1 ];

/// ERL_Hold2
Property ERLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ERL_Hold2 ];

/// ERL_Hold3
Property ERLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ERL_Hold3 ];

/// ERL_Hold4
Property ERLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ERL_Hold4 ];

/// ERL_Hold5
Property ERLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = ERL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipRangeList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ERL_AccessFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ERL_EquipRangeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ERL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ERL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ERL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ERL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ERL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ERL_SubValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ERL_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ERL_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQEquipRangeList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ERL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ERL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccessFlag">
<Global>^DHCEQEquipRangeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ERL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AccessFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERL_EquipRangeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ERL_AccessFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ERL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLimitType">
<Global>^DHCEQEquipRangeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ERL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LimitType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERL_EquipRangeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ERL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLimitValue">
<Global>^DHCEQEquipRangeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ERL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LimitValue"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERL_EquipRangeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERL_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ERL_Value}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ERL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexValue">
<Global>^DHCEQEquipRangeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ERL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Value"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERL_Value}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexlimit">
<Global>^DHCEQEquipRangeList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Field>ERL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LimitDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERL_EquipRangeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipRangeListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

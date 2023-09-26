/// JXInPerson
Class dhc.pa.inter.JXInPerson Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXInPerson_rowid, SqlTableName = JXInPerson, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// JXInPerson_jxUnitDr
Property JXInPersonjxUnitDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 2, SqlFieldName = JXInPerson_jxUnitDr ];

/// JXInPerson_ssUserDr
Property JXInPersonssUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = JXInPerson_ssUserDr ];

/// JXInPerson_remark
Property JXInPersonremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXInPerson_remark ];

/// JXInPerson_active
Property JXInPersonactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = JXInPerson_active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCJXPAJXINPERSON(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="JXInPerson_active">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JXInPerson_jxUnitDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JXInPerson_remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JXInPerson_ssUserDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCCJXPAJXINPERSON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JXInPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{JXInPerson_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCCJXPAJXINPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXInPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXInPerson_active}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXInPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJXUnit">
<Global>^DHCCJXPAJXINPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXInPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JXUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXInPerson_jxUnitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXInPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexJXUnitUser">
<Global>^DHCCJXPAJXINPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>JXInPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"JXUnitUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXInPerson_jxUnitDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXInPerson_ssUserDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{JXInPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexssUser">
<Global>^DHCCJXPAJXINPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>JXInPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ssUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JXInPerson_ssUserDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JXInPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.inter.JXInPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

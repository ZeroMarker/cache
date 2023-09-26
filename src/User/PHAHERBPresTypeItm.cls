Class User.PHAHERBPresTypeItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPTI_RowID, SqlTableName = PHAHERB_PresTypeItm, StorageStrategy = sqlStorage ]
{

Index RowIDBasedIDKeyIndex On PHPTIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PHPTIParref As User.PHAHERBPresType [ Cardinality = parent, Inverse = ChildPHAHERBPresTypeItm, Required, SqlFieldName = PHPTI_Parref ];

Property PHPTIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHPTI_ChildSub ];

Property PHPTIConCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PHPTI_ConCode ];

Property PHPTIConDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = PHPTI_ConDesc ];

Storage sqlStorage
{
<SQLMap name="DataMaster">
<Data name="PHPTI_ConCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHPTI_ConDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CD.PHA.HERB.PresTypeItm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAHERB_PresType.PHPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHPTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAHERB_PresType.PHPT_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PHPTI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHPTI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConCode">
<Global>^CD.PHA.HERB.PresTypeItmi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAHERB_PresType.PHPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHPTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ConCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHPTI_ConCode}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAHERB_PresType.PHPT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHPTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAHERBPresTypeItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class dhc.ca.cache.data.InPerson Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = InPerson_rowid, SqlTableName = InPerson, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// InPerson_order
Property InPersonorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = InPerson_order ];

/// InPerson_personDr
Property InPersonpersonDr As dhc.ca.cache.data.UnitPersons [ SqlColumnNumber = 3, SqlFieldName = InPerson_personDr ];

/// InPerson_personSetsDr
Property InPersonpersonSetsDr As dhc.ca.cache.data.PersonSets [ SqlColumnNumber = 4, SqlFieldName = InPerson_personSetsDr ];

/// InPerson_outPersonDr
Property InPersonoutPersonDr As dhc.ca.cache.data.OutPerson [ SqlColumnNumber = 5, SqlFieldName = InPerson_outPersonDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAINPERSON(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="InPerson_order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="InPerson_outPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="InPerson_personDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="InPerson_personSetsDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="InPerson_rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAINPERSON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InPerson_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInPerson">
<Global>^DHCCAINPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>InPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InPerson"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InPerson_personDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.InPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

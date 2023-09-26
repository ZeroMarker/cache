Class dhc.ca.cache.data.OutPerson Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutPerson_rowid, SqlTableName = OutPerson, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OutPerson_order
Property OutPersonorder As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = OutPerson_order ];

/// OutPerson_code
Property OutPersoncode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OutPerson_code ];

/// OutPerson_name
Property OutPersonname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OutPerson_name ];

/// OutPerson_remark
Property OutPersonremark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OutPerson_remark ];

/// OutPerson_InPersonDr
Property OutPersonInPersonDr As dhc.ca.cache.data.InPerson [ SqlColumnNumber = 6, SqlFieldName = OutPerson_InPersonDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCAOUTPERSON(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="OutPerson_InPersonDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OutPerson_code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OutPerson_name">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OutPerson_order">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OutPerson_remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OutPerson_rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCCAOUTPERSON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OutPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OutPerson_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInPerson">
<Global>^DHCCAOUTPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InPerson"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutPerson_InPersonDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutCode">
<Global>^DHCCAOUTPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutPerson_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutName">
<Global>^DHCCAOUTPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutPerson_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutOrder">
<Global>^DHCCAOUTPERSON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OutPerson_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutPerson_order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutPerson_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.OutPersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

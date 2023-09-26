Class User.DHCRBStaticAppBillFieldVa Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSFV_Rowid, SqlTableName = DHCRB_StaticAppBillFieldValue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 254;

/// DSFV_Name
Property DSFVName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSFV_Name ];

/// DSFV_OEOrditem_DR
Property DSFVOEOrditemDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DSFV_OEOrditem_DR ];

/// DSFV_Value
Property DSFVValue As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DSFV_Value ];

/// DSFV_Note
Property DSFVNote As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DSFV_Note ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBApp("FieldValue"))</SqlIdExpression>
<SQLMap name="IndexName">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSFV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSFV_Name}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSFV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSFV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Orditem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSFV_OEOrditem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSFV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexValue">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSFV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Value"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSFV_Value}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSFV_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapData">
<Data name="DSFV_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSFV_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSFV_OEOrditem_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSFV_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSFV_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FieldValue"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSFV_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBStaticAppBillFieldVaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

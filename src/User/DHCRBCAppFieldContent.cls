Class User.DHCRBCAppFieldContent Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAFC_Rowid, SqlTableName = DHCRBC_AppField_Content, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAFC_Field_DR
Property DAFCFieldDR As User.DHCRBCApplicationField [ SqlColumnNumber = 2, SqlFieldName = DAFC_Field_DR ];

/// DAFC_Value
Property DAFCValue As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DAFC_Value ];

/// DAFC_Format
Property DAFCFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DAFC_Format ];

/// DAFC_Code
Property DAFCCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DAFC_Code ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBApp("FieldContent"))</SqlIdExpression>
<SQLMap name="DHCRBApp">
<Data name="DAFC_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAFC_Field_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAFC_Format">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAFC_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAFC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FieldContent"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAFC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexField">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAFC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"FieldContent"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAFC_Field_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAFC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCAppFieldContentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// 
Class User.DHCRBCApplicationField Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAF_Rowid, SqlTableName = DHCRBC_ApplicationField, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAF_Desc
Property DAFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DAF_Desc ];

/// DAF_Type
Property DAFType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DAF_Type ];

/// DAF_Content
Property DAFContent As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DAF_Content ];

/// DAF_Option
Property DAFOption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DAF_Option ];

/// DAF_Require
Property DAFRequire As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DAF_Require ];

/// DAF_Width
Property DAFWidth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DAF_Width ];

/// DAF_Height
Property DAFHeight As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DAF_Height ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBApp("Field"))</SqlIdExpression>
<SQLMap name="MasterMapData">
<Data name="DAF_Content">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAF_Height">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DAF_Option">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAF_Require">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DAF_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAF_Width">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCRBApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Field"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAF_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCApplicationFieldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

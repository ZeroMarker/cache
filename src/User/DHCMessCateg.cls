/// Message Category
Class User.DHCMessCateg Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MESSCAT_RowId, SqlTableName = DHC_MessCateg, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Message Category Code
Property MESSCATCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "20.0000%", TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MESSCAT_Code ];

/// Message Category desc
Property MESSCATDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MESSCAT_Desc ];

/// Message category Active
Property MESSCATActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MESSCAT_Active ];

/// Message Category Note
Property MESSCATNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MESSCAT_Note ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMESS("MESSCAT"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MESSCAT_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MESSCAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MESSCAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MESSCAT_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMESS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MESSCAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MESSCAT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMessCategS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

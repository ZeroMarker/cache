Class User.DHCPHREQCODE Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHReqc_rowid, SqlTableName = DHC_PHREQCODE, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHReqc_Code
Property PHReqcCode As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = PHReqc_Code ];

/// year
Property PHReqcYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PHReqc_Year ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHREQC)</SqlIdExpression>
<SQLMap name="phreqcmaster">
<Data name="PHReqc_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHReqc_Year">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHREQC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHReqc_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHReqc_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHREQCODES</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

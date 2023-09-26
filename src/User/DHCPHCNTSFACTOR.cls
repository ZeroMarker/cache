Class User.DHCPHCNTSFACTOR Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCF_RowID, SqlTableName = DHC_PHCNTSFACTOR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PCF_Code
Property PCFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCF_Code ];

/// PCF_Desc
Property PCFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PCF_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPCFACTOR)</SqlIdExpression>
<SQLMap name="MasterData">
<Data name="PCF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPCFACTOR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PCF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCNTSFACTORS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

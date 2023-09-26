Class User.DHCSTRefuseReason Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RF_Rowid, SqlTableName = DHC_STRefuseReason, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RF_Code
Property RFCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RF_Code ];

/// RF_Desc
Property RFDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RF_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRFREASON)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRFREASON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RF_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSTRefuseReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

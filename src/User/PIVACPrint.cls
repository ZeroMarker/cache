/// mt36281
Class User.PIVACPrint Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCP_Rowid, SqlTableName = PIVA_CPrint, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PCP_PrintNo
Property PCPPrintNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PCP_PrintNo ];

/// PCP_SSUSR_Dr
Property PCPSSUSRDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PCP_SSUSR_Dr ];

/// PCP_Date
Property PCPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PCP_Date ];

/// PCP_Time
Property PCPTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PCP_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVACP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCP_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCP_PrintNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCP_SSUSR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCP_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PIVACP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCP_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PCP_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVACPrintS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

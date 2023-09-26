/// DHC_PA_ProcCodeEPR
Class User.DHCPAProcCodeEPR Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROCCE_RowId, SqlTableName = DHC_PA_ProcCodeEPR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PROCCE_Code
Property PROCCECode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PROCCE_Code ];

/// PROCCE_Desc
Property PROCCEDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PROCCE_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCProcC("EPRItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PROCCE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROCCE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCProcC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PROCCE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PROCCE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCProcC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PROCCE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"EPR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PROCCE_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PROCCE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcCodeEPRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

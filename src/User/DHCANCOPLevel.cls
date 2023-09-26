/// DHC_ANC_OPLevel
Class User.DHCANCOPLevel Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCOPL_RowId, SqlTableName = DHC_ANC_OPLevel, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ANCOPL_Code
Property ANCOPLCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ANCOPL_Code ];

/// ANCOPL_Desc
Property ANCOPLDesc As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCOPL_Desc ];

Index ANCOPLCodeUnqIdx1 On ANCOPLCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCANC("OPLevel",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ANCOPL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCOPL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ANCOPL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPLevel"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ANCOPL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCANC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ANCOPL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPLevel"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCOPL_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANCOPL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCOPLevelS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

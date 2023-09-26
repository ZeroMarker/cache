Class User.PIVALocGrp Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PLG_Rowid, SqlTableName = PIVA_LocGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildPIVALocGrpItm As User.PIVALocGrpItm [ Cardinality = children, Inverse = PLGIPLGParRef ];

/// PLG_Desc
Property PLGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PLG_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PLGR)</SqlIdExpression>
<SQLMap name="DataMasterPLGR">
<Data name="PLG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PLGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLG_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PLG_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVALocGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

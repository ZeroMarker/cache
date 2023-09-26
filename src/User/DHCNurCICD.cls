/// DHC_NurC_ICD
Class User.DHCNurCICD Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = NCICD_RowId, SqlTableName = DHC_NurC_ICD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2000;

/// NCICD_Code
Property NCICDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = NCICD_Code ];

/// NCICD_Desc
Property NCICDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = NCICD_Desc ];

Storage SQLStorage
{
<ExtentSize>2000</ExtentSize>
<SqlIdExpression>$i(^DHCNurC("ICD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NCICD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NCICD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCNurC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NCICD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ICD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NCICD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCNurCICDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCRBStudyNoCreatetype Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RBSCT_Rowid, SqlTableName = DHCRB_StudyNo_Createtype, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RBSCT_Type
Property RBSCTType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RBSCT_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACRegInfoCT("CreateType",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RBSCT_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPACRegInfoCT</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RBSCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CreateType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBSCT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBStudyNoCreatetypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

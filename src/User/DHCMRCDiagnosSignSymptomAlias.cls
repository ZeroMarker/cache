Class User.DHCMRCDiagnosSignSymptomAlias Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_MRCDiagnosSignSymptomAlias, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (DSYMAParRef, DSYMAChildsub) [ IdKey, PrimaryKey, Unique ];

Property DSYMAAlias As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DSYMA_Alias ];

Property DSYMAChildsub As %Float [ InitialExpression = {$i(^MRC("DSYM",$s($d(p1):p1,1:%d(2)),"ALIAS",0))}, SqlColumnNumber = 3, SqlFieldName = DSYMA_Childsub ];

Property DSYMAParRef As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DSYMA_ParRef ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMap">
<Data name="DSYMA_Alias">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DSYMA_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DSYMA_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSYM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSYMA_ParRef}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSYMA_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSYMA_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDiagnosSiA1CS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

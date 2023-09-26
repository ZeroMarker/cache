/// CustomExtractReport(2341)
Class User.PACCustomExtractReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CustomExtractReport, StorageStrategy = SQLStorage ]
{

/// Childsub
Property REPChildsub As %Float [ InitialExpression = {$i(^PAC("CUSTEXT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REP",0))}, SqlColumnNumber = 2, SqlFieldName = REP_Childsub ];

/// Code
Property REPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REP_Code ];

/// DeleteScript
Property REPDeleteScript As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = REP_DeleteScript ];

/// Description
Property REPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = REP_Desc ];

/// ExtractScript
Property REPExtractScript As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = REP_ExtractScript ];

/// PAC_CustomExtract Parent Reference
Relationship REPParRef As PACCustomExtract [ Cardinality = parent, Inverse = ChildPACCustomExtractReport, Required, SqlFieldName = REP_ParRef ];

Index RowIDBasedIDKeyIndex On REPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="REPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPDeleteScript">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPExtractScript">
<Selectivity>1</Selectivity>
</Property>
<Property name="REPParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="REP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REP_DeleteScript">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REP_ExtractScript">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_CustomExtract.CUSTEXT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>REP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CUSTEXT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_CustomExtract.CUSTEXT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REP_RowId</SqlRowIdName>
<StreamLocation>^User.PACCustomExtractReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCItmReplace Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IR_Rowid, SqlTableName = DHC_ItmReplace, StorageStrategy = NewStorage1 ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On IRChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmMast Parent Reference
Relationship IRParRef As User.DHCItmMast [ Cardinality = parent, Inverse = ChildDHCItmReplace, Required, SqlFieldName = IR_ParRef ];

/// ITC_Childsub
Property IRChildsub As %Library.Float [ InitialExpression = {$i(^DHCItmMast($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CR",0))}, SqlColumnNumber = 2, SqlFieldName = IR_Childsub ];

/// ITC_ConflicItm_DR
Property IRReplaceItmDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = IR_ReplaceItm_DR ];

Property IRReplaceExpress As %String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = IR_ReplaceExpress ];

Storage NewStorage1
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IR_ReplaceExpress">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IR_ReplaceItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCItmMast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmMast.DARCIM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IR_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ItmMast.DARCIM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IR_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCItmReplaceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

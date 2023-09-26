Class User.DHCItmAppend Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCIA_Rowid, SqlTableName = DHC_ItmAppend, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DHCIAChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmMast Parent Reference
Relationship DHCIAParRef As User.DHCItmMast [ Cardinality = parent, Inverse = ChildDHCItmAppend, Required, SqlFieldName = DHCIA_ParRef ];

/// DHCIA_Childsub
Property DHCIAChildsub As %Library.Float [ InitialExpression = {$i(^DHCItmMast($p(%d(0),$c(1)),"AP",0))}, Required, SqlColumnNumber = 2, SqlFieldName = DHCIA_Childsub ];

/// DHCIA_AppendItm_DR
Property DHCIAAppendItmDR As User.DHCItmMast [ SqlColumnNumber = 3, SqlFieldName = DHCIA_AppendItm_DR ];

/// DHCIA_Qty
Property DHCIAQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCIA_Qty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DHCIA_AppendItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCIA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCItmMast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmMast.DARCIM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHCIA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_ItmMast.DARCIM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCIA_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCItmAppendS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

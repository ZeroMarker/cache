Class User.DHCSubLocStkTkItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = SUBSTI_RowId, SqlTableName = DHC_SubLocStkTkItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SUBSTIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship SUBSTISUBSTParref As User.DHCSubLocStkTk [ Cardinality = parent, Inverse = ChildDHCSubLocStkTkItm, Required, SqlFieldName = SUBSTI_SUBST_Parref ];

Property SUBSTIChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SUBSTI_Childsub ];

Property SUBSTIINCILDR As User.INCItmLoc [ SqlColumnNumber = 3, SqlFieldName = SUBSTI_INCIL_DR ];

/// 冻结数量(基本单位)
Property SUBSTIFreezeQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = SUBSTI_FreezeQty ];

/// 实盘数量(基本单位)
Property SUBSTICountQty As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SUBSTI_CountQty ];

Property SUBSTICTUOMDR As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = SUBSTI_CTUOM_DR ];

Property SUBSTIRpAmt As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = SUBSTI_RpAmt ];

Property SUBSTISpAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = SUBSTI_SpAmt ];

Property SUBSTIRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SUBSTI_Remarks ];

/// 补货量(基本单位)
Property SUBSTIQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SUBSTI_Qty ];

Property SUBSTIINADIStr As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SUBSTI_INADIStr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterMap">
<Data name="SUBSTI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUBSTI_CountQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUBSTI_FreezeQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUBSTI_INADIStr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SUBSTI_INCIL_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBSTI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUBSTI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUBSTI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUBSTI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCSLST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_SubLocStkTk.SUBST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SUBSTI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_SubLocStkTk.SUBST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SUBSTI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUBSTI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSubLocStkTkItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

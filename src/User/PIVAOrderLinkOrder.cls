Class User.PIVAOrderLinkOrder Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = POLO_RowID, SqlTableName = PIVA_OrderLinkOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On POLOChildsub [ IdKey, PrimaryKey, Unique ];

/// PIVA_OrderLink Parent Reference
Relationship POLOPOLParRef As User.PIVAOrderLink [ Cardinality = parent, Inverse = ChildPIVAOrderLinkOrder, Required, SqlFieldName = POLO_POL_ParRef ];

/// POLO_Childsub
Property POLOChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = POLO_Childsub ];

/// POL_Arcim_Dr
Property POLOArcimDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = POLO_Arcim_Dr ];

/// POLO_AddQty
Property POLOAddQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = POLO_AddQty ];

/// 批次名称
Property POLOBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = POLO_BatNo ];

/// 是否打包,Y-打包,N-配液,""-所有
Property POLOPackFlag As %Library.String(DISPLAYLIST = ",Y,N", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = POLO_PackFlag ];

/// 是否关联医嘱
Property POLOSeqFlag As %Library.String(DISPLAYLIST = ",Y,N", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = POLO_SeqFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterPOLO">
<Data name="POLO_AddQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="POLO_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POLO_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POLO_Childsub">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POLO_POL_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POLO_PackFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POLO_SeqFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^POLI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_OrderLink.POL_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POLO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PIVA_OrderLink.POL_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"M"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{POLO_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PIVAOrderLinkOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCASPAmountLB Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ASPALB_Rowid, SqlTableName = DHC_ASPAmountLB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ASPALBChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_ASPAmount Parent Reference
Relationship ASPALBASPAParref As User.DHCASPAmount [ Cardinality = parent, Inverse = ChildDHCASPAmountLB, Required, SqlFieldName = ASPALB_ASPA_Parref ];

/// ASPALB_Childsub
Property ASPALBChildsub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ASPALB_Childsub ];

/// ASPALB_INCLB_DR
Property ASPALBINCLBDR As User.INCItmLcBt [ SqlColumnNumber = 3, SqlFieldName = ASPALB_INCLB_DR ];

/// ASPALB_Qty
Property ASPALBQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = ASPALB_Qty ];

/// SPALB_AdjDiff
Property ASPALBAdjDiff As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ASPALB_AdjDiff ];

/// ASPALB_AdjAmt_
Property ASPALBAdjAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ASPALB_AdjAmt ];

/// ASPALB_AdjRP
Property ASPALBAdjRP As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ASPALB_AdjRP ];

/// ASPALB_RPAmt
Property ASPALBRPAmt As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ASPALB_RPAmt ];

/// ASPALB_PriorRP
Property ASPALBPriorRP As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ASPALB_PriorRP ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ASPALB_AdjAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASPALB_AdjDiff">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASPALB_AdjRP">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ASPALB_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASPALB_PriorRP">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ASPALB_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASPALB_RPAmt">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^ASPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ASPAmount.ASPA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ASPALB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_ASPAmount.ASPA_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ASPALB_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInclb">
<Global>^ASPA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ASPAmount.ASPA_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ASPALB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ASPALB_INCLB_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_ASPAmount.ASPA_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ASPALB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCASPAmountLBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

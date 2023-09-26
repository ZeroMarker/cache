Class User.DHCMatDispItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSI_RowId, SqlTableName = DHC_MatDispItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DSIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DSIParRef As User.DHCMatDisp [ Cardinality = parent, Inverse = ChildDHCMatDispItm, Required, SqlFieldName = DSI_ParRef ];

Relationship ChildDHCMatDispItmInclb As User.DHCMatDispItmInclb [ Cardinality = children, Inverse = DSLBParRef ];

Property DSIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DSI_ChildSub ];

Property DSIOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DSI_OEORI_DR ];

Property DSIDispensingDR As User.DHCOEDispensing [ SqlColumnNumber = 4, SqlFieldName = DSI_Dispensing_DR ];

Property DSIPrescNo As %String [ SqlColumnNumber = 5, SqlFieldName = DSI_PrescNo ];

Property DSIOriStatus As User.OEOrdStatus [ SqlColumnNumber = 6, SqlFieldName = DSI_OriStatus ];

Property DSIINCIDR As User.INCItm [ SqlColumnNumber = 7, SqlFieldName = DSI_INCI_DR ];

Property DSIQty As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DSI_Qty ];

Property DSISp As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DSI_Sp ];

Property DSISpAmt As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DSI_SpAmt ];

Property DSIRetQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = DSI_RetQty ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DSI_Dispensing_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSI_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSI_OriStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSI_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSI_RetQty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSI_Sp">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMATDISP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MatDisp.DISP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_MatDisp.DISP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOeOri">
<Global>^DHCMATDISP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_MatDisp.DISP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OeOri"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSI_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_MatDisp.DISP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMatDispItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

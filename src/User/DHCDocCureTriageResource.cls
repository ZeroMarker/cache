Class User.DHCDocCureTriageResource Extends %Persistent [ SqlTableName = DHC_DocCureTriageResource, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DDCTRChildSub [ IdKey, PrimaryKey, Unique ];

Relationship DDCTRParRef As User.DHCDocCureRBCServiceGroupSet [ Cardinality = parent, Inverse = ChildDHCDocCureRBCServiceGroupSet, Required, SqlFieldName = DDCTR_ParRef ];

/// DCAA_ChildSub
Property DDCTRChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureTR($p(%d(0),$c(1)),"TR",0))}, SqlColumnNumber = 2, SqlFieldName = DDCTR_ChildSub ];

Property DDCTRCTLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DDCTR_CTLoc_Dr ];

Property DDCTRCTPCPDr As User.RBResource [ SqlColumnNumber = 4, SqlFieldName = DDCTR_CTPCP_Dr ];

Property DDCTRActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DDCTR_Active ];

Property DDCTRCount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DDCTR_Count ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DDCTR_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCTR_CTLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCTR_CTPCP_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCTR_Count">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocCureTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureRBCServiceGroupSet.DDCSGS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DDCTR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureRBCServiceGroupSet.DDCSGS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCTR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLoc">
<Global>^DHCDocCureTRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureRBCServiceGroupSet.DDCSGS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DDCTR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCTR_CTLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureRBCServiceGroupSet.DDCSGS_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCTR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocResource">
<Global>^DHCDocCureTRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_DocCureRBCServiceGroupSet.DDCSGS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DDCTR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCTR_CTLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCTR_CTPCP_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_DocCureRBCServiceGroupSet.DDCSGS_Rowid}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DDCTR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCTR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureTriageResourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

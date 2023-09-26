Class User.DHCPHCOMMENTSREITM Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCNTSRI_RowID, SqlTableName = DHC_PHCOMMENTSREITM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PCNTSRIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHCOMMENTS Parent Reference
Relationship PCNTSRIParRefDr As User.DHCPHCOMMENTS [ Cardinality = parent, Inverse = ChildDHCPHCOMMENTSREITM, Required, SqlFieldName = PCNTSRI_ParRef_Dr ];

/// PCNTSRI_ChildSub
Property PCNTSRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PCNTSRI_ChildSub ];

/// PCNTSRI_CNTSITM_Dr
Property PCNTSRICNTSITMDr As User.DHCPHCOMMENTSITM [ SqlColumnNumber = 3, SqlFieldName = PCNTSRI_CNTSITM_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PCNTSRI_CNTSITM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PCNTSRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"REI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCNTSRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCNTItm">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PCNTSRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CNTITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCNTSRI_CNTSITM_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PCNTSRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCOMMENTSREITMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

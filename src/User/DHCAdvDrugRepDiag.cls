Class User.DHCAdvDrugRepDiag Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADVDRD_RowID, SqlTableName = DHC_AdvDrugRepDiag, StorageStrategy = NewStorage1 ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADVDRDChildSub [ IdKey, PrimaryKey, Unique ];

/// ADVDRDADRRParref Parent Reference ADVDRD_ADRR_Parref
Relationship ADVDRDADRRParref As User.DHCAdvDrugReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPDIAG, Required, SqlFieldName = ADVDRD_ADRR_Parref ];

/// ADVDRD_ChildSub
Property ADVDRDChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADVDRD_ChildSub ];

/// ADVDRD_ICDCode_DR 
Property ADVDRDICDCodeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADVDRD_ICDCode_DR ];

/// ADVDRD_Desc
Property ADVDRDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADVDRD_Desc ];

Storage NewStorage1
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADVDRD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADVDRD_ICDCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVDRUGDI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AdvDrugReport.ADVDR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADVDRD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AdvDrugReport.ADVDR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIAG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDRD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDrugRepDiagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

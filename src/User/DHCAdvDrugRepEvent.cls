Class User.DHCAdvDrugRepEvent Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADVDRE_RowID, SqlTableName = DHC_AdvDrugRepEvent, StorageStrategy = NewStorage1 ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADVDREChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCAdvDrugReport Parent Reference ADVDRE_ADRR_Parref
Relationship ADVDREADRRParref As User.DHCAdvDrugReport [ Cardinality = parent, Inverse = ChildDHCPHADVDREPEVENT, Required, SqlFieldName = ADVDRE_ADRR_Parref ];

/// ADVDRE_ChildSub
Property ADVDREChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADVDRE_ChildSub ];

/// ADVDRE_ADRE_DR 
Property ADVDREADREDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADVDRE_ADRE_DR ];

/// ADVDRE_Desc
Property ADVDREDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADVDRE_Desc ];

Storage NewStorage1
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADVDRE_ADRE_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVDRE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AdvDrugReport.ADVDR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADVDRE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AdvDrugReport.ADVDR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Event"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDRE_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEvent">
<Global>^DHCADVDRUGREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AdvDrugReport.ADVDR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ADVDRE_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DrugEvent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVDRE_ADRE_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AdvDrugReport.ADVDR_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVDRE_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDrugRepEventS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

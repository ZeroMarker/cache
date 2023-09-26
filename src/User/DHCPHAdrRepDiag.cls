Class User.DHCPHAdrRepDiag Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRD_RowID, SqlTableName = DHC_PHAdrRepDiag, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRRDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADRRD_ADRR_Parref
Relationship ADRRDADRRParref As User.DHCPHAdrReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPDIAG, Required, SqlFieldName = ADRRD_ADRR_Parref ];

/// ADRRD_ChildSub
Property ADRRDChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRRD_ChildSub ];

/// ADRRD_ICDCode_DR 
Property ADRRDDICDCodeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ADRRD_ICDCode_DR ];

/// ADRRD_Desc
Property ADRRDDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ADRRD_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRRD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRRD_ICDCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHADRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHAdrReport.ADRR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADRRD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrReport.ADRR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADRRD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRRD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrRepDiagS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCPHAdrRepAudit Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADRRA_RowID, SqlTableName = DHC_PHAdrRepAudit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ADRRAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHAdrReport Parent Reference ADRRA_ADRR_Parref
Relationship ADRRAADRRParref As User.DHCPHAdrReport [ Cardinality = parent, Inverse = ChildDHCPHADRREPAUDIT, Required, SqlFieldName = ADRRA_ADRR_Parref ];

/// ADRRA_ChildSub
Property ADRRAChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADRRA_ChildSub ];

/// ADRRA_Status_DR 
Property ADRRAStatusDR As User.DHCPHAdrStatus [ SqlColumnNumber = 3, SqlFieldName = ADRRA_Status_DR ];

/// ADRRA_AuditUser_DR
Property ADRRAAuditUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = ADRRA_AuditUser_DR ];

/// ADRRA_AuditDate
Property ADRRAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = ADRRA_AuditDate ];

/// ADRRA_AuditTime
Property ADRRAAuditTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = ADRRA_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADRRA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADRRA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADRRA_AuditUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADRRA_Status_DR">
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
<Field>ADRRA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PHAdrReport.ADRR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADRRA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADRRA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAdrRepAuditS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

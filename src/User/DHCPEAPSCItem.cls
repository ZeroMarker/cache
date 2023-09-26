Class User.DHCPEAPSCItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APSCI_RowID, SqlTableName = DHC_PE_APSCItem, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEAPSCItem";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APSCISub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_APStatusChange Parent Reference
Relationship APSCIParRef As User.DHCPEAPStatusChange [ Cardinality = parent, Inverse = ChildDHCPEAPSCItem, Required, SqlFieldName = APSCI_ParRef ];

/// APSCI_Sub
Property APSCISub As %Library.Float [ InitialExpression = {$i(^DHCPEAP(+%d(0),"SC",$p($p(%d(0),$c(1)),"||",2),"Item",0))}, SqlColumnNumber = 2, SqlFieldName = APSCI_Sub ];

/// APSCI_Status
Property APSCIStatus As %Library.String(DISPLAYLIST = ",New,Old,Delete", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,O,D") [ SqlColumnNumber = 3, SqlFieldName = APSCI_Status ];

/// APSCI_OrdEnt_DR
Property APSCIOrdEntDR As User.DHCPEAPSCOrdSets [ SqlColumnNumber = 4, SqlFieldName = APSCI_OrdEnt_DR ];

/// APSCI_ItmMast_DR
Property APSCIItmMastDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = APSCI_ItmMast_DR ];

/// APSCI_AddDate
Property APSCIAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = APSCI_AddDate ];

/// APSCI_AddTime
Property APSCIAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = APSCI_AddTime ];

/// APSCI_AddUser_DR
Property APSCIAddUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = APSCI_AddUser_DR ];

/// APSCI_UpdateDate
Property APSCIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = APSCI_UpdateDate ];

/// APSCI_UpdateTime
Property APSCIUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = APSCI_UpdateTime ];

/// APSCI_UpdateUser_DR
Property APSCIUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = APSCI_UpdateUser_DR ];

/// APSCI_Remark
Property APSCIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = APSCI_Remark ];

/// APSCI_1
Property APSCI1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = APSCI_1 ];

/// APSCI_2
Property APSCI2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = APSCI_2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APSCI_1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APSCI_2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APSCI_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APSCI_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APSCI_AddUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APSCI_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APSCI_OrdEnt_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APSCI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APSCI_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APSCI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APSCI_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="APSCI_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPEAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PE_APStatusChange.APSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>APSCI_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PE_APStatusChange.APSC_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APSCI_Sub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCID">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_PE_APStatusChange.APSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>APSCI_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APSCI_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_APStatusChange.APSC_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APSCI_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEAPSCItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

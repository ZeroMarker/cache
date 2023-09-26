Class User.DHCPEAsChargedOrder Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACO_RowId, SqlTableName = DHC_PE_AsChargedOrder, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEAsChargedOrder";

Parameter EXTENTSIZE = 250;

/// ACO_ARPBL_DR
Property ACOARPBLDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ACO_ARPBL_DR ];

/// ACO_AddOrdItem
Property ACOAddOrdItem As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ACO_AddOrdItem ];

/// ACO_BillStatus
Property ACOBillStatus As %Library.String(DISPLAYLIST = ",On Credit,Paid", MAXLEN = 9, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",O,P") [ SqlColumnNumber = 4, SqlFieldName = ACO_BillStatus ];

/// ACO_DischargedMode
Property ACODischargedMode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ACO_DischargedMode ];

/// ACO_OEORI_DR
Property ACOOEORIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ACO_OEORI_DR ];

/// ACO_PAADM_DR
Property ACOPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ACO_PAADM_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEACO)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEACO">
<Data name="ACO_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACO_AddOrdItem">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACO_BillStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACO_DischargedMode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACO_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACO_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPEACO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ACO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARPBL">
<Global>^DHCPEACO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARPBL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ACO_ARPBL_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ACO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCPEACO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ACO_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ACO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPEACO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACO_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ACO_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ACO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEAsChargedOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

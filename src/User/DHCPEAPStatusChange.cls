Class User.DHCPEAPStatusChange Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APSC_RowID, SqlTableName = DHC_PE_APStatusChange, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEAPStatusChange";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APSCChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPEAPSCItem As User.DHCPEAPSCItem [ Cardinality = children, Inverse = APSCIParRef ];

Relationship ChildDHCPEAPSCOrdSets As User.DHCPEAPSCOrdSets [ Cardinality = children, Inverse = APSCOParRef ];

/// DHC_PE_AdvancePayment Parent Reference
Relationship APSCParRef As User.DHCPEAdvancePayment [ Cardinality = parent, Inverse = ChildDHCPEAPStatusChange, Required, SqlFieldName = APSC_ParRef ];

/// APSC_ChildSub
Property APSCChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEAP($p(%d(0),$c(1),1),"SC",0))}, SqlColumnNumber = 2, SqlFieldName = APSC_ChildSub ];

/// APSC_Status
Property APSCStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = APSC_Status ];

/// APSC_UpdateDate
Property APSCUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = APSC_UpdateDate ];

/// APSC_UpdateTime
Property APSCUpdateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = APSC_UpdateTime ];

/// APSC_UpdateUser_DR
Property APSCUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = APSC_UpdateUser_DR ];

/// APSC_Remark
Property APSCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = APSC_Remark ];

/// APSC_1
Property APSC1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = APSC_1 ];

/// APSC_2
Property APSC2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = APSC_2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APSC_1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APSC_2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APSC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APSC_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APSC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APSC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APSC_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPEAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>APSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APSC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSCDate">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>APSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APSC_UpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCPEAP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_AdvancePayment.AP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>APSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{APSC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEAPStatusChangeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

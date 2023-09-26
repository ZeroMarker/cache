Class User.DHCPEAPSCOrdSets Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APSCO_RowID, SqlTableName = DHC_PE_APSCOrdSets, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEAPSCOrdSets";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On APSCOChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_APStatusChange Parent Reference
Relationship APSCOParRef As User.DHCPEAPStatusChange [ Cardinality = parent, Inverse = ChildDHCPEAPSCOrdSets, Required, SqlFieldName = APSCO_ParRef ];

/// APSCO_ChildSub
Property APSCOChildSub As %Library.Float [ InitialExpression = {$i(^DHCPEAP(+%d(0),"SC",$p($p(%d(0),$c(1)),"||",2),"OrdSets",0))}, SqlColumnNumber = 2, SqlFieldName = APSCO_ChildSub ];

/// APSCO_Status
Property APSCOStatus As %Library.String(DISPLAYLIST = ",New,Old,Delete", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,O,D") [ SqlColumnNumber = 3, SqlFieldName = APSCO_Status ];

/// APSCO_OrdSets_DR
Property APSCOOrdSetsDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = APSCO_OrdSets_DR ];

/// APSCO_AddDate
Property APSCOAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = APSCO_AddDate ];

/// APSCO_AddTime
Property APSCOAddTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = APSCO_AddTime ];

/// APSCO_AddUser_DR
Property APSCOAddUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = APSCO_AddUser_DR ];

/// APSCO_UpdateDate
Property APSCOUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = APSCO_UpdateDate ];

/// APSCO_UpdateTime
Property APSCOUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = APSCO_UpdateTime ];

/// APSCO_UpdateUser_DR
Property APSCOUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = APSCO_UpdateUser_DR ];

/// APSCO_Remark
Property APSCORemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = APSCO_Remark ];

/// APSCO_1
Property APSCO1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = APSCO_1 ];

/// APSCO_2
Property APSCO2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = APSCO_2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APSCO_1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APSCO_2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APSCO_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APSCO_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APSCO_AddUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APSCO_OrdSets_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APSCO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APSCO_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APSCO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APSCO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APSCO_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
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
<Field>APSCO_ChildSub</Field>
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
<Expression>"OrdSets"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{APSCO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdSets">
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
<Field>APSCO_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdSets"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APSCO_OrdSets_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PE_AdvancePayment.AP_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PE_APStatusChange.APSC_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{APSCO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEAPSCOrdSetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

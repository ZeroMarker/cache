Class User.DHCPESSResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSR_RowId, SqlTableName = DHC_PE_SSResult, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPESSResult";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SSRChildSub [ IdKey, PrimaryKey, Unique ];

/// SSR_ChildSub
Property SSRChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPESS($p(%d(0),$c(1),1),"Result",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SSR_ChildSub ];

/// DHC_PE_StationSummarize Parent Reference
Relationship SSRParRef As User.DHCPEStationSummarize [ Cardinality = parent, Inverse = ChildDHCPESSResult, Required, SqlFieldName = SSR_ParRef ];

/// SSR_RLT_DR
Property SSRRLTDR As User.DHCPEResult [ SqlColumnNumber = 3, SqlFieldName = SSR_RLT_DR ];

/// SSR_Remark
Property SSRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSR_Remark ];

/// SSR_Submit
Property SSRSubmit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SSR_Submit ];

/// SSR_UpdateDate
Property SSRUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = SSR_UpdateDate ];

/// SSR_UpdateTime
Property SSRUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = SSR_UpdateTime ];

/// SSR_UpdateUser_DR
Property SSRUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SSR_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPESS">
<Data name="SSR_RLT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSR_Submit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPESS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_StationSummarize.SS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SSR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_StationSummarize.SS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Result"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SSR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRLT">
<Global>^DHCPESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_StationSummarize.SS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RLT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SSR_RLT_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_StationSummarize.SS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESSResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

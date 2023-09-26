Class User.DHCPEGSResult Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GSR_RowId, SqlTableName = DHC_PE_GSResult, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEGSResult";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On GSRChildSub [ IdKey, PrimaryKey, Unique ];

/// GSR_ChildSub
Property GSRChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEGS($p(%d(0),$c(1),1),"Result",0))}, Required, SqlColumnNumber = 2, SqlFieldName = GSR_ChildSub ];

/// DHC_PE_GeneralSummarize Parent Reference
Relationship GSRParRef As User.DHCPEGeneralSummarize [ Cardinality = parent, Inverse = ChildDHCPEGSResult, Required, SqlFieldName = GSR_ParRef ];

/// GSR_Remark
Property GSRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GSR_Remark ];

/// GSR_SSPrint
Property GSRSSPrint As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = GSR_SSPrint ];

/// GSR_SSR_DR
Property GSRSSRDR As User.DHCPESSResult [ SqlColumnNumber = 3, SqlFieldName = GSR_SSR_DR ];

/// GSR_UpdateDate
Property GSRUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = GSR_UpdateDate ];

/// GSR_UpdateTime
Property GSRUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = GSR_UpdateTime ];

/// GSR_UpdateUser_DR
Property GSRUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = GSR_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPEGS">
<Data name="GSR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GSR_SSPrint">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GSR_SSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GSR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GSR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GSR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPEGS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_GeneralSummarize.GS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>GSR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralSummarize.GS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Result"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GSR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSSR">
<Global>^DHCPEGS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_GeneralSummarize.GS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>GSR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SSRDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{GSR_SSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_GeneralSummarize.GS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{GSR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEGSResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCPESSDiagnosis Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSD_RowId, SqlTableName = DHC_PE_SSDiagnosis, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPESSDiagnosis";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SSDChildSub [ IdKey, PrimaryKey, Unique ];

/// SSD_Advice
Property SSDAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SSD_Advice ];

/// SSD_ChildSub
Property SSDChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPESS($p(%d(0),$c(1),1),"Diagnosis",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SSD_ChildSub ];

/// SSD_DiagnoseConclusion
Property SSDDiagnoseConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSD_DiagnoseConclusion ];

/// SSD_ED_DR
Property SSDEDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 3, SqlFieldName = SSD_ED_DR ];

/// DHC_PE_StationSummarize Parent Reference
Relationship SSDParRef As User.DHCPEStationSummarize [ Cardinality = parent, Inverse = ChildDHCPESSDiagnosis, Required, SqlFieldName = SSD_ParRef ];

/// SSD_Submit
Property SSDSubmit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SSD_Submit ];

/// SSD_UpdateDate
Property SSDUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = SSD_UpdateDate ];

/// SSD_UpdateTime
Property SSDUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = SSD_UpdateTime ];

/// SSD_UpdateUser_DR
Property SSDUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SSD_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCPESS">
<Data name="SSD_Advice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSD_DiagnoseConclusion">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSD_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSD_Submit">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSD_UpdateUser_DR">
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
<Field>SSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_StationSummarize.SS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Diagnosis"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SSD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexED">
<Global>^DHCPESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PE_StationSummarize.SS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SSD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SSD_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_StationSummarize.SS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESSDiagnosisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

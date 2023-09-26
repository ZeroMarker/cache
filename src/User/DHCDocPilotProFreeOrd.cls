Class User.DHCDocPilotProFreeOrd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPF_RowId, SqlTableName = DHC_DocPilotProFreeOrd, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPFChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PPFPPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProFreeOrd, Required, SqlFieldName = PPF_PPP_ParRef ];

Relationship ChildDHCDocPilotProFreeOrdLog As User.DHCDocPilotProFreeOrdLog [ Cardinality = children, Inverse = PPFLPPParRef ];

/// PPF_ChildSub
Property PPFChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPF(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPF_ChildSub ];

/// PPF_SttDate
Property PPFSttDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PPF_SttDate ];

/// PPF_SttTime
Property PPFSttTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PPF_SttTime ];

/// PPF_EndDate
Property PPFEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PPF_EndDate ];

/// PPF_EndTime
Property PPFEndTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PPF_EndTime ];

Property PPFItmMastDR As ARCItmMast [ Required, SqlColumnNumber = 7, SqlFieldName = PPF_ItmMastDR ];

Property PPFFreeNum As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PPF_FreeNum ];

Property PPFLimitEntryAfterNoFreeNum As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PPF_LimitEntryAfterNoFreeNum ];

Property PPFPrjStage As User.DHCDocPilotProStage [ SqlColumnNumber = 10, SqlFieldName = PPF_PrjStage ];

/// PPF_AddTime
Property PPFAddTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PPF_AddTime ];

/// PPF_AddDate
Property PPFAddDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = PPF_AddDate ];

/// PPF_AddUser
Property PPFAddUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PPF_AddUser ];

/// PPF_AddLoc
Property PPFAddLoc As User.CTLoc [ SqlColumnNumber = 14, SqlFieldName = PPF_AddLoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPF_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPF_AddLoc">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPF_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPF_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PPF_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPF_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPF_FreeNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPF_ItmMastDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPF_LimitEntryAfterNoFreeNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPF_PrjStage">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPF_SttDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPF_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDocPPF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPF_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPF_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxPrjStageArcim">
<Global>^DHCDocPPF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PPF_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrjStageArcim"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPF_PrjStage}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPF_ItmMastDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PPF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArcim">
<Global>^DHCDocPPF</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPF_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPF_ItmMastDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPF_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProFreeOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

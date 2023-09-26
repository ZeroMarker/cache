Class User.DHCInPhReqItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHRI_RowID, SqlTableName = DHC_InPhReqItm, StorageStrategy = SQLStorage ]
{

/// d ##Class(User.DHCInPhReqItm).%BuildIndices()
Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHRIChildSub [ IdKey, PrimaryKey, Unique ];

/// User.DHCInPhReqItm Parent Reference
Relationship PHRIPHRParref As User.DHCInPhReq [ Cardinality = parent, Inverse = ChildDHCInPhReqItm, Required, SqlFieldName = PHRI_PHR_Parref ];

/// PHRI_ChildSub
Property PHRIChildSub As %Library.Float [ InitialExpression = {$i(^DHCINPHREQ($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PHRI_ChildSub ];

/// PHRI_Dsp_Dr
Property PHRIDspDr As User.DHCOEDispensing [ SqlColumnNumber = 3, SqlFieldName = PHRI_Dsp_Dr ];

/// 请领单状态
Property PHRIStatus As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHRI_Status ];

/// 撤销人
Property PHRICancelUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PHRI_CancelUser_Dr ];

/// 撤销日期
Property PHRICancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PHRI_CancelDate ];

/// 撤销时间
Property PHRICancelTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PHRI_CancelTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHRI_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHRI_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHRI_CancelUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHRI_Dsp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHRI_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCINPHREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InPhReq.PHR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_InPhReq.PHR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHRI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDsp">
<Global>^DHCINPHREQi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_InPhReq.PHR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DSP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHRI_Dsp_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_InPhReq.PHR_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInPhReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

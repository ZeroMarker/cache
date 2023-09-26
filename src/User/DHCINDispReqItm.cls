Class User.DHCINDispReqItm Extends %Persistent [ ClassType = persistent, SqlRowIdName = DSRQI_RowId, SqlTableName = DHC_INDispReqItm, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On DSRQIChildSub [ IdKey, PrimaryKey, Unique ];

/// DSRQI_DSRQ_ParRef
Relationship DSRQIDSRQParRef As User.DHCINDispReq [ Cardinality = parent, Inverse = ChildDHCINDispReqItm, Required, SqlFieldName = DSRQI_DSRQ_ParRef ];

/// DSRQI_ChildSub
Property DSRQIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCINDSREQ($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = DSRQI_ChildSub ];

/// DSRQI_INCI_DR
Property DSRQIINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = DSRQI_INCI_DR ];

/// DSRQI_Qty
Property DSRQIQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DSRQI_Qty ];

/// DSRQI_CTUOM_DR
Property DSRQICTUOMDR As User.CTUOM [ SqlColumnNumber = 5, SqlFieldName = DSRQI_CTUOM_DR ];

/// DSRQI_Remark
Property DSRQIRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DSRQI_Remark ];

/// DSRQI_MoveStatus
Property DSRQIMoveStatus As %String(DISPLAYLIST = ",Ready,Disp,Cancel,Reject", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",G,D,X,R") [ InitialExpression = "G", SqlColumnNumber = 7, SqlFieldName = DSRQI_MoveStatus ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterDispReqItm">
<Data name="DSRQI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSRQI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSRQI_MoveStatus">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSRQI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSRQI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINDSREQ</Global>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_INDispReq.DSRQ_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSRQI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInci">
<Global>^DHCINDSREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INDispReq.DSRQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DSRQI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSRQI_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_INDispReq.DSRQ_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DSRQI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINDispReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

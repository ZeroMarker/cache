Class User.DHCINDispReq Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_INDispReq, StorageStrategy = SqlStorage ]
{

Relationship ChildDHCINDispReqItm As User.DHCINDispReqItm [ Cardinality = children, Inverse = DSRQIDSRQParRef ];

/// DSRQ_No
Property DSRQNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSRQ_No ];

/// DSRQ_DispLoc_DR
Property DSRQDispLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = DSRQ_DispLoc_DR ];

/// DSRQ_SCG_DR
Property DSRQSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 4, SqlFieldName = DSRQ_SCG_DR ];

/// DSRQ_Date
Property DSRQDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DSRQ_Date ];

/// DSRQ_Time
Property DSRQTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DSRQ_Time ];

/// DSRQ_SSUSR_DR
Property DSRQSSUSRDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DSRQ_SSUSR_DR ];

/// DSRQ_ReqMode - 1:按人请领 0:按组请领
Property DSRQReqMode As %String [ SqlColumnNumber = 8, SqlFieldName = DSRQ_ReqMode ];

/// DSRQ_ReqUserGrp_DR
Property DSRQReqUserGrpDR As User.DHCSubLocUserGroup [ SqlColumnNumber = 9, SqlFieldName = DSRQ_ReqUserGrp_DR ];

/// DSRQ_ReqUser_DR
Property DSRQReqUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DSRQ_ReqUser_DR ];

/// DSRQ_Complete
Property DSRQComplete As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DSRQ_Complete ];

/// Status (C)lose,(O)pen,(X)cancel,(R)eject
Property DSRQStatus As %String(DISPLAYLIST = ",Close,Open,Cancel,Reject", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",C,O,X,R") [ InitialExpression = "O", SqlColumnNumber = 12, SqlFieldName = DSRQ_Status ];

/// DSRQ_Remark
Property DSRQRemark As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DSRQ_Remark ];

/// 模板标志
Property DSRQTemplate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DSRQ_Template ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINDSREQ)</SqlIdExpression>
<SQLMap name="DataMasterDispReq">
<Data name="DSRQ_Complete">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DSRQ_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSRQ_DispLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSRQ_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSRQ_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DSRQ_ReqMode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSRQ_ReqUserGrp_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSRQ_ReqUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSRQ_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSRQ_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSRQ_Status">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSRQ_Template">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DSRQ_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCINDSREQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCINDSREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATELOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_DispLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTemplate">
<Global>^DHCINDSREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LocTemplate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_DispLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_Template}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DSRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCINDSREQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({DSRQ_No})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DSRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSRQ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINDispReqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINDSREQ)
	s oldI = +$g(^mdata("DHCINDISPREQ"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINDSREQ = maxI
	s ^mdata("DHCINDISPREQ") = maxI
}

}

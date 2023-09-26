Class User.DHCInDispRet Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSR_RowId, SqlTableName = DHC_InDispRet, StorageStrategy = NewSqlStorage ]
{

Relationship ChildDHCInDispRetItm As User.DHCInDispRetItm [ Cardinality = children, Inverse = DSRIDSRParRef ];

/// DSR_No
Property DSRNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DSR_No ];

/// DSR_Date
Property DSRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DSR_Date ];

/// DSR_Time
Property DSRTime As %Time [ SqlColumnNumber = 4, SqlFieldName = DSR_Time ];

/// DSR_SSUSR_DR
Property DSRSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DSR_SSUSR_DR ];

/// DSR_Completed
Property DSRCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DSR_Completed ];

/// DSR_AckFlag
Property DSRAckFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DSR_AckFlag ];

/// DSR_AckDate
Property DSRAckDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DSR_AckDate ];

/// DSR_AckTime 
Property DSRAckTime As %Time [ SqlColumnNumber = 9, SqlFieldName = DSR_AckTime ];

/// DSR_AckUser_Dr
Property DSRAckUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DSR_AckUser_Dr ];

/// DSR_SCG_DR
Property DSRSCGDR As User.DHCStkCatGroup [ SqlColumnNumber = 11, SqlFieldName = DSR_SCG_DR ];

/// DSR_StkType
Property DSRStkType As %String(DISPLAYLIST = ",Drug,Material,Others", MAXLEN = 8, SELECTIVITY = "25.0000%", VALUELIST = ",G,M,O") [ SqlColumnNumber = 12, SqlFieldName = DSR_StkType ];

///  DSR_Remark
Property DSRRemark As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DSR_Remark ];

///  DSR_CTLOC_DR
Property DSRCTLOCDR As User.CTLoc [ SqlColumnNumber = 14, SqlFieldName = DSR_CTLOC_DR ];

/// DSR_Status 状态
Property DSRStatus As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DSR_Status ];

/// DSR_RetLOC_DR(退回单接收科室,协和)
Property DSRRetLOCDR As User.CTLoc [ SqlColumnNumber = 16, SqlFieldName = DSR_RetLOC_DR ];

Storage NewSqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCINDSR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSR_AckDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSR_AckFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSR_AckTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSR_AckUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DSR_Completed">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DSR_RetLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DSR_SCG_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSR_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DSR_StkType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DSR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCINDSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DSR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINDSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^DHCINDSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DSR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"LOCDATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DSR_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCINDSR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({DSR_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DSR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DSR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCInDispRetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCINDSR)
	s oldI = +$g(^mdata("DHCInDispRet"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCINDSR = maxI
	s ^mdata("DHCInDispRet") = maxI
}

}

Class User.DHCSTPHADOCReq Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PDRQ_RowId, SqlTableName = DHCST_PHADOCReq, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCSTPHADOCReqItm As User.DHCSTPHADOCReqItm [ Cardinality = children, Inverse = PDRQIPDRQParRef ];

/// Request Reference Number
Property PDRQNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ InitialExpression = "0", Required, SqlColumnNumber = 2, SqlFieldName = PDRQ_No ];

/// Des Ref to CTLOC
Property PDRQRecLocDR As CTLoc [ Required, SqlColumnNumber = 3, SqlFieldName = PDRQ_RecLoc_DR ];

/// Des Ref to CTLOC
Property PDRQReqLocDR As CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = PDRQ_ReqLoc_DR ];

/// Des Ref to SSUSR
Property PDRQSSUSRDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = PDRQ_SSUSR_DR ];

/// Date When Request Made
Property PDRQDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PDRQ_Date ];

/// Request Time
Property PDRQTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PDRQ_Time ];

/// Completed Flag
Property PDRQCompleted As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PDRQ_Completed ];

/// Date When Request End
Property PDRQEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PDRQ_EndDate ];

/// Request End Time
Property PDRQEndTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PDRQ_EndTime ];

/// PDRQ_Type
Property PDRQParType As %Library.String(DISPLAYLIST = ",Parent,Child", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",P,C") [ SqlColumnNumber = 11, SqlFieldName = PDRQ_ParType ];

/// PDRQ_RelPdrq
Property PDRQRelPdrq As User.DHCSTPHADOCReq [ SqlColumnNumber = 12, SqlFieldName = PDRQ_RelPdrq ];

/// PDRQ_TempFlag
Property PDRQTempFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PDRQ_TempFlag ];

/// PDRQ_Hosp_DR
Property PDRQHospDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = PDRQ_Hosp_DR ];

/// PDRQ_State (10-医嘱数计算完成,20-最终完成)
Property PDRQState As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 15, SqlFieldName = PDRQ_State ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCSTPDRQ(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PDRQ_Completed">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDRQ_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDRQ_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDRQ_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDRQ_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PDRQ_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDRQ_ParType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDRQ_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDRQ_RelPdrq">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDRQ_ReqLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDRQ_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDRQ_State">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PDRQ_TempFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PDRQ_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSTPDRQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PDRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PDRQ_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPDRQDate">
<Global>^DHCSTPDRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDRQ_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDRQNo">
<Global>^DHCSTPDRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PDRQ_No})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDRQRecLocDR">
<Global>^DHCSTPDRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDRQ_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDRQReqLocDR">
<Global>^DHCSTPDRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PDRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReqLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDRQ_ReqLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPDRQReqRecUser">
<Global>^DHCSTPDRQ</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PDRQ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReqRecUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDRQ_ReqLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDRQ_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PDRQ_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PDRQ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDRQ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSTPHADOCReqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

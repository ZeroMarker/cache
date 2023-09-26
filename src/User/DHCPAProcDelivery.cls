/// DHC_PA_ProcDelivery
Class User.DHCPAProcDelivery Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROCD_RowId, SqlTableName = DHC_PA_ProcDelivery, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PROCD_Adm_DR
Property PROCDAdmDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PROCD_Adm_DR ];

/// PROCD_EndDate
Property PROCDEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PROCD_EndDate ];

/// PROCD_EndTime
Property PROCDEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PROCD_EndTime ];

/// PROCD_LaborDate
Property PROCDLaborDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PROCD_LaborDate ];

/// PROCD_LaborTime
Property PROCDLaborTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PROCD_LaborTime ];

/// PROCD_StartDate
Property PROCDStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PROCD_StartDate ];

/// PROCD_StartTime
Property PROCDStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PROCD_StartTime ];

/// PROCD_Status
Property PROCDStatus As %Library.String(DISPLAYLIST = ",Labor,Delivery,Recovery,Cancel", MAXLEN = 8, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",L,D,R,C") [ SqlColumnNumber = 3, SqlFieldName = PROCD_Status ];

/// PROCD_UpdateDate
Property PROCDUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PROCD_UpdateDate ];

/// PROCD_UpdateTime
Property PROCDUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PROCD_UpdateTime ];

/// PROCD_UpdateUser_DR
Property PROCDUpdateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PROCD_UpdateUser_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPregDel(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PROCD_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROCD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PROCD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PROCD_LaborDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROCD_LaborTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PROCD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PROCD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PROCD_Status">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROCD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PROCD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PROCD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPregDel</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PROCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PROCD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLaborDate">
<Global>^DHCPregDel</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PROCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROCD_LaborDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadmDr">
<Global>^DHCPregDel</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PROCD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROCD_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROCD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcDeliveryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.PIVABatTime Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PBT_RowID, SqlTableName = PIVA_BatTime, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PBT_TimeFrom
Property PBTTimeFrom As %Library.Time [ SqlColumnNumber = 2, SqlFieldName = PBT_TimeFrom ];

/// PBT_TimeTo
Property PBTTimeTo As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = PBT_TimeTo ];

/// PBT_BatNo
Property PBTBatNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PBT_BatNo ];

/// PBT_Ctloc_Dr
Property PBTCtlocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PBT_Ctloc_Dr ];

/// PBT_SeqFlag
Property PBTSeqFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = PBT_SeqFlag ];

/// PBT_Ward_Dr
Property PBTWardDr As User.PACWard [ SqlColumnNumber = 7, SqlFieldName = PBT_Ward_Dr ];

/// PBT_PYTime
Property PBTPYTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PBT_PYTime ];

/// PBTPriorityDr
Property PBTPriorityDr As OECPriority [ SqlColumnNumber = 9, SqlFieldName = PBT_Priority_Dr ];

/// PBT_Remark
Property PBTRemark As %String [ SqlColumnNumber = 10, SqlFieldName = PBT_Remark ];

/// PBT_AutoPack
Property PBTAutoPack As %String [ SqlColumnNumber = 11, SqlFieldName = PBT_AutoPack ];

/// PBT_InterTime
Property PBTInterTime As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PBT_InterTime ];

/// PBT_LabelNum
Property PBTLabelNum As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PBT_LabelNum ];

/// PBTADMType
Property PBTADMType As %String(DISPLAYLIST = ",In Patient,Out Patient", MAXLEN = 16, TRUNCATE = 0, VALUELIST = ",I,O") [ SqlColumnNumber = 14, SqlFieldName = PBT_ADMType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVABT)</SqlIdExpression>
<SQLMap name="DataMasterPIVABatTime">
<Data name="PBT_ADMType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PBT_AutoPack">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PBT_BatNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PBT_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PBT_InterTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PBT_LabelNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PBT_PYTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PBT_Priority_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PBT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PBT_SeqFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PBT_TimeFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PBT_TimeTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PBT_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PIVABT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PBT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PBT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBatNo">
<Global>^PIVABT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PBT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BatNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBT_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBT_BatNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTime">
<Global>^PIVABT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PBT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TIME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PBT_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PBT_TimeFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PBT_TimeTo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PBT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVABatTimeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// DHC_PA_Process
Class User.DHCPAProcess Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PROC_RowId, SqlTableName = DHC_PA_Process, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPAProcAdm As User.DHCPAProcAdm [ Cardinality = children, Inverse = PROCAParref ];

Relationship ChildDHCPAProcBooking As User.DHCPAProcBooking [ Cardinality = children, Inverse = PROCBParref ];

Relationship ChildDHCPAProcEPR As User.DHCPAProcEPR [ Cardinality = children, Inverse = PROCEParref ];

/// PROC_Papmi_DR
Property PROCPapmiDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PROC_Papmi_DR ];

/// PROC_Type_DR
Property PROCTypeDR As User.DHCPAProcCodeType [ SqlColumnNumber = 3, SqlFieldName = PROC_Type_DR ];

/// PROC_Status
Property PROCStatus As %Library.String(DISPLAYLIST = ",Complete,Open,Cancelled", MAXLEN = 9, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",C,O,X") [ SqlColumnNumber = 4, SqlFieldName = PROC_Status ];

/// PROC_No
Property PROCNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PROC_No ];

/// PROC_CreateDate
Property PROCCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PROC_CreateDate ];

/// PROC_CreateTime
Property PROCCreateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PROC_CreateTime ];

/// PROC_CreateUser_DR
Property PROCCreateUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PROC_CreateUser_DR ];

/// last normal menstrual period
Property PROCLnmp As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PROC_Lnmp ];

/// PROC_PrePregWeight
Property PROCPrePregWeight As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PROC_PrePregWeight ];

/// PROC_HighRisk
Property PROCHighRisk As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = PROC_HighRisk ];

/// PROC_HBVDNA
Property PROCHBVDNA As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PROC_HBVDNA ];

/// PROC_HCG
Property PROCHCG As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PROC_HCG ];

/// PROC_BloodType
Property PROCBloodType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PROC_BloodType ];

/// PROC_CityArea_Dr
Property PROCCityAreaDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PROC_CityArea_Dr ];

/// PROC_Phone
Property PROCPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PROC_Phone ];

/// PROC_LnmpEditReason
Property PROCLnmpEditReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PROC_LnmpEditReason ];

/// PROC_HRMainReason_Dr
Property PROCHRMainReasonDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PROC_HRMainReason_Dr ];

/// PROC_HRSecondReason_Dr
Property PROCHRSecondReasonDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PROC_HRSecondReason_Dr ];

/// PROC_lnmpEditReason_Dr
Property PROClnmpEditReasonDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PROC_lnmpEditReason_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCProc(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Data name="PROC_BloodType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PROC_CityArea_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PROC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PROC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PROC_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PROC_HBVDNA">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PROC_HCG">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PROC_HRMainReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PROC_HRSecondReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PROC_HighRisk">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PROC_Lnmp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PROC_LnmpEditReason">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PROC_No">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PROC_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROC_Phone">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PROC_PrePregWeight">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PROC_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PROC_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROC_lnmpEditReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^DHCProc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PROC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PROC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCProc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PROC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PROC_Papmi_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPAProcessS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

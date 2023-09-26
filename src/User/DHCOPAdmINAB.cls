Class User.DHCOPAdmINAB Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCOPAdm_INAB, StorageStrategy = SQLStorage ]
{

/// 病人ID INAB_Patient_Dr 
Property INABPatientDr As PAPatMas [ Required, SqlColumnNumber = 2, SqlFieldName = INAB_Patient_Dr ];

/// 病人就诊ID INAB_PAADM_Dr 
Property INABPAADMDr As PAAdm [ Required, SqlColumnNumber = 3, SqlFieldName = INAB_PAADM_Dr ];

/// 医保指针 INAB_ADMRowid
Property INABADMRowid As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = INAB_ADMRowid ];

/// 操作人 INAB_UserDr
Property INABUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = INAB_UserDr ];

/// 产生日期 INAB_Date
Property INABDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = INAB_Date ];

/// 产生时间 INAB_Time
Property INABTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = INAB_Time ];

/// 处理人 INAB_DealUserDr
Property INABDealUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = INAB_DealUserDr ];

/// 处理日期 INAB_DealDate
Property INABDealDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = INAB_DealDate ];

/// 处理时间 INAB_DealTime
Property INABDealTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = INAB_DealTime ];

/// 订单状态 INAB_RecptStatus
Property INABRecptStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = INAB_RecptStatus ];

/// 退号科室 INAB_DepDr
Property INABDepDr As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = INAB_DepDr ];

/// 退号医生 INAB_DocDr
Property INABDocDr As User.CTCareProv [ SqlColumnNumber = 13, SqlFieldName = INAB_DocDr ];

/// 排班ID INAB_ASRowId
Property INABASRowId As User.RBApptSchedule [ SqlColumnNumber = 14, SqlFieldName = INAB_ASRowId ];

/// 来自挂号业务 INAB_ComeFrom
Property INABComeFrom As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = INAB_ComeFrom ];

/// 优惠类型
Property INABAdmReasonDR As PACAdmReason [ SqlColumnNumber = 16, SqlFieldName = INAB_AdmReason_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCOPAdmINAB(0))</SqlIdExpression>
<SQLMap name="DataMasterINAB">
<Data name="INAB_ADMRowid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INAB_ASRowId">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INAB_AdmReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INAB_ComeFrom">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INAB_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INAB_DealDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INAB_DealTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INAB_DealUserDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INAB_DepDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INAB_DocDr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INAB_PAADM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INAB_Patient_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INAB_RecptStatus">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INAB_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INAB_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INAB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INAB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INAB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatientDr">
<Global>^INABi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INAB_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatientDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({INAB_Patient_Dr})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INAB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INAB_RowID</SqlRowIdName>
<StreamLocation>^User.DHCOPAdmINABS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

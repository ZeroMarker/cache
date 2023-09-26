/// 门诊配液系统-配液申请
Class User.PIVADispRequest Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PIVADIS_Rowid, SqlTableName = PIVA_DispRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PIVADIS_OEORI_DR 
Property PIVADISOEORIDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = PIVADIS_OEORI_DR ];

/// PIVADIS_DODIS_Dr
Property PIVADISDODISDr As User.DHCOEDispensing [ SqlColumnNumber = 3, SqlFieldName = PIVADIS_DODIS_Dr ];

/// PIVADIS_PackFlag  打包标志
Property PIVADISPackFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PIVADIS_PackFlag ];

/// PIVADIS_Date  申请日期
Property PIVADISDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PIVADIS_Date ];

/// PIVADIS_Time  申请时间
Property PIVADISTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PIVADIS_Time ];

/// PIVADIS_User_Dr  申请人
Property PIVADISUserDr As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PIVADIS_User_Dr ];

/// PIVADIS_OpStatus 操作状态
Property PIVADISOpStatus As %Library.String(DISPLAYLIST = ",RECEIVE,REFUSE", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",REC,REF") [ SqlColumnNumber = 8, SqlFieldName = PIVADIS_OpStatus ];

/// PIVADIS_OpUser_Dr  操作人
Property PIVADISOpUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PIVADIS_OpUser_Dr ];

/// PIVADIS_OpDate  操作日期
Property PIVADISOpDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PIVADIS_OpDate ];

/// PIVADIS_OpTime  操作时间
Property PIVADISOpTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PIVADIS_OpTime ];

/// PIVADIS_RecLoc_Dr  接收科室
Property PIVADISRecLocDr As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = PIVADIS_RecLoc_Dr ];

/// PIVADIS_CStatus 撤销状态
Property PIVADISCStatus As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PIVADIS_CStatus ];

/// PIVADIS_CUser_Dr 撤销操作人
Property PIVADISCUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PIVADIS_CUser_Dr ];

/// PIVADIS_CDate  撤销操作日期
Property PIVADISCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = PIVADIS_CDate ];

/// PIVADIS_CTime  撤销操作时间
Property PIVADISCTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = PIVADIS_CTime ];

/// PIVADIS_RefRemark  拒绝接收备注
Property PIVADISRefRemark As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PIVADIS_RefRemark ];

/// PIVADIS_ReqRemark  再次申请备注  
Property PIVADISReqRemark As %Library.String [ SqlColumnNumber = 18, SqlFieldName = PIVADIS_ReqRemark ];

/// PIVADIS_PatNum   患者顺序号
Property PIVADISPatSerial As %Library.String [ SqlColumnNumber = 19, SqlFieldName = PIVADIS_PatSerial ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^PIVADIS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PIVADIS_CDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PIVADIS_CStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIVADIS_CTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PIVADIS_CUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PIVADIS_DODIS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIVADIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIVADIS_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIVADIS_OpDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIVADIS_OpStatus">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PIVADIS_OpTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIVADIS_OpUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIVADIS_PackFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIVADIS_PatSerial">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PIVADIS_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIVADIS_RefRemark">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PIVADIS_ReqRemark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PIVADIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIVADIS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PIVADIS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVADIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVADIS_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PIVADIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>"L2"</Expression>
<Field>{PIVADIS_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVADIS_RecLoc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVADIS_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PIVADIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDodis">
<Global>^PIVADIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>"L3"</Expression>
<Field>{PIVADIS_Rowid}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DODIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVADIS_DODIS_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIVADIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVADispRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^PIVADIS)
	s oldI = +$g(^mdata("PIVADispRequest"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^PIVADIS = maxI
	s ^mdata("PIVADispRequest") = maxI
}

}

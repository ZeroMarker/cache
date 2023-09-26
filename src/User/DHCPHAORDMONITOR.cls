Class User.DHCPHAORDMONITOR Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHAOM_ROWID, SqlTableName = DHC_PHAORDMONITOR, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHAORDMONITORLIST As User.DHCPHAORDMONITORLIST [ Cardinality = children, Inverse = PCTLPHAOMParRef ];

/// PHAOM_User_Dr  操作人
Property PHAOMUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PHAOM_User_Dr ];

/// PHAOM_Result  结果(合格、不合格)
Property PHAOMResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHAOM_Result ];

/// PHAOM_Date  日期
Property PHAOMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PHAOM_Date ];

/// PHAOM_TIME  时间
Property PHAOMTIME As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PHAOM_TIME ];

/// PHAOM_Loc_Dr  接收科室
Property PHAOMLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PHAOM_Loc_Dr ];

/// PHAOM_PhNote  药师备注
Property PHAOMPhNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHAOM_PhNote ];

/// PHAOM_DocNote  医师备注
Property PHAOMDocNote As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHAOM_DocNote ];

/// PHAOM_AgreeFlag  同意标志
Property PHAOMAgreeFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PHAOM_AgreeFlag ];

/// PHAOM_AppType  应用备注
Property PHAOMAppType As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PHAOM_AppType ];

/// PHAOM_DocDate  医生操作日期
Property PHAOMDocDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PHAOM_DocDate ];

/// PHAOM_DocTIME  医生操作时间
Property PHAOMDocTIME As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PHAOM_DocTIME ];

/// PHAOM_CancelUser_Dr  撤销操作人
Property PHAOMCancelUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PHAOM_CancelUser_Dr ];

/// PHAOM_CancelDate  撤销日期
Property PHAOMCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = PHAOM_CancelDate ];

/// PHAOM_CancelTIME  撤销时间
Property PHAOMCancelTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = PHAOM_CancelTime ];

/// PHAOM_MarkFlag  需要特殊关注
Property PHAOMMarkFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = PHAOM_MarkFlag ];

/// 第二审核人
Property PHAOMAuditUserDr As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = PHAOM_AuditUser_Dr ];

/// 审核途径（1-自动审核，2-人工审核）
Property PHAOMAuditWay As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHAOM_AuditWay ];

Property PHAOMReInsuLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = PHAOM_ReInsuLoc ];

Property PHAOMReMedicalLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = PHAOM_ReMedicalLoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHORDM)</SqlIdExpression>
<SQLMap name="IndexDateLoc">
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>{PHAOM_ROWID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAOM_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAOM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAOM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateResult">
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>{PHAOM_ROW</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateResult"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAOM_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAOM_Result}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAOM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMarkDateLoc">
<Global>^DHCPHORDM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>{PHAOM_ROWID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MarkDateLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAOM_MarkFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAOM_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAOM_Loc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PHAOM_ROWID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHAOM_AgreeFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHAOM_AppType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHAOM_AuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHAOM_AuditWay">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHAOM_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHAOM_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHAOM_CancelUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHAOM_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAOM_DocDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHAOM_DocNote">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHAOM_DocTIME">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHAOM_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHAOM_MarkFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHAOM_PhNote">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAOM_ReInsuLoc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHAOM_ReMedicalLoc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHAOM_Result">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAOM_TIME">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAOM_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHORDM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{PHAOM_ROWID}</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PHAOM_ROWID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHAORDMONITOR</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHORDM)
	s oldI = +$g(^mdata("DHCPHAORDMONITOR"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHORDM = maxI
	s ^mdata("DHCPHAORDMONITOR") = maxI
}

}

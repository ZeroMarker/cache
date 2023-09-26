Class User.DHCPAAdmSheets Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PAADMS_RowId, SqlTableName = DHC_PAAdmSheets, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildSheetsItem As DHCPAAdmSheetsItem [ Cardinality = children, Inverse = SISheetParRef ];

Relationship ChildSheetsLog As DHCPAAdmSheetsLog [ Cardinality = children, Inverse = SLSheetParRef ];

/// PA_Adm
Property PAADMSAdmDr As PAAdm [ SqlColumnNumber = 2, SqlFieldName = PAADMS_Adm_Dr ];

/// 开单日期
Property PAADMSDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PAADMS_Date ];

/// 开单科室
Property PAADMSDepDr As CTLoc [ SqlColumnNumber = 8, SqlFieldName = PAADMS_Dep_Dr ];

/// 结束日期
Property PAADMSEndDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PAADMS_EndDate ];

/// 单号
Property PAADMSNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = PAADMS_No ];

/// 备注
Property PAADMSRemark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PAADMS_Remark ];

/// 开始日期
Property PAADMSStartDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PAADMS_StartDate ];

/// 备注
Property PAADMSStatus As %String(DISPLAYLIST = ",Insert,Presc,Stop,Changed", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,P,S,C") [ SqlColumnNumber = 12, SqlFieldName = PAADMS_Status ];

/// 停止日期
Property PAADMSStopDate As %Date [ SqlColumnNumber = 13, SqlFieldName = PAADMS_StopDate ];

/// 停止时间
Property PAADMSStopTime As %Time [ SqlColumnNumber = 14, SqlFieldName = PAADMS_StopTime ];

/// 停止人
Property PAADMSStopUserDr As SSUser [ SqlColumnNumber = 15, SqlFieldName = PAADMS_StopUser_Dr ];

/// 开单时间
Property PAADMSTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PAADMS_Time ];

/// 单据类型
Property PAADMSType As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAADMS_Type ];

/// 开单人
Property PAADMSUserDr As SSUser [ SqlColumnNumber = 7, SqlFieldName = PAADMS_User_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPAADMS(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PAADMS_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAADMS_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAADMS_Dep_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAADMS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAADMS_No">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAADMS_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAADMS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAADMS_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAADMS_StopDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAADMS_StopTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PAADMS_StopUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PAADMS_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAADMS_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAADMS_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPAADMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAADMS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PAADMS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCPAADMS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAADMS_Adm_Dr</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAADMS_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAADMS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAADMS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPAAdmSheetsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

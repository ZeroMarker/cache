Class User.DHCEmAdvPayAss Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmAdvPayAss, StorageStrategy = SQLStorage ]
{

/// d ##class(User.DHCEmAdvPayAss).%BuildIndices()
/// 就诊ID  EM_Adm_Dr
Property EMAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EM_Adm_Dr ];

/// 当前病区ID  EM_Ward_Dr
Property EMWardDr As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = EM_Ward_Dr ];

/// 评估留观天数  EM_ObsDays
Property EMObsDays As %Library.String [ SqlColumnNumber = 4, SqlFieldName = EM_ObsDays ];

/// 评估留观病区  EM_ObsWard_Dr
Property EMObsWardDr As User.PACWard [ SqlColumnNumber = 5, SqlFieldName = EM_ObsWard_Dr ];

/// 评估预交金  EM_AdvPayAmt
Property EMAdvPayAmt As %Library.String [ SqlColumnNumber = 6, SqlFieldName = EM_AdvPayAmt ];

/// 评估科室  EM_Loc_Dr
Property EMLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = EM_Loc_Dr ];

/// 评估人  EM_User_Dr
Property EMUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = EM_User_Dr ];

/// 评估日期  EM_Date
Property EMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = EM_Date ];

/// 评估时间  EM_Time
Property EMTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = EM_Time ];

/// 备注  EM_Note
Property EMNote As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EM_Note ];

/// 是否可用  EM_Enabled
Property EMEnabled As %Library.String [ SqlColumnNumber = 12, SqlFieldName = EM_Enabled ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMADVPA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_AdvPayAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EM_Enabled">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EM_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EM_Note">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EM_ObsDays">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_ObsWard_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EM_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EM_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EM_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMADVPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEMADVPA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AdmNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMADVPA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AssDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmAdvPayAssS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

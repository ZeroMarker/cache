Class User.DHCEMCScore Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EMCScore, StorageStrategy = SQLStorage ]
{

/// 病人Adm   EC_Adm_Dr
Property ECAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EC_Adm_Dr ];

/// 创建日期  EC_Date
Property ECDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = EC_Date ];

/// 创建时间  EC_Time
Property ECTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = EC_Time ];

/// 创建人  EC_User_Dr
Property ECUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = EC_User_Dr ];

/// 业务类型   EC_Type
Property ECType As %String [ SqlColumnNumber = 6, SqlFieldName = EC_Type ];

/// 评分表ID   EC_Score_Dr
Property ECScoreDr As %String [ SqlColumnNumber = 7, SqlFieldName = EC_Score_Dr ];

/// 评分值   EC_ScoreVal
Property ECScoreVal As %String [ SqlColumnNumber = 8, SqlFieldName = EC_ScoreVal ];

/// 分诊ID   EC_Chk_Dr
Property ECChkDr As %String [ SqlColumnNumber = 9, SqlFieldName = EC_Chk_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCS)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_ScoreVal">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_Score_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMCS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCEMCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexChk">
<Global>^DHCEMCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CHK"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEMCScoreS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEmConsultPat Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsultPat, StorageStrategy = SQLStorage ]
{

/// 诊断ID  EC_Adm_Dr
Property ECAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = EC_Adm_Dr ];

/// 日期  EC_Date
Property ECDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = EC_Date ];

/// 时间  EC_Time
Property ECTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = EC_Time ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsultPatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

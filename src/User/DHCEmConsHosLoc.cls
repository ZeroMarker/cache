Class User.DHCEmConsHosLoc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsHosLoc, StorageStrategy = SQLStorage ]
{

/// EC_Hosp_Dr  医院ID
Property ECHospDr As User.DHCEmConsDicItem [ SqlColumnNumber = 2, SqlFieldName = EC_Hosp_Dr ];

/// EC_Loc_Dr  科室ID
Property ECLocDr As User.DHCEmConsDicItem [ SqlColumnNumber = 3, SqlFieldName = EC_Loc_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCHL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCHL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^DHCEMCHL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HospID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsHosLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

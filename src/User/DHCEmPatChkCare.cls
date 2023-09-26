Class User.DHCEmPatChkCare Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCC_RowID, SqlTableName = DHC_EmPatChkCare, StorageStrategy = SQLStorage ]
{

/// 预检表 PCC_Chk_Dr
Property PCCChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCC_Chk_Dr ];

/// 医护资源表 PCC_Care_Dr
Property PCCCareDr As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = PCC_Care_Dr ];

/// 表 PCC_Loc_Dr
Property PCCLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PCC_Loc_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMPCC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PCC_Care_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCC_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMPCC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPatCheckLev">
<Global>^DHCEMPCC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PatCheckLev"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCC_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkCareS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

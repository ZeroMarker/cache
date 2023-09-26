Class User.DHCMDTDocAut Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTDocAut, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 科室 MD_Loc_Dr
Property MDLocDr As %Library.String [ SqlColumnNumber = 2, SqlFieldName = MD_Loc_Dr ];

/// 职称 MD_ProvTp_Dr
Property MDProvTpDr As User.CTCarPrvTp [ SqlColumnNumber = 3, SqlFieldName = MD_ProvTp_Dr ];

/// 集团化医院  MD_Hosp_Dr
Property MDHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = MD_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDTDA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MD_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MD_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_ProvTp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCMDTDA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_Loc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTDocAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCMDTOuterExpert Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MD_RowID, SqlTableName = DHC_MDTOuterExpert, StorageStrategy = SQLStorage ]
{

/// 工号  MD_Code
Property MDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MD_Code ];

/// 姓名  MD_Name
Property MDName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MD_Name ];

/// 性别  MD_Sex_Dr
Property MDSexDr As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = MD_Sex_Dr ];

/// 职称ID  MD_ProvTp_Dr
Property MDProvTpDr As User.CTCareProv [ SqlColumnNumber = 5, SqlFieldName = MD_ProvTp_Dr ];

/// 身份证号  MD_IDCard
Property MDIDCard As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MD_IDCard ];

/// 科室  MD_Loc_Dr
Property MDLocDr As User.DHCMDTDicItem [ SqlColumnNumber = 7, SqlFieldName = MD_Loc_Dr ];

/// 联系电话  MD_Phone
Property MDPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MD_Phone ];

/// 是否可用  MD_ActiveFlag
Property MDActiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MD_ActiveFlag ];

/// 医院  MD_Hosp_Dr
Property MDHospDr As User.CTHospital [ SqlColumnNumber = 10, SqlFieldName = MD_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTOUTEXP)</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="MD_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MD_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MD_IDCard">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MD_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MD_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MD_Phone">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MD_ProvTp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MD_Sex_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCMDTOUTEXP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMDTOUTEXP</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"userCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MD_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCMDTOUTEXP</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"userName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({MD_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPhone">
<Global>^DHCMDTOUTEXP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Phone"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MD_Phone}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTOuterExpertS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

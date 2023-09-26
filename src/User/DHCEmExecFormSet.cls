Class User.DHCEmExecFormSet Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = FS_RowID, SqlTableName = DHC_EmExecFormSet, StorageStrategy = SQLStorage ]
{

/// 代码 FSCode
Property FSCode As %String [ SqlColumnNumber = 2, SqlFieldName = FS_Code ];

/// 执行单名称 FS_Name	
Property FSName As %String [ SqlColumnNumber = 3, SqlFieldName = FS_Name ];

/// 集团化医院  FS_Hosp_Dr
Property FSHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = FS_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMEFS)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMEFS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FS_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="FS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FS_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMEFS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmExecFormSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCMRIPDetail Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_MRIPDetail, StorageStrategy = SQLStorage ]
{

/// PAADM_Rowid
Property IPDEPAADMDr As PAAdm [ SqlColumnNumber = 2, SqlFieldName = IPDE_PAADM_Dr ];

Property IPDEType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IPDE_Type ];

/// IPDE_IPDayil_Dr
Property IPDEMRIPDayDr As DHCMRIPDay [ SqlColumnNumber = 4, SqlFieldName = IPDE_MRIPDay_Dr ];

/// IPDE_IPDayil_Dr
Property IPDETranDr As User.PAAdmTransaction [ SqlColumnNumber = 5, SqlFieldName = IPDE_Tran_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMRIPDetail(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPDE_MRIPDay_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPDE_PAADM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPDE_Tran_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPDE_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMRIPDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IPDE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IPDE_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIPDay">
<Global>^DHCMRIPDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPDE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPDay"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPDE_MRIPDay_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPDE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPType">
<Global>^DHCMRIPDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IPDE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPDE_MRIPDay_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPDE_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPDE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexIPTypeAdm">
<Global>^DHCMRIPDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>IPDE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPDE_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPDE_PAADM_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{IPDE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaadm">
<Global>^DHCMRIPDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IPDE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Paadm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPDE_PAADM_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPDE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexIPTypePaadm">
<Global>^DHCMRIPDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>IPDE_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IPDayDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPDE_MRIPDay_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPDE_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Paadm"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{IPDE_PAADM_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{IPDE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IPDE_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCMRIPDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

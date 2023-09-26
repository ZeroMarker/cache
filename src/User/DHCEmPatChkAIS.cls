Class User.DHCEmPatChkAIS Extends (%Persistent, %XML.Adaptor) [ SqlRowIdName = PCA_RowId, SqlTableName = DHC_EmPatChkAIS, StorageStrategy = NewStorage1 ]
{

/// 预检表  PCA_Chk_Dr
Property PCAChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCA_Chk_Dr ];

/// 创伤主id  PCA_AIS_Dr
Property PCAAISDr As User.DHCEmAIS [ SqlColumnNumber = 3, SqlFieldName = PCA_AIS_Dr ];

/// 创伤子表id  PCA_AISI_Dr
Property PCAAISIDr As User.DHCEmAISItem [ SqlColumnNumber = 4, SqlFieldName = PCA_AISI_Dr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCEMPCAI)</SqlIdExpression>
<SQLMap name="DateMaster">
<Data name="PCA_AISI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCA_AIS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCA_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMPCAI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCheckLev">
<Global>^DHCEMPCAI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CHECKLEV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCA_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPatChkAISS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

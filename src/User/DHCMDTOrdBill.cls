Class User.DHCMDTOrdBill Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MO_RowID, SqlTableName = DHC_MDTOrdBill, StorageStrategy = SQLStorage ]
{

/// 会诊ID   MO_Cons_Dr
Property MOConsDr As User.DHCMDTConsult [ SqlColumnNumber = 2, SqlFieldName = MO_Cons_Dr ];

/// 会诊医嘱ID   MO_OrdItm_Dr
Property MOOrdItmDr As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = MO_OrdItm_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTORD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MO_Cons_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MO_OrdItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MO_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCst">
<Global>^DHCMDTORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexCst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MO_Cons_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrd">
<Global>^DHCMDTORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MO_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexOrd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MO_OrdItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MO_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTOrdBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

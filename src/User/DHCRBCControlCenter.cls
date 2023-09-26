Class User.DHCRBCControlCenter Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCC_RowID, SqlTableName = DHCRBC_ControlCenter, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCC_Dispatcher_DR
Property DCCDispatcherDR As User.DHCRBCOutWorkerSet [ SqlColumnNumber = 2, SqlFieldName = DCC_Dispatcher_DR ];

/// DCC_Retine_DR
Property DCCRetinueDR As User.DHCRBCOutWorkerSet [ SqlColumnNumber = 3, SqlFieldName = DCC_Retinue_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCControlCenter)</SqlIdExpression>
<SQLMap name="IndexDispatcher">
<Global>^DHCRBCControlCenteri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DCC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Dispatcher"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DCC_Dispatcher_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DCC_Dispatcher_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCC_Retinue_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCControlCenter</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DCC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCControlCenterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

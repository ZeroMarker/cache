Class User.DHCSSDocGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCSD_Rowid, SqlTableName = DHC_SSDocGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCSD_Group_Dr
Property DHCSDGroupDr As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = DHCSD_Group_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSDGRP)</SqlIdExpression>
<SQLMap name="DHCSSDocGroupMaster">
<Data name="DHCSD_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSDGRP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCSD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCSSDocGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

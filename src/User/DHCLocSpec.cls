Class User.DHCLocSpec Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = DHCLS_Rowid, SqlTableName = DHC_LocSpec, StorageStrategy = SQLStorage ]
{

Property DHCLSCGDR As RBCClinicGroup [ SqlColumnNumber = 3, SqlFieldName = DHCLS_CG_DR ];

Property DHCLSLocDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = DHCLS_Loc_DR ];

Property DHCLSCGSDR As RBCClinicServiceGroup [ SqlColumnNumber = 4, SqlFieldName = DHCLS_CGS_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCLocSubject(0))</SqlIdExpression>
<SQLMap name="DHCLSCGSDR">
<Global>^DHCLocSubjecti</Global>
<RowIdSpec name="1">
<Expression>L4</Expression>
<Field>{{DHCLS_RowId}}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CGS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCLS_CGS_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLS_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DHCLS_CGS_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCLS_CG_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCLS_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLocSubject</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCLS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCLS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDHCLSCGDR">
<Global>^DHCLocSubjecti</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCLS_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCLS_CG_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCLS_Loc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCLS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCLS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLocSpecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

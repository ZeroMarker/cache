Class User.DHCRBRight Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RBR_Rowid, SqlTableName = DHCRB_Right, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBRightEquipment As User.DHCRBRightEquipment [ Cardinality = children, Inverse = RBREParRef ];

/// CT CAREPROO
Property RBRCTPCPDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RBR_CTPCP_DR ];

/// RBR_RightValue
Property RBRRightValue As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = RBR_RightValue ];

/// RBR_CTLOC_DR
Property RBRCTLOCDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = RBR_CTLOC_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPACRight("RBRIGHT",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="RBR_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RBR_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RBR_RightValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPACRight</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RBR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RBRIGHT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCarePro">
<Global>^DHCPACRighti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RBR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CarePr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBR_CTPCP_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^DHCPACRighti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RBR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Location"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RBR_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRightS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

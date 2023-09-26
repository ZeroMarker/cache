Class User.DHCPHLibRule Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHLR_RowId, SqlTableName = DHC_PHLibRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPHLibRuleItm As User.DHCPHLibRuleItm [ Cardinality = children, Inverse = PHLRIParRefDr ];

/// PHLR_Lib_Dr
Property PHLRLibDr As User.DHCPHLibaryLabel [ SqlColumnNumber = 2, SqlFieldName = PHLR_Lib_Dr ];

/// PHLR_Label_Dr
Property PHLRLabelDr As User.DHCPHInstLabel [ SqlColumnNumber = 3, SqlFieldName = PHLR_Label_Dr ];

/// PHLR_OrdNum
Property PHLROrdNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHLR_OrdNum ];

/// PHLR_Relation
Property PHLRRelation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHLR_Relation ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHLIBRULE)</SqlIdExpression>
<SQLMap name="IndexLabel">
<Global>^DHCPHLIBRULE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHLR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Label"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLR_Lib_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLR_Label_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdNum">
<Global>^DHCPHLIBRULE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLR_Lib_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLR_OrdNum}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLR_Label_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHLR_Lib_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLR_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLR_Relation">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHLIBRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHLR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHLR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

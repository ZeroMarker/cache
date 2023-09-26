Class User.DHCPHLibRuleItm Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHLRI_RowId, SqlTableName = DHC_PHLibRuleItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHLRIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHLibRule Parent Reference
Relationship PHLRIParRefDr As User.DHCPHLibRule [ Cardinality = parent, Inverse = ChildDHCPHLibRuleItm, Required, SqlFieldName = PHLRI_ParRef_Dr ];

/// PHLRI_ChildSub
Property PHLRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHLRI_ChildSub ];

/// PHLRI_OrdNum
Property PHLRIOrdNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHLRI_OrdNum ];

/// PHLRI_Relation
Property PHLRIRelation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHLRI_Relation ];

/// PHLRI_Item_Dr
Property PHLRIItemDr As User.DHCPHLibItemFeild [ SqlColumnNumber = 5, SqlFieldName = PHLRI_Item_Dr ];

/// PHLRI_Conditon
Property PHLRICondition As %String(DISPLAYLIST = ",Y,N", VALUELIST = ",Y,N") [ SqlFieldName = PHLRI_Conditon ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexOrdNum">
<Global>^DHCPHLIBRULE</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_PHLibRule.PHLR_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHLRI_OrdNum}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHLRI_Conditon">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHLRI_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLRI_OrdNum">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLRI_Relation">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCPHLIBRULE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHLibRule.PHLR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHLRI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_PHLibRule.PHLR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{PHLRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHLibRuleItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

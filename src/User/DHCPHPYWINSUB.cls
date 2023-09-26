Class User.DHCPHPYWINSUB Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHPYS_ROWID, SqlTableName = DHC_PHPYWINSUB, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PHPYSCHILDSUB [ IdKey, PrimaryKey, Unique ];

/// PHPYS_CHILDSUB
Property PHPYSCHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PHPYS_CHILDSUB ];

/// DHC_PHPYWIN Parent Reference
Relationship PHPYSPHPYPARREF As User.DHCPHPYWIN [ Cardinality = parent, Inverse = ChildDHCPHPYWINSUB, Required, SqlFieldName = PHPYS_PHPY_PARREF ];

/// PHPYS_PHW_DR
Property PHPYSPHWDR As User.DHCPHWINDOW [ SqlColumnNumber = 3, SqlFieldName = PHPYS_PHW_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="PHPYSMASTER">
<Data name="PHPYS_PHW_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHPY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHPYWIN.PHPY_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHPYS_CHILDSUB</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHPYWIN.PHPY_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PHW"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHPYS_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHPYWINSUBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

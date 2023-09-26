Class User.DHCEmPreHosRegItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmPreHosRegItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EMChildSub [ IdKey, PrimaryKey, Unique ];

Relationship EWParRefDr As User.DHCEmPreHosReg [ Cardinality = parent, Inverse = ChildDHCEmPreHosRegItem, Required, SqlFieldName = EW_ParRef_Dr ];

Property EMChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EM_ChildSub ];

Property EMItemCode As %String [ SqlColumnNumber = 3, SqlFieldName = EM_Item_Code ];

Property EMItemVal As %String [ SqlColumnNumber = 4, SqlFieldName = EM_ItemVal ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EM_ItemVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_Item_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMPHRI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmPreHosReg.EM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmPreHosReg.EM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPreHosRegItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

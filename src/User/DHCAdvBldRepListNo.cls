Class User.DHCAdvBldRepListNo Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BLD_ItmRowID, SqlTableName = DHC_AdvBldRepListNo, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On BLDChlidSub [ IdKey, PrimaryKey, Unique ];

Relationship BLDRepListParRef As User.DHCAdvBldRepList [ Cardinality = parent, Inverse = ChildDHCAdvBldRepListNo, Required, SqlFieldName = BLD_RepList_ParRef ];

Property BLDChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = BLD_ChlidSub ];

Property BLDNo As %String [ SqlColumnNumber = 3, SqlFieldName = BLD_No ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MasterData">
<Data name="BLD_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVBLDRLIN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AdvBldRepList.BLD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>BLD_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AdvBldRepList.BLD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BLDI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLD_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvBldRepListNoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCINDistributeItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = DSTRI_RowId, SqlTableName = DHC_INDistributeItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DSTRIChildSub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 250;

Relationship DSTRIDSTRParRef As User.DHCINDistribute [ Cardinality = parent, Inverse = ChildDHCINDistributeItm, Required, SqlFieldName = DSTRI_DSTR_ParRef ];

Property DSTRIChildSub As %Library.Numeric [ InitialExpression = {$i(^DHCINDSTR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = DSTRI_ChildSub ];

Property DSTRIINITDR As User.DHCInIsTrf [ SqlColumnNumber = 3, SqlFieldName = DSTRI_INIT_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DSTRI_INIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINDSTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INDistribute.DSTR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DSTRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_INDistribute.DSTR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DSTRI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DSTRI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINDistributeItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

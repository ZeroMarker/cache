Class User.DHCINGdRecCoverItm Extends (%Persistent, User.Abstract) [ SqlRowIdName = CVRI_RowId, SqlTableName = DHC_INGdRec_CoverItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On CVRIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship CVRIParref As User.DHCINGdRecCover [ Cardinality = parent, Inverse = ChildDHCINGdRecCoverItm, Required, SqlFieldName = CVRI_Parref ];

Property CVRIChildSub As %Float [ InitialExpression = {$i(^DHCINGRCover($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = CVRI_ChildSub ];

Property CVRIStkCatDR As User.INCStkCat [ SqlColumnNumber = 3, SqlFieldName = CVRI_StkCat_DR ];

Property CVRIRpAmt As %Float [ SqlColumnNumber = 4, SqlFieldName = CVRI_RpAmt ];

Property CVRISpAmt As %Float [ SqlColumnNumber = 5, SqlFieldName = CVRI_SpAmt ];

Storage NewStorage1
{
<SQLMap name="DataMaster">
<Data name="CVRI_RpAmt">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CVRI_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CVRI_StkCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINGRCover</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INGdRec_Cover.CVR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CVRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_INGdRec_Cover.CVR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{CVRI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CVRI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCINGdRecCoverItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// Description:治疗项目设置增加扩展设置,用以保存各种关联内容设置
/// Modify:20211112 DDCISExpKey 增加要素POA：部位/穴位关联
Class User.DHCDocCureItemSetExpand Extends (%Persistent, User.Abstract) [ SqlRowIdName = DDCISExp_RowID, SqlTableName = DHC_DocCureItemSet_Expand, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DDCISExpChildSub [ IdKey, PrimaryKey, Unique ];

/// DDCISPParRef
Relationship DDCISExpParRef As User.DHCDocCureItemSet [ Cardinality = parent, Inverse = ChildDHCDocCureItemSetExp, Required, SqlFieldName = DDCISExp_ParRef ];

/// DDCISPChildSub
Property DDCISExpChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureItemSet(+$s($d(initvalue):initvalue,1:%d(0)),"Exp",0))}, SqlColumnNumber = 2, SqlFieldName = DDCISExp_ChildSub ];

/// DDCISExp_Key 扩展要素Key(POA：关联部位/穴位 POAGRP:关联部位/穴位组)
Property DDCISExpKey As %String(DISPLAYLIST = ",POA,POAGRP", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",POA,POAGRP") [ SqlColumnNumber = 3, SqlFieldName = DDCISExp_Key ];

/// DDCISExp_Value  扩展内容存值
Property DDCISExpValue As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DDCISExp_Value ];

/// DDCISExp_ValueTbl  扩展内容存值-对应后台表
Property DDCISExpValueTbl As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DDCISExp_ValueTbl ];

/// DDCISExp_Value2  扩展内容存值1
Property DDCISExpValue1 As %Library.String [ SqlColumnNumber = 6, SqlFieldName = DDCISExp_Value1 ];

/// DDCISExp_Value3  扩展内容存值2
Property DDCISExpValue2 As %Library.String [ SqlColumnNumber = 7, SqlFieldName = DDCISExp_Value2 ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="DDCISExp_Key">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCISExp_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCISExp_Value1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDCISExp_Value2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCISExp_ValueTbl">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCureItemSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DDCISExp_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Exp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCISExp_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexKey">
<Global>^DHCDocCureItemSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DDCISExp_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ExpKey"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCISExp_Key}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCISExp_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKeyVal">
<Global>^DHCDocCureItemSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DDCISExp_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"KeyVal"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDCISExp_Key}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCISExp_Value}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDCISExp_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocCureItemSetExpandS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

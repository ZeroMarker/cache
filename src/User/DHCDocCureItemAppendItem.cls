/// 治疗医嘱绑定医嘱
Class User.DHCDocCureItemAppendItem Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DHC_DocCureItemAppendItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DDCIAIChildSub [ IdKey, PrimaryKey, Unique ];

/// DDCISPParRef
Relationship DDCIAIParRef As User.DHCDocCureItemSet [ Cardinality = parent, Inverse = ChildDHCDocCureItemAppendItem, Required, SqlFieldName = DDCIAI_ParRef ];

/// DDCISPChildSub
Property DDCIAIChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureItemSet(+$s($d(initvalue):initvalue,1:%d(0)),"AI",0))}, SqlColumnNumber = 2, SqlFieldName = DDCIAI_ChildSub ];

/// DDCIAI_ItemMast_Dr  绑定医嘱项
Property DDCIAIItemMastDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = DDCIAI_ItemMast_Dr ];

/// DDCIAI_Qty  绑定数量
Property DDCIAIQty As %Float(MAXVAL = 999999, MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = DDCIAI_Qty ];

/// DDCIAI_AdmLoc_Dr  患者就诊科室
Property DDCIAIAdmLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = DDCIAI_AdmLoc_Dr ];

/// DDCIAI_RecLoc_Dr  接收科室
Property DDCIAIRecLocDr As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DDCIAI_RecLoc_Dr ];

/// DDCIAI_RecLoc_Dr  默认
Property DDCIAIDefaultFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DDCIAI_DefaultFlag ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="DDCIAI_AdmLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDCIAI_DefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDCIAI_ItemMast_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCIAI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCIAI_RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDocCureItemSet</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DDCIAI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCIAI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DDCIAI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCDocCureItemAppendItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

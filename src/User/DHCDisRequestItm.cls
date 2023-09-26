Class User.DHCDisRequestItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = REQ_RowID, SqlTableName = DHC_DisRequestItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On REQChildSub [ IdKey, PrimaryKey, Unique ];

/// 主表id REQ_ParRef_Dr	
Relationship REQParRefDr As User.DHCDisRequest [ Cardinality = parent, Inverse = ChildDHCDISREQUEST, Required, SqlFieldName = REQ_ParRef_Dr ];

/// 子表sub REQ_ChildSub	
Property REQChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = REQ_ChildSub ];

/// 项目ID REQ_Item		
Property REQItem As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = REQ_Item ];

/// 项目类型 REQ_ItemType
Property REQItemType As %String(DISPLAYLIST = ",Ord,Oth", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Ord,Oth") [ SqlColumnNumber = 4, SqlFieldName = REQ_ItemType ];

/// 去向 REQ_ExeLoc_Dr
Property REQExeLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = REQ_ExeLoc_Dr ];

Storage NewStorage1
{
<SQLMap name="Master">
<Data name="REQ_ExeLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REQ_Item">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REQ_ItemType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DisRequest.REQ_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REQ_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DisRequest.REQ_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Itm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REQ_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDisRequestItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

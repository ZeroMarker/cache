Class User.DHCDisWorkNodeItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WN_RowID, SqlTableName = DHC_DisWorkNodeItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On WNChildSub [ IdKey, PrimaryKey, Unique ];

/// User.DHCDisWorkNode Parent Reference WN_ParRef
Relationship WNParRef As User.DHCDisWorkNode [ Cardinality = parent, Inverse = ChildDHCDISWORKNODEITM, Required, SqlFieldName = WN_ParRef ];

/// WN_ChildSub
Property WNChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = WN_ChildSub ];

/// 工作结点位置  WN_NodeCode
Property WNLoction As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WN_Loction ];

/// 工作结点标识  WN_NodeName
Property WNLoctionFlag As %Library.String(DISPLAYLIST = ",中转站,科室", SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 4, SqlFieldName = WN_LoctionFlag ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="WN_Loction">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WN_LoctionFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCDISWN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DisWorkNode.WN_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>WN_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DisWorkNode.WN_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WN_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^DHCDISWN</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_DisWorkNode.WN_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>WN_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Locpoint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WN_Loction}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WN_LoctionFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_DisWorkNode.WN_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{WN_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisWorkNodeItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

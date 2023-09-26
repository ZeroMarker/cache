Class User.DHCDisRequestAsseI Extends %Persistent [ SqlRowIdName = RAI_RowId, SqlTableName = DHC_DisRequestAsseI, StorageStrategy = NewStorage1 ]
{

/// 主表id  RA_ParRef_Dr 
Relationship Parref As User.DHCDisRequestAsse [ Cardinality = parent, Inverse = RequestAsseItem, SqlFieldName = RA_ParRef_Dr ];

/// 子表sub  RA_ChildSub
Property RAChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCDISRA($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"c",0))}, Required, SqlColumnNumber = 2, SqlFieldName = RA_ChildSub ];

/// 评价项目  RA_Item_Dr
Property RAItemDr As %String [ SqlColumnNumber = 4, SqlFieldName = RA_Item_Dr ];

Index RAChildSub On RAChildSub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="Master">
<Data name="RA_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RA_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RA_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCDISRAi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DisRequestAsse.RA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DisRequestAsse.RA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RAI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDisRequestAsseIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

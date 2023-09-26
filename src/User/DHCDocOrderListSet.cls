Class User.DHCDocOrderListSet Extends %Persistent [ ClassType = persistent, SqlRowIdName = OLS_RowID, SqlTableName = DHC_DocOrderListSet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OLSChildSub [ IdKey, PrimaryKey, Unique ];

///  Par Ref
Relationship OLSDOGParRef As DHCDocOrderGrid [ Cardinality = parent, Inverse = ChildDHCDocOrderListSet, Required, SqlFieldName = OLS_DOG_ParRef ];

/// Child Sub (New Key)
Property OLSChildSub As %Float [ InitialExpression = {$i(^DHCDocOLS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),0))}, Required, SqlColumnNumber = 2, SqlFieldName = OLS_ChildSub ];

/// 代码
Property OLSCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = OLS_Code ];

/// 描述
Property OLSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OLS_Desc ];

/// 表达式
Property OLSExpression As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OLS_Expression ];

/// 宽度
Property OLSColWidth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OLS_ColWidth ];

/// 是否隐藏
Property OLSHidden As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = OLS_Hidden ];

/// 顺序
Property OLSSeqno As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OLS_Seqno ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="OLS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OLS_ColWidth">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OLS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OLS_Expression">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OLS_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OLS_Seqno">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCDocOLS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>DHC_DocOrderGrid.DOG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L3}</Expression>
<Field>OLS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderGrid.DOG_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{OLS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDocOLSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_DocOrderGrid.DOG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OLS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{OLS_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderGrid.DOG_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{OLS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCDocOLSi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocOrderPage.DOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_DocOrderGrid.DOG_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OLS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{OLS_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderPage.DOP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocOrderGrid.DOG_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>{OLS_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocOrderListSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

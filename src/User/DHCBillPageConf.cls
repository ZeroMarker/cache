/// 名称: User.DHCBillPageConf.cls
/// 描述: 页面配置表
/// 编写者: ZhYW
/// 编写日期: 2019-04-16
Class User.DHCBillPageConf Extends (%Persistent, User.Abstract) [ SqlRowIdName = PC_RowID, SqlTableName = DHC_BillPageConf, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PCSub [ IdKey, PrimaryKey, Unique ];

/// 父表 DHC_BillWebPage
Relationship PCWPParRef As User.DHCBillWebPage [ Cardinality = parent, Inverse = ChildDHCBillPageConf, Required, SqlFieldName = PC_WP_ParRef ];

/// PC_Sub
Property PCSub As %Library.Float [ InitialExpression = {$i(^DHCBillWebPage($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"C",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PC_Sub ];

/// PC_Site
Property PCSite As %Library.String(DISPLAYLIST = ",USER,GROUP,HOSPITAL,SYSTEM", TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PC_Site ];

/// PC_Site_DR   站点为"SYSTEM"时为空
Property PCSiteDR As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PC_Site_DR ];

/// PC_Code
Property PCCode As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PC_Code ];

/// PC_Value
Property PCValue As %Library.String(COLLATION = "Exact", MAXLEN = 500000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PC_Value ];

/// PC_Desc
Property PCDesc As %Library.String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PC_Desc ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PC_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PC_Site">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PC_Site_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PC_Value">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCBillWP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_BillWebPage.WP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PC_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_BillWebPage.WP_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PC_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSiteCode">
<Global>^DHCBillWP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_BillWebPage.WP_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>PC_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_BillWebPage.WP_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Site"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PC_Site}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PC_Code}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{PC_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PC_RowID</SqlRowIdName>
<StreamLocation>^User.DHCBillPageConfS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

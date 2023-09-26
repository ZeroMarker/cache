/// 配液中心顺序规则
Class User.PIVALocBatSort Extends %Persistent [ SqlRowIdName = PLBATS_RowID, SqlTableName = PIVA_LocBatSort, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PLBATSChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PLBATSLBParref As User.PIVALocBat [ Cardinality = parent, Inverse = ChildPIVALocBatSort, Required, SqlFieldName = PLBATS_LB_Parref ];

Property PLBATSChildSub As %Library.Float [ InitialExpression = {..GetInitID($g(initvalue))}, SqlColumnNumber = 2, SqlFieldName = PLBATS_ChildSub ];

/// 类型, 对应持久类的classname全称, 区分大小写, 如 User.INCItm
Property PLBATSType As %String [ SqlColumnNumber = 3, SqlFieldName = PLBATS_Type ];

/// 指向
Property PLBATSPointer As %String [ SqlColumnNumber = 4, SqlFieldName = PLBATS_Pointer ];

/// 顺序
Property PLBATSSortCode As %String [ SqlColumnNumber = 5, SqlFieldName = PLBATS_SortCode ];

ClassMethod GetInitID(initvalue)
{
	if (initvalue = ""){
		s initvalue = $g(%d(0))
	}
	q:(initvalue = "") "没有父指向"
 	q $i(^PIVALBAT(initvalue, "Sort"))
}

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PLBATS_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLBATS_SortCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PLBATS_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PIVALBAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PLBATS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Sort"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLBATS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^PIVALBAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIVA_LocBat.PLBAT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>PLBATS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIVA_LocBat.PLBAT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLBATS_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PLBATS_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PLBATS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PIVALocBatSortS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

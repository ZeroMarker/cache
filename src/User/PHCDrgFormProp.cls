/// 药房药库:药学属性
Class User.PHCDrgFormProp Extends (%Persistent, User.Abstract) [ SqlTableName = PHC_DrgFormProp, StorageStrategy = CacheSQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHCDFPChildSub [ IdKey, PrimaryKey, Unique ];

Relationship PHCDFPParRef As User.PHCDrgForm [ Cardinality = parent, Inverse = ChildPHCDrgFormProp, Required, SqlFieldName = PHCDFP_ParRef ];

Property PHCDFPChildSub As %Float [ InitialExpression = {..GetInitID(initvalue)}, SqlColumnNumber = 2, SqlFieldName = PHCDFP_ChildSub ];

/// 代码
Property PHCDFPCode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PHCDFP_Code ];

/// 名称
Property PHCDFPDesc As %String [ SqlColumnNumber = 4, SqlFieldName = PHCDFP_Desc ];

/// 值
Property PHCDFPVal As %String [ SqlColumnNumber = 5, SqlFieldName = PHCDFP_Val ];

ClassMethod GetInitID(initvalue)
{
	if (initvalue = ""){
		s initvalue = $g(%d(0))
	}
	q:(initvalue = "") "没有父指向"
 	q $i(^PHCD($p(initvalue, "||", 1), "DF", $p(initvalue, "||", 2), "P", 0))
}

Storage CacheSQLStorage
{
<SQLMap name="DataMaster">
<Data name="PHCDFP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCDFP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCDFP_Val">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHC_DrgForm.PHCDF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHCDFP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgForm.PHCDF_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCDFP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PHCD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_DrgMast.PHCD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_DrgForm.PHCDF_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PHCDFP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PHCDFPCode"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHCDFP_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_DrgMast.PHCD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_DrgForm.PHCDF_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCDFP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHCDFP_RowId</SqlRowIdName>
<StreamLocation>^User.PHCDrgFormPropS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCDocCureItemSetPlan Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdPrivate, SqlTableName = DHC_DocCureItemSetPlan, StorageStrategy = StorageSQL ]
{

Index RowIDBasedIDKeyIndex On DDCISPChildSub [ IdKey, PrimaryKey, Unique ];

/// DDCISPParRef
Relationship DDCISPParRef As User.DHCDocCureItemSet [ Cardinality = parent, Inverse = ChildDHCDocCureItemSetPlan, Required, SqlFieldName = DDCISP_ParRef ];

/// DDCISPChildSub
Property DDCISPChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCureItemSet(+$s($d(initvalue):initvalue,1:%d(0)),"P",0))}, SqlColumnNumber = 2, SqlFieldName = DDCISP_ChildSub ];

/// DDCISP_PlanTitle  标题
Property DDCISPPlanTitle As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = DDCISP_PlanTitle ];

/// DDCISP_PlanDetail  内容详细
Property DDCISPPlanDetail As %Library.String(MAXLEN = 15000) [ SqlColumnNumber = 4, SqlFieldName = DDCISP_PlanDetail ];

/// DDCISP_Type 模板类型   Plan 方案模板，Note 备注模板
Property DDCISPType As %Library.String(DISPLAYLIST = ",Plan,Note", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",P,N") [ SqlColumnNumber = 5, SqlFieldName = DDCISP_Type ];

Storage StorageSQL
{
<SQLMap name="DataMaster">
<Data name="DDCISP_PlanDetail">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDCISP_PlanTitle">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDCISP_Type">
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
<Field>DDCISP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCISP_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCDocCureItemSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_DocCureItemSet.DDCIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DDCISP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"TP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_DocCureItemSet.DDCIS_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DDCISP_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DDCISP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDCISP_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCDocCureItemSetPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

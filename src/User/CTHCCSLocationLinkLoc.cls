/// 描述：医呼通科室关联HIS科室
/// 创建人：陈莹-基础数据平台
/// 创建日期：2021-01-28
Class User.CTHCCSLocationLinkLoc Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSLocationLinkLoc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LLLChildsub [ IdKey, PrimaryKey, Unique ];

/// 父表指针
Relationship LLLParRef As User.CTHCCSLocation [ Cardinality = parent, Inverse = ChildLocationLinkLoc, Required, SqlFieldName = LLL_ParRef ];

/// Childsub
Property LLLChildsub As %Float [ InitialExpression = {$i(^CT("HCCSLOC",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LINK",0))}, SqlColumnNumber = 2, SqlFieldName = LLL_Childsub ];

/// his科室代码
Property LLLHISCode As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LLL_HISCode ];

/// his科室名称
Property LLLHISDesc As %String(MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LLL_HISDesc ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LLL_HISCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LLL_HISDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_HCCSLocation.LOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LLL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCCSLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_HCCSLocation.LOC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LLL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHISCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_HCCSLocation.LOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LLL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HISCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_HCCSLocation.LOC_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LLL_HISCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LLL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHISCode2">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_HCCSLocation.LOC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LLL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSLOC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HISCode2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LLL_HISCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_HCCSLocation.LOC_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LLL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LLL_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSLocationLinkLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

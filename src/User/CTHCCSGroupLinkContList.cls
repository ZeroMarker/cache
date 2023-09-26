/// 描述：医呼通-群组关联个人通讯录
/// 创建人：陈莹-基础数据平台
/// 创建日期：2020-12-15
Class User.CTHCCSGroupLinkContList Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock, SqlTableName = CT_HCCSGroupLinkContList, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CGCLChildsub [ IdKey, PrimaryKey, Unique ];

/// 父表指针
Relationship CGCLParRef As User.CTHCCSGroup [ Cardinality = parent, Inverse = ChildGroupLinkContList, Required, SqlFieldName = CGCL_ParRef ];

/// Childsub
Property CGCLChildsub As %Float [ InitialExpression = {$i(^CT("HCCSGROUP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CGCL",0))}, SqlColumnNumber = 2, SqlFieldName = CGCL_Childsub ];

/// 关联个人通讯录
Property CGCLContactListDR As User.CTHCCSContactList [ SqlColumnNumber = 3, SqlFieldName = CGCL_ContactList_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CGCL_ContactList_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_HCCSGroup.GROUP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CGCL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HCCSGROUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_HCCSGroup.GROUP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CGCL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexContactListDR">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CT_HCCSGroup.GROUP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>CGCL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSGROUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ContactList"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CT_HCCSGroup.GROUP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CGCL_ContactList_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CGCL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CGCL_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSGroupLinkContListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

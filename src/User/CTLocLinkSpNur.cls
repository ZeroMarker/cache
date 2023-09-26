/// 项目：重庆人民医院，科室病区添加专项护理按钮
/// 描述: 专项护理子表
/// 表名：CTLocLinkSpNur
/// 父表：科室病区User.CTLoc
/// 编写者：基础数据平台组 李可凡
/// 编写日期: 2019年8月22日
Class User.CTLocLinkSpNur Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = CT_LocLinkSpNur, StorageStrategy = SQLStorage ]
{

/// CT_Loc Parent Reference
Relationship SpNurParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocLinkSpNur, Required, SqlFieldName = SpNur_ParRef ];

/// Childsub
Property SpNurChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SpNur",0))}, SqlColumnNumber = 2, SqlFieldName = SpNur_Childsub ];

/// 指向专项护理
Property SpNurDR As CTSpecialNursing [ SqlColumnNumber = 3, SqlFieldName = SpNur_DR ];

Index RowIDBasedIDKeyIndex On SpNurChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="SpNur_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SpNur_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SpNur"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SpNur_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.CTLocLinkSpNurS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

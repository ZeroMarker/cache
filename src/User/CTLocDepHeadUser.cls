/// 项目：安徽淮南朝阳，张婷，科主任需要维护多个人
/// 描述: 科主任子表
/// 表名：CT_LocDepHeadUser
/// 父表：科室病区User.CTLoc
/// 编写者：基础数据平台-likefan
/// 编写日期: 2021-01-06
Class User.CTLocDepHeadUser Extends (%Persistent, User.Abstract) [ SqlRowIdName = CTDHU_RowId, SqlTableName = CT_LocDepHeadUser, StorageStrategy = NewStorage1 ]
{

/// CT_Loc Parent Reference
Relationship CTDHUParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocDepHeadUser, Required, SqlFieldName = CTDHU_ParRef ];

/// Childsub
Property CTDHUChildsub As %Float [ InitialExpression = {$i(^CTLOC($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CTDHU",0))}, SqlColumnNumber = 2, SqlFieldName = CTDHU_Childsub ];

/// 指向用户
Property CTDHUDepHeadUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = CTDHU_DepHeadUserDR ];

/// 开始日期
Property CTDHUDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CTDHU_DateFrom ];

/// 结束日期
Property CTDHUDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CTDHU_DateTo ];

Index RowIDBasedIDKeyIndex On CTDHUChildsub [ IdKey, PrimaryKey, Unique ];

Storage NewStorage1
{
<SQLMap name="DataMap">
<Data name="CTDHU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTDHU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTDHU_DepHeadUserDR">
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
<Field>CTDHU_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CTDHU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CTDHU_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.CTLocDepHeadUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

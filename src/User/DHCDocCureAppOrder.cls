/// 治疗预约申请单医嘱关联表
Class User.DHCDocCureAppOrder Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCAO_RowId, SqlTableName = DHC_DocCureAppOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCAOChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DCAOParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureAppOrder, Required, SqlFieldName = DCAO_ParRef ];

/// DCAA_ChildSub
Property DCAOChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure($p(%d(0),$c(1)),"Order"))}, SqlColumnNumber = 2, SqlFieldName = DCAO_ChildSub ];

/// 申请单关联医嘱
Property DCAOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DCAO_EORI_DR ];

/// 医嘱使用状态-预约时候使用  正常 N  使用U
Property DCAOEORIStatus As %Library.String(DISPLAYLIST = ",Normoal,Usered", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",N,U") [ SqlColumnNumber = 4, SqlFieldName = DCAO_EORIStatus ];

/// 更新人
Property DCAOUpdateUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DCAO_UpdateUserDR ];

/// 更新日期
Property DCAOUpdateDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DCAO_UpdateDate ];

/// 更新时间
Property DCAOUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DCAO_UpdateTime ];

/// 备注
Property DCAORemark As %Library.String [ SqlColumnNumber = 8, SqlFieldName = DCAO_Remark ];

/// 预约记录ID
Property DCAOAplayDr As DHCDocCureAppArrive [ SqlColumnNumber = 9, SqlFieldName = DCAO_AplayDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCAO_AplayDr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCAO_EORIStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAO_EORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAO_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCAO_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCAO_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCAO_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCAO_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAO_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOfAplayDr">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DCAO_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrderApplayDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAO_AplayDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCAO_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocCureAppOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

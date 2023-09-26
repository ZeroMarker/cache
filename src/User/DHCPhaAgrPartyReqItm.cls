/// 科室协定方申请子表（新疆中医院） 2017-12-14 hulihua 
/// d ##Class(User.DHCPhaAgrPartyReqItm).%BuildIndices()
Class User.DHCPhaAgrPartyReqItm Extends (%Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHAAPRI_RowId, SqlTableName = DHC_PhaAgrPartyReqItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// sub上做个索引，对sub做个约束
Index RowIDBasedIDKeyIndex On PHAAPRIChildSub [ IdKey, PrimaryKey, Unique ];

/// 和主表做关联
Relationship PHAAPRIPHAAPRParRef As User.DHCPhaAgrPartyReq [ Cardinality = parent, Inverse = ChildDHCPhaAgrPartyReqItm, Required, SqlFieldName = PHAAPRI_PHAAPR_ParRef ];

/// 子表里面计数器
Property PHAAPRIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPHAAPR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PHAAPRI_ChildSub ];

/// 科室协定方医嘱项ID
Property PHAAPRIARCIMDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = PHAAPRI_ARCIM_DR ];

/// 积累数量
Property PHAAPRIAccQty As %Library.Integer [ SqlColumnNumber = 4, SqlFieldName = PHAAPRI_AccQty ];

/// 申请数量
Property PHAAPRIReqQty As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = PHAAPRI_ReqQty ];

/// 发药数量
Property PHAAPRIDispQty As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = PHAAPRI_DispQty ];

/// 修改日期
Property PHAAPRIUpReqDetDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PHAAPRI_UpReqDetDate ];

/// 修改时间
Property PHAAPRIUpReqDetTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PHAAPRI_UpReqDetTime ];

/// 修改人DR
Property PHAAPRIUpReqDetUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PHAAPRI_UpReqDetUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHAAPRI_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHAAPRI_AccQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAAPRI_DispQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAAPRI_ReqQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAAPRI_UpReqDetDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHAAPRI_UpReqDetTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAAPRI_UpReqDetUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPHAAPR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaAgrPartyReq.PHAAPR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAAPRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PhaAgrPartyReq.PHAAPR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAAPRI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaAgrPartyReqItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

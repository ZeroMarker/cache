/// 处方追踪子表（新疆中医院） 2017-12-22 hulihua 
/// d ##Class(User.DHCPhaPresTrackItm).%BuildIndices()
Class User.DHCPhaPresTrackItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PHAPTI_RowId, SqlTableName = DHC_PhaPresTrackItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// sub上做个索引，对sub做个约束
Index RowIDBasedIDKeyIndex On PHAPTIChildSub [ IdKey, PrimaryKey, Unique ];

/// 和主表做关联
Relationship PHAPTIPHAPTParRef As User.DHCPhaPresTrack [ Cardinality = parent, Inverse = ChildDHCPhaPresTrackItm, Required, SqlFieldName = PHAPTI_PHAPT_ParRef ];

/// 子表里面计数器
Property PHAPTIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$I(^PHAPRESTRACK($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PHAPTI_ChildSub ];

/// 执行记录表ID
Property PHAPTIOEOREDR As User.OEOrdExec [ SqlColumnNumber = 3, SqlFieldName = PHAPTI_OEORE_DR ];

/// 执行人
Property PHAPTIExecuteUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHAPTI_ExecuteUser_Dr ];

/// 执行日期
Property PHAPTIExecuteDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHAPTI_ExecuteDate ];

/// 执行时间
Property PHAPTIExecuteTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = PHAPTI_ExecuteTime ];

/// 执行状态
Property PHAPTIPreStateDR As User.DHCPhaPreState [ SqlColumnNumber = 7, SqlFieldName = PHAPTI_PreState_DR ];

/// 执行科室
Property PHAPTIExeLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = PHAPTI_ExeLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHAPTI_ExeLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAPTI_ExecuteDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAPTI_ExecuteTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAPTI_ExecuteUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAPTI_OEORE_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHAPTI_PreState_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PHAPRESTRACK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PhaPresTrack.PHAPT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAPTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_PhaPresTrack.PHAPT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAPTI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocPreState">
<Global>^PHAPRESTRACKi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_PhaPresTrack.PHAPT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHAPTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LocPreState"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAPTI_ExeLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAPTI_PreState_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_PhaPresTrack.PHAPT_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHAPTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaPresTrackItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

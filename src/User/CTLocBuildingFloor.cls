/// 医院楼层表-医院楼的子表
/// 基础数据平台-李可凡
/// 2020年8月31日
Class User.CTLocBuildingFloor Extends (%Persistent, User.Abstract) [ SqlRowIdName = CTLBF_RowId, SqlTableName = CTLoc_BuildingFloor, StorageStrategy = SQLStorage ]
{

Relationship CTLBFParRef As User.CTLocBuilding [ Cardinality = parent, Inverse = ChildFloor, Required, SqlFieldName = CTLBF_ParRef ];

Index RowIDBasedIDKeyIndex On CTLBFChildsub [ IdKey, PrimaryKey, Unique ];

Property CTLBFChildsub As %Float [ InitialExpression = {$i(^CT("CTLB",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Floor",0))}, Required, SqlColumnNumber = 3, SqlFieldName = CTLBF_Childsub ];

/// 楼层
Property CTLBFFloor As %String [ SqlColumnNumber = 4, SqlFieldName = CTLBF_Floor ];

/// Date From
Property CTLBFDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CTLBF_DateFrom ];

/// Date To
Property CTLBFDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CTLBF_DateTo ];

/// Mark
Property CTLBFMark As %String [ SqlColumnNumber = 7, SqlFieldName = CTLBF_Mark ];

Storage SQLStorage
{
<SQLMap name="DataMap">
<Data name="CTLBF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTLBF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTLBF_Floor">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTLBF_Mark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_LocBuilding.CTLB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CTLBF_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CTLB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_LocBuilding.CTLB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>"Floor"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTLBF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.CTLocBuildingFloorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

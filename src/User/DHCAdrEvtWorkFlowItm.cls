Class User.DHCAdrEvtWorkFlowItm Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ADREWI_RowID, SqlTableName = DHC_AdrEvtWorkFlowItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On ADREWIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ADREWIADREWParref As User.DHCAdrEvtWorkFlow [ Cardinality = parent, Inverse = ChildDHCAdrEvtWorkFlowItm, Required, SqlFieldName = ADREWI_ADREW_Parref ];

Property ADREWIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ADREWI_ChildSub ];

Property ADREWICode As %String [ SqlColumnNumber = 3, SqlFieldName = ADREWI_Code ];

Property ADREWIDesc As %String [ SqlColumnNumber = 4, SqlFieldName = ADREWI_Desc ];

/// 顺序号
Property ADREWIOrderNo As %String [ SqlColumnNumber = 5, SqlFieldName = ADREWI_OrderNo ];

/// 是否可用
Property ADREWIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ADREWI_ActiveFlag ];

/// 层级
Property ADREWILevel As %String [ SqlColumnNumber = 7, SqlFieldName = ADREWI_Level ];

/// 上一层级 RowID
Property ADREWILevelRowID As %String [ SqlColumnNumber = 8, SqlFieldName = ADREWI_LevelRowID ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="IndexLevOrderNo">
<Global>^DHCADREVTWFI</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_AdrEvtWorkFlow.ADREW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ADREWI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LevOrderNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADREWI_LevelRowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AdrEvtWorkFlow.ADREW_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADREWI_OrderNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADREWI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADREWI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADREWI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADREWI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADREWI_Level">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADREWI_LevelRowID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADREWI_OrderNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADREVTWFI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AdrEvtWorkFlow.ADREW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ADREWI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AdrEvtWorkFlow.ADREW_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADREWI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADREWI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexCode">
<Global>^DHCADREVTWFI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AdrEvtWorkFlow.ADREW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ADREWI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ADREWI_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AdrEvtWorkFlow.ADREW_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADREWI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexLevelDr">
<Global>^DHCADREVTWFI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AdrEvtWorkFlow.ADREW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ADREWI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmLevelDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADREWI_LevelRowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AdrEvtWorkFlow.ADREW_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADREWI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdrEvtWorkFlowItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

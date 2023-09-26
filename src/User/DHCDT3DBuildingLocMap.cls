Class User.DHCDT3DBuildingLocMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BLM_RowID, SqlTableName = DHC_DT3DBuildingLocMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BLM_BuildingDR
Property BLMBuildingDR As User.DHCDT3DBuilding [ SqlColumnNumber = 2, SqlFieldName = BLM_BuildingDR ];

/// BLM_FloorDR
Property BLMFloorDR As User.DHCDT3DFloor [ SqlColumnNumber = 3, SqlFieldName = BLM_FloorDR ];

/// BLM_LocDR
Property BLMLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 4, SqlFieldName = BLM_LocDR ];

/// BLM_LocFlag
Property BLMLocFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BLM_LocFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDT3DBuildingLocMap("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BLM_BuildingDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BLM_FloorDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BLM_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BLM_LocFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDT3DBuildingLocMap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{BLM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuilding">
<Global>^DHCDT3DBuildingLocMap</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{BLM_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Building"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLM_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFloor">
<Global>^DHCDT3DBuildingLocMap</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{BLM_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Floor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLM_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLM_FloorDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BLM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocFlagLoc">
<Global>^DHCDT3DBuildingLocMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{BLM_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BLM_LocFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BLM_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BLM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDT3DBuildingLocMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

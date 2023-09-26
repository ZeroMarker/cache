Class User.DHCDT3DBuildUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BU_RowID, SqlTableName = DHC_DT3DBuildUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BU_FloorDR
Property BUFloorDR As User.DHCDT3DFloor [ SqlColumnNumber = 2, SqlFieldName = BU_FloorDR ];

/// BU_BuildUnitEXID
/// Property BUBuildUnitEXID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BU_BuildUnitEXID ];
Property BUBuildUnitEXID As User.DHCEQBUBuildingUnit [ SqlColumnNumber = 3, SqlFieldName = BU_BuildUnitEXID ];

/// BU_AreaType
Property BUAreaType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BU_AreaType ];

/// BU_AreaID
Property BUAreaID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BU_AreaID ];

/// BU_No
Property BUNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BU_No ];

/// BU_Desc
Property BUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BU_Desc ];

/// BU_DoorNo
Property BUDoorNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BU_DoorNo ];

/// BU_BuildingArea
Property BUBuildingArea As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BU_BuildingArea ];

/// BU_UseLocDR
Property BUUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BU_UseLocDR ];

/// BU_UnitType
Property BUUnitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BU_UnitType ];

/// BU_Status
Property BUStatus As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BU_Status ];

/// BU_Purpose
Property BUPurpose As User.DHCEQCLandPurpose [ SqlColumnNumber = 13, SqlFieldName = BU_Purpose ];

/// BU_3DRoomID
Property BU3DRoomID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BU_3DRoomID ];

/// BU_PosX
Property BUPosX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BU_PosX ];

/// BU_PosY
Property BUPosY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BU_PosY ];

/// BU_PosZ
Property BUPosZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BU_PosZ ];

/// BU_MinX
Property BUMinX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BU_MinX ];

/// BU_MaxX
Property BUMaxX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BU_MaxX ];

/// BU_MinY
Property BUMinY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BU_MinY ];

/// BU_MaxY
Property BUMaxY As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BU_MaxY ];

/// BU_MinZ
Property BUMinZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BU_MinZ ];

/// BU_MaxZ
Property BUMaxZ As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BU_MaxZ ];

/// BU_Temperature
Property BUTemperature As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BU_Temperature ];

/// BU_Humidity
Property BUHumidity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BU_Humidity ];

/// BU_InvalidFlag
Property BUInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BU_InvalidFlag ];

/// BU_Remark
Property BURemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BU_Remark ];

/// BU_ParentBuildUnitDR
Property BUParentBuildUnitDR As User.DHCDT3DBuildUnit [ SqlColumnNumber = 28, SqlFieldName = BU_ParentBuildUnitDR ];

/// BU_AuxiliaryFlag
Property BUAuxiliaryFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = BU_AuxiliaryFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDT3DBuildUnit("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BU_3DRoomID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BU_AreaID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BU_AreaType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BU_AuxiliaryFlag">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BU_BuildUnitEXID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BU_BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BU_DoorNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BU_FloorDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BU_Humidity">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BU_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BU_MaxX">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BU_MaxY">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BU_MaxZ">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BU_MinX">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BU_MinY">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BU_MinZ">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BU_No">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BU_ParentBuildUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BU_PosX">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BU_PosY">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BU_PosZ">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BU_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BU_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BU_Temperature">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BU_UnitType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BU_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCDT3DBuildUnit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index3DRoomID">
<Global>^DHCDT3DBuildUnit</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{BU_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"3DRoomID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BU_3DRoomID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArea">
<Global>^DHCDT3DBuildUnit</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{BU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Area"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{BU_AreaType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{BU_AreaID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBUNo">
<Global>^DHCDT3DBuildUnit</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{BU_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BUNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BU_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuildingUnit">
<Global>^DHCDT3DBuildUnit</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{BU_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildingUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BU_BuildUnitEXID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFloor">
<Global>^DHCDT3DBuildUnit</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{BU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Floor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>+{BU_FloorDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDT3DBuildUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

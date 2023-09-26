Class User.DHCEQBUBuildingUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BU_RowID, SqlTableName = DHC_EQBUBuildingUnit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BU_BuildingDR
Property BUBuildingDR As User.DHCEQBUBuilding [ SqlColumnNumber = 2, SqlFieldName = BU_BuildingDR ];

/// BU_FloorIndex
Property BUFloorIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BU_FloorIndex ];

/// BU_Desc
Property BUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BU_Desc ];

/// BU_DoorNo
Property BUDoorNo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BU_DoorNo ];

/// BU_Place
Property BUPlace As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BU_Place ];

/// BU_BuildingArea
Property BUBuildingArea As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BU_BuildingArea ];

/// BU_UtilizationArea
Property BUUtilizationArea As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = BU_UtilizationArea ];

/// BU_Stuct
Property BUStuct As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BU_Stuct ];

/// BU_UseLocDR
Property BUUseLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BU_UseLocDR ];

/// BU_UnitType
Property BUUnitType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BU_UnitType ];

/// BU_Status
Property BUStatus As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BU_Status ];

/// BU_ManagerUserDR
Property BUManagerUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BU_ManagerUserDR ];

/// BU_Purpose
Property BUPurpose As User.DHCEQCLandPurpose [ SqlColumnNumber = 14, SqlFieldName = BU_Purpose ];

/// BU_OriginalFee
Property BUOriginalFee As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = BU_OriginalFee ];

/// BU_Origin
Property BUOrigin As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = BU_Origin ];

/// BU_Change
Property BUChange As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BU_Change ];

/// BU_DateFrom
Property BUDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = BU_DateFrom ];

/// BU_DateTo
Property BUDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = BU_DateTo ];

/// BU_RoomFacing
Property BURoomFacing As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BU_RoomFacing ];

/// BU_MinPeople
Property BUMinPeople As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BU_MinPeople ];

/// BU_MaxPeople
Property BUMaxPeople As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BU_MaxPeople ];

/// BU_ElectricCond
Property BUElectricCond As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BU_ElectricCond ];

/// BU_WaterCond
Property BUWaterCond As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BU_WaterCond ];

/// BU_SewageDisposal
Property BUSewageDisposal As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BU_SewageDisposal ];

/// BU_RadProtect
Property BURadProtect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = BU_RadProtect ];

/// BU_Hold1
Property BUHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = BU_Hold1 ];

/// BU_Hold2
Property BUHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = BU_Hold2 ];

/// BU_Hold3
Property BUHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = BU_Hold3 ];

/// BU_Hold4
Property BUHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = BU_Hold4 ];

/// BU_Hold5
Property BUHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = BU_Hold5 ];

/// BU_BuildingUnitDR
Property BUBuildingUnitDR As User.DHCEQBuildingUnit [ SqlColumnNumber = 32, SqlFieldName = BU_BuildingUnitDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBUBuildingUnit("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BU_BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BU_BuildingDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BU_BuildingUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="BU_Change">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BU_DoorNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BU_ElectricCond">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BU_FloorIndex">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BU_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="BU_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="BU_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="BU_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="BU_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="BU_ManagerUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BU_MaxPeople">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BU_MinPeople">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BU_Origin">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BU_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BU_Place">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BU_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BU_RoomFacing">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BU_SewageDisposal">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BU_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BU_Stuct">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BU_UnitType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BU_UseLocDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BU_UtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Bu_RadProtect">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="Bu_WaterCond">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCEQBUBuildingUnit</Global>
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
<SQLMap name="IndexBuilding">
<Global>^DHCEQBUBuildingUnit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Building"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BU_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuildingFloor">
<Global>^DHCEQBUBuildingUnit</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{BU_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildingFloor"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BU_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BU_FloorIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBUBuildingUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

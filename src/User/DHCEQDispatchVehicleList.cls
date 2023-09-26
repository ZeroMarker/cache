Class User.DHCEQDispatchVehicleList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DVL_RowID, SqlTableName = DHC_EQDispatchVehicleList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DVL_DispatchVehicleDR
Property DVLDispatchVehicleDR As User.DHCEQDispatchVehicle [ SqlColumnNumber = 2, SqlFieldName = DVL_DispatchVehicleDR ];

/// DVL_EquipDR
Property DVLEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = DVL_EquipDR ];

/// DVL_DriverDR
Property DVLDriverDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DVL_DriverDR ];

/// DVL_CardNo
Property DVLCardNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DVL_CardNo ];

/// DVL_RunDate
Property DVLRunDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DVL_RunDate ];

/// DVL_RunTime
Property DVLRunTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DVL_RunTime ];

/// DVL_EndDate
Property DVLEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = DVL_EndDate ];

/// DVL_EndTime
Property DVLEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DVL_EndTime ];

/// DVL_StartMileage
Property DVLStartMileage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DVL_StartMileage ];

/// DVL_EndMileage
Property DVLEndMileage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DVL_EndMileage ];

/// DVL_Remark
Property DVLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DVL_Remark ];

/// DVL_Hold1
Property DVLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DVL_Hold1 ];

/// DVL_Hold2
Property DVLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DVL_Hold2 ];

/// DVL_Hold3
Property DVLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DVL_Hold3 ];

/// DVL_Hold4
Property DVLHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DVL_Hold4 ];

/// DVL_Hold5
Property DVLHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DVL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDispatchVehicleList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DVL_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DVL_DispatchVehicleDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DVL_DriverDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DVL_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DVL_EndMileage">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DVL_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DVL_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DVL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DVL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DVL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DVL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DVL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DVL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DVL_RunDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DVL_RunTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DVL_StartMileage">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQDispatchVehicleList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DVL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DVL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDispatchVehicle">
<Global>^DHCEQDispatchVehicleList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DVL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DispatchVehicle"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DVL_DispatchVehicleDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DVL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDriverDR">
<Global>^DHCEQDispatchVehicleList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DVL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Driver"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DVL_DriverDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DVL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQDispatchVehicleList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DVL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DVL_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DVL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDispatchVehicleListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

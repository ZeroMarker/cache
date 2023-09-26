Class User.DHCDT3DFloor Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = F_RowID, SqlTableName = DHC_DT3DFloor, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// F_BuildingDR
Property FBuildingDR As User.DHCDT3DBuilding [ SqlColumnNumber = 2, SqlFieldName = F_BuildingDR ];

/// F_FloorIndex
Property FFloorIndex As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = F_FloorIndex ];

/// F_FloorNum
Property FFloorNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = F_FloorNum ];

/// F_FloorNo
Property FFloorNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = F_FloorNo ];

/// F_3DFloorID
Property F3DFloorID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = F_3DFloorID ];

/// F_BuildingArea
Property FBuildingArea As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = F_BuildingArea ];

/// F_UtilizationArea
Property FUtilizationArea As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = F_UtilizationArea ];

/// F_Height
Property FHeight As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = F_Height ];

/// F_Purpose
Property FPurpose As %Library.String(DISPLAYLIST = ",临床,医技,医辅,行政后勤", MAXLEN = 3, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4") [ SqlColumnNumber = 10, SqlFieldName = F_Purpose ];

/// F_Remark
Property FRemark As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = F_Remark ];

/// F_ActiveFlag
Property FActiveFlag As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = F_ActiveFlag ];

/// F_Hold1
Property FHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = F_Hold1 ];

/// F_Hold2
Property FHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = F_Hold2 ];

/// F_Hold3
Property FHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = F_Hold3 ];

/// F_Hold4
Property FHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = F_Hold4 ];

/// F_Hold5
Property FHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = F_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDT3DFloor("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="F_3DFloorID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="F_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="F_BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="F_BuildingDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="F_FloorIndex">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="F_FloorNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="F_FloorNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="F_Height">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="F_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="F_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="F_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="F_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="F_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="F_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="F_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="F_UtilizationArea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDT3DFloor</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>F_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{F_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuilding">
<Global>^DHCDT3DFloor</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{F_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Building"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{F_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{F_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexBuildingFloorIndex">
<Global>^DHCDT3DFloor</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{F_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuildingFloorIndex"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{F_BuildingDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{F_FloorIndex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{F_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFloorID">
<Global>^DHCDT3DFloor</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{F_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FloorID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{F_3DFloorID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{F_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDT3DFloorS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEQCLocation Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = L_RowID, SqlTableName = DHC_EQCLocation, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// L_Code
Property LCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = L_Code ];

/// L_Desc
Property LDesc As %Library.String(COLLATION = "Exact", MAXLEN = 130, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = L_Desc ];

/// L_Type
/// 科室类型:0:科室 1:房间 9:其他
Property LType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = L_Type ];

/// L_HospitalDR
Property LHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = L_HospitalDR ];

// Property LLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = L_LocDR ];

/// L_LocDR
Property LLocDR As User.DHCEQCDepartment [ SqlColumnNumber = 6, SqlFieldName = L_LocDR ];

/// L_BuildingDR
/// 房屋信息：czf 修改指向表，DHCEQBUBuilding改为DHCDT3DBuilding
Property LBuildingDR As User.DHCDT3DBuilding [ SqlColumnNumber = 7, SqlFieldName = L_BuildingDR ];

/// L_BuildingUnitDR
/// 空间信息：czf 修改指向表，DHCEQBUBuildingUnit改为DHCDT3DBuildUnit
Property LBuildingUnitDR As User.DHCDT3DBuildUnit [ SqlColumnNumber = 8, SqlFieldName = L_BuildingUnitDR ];

/// L_Place
Property LPlace As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = L_Place ];

/// L_DateFrom
Property LDateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = L_DateFrom ];

/// L_DateTo
Property LDateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = L_DateTo ];

/// L_InvalidFlag
Property LInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = L_InvalidFlag ];

/// L_Remark
Property LRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = L_Remark ];

/// L_Hold1 楼层编号
Property LHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = L_Hold1 ];

/// L_Hold2 门牌号
Property LHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = L_Hold2 ];

/// L_Hold3
Property LHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = L_Hold3 ];

/// L_Hold4
Property LHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = L_Hold4 ];

/// L_Hold5
Property LHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = L_Hold5 ];

/// L_IsDefault
Property LIsDefault As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = L_IsDefault ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCLocation",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="L_BuildingDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="L_BuildingUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="L_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="L_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="L_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="L_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="L_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="L_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="L_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="L_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="L_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="L_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="L_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="L_IsDefault">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="L_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="L_Place">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="L_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="L_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>L_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCLocation"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{L_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuildUnit">
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{L_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCLocation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BuildUnit"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{L_BuildingUnitDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{L_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDefaultLoc">
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>{L_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCLocation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"isDefault"</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{L_IsDefault}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{L_LocDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{L_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQCCode</Global>
<Subscript name="1">
<Expression>"DHCEQCLocation"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{L_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{L_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

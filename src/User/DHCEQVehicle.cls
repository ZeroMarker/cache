Class User.DHCEQVehicle Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = V_RowID, SqlTableName = DHC_EQVehicle, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// V_EquipDR
Property VEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = V_EquipDR ];

/// V_VehicleNo
Property VVehicleNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = V_VehicleNo ];

/// V_EngineNo
Property VEngineNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = V_EngineNo ];

/// V_CarFrameNo
Property VCarFrameNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = V_CarFrameNo ];

/// V_Displacemint
Property VDisplacemint As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = V_Displacemint ];

/// V_Mileage
Property VMileage As %Float [ SqlColumnNumber = 7, SqlFieldName = V_Mileage ];

/// V_Color
Property VColor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = V_Color ];

/// V_DisplacemintNo
Property VDisplacemintNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = V_DisplacemintNo ];

/// V_FacModel
Property VFacModel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = V_FacModel ];

/// V_RegisterDate
Property VRegisterDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = V_RegisterDate ];

/// V_CerHolderNo
Property VCerHolderNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = V_CerHolderNo ];

/// V_HasLicenseNo
Property VHasLicenseNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = V_HasLicenseNo ];

/// V_SeatNum
Property VSeatNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = V_SeatNum ];

/// V_Origin
Property VOrigin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = V_Origin ];

/// V_Purpose
Property VPurpose As User.DHCEQCVehPrupose [ SqlColumnNumber = 16, SqlFieldName = V_Purpose ];

/// V_Plait
Property VPlait As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = V_Plait ];

/// V_SourceType
Property VSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = V_SourceType ];

/// V_SourceID
Property VSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = V_SourceID ];

/// V_InvalidFlag
Property VInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = V_InvalidFlag ];

/// V_Identification
Property VIdentification As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = V_Identification ];

/// V_VehicleType
Property VVehicleType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = V_VehicleType ];

/// V_Hold2
Property VHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = V_Hold2 ];

/// V_Hold3
Property VHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = V_Hold3 ];

/// V_Hold4
Property VHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = V_Hold4 ];

/// V_Hold5
Property VHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = V_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQVehicle("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="V_CarFrameNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="V_CerHolderNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="V_Color">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="V_Displacemint">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="V_DisplacemintNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="V_EngineNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="V_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="V_FacModel">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="V_HasLicenseNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="V_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="V_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="V_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="V_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="V_Identification">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="V_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="V_Mileage">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="V_Origin">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="V_Plait">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="V_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="V_RegisterDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="V_SeatNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="V_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="V_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="V_VehicleNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="V_VehicleType">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Global>^DHCEQVehicle</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>V_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{V_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQVehicle</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>V_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{V_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{V_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQVehicle</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>V_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{V_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{V_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{V_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVehicleNo">
<Global>^DHCEQVehicle</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>V_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VehicleNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{V_VehicleNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{V_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>V_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQVehicleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

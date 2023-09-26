Class User.DHCEQCMasterItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MI_RowID, SqlTableName = DHC_EQCMasterItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MI_CatDR
Property MICatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 5, SqlFieldName = MI_CatDR ];

/// MI_Code
Property MICode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MI_Code ];

/// MI_CycleNum
Property MICycleNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MI_CycleNum ];

/// MI_CycleUnitDR
Property MICycleUnitDR As User.DHCEQCCycleUnit [ SqlColumnNumber = 20, SqlFieldName = MI_CycleUnitDR ];

/// MI_Desc
Property MIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MI_Desc ];

/// MI_EquipTypeDR
Property MIEquipTypeDR As User.DHCEQCEquipType [ SqlColumnNumber = 4, SqlFieldName = MI_EquipTypeDR ];

/// MI_ForceInspectFlag->MI_CFDADR
Property MICFDADR As User.DHCEQCTree [ SqlColumnNumber = 10, SqlFieldName = MI_CFDADR ];

/// MI_Hold1->MI_CFDAListDR
Property MICFDAListDR As User.DHCEQCTreeList [ SqlColumnNumber = 11, SqlFieldName = MI_CFDAListDR ];

/// MI_Hold2->MI_HospitalDR
Property MIHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MI_HospitalDR ];

/// MI_Hold3->MI_ManageLevel
Property MIManageLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MI_ManageLevel ];

/// MI_Hold4->MI_LocalWJWCode
Property MILocalWJWCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MI_LocalWJWCode ];

/// MI_LocalFinanceCode
Property MILocalFinanceCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MI_LocalFinanceCode ];

/// MI_Hold6->MI_MeasureFee
Property MIMeasureFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MI_MeasureFee ];

/// MI_Hold7->MI_StandFlag
Property MIStandFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MI_StandFlag ];

/// MI_Hold8->MI_StandItemDR
Property MIStandItemDR As User.DHCEQCMasterItem [ SqlColumnNumber = 23, SqlFieldName = MI_StandItemDR ];

/// MI_InvalidFlag
Property MIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = MI_InvalidFlag ];

/// MI_MeasureFlag->MI_HoldCat
Property MIHoldCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MI_HoldCat ];

/// MI_MedicalFlag
Property MIMedicalFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = MI_MedicalFlag ];

/// MI_RaditionFlag
Property MIRaditionFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = MI_RaditionFlag ];

/// MI_Remark
Property MIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MI_Remark ];

/// MI_StatCatDR
Property MIStatCatDR As User.DHCEQCStatCat [ SqlColumnNumber = 6, SqlFieldName = MI_StatCatDR ];

/// MI_UnitDR
Property MIUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MI_UnitDR ];

/// MI_Hold9
Property MIHold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MI_Hold9 ];

/// MI_Hold10
Property MIHold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = MI_Hold10 ];

/// MI_Hold11
Property MIHold11 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MI_Hold11 ];

/// MI_Hold12
Property MIHold12 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MI_Hold12 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCMasterItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MI_CFDADR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MI_CFDAListDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MI_CatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MI_CycleNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MI_CycleUnitDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MI_EquipTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MI_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MI_Hold11">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MI_Hold12">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MI_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MI_HoldCat">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MI_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MI_LocalFinanceCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MI_LocalWJWCode">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MI_ManageLevel">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MI_MeasureFee">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MI_MedicalFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MI_RaditionFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MI_StandFlag">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MI_StandItemDR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MI_StatCatDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MI_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCMasterItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCMasterItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MI_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCMasterItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({MI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCMasterItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MI_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCMasterItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Hospital"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>+{MI_HospitalDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MI_EquipTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMICatDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCMasterItem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MICatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MI_CatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCMasterItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

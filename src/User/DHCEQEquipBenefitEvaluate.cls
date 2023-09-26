Class User.DHCEQEquipBenefitEvaluate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EBE_RowID, SqlTableName = DHC_EQEquipBenefitEvaluate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EBE_EquipDR
Property EBEEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = EBE_EquipDR ];

/// EBE_Year
Property EBEYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EBE_Year ];

/// EBE_Material
Property EBEMaterial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EBE_Material ];

/// EBE_OperatorCount
Property EBEOperatorCount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = EBE_OperatorCount ];

/// EBE_MedicalItem
Property EBEMedicalItem As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EBE_MedicalItem ];

/// EBE_YearRunTime
Property EBEYearRunTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EBE_YearRunTime ];

/// EBE_FeeOfEmployee
Property EBEFeeOfEmployee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EBE_FeeOfEmployee ];

/// EBE_UsePerMonthNum
Property EBEUsePerMonthNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EBE_UsePerMonthNum ];

/// EBE_WorkLoadPerMonthNum
Property EBEWorkLoadPerMonthNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EBE_WorkLoadPerMonthNum ];

/// EBE_ReclaimYearsNum
Property EBEReclaimYearsNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = EBE_ReclaimYearsNum ];

/// EBE_UseRate
Property EBEUseRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EBE_UseRate ];

/// EBE_GoodRate
Property EBEGoodRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EBE_GoodRate ];

/// EBE_YearIncomeFee
Property EBEYearIncomeFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = EBE_YearIncomeFee ];

/// EBE_CostFee
Property EBECostFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EBE_CostFee ];

/// EBE_YearMaintFee
Property EBEYearMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = EBE_YearMaintFee ];

/// EBE_ClinicEffect
Property EBEClinicEffect As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EBE_ClinicEffect ];

/// EBE_ResoureState
Property EBEResoureState As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = EBE_ResoureState ];

/// EBE_WaterPerMonthNum
Property EBEWaterPerMonthNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EBE_WaterPerMonthNum ];

/// EBE_ElectricityPerMonthNum
Property EBEElectricityPerMonthNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EBE_ElectricityPerMonthNum ];

/// EBE_ComeIncreaseRate
Property EBEComeIncreaseRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = EBE_ComeIncreaseRate ];

/// EBE_OutIncreaseRate
Property EBEOutIncreaseRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = EBE_OutIncreaseRate ];

/// EBE_Hold1
Property EBEHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = EBE_Hold1 ];

/// EBE_Hold2
Property EBEHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = EBE_Hold2 ];

/// EBE_Hold3
Property EBEHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = EBE_Hold3 ];

/// EBE_Hold4
Property EBEHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = EBE_Hold4 ];

/// EBE_Hold5
Property EBEHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = EBE_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipBenefitEvaluate("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EBE_ClinicEffect">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EBE_ComeIncreaseRate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EBE_CostFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EBE_ElectricityPerMonthNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EBE_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EBE_FeeOfEmployee">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EBE_GoodRate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EBE_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="EBE_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EBE_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="EBE_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="EBE_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="EBE_Material">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EBE_MedicalItem">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EBE_OperatorCount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EBE_OutIncreaseRate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EBE_ReclaimYearsNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EBE_ResoureState">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EBE_UsePerMonthNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EBE_UseRate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EBE_WaterPerMonthNum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EBE_WorkLoadPerMonthNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EBE_Year">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EBE_YearIncomeFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EBE_YearMaintFee">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EBE_YearRunTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQEquipBenefitEvaluate</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EBE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EBE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipBenefitEvaluate">
<Global>^DHCEQEquipBenefitEvaluate</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EBE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EBE_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EBE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipBenefitEvaluate</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

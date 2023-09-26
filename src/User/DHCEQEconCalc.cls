Class User.DHCEQEconCalc Extends %Persistent [ SqlRowIdName = EC_RowID, SqlTableName = DHC_EQEconCalc, StorageStrategy = SQLStorage ]
{

/// EC_SourceType
Property ECSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EC_SourceType ];

/// EC_SourceID
Property ECSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EC_SourceID ];

/// EC_EquipDR
Property ECEquipDR As User.DHCEQEquip [ SqlColumnNumber = 4, SqlFieldName = EC_EquipDR ];

/// EC_CalcFlag
Property ECCalcFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = EC_CalcFlag ];

/// EC_Year
Property ECYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EC_Year ];

/// EC_ServiceIncome
Property ECServiceIncome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EC_ServiceIncome ];

/// EC_MaterialIncome
Property ECMaterialIncome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EC_MaterialIncome ];

/// EC_MaintFee
Property ECMaintFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EC_MaintFee ];

/// EC_FeeOfEmployee
Property ECFeeOfEmployee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EC_FeeOfEmployee ];

/// EC_MaterialFee
Property ECMaterialFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EC_MaterialFee ];

/// EC_DepreFee
Property ECDepreFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EC_DepreFee ];

/// EC_BuildingFee
Property ECBuildingFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EC_BuildingFee ];

/// EC_EnergyFee
Property ECEnergyFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = EC_EnergyFee ];

/// EC_Effect
Property ECEffect As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EC_Effect ];

/// EC_WorkLoadNum
Property ECWorkLoadNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = EC_WorkLoadNum ];

/// EC_PositiveRate
Property ECPositiveRate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EC_PositiveRate ];

/// EC_Hold1
Property ECHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = EC_Hold1 ];

/// EC_Hold2
Property ECHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EC_Hold2 ];

/// EC_Hold3
Property ECHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = EC_Hold3 ];

/// EC_Hold4
Property ECHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = EC_Hold4 ];

/// EC_Hold5
Property ECHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = EC_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEconCalc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_BuildingFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EC_CalcFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_DepreFee">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EC_Effect">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EC_EnergyFee">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_FeeOfEmployee">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EC_MaintFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_MaterialFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EC_MaterialIncome">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_PositiveRate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EC_ServiceIncome">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EC_Year">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQEconCalc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{EC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndesxSource">
<Global>^DHCEQEconCalc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_CalcFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQEconCalc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEconCalcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

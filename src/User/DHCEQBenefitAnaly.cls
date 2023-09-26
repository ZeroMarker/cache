Class User.DHCEQBenefitAnaly Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BA_RowID, SqlTableName = DHC_EQBenefitAnaly, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BA_No
Property BANo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BA_No ];

/// BA_InDate
Property BAInDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = BA_InDate ];

/// BA_Year
Property BAYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BA_Year ];

/// BA_Month
Property BAMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BA_Month ];

/// BA_CTLocDR
Property BACTLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BA_CTLocDR ];

/// BA_EquipDR
Property BAEquipDR As User.DHCEQEquip [ SqlColumnNumber = 7, SqlFieldName = BA_EquipDR ];

/// BA_PlanUse
Property BAPlanUse As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = BA_PlanUse ];

/// BA_FactUse
Property BAFactUse As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = BA_FactUse ];

/// BA_Price
Property BAPrice As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = BA_Price ];

/// BA_Amount
Property BAAmount As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = BA_Amount ];

/// BA_ProfitLossAmount
Property BAProfitLossAmount As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = BA_ProfitLossAmount ];

/// BA_OriginalFee
Property BAOriginalFee As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = BA_OriginalFee ];

/// BA_Status
Property BAStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 14, SqlFieldName = BA_Status ];

/// BA_UserDR
Property BAUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BA_UserDR ];

/// BA_AuditUserDR
Property BAAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BA_AuditUserDR ];

/// BA_AuditDate
Property BAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = BA_AuditDate ];

/// BA_ProfitRate
Property BAProfitRate As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = BA_ProfitRate ];

/// BA_Remark
Property BARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BA_Remark ];

/// BA_Hold1
Property BAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BA_Hold1 ];

/// BA_Hold2
Property BAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = BA_Hold2 ];

/// BA_Hold3
Property BAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = BA_Hold3 ];

/// BA_Hold4
Property BAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = BA_Hold4 ];

/// BA_Hold5
Property BAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = BA_Hold5 ];

/// BA_ManagerLocDR
Property BAManagerLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = BA_ManagerLocDR ];

/// BA_OutTotalFee
Property BAOutTotalFee As %Library.Float [ SqlColumnNumber = 26, SqlFieldName = BA_OutTotalFee ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBenefitAnaly("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BA_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BA_CTLocDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BA_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BA_FactUse">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="BA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="BA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="BA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="BA_InDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BA_ManagerLocDR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="BA_Month">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BA_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BA_OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BA_OutTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="BA_PlanUse">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BA_Price">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BA_ProfitLossAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BA_ProfitRate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BA_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BA_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BA_Year">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQBenefitAnaly</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEQBenefitAnaly</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BA_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BA_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQBenefitAnaly</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BA_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquipYearMonth">
<Global>^DHCEQBenefitAnaly</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EquipYearMonth"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BA_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BA_Year}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BA_Month}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCEQBenefitAnaly</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BA_CTLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexManagerLoc">
<Global>^DHCEQBenefitAnaly</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ManagerLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BA_ManagerLocDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQBenefitAnaly</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BA_InDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BA_No}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBenefitAnalyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

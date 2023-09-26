/// CTOR: QP
/// DATE: 2020-07-15
/// DESC: 化疗项目调整比例记录表
Class User.ChemoPlanItemAdj Extends %Persistent [ SqlTableName = Chemo_PlanItemAdj, StorageStrategy = SQLStorage ]
{

/// 医嘱项目
Property PIAItem As User.ChemoPlanItem [ SqlColumnNumber = 2, SqlFieldName = PIA_Item ];

/// 调整比例
Property PIAPercent As %String [ SqlColumnNumber = 3, SqlFieldName = PIA_Percent ];

/// 调整时的BSA
Property PIABSA As %String [ SqlColumnNumber = 4, SqlFieldName = PIA_BSA ];

/// 调整时的GFR
Property PIAGFR As %String [ SqlColumnNumber = 5, SqlFieldName = PIA_GFR ];

/// 调整时的SC
Property PIASC As %String [ SqlColumnNumber = 6, SqlFieldName = PIA_SC ];

/// 调整时的身高
Property PIAHeight As %String [ SqlColumnNumber = 7, SqlFieldName = PIA_Height ];

/// 调整时的体重
Property PIAWeight As %String [ SqlColumnNumber = 8, SqlFieldName = PIA_Weight ];

/// 计算公式
Property PIAFormula As %String [ SqlColumnNumber = 9, SqlFieldName = PIA_Formula ];

/// 标准值
Property PIABSAUnitSTD As %String [ SqlColumnNumber = 10, SqlFieldName = PIA_BSAUnitSTD ];

/// 调整后的标准值
Property PIABSAUnit As %String [ SqlColumnNumber = 11, SqlFieldName = PIA_BSAUnit ];

/// 调整后的剂量值
Property PIAFinalDose As %String [ SqlColumnNumber = 12, SqlFieldName = PIA_FinalDose ];

/// 药品
Property PIAArcim As User.ARCItmMast [ SqlColumnNumber = 13, SqlFieldName = PIA_Arcim ];

/// 调整人
Property PIAUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = PIA_User ];

/// 调整科室
Property PIALoc As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = PIA_Loc ];

/// 调整日期
Property PIADate As %Date [ SqlColumnNumber = 16, SqlFieldName = PIA_Date ];

/// 调整时间
Property PIATime As %Time [ SqlColumnNumber = 17, SqlFieldName = PIA_Time ];

/// 调整原因
Property PIAReason As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PIA_Reason ];

/// PLID
Property PIAPLID As User.ChemoPlan [ SqlColumnNumber = 19, SqlFieldName = PIA_PLID ];

/// 理想体重
Property PIAIBW As %String [ SqlColumnNumber = 20, SqlFieldName = PIA_IBW ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.DOC.Chemo.Count("User.ChemoPlanItemAdj"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PIA_Arcim">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PIA_BSA">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PIA_BSAUnit">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PIA_BSAUnitSTD">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PIA_Date">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PIA_FinalDose">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PIA_Formula">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PIA_GFR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PIA_Height">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PIA_IBW">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PIA_Item">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PIA_Loc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PIA_PLID">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PIA_Percent">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PIA_Reason">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PIA_SC">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PIA_Time">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PIA_User">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PIA_Weight">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanItemAdjD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PIA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PIA_ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxArcim">
<Global>^BS.DOC.Chemo.PlanItemAdjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Arcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIA_Arcim}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIA_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxItem">
<Global>^BS.DOC.Chemo.PlanItemAdjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Item"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIA_Item}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIA_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxItemArcim">
<Global>^BS.DOC.Chemo.PlanItemAdjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PIA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ItemArcim"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIA_Item}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIA_Arcim}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PIA_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxPLID">
<Global>^BS.DOC.Chemo.PlanItemAdjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PIA_ID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PLID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PIA_PLID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PIA_ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PIA_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanItemAdjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

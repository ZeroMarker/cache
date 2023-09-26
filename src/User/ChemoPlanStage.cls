/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 化疗周期
Class User.ChemoPlanStage Extends %Persistent [ SqlTableName = Chemo_PlanStage, StorageStrategy = SQLStorage ]
{

Relationship ChildGroup As User.ChemoPlanGroup [ Cardinality = children, Inverse = PGParref ];

Relationship PSParRef As User.ChemoPlan [ Cardinality = parent, Inverse = ChildDetail, Required, SqlFieldName = PS_ParRef ];

Index RowIDBasedIDKeyIndex On PSChildSub [ IdKey, PrimaryKey, Unique ];

/// PS_ChildSub
Property PSChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.Plan(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PS_ChildSub ];

/// 阶段代码
Property PSStage As %String [ SqlColumnNumber = 3, SqlFieldName = PS_Stage ];

/// 阶段描述
Property PSDesc As %String [ SqlColumnNumber = 4, SqlFieldName = PS_Desc ];

/// 阶段开始日期
Property PSStartDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PS_StartDate ];

/// 阶段结束日期
Property PSEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PS_EndDate ];

/// 是否签署知情同意书（1已签，2未签）
Property PSAgreeForm As %String [ SqlColumnNumber = 7, SqlFieldName = PS_AgreeForm ];

/// 有无过敏史(1/0)
Property PSHasGMis As %String [ SqlColumnNumber = 8, SqlFieldName = PS_HasGMis ];

/// 上次化疗效果评价
Property PSTreatType As %String [ SqlColumnNumber = 9, SqlFieldName = PS_TreatType ];

/// 体表面积
Property PSBSA As %String [ SqlColumnNumber = 10, SqlFieldName = PS_BSA ];

/// 不良反应
Property PSEffect As %String [ SqlColumnNumber = 11, SqlFieldName = PS_Effect ];

/// 是否确认过过敏史(1/0)
Property PSGMisOK As %String [ SqlColumnNumber = 12, SqlFieldName = PS_GMisOK ];

/// 过过敏史确认者
Property PSOKUser As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = PS_OKUser ];

/// 过过敏史确认日期
Property PSOKDate As %Date [ SqlColumnNumber = 14, SqlFieldName = PS_OKDate ];

/// 过过敏史确认时间
Property PSOKTime As %Time [ SqlColumnNumber = 15, SqlFieldName = PS_OKTime ];

/// 化疗模板阶段指征
Property PSTplStage As User.ChemoTemplateStage [ SqlColumnNumber = 16, SqlFieldName = PS_TplStage ];

/// 癌症分期
Property PSCancerStage As %String [ SqlColumnNumber = 17, SqlFieldName = PS_CancerStage ];

/// 血清肌酸酐
Property PSSC As %String [ SqlColumnNumber = 18, SqlFieldName = PS_SC ];

/// 过敏史记录
Property PSGMisFill As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = PS_GMisFill ];

/// 其他记录
Property PSOhterFill As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = PS_OhterFill ];

/// 预估时长
Property PSPlanTime As %String [ SqlColumnNumber = 21, SqlFieldName = PS_PlanTime ];

/// 周期数
Property PSNextNum As %String [ SqlColumnNumber = 22, SqlFieldName = PS_NextNum ];

/// 化疗日期
Property PSChemoDate As %String(COLLATION = "Exact", MAXLEN = 10000, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = PS_ChemoDate ];

/// 是否按时（1按时,2推迟）
Property PSOnTime As %String [ SqlColumnNumber = 24, SqlFieldName = PS_OnTime ];

/// 推迟原因
Property PSDelayReason As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = PS_DelayReason ];

/// 治疗类别(1新辅助，2辅助，3转移，4复发，5其他)
Property PSTreatTypeNew As %String [ SqlColumnNumber = 26, SqlFieldName = PS_TreatTypeNew ];

/// 主药信息
Property PSMainDrugInfo As %String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = PS_MainDrugInfo ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PS_AgreeForm">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PS_BSA">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PS_CancerStage">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PS_ChemoDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PS_DelayReason">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PS_Effect">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PS_GMisFill">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PS_GMisOK">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PS_HasGMis">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PS_MainDrugInfo">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PS_NextNum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PS_OKDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PS_OKTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PS_OKUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PS_OhterFill">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PS_OnTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PS_PlanTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PS_SC">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PS_Stage">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PS_TplStage">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PS_TreatType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PS_TreatTypeNew">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_Plan.PL_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PS_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxStage">
<Global>^BS.DOC.Chemo.PlanI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Chemo_Plan.PL_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PS_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanStage"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Stage"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Chemo_Plan.PL_ID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PS_Stage}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PS_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PS_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanStageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

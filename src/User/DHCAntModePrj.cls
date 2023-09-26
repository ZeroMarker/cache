/// CTOR: QP
/// DATE: 2019-04-30
/// DESC: 抗菌药物项目本地化的扩展表
Class User.DHCAntModePrj Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHCAnt_ModePrj, StorageStrategy = SQLStorage ]
{

/// MPRJ_AimDr
Property AimDr As User.DHCAntUsePurpose [ SqlColumnNumber = 2, SqlFieldName = MPRJ_AimDr ];

/// MPRJ_ApplyDr
Property ApplyDr As User.DHCDocAntibioticApply [ SqlColumnNumber = 3, SqlFieldName = MPRJ_ApplyDr ];

/// MPRJ_HasGMis 有无过敏(1有,0无)
Property HasGMis As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MPRJ_HasGMis ];

/// MPRJ_GMDrug 过敏药物
Property GMDrug As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MPRJ_GMDrug ];

/// MPRJ_GMClassify 过敏分类
Property GMClassify As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MPRJ_GMClassify ];

/// MPRJ_T
Property T As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MPRJ_T ];

/// MPRJ_WBC
Property WBC As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MPRJ_WBC ];

/// MPRJ_N
Property N As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MPRJ_N ];

/// MPRJ_CRP
Property CRP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MPRJ_CRP ];

/// MPRJ_PCT
Property PCT As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MPRJ_PCT ];

/// MPRJ_G
Property G As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MPRJ_G ];

/// MPRJ_GM
Property GM As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MPRJ_GM ];

/// MPRJ_GRQT 感染其他
Property GRQT As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MPRJ_GRQT ];

/// MPRJ_HasBYX 是否做过病原学检查
Property HasBYX As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MPRJ_HasBYX ];

/// MPRJ_BYXResult 病原学结果
Property BYXResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MPRJ_BYXResult ];

/// MPRJ_HasCombined 是否联用
Property HasCombined As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = MPRJ_HasCombined ];

/// MPRJ_CombinedDrug 联用药品通用名
Property CombinedDrug As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = MPRJ_CombinedDrug ];

/// MPRJ_CombinedReason 联用理由
Property CombinedReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = MPRJ_CombinedReason ];

/// MPRJ_JL 单次剂量
Property JL As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = MPRJ_JL ];

/// MPRJ_Freq 频次
Property Freq As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = MPRJ_Freq ];

/// MPRJ_DrugReason 药品品种选择理由
Property DrugReason As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = MPRJ_DrugReason ];

/// MPRJ_Instruc 用法
Property Instruc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MPRJ_Instruc ];

/// MPRJ_JLUom 单次剂量单位
Property JLUom As User.CTUOM [ SqlColumnNumber = 24, SqlFieldName = MPRJ_JLUom ];

/// MPRJ_Prior 医嘱类型
Property Prior As User.OECPriority [ SqlColumnNumber = 25, SqlFieldName = MPRJ_Prior ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.ANT.DHCAntModePrjD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MPRJ_AimDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MPRJ_ApplyDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MPRJ_BYXResult">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MPRJ_CRP">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MPRJ_CombinedDrug">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MPRJ_CombinedReason">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MPRJ_DrugReason">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MPRJ_Freq">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MPRJ_G">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MPRJ_GM">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MPRJ_GMClassify">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MPRJ_GMDrug">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MPRJ_GRQT">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MPRJ_HasBYX">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MPRJ_HasCombined">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MPRJ_HasGMis">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MPRJ_Instruc">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MPRJ_JL">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MPRJ_JLUom">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MPRJ_N">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MPRJ_PCT">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MPRJ_Prior">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MPRJ_T">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MPRJ_WBC">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^BS.ANT.DHCAntModePrjD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MPRJ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MPRJ_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAimDr">
<Global>^BS.ANT.DHCAntModePrjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MPRJ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AimDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MPRJ_AimDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MPRJ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApplyDr">
<Global>^BS.ANT.DHCAntModePrjI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MPRJ_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ApplyDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MPRJ_ApplyDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MPRJ_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MPRJ_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAntModePrjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

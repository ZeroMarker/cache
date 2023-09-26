/// UnitResultDetail
Class dhc.pa.data.UnitResultDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UnitResultDetail_rowid, SqlTableName = UnitResultDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On UnitResultDetailchildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildURDetailAdd As dhc.pa.data.URDetailAdd [ Cardinality = children, Inverse = URDetailAddparRef ];

Relationship ChildURDetailDist As dhc.pa.data.URDetailDist [ Cardinality = children, Inverse = URDetailDistparRef ];

/// UnitResultDetail_parRef
Relationship UnitResultDetailparRef As dhc.pa.data.UnitResult [ Cardinality = parent, Inverse = ChildUnitResultDetail, Required, SqlFieldName = UnitResultDetail_parRef ];

/// UnitResultDetail_childSub
Property UnitResultDetailchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),"||"),"UnitResult",$p(%d(0),"||",2),"URDetail",0))}, SqlColumnNumber = 2, SqlFieldName = UnitResultDetail_childSub ];

/// UnitResultDetail_sDetailDr
Property UnitResultDetailsDetailDr As dhc.pa.data.SchemDetail [ SqlColumnNumber = 3, SqlFieldName = UnitResultDetail_sDetailDr ];

/// UnitResultDetail_KPIDr
Property UnitResultDetailKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 4, SqlFieldName = UnitResultDetail_KPIDr ];

/// UnitResultDetail_order
Property UnitResultDetailorder As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = UnitResultDetail_order ];

/// UnitResultDetail_isTarget
Property UnitResultDetailisTarget As %Library.Float(SELECTIVITY = "33.3333%") [ SqlColumnNumber = 6, SqlFieldName = UnitResultDetail_isTarget ];

/// UnitResultDetail_baseValue
Property UnitResultDetailbaseValue As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = UnitResultDetail_baseValue ];

/// UnitResultDetail_tValue
Property UnitResultDetailtValue As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = UnitResultDetail_tValue ];

/// UnitResultDetail_bValue
Property UnitResultDetailbValue As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = UnitResultDetail_bValue ];

/// UnitResultDetail_tValueUp
Property UnitResultDetailtValueUp As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = UnitResultDetail_tValueUp ];

/// UnitResultDetail_bValueUp
Property UnitResultDetailbValueUp As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = UnitResultDetail_bValueUp ];

/// UnitResultDetail_rate
Property UnitResultDetailrate As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = UnitResultDetail_rate ];

/// 实际值
Property UnitResultDetailactValue As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = UnitResultDetail_actValue ];

/// 明细计算得分
Property UnitResultDetailscore As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = UnitResultDetail_score ];

/// UnitResultDetail_lastValue
Property UnitResultDetaillastValue As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = UnitResultDetail_lastValue ];

/// UnitResultDetail_distRate
Property UnitResultDetaildistRate As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = UnitResultDetail_distRate ];

/// UnitResultDetail_flag
Property UnitResultDetailflag As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = UnitResultDetail_flag ];

/// UnitResultDetail_estDesc
Property UnitResultDetailestDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = UnitResultDetail_estDesc ];

/// UnitResultDetail_estUserDr
Property UnitResultDetailestUserDr As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = UnitResultDetail_estUserDr ];

/// UnitResultDetail_estAUserDr
Property UnitResultDetailestAUserDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = UnitResultDetail_estAUserDr ];

/// UnitResultDetail_estADate
Property UnitResultDetailestADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = UnitResultDetail_estADate ];

/// UnitResultDetail_fBDesc
Property UnitResultDetailfBDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = UnitResultDetail_fBDesc ];

/// UnitResultDetail_fBUserDr
Property UnitResultDetailfBUserDr As User.SSUser [ SqlColumnNumber = 23, SqlFieldName = UnitResultDetail_fBUserDr ];

/// UnitResultDetail_estDate
Property UnitResultDetailestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = UnitResultDetail_estDate ];

/// UnitResultDetail_fBDate
Property UnitResultDetailfBDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = UnitResultDetail_fBDate ];

/// UnitResultDetail_isSubmit
Property UnitResultDetailisSubmit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = UnitResultDetail_isSubmit ];

/// UnitResultDetail_parent
Property UnitResultDetailparent As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = UnitResultDetail_parent ];

/// UnitResultDetail_distMethodDr
Property UnitResultDetaildistMethodDr As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = UnitResultDetail_distMethodDr ];

/// 明细最终得分
Property UnitResultDetailRscore As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = UnitResultDetail_Rscore ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="UnitResultDetail_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="UnitResultDetail_Rscore">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="UnitResultDetail_actValue">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="UnitResultDetail_bValue">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UnitResultDetail_bValueUp">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UnitResultDetail_baseValue">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UnitResultDetail_distMethodDr">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="UnitResultDetail_distRate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UnitResultDetail_estADate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="UnitResultDetail_estAUserDr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UnitResultDetail_estDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="UnitResultDetail_estDesc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="UnitResultDetail_estUserDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UnitResultDetail_fBDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="UnitResultDetail_fBDesc">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="UnitResultDetail_fBUserDr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="UnitResultDetail_flag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UnitResultDetail_isSubmit">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="UnitResultDetail_isTarget">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UnitResultDetail_lastValue">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UnitResultDetail_order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UnitResultDetail_parent">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="UnitResultDetail_rate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="UnitResultDetail_sDetailDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UnitResultDetail_score">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UnitResultDetail_tValue">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UnitResultDetail_tValueUp">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCCJXPASTRATAGEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>UnitResult.UnitResult_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>UnitResultDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URDetail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResultDetail_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParent">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>UnitResult.UnitResult_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>UnitResultDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URDParent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResultDetail_parent}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitResultDetail_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecord">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>UnitResult.UnitResult_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>UnitResultDetail_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"URDetailRecord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UnitResult.UnitResult_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UnitResultDetail_sDetailDr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{UnitResultDetail_KPIDr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{UnitResultDetail_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.UnitResultDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class dhc.ca.cache.data.DeptCostDetial Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptCostDetial_rowid, SqlTableName = DeptCostDetial, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DeptCostDetialchildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistSets Parent Reference
Relationship DeptCostDetialparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildDeptCostDetial, Required, SqlFieldName = DeptCostDetial_parRef ];

/// DeptCostDetial_childSub
Property DeptCostDetialchildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"DeptCostDetial",0))}, SqlColumnNumber = 2, SqlFieldName = DeptCostDetial_childSub ];

/// DeptCostDetial_intervalDr
Property DeptCostDetialintervalDr As dhc.ca.cache.data.AccountMonths [ SqlColumnNumber = 3, SqlFieldName = DeptCostDetial_intervalDr ];

/// DeptCostDetial_deptDr
Property DeptCostDetialdeptDr As dhc.ca.cache.data.UnitDepts [ SqlColumnNumber = 4, SqlFieldName = DeptCostDetial_deptDr ];

/// DeptCostDetial_budgCost
Property DeptCostDetialbudgCost As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DeptCostDetial_budgCost ];

/// DeptCostDetial_primeCost
Property DeptCostDetialprimeCost As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DeptCostDetial_primeCost ];

/// DeptCostDetial_allocCost1
Property DeptCostDetialallocCost1 As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DeptCostDetial_allocCost1 ];

/// DeptCostDetial_allocCost2
Property DeptCostDetialallocCost2 As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DeptCostDetial_allocCost2 ];

/// DeptCostDetial_allocCost3
Property DeptCostDetialallocCost3 As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DeptCostDetial_allocCost3 ];

/// DeptCostDetial_allocCost4
Property DeptCostDetialallocCost4 As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DeptCostDetial_allocCost4 ];

/// DeptCostDetial_allocCost5
Property DeptCostDetialallocCost5 As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = DeptCostDetial_allocCost5 ];

/// DeptCostDetial_allocCost6
Property DeptCostDetialallocCost6 As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DeptCostDetial_allocCost6 ];

/// DeptCostDetial_allocCost7
Property DeptCostDetialallocCost7 As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = DeptCostDetial_allocCost7 ];

/// DeptCostDetial_allocCost8
Property DeptCostDetialallocCost8 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DeptCostDetial_allocCost8 ];

/// DeptCostDetial_costVari
Property DeptCostDetialcostVari As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DeptCostDetial_costVari ];

/// DeptCostDetial_costFix
Property DeptCostDetialcostFix As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DeptCostDetial_costFix ];

/// DeptCostDetial_costCtrl
Property DeptCostDetialcostCtrl As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DeptCostDetial_costCtrl ];

/// DeptCostDetial_costCtrlN
Property DeptCostDetialcostCtrlN As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = DeptCostDetial_costCtrlN ];

/// DeptCostDetial_costPer
Property DeptCostDetialcostPer As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = DeptCostDetial_costPer ];

/// DeptCostDetial_costMate
Property DeptCostDetialcostMate As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = DeptCostDetial_costMate ];

/// DeptCostDetial_costDrug
Property DeptCostDetialcostDrug As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = DeptCostDetial_costDrug ];

/// DeptCostDetial_costRetire
Property DeptCostDetialcostRetire As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = DeptCostDetial_costRetire ];

/// DeptCostDetial_costMan
Property DeptCostDetialcostMan As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = DeptCostDetial_costMan ];

/// DeptCostDetial_costT
Property DeptCostDetialcostT As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = DeptCostDetial_costT ];

/// DeptCostDetial_costD
Property DeptCostDetialcostD As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = DeptCostDetial_costD ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DeptCostDetial_allocCost1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DeptCostDetial_allocCost2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DeptCostDetial_allocCost3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DeptCostDetial_allocCost4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DeptCostDetial_allocCost5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DeptCostDetial_allocCost6">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DeptCostDetial_allocCost7">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DeptCostDetial_allocCost8">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DeptCostDetial_budgCost">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DeptCostDetial_costCtrl">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DeptCostDetial_costCtrlN">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DeptCostDetial_costD">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DeptCostDetial_costDrug">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DeptCostDetial_costFix">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DeptCostDetial_costMan">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DeptCostDetial_costMate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DeptCostDetial_costPer">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DeptCostDetial_costRetire">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DeptCostDetial_costT">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DeptCostDetial_costVari">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DeptCostDetial_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DeptCostDetial_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DeptCostDetial_primeCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DeptCostDetial_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptCostDetail"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptCostDetial_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache60B.DeptCostDetialS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

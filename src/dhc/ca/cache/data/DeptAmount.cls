Class dhc.ca.cache.data.DeptAmount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DeptAmount_rowid, SqlTableName = DeptAmount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DeptAmountchildSub [ IdKey, PrimaryKey, Unique ];

/// CostDistSets Parent Reference
Relationship DeptAmountparRef As dhc.ca.cache.data.CostDistSets [ Cardinality = parent, Inverse = ChildDeptAmount, Required, SqlFieldName = DeptAmount_parRef ];

/// DeptAmount_childSub
Property DeptAmountchildSub As %Library.Float [ InitialExpression = {$i(^DHCCACOSTDISTSETS($p(%d(0),$c(1),1),"DeptAmount",0))}, SqlColumnNumber = 3, SqlFieldName = DeptAmount_childSub ];

/// DeptAmount_intervalDr
Property DeptAmountintervalDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DeptAmount_intervalDr ];

/// DeptAmount_deptDr_
Property DeptAmountdeptDr As %Library.String(COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DeptAmount_deptDr ];

/// DeptAmount_fDeptIncome
Property DeptAmountfDeptIncome As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DeptAmount_fDeptIncome ];

/// DeptAmount_tDeptIncome
Property DeptAmounttDeptIncome As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DeptAmount_tDeptIncome ];

/// DeptAmount_ownIncome
Property DeptAmountownIncome As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DeptAmount_ownIncome ];

/// DeptAmount_mIncome
Property DeptAmountmIncome As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DeptAmount_mIncome ];

/// DeptAmount_pIncome
Property DeptAmountpIncome As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DeptAmount_pIncome ];

/// DeptAmount_sIncome
Property DeptAmountsIncome As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = DeptAmount_sIncome ];

/// DeptAmount_testing_
Property DeptAmounttesting As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DeptAmount_testing ];

/// DeptAmount_outp
Property DeptAmountoutp As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = DeptAmount_outp ];

/// DeptAmount_beds
Property DeptAmountbeds As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DeptAmount_beds ];

/// DeptAmount_outPer
Property DeptAmountoutPer As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DeptAmount_outPer ];

/// DeptAmount_tech
Property DeptAmounttech As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DeptAmount_tech ];

/// DeptAmount_emp
Property DeptAmountemp As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DeptAmount_emp ];

/// DeptAmount_bedRate
Property DeptAmountbedRate As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = DeptAmount_bedRate ];

/// DeptAmount_fin
Property DeptAmountfin As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = DeptAmount_fin ];

/// DeptAmount_hs
Property DeptAmounths As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = DeptAmount_hs ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="DeptAmount_bedRate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DeptAmount_beds">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DeptAmount_deptDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DeptAmount_emp">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DeptAmount_fDeptIncome">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DeptAmount_fin">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DeptAmount_hs">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DeptAmount_intervalDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DeptAmount_mIncome">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DeptAmount_outPer">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DeptAmount_outp">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DeptAmount_ownIncome">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DeptAmount_pIncome">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DeptAmount_sIncome">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DeptAmount_tDeptIncome">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DeptAmount_tech">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DeptAmount_testing">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCCACOSTDISTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CostDistSets.CostDistSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DeptAmount_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CostDistSets.CostDistSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DeptAmount"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DeptAmount_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache.data.DeptAmountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

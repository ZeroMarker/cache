Class User.DHCEQBudgetUsed Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQBudgetUsed, StorageStrategy = SQLStorage ]
{

/// BU_BudgetDR
Property BUBudgetDR As DHCEQBudget [ SqlColumnNumber = 2, SqlFieldName = BU_BudgetDR ];

/// BU_SourceType
Property BUSourceType As %String(DISPLAYLIST = ",入库明细,合同,验收,调账,保养,检查,维修,保修合同,工程款", MAXLEN = 4, VALUELIST = ",1,2,3,4,5,6,7,8,10") [ SqlColumnNumber = 3, SqlFieldName = BU_SourceType ];

/// BU_SourceID
Property BUSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BU_SourceID ];

/// BU_UsedAmount
Property BUUsedAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = BU_UsedAmount ];

/// BU_Status
Property BUStatus As %String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 6, SqlFieldName = BU_Status ];

/// BU_AddUserDR
Property BUAddUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BU_AddUserDR ];

/// BU_AddDate
Property BUAddDate As %Date [ SqlColumnNumber = 8, SqlFieldName = BU_AddDate ];

/// BU_AddTime
Property BUAddTime As %Time [ SqlColumnNumber = 9, SqlFieldName = BU_AddTime ];

/// BU_AuditUserDR
Property BUAuditUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BU_AuditUserDR ];

/// BU_AuditDate
Property BUAuditDate As %Date [ SqlColumnNumber = 11, SqlFieldName = BU_AuditDate ];

/// BU_AuditTime
Property BUAuditTime As %Time [ SqlColumnNumber = 12, SqlFieldName = BU_AuditTime ];

/// BU_CancelUserDR
Property BUCancelUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = BU_CancelUserDR ];

/// BU_CancelDate
Property BUCancelDate As %Date [ SqlColumnNumber = 14, SqlFieldName = BU_CancelDate ];

/// BU_CancelTime
Property BUCancelTime As %Time [ SqlColumnNumber = 15, SqlFieldName = BU_CancelTime ];

/// BU_Hold1
Property BUHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BU_Hold1 ];

/// BU_Hold2
Property BUHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BU_Hold2 ];

/// BU_Hold3
Property BUHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BU_Hold3 ];

/// BU_Hold4
Property BUHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = BU_Hold4 ];

/// BU_Hold5
Property BUHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = BU_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQBudgetUsed("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BU_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BU_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BU_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BU_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BU_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BU_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BU_BudgetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BU_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BU_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BU_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BU_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BU_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BU_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BU_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="BU_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="BU_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BU_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BU_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BU_UsedAmount">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQBudgetUsed</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBudget">
<Global>^DHCEQBudgetUsed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Budget"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BU_BudgetDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQBudgetUsed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BU_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BU_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BU_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BU_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQBudgetUsedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

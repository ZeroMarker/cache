Class User.DHCEQInventoryPlan Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IP_RowID, SqlTableName = DHC_EQInventoryPlan, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index IPDescUnqIdx1 On IPDesc [ Unique ];

/// IP_AddDate
Property IPAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = IP_AddDate ];

/// IP_AddUserDR
Property IPAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IP_AddUserDR ];

/// IP_Remark
Property IPRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = IP_Remark ];

/// IP_Hold1
Property IPHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = IP_Hold1 ];

/// IP_Hold2
Property IPHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = IP_Hold2 ];

/// IP_Hold3
Property IPHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = IP_Hold3 ];

/// IP_Hold4
Property IPHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = IP_Hold4 ];

/// IP_Hold5
Property IPHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = IP_Hold5 ];

/// IP_InvalidFlag
Property IPInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = IP_InvalidFlag ];

/// IP_Desc
Property IPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IP_Desc ];

/// IP_Code
Property IPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IP_Code ];

/// IP_PlanStatus
Property IPPlanStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 4, SqlFieldName = IP_PlanStatus ];

/// IP_StartDate
Property IPStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = IP_StartDate ];

/// IP_EndDate
Property IPEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = IP_EndDate ];

/// IP_UpdateDate
Property IPUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = IP_UpdateDate ];

/// IP_UpdateUserDR
Property IPUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IP_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQInventoryPlan("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IP_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IP_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IP_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IP_PlanStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IP_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IP_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQInventoryPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQInventoryPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IP_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEQInventoryPlan</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IP_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQInventoryPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

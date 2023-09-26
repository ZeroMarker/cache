Class User.DHCEQQMatter Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MT_RowID, SqlTableName = DHC_EQQMatter, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MT_ModuleDR
Property MTModuleDR As User.DHCEQQModule [ SqlColumnNumber = 2, SqlFieldName = MT_ModuleDR ];

/// MT_FunctionDR
Property MTFunctionDR As User.DHCEQQFunction [ SqlColumnNumber = 3, SqlFieldName = MT_FunctionDR ];

/// MT_MatterDesc
Property MTMatterDesc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MT_MatterDesc ];

/// MT_TypeDR
Property MTTypeDR As User.DHCEQQType [ SqlColumnNumber = 5, SqlFieldName = MT_TypeDR ];

/// MT_Status
Property MTStatus As %Library.String(DISPLAYLIST = ",激活,分配,受理,解决,关闭,搁置", MAXLEN = 3, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5") [ SqlColumnNumber = 6, SqlFieldName = MT_Status ];

/// MT_BringDate
Property MTBringDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MT_BringDate ];

/// MT_BringTime
Property MTBringTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MT_BringTime ];

/// MT_BringUserDR
Property MTBringUserDR As User.DHCEQQUser [ SqlColumnNumber = 9, SqlFieldName = MT_BringUserDR ];

/// MT_SolveDate
Property MTSolveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = MT_SolveDate ];

/// MT_SolveTime
Property MTSolveTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = MT_SolveTime ];

/// MT_SolveUserDR
Property MTSolveUserDR As User.DHCEQQUser [ SqlColumnNumber = 12, SqlFieldName = MT_SolveUserDR ];

/// MT_DutyUserDR
Property MTDutyUserDR As User.DHCEQQUser [ SqlColumnNumber = 13, SqlFieldName = MT_DutyUserDR ];

/// MT_SolveMethod
Property MTSolveMethod As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MT_SolveMethod ];

/// MT_SolveReason
Property MTSolveReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MT_SolveReason ];

/// MT_CloseUserDR
Property MTCloseUserDR As User.DHCEQQUser [ SqlColumnNumber = 16, SqlFieldName = MT_CloseUserDR ];

/// MT_CloseDate
Property MTCloseDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = MT_CloseDate ];

/// MT_CloseTime
Property MTCloseTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = MT_CloseTime ];

/// MT_CustormDR
Property MTCustormDR As User.DHCEQQCustorm [ SqlColumnNumber = 19, SqlFieldName = MT_CustormDR ];

/// MT_AssignDate
Property MTAssignDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = MT_AssignDate ];

/// MT_AssignTime
Property MTAssignTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = MT_AssignTime ];

/// MT_AcceptDate
Property MTAcceptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = MT_AcceptDate ];

/// MT_AcceptTime
Property MTAcceptTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = MT_AcceptTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQQ("DHCEQQMatter",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MT_AcceptDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MT_AcceptTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MT_AssignDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MT_AssignTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MT_BringDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MT_BringTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MT_BringUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MT_CloseDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MT_CloseTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MT_CloseUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MT_CustormDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MT_DutyUserDR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MT_FunctionDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MT_MatterDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MT_ModuleDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MT_SolveDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MT_SolveMethod">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MT_SolveReason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MT_SolveTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MT_SolveUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MT_Status">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MT_TypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQQ</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQQMatter"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MT_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQQMatterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEQDataChangeRequest Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCR_RowID, SqlTableName = DHC_EQDataChangeRequest, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCR_TableName
Property DCRTableName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DCR_TableName ];

/// DCR_ClassName
Property DCRClassName As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DCR_ClassName ];

/// DCR_BussID
Property DCRBussID As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DCR_BussID ];

/// DCR_UpdateUserDR
Property DCRUpdateUserDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DCR_UpdateUserDR ];

/// DCR_UpdateDate
Property DCRUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DCR_UpdateDate ];

/// DCR_UpdateTime
Property DCRUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DCR_UpdateTime ];

/// DCR_OperateType
Property DCROperateType As %Library.String(DISPLAYLIST = ",Add,Update,Delete", VALUELIST = ",A,U,D") [ SqlColumnNumber = 8, SqlFieldName = DCR_OperateType ];

/// DCR_OldValue
Property DCROldValue As %Library.String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = DCR_OldValue ];

/// DCR_NewValue
Property DCRNewValue As %Library.String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = DCR_NewValue ];

/// DCR_AuditUserDR
Property DCRAuditUserDR As %Library.String [ SqlColumnNumber = 11, SqlFieldName = DCR_AuditUserDR ];

/// DCR_AuditDate
Property DCRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DCR_AuditDate ];

/// DCR_AuditTime
Property DCRAuditTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DCR_AuditTime ];

/// DCR_Status
Property DCRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", VALUELIST = ",0,1,2") [ SqlColumnNumber = 14, SqlFieldName = DCR_Status ];

/// DCR_InvalidFlag
Property DCRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DCR_InvalidFlag ];

/// DCR_RequestNo
Property DCRRequestNo As %Library.String [ SqlColumnNumber = 16, SqlFieldName = DCR_RequestNo ];

/// DCR_SubmitUserDR
Property DCRSubmitUserDR As %Library.String [ SqlColumnNumber = 17, SqlFieldName = DCR_SubmitUserDR ];

/// DCR_SubmitDate
Property DCRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = DCR_SubmitDate ];

/// DCR_SubmitTime
Property DCRSubmitTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = DCR_SubmitTime ];

/// DCR_Hold1
Property DCRHold1 As %Library.String [ SqlColumnNumber = 20, SqlFieldName = DCR_Hold1 ];

/// DCR_Hold2
Property DCRHold2 As %Library.String [ SqlColumnNumber = 21, SqlFieldName = DCR_Hold2 ];

/// DCR_Hold3
Property DCRHold3 As %Library.String [ SqlColumnNumber = 22, SqlFieldName = DCR_Hold3 ];

/// DCR_Hold4
Property DCRHold4 As %Library.String [ SqlColumnNumber = 23, SqlFieldName = DCR_Hold4 ];

/// DCR_Hold5
Property DCRHold5 As %Library.String [ SqlColumnNumber = 24, SqlFieldName = DCR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDataChangeRequest("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DCR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCR_BussID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCR_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DCR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DCR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DCR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DCR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DCR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DCR_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCR_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCR_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCR_RequestNo">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DCR_Status">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DCR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DCR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DCR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DCR_TableName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQDataChangeRequest</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DCR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTableName">
<Global>^DHCEQDataChangeRequest</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TableName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCR_TableName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCR_BussID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDataChangeRequestS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

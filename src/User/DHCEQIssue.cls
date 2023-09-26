Class User.DHCEQIssue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = I_RowID, SqlTableName = DHC_EQIssue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// I_No
Property INo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = I_No ];

/// I_Name
Property IName As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = I_Name ];

/// I_ShortName
Property IShortName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = I_ShortName ];

/// I_Content
Property IContent As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = I_Content ];

/// I_Purpose
Property IPurpose As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = I_Purpose ];

/// I_Master
Property IMaster As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = I_Master ];

/// I_RequestDate
Property IRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = I_RequestDate ];

/// I_RequestFee
Property IRequestFee As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = I_RequestFee ];

/// I_Dept
Property IDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = I_Dept ];

/// I_StartDate
Property IStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = I_StartDate ];

/// I_EndDate
Property IEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = I_EndDate ];

/// I_Status
Property IStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 13, SqlFieldName = I_Status ];

/// I_Remark
Property IRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = I_Remark ];

/// I_AddUserDR
Property IAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = I_AddUserDR ];

/// I_AddDate
Property IAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16, SqlFieldName = I_AddDate ];

/// I_AddTime
Property IAddTime As %Library.Time [ SqlColumnNumber = 17, SqlFieldName = I_AddTime ];

/// I_SubmitUserDR
Property ISubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = I_SubmitUserDR ];

/// I_SubmitDate
Property ISubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = I_SubmitDate ];

/// I_SubmitTime
Property ISubmitTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = I_SubmitTime ];

/// I_AuditUserDR
Property IAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = I_AuditUserDR ];

/// I_AuditDate
Property IAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = I_AuditDate ];

/// I_AuditTime
Property IAuditTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = I_AuditTime ];

/// I_CancelUserDR
Property ICancelUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = I_CancelUserDR ];

/// I_CancelDate
Property ICancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = I_CancelDate ];

/// I_CancelTime
Property ICancelTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = I_CancelTime ];

/// I_InvalidFlag
Property IInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = I_InvalidFlag ];

/// I_Hold1
Property IHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = I_Hold1 ];

/// I_Hold2
Property IHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = I_Hold2 ];

/// I_Hold3
Property IHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = I_Hold3 ];

/// I_Hold4
Property IHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = I_Hold4 ];

/// I_Hold5
Property IHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = I_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQIssue("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="I_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="I_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="I_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="I_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="I_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="I_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="I_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="I_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="I_CancelUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="I_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="I_Dept">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="I_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="I_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="I_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="I_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="I_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="I_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="I_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="I_Master">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="I_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="I_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="I_Purpose">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="I_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="I_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="I_RequestFee">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="I_ShortName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="I_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="I_Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="I_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="I_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="I_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DHCEQIssue</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>I_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{I_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQIssueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

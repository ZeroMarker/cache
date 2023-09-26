Class User.DHCEQDispatchVehicle Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DV_RowID, SqlTableName = DHC_EQDispatchVehicle, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DV_DispatchVehicleNo
Property DVDispatchVehicleNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DV_DispatchVehicleNo ];

/// DV_RequestDate
Property DVRequestDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DV_RequestDate ];

/// DV_Status
Property DVStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 4, SqlFieldName = DV_Status ];

/// DV_AddUserDR
Property DVAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DV_AddUserDR ];

/// DV_AddDate
Property DVAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DV_AddDate ];

/// DV_AddTime
Property DVAddTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DV_AddTime ];

/// DV_UpdateUserDR
Property DVUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DV_UpdateUserDR ];

/// DV_UpdateDate
Property DVUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DV_UpdateDate ];

/// DV_UpdateTime
Property DVUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DV_UpdateTime ];

/// DV_SubmitUserDR
Property DVSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DV_SubmitUserDR ];

/// DV_SubmitDate
Property DVSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DV_SubmitDate ];

/// DV_SubmitTime
Property DVSubmitTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DV_SubmitTime ];

/// DV_RequestUserDR
Property DVRequestUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DV_RequestUserDR ];

/// DV_UserName
Property DVUserName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DV_UserName ];

/// DV_RequestReason
Property DVRequestReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DV_RequestReason ];

/// DV_Arrive
Property DVArrive As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DV_Arrive ];

/// DV_DispatchDate
Property DVDispatchDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = DV_DispatchDate ];

/// DV_DispatchTime
Property DVDispatchTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = DV_DispatchTime ];

/// DV_PatchDate
Property DVPatchDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DV_PatchDate ];

/// DV_PatchTime
Property DVPatchTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DV_PatchTime ];

/// DV_Remark
Property DVRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DV_Remark ];

/// DV_CancelUser
Property DVCancelUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DV_CancelUser ];

/// DV_CancelDate
Property DVCancelDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = DV_CancelDate ];

/// DV_CancelTime
Property DVCancelTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = DV_CancelTime ];

/// DV_InvalidFlag
Property DVInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = DV_InvalidFlag ];

/// DV_Hold1
Property DVHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DV_Hold1 ];

/// DV_Hold2
Property DVHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = DV_Hold2 ];

/// DV_Hold3
Property DVHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DV_Hold3 ];

/// DV_Hold4
Property DVHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DV_Hold4 ];

/// DV_Hold5
Property DVHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = DV_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDispatchVehicle("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DV_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DV_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DV_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DV_Arrive">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DV_CancelDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DV_CancelTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DV_CancelUser">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DV_DispatchDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DV_DispatchTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DV_DispatchVehicleNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DV_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DV_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DV_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DV_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DV_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DV_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DV_PatchDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DV_PatchTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DV_Remark">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DV_RequestDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DV_RequestReason">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DV_RequestUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DV_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DV_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DV_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DV_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DV_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DV_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DV_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DV_UserName">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCEQDispatchVehicle</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DV_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DV_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDispatchVehicleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCEQSRentMaintMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RMM_RowID, SqlTableName = DHC_EQSRentMaintMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RMM_RentDR
Property RMMRentDR As User.DHCEQSRent [ SqlColumnNumber = 2, SqlFieldName = RMM_RentDR ];

/// RMM_Type
Property RMMType As %Library.String(DISPLAYLIST = ",维修,保养,质控,清洗消毒", MAXLEN = 3, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4") [ SqlColumnNumber = 3, SqlFieldName = RMM_Type ];

/// RMM_MaintReason
Property RMMMaintReason As %Library.String(DISPLAYLIST = ",科室原因,自然因素", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 4, SqlFieldName = RMM_MaintReason ];

/// RMM_BussID
Property RMMBussID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RMM_BussID ];

/// RMM_MaintContent
Property RMMMaintContent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RMM_MaintContent ];

/// RMM_ResultStatus
Property RMMResultStatus As %Library.String(DISPLAYLIST = ",完好,有缺陷,故障", MAXLEN = 4, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 7, SqlFieldName = RMM_ResultStatus ];

/// RMM_MaintResult
Property RMMMaintResult As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = RMM_MaintResult ];

/// RMM_AddUser
Property RMMAddUser As User.DHCEQCUser [ SqlColumnNumber = 9, SqlFieldName = RMM_AddUser ];

/// RMM_AddDate
Property RMMAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = RMM_AddDate ];

/// RMM_AddTime
Property RMMAddTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = RMM_AddTime ];

/// RMM_Status
Property RMMStatus As %Library.String(DISPLAYLIST = ",新建,提交,审核,作废", MAXLEN = 5, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 12, SqlFieldName = RMM_Status ];

/// RMM_Remark
Property RMMRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RMM_Remark ];

/// RMM_Hold1
Property RMMHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RMM_Hold1 ];

/// RMM_Hold2
Property RMMHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = RMM_Hold2 ];

/// RMM_Hold3
Property RMMHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = RMM_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQSRentMaintMap("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RMM_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RMM_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RMM_AddUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RMM_BussID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RMM_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RMM_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RMM_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RMM_MaintContent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RMM_MaintReason">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RMM_MaintResult">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RMM_Remark">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RMM_RentDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RMM_ResultStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RMM_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RMM_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQSRentMaintMap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RMM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RMM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSourceID">
<Global>^DHCEQSRentMaintMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RMM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Rent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RMM_RentDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RMM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQSRentMaintMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

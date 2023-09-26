Class User.DHCAutoHandlePurPlan Extends (%Persistent, User.Abstract) [ SqlRowIdName = AUTO_RowId, SqlTableName = DHC_AutoHandlePurPlan, StorageStrategy = SqlStorage ]
{

Property AUTOCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = AUTO_CTLOC_DR ];

Property AUTOExeUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = AUTO_ExeUser_DR ];

Property AUTOStartTime1 As %String [ SqlColumnNumber = 4, SqlFieldName = AUTO_StartTime1 ];

Property AUTOEndTime1 As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = AUTO_EndTime1 ];

Property AUTOStartTime2 As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AUTO_StartTime2 ];

Property AUTOEndTime2 As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = AUTO_EndTime2 ];

Property AUTOStartTime3 As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = AUTO_StartTime3 ];

Property AUTOEndTime3 As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = AUTO_EndTime3 ];

Property AUTOSaturday As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = AUTO_Saturday ];

Property AUTOSunday As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = AUTO_Sunday ];

Property AUTOHolidays As %String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AUTO_Holidays ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAutoPurPlan(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AUTO_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AUTO_EndTime1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AUTO_EndTime2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AUTO_EndTime3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AUTO_ExeUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AUTO_Holidays">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AUTO_Saturday">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AUTO_StartTime1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AUTO_StartTime2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AUTO_StartTime3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AUTO_Sunday">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCAutoPurPlan</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AUTO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{AUTO_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AUTO_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAutoHandlePurPlanS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

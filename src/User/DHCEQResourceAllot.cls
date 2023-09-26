Class User.DHCEQResourceAllot Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = RA_RowID, SqlTableName = DHC_EQResourceAllot, StorageStrategy = SQLStorage ]
{

/// RA_LocDR
Property RALocDR As DHCEQCDepartment [ SqlColumnNumber = 2, SqlFieldName = RA_LocDR ];

/// RA_Year
Property RAYear As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RA_Year ];

/// RA_Month
Property RAMonth As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RA_Month ];

/// RA_ResourceTypeDR
Property RAResourceTypeDR As DHCEQCResourceType [ SqlColumnNumber = 5, SqlFieldName = RA_ResourceTypeDR ];

/// RA_Amount
Property RAAmount As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RA_Amount ];

/// RA_Rate
Property RARate As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RA_Rate ];

/// RA_AllotAmount
Property RAAllotAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = RA_AllotAmount ];

/// RA_AllotMode
Property RAAllotMode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RA_AllotMode ];

/// RA_Total
Property RATotal As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = RA_Total ];

/// RA_Remark
Property RARemark As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RA_Remark ];

/// RA_Status
Property RAStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 12, SqlFieldName = RA_Status ];

/// RA_InvalidFlag
Property RAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = RA_InvalidFlag ];

/// RA_Hold1
Property RAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = RA_Hold1 ];

/// RA_Hold2
Property RAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = RA_Hold2 ];

/// RA_Hold3
Property RAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = RA_Hold3 ];

/// RA_Hold4
Property RAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = RA_Hold4 ];

/// RA_Hold5
Property RAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = RA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQResourceAllot("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RA_AllotAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RA_AllotMode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RA_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RA_Month">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RA_Rate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RA_ResourceTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RA_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RA_Total">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RA_Year">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQResourceAllot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{RA_RowID}</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{RA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexResourceType">
<Global>^DHCEQResourceAllot</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>RA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ResourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RA_ResourceTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RA_LocDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RA_Year}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RA_Month}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RA_Status}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>{RA_RowID}</SqlRowIdName>
<StreamLocation>^User.DHCEQResourceAllotS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

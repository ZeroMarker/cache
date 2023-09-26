/// ClientDiaryDayData(2345)
Class User.PAClientDiaryDayData Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_ClientDiaryDayData, StorageStrategy = SQLStorage ]
{

/// Des Ref Person
Property CLDPersonDR As PAPerson [ SqlColumnNumber = 2, SqlFieldName = CLD_Person_DR ];

/// Text1
Property CLDText1 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLD_Text1, SqlListType = SUBNODE ];

/// Text2
Property CLDText2 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CLD_Text2, SqlListType = SUBNODE ];

/// Text3
Property CLDText3 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CLD_Text3, SqlListType = SUBNODE ];

/// Text4
Property CLDText4 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CLD_Text4, SqlListType = SUBNODE ];

/// Text5
Property CLDText5 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CLD_Text5, SqlListType = SUBNODE ];

/// Text6
Property CLDText6 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CLD_Text6, SqlListType = SUBNODE ];

/// Text7
Property CLDText7 As list Of %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CLD_Text7, SqlListType = SUBNODE ];

/// Update Date
Property CLDUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CLD_UpdateDate ];

/// Update Time
Property CLDUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CLD_UpdateTime ];

/// Des Ref UpdateUser
Property CLDUpdateUserDR As SSUser [ SqlColumnNumber = 12, SqlFieldName = CLD_UpdateUser_DR ];

Parameter EXTENTSIZE = 1;

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="CLDPersonDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText1">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText2">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText3">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText4">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText5">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText6">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDText7">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDUpdateDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDUpdateTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="CLDUpdateUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PACLD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CLD_Person_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CLD_Text1">
<Node>"TX1"</Node>
</Data>
<Data name="CLD_Text2">
<Node>"TX2"</Node>
</Data>
<Data name="CLD_Text3">
<Node>"TX3"</Node>
</Data>
<Data name="CLD_Text4">
<Node>"TX4"</Node>
</Data>
<Data name="CLD_Text5">
<Node>"TX5"</Node>
</Data>
<Data name="CLD_Text6">
<Node>"TX6"</Node>
</Data>
<Data name="CLD_Text7">
<Node>"TX7"</Node>
</Data>
<Data name="CLD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CLD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CLD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PACLD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CLD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CLD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPerson">
<Global>^PACLD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CLD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Person"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CLD_Person_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CLD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CLD_RowId</SqlRowIdName>
<StreamLocation>^User.PAClientDiaryDayDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

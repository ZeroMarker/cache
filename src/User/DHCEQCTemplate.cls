Class User.DHCEQCTemplate Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = T_RowID, SqlTableName = DHC_EQCTemplate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// T_Type
Property TType As %Library.String(DISPLAYLIST = ",质量检测用,PM用,论证用,效益分析用", MAXLEN = 6, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4") [ SqlColumnNumber = 2, SqlFieldName = T_Type ];

/// T_Name
Property TName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = T_Name ];

/// T_Caption
Property TCaption As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = T_Caption ];

/// T_Note
Property TNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = T_Note ];

/// T_Remark
Property TRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = T_Remark ];

/// T_FromDate
Property TFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = T_FromDate ];

/// T_ToDate
Property TToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = T_ToDate ];

/// T_InvalidFlag
Property TInvalidFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = T_InvalidFlag ];

/// T_Hold1
Property THold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = T_Hold1 ];

/// T_Hold2
Property THold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = T_Hold2 ];

/// T_Hold3
Property THold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = T_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCTemplate",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="T_Caption">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="T_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="T_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="T_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="T_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="T_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="T_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="T_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="T_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="T_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="T_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCTemplate"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{T_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypeName">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCTemplate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeName"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{T_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{T_Name}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{T_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

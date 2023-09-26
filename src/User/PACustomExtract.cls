/// PA CustomExtract(2342)
Class User.PACustomExtract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CustomExtract, StorageStrategy = SQLStorage ]
{

Relationship ChildPACustomExtractReport As PACustomExtractReport [ Cardinality = children, Inverse = REPParRef ];

/// Des Ref PAC CustomExtract
Property EXCustomExtractDR As PACCustomExtract [ SqlColumnNumber = 2, SqlFieldName = EX_CustomExtract_DR ];

/// Date From
Property EXDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = EX_DateFrom ];

/// Date Run
Property EXDateRun As %Date [ SqlColumnNumber = 5, SqlFieldName = EX_DateRun ];

/// Date To
Property EXDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = EX_DateTo ];

/// Number
Property EXNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EX_Number ];

/// Status
Property EXStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EX_Status ];

/// Des Ref User
Property EXUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = EX_User_DR ];

Parameter EXTENTSIZE = 2;

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="EXCustomExtractDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXDateRun">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXNumber">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXStatus">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXUserDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAEX(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="EX_CustomExtract_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EX_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EX_DateRun">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EX_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EX_Number">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EX_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EX_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAEX</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{EX_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EX_RowId</SqlRowIdName>
<StreamLocation>^User.PACustomExtractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

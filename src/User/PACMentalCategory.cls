/// Mental Category(2207)
Class User.PACMentalCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_MentalCategory, StorageStrategy = SQLStorage ]
{

/// Code
Property MENTCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MENTC_Code ];

/// DateFrom
Property MENTCDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = MENTC_DateFrom ];

/// Date To
Property MENTCDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = MENTC_DateTo ];

/// Description
Property MENTCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MENTC_Desc ];

/// National Code
Property MENTCNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MENTC_NationalCode ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="MENTCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="MENTCDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="MENTCDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="MENTCDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="MENTCNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("MENTC",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MENTC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MENTC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MENTC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MENTC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MENTC_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MENTC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MENTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MENTC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MENTC_RowId</SqlRowIdName>
<StreamLocation>^User.PACMentalCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

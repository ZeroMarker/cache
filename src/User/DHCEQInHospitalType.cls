Class User.DHCEQInHospitalType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IHT_RowID, SqlTableName = DHC_EQCInHospitalType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AT_Code
Property IHTCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = IHT_Code ];

/// AT_Desc
Property IHTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = IHT_Desc ];

/// AT_Type
Property IHTType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = IHT_Type ];

/// AT_InvalidFlag
Property IHTInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = IHT_InvalidFlag ];

/// AT_Hold1
Property IHTHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = IHT_Hold1 ];

/// AT_Hold2
Property IHTHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = IHT_Hold2 ];

/// AT_Hold3
Property IHTHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = IHT_Hold3 ];

/// AT_Hold4
Property IHTHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = IHT_Hold4 ];

/// AT_Hold5
Property IHTHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = IHT_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCInHospitalType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IHT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IHT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IHT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IHT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IHT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IHT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IHT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IHT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IHT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IHT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCInHospitalType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{IHT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IHT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCInHospitalType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IHT_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IHT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCInHospitalTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCMedEqptCat Extends (%Persistent, User.Abstract) [ SqlRowIdName = MECAT_RowId, SqlTableName = DHC_MedEqptCat, StorageStrategy = SQLStorage1 ]
{

Property MECATCode As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MECAT_Code ];

Property MECATDesc As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MECAT_Desc ];

Property MECATGrade As %String(DISPLAYLIST = ",1,2,3", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 4, SqlFieldName = MECAT_Grade ];

Property MECATSubCode As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MECAT_SubCode ];

Property MECATSubDesc As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MECAT_SubDesc ];

Property MECATMinorCode As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MECAT_MinorCode ];

Property MECATMinorDesc As %String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MECAT_MinorDesc ];

Storage SQLStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCMECAT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MECAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MECAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MECAT_Grade">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MECAT_MinorCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MECAT_MinorDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MECAT_SubCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MECAT_SubDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMECAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MECAT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{MECAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MECAT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMedEqptCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

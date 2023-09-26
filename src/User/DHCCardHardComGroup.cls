Class User.DHCCardHardComGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CCG_RowID, SqlTableName = DHC_CardHardComGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CCG_Code
Property CCGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CCG_Code ];

/// CCG_Desc
Property CCGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CCG_Desc ];

/// CCG_Type
Property CCGType As %Library.String(DISPLAYLIST = ",Card Equip,Infomation Equip,Bar Code, PWD KeyPress Equip,Sound Quote", MAXLEN = 16, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",CE,IE,BC,PKE,SQ") [ SqlColumnNumber = 4, SqlFieldName = CCG_Type ];

/// CCG_Note1
Property CCGNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CCG_Note1 ];

/// CCG_Note2
Property CCGNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CCG_Note2 ];

/// CCG_Note3
Property CCGNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CCG_Note3 ];

/// CCG_Note4
Property CCGNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CCG_Note4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCARDHARDCOM("GROUP"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CCG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CCG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CCG_Note1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CCG_Note2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CCG_Note3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CCG_Note4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CCG_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCARDHARDCOM</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GROUP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CCG_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCCARDHARDCOMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>CCG_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GROUP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{CCG_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CCG_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCardHardComGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

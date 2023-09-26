Class User.DHCEQUserDefinedInfoList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = UDIL_RowID, SqlTableName = DHC_EQUserDefinedInfoList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// UDIL_UserDefinedInfoDR
Property UDILUserDefinedInfoDR As User.DHCEQUserDefinedInfo [ SqlColumnNumber = 2, SqlFieldName = UDIL_UserDefinedInfoDR ];

/// UDIL_UserDefinedListDR
Property UDILUserDefinedListDR As User.DHCEQCUserDefinedList [ SqlColumnNumber = 3, SqlFieldName = UDIL_UserDefinedListDR ];

/// UDIL_Info
Property UDILInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = UDIL_Info ];

/// UDIL_Remark
Property UDILRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = UDIL_Remark ];

/// UDIL_Hold1
Property UDILHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = UDIL_Hold1 ];

/// UDIL_Hold2
Property UDILHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = UDIL_Hold2 ];

/// UDIL_Hold3
Property UDILHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = UDIL_Hold3 ];

/// UDIL_Hold4
Property UDILHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = UDIL_Hold4 ];

/// UDIL_Hold5
Property UDILHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = UDIL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQUserDefinedInfoList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="UDIL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="UDIL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="UDIL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UDIL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UDIL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UDIL_Info">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="UDIL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="UDIL_UserDefinedInfoDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UDIL_UserDefinedListDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQUserDefinedInfoList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>UDIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{UDIL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUserDefinedInfo">
<Global>^DHCEQUserDefinedInfoList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>UDIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDefinedInfo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UDIL_UserDefinedInfoDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UDIL_UserDefinedListDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{UDIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDefinedList">
<Global>^DHCEQUserDefinedInfoList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>UDIL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDefinedList"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{UDIL_UserDefinedListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{UDIL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQUserDefinedInfoListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

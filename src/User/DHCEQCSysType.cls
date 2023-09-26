Class User.DHCEQCSysType Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ST_RowID, SqlTableName = DHC_EQCSysType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ST_Code
Property STCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ST_Code ];

/// ST_Desc
Property STDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ST_Desc ];

/// ST_Remark
Property STRemark As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ST_Remark ];

/// ST_InvalidFlag
Property STInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ST_InvalidFlag ];

/// ST_ReplaceContent
Property STReplaceContent As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ST_ReplaceContent ];

/// ST_Hold1
Property STHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = ST_Hold1 ];

/// ST_Hold2
Property STHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = ST_Hold2 ];

/// ST_Hold3
Property STHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = ST_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCSysType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ST_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ST_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ST_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ST_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ST_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ST_ReplaceContent">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ST_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCSysType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ST_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCSysTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

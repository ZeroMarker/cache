Class User.DHCEQDepreSetDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSD_RowID, SqlTableName = DHC_EQDepreSetDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSD_DepreSetDR
Property DSDDepreSetDR As User.DHCEQDepreSet [ SqlColumnNumber = 2, SqlFieldName = DSD_DepreSetDR ];

/// DSD_ExceedFlag
Property DSDExceedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = DSD_ExceedFlag ];

/// DSD_FromYear
Property DSDFromYear As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DSD_FromYear ];

/// DSD_ToYear
Property DSDToYear As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DSD_ToYear ];

/// DSD_Rate
Property DSDRate As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DSD_Rate ];

/// DSD_Hold1
Property DSDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DSD_Hold1 ];

/// DSD_Hold2
Property DSDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DSD_Hold2 ];

/// DSD_Hold3
Property DSDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DSD_Hold3 ];

/// DSD_Hold4
Property DSDHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DSD_Hold4 ];

/// DSD_Hold5
Property DSDHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DSD_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDepreSetDetail("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DSD_DepreSetDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSD_ExceedFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSD_FromYear">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DSD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DSD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DSD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DSD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DSD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DSD_Rate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSD_ToYear">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQDepreSetDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DSD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDepreSet">
<Global>^DHCEQDepreSetDetail</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DepreSet"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DSD_DepreSetDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDepreSetDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

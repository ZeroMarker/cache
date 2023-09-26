Class User.DHCEQSharingPlatformList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQSharingPlatformList, StorageStrategy = SQLStorage ]
{

/// SPL_SharingPlatformDR
Property SPLSharingPlatformDR As DHCEQSharingPlatform [ SqlColumnNumber = 2, SqlFieldName = SPL_SharingPlatformDR ];

/// SPL_Content
Property SPLContent As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SPL_Content ];

/// SPL_AnonymousFlag
Property SPLAnonymousFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPL_AnonymousFlag ];

/// SPL_Rate
Property SPLRate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SPL_Rate ];

/// SPL_Picture
Property SPLPicture As DHCEQPicture [ SqlColumnNumber = 6, SqlFieldName = SPL_Picture ];

/// SPL_UpdateUserDR
Property SPLUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = SPL_UpdateUserDR ];

/// SPL_UpdateDate
Property SPLUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SPL_UpdateDate ];

/// SPL_UpdateTime
Property SPLUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = SPL_UpdateTime ];

/// SPL_Hold1
Property SPLHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SPL_Hold1 ];

/// SPL_Hold2
Property SPLHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SPL_Hold2 ];

/// SPL_Hold3
Property SPLHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SPL_Hold3 ];

/// SPL_Hold4
Property SPLHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SPL_Hold4 ];

/// SPL_Hold5
Property SPLHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SPL_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSharingPlatformList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SPL_AnonymousFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SPL_Content">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SPL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SPL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SPL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SPL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SPL_Picture">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SPL_Rate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SPL_SharingPlatformDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SPL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SPL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQSharingPlatformList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SPL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SPL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSharingPlatformDR">
<Global>^DHCEQSharingPlatformList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"SharingPlatformDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SPL_SharingPlatformDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateUserDR">
<Global>^DHCEQSharingPlatformList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SPL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateUserDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SPL_UpdateUserDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPL_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQSharingPlatformListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

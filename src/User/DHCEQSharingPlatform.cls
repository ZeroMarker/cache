Class User.DHCEQSharingPlatform Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQSharingPlatform, StorageStrategy = SQLStorage ]
{

/// SP_Title
Property SPTitle As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SP_Title ];

/// SP_Content
Property SPContent As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SP_Content ];

/// SP_Type
Property SPType As %String(DISPLAYLIST = ",维修", MAXLEN = 2, VALUELIST = ",1") [ SqlColumnNumber = 4, SqlFieldName = SP_Type ];

/// SP_Status
Property SPStatus As %String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, VALUELIST = ",0,1,2") [ SqlColumnNumber = 5, SqlFieldName = SP_Status ];

/// SP_InvalidFlag
Property SPInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SP_InvalidFlag ];

/// SP_AnonymousFlag
Property SPAnonymousFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SP_AnonymousFlag ];

/// SP_Rate
Property SPRate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SP_Rate ];

/// SP_UpdateUserDR
Property SPUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = SP_UpdateUserDR ];

/// SP_UpdateDate
Property SPUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = SP_UpdateDate ];

/// SP_UpdateTime
Property SPUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = SP_UpdateTime ];

/// SP_Hold1
Property SPHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SP_Hold1 ];

/// SP_Hold2
Property SPHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SP_Hold2 ];

/// SP_Hold3
Property SPHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SP_Hold3 ];

/// SP_Hold4
Property SPHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SP_Hold4 ];

/// SP_Hold5
Property SPHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SP_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQSharingPlatform("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SP_AnonymousFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SP_Content">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SP_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SP_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SP_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SP_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SP_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SP_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SP_Rate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SP_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SP_Title">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SP_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SP_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SP_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SP_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCEQSharingPlatform</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SP_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCEQSharingPlatform</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SP_Status}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUpdateUserDR">
<Global>^DHCEQSharingPlatform</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UpdateUserDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SP_UpdateUserDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SP_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQSharingPlatformS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

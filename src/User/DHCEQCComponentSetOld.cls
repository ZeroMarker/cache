Class User.DHCEQCComponentSetOld Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCComponentSetOld, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CS_SourceType
Property CSSourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CS_SourceType ];

/// CS_SourceID
Property CSSourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CS_SourceID ];

/// CS_ComponentName
Property CSComponentName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CS_ComponentName ];

/// CS_Layout
Property CSLayout As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CS_Layout ];

/// CS_LastUpdateDate
Property CSLastUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CS_LastUpdateDate ];

/// CS_LastUpdateTime
Property CSLastUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CS_LastUpdateTime ];

/// CS_LastUpdateUserDR
Property CSLastUpdateUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CS_LastUpdateUserDR ];

/// CS_InvalidFlag
Property CSInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CS_InvalidFlag ];

/// CS_Hold1
Property CSHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CS_Hold1 ];

/// CS_Hold2
Property CSHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CS_Hold2 ];

/// CS_Hold3
Property CSHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CS_Hold3 ];

/// CS_Hold4
Property CSHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CS_Hold4 ];

/// CS_Hold5
Property CSHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CS_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCComponent("DHCEQCComponentSetOld","0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CS_ComponentName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CS_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CS_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CS_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CS_LastUpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CS_Layout">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CS_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CS_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCComponent</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentSetOld"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComponent">
<Global>^DHCEQCComponent</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>CS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCComponentSetOld"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Component"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CS_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>+{CS_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CS_ComponentName}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{CS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CS_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCComponentSetOldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

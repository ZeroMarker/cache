Class User.DHCEQAssociated Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EA_RowID, SqlTableName = DHC_EQAssociated, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EA_ParEquipDR
Property EAParEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = EA_ParEquipDR ];

/// EA_ChildEquipDR
Property EAChildEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = EA_ChildEquipDR ];

/// EA_Remark
Property EARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EA_Remark ];

/// EA_InvalidFlag
Property EAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = EA_InvalidFlag ];

/// EA_FromDate
Property EAFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = EA_FromDate ];

/// EA_ToDate
Property EAToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = EA_ToDate ];

/// EA_Hold1
Property EAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EA_Hold1 ];

/// EA_Hold2
Property EAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EA_Hold2 ];

/// EA_Hold3
Property EAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EA_Hold3 ];

/// EA_Hold4
Property EAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EA_Hold4 ];

/// EA_Hold5
Property EAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EA_Hold5 ];

/// EA_UserDR
Property EAUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EA_UserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAssociated("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EA_ChildEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EA_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EA_ParEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EA_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EA_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQAssociated</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{EA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChildEquipDR">
<Global>^DHCEQAssociated</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ChildEquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EA_ChildEquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EA_InvalidFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParEquipDR">
<Global>^DHCEQAssociated</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParEquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EA_ParEquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EA_InvalidFlag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAssociatedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

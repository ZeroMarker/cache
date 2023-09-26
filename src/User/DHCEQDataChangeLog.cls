Class User.DHCEQDataChangeLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCL_RowID, SqlTableName = DHC_EQDataChangeLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DCL_TableName
Property DCLTableName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DCL_TableName ];

/// DCL_ClassName
Property DCLClassName As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DCL_ClassName ];

/// DCL_BussID
Property DCLBussID As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DCL_BussID ];

/// DCL_UpdateUserDR
Property DCLUpdateUserDR As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DCL_UpdateUserDR ];

/// DCL_UpdateDate
Property DCLUpdateDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6, SqlFieldName = DCL_UpdateDate ];

/// DCL_UpdateTime
Property DCLUpdateTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 7, SqlFieldName = DCL_UpdateTime ];

/// DCL_OperateType
Property DCLOperateType As %Library.String(DISPLAYLIST = ",Add,Update,Delete", VALUELIST = ",A,U,D") [ SqlColumnNumber = 8, SqlFieldName = DCL_OperateType ];

/// DCL_OldValue
Property DCLOldValue As %Library.String(MAXLEN = "") [ SqlColumnNumber = 9, SqlFieldName = DCL_OldValue ];

/// DCL_NewValue
Property DCLNewValue As %Library.String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = DCL_NewValue ];

/// DCL_IpAddress
Property DCLIpAddress As %Library.String [ SqlColumnNumber = 11, SqlFieldName = DCL_IpAddress ];

/// DCL_DataChangeRegDR
Property DCLDataChangeRegDR As %Library.String [ SqlColumnNumber = 12, SqlFieldName = DCL_DataChangeRegDR ];

/// DCL_Hold1
Property DCLHold1 As %Library.String [ SqlColumnNumber = 13, SqlFieldName = DCL_Hold1 ];

/// DCL_Hold2
Property DCLHold2 As %Library.String [ SqlColumnNumber = 14, SqlFieldName = DCL_Hold2 ];

/// DCL_Hold3
Property DCLHold3 As %Library.String [ SqlColumnNumber = 15, SqlFieldName = DCL_Hold3 ];

/// DCL_Hold4
Property DCLHold4 As %Library.String [ SqlColumnNumber = 16, SqlFieldName = DCL_Hold4 ];

/// DCL_Hold5
Property DCLHold5 As %Library.String [ SqlColumnNumber = 17, SqlFieldName = DCL_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDataChangeLog("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DCL_BussID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCL_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCL_DataChangeRegDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DCL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DCL_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DCL_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DCL_IpAddress">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCL_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCL_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCL_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCL_TableName">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQDataChangeLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DCL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDataChangeReg">
<Global>^DHCEQDataChangeLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DataChangeReq"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCL_DataChangeRegDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTableName">
<Global>^DHCEQDataChangeLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TableName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCL_TableName}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCL_BussID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDataChangeLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

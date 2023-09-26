Class User.DHCEQMessageSendDefine Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MSD_RowID, SqlTableName = DHC_EQMessageSendDefine, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MSD_MessagesType
Property MSDMessagesType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MSD_MessagesType ];

/// MSD_BussType
Property MSDBussType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MSD_BussType ];

/// MSD_DefineType
Property MSDDefineType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MSD_DefineType ];

/// MSD_Times
Property MSDTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MSD_Times ];

/// MSD_FromRole
Property MSDFromRole As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MSD_FromRole ];

/// MSD_FromAction
Property MSDFromAction As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MSD_FromAction ];

/// MSD_ToRole
Property MSDToRole As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MSD_ToRole ];

/// MSD_ToAction
Property MSDToAction As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MSD_ToAction ];

/// MSD_Templet
Property MSDTemplet As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MSD_Templet ];

/// MSD_RepeatFlag
Property MSDRepeatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MSD_RepeatFlag ];

/// MSD_RepeatLength
Property MSDRepeatLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MSD_RepeatLength ];

/// MSD_MaxLength
Property MSDMaxLength As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = MSD_MaxLength ];

/// MSD_Hold1
Property MSDHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MSD_Hold1 ];

/// MSD_Hold2
Property MSDHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MSD_Hold2 ];

/// MSD_Hold3
Property MSDHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MSD_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQMessageSendDefine("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MSD_BussType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MSD_DefineType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MSD_FromAction">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MSD_FromRole">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MSD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MSD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MSD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MSD_MaxLength">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MSD_MessagesType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MSD_RepeatFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MSD_RepeatLength">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MSD_Templet">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MSD_Times">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MSD_ToAction">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MSD_ToRole">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQMessageSendDefine</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MSD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDefineType">
<Global>^DHCEQMessageSendDefine</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MSD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DefineType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MSD_DefineType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MSD_BussType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MSD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQMessageSendDefineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

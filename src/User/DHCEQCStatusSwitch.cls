Class User.DHCEQCStatusSwitch Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SS_RowID, SqlTableName = DHC_EQCStatusSwitch, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SS_SwitchType
Property SSSwitchType As %Library.String(DISPLAYLIST = ",盘点状态-处理状态,处理状态-处理结果", MAXLEN = 5, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 2, SqlFieldName = SS_SwitchType ];

/// SS_PreStatusID
Property SSPreStatusID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SS_PreStatusID ];

/// SS_PreStatus
Property SSPreStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SS_PreStatus ];

/// SS_Dispose
Property SSDispose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SS_Dispose ];

/// SS_DisposeStatusID
Property SSDisposeStatusID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SS_DisposeStatusID ];

/// SS_DisposeStatus
Property SSDisposeStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SS_DisposeStatus ];

/// SS_InvalidFlag
Property SSInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SS_InvalidFlag ];

/// SS_Hold1
Property SSHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = SS_Hold1 ];

/// SS_Hold2
Property SSHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = SS_Hold2 ];

/// SS_Hold3
Property SSHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SS_Hold3 ];

/// SS_Hold4
Property SSHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SS_Hold4 ];

/// SS_Hold5
Property SSHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SS_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCStatusSwitch",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SS_Dispose">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SS_DisposeStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SS_DisposeStatusID">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SS_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SS_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SS_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SS_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SS_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SS_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SS_PreStatus">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SS_PreStatusID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SS_SwitchType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCStatusSwitch"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCStatusSwitchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

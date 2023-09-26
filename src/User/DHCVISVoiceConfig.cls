/// Voice Call Config
Class User.DHCVISVoiceConfig Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = VIS_ConfigID, SqlTableName = DHC_VIS_VoiceConfig, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Voice
Property VISVoice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = VIS_Voice ];

/// Voice Rate
Property VISRate As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = VIS_Rate ];

/// voice Volume
Property VISVolume As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = VIS_Volume ];

/// Voice Format
Property VISFormat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = VIS_Format ];

/// Active
Property VISActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = VIS_Active ];

/// VIS Version
Property VISVersion As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = VIS_Version ];

/// Application Update Path
Property VISUpdatePath As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = VIS_UpdatePath ];

/// Wait Patient Number
Property VISWait As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = VIS_Wait ];

/// Secode Wait Patient Number
Property VISSecWait As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = VIS_SecWait ];

/// Config Note
Property VISConfigNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = VIS_ConfigNote ];

/// Update User
Property VISUpdateUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = VIS_UpdateUser ];

/// Update Date
Property VISUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = VIS_UpdateDate ];

/// Update Time
Property VISUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = VIS_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISConfig)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VIS_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VIS_ConfigNote">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="VIS_Format">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VIS_Rate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VIS_SecWait">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="VIS_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="VIS_UpdatePath">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="VIS_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="VIS_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="VIS_Version">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="VIS_Voice">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VIS_Volume">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VIS_Wait">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCVISConfig</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>VIS_ConfigID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{VIS_ConfigID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISVoiceConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

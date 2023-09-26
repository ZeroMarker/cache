Class User.DHCEQTempLocMap Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LM_RowID, SqlTableName = DHC_EQTempLocMap, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LM_OldLoc
Property LMOldLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = LM_OldLoc ];

/// LM_NewLoc
Property LMNewLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = LM_NewLoc ];

/// LM_NewLocID
Property LMNewLocID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LM_NewLocID ];

/// LM_OldLocID
Property LMOldLocID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = LM_OldLocID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTempLocMap("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LM_NewLoc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LM_NewLocID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LM_OldLoc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LM_OldLocID">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQTempLocMap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTempLocMapS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

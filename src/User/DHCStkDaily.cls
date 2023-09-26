Class User.DHCStkDaily Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SD_RowID, SqlTableName = DHC_StkDaily, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCStkDailyReport As User.DHCStkDailyReport [ Cardinality = children, Inverse = SDRSDParref ];

/// SD_User
Property SDUser As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = SD_User ];

/// SD_Date
Property SDDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = SD_Date ];

/// SD_Time
Property SDTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = SD_Time ];

/// SD_CTLOC_Dr
Property SDCtLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = SD_CtLoc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSDR)</SqlIdExpression>
<SQLMap name="DataMasterDHCSDR">
<Data name="SD_CtLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SD_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SD_User">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexData">
<Global>^DHCSDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SD_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SD_CtLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCStkDailyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

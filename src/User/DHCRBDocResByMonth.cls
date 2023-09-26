Class User.DHCRBDocResByMonth Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCMon_Rowid, SqlTableName = DHC_RBDocResByMonth, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCMon_Depid
Property DHCMonDepid As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DHCMon_Depid ];

/// DHCMon_docid
Property DHCMondocid As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = DHCMon_docid ];

/// DHCMon_Year
Property DHCMonYear As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCMon_Year ];

/// DHCMon_Month
Property DHCMonMonth As %Library.Numeric(MAXVAL = 12, MINVAL = 1, SCALE = 0) [ SqlColumnNumber = 5, SqlFieldName = DHCMon_Month ];

/// DHCMon_Date
Property DHCMonDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCMon_Date ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBMON)</SqlIdExpression>
<SQLMap name="Indexdepdate">
<Global>^DHCRBMON</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHCMon_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DepDay"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHCMon_Depid}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCMon_Year}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHCMon_Month}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHCMon_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHCMon_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDATA">
<Data name="DHCMon_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCMon_Depid">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCMon_Month">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCMon_Rowid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCMon_Year">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCMon_docid">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBMON</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCMon_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCMon_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBDocResByMonthS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

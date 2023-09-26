Class User.DHCWMRReceiptLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Rowid, SqlTableName = DHC_WMR_ReceiptLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 25000000;

/// OpeType
Property OpeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// MrType_Dr
Property MrTypeDr As User.DHCWMRDictionary [ SqlColumnNumber = 3, SqlFieldName = MrType_Dr ];

/// MrNo
Property MrNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// Volume_Dr
Property VolumeDr As User.DHCWMRMainVolume [ SqlColumnNumber = 5, SqlFieldName = Volume_Dr ];

/// Papmi_Dr
Property PapmiDr As User.PAPatMas [ SqlColumnNumber = 6, SqlFieldName = Papmi_Dr ];

/// Paadm_Dr
Property PaadmDr As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = Paadm_Dr ];

/// RecLoc_Dr
Property RecLocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = RecLoc_Dr ];

/// RecUser_Dr
Property RecUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = RecUser_Dr ];

/// RecDate
Property RecDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10 ];

/// RecTime
Property RecTime As %Library.Time [ SqlColumnNumber = 11 ];

/// IsActive
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// ResumeText
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Storage SQLStorage
{
<ExtentSize>25000000</ExtentSize>
<SqlIdExpression>$i(^DHCWMRRecLog(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IsActive">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MrNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MrType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OpeType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Paadm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Papmi_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RecDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RecLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RecTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RecUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ResumeText">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Volume_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCWMRRecLog</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMrNo">
<Global>^DHCWMRRecLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"MrNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MrType_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MrNo}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPapmi">
<Global>^DHCWMRRecLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Papmi"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{Papmi_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDate">
<Global>^DHCWMRRecLog</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RecDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RecDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWMRReceiptLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

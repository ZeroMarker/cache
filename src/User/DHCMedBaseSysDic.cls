/// System Dictory
Class User.DHCMedBaseSysDic Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MBSD_Rowid, SqlTableName = DHC_MedBaseSysDic, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MBSD_Name
Property MBSDName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MBSD_Name ];

/// MBSD_TblName
Property MBSDTblName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MBSD_TblName ];

/// MBSD_IdField
Property MBSDIdField As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MBSD_IdField ];

/// MBSD_CodeField
Property MBSDCodeField As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MBSD_CodeField ];

/// MBSD_DescField
Property MBSDDescField As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = MBSD_DescField ];

/// MBSD_Demo
Property MBSDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MBSD_Demo ];

/// MBSD_Active
Property MBSDActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = MBSD_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMBSDIC)</SqlIdExpression>
<SQLMap name="IndexNameTbl">
<Global>^DHCMBSDIC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MBSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"NameTbl"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MBSD_Name}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MBSD_TblName}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MBSD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataMap">
<Data name="MBSD_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MBSD_CodeField">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MBSD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MBSD_DescField">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MBSD_IdField">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MBSD_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MBSD_TblName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMBSDIC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MBSD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MBSD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedBaseSysDicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

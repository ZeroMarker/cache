Class User.DHCMedInfLocDic Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MILD_Rowid, SqlTableName = DHC_MedInfLocDic, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2500;

/// MILD_Code
Property MILDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MILD_Code ];

/// MILD_Desc
Property MILDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MILD_Desc ];

/// MILD_IsActive
Property MILDIsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MILD_IsActive ];

/// MILD_Resume
Property MILDResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MILD_Resume ];

Storage SQLStorage
{
<ExtentSize>2500</ExtentSize>
<SqlIdExpression>$i(^DHCMInfLD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MILD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MILD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MILD_IsActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MILD_Resume">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMInfLD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MILD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MILD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCMInfLD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MILD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MILD_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MILD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedInfLocDicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

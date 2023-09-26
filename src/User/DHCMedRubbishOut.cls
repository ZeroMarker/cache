Class User.DHCMedRubbishOut Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRO_Rowid, SqlTableName = DHC_MedRubbishOut, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MRO_ActiveFlag
Property MROActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 2, SqlFieldName = MRO_ActiveFlag ];

/// MRO_Weight
Property MROWeight As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = MRO_Weight ];

/// MRO_OutUser_DR
Property MROOutUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = MRO_OutUser_DR ];

/// MRO_RollUser_DR
Property MRORollUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MRO_RollUser_DR ];

/// MRO_Date
Property MRODate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MRO_Date ];

/// MRO_Time
Property MROTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MRO_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMRO)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MRO_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRO_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRO_OutUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRO_RollUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRO_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRO_Weight">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMRO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MRO_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateUser">
<Global>^DHCMRO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRO_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRO_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRO_OutUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRO_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedRubbishOutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

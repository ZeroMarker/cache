Class User.DHCMedRubRep Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MRP_RowID, SqlTableName = DHC_MedRubRep, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedRubRepSub As User.DHCMedRubRepSub [ Cardinality = children, Inverse = MRPSParRef ];

/// MRP_Status
Property MRPStatus As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MRP_Status ];

/// MRP_Type
Property MRPType As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MRP_Type ];

/// MRP_TypeDesc
Property MRPTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MRP_TypeDesc ];

/// MRP_Weight
Property MRPWeight As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = MRP_Weight ];

/// MRP_Loc
Property MRPLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = MRP_Loc ];

/// MRP_RepPlace
Property MRPRepPlace As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MRP_RepPlace ];

/// MRP_User
Property MRPUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = MRP_User ];

/// MRP_Date
Property MRPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MRP_Date ];

/// MRP_Time
Property MRPTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MRP_Time ];

/// MRP_Resume
Property MRPResume As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MRP_Resume ];

/// MRP_RefOut_DR
Property MRPRefOutDR As User.DHCMedRubbishOut [ SqlColumnNumber = 12, SqlFieldName = MRP_RefOut_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMRB)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MRP_Date">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRP_Loc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRP_RefOut_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRP_RepPlace">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRP_Resume">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRP_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRP_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRP_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRP_TypeDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRP_User">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRP_Weight">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMRB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MRP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCMRB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRP_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRP_Loc}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRubOut">
<Global>^DHCMRB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRP_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RubOut"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MRP_RefOut_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MRP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedRubRepS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

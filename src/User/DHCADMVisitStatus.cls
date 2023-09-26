/// DHC Episode Visitor Status
Class User.DHCADMVisitStatus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AVS_RowId, SqlTableName = DHC_ADMVisitStatus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PAAdm Reference
Property AVSPAADMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AVS_PAADM_DR ];

/// AVS_VisitStatus
Property AVSVisitStatus As User.DHCPACVisitStatus [ SqlColumnNumber = 4, SqlFieldName = AVS_VisitStatus ];

/// AVS_Date
Property AVSDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AVS_Date ];

/// AVS_Time
Property AVSTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AVS_Time ];

/// AVS_User_DR
Property AVSUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = AVS_User_DR ];

/// AVS_Location
Property AVSLocation As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AVS_Location ];

/// AVS_CreateDate
Property AVSCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AVS_CreateDate ];

/// AVS_CreateTime
Property AVSCreateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AVS_CreateTime ];

/// AVS_CreateUser
Property AVSCreateUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = AVS_CreateUser ];

/// AVS_Ward_Dr
Property AVSWardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = AVS_Ward_Dr ];

/// AVS_Note
Property AVSNote As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = AVS_Note ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCADMVisitStatus(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AVS_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AVS_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AVS_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AVS_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AVS_Location">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AVS_Note">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AVS_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AVS_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AVS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AVS_VisitStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AVS_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCADMVisitStatus</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AVS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AVS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXDateVisitStatus">
<Global>^DHCADMVisitStatus</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AVS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateStatus"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AVS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AVS_VisitStatus}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AVS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXEpisode">
<Global>^DHCADMVisitStatus</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AVS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AVS_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AVS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCADMVisitStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

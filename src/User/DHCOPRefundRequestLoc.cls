Class User.DHCOPRefundRequestLoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RL_Rowid, SqlTableName = DHC_OPRefundRequestLoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RL_Group_DR
Property RLGroupDR As User.SSGroup [ SqlColumnNumber = 2, SqlFieldName = RL_Group_DR ];

/// RL_Loc_DR
Property RLLocDR As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = RL_Loc_DR ];

/// RL_User_DR
Property RLUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = RL_User_DR ];

/// RL_Date
Property RLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = RL_Date ];

/// RL_Time
Property RLTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = RL_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPRefundRequestLoc)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RL_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RL_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RL_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RL_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCOPRefundRequestLoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRL">
<Global>^DHCOPRefundRequestLoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"RL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RL_Group_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RL_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPRefundRequestLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

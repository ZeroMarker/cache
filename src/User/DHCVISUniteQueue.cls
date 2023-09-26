/// VIS Unite Queue
Class User.DHCVISUniteQueue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ID, SqlTableName = DHC_VIS_UniteQueue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Queue NO
Property QueueNo As %Library.Float [ SqlColumnNumber = 2 ];

/// Patient RegNo
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// Adm RowID
Property EpisodeID As User.PAAdm [ SqlColumnNumber = 4 ];

/// Patient Name
Property PatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// Loction CTLoc RowID 
Property Loction As User.CTLoc [ SqlColumnNumber = 6 ];

/// Priority
Property Priority As %Library.String(MAXLEN = 6, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",VIP||V,Normal||N") [ SqlColumnNumber = 7 ];

/// Queue State
Property State As %Library.String(MAXLEN = 7, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",Waiting||W,Called||C,Arrival||A,Pass||P") [ SqlColumnNumber = 8 ];

/// Queue Type
Property Type As %Library.String(MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Infusion||I,Blood||B,Charge||C") [ SqlColumnNumber = 9 ];

/// Queue Create Date
Property CreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10 ];

/// Queue Create Time 
Property CreateTime As %Library.Time [ SqlColumnNumber = 11 ];

/// Queue Create User
Property CreateUser As User.SSUser [ SqlColumnNumber = 12 ];

/// Queue Update Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13 ];

/// Queue Update Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 14 ];

/// Queue Update User
Property UpdateUser As User.SSUser [ SqlColumnNumber = 15 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISUQ)</SqlIdExpression>
<SQLMap name="IndexDateTypeLocEp">
<Global>^DHCVISUQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTypeLocEp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Loction}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EpisodeID}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTypeLocPrSt">
<Global>^DHCVISUQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTypeLocPrSt"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Loction}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{Priority}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{State}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTypeLocQueueNo">
<Global>^DHCVISUQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTypeLocQueueNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Loction}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QueueNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTypeLocReg">
<Global>^DHCVISUQi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTypeLocReg"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Loction}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RegNo}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapMaster">
<Data name="CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EpisodeID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="Loction">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PatName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Priority">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RegNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="State">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCVISUQ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCVISUniteQueueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

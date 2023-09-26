/// SetTop Terminal
Class User.DHCVISTopTerm Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TopRowID, SqlTableName = DHC_VIS_TopTerm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SetTop Code
Property TopCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// SetTop Desc
Property TopDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// SetTop Mac
Property TopMac As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// SetTop IP
Property TopIP As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// SetTop Group Ref
Property TopGroupDR As User.DHCVISTopGroup [ SqlColumnNumber = 6 ];

/// SetTop Fix Site
Property TopFixSite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// SetTop USB Storage Flag
Property TopUSBFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8 ];

/// SetTop Memory
Property TopMemory As %Library.Float [ SqlColumnNumber = 9 ];

/// SetTop State
Property TopState As %Library.String(MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",PowerOn||P,Working||W,Standby||S") [ SqlColumnNumber = 10 ];

/// SetTop Add Lan Date 
Property TopAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11 ];

/// SetTop Add Lan Time
Property TopAddTime As %Library.Time [ SqlColumnNumber = 12 ];

/// SetTop Add User
Property TopAddUser As User.SSUser [ SqlColumnNumber = 13 ];

/// SetTop Note
Property TopNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// SetTop Update Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15 ];

/// SetTop Update Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 16 ];

/// SetTop Update User
Property UpdateUser As User.SSUser [ SqlColumnNumber = 17 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISTopTerm)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TopAddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TopAddTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="TopAddUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TopCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TopDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TopFixSite">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TopGroupDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TopIP">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TopMac">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TopMemory">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TopNote">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TopState">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TopUSBFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCVISTopTerm</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTopFixSite">
<Global>^DHCVISTopTermi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopFixSite"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TopFixSite}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTopGroup">
<Global>^DHCVISTopTermi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TopGroupDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTopIP">
<Global>^DHCVISTopTermi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopIP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TopIP}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTopMac">
<Global>^DHCVISTopTermi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopMac"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TopMac}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTopState">
<Global>^DHCVISTopTermi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopState"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TopState}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTopUSBFlag">
<Global>^DHCVISTopTermi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TopRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TopUSBFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TopUSBFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TopRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISTopTermS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

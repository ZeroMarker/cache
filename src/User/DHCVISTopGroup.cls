/// SetTop Group
Class User.DHCVISTopGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GroupRowID, SqlTableName = DHC_VIS_TopGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SetTop Group Code
Property GroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// SetTop Group Name
Property GroupDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// SetTop Group Active Flag
Property GroupActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// SetTop Group Ref Department
Property GroupDepDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

/// SetTop Group Ref Department Name
Property GroupDepDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// SetTop Group Start Time
Property GroupStartTime As %Library.Time [ SqlColumnNumber = 7 ];

/// SetTop Group End Time
Property GroupEndTime As %Library.Time [ SqlColumnNumber = 8 ];

/// SetTop Group Note
Property GroupNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9 ];

/// Group SetTop Max Number
Property GroupMax As %Library.Float [ SqlColumnNumber = 10 ];

/// Group Ref From
Property GroupFromDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11 ];

/// Group Insert User
Property InsertUser As User.SSUser [ SqlColumnNumber = 12 ];

/// Group Insert Date
Property InsertDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13 ];

/// Group Insert Time
Property InsertTime As %Library.Time [ SqlColumnNumber = 14 ];

/// Group Update User
Property UpdateUser As User.SSUser [ SqlColumnNumber = 15 ];

/// Group Update Date
Property UpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 16 ];

/// Group Update Time
Property UpdateTime As %Library.Time [ SqlColumnNumber = 17 ];

/// SetTop Group Start Date
Property GroupStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18 ];

/// SetTop Group End Date
Property GroupEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCVISTopGroup)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GroupActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GroupCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GroupDepDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="GroupDepDesc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="GroupDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GroupEndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="GroupEndTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="GroupFromDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="GroupMax">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="GroupNote">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="GroupStartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="GroupStartTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="InsertDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="InsertTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="InsertUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCVISTopGroup</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>GroupRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{GroupRowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexActive">
<Global>^DHCVISTopGroupi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GroupRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Active"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GroupActive}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GroupRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDep">
<Global>^DHCVISTopGroupi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GroupRowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupDepDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{GroupDepDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GroupRowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCVISTopGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// CT Day of Week Entry    (DOWE,8061)
Class User.CTDayOfWeekEntry Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_DayOfWeekEntry, StorageStrategy = SQLStorage ]
{

/// CT_DayOfWeekEntry Row ID
/// Property DOWERowId As %Float [ Required, SqlFieldName = DOWE_RowId ];
/// Day 1
Property DOWEDay1 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DOWE_Day1 ];

/// Day 2
Property DOWEDay2 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DOWE_Day2 ];

/// Day 3
Property DOWEDay3 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = DOWE_Day3 ];

/// Day 4
Property DOWEDay4 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 5, SqlFieldName = DOWE_Day4 ];

/// Day 5
Property DOWEDay5 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 6, SqlFieldName = DOWE_Day5 ];

/// Day 6
Property DOWEDay6 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 7, SqlFieldName = DOWE_Day6 ];

/// Day 7
Property DOWEDay7 As %String(COLLATION = "AlphaUp", MAXLEN = 9, TRUNCATE = 1) [ Required, SqlColumnNumber = 8, SqlFieldName = DOWE_Day7 ];

/// Sequence 1
Property DOWESeq1 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 9, SqlFieldName = DOWE_Seq1 ];

/// Sequence 2
Property DOWESeq2 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 10, SqlFieldName = DOWE_Seq2 ];

/// Sequence 3
Property DOWESeq3 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 11, SqlFieldName = DOWE_Seq3 ];

/// Sequence 4
Property DOWESeq4 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 12, SqlFieldName = DOWE_Seq4 ];

/// Sequence 5
Property DOWESeq5 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 13, SqlFieldName = DOWE_Seq5 ];

/// Sequence 6
Property DOWESeq6 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 14, SqlFieldName = DOWE_Seq6 ];

/// Sequence 7
Property DOWESeq7 As %Numeric(MAXVAL = 7, MINVAL = 1, SCALE = 0) [ Required, SqlColumnNumber = 15, SqlFieldName = DOWE_Seq7 ];

/// Checked1
Property DOWEChecked1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 16, SqlFieldName = DOWE_Checked1 ];

/// Checked2
Property DOWEChecked2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 17, SqlFieldName = DOWE_Checked2 ];

/// Checked3
Property DOWEChecked3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 18, SqlFieldName = DOWE_Checked3 ];

/// Checked4
Property DOWEChecked4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 19, SqlFieldName = DOWE_Checked4 ];

/// Checked5
Property DOWEChecked5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 20, SqlFieldName = DOWE_Checked5 ];

/// Checked6
Property DOWEChecked6 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 21, SqlFieldName = DOWE_Checked6 ];

/// Checked7
Property DOWEChecked7 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 22, SqlFieldName = DOWE_Checked7 ];

/// Weekend1
Property DOWEWeekend1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DOWE_Weekend1 ];

/// Weekend2
Property DOWEWeekend2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = DOWE_Weekend2 ];

/// Weekend3
Property DOWEWeekend3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = DOWE_Weekend3 ];

/// Weekend4
Property DOWEWeekend4 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = DOWE_Weekend4 ];

/// Weekend5
Property DOWEWeekend5 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = DOWE_Weekend5 ];

/// Weekend6
Property DOWEWeekend6 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = DOWE_Weekend6 ];

/// Weekend7
Property DOWEWeekend7 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 29, SqlFieldName = DOWE_Weekend7 ];

Index DOWESeq1UnqIdx2 On DOWESeq1 [ Unique ];

Index DOWESeq2UnqIdx3 On DOWESeq2 [ Unique ];

Index DOWESeq3UnqIdx4 On DOWESeq3 [ Unique ];

Index DOWESeq4UnqIdx5 On DOWESeq4 [ Unique ];

Index DOWESeq5UnqIdx6 On DOWESeq5 [ Unique ];

Index DOWESeq6UnqIdx7 On DOWESeq6 [ Unique ];

Index DOWESeq7UnqIdx8 On DOWESeq7 [ Unique ];

/// Index RowIDBasedIDKeyIndex On DOWERowId [ IdKey, PrimaryKey, Unique ];
Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTDayOfWeekEntry).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDayOfWeekEntry","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTDayOfWeekEntry).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDayOfWeekEntry","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTDayOfWeekEntry).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDayOfWeekEntry","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTDayOfWeekEntry).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDayOfWeekEntry","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTDayOfWeekEntry).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDayOfWeekEntry","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTDayOfWeekEntry","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterDOWE">
<Data name="DOWE_Checked1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Checked2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Checked3">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Checked4">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Checked5">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Checked6">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Checked7">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>3</Piece>
</Data>
<Data name="DOWE_Day1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Day2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Day3">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Day4">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Day5">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Day6">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Day7">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>1</Piece>
</Data>
<Data name="DOWE_Seq1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Seq2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Seq3">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Seq4">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Seq5">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Seq6">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Seq7">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>2</Piece>
</Data>
<Data name="DOWE_Weekend1">
<Delimiter>"^"</Delimiter>
<Node>1</Node>
<Piece>4</Piece>
</Data>
<Data name="DOWE_Weekend2">
<Delimiter>"^"</Delimiter>
<Node>2</Node>
<Piece>4</Piece>
</Data>
<Data name="DOWE_Weekend3">
<Delimiter>"^"</Delimiter>
<Node>3</Node>
<Piece>4</Piece>
</Data>
<Data name="DOWE_Weekend4">
<Delimiter>"^"</Delimiter>
<Node>4</Node>
<Piece>4</Piece>
</Data>
<Data name="DOWE_Weekend5">
<Delimiter>"^"</Delimiter>
<Node>5</Node>
<Piece>4</Piece>
</Data>
<Data name="DOWE_Weekend6">
<Delimiter>"^"</Delimiter>
<Node>6</Node>
<Piece>4</Piece>
</Data>
<Data name="DOWE_Weekend7">
<Delimiter>"^"</Delimiter>
<Node>7</Node>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOWE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DOW"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DOWE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DOWE_RowId</SqlRowIdName>
<StreamLocation>^User.CTDayOfWeekEntryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

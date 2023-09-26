/// SS Report(1838)
Class User.SSReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Report, StorageStrategy = SQLStorage ]
{

/// Field1
Property REPField1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = REP_Field1 ];

/// Field10
Property REPField10 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = REP_Field10 ];

/// Field11
Property REPField11 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = REP_Field11 ];

/// Field12
Property REPField12 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = REP_Field12 ];

/// Field13
Property REPField13 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = REP_Field13 ];

/// Field14
Property REPField14 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = REP_Field14 ];

/// Field15
Property REPField15 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = REP_Field15 ];

/// Field16
Property REPField16 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = REP_Field16 ];

/// Field17
Property REPField17 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = REP_Field17 ];

/// Field18
Property REPField18 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = REP_Field18 ];

/// Field19
Property REPField19 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = REP_Field19 ];

/// Field2
Property REPField2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = REP_Field2 ];

/// Field20
Property REPField20 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = REP_Field20 ];

/// Field21
Property REPField21 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = REP_Field21 ];

/// Field22
Property REPField22 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = REP_Field22 ];

/// Field23
Property REPField23 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = REP_Field23 ];

/// Field24
Property REPField24 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = REP_Field24 ];

/// Field25
Property REPField25 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = REP_Field25 ];

/// Field26
Property REPField26 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = REP_Field26 ];

/// Field27
Property REPField27 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = REP_Field27 ];

/// Field28
Property REPField28 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = REP_Field28 ];

/// Field29
Property REPField29 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = REP_Field29 ];

/// Field3
Property REPField3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = REP_Field3 ];

/// Field30
Property REPField30 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = REP_Field30 ];

/// Field4
Property REPField4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = REP_Field4 ];

/// Field5
Property REPField5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = REP_Field5 ];

/// Field6
Property REPField6 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = REP_Field6 ];

/// Field7
Property REPField7 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = REP_Field7 ];

/// Field8
Property REPField8 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = REP_Field8 ];

/// Field9
Property REPField9 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = REP_Field9 ];

/// Key1
Property REPKey1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = REP_Key1 ];

/// Key2
Property REPKey2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = REP_Key2 ];

Index RowIDBasedIDKeyIndex On (REPKey1, REPKey2) [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSReport).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSReport","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSReport).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSReport","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSReport).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSReport","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSReport).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSReport","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSReport).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSReport","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Master">
<Data name="REP_Field1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="REP_Field10">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="REP_Field11">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="REP_Field12">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="REP_Field13">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="REP_Field14">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="REP_Field15">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="REP_Field16">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="REP_Field17">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="REP_Field18">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="REP_Field19">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="REP_Field2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="REP_Field20">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="REP_Field21">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="REP_Field22">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="REP_Field23">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="REP_Field24">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="REP_Field25">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="REP_Field26">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="REP_Field27">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="REP_Field28">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="REP_Field29">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="REP_Field3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="REP_Field30">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="REP_Field4">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="REP_Field5">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="REP_Field6">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="REP_Field7">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="REP_Field8">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="REP_Field9">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^TMP</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>REP_Key1</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>REP_Key2</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"REPORT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{REP_Key1}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REP_Key2}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>REP_RowId</SqlRowIdName>
<StreamLocation>^User.SSReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

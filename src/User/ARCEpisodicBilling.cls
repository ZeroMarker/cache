/// ARC Episodic Billing(1871)
Class User.ARCEpisodicBilling Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_EpisodicBilling, StorageStrategy = SQLStorage ]
{

/// Bill Field1
Property EPBBillField1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = EPB_BillField1 ];

/// Bill Field2
Property EPBBillField2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EPB_BillField2 ];

/// Bill Field3
Property EPBBillField3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EPB_BillField3 ];

/// Bill Field4
Property EPBBillField4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = EPB_BillField4 ];

/// Bill Field5
Property EPBBillField5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EPB_BillField5 ];

/// Bill Field6
Property EPBBillField6 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EPB_BillField6 ];

/// Bill Field7
Property EPBBillField7 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EPB_BillField7 ];

/// Bill Field8
Property EPBBillField8 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = EPB_BillField8 ];

/// BillField 9
Property EPBBillField9 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = EPB_BillField9 ];

/// Bill Field 10
Property EPBBillField10 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = EPB_BillField10 ];

/// Bill Field 11
Property EPBBillField11 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = EPB_BillField11 ];

/// Bill Field 12
Property EPBBillField12 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = EPB_BillField12 ];

/// Bill Field13
Property EPBBillField13 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = EPB_BillField13 ];

/// Bill Field14
Property EPBBillField14 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = EPB_BillField14 ];

/// Bill Field15
Property EPBBillField15 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = EPB_BillField15 ];

/// Bill Field16
Property EPBBillField16 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = EPB_BillField16 ];

/// Bill Field17
Property EPBBillField17 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = EPB_BillField17 ];

/// Bill Field18
Property EPBBillField18 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = EPB_BillField18 ];

/// Bill Field19
Property EPBBillField19 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = EPB_BillField19 ];

/// BillField20
Property EPBBillField20 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = EPB_BillField20 ];

/// BillField21
Property EPBBillField21 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = EPB_BillField21 ];

/// BillField22
Property EPBBillField22 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = EPB_BillField22 ];

/// BillField23
Property EPBBillField23 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = EPB_BillField23 ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCEpisodicBilling).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCEpisodicBilling","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCEpisodicBilling).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCEpisodicBilling","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCEpisodicBilling).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCEpisodicBilling","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCEpisodicBilling).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCEpisodicBilling","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCEpisodicBilling).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCEpisodicBilling","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCEpisodicBilling","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("EPB",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="EPB_BillField1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPB_BillField10">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EPB_BillField11">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EPB_BillField12">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EPB_BillField13">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EPB_BillField14">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EPB_BillField15">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EPB_BillField16">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EPB_BillField17">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EPB_BillField18">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EPB_BillField19">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EPB_BillField2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPB_BillField20">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EPB_BillField21">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EPB_BillField22">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="EPB_BillField23">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EPB_BillField3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EPB_BillField4">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EPB_BillField5">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EPB_BillField6">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EPB_BillField7">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EPB_BillField8">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EPB_BillField9">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EPB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EPB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EPB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EPB_RowId</SqlRowIdName>
<StreamLocation>^User.ARCEpisodicBillingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

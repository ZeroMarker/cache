/// BLC MultOperDiscount(1200)
Class User.BLCMultOperDisc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_MultOperDisc, StorageStrategy = SQLStorage ]
{

/// Date From
Property MULTOPDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = MULTOP_DateFrom ];

/// Date To
Property MULTOPDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = MULTOP_DateTo ];

/// % Discount
Property MULTOPPerc As %Float [ SqlColumnNumber = 2, SqlFieldName = MULTOP_Perc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCMultOperDisc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMultOperDisc","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCMultOperDisc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMultOperDisc","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCMultOperDisc).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMultOperDisc","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCMultOperDisc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMultOperDisc","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCMultOperDisc).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCMultOperDisc","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="MULTOPDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MULTOPDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MULTOPPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("MULTOP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MULTOP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MULTOP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MULTOP_Perc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MULTOP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MULTOP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MULTOP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MULTOP_RowId</SqlRowIdName>
<StreamLocation>^User.BLCMultOperDiscS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

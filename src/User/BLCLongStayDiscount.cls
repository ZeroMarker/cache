/// BLC Long Stay Discount(1197)
Class User.BLCLongStayDiscount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_LongStayDiscount, StorageStrategy = SQLStorage ]
{

/// Day From
Property LONGSDDayFrom As %Float [ SqlColumnNumber = 2, SqlFieldName = LONGSD_DayFrom ];

/// Day To
Property LONGSDDayTo As %Float [ SqlColumnNumber = 3, SqlFieldName = LONGSD_DayTo ];

/// Des Ref to InsType_DR
Property LONGSDInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 4, SqlFieldName = LONGSD_InsType_DR ];

/// % Discount
Property LONGSDPerc As %Float [ SqlColumnNumber = 5, SqlFieldName = LONGSD_Perc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCLongStayDiscount).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLongStayDiscount","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCLongStayDiscount).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLongStayDiscount","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCLongStayDiscount).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLongStayDiscount","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCLongStayDiscount).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLongStayDiscount","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCLongStayDiscount).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.BLCLongStayDiscount","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="LONGSDDayFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LONGSDDayTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LONGSDInsTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LONGSDPerc">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^BLC("LONGSD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LONGSD_DayFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LONGSD_DayTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LONGSD_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LONGSD_Perc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LONGSD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LONGSD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LONGSD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LONGSD_RowId</SqlRowIdName>
<StreamLocation>^User.BLCLongStayDiscountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

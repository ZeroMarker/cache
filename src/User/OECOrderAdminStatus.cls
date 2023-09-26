/// Order AdminStatus          (OECST,)
Class User.OECOrderAdminStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_Order_AdminStatus, StorageStrategy = SQLStorage ]
{

/// Code
Property STATCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = STAT_Code ];

/// Description
Property STATDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = STAT_Desc ];

/// Bill flag
Property STATBill As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = STAT_Bill ];

/// Deduct Stock flag
Property STATDeductStock As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = STAT_DeductStock ];

/// IVCompleted
Property STATIVCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = STAT_IVCompleted ];

/// CanAdminSkinTest
Property STATCanAdminSkinTest As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = STAT_CanAdminSkinTest ];

Index STATCodeUnqIdx1 On STATCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECOrderAdminStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderAdminStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECOrderAdminStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderAdminStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECOrderAdminStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderAdminStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECOrderAdminStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderAdminStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderAdminStatus","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECOrderAdminStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrderAdminStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="STATBill">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="STATCanAdminSkinTest">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="STATCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="STATDeductStock">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="STATDesc">
<Selectivity>5.2632%</Selectivity>
</Property>
<Property name="STATIVCompleted">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("STAT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="STAT_Bill">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STAT_CanAdminSkinTest">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="STAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STAT_DeductStock">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="STAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STAT_IVCompleted">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>STAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{STAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STAT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>STAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({STAT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{STAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>STAT_RowId</SqlRowIdName>
<StreamLocation>^User.OECOrderAdminStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

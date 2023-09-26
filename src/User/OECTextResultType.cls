/// OEC Text Result Type(1391)
Class User.OECTextResultType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_TextResultType, StorageStrategy = SQLStorage ]
{

Relationship ChildOECTextResultSection As OECTextResultSection [ Cardinality = children, Inverse = SECParRef ];

/// Result Name
Property TRTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = TRT_Desc ];

/// ModifyFlag
Property TRTModifyFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = TRT_ModifyFlag ];

Index TRTDescUnqIdx1 On TRTDesc [ Unique ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OECTextResultType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultType","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OECTextResultType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OECTextResultType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OECTextResultType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OECTextResultType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECTextResultType","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="TRTDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="TRTModifyFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^OEC("TRT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TRT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TRT_ModifyFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TRT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TRT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TRT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TRT_RowId</SqlRowIdName>
<StreamLocation>^User.OECTextResultTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

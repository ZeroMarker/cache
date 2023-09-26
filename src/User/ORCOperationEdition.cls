/// Operation Edition(2176)
Class User.ORCOperationEdition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_OperationEdition, StorageStrategy = SQLStorage ]
{

/// Childsub
Property EDChildsub As %Float [ InitialExpression = {$i(^ORC("OPER",$p(%d(0),$c(1)),"ED",0))}, SqlColumnNumber = 2, SqlFieldName = ED_Childsub ];

/// Date From
Property EDDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ED_DateFrom ];

/// Date To
Property EDDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ED_DateTo ];

/// Des Ref Edition
Property EDEditionDR As MRCICDEdition [ SqlColumnNumber = 3, SqlFieldName = ED_Edition_DR ];

/// ORC_Operation Parent Reference
Relationship EDParRef As ORCOperation [ Cardinality = parent, Inverse = ChildORCOperationEdition, Required, SqlFieldName = ED_ParRef ];

Index RowIDBasedIDKeyIndex On EDChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCOperationEdition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationEdition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCOperationEdition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationEdition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCOperationEdition).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationEdition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCOperationEdition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationEdition","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCOperationEdition).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ORCOperationEdition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ED_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ED_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ED_Edition_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Operation.OPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Operation.OPER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEdition">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Operation.OPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ED_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Operation.OPER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ED"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Edition"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ED_Edition_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ED_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperationEditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

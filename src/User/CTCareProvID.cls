/// CT Care Prov ID(1792)
Class User.CTCareProvID Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CareProvID, StorageStrategy = SQLStorage ]
{

/// Childsub
Property IDChildsub As %Float [ InitialExpression = {$i(^CTPCP($p(%d(0),$c(1)),"ID",0))}, SqlColumnNumber = 2, SqlFieldName = ID_Childsub ];

/// ClaimID
Property IDClaimID As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ID_ClaimID ];

/// Date From
Property IDDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ID_DateFrom ];

/// Date To
Property IDDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ID_DateTo ];

/// CT_CareProv Parent Reference
Relationship IDParRef As CTCareProv [ Cardinality = parent, Inverse = ChildCTCareProvID, Required, SqlFieldName = ID_ParRef ];

Index RowIDBasedIDKeyIndex On IDChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCareProvID).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvID","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCareProvID).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvID","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCareProvID).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvID","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCareProvID).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvID","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCareProvID).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTCareProvID","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="IDChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IDClaimID">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IDDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IDDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="IDParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ID_ClaimID">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ID_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ID_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CTPCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ID_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ID_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^CTPCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_CareProv.CTPCP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ID_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_CareProv.CTPCP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DateFrom"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ID_DateFrom}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ID_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ID_RowId</SqlRowIdName>
<StreamLocation>^User.CTCareProvIDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

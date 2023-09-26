/// RVC Rejection CodeNFMI(1177)
Class User.RVCRejectionCodeNFMI Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVC_RejectionCodeNFMI, StorageStrategy = SQLStorage ]
{

/// Code
Property RNFMICode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = RNFMI_Code ];

/// Description
Property RNFMIDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RNFMI_Desc ];

Index RNFMICodeUnqIdx1 On RNFMICode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVCRejectionCodeNFMI).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCRejectionCodeNFMI","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVCRejectionCodeNFMI).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCRejectionCodeNFMI","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVCRejectionCodeNFMI).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCRejectionCodeNFMI","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVCRejectionCodeNFMI).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCRejectionCodeNFMI","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVCRejectionCodeNFMI).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVCRejectionCodeNFMI","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RVC("RNFMI",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RNFMI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RNFMI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RVC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RNFMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RNFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RNFMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNFMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RNFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RNFMI_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNFMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RVC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNFMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RNFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RNFMI_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNFMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RNFMI_RowId</SqlRowIdName>
<StreamLocation>^User.RVCRejectionCodeNFMIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

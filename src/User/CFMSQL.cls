/// MSQL Config String      (MSCF,1053)
Class User.CFMSQL Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_MSQL, StorageStrategy = SQLStorage ]
{

/// MSQL Configuration String
Property MSCFString As %String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MSCF_String ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFMSQL).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMSQL","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFMSQL).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMSQL","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFMSQL).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMSQL","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFMSQL).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMSQL","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFMSQL).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFMSQL","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("MSQL"))</SqlIdExpression>
<SQLMap name="DataMasterMSCF">
<Data name="MSCF_String"/>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MSCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"MSQL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MSCF_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MSCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFMSQLS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

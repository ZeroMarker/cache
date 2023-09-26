/// CT NFMI Category Department(1366)
Class User.CTNFMICategDepart Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_NFMI_CategDepart, StorageStrategy = SQLStorage ]
{

Relationship ChildCTNFMICategDepPayor As CTNFMICategDepPayor [ Cardinality = children, Inverse = PAParRef ];

/// Childsub
Property DEPChildsub As %Float [ InitialExpression = {$i(^CT("NFMI",$s($d(initvalue):initvalue,1:%d(0)),"DEP",0))}, SqlColumnNumber = 2, SqlFieldName = DEP_Childsub ];

/// Code
Property DEPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = DEP_Code ];

/// Description
Property DEPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = DEP_Desc ];

/// CT_NFMI_Category Parent Reference
Relationship DEPParRef As CTNFMICategory [ Cardinality = parent, Inverse = ChildCTNFMICategDepart, Required, SqlFieldName = DEP_ParRef ];

/// Priority
Property DEPPriority As %Float [ SqlColumnNumber = 5, SqlFieldName = DEP_Priority ];

Index DEPPriorityUnqIdx1 On DEPPriority [ Unique ];

Index RowIDBasedIDKeyIndex On DEPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 17;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTNFMICategDepart).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepart","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTNFMICategDepart).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepart","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTNFMICategDepart).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepart","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTNFMICategDepart).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepart","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTNFMICategDepart).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTNFMICategDepart","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>17</ExtentSize>
<Property name="DEPChildsub">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DEPCode">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="DEPDesc">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="DEPParRef">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="DEPPriority">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="DEP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEP_Priority">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_NFMI_Category.NFMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_NFMI_Category.NFMI_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DEP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_NFMI_Category.NFMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NFMI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DEPCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DEP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_NFMI_Category.NFMI_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DEP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DEP_RowId</SqlRowIdName>
<StreamLocation>^User.CTNFMICategDepartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// Body Parts              (MRBP,1066)
Class User.MRCBodyParts Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodyParts, StorageStrategy = SQLStorage ]
{

/// Code
Property BODPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = BODP_Code ];

/// Description
Property BODPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = BODP_Desc ];

/// Des Ref to CTLOC
Property BODPCTLOCDR As CTLoc [ SqlColumnNumber = 4, SqlFieldName = BODP_CTLOC_DR ];

/// 输液部位标志
Property BODPInfusionFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BODP_InfusionFlag ];

Relationship ChildMRCBodyPartsSymptoms As MRCBodyPartsSymptoms [ Cardinality = children, Inverse = SYMParRef ];

Index BODPCodeUnqIdx1 On BODPCode [ Unique ];

Parameter EXTENTSIZE = 67;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodyParts).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyParts","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodyParts).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyParts","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodyParts).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyParts","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodyParts).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyParts","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodyParts).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyParts","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>67</ExtentSize>
<Property name="BODPCTLOCDR">
<Selectivity>5.0000%</Selectivity>
</Property>
<Property name="BODPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="BODPDesc">
<Selectivity>1.9231%</Selectivity>
</Property>
<SqlIdExpression>$i(^MRC("BODP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BODP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BODP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BODP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BODP_InfusionFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BODP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BODP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BODP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BODP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BODP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BODP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BODP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BODP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BODP_RowId</SqlRowIdName>
<StreamLocation>^User.MRCBodyPartsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

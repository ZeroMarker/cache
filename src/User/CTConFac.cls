/// CT Conversion Factor     (CTCF,323)
Class User.CTConFac Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_ConFac, StorageStrategy = SQLStorage ]
{

/// Record In Use
Property CTCFActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 6, SqlFieldName = CTCF_ActiveFlag ];

/// Conversion Factor
Property CTCFFactor As %Float [ Required, SqlColumnNumber = 4, SqlFieldName = CTCF_Factor ];

/// Des Ref to CTUOM
Property CTCFFrUOMDR As CTUOM [ Required, SqlColumnNumber = 2, SqlFieldName = CTCF_FrUOM_DR ];

/// Des Ref to CTUOM
Property CTCFToUOMDR As CTUOM [ Required, SqlColumnNumber = 3, SqlFieldName = CTCF_ToUOM_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTConFac).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTConFac","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTConFac).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTConFac","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTConFac).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTConFac","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTConFac).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTConFac","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTConFac).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTConFac","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="CTCFActiveFlag">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTCFFactor">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CTCFFrUOMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CTCFToUOMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("CTCF",0))</SqlIdExpression>
<SQLMap name="CTCFDataMastermap">
<Data name="CTCF_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTCF_Factor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTCF_FrUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTCF_ToUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTCF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTCF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTCF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="CTCFIndexUOM">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CTCF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTCF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"UOM"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTCF_FrUOM_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTCF_ToUOM_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{CTCF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTCF_RowID</SqlRowIdName>
<StreamLocation>^User.CTConFacS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

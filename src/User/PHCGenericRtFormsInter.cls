/// GenericRtFormsInter(2621)
Class User.PHCGenericRtFormsInter Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericRtFormsInter, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INTChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_GenericRtForms Parent Reference
Relationship INTParRef As PHCGenericRtForms [ Cardinality = parent, Inverse = ChildPHCGenericRtFormsInter, Required, SqlFieldName = INT_ParRef ];

/// Childsub
Property INTChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RTF",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"INT",0))}, SqlColumnNumber = 2, SqlFieldName = INT_Childsub ];

/// Des Ref GenRouteForm
Property INTGenRouteFormDR As PHCGenericRtForms [ SqlColumnNumber = 3, SqlFieldName = INT_GenRouteForm_DR ];

/// Des Ref Severity
Property INTSeverityDR As PHCDrugInteractSeverity [ SqlColumnNumber = 4, SqlFieldName = INT_Severity_DR ];

/// Des Ref Monograph
Property INTMonographDR As PHCMonograph [ SqlColumnNumber = 5, SqlFieldName = INT_Monograph_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsInter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsInter","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsInter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsInter","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsInter).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsInter","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCGenericRtFormsInter).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsInter","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCGenericRtFormsInter).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsInter","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="INT_GenRouteForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INT_Monograph_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INT_Severity_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_GenericRtForms.RTF_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>INT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_GenericRtForms.RTF_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRTF">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_GenericRtForms.RTF_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>INT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_GenericRtForms.RTF_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"INT"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INT_GenRouteForm_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{INT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INT_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericRtFormsInterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

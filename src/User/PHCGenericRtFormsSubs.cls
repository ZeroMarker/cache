/// GenericRtFormsSubs(2642)
Class User.PHCGenericRtFormsSubs Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericRtFormsSubs, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SUBSChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_GenericRtForms Parent Reference
Relationship SUBSParRef As PHCGenericRtForms [ Cardinality = parent, Inverse = ChildPHCGenericRtFormsSubs, Required, SqlFieldName = SUBS_ParRef ];

/// Childsub
Property SUBSChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RTF",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SUBS",0))}, SqlColumnNumber = 2, SqlFieldName = SUBS_Childsub ];

/// Des Ref GenRtForm
Property SUBSGenRtFormDR As PHCGenericRtForms [ SqlColumnNumber = 3, SqlFieldName = SUBS_GenRtForm_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PHCGenericRtFormsSubs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsSubs","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PHCGenericRtFormsSubs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsSubs","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PHCGenericRtFormsSubs).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsSubs","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PHCGenericRtFormsSubs).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsSubs","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PHCGenericRtFormsSubs).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsSubs","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsSubs","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="SUBS_GenRtForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Field>SUBS_Childsub</Field>
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
<Expression>"SUBS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRtForm">
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
<Field>SUBS_Childsub</Field>
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
<Expression>"SUBS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"GenRtForm"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{SUBS_GenRtForm_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{SUBS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUBS_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericRtFormsSubsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

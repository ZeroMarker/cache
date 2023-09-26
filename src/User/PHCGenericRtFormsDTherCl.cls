/// GenericRtFormsDTherCl(2620)
Class User.PHCGenericRtFormsDTherCl Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericRtFormsDTherCl, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DTCChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_GenericRtForms Parent Reference
Relationship DTCParRef As PHCGenericRtForms [ Cardinality = parent, Inverse = ChildPHCGenericRtFormsDTherCl, Required, SqlFieldName = DTC_ParRef ];

/// Childsub
Property DTCChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RTF",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DTC",0))}, SqlColumnNumber = 2, SqlFieldName = DTC_Childsub ];

/// Des Ref DuplTherClass
Property DTCDuplTherClassDR As PHCDuplicateTherClass [ SqlColumnNumber = 3, SqlFieldName = DTC_DuplTherClass_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsDTherCl).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsDTherCl","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsDTherCl).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsDTherCl","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsDTherCl).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsDTherCl","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCGenericRtFormsDTherCl).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsDTherCl","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCGenericRtFormsDTherCl).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsDTherCl","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DTC_DuplTherClass_DR">
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
<Field>DTC_Childsub</Field>
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
<Expression>"DTC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DTC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDuplTC">
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
<Field>DTC_Childsub</Field>
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
<Expression>"DTC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"DuplTC"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DTC_DuplTherClass_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{DTC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DTC_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericRtFormsDTherClS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

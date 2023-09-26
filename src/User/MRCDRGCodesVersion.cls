/// DRGCodesVersion(2288)
Class User.MRCDRGCodesVersion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_DRGCodesVersion, StorageStrategy = SQLStorage ]
{

/// Childsub
Property VERChildsub As %Float [ InitialExpression = {$i(^MRC("DRG",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"VER",0))}, SqlColumnNumber = 2, SqlFieldName = VER_Childsub ];

/// MRC_DRGCodes Parent Reference
Relationship VERParRef As MRCDRGCodes [ Cardinality = parent, Inverse = ChildMRCDRGCodesVersion, Required, SqlFieldName = VER_ParRef ];

/// Des Ref Version
Property VERVersionDR As MRCDRGVersion [ SqlColumnNumber = 3, SqlFieldName = VER_Version_DR ];

Index RowIDBasedIDKeyIndex On VERChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodesVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodesVersion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodesVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodesVersion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCDRGCodesVersion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodesVersion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCDRGCodesVersion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodesVersion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCDRGCodesVersion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCDRGCodesVersion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="VERChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="VERParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="VERVersionDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VER_Version_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_DRGCodes.DRG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>VER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCodes.DRG_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVersion">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_DRGCodes.DRG_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>VER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_DRGCodes.DRG_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Version"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{VER_Version_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{VER_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VER_RowId</SqlRowIdName>
<StreamLocation>^User.MRCDRGCodesVersionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

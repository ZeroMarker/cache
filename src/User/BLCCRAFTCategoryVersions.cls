/// CRAFT Category Versions(2315)
Class User.BLCCRAFTCategoryVersions Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = BLC_CRAFTCategoryVersions, StorageStrategy = SQLStorage ]
{

/// Childsub
Property VERChildsub As %Float [ InitialExpression = {$i(^BLC("CRAFTC",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"VER",0))}, SqlColumnNumber = 2, SqlFieldName = VER_Childsub ];

/// BLC_CRAFTCategory Parent Reference
Relationship VERParRef As BLCCRAFTCategory [ Cardinality = parent, Inverse = ChildBLCCRAFTCategoryVersions, Required, SqlFieldName = VER_ParRef ];

/// Des Ref Version
Property VERVersionDR As BLCCRAFTVersion [ SqlColumnNumber = 3, SqlFieldName = VER_Version_DR ];

Index RowIDBasedIDKeyIndex On VERChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 4;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTCategoryVersions).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategoryVersions","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTCategoryVersions).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategoryVersions","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.BLCCRAFTCategoryVersions).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategoryVersions","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.BLCCRAFTCategoryVersions).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategoryVersions","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.BLCCRAFTCategoryVersions).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.BLCCRAFTCategoryVersions","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="VERChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="VERParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="VERVersionDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VER_Version_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^BLC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BLC_CRAFTCategory.CRAFTC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>VER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{BLC_CRAFTCategory.CRAFTC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VER_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexVersion">
<Global>^BLC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BLC_CRAFTCategory.CRAFTC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>VER_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CRAFTC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BLC_CRAFTCategory.CRAFTC_RowId}</Expression>
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
<StreamLocation>^User.BLCCRAFTCategoryVersionsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

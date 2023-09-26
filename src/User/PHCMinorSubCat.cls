/// Minor SubCategory      (PHCMS,1207)
Class User.PHCMinorSubCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PHC_MinorSubCat, StorageStrategy = SQLStorage ]
{

/// Childsub
Property MINChildsub As %Float [ InitialExpression = {$i(^PHCC($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"SC",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"MIN",0))}, SqlColumnNumber = 2, SqlFieldName = MIN_Childsub ];

/// Code
Property MINCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = MIN_Code ];

/// Description
Property MINDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = MIN_Desc ];

/// PHC_SubCat Parent Reference
Relationship MINParRef As PHCSubCat [ Cardinality = parent, Inverse = ChildPHCMinorSubCat, Required, SqlFieldName = MIN_ParRef ];

Index RowIDBasedIDKeyIndex On MINChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCMinorSubCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCMinorSubCat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCMinorSubCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCMinorSubCat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCMinorSubCat).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCMinorSubCat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCMinorSubCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCMinorSubCat","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCMinorSubCat).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PHCMinorSubCat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MIN_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MIN_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PHCC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHC_Cat.PHCC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHC_SubCat.PHCSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PHC_Cat.PHCC_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_SubCat.PHCSC_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"MIN"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIN_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PHCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_Cat.PHCC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_SubCat.PHCSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MIN_Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({MIN_Code})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_Cat.PHCC_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_SubCat.PHCSC_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PHCC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHC_Cat.PHCC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_SubCat.PHCSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MIN_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MIN_Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({MIN_Desc})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHC_Cat.PHCC_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_SubCat.PHCSC_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MIN_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MIN_RowId</SqlRowIdName>
<StreamLocation>^User.PHCMinorSubCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// Insurance Subcategory(1108)
Class User.ARCInsuranceSubcategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_InsuranceSubcategory, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SUBChildsub As %Float [ InitialExpression = {$i(^ARC("INSC",$p(%d(0),$c(1)),"SUB",0))}, SqlColumnNumber = 2, SqlFieldName = SUB_Childsub ];

/// Code
Property SUBCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SUB_Code ];

/// Description
Property SUBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SUB_Desc ];

/// ARC_InsuranceCategory Parent Reference
Relationship SUBParRef As ARCInsuranceCategory [ Cardinality = parent, Inverse = ChildARCInsuranceSubcategory, Required, SqlFieldName = SUB_ParRef ];

Index RowIDBasedIDKeyIndex On SUBChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 20;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceSubcategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceSubcategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceSubcategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceSubcategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsuranceSubcategory).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceSubcategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsuranceSubcategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceSubcategory","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsuranceSubcategory).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsuranceSubcategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>20</ExtentSize>
<Property name="SUBChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SUBCode">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="SUBDesc">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="SUBParRef">
<Selectivity>5.2632%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SUB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_InsuranceCategory.INSC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_InsuranceCategory.INSC_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUB_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsuranceSubcategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

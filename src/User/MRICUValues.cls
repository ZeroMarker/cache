/// MR ICU Values(1318)
Class User.MRICUValues Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_ICUValues, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ICUVChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),$c(1)),"ICUV",0))}, SqlColumnNumber = 2, SqlFieldName = ICUV_Childsub ];

/// Date Created
Property ICUVDateCreated As %Date [ InitialExpression = "T", SqlColumnNumber = 5, SqlFieldName = ICUV_DateCreated ];

/// Des Ref to MRC ICU
Property ICUVICUDR As MRCIntensiveCareUnit [ SqlColumnNumber = 3, SqlFieldName = ICUV_ICU_DR ];

/// MR_Adm Parent Reference
Relationship ICUVParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRICUValues, Required, SqlFieldName = ICUV_ParRef ];

/// Time Created
Property ICUVTimeCreated As %Time [ InitialExpression = "N", SqlColumnNumber = 6, SqlFieldName = ICUV_TimeCreated ];

/// User Created
Property ICUVUserCreated As SSUser [ SqlColumnNumber = 7, SqlFieldName = ICUV_UserCreated ];

/// Value
Property ICUVValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ICUV_Value ];

Index RowIDBasedIDKeyIndex On ICUVChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRICUValues).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRICUValues","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRICUValues).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRICUValues","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRICUValues).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRICUValues","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRICUValues).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRICUValues","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRICUValues).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRICUValues","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUV_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUV_ICU_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUV_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUV_UserCreated">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUV_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUV_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICUV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUV_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICUV_RowId</SqlRowIdName>
<StreamLocation>^User.MRICUValuesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

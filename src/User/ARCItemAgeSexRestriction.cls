/// Item Age Sex Restrictions(1922)
Class User.ARCItemAgeSexRestriction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemAgeSexRestriction, StorageStrategy = SQLStorage ]
{

/// Age From
Property AGEAgeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AGE_AgeFrom ];

/// AgeTo
Property AGEAgeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = AGE_AgeTo ];

/// Childsub
Property AGEChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"AGE",0))}, SqlColumnNumber = 2, SqlFieldName = AGE_Childsub ];

/// ARC_ItmMast Parent Reference
Relationship AGEParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemAgeSexRestriction, Required, SqlFieldName = AGE_ParRef ];

/// Des Ref Sex
Property AGESexDR As CTSex [ SqlColumnNumber = 3, SqlFieldName = AGE_Sex_DR ];

/// 从年龄类型 （岁/月/日） ^4
Property AGEAgeFromType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = AGE_AgeFromType ];

/// 到年龄类型 （岁/月/日） ^5
Property AGEAgeToType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = AGE_AgeToType ];

Index RowIDBasedIDKeyIndex On AGEChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 9;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemAgeSexRestriction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemAgeSexRestriction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemAgeSexRestriction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemAgeSexRestriction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemAgeSexRestriction).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemAgeSexRestriction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemAgeSexRestriction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemAgeSexRestriction","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemAgeSexRestriction).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCItemAgeSexRestriction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>9</ExtentSize>
<Property name="AGEAgeFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="AGEAgeTo">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="AGEChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="AGEParRef">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="AGESexDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="AGE_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AGE_AgeFromType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AGE_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AGE_AgeToType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AGE_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>AGE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AGE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AGE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AGE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemAgeSexRestrictionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// Executable Translation (SSVBT,1158)
Class User.SSVBExecTranslation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_VBExecTranslation, StorageStrategy = SQLStorage ]
{

/// Translation
Property EXTRDesc As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EXTR_Desc ];

/// SS_VBExecutables Parent Reference
Relationship EXTRParRef As SSVBExecutables [ Cardinality = parent, Inverse = ChildSSVBExecTranslation, Required, SqlFieldName = EXTR_ParRef ];

/// Des Ref to SSLAN
Property EXTRSSLANDR As SSLanguage [ Required, SqlColumnNumber = 2, SqlFieldName = EXTR_SSLAN_DR ];

Index RowIDBasedIDKeyIndex On EXTRSSLANDR [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 15;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSVBExecTranslation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecTranslation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSVBExecTranslation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecTranslation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSVBExecTranslation).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecTranslation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSVBExecTranslation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecTranslation","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSVBExecTranslation).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSVBExecTranslation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="EXTRDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXTRParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="EXTRSSLANDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="EXTR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_VBExecutables.SSVBE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EXTR_SSLAN_DR</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSVBE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_VBExecutables.SSVBE_RowID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TRANS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXTR_SSLAN_DR}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EXTR_RowId</SqlRowIdName>
<StreamLocation>^User.SSVBExecTranslationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// RVI InsCoBill Location(1288)
Class User.RVIInsCoBillLocation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RVI_InsCoBillLocation, StorageStrategy = SQLStorage ]
{

/// Childsub
Property LOCChildsub As %Float [ InitialExpression = {$i(^RVI($p(%d(0),$c(1)),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = LOC_Childsub ];

/// Des Ref to NFMIDep
Property LOCNFMIDepDR As CTNFMICategDepart [ SqlColumnNumber = 3, SqlFieldName = LOC_NFMIDep_DR ];

/// RVI_InsCompanyBill Parent Reference
Relationship LOCParRef As RVIInsCompanyBill [ Cardinality = parent, Inverse = ChildRVIInsCoBillLocation, Required, SqlFieldName = LOC_ParRef ];

/// Print
Property LOCPrint As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LOC_Print ];

Index RowIDBasedIDKeyIndex On LOCChildsub [ IdKey, PrimaryKey, Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillLocation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillLocation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RVIInsCoBillLocation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillLocation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RVIInsCoBillLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillLocation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RVIInsCoBillLocation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RVIInsCoBillLocation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LOC_NFMIDep_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOC_Print">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RVI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RVI_InsCompanyBill.INSB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RVI_InsCompanyBill.INSB_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LOC_RowId</SqlRowIdName>
<StreamLocation>^User.RVIInsCoBillLocationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

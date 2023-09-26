/// ServiceAgreementHAR(2139)
Class User.PACServiceAgreementHAR Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ServiceAgreementHAR, StorageStrategy = SQLStorage ]
{

/// Childsub
Property HARChildsub As %Float [ InitialExpression = {$i(^PAC("SLA",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HAR",0))}, SqlColumnNumber = 2, SqlFieldName = HAR_Childsub ];

/// Des Ref HCR
Property HARHCRDR As CTHealthCareRegion [ SqlColumnNumber = 3, SqlFieldName = HAR_HCR_DR ];

/// PAC_ServiceAgreement Parent Reference
Relationship HARParRef As PACServiceAgreement [ Cardinality = parent, Inverse = ChildPACServiceAgreementHAR, Required, SqlFieldName = HAR_ParRef ];

Index RowIDBasedIDKeyIndex On HARChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 15;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementHAR).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACServiceAgreementHAR","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementHAR).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACServiceAgreementHAR","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACServiceAgreementHAR).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACServiceAgreementHAR","OnAfterUpdate")
}

Storage SQLStorage
{
<ExtentSize>15</ExtentSize>
<Property name="HARChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="HARHCRDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="HARParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="HAR_HCR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ServiceAgreement.SLA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>HAR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SLA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ServiceAgreement.SLA_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HAR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HAR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HAR_RowId</SqlRowIdName>
<StreamLocation>^User.PACServiceAgreementHARS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

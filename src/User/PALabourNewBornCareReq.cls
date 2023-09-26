/// Labour NewBorn Care Req(1324)
Class User.PALabourNewBornCareReq Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_LabourNewBornCareReq, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IMCChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_LabourNewBorn Parent Reference
Relationship IMCParRef As PALabourNewBorn [ Cardinality = parent, Inverse = ChildPALabourNewBornCareReq, Required, SqlFieldName = IMC_ParRef ];

/// Childsub
Property IMCChildsub As %Float [ InitialExpression = {$i(^PAADM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"ALB",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"LNB",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"IMC",0))}, SqlColumnNumber = 2, SqlFieldName = IMC_Childsub ];

/// Des Ref to ImmedCare
Property IMCImmedCareDR As PACImmedCareRequired [ SqlColumnNumber = 3, SqlFieldName = IMC_ImmedCare_DR ];

/// Date From
Property IMCDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = IMC_DateFrom ];

/// Date To
Property IMCDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = IMC_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PALabourNewBornCareReq).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PALabourNewBornCareReq","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PALabourNewBornCareReq).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PALabourNewBornCareReq","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PALabourNewBornCareReq).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PALabourNewBornCareReq","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PALabourNewBornCareReq).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PALabourNewBornCareReq","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PALabourNewBornCareReq).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PALabourNewBornCareReq","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="IMC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IMC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IMC_ImmedCare_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAADM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Adm.PAADM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_AdmLab.ALB_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PA_LabourNewBorn.LNB_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L7}</Expression>
<Field>IMC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Adm.PAADM_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_AdmLab.ALB_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LNB"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_LabourNewBorn.LNB_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"IMC"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{IMC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>IMC_RowId</SqlRowIdName>
<StreamLocation>^User.PALabourNewBornCareReqS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// ConsultCategWLType(2702)
Class User.OECConsultCategWLType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ConsultCategWLType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On WLTChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_ConsultCateg Parent Reference
Relationship WLTParRef As OECConsultCateg [ Cardinality = parent, Inverse = ChildOECConsultCategWLType, Required, SqlFieldName = WLT_ParRef ];

/// Childsub
Property WLTChildsub As %Float [ InitialExpression = {$i(^OEC("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"WLT",0))}, SqlColumnNumber = 2, SqlFieldName = WLT_Childsub ];

/// DateFrom
Property WLTDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = WLT_DateFrom ];

/// DateTo
Property WLTDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = WLT_DateTo ];

/// Des Ref CTLOC
Property WLTCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = WLT_CTLOC_DR ];

/// Des Ref Hospital
Property WLTHospitalDR As CTHospital [ SqlColumnNumber = 6, SqlFieldName = WLT_Hospital_DR ];

/// Des Ref WaitLisType
Property WLTWaitLisTypeDR As PACWaitingListType [ SqlColumnNumber = 7, SqlFieldName = WLT_WaitLisType_DR ];

/// Recall
Property WLTRecall As %Float [ SqlColumnNumber = 8, SqlFieldName = WLT_Recall ];

/// Recall Period
Property WLTRecallPeriod As %String(DISPLAYLIST = ",Days,Months,Weeks,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,M,W,Y") [ SqlColumnNumber = 9, SqlFieldName = WLT_RecallPeriod ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECConsultCategWLType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategWLType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECConsultCategWLType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategWLType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECConsultCategWLType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategWLType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECConsultCategWLType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategWLType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECConsultCategWLType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategWLType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="WLT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLT_Recall">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLT_RecallPeriod">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLT_WaitLisType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>WLT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"WLT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>WLT_RowId</SqlRowIdName>
<StreamLocation>^User.OECConsultCategWLTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

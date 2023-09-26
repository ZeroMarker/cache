/// ApptSchemaAppt(2775)
Class User.RBApptSchemaAppt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ApptSchemaAppt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildRBApptSchemaApptOrders As RBApptSchemaApptOrders [ Cardinality = children, Inverse = ORDParRef ];

/// RB_ApptSchema Parent Reference
Relationship APParRef As RBApptSchema [ Cardinality = parent, Inverse = ChildRBApptSchemaAppt, Required, SqlFieldName = AP_ParRef ];

/// Childsub
Property APChildsub As %Float [ InitialExpression = {$i(^RB("SCH",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"AP",0))}, SqlColumnNumber = 2, SqlFieldName = AP_Childsub ];

/// ApptNumber
Property APApptNumber As %Float [ SqlColumnNumber = 3, SqlFieldName = AP_ApptNumber ];

/// Des Ref Hospital
Property APHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = AP_Hospital_DR ];

/// Des Ref CTLOC
Property APCTLOCDR As CTLoc [ SqlColumnNumber = 5, SqlFieldName = AP_CTLOC_DR ];

/// Des Ref Resource
Property APResourceDR As RBResource [ SqlColumnNumber = 6, SqlFieldName = AP_Resource_DR ];

/// Des Ref Service
Property APServiceDR As RBCServices [ SqlColumnNumber = 7, SqlFieldName = AP_Service_DR ];

/// Des Ref SessionType
Property APSessionTypeDR As RBCSessionType [ SqlColumnNumber = 8, SqlFieldName = AP_SessionType_DR ];

/// Des Ref ConsultCateg
Property APConsultCategDR As OECConsultCateg [ SqlColumnNumber = 9, SqlFieldName = AP_ConsultCateg_DR ];

/// Des Ref WLType
Property APWLTypeDR As PACWaitingListType [ SqlColumnNumber = 10, SqlFieldName = AP_WLType_DR ];

/// Des Ref WLPriority
Property APWLPriorityDR As PACWaitingListPriority [ SqlColumnNumber = 11, SqlFieldName = AP_WLPriority_DR ];

/// Des Ref WLStatus
Property APWLStatusDR As PACWaitingListStatus [ SqlColumnNumber = 12, SqlFieldName = AP_WLStatus_DR ];

/// Des Ref CTLOC
Property APWLCTLOCDR As CTLoc [ SqlColumnNumber = 13, SqlFieldName = AP_WL_CTLOC_DR ];

/// Des Ref Hospital
Property APWLHospitalDR As CTHospital [ SqlColumnNumber = 14, SqlFieldName = AP_WL_Hospital_DR ];

/// Des Ref CareProv
Property APWLCareProvDR As CTCareProv [ SqlColumnNumber = 15, SqlFieldName = AP_WL_CareProv_DR ];

/// Frequency
Property APFrequency As %Float [ SqlColumnNumber = 16, SqlFieldName = AP_Frequency ];

/// FreqInterval
Property APFreqInterval As %String(DISPLAYLIST = ",Days,Weeks,Months,Years", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",D,W,M,Y") [ SqlColumnNumber = 17, SqlFieldName = AP_FreqInterval ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.RBApptSchemaAppt).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaAppt","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.RBApptSchemaAppt).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaAppt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.RBApptSchemaAppt).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaAppt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.RBApptSchemaAppt).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaAppt","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.RBApptSchemaAppt).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaAppt","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBApptSchemaAppt","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="APApptNumber">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="APCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APChildsub">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="APConsultCategDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APFreqInterval">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="APFrequency">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APResourceDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APServiceDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APSessionTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APWLCTLOCDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APWLCareProvDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APWLHospitalDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APWLPriorityDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APWLStatusDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="APWLTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="AP_ApptNumber">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AP_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AP_ConsultCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AP_FreqInterval">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AP_Frequency">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AP_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AP_Service_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AP_SessionType_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AP_WLPriority_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AP_WLStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AP_WLType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AP_WL_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AP_WL_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AP_WL_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_ApptSchema.SCH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchema.SCH_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>AP_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptSchemaApptS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

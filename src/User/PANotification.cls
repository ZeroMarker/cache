/// PA Notification(1344)
Class User.PANotification Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Notification, StorageStrategy = SQLStorage ]
{

/// Admission Type
Property NOTAdmType As %String(DISPLAYLIST = ",First Admission,Re-Admission", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",F,R") [ SqlColumnNumber = 11, SqlFieldName = NOT_AdmType ];

/// Des REf CTCP
Property NOTCTCPDR As CTCareProv [ SqlColumnNumber = 12, SqlFieldName = NOT_CTCP_DR ];

/// Des Ref CTLOC
Property NOTCTLOCDR As CTLoc [ SqlColumnNumber = 13, SqlFieldName = NOT_CTLOC_DR ];

/// Des Ref MRCIDx
Property NOTDiagnosisDR As MRCICDDx [ SqlColumnNumber = 3, SqlFieldName = NOT_Diagnosis_DR ];

/// Expected Adm Date
Property NOTExpAdmDate As %Date [ SqlColumnNumber = 5, SqlFieldName = NOT_ExpAdmDate ];

/// Expected Length Of Stay
Property NOTExpLOS As %Float [ SqlColumnNumber = 7, SqlFieldName = NOT_ExpLOS ];

/// Expected Operation Date
Property NOTExpOperDate As %Date [ SqlColumnNumber = 6, SqlFieldName = NOT_ExpOperDate ];

/// Des REf DiagType
Property NOTMRCDiagTypeDR As MRCDiagnosType [ SqlColumnNumber = 14, SqlFieldName = NOT_MRC_DiagType_DR ];

/// Des Ref to Operation
Property NOTOperationDR As ORCOperation [ SqlColumnNumber = 4, SqlFieldName = NOT_Operation_DR ];

/// Des Ref OrderSubCat
Property NOTOrderSubcatDR As ARCItemCat [ SqlColumnNumber = 8, SqlFieldName = NOT_OrderSubcat_DR ];

/// Des Ref to PAADM
Property NOTPAADMDR As PAAdm [ Required, SqlColumnNumber = 2, SqlFieldName = NOT_PAADM_DR ];

/// Des Ref RoomType
Property NOTRoomTypeDR As PACRoomType [ SqlColumnNumber = 9, SqlFieldName = NOT_RoomType_DR ];

/// Urgent
Property NOTUrgent As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = NOT_Urgent ];

Parameter EXTENTSIZE = 854;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PANotification).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PANotification","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PANotification).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PANotification","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PANotification).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PANotification","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PANotification).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PANotification","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PANotification).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PANotification","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>854</ExtentSize>
<Property name="NOTAdmType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="NOTCTCPDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTCTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTDiagnosisDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTExpAdmDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTExpLOS">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTExpOperDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTMRCDiagTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTOperationDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTOrderSubcatDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTPAADMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTRoomTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="NOTUrgent">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PANOT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="NOT_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="NOT_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="NOT_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="NOT_Diagnosis_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NOT_ExpAdmDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NOT_ExpLOS">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NOT_ExpOperDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="NOT_MRC_DiagType_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="NOT_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NOT_OrderSubcat_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="NOT_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NOT_RoomType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="NOT_Urgent">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PANOT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>NOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{NOT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^PANOT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>NOT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{NOT_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{NOT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NOT_RowId</SqlRowIdName>
<StreamLocation>^User.PANotificationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

Class User.DHCMedAdrRepAuditItm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDADRI_RowID, SqlTableName = DHC_MedAdrRepAuditItm, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On MEDADRIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship MEDADRIAdtParRef As User.DHCMedAdrRepAudit [ Cardinality = parent, Inverse = ChildDHCMedAdrRepAuditItm, Required, SqlFieldName = MEDADRI_Adt_ParRef ];

Property MEDADRIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MEDADRI_ChildSub ];

//转抄日期

Property MEDADRIAuditDate As %Date [ SqlColumnNumber = 3, SqlFieldName = MEDADRI_AuditDate ];

//转抄时间

Property MEDADRIAuditTime As %Time [ SqlColumnNumber = 4, SqlFieldName = MEDADRI_AuditTime ];

//转抄人

Property MEDADRIAuditUser As %String [ SqlColumnNumber = 5, SqlFieldName = MEDADRI_AuditUser ];

//指向处理部门

Property MEDADRINexLocDR As %String [ SqlColumnNumber = 6, SqlFieldName = MEDADRI_NexLoc_DR ];

//指向处理部门人员

Property MEDADRINextUserDR As %String [ SqlColumnNumber = 7, SqlFieldName = MEDADRI_NextUser_DR ];

//人员意见

Property MEDADRIUserAdvice As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = MEDADRI_UserAdvice ];

//接收状态

Property MEDADRIReceive As %String [ SqlColumnNumber = 9, SqlFieldName = MEDADRI_Receive ];

//接收日期

Property MEDADRIReceiveDate As %Date [ SqlColumnNumber = 10, SqlFieldName = MEDADRI_ReceiveDate ];

//接收时间

Property MEDADRIReceiveTime As %Time [ SqlColumnNumber = 11, SqlFieldName = MEDADRI_ReceiveTime ];

//完成日期

Property MEDADRICompleteDate As %Date [ SqlColumnNumber = 12, SqlFieldName = MEDADRI_CompleteDate ];

//完成时间

Property MEDADRICompleteTime As %Time [ SqlColumnNumber = 13, SqlFieldName = MEDADRI_CompleteTime ];

//科室意见

Property MEDADRILocAdvice As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = MEDADRI_LocAdvice ];

//是否转抄回复

Property MEDADRIDutyFlag As %String [ SqlColumnNumber = 15, SqlFieldName = MEDADRI_DutyFlag ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="MEDADRI_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDADRI_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEDADRI_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDADRI_CompleteDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEDADRI_CompleteTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEDADRI_DutyFlag">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEDADRI_LocAdvice">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEDADRI_NexLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEDADRI_NextUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEDADRI_Receive">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEDADRI_ReceiveDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEDADRI_ReceiveTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEDADRI_UserAdvice">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCMEDREPADT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_MedAdrRepAudit.MEDADR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MEDADRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_MedAdrRepAudit.MEDADR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MEDADRI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDADRI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="NextUserIndex">
<Global>^DHCMEDREPADT</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_MedAdrRepAudit.MEDADR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MEDADRI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NextUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_MedAdrRepAudit.MEDADR_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDADRI_NextUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MEDADRI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedAdrRepAuditItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// 治疗记录预约到达表(预约记录表子表)
Class User.DHCDocCureAppArrive Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCAA_RowId, SqlTableName = DHC_DocCureAppArrive, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCAAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DCAAParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureAppArrive, Required, SqlFieldName = DCAA_ParRef ];

/// DCAA_ChildSub
Property DCAAChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure($p(%d(0),$c(1)),"Arrive",0))}, SqlColumnNumber = 2, SqlFieldName = DCAA_ChildSub ];

/// DCAA_RBAS_DR  预约资源关联
Property DCAARBASDR As User.DHCDocCureRBCResSchdule [ SqlColumnNumber = 3, SqlFieldName = DCAA_RBAS_DR ];

/// DCAA_OEORE_DR  医嘱执行表关联
Property DCAAOEOREDR As User.OEOrdExec [ SqlColumnNumber = 4, SqlFieldName = DCAA_OEORE_DR ];

/// DCAA_ReqUser_DR  预约人
Property DCAAReqUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DCAA_ReqUser_DR ];

/// DCAA_ReqDate  预约操作日期
Property DCAAReqDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DCAA_ReqDate ];

/// DCAA_ReqTime  预约操作时间
Property DCAAReqTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DCAA_ReqTime ];

/// DCAA_Status  预约方式
Property DCAAReqType As %Library.String(DISPLAYLIST = ",Auto,Manual", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",A,M") [ SqlColumnNumber = 8, SqlFieldName = DCAA_ReqType ];

/// DCAA_Status  预约状态  预约 I   到达A  C  取消预约
Property DCAAStatus As %Library.String(DISPLAYLIST = ",Inserted,Admitted,Cancelled", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",I,A,C") [ SqlColumnNumber = 9, SqlFieldName = DCAA_Status ];

/// DCAA_LastUpdateUser_DR  更新人
Property DCAALastUpdateUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DCAA_LastUpdateUser_DR ];

/// DCAA_LastUpdateDate  更新日期
Property DCAALastUpdateDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = DCAA_LastUpdateDate ];

/// DCAA_LastUpdateTime  更新时间
Property DCAALastUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DCAA_LastUpdateTime ];

/// DCAA_Remark   备注
Property DCAARemark As %Library.String [ SqlColumnNumber = 13, SqlFieldName = DCAA_Remark ];

/// DCAACallStatus
Property DCAACallStatus As %Library.String [ SqlColumnNumber = 14, SqlFieldName = DCAA_CallStatus ];

/// DCAA_Text2->DCAA_SeqNo 预约排队号
Property DCAASeqNo As %Library.String [ SqlColumnNumber = 15, SqlFieldName = DCAA_SeqNo ];

/// DCAA_AppQty 
Property DCAAAppQty As %Library.String [ SqlColumnNumber = 16, SqlFieldName = DCAA_AppQty ];

/// DCAA_CallStatusDr
Property DCAAPerStatusDr As User.DHCDocCurePerState [ SqlColumnNumber = 17, SqlFieldName = DCAA_PerStatusDr ];

/// DCAA_AppTypeDr 预约渠道
Property DCAAAppTypeDr As User.RBCApptType [ SqlColumnNumber = 18, SqlFieldName = DCAA_AppTypeDr ];

/// DCAA_CallUser_DR 呼叫锁定用户
Property DCAACallUserDR As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = DCAA_CallUser_DR ];

/// DCAA_ReportSeqFlag  报到时产生序号
Property DCAAReportSeqFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = DCAA_ReportSeqFlag ];

/// 关联的队列记录
Property DCAAQueDR As User.DHCDocCureQueue [ SqlColumnNumber = 21, SqlFieldName = DCAA_Que_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(DHCDoc.DHCDocCure.Appointment).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(DHCDoc.DHCDocCure.Appointment).OnTrigger($g(%d(1)),"TAfterUpd")
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    i insert {
	    s sc=##Class(DHCDoc.DHCDocCure.Appointment).OnTrigger(%this.%Id(),"TAfterIns")
    }else{
	    s sc=##Class(DHCDoc.DHCDocCure.Appointment).OnTrigger(%this.%Id(),"TAfterUpd")
    }
    
    Q sc
}

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCAA_AppQty">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DCAA_AppTypeDr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DCAA_CallStatus">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCAA_CallUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DCAA_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCAA_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCAA_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCAA_OEORE_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCAA_PerStatusDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DCAA_Que_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DCAA_RBAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCAA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCAA_ReportSeqFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DCAA_ReqDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCAA_ReqTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCAA_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCAA_ReqUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCAA_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DCAA_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCAA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arrive"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppDate">
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCAA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAA_ReqDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORE">
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCAA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAA_OEORE_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRBAS">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCAA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RBAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCAA_RBAS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCAA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCAA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCureAppArriveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

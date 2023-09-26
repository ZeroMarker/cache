/// 治疗记录申请表
Class User.DHCDocCureApp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCA_RowId, SqlTableName = DHC_DocCureApp, StorageStrategy = SQLStorge ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCDocCureAppArrive As User.DHCDocCureAppArrive [ Cardinality = children, Inverse = DCAAParRef ];

Relationship ChildDHCDocCureTriage As User.DHCDocCureTriage [ Cardinality = children, Inverse = DDCTParRef ];

Relationship ChildDHCDocCureRecode As User.DHCDocCureRecode [ Cardinality = children, Inverse = DCRParRef ];

Relationship ChildDHCDocCureExecChange As User.DHCDocCureAppExecChange [ Cardinality = children, Inverse = DCAECParRef ];

Relationship ChildDHCDocCureAppCureItem As User.DHCDocCureAppCureItem [ Cardinality = children, Inverse = DCACParRef ];

Relationship ChildDHCDocCureAppOrder As User.DHCDocCureAppOrder [ Cardinality = children, Inverse = DCAOParRef ];

Relationship ChildDHCDocCureAssessment As User.DHCDocCureAssessment [ Cardinality = children, Inverse = DCAssParRef ];

/// DCA_Adm_DR  就诊指针
Property DCAAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = DCA_Adm_DR ];

/// DCA_OEORD_DR  申请单关联医嘱
Property DCAOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DCA_OEORI_DR ];

/// DCA_Status 申请单状态   Apply 申请,Cancel 取消，F已完成，D已分配
Property DCAStatus As %Library.String(DISPLAYLIST = ",Apply,Cancel,Finish,Distribute", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",A,C,F,D") [ SqlColumnNumber = 4, SqlFieldName = DCA_Status ];

/// DCA_AppUser_DR 申请人
Property DCAAppUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DCA_AppUser_DR ];

/// DCA_AppDate 申请日期
Property DCAAppDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = DCA_AppDate ];

/// DCA_AppTime  申请时间
Property DCAAppTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DCA_AppTime ];

/// DCA_UpdateUser_DR 更新人
Property DCAUpdateUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DCA_UpdateUser_DR ];

/// DCA_AppDate 更新日期
Property DCAUpdateDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = DCA_UpdateDate ];

/// DCA_AppTime  更新时间
Property DCAUpdateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DCA_UpdateTime ];

/// DCA_Remark  申请单备注 
Property DCARemark As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = DCA_Remark ];

/// DCA_AppPlan  治疗方案
Property DCAAppPlan As %Library.String(MAXLEN = 15000) [ SqlColumnNumber = 12, SqlFieldName = DCA_AppPlan ];

/// DCA_UpdateUser_DR 执行完成人
Property DCAFinishUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = DCA_FinishUser_DR ];

/// DCA_AppDate 执行完成日期，目前废止，无用
Property DCAFinishDate As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = DCA_FinishDate ];

/// DCA_AppTime  执行完成时间，目前废止，无用
Property DCAFinishTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DCA_FinishTime ];

Property DCAExecNum As %Library.String [ SqlColumnNumber = 16, SqlFieldName = DCA_ExecNum ];

/// 深圳中医用 呼叫状态
Property DCACallStatus As %Library.String [ SqlColumnNumber = 17, SqlFieldName = DCA_CallStatus ];

/// DCA_Papmi_DR  就诊指针
Property DCAPapmiDR As User.PAPatMas [ SqlColumnNumber = 18, SqlFieldName = DCA_Papmi_DR ];

/// AppNo申请单号
Property DCAAppNo As %Library.String [ SqlColumnNumber = 19, SqlFieldName = DCA_AppNo ];

/// 该申请单是否直接执行，防止中途修改治疗医嘱项是否直接执行配置影响数据
Property DCAApplyExec As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = DCA_ApplyExec ];

/// 该申请单是否预约允许直接执行，防止中途修改配置是否预约允许直接执行配置影响数据
Property DCAApplyAppointExec As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = DCA_ApplyAppointExec ];

/// 申请单保存的部位图片
Property DCABodyFrontImage As %Stream.GlobalCharacter [ SqlColumnNumber = 22, SqlFieldName = DCA_BodyFrontImage ];

/// 申请单保存的部位图片（背面）
Property DCABodyBackImage As %Stream.GlobalCharacter [ SqlColumnNumber = 23, SqlFieldName = DCA_BodyBackImage ];

/// 申请单保存的部位备注信息
Property DCABodySetStr As %Library.String(MAXLEN = 9999) [ SqlColumnNumber = 24, SqlFieldName = DCA_BodySetStr ];

/// 呼叫锁定用户
Property DCACallUserDR As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = DCA_CallUser_DR ];

/// 治疗科室 用于检索
Property DCACureRecLocDR As User.CTLoc [ SqlColumnNumber = 26, SqlFieldName = DCA_CureRecLoc_DR ];

/// 操作来源 OEOrdEntry 医嘱录入[治疗申请]按钮弹出 OEOrdEntryUpdate 医嘱录入审核弹出 Menu 治疗申请菜单
Property DCACureDoSourceType As %Library.String [ SqlColumnNumber = 27, SqlFieldName = DCA_DoSourceType ];

Storage SQLStorge
{
<ExtentSize>250</ExtentSize>
<IdExpression>$i(^DHCDocCure(0))</IdExpression>
<SqlIdExpression>$i(^DHCDocCure(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DCA_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCA_AppDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCA_AppNo">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DCA_AppPlan">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCA_AppTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCA_AppUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCA_ApplyAppointExec">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DCA_ApplyExec">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DCA_BodyBackImage">
<Node>"BBI"</Node>
</Data>
<Data name="DCA_BodyFrontImage">
<Node>"BFI"</Node>
</Data>
<Data name="DCA_BodySetStr">
<Node>"BSS"</Node>
</Data>
<Data name="DCA_CallStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DCA_CallUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DCA_CureRecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DCA_DoSourceType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DCA_ExecNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DCA_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DCA_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DCA_FinishUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCA_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCA_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DCA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCA_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DCA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCA_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmDr">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAppNo">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_AppNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApplyDate">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApplyDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_AppDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApplyExec">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ApplyExec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_ApplyExec}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_AppDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCallStatus">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CallStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_CallStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLongOEORI">
<Condition>##class(DHCDoc.DHCDocCure.Common).GetOrderPrior({DCA_OEORI_DR})=1</Condition>
<ConditionFields>DCA_OEORI_DR</ConditionFields>
<Global>^DHCDocCure</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LONGOEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDr">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_Papmi_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecDate">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_CureRecLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_AppDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DCA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STAT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCA_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DCA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCA_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCureAppS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

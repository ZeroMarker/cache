/// 治疗记录表(预约记录表子表)
Class User.DHCDocCureRecode Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCR_RowId, SqlTableName = DHC_DocCureRecode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DCRChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocCureApp Parent Reference
Relationship DCRParRef As User.DHCDocCureApp [ Cardinality = parent, Inverse = ChildDHCDocCureRecode, Required, SqlFieldName = DCR_ParRef ];

Relationship ChildDHCDocCureRecodeChange As User.DHCDocCureRecodeChange [ Cardinality = children, Inverse = DCRCParRef ];

Relationship ChildDHCDocCureRecodePicture As User.DHCDocCureRecodePicture [ Cardinality = children, Inverse = DCRPParRef ];

/// DCR_ChildSub
Property DCRChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocCure($p(%d(0),$c(1)),"Recode",0))}, SqlColumnNumber = 2, SqlFieldName = DCR_ChildSub ];

/// DCR_CureAppArrive_DR  治疗预约表关联
Property DCRCureAppArriveDR As User.DHCDocCureAppArrive [ SqlColumnNumber = 3, SqlFieldName = DCR_CureAppArrive_DR ];

/// DCR_OEORE_DR  医嘱执行表关联
Property DCROEOREDR As User.OEOrdExec [ SqlColumnNumber = 4, SqlFieldName = DCR_OEORE_DR ];

/// DCR_Title  记录标题
Property DCRTitle As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = DCR_Title ];

/// DCR_Content 记录描述
Property DCRContent As %Library.String(MAXLEN = 3000) [ SqlColumnNumber = 6, SqlFieldName = DCR_Content ];

/// DCR_CreateUser_DR 创建人
Property DCRCreateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DCR_CreateUser_DR ];

/// DCR_CreateDate 创建日期
Property DCRCreateDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = DCR_CreateDate ];

/// DCR_CreateTime 创建时间
Property DCRCreateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = DCR_CreateTime ];

/// DCR_LastUpdateUser_DR  更新人
Property DCRLastUpdateUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = DCR_LastUpdateUser_DR ];

/// DCR_LastUpdateDate   更新日期
Property DCRLastUpdateDate As %Library.Date [ SqlColumnNumber = 11, SqlFieldName = DCR_LastUpdateDate ];

/// DCR_LastUpdateTime   更新时间
Property DCRLastUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = DCR_LastUpdateTime ];

/// DCR_Active   是否有效
Property DCRActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DCR_Active ];

/// DCR_IsPicture   是否存在图像
Property DCRIsPicture As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DCR_IsPicture ];

/// DCR_CureDate 治疗日期
Property DCRCureDate As %Library.Date [ SqlColumnNumber = 15, SqlFieldName = DCR_CureDate ];

/// DCR_CureTime 治疗时间
Property DCRCureTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = DCR_CureTime ];

/// DCR_Response  治疗反应
Property DCRResponse As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 17, SqlFieldName = DCR_Response ];

/// DCR_Effect  治疗效果
Property DCREffect As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 18, SqlFieldName = DCR_Effect ];

/// DCR_Text1  备用字段
Property DCRDoseage As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 19, SqlFieldName = DCR_Doseage ];

/// DCR_CureDate 治疗结束日期
Property DCRCureEndDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = DCR_CureEndDate ];

/// DCR_CureTime 治疗结束时间
Property DCRCureEndTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DCR_CureEndTime ];

/// DCR_MapID 保存时所用的模板ID
Property DCRMapID As %Library.String [ SqlColumnNumber = 22, SqlFieldName = DCR_MapID ];

/// DCR_JsonStr 治疗记录Json串
Property DCRJsonStr As %Library.String(MAXLEN = 99999) [ SqlColumnNumber = 23, SqlFieldName = DCR_JsonStr ];

/// DCR_CurePOAID 保存关联的部位 穴位ID，可能有多个，$c(1)链接
Property DCRCurePOAID As %Library.String [ SqlColumnNumber = 24, SqlFieldName = DCR_CurePOAID ];

/// DCR_Reconfirm_DR  复核人工号
Property DCRReconfirmUserCode As %Library.String [ SqlColumnNumber = 25, SqlFieldName = DCR_ReconfirmUserCode ];

/// DCR_CureExecDate 治疗执行日期与执行记录执行时间相同
Property DCRCureExecDate As %Library.Date [ SqlColumnNumber = 26, SqlFieldName = DCR_CureExecDate ];

/// DCR_CureExecTime 治疗执行时间与执行记录执行时间相同
Property DCRCureExecTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = DCR_CureExecTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DCR_Active">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DCR_Content">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DCR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DCR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DCR_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DCR_CureAppArrive_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DCR_CureDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DCR_CureEndDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DCR_CureEndTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DCR_CureExecDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DCR_CureExecTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DCR_CurePOAID">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DCR_CureTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DCR_Doseage">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DCR_Effect">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DCR_IsPicture">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DCR_JsonStr">
<Node>"Json"</Node>
</Data>
<Data name="DCR_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DCR_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DCR_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DCR_MapID">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DCR_OEORE_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DCR_ReconfirmUserCode">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DCR_Response">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DCR_Title">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDocCure</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DCR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Recode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAppArriveDR">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AppArriveDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCR_CureAppArrive_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RecordDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExecDate">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExecDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCR_CureExecDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEOREDR">
<Global>^DHCDocCure</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocCureApp.DCA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DCR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEOREDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DCR_OEORE_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocCureApp.DCA_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DCR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DCR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocCureRecodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

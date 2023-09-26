/// CT Referral Clinic       (CTRFC,76)
/// 医疗机构  sunfengchao 新扩展字段 :类别编码  级别 行政区划
Class User.CTRefClin Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_RefClin, StorageStrategy = SQLStorage ]
{

Relationship ChildCTRefClnContractDetails As CTRefClnContractDetails [ Cardinality = children, Inverse = CONTRParRef ];

/// 医疗机构代码
Property CTRFCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTRFC_Code ];

/// 医疗机构名称
Property CTRFCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTRFC_Desc ];

/// 是否有效(Y/N)
Property CTRFCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CTRFC_ActiveFlag ];

/// VEMD
Property CTRFCVEMD As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CTRFC_VEMD ];

/// 开始日期
Property CTRFCDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = CTRFC_DateFrom ];

/// 结束日期
Property CTRFCDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = CTRFC_DateTo ];

/// 类别编码
Property CTRFCCategoryCode As %String [ SqlColumnNumber = 8, SqlFieldName = CTRFC_CategoryCode ];

/// 级别  
Property CTRFCLevel As %String [ SqlColumnNumber = 9, SqlFieldName = CTRFC_Level ];

/// 行政区划(市)
Property CTRFCCityDR As CTCity [ SqlColumnNumber = 10, SqlFieldName = CTRFC_City_DR ];

/// 行政区划(县)
Property CTRFCCityAreaDR As CTCityArea [ SqlColumnNumber = 11, SqlFieldName = CTRFC_CityArea_DR ];

/// 组织机构代码-外键 add@20220923
Property CTRFCORGCode As CT.BDP.CT.HOSOrganization [ SqlColumnNumber = 12, SqlFieldName = CTRFC_ORGCode ];

/// 医疗机构执业许可证号
Property CTRFCBusinessClicenseCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CTRFC_BusinessClicenseCode ];

/// 医疗机构执业许可证效期开始日期
Property CTRFCBusinessClicenseFrom As %Date [ SqlColumnNumber = 14, SqlFieldName = CTRFC_BusinessClicenseFrom ];

/// 医疗机构执业许可证效期结束日期
Property CTRFCBusinessClicenseTo As %Date [ SqlColumnNumber = 15, SqlFieldName = CTRFC_BusinessClicenseTo ];

/// 编制床位数
Property CTRFCBeds As %Float [ SqlColumnNumber = 16, SqlFieldName = CTRFC_Beds ];

/// 医院等级代码-外键
Property CTRFCGradeCode As CT.BDP.CT.HOSHORGGrade [ SqlColumnNumber = 17, SqlFieldName = CTRFC_GradeCode ];

/// 医院物价标准
Property CTRFCChargeStandard As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CTRFC_ChargeStandard ];

/// 医院医保代码
Property CTRFCInsuCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CTRFC_InsuCode ];

/// 系统创建日期
Property CTRFCCreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 20, SqlFieldName = CTRFC_CreateDate ];

/// 系统创建时间
Property CTRFCCreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 21, SqlFieldName = CTRFC_CreateTime ];

/// 系统创建人
Property CTRFCCreateUser As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = CTRFC_CreateUser ];

/// 系统排序号
Property CTRFCSeqNo As %Float [ SqlColumnNumber = 23, SqlFieldName = CTRFC_SeqNo ];

/// 系统最后更新日期
Property CTRFCLastUpdateDate As %Date [ SqlColumnNumber = 24, SqlFieldName = CTRFC_LastUpdateDate ];

/// 系统最后更新时间
Property CTRFCLastUpdateTime As %Time [ SqlColumnNumber = 25, SqlFieldName = CTRFC_LastUpdateTime ];

/// 系统最新更新人
Property CTRFCLastUpdateUser As User.SSUser [ SqlColumnNumber = 26, SqlFieldName = CTRFC_LastUpdateUser ];

/// 拼音码
Property CTRFCPYCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = CTRFC_PYCode ];

/// 五笔码
Property CTRFCWBCode As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = CTRFC_WBCode ];

/// 备注
Property CTRFCMark As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = CTRFC_Mark ];

Index CTRFCCodeUnqIdx1 On CTRFCCode [ Unique ];

Index CTRFCDescUnqIdx2 On CTRFCDesc [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTRefClin).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRefClin","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTRefClin).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRefClin","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTRefClin).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRefClin","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTRefClin).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRefClin","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTRefClin).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRefClin","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("RFC",0))</SqlIdExpression>
<SQLMap name="DataMasterCTRFC">
<Data name="CTRFC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTRFC_Beds">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CTRFC_BusinessClicenseCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTRFC_BusinessClicenseFrom">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CTRFC_BusinessClicenseTo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CTRFC_CategoryCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTRFC_ChargeStandard">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CTRFC_CityArea_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTRFC_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTRFC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTRFC_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CTRFC_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CTRFC_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CTRFC_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTRFC_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTRFC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTRFC_GradeCode">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CTRFC_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CTRFC_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CTRFC_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CTRFC_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CTRFC_Level">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTRFC_Mark">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CTRFC_ORGCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTRFC_PYCode">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CTRFC_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CTRFC_VEMD">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTRFC_WBCode">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTRFC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCategoryCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CategoryCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CTRFC_CategoryCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTRFC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCityDR">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTRFC_City_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTRFC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({CTRFC_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CTRFC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCtiyAreaDR">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_ROwId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CityAreaDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTRFC_CityArea_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTRFC_ROwId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTRFC_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTRFC_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrg">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Organization"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTRFC_ORGCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTRFC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrgGrade">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTRFC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RFC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrgGrade"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CTRFC_GradeCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CTRFC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTRFC_RowId</SqlRowIdName>
<StreamLocation>^User.CTRefClinS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

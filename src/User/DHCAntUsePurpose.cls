/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 抗菌药物使用目的业务表
/// NOTE: 启用新的基础数据配置表 DHCAnt_Base.PurposeDataConfig
/// 			DAUPDTAUPDR：User.DHCCTAntUsePurpose
/// 	  	DAUPOPerInd: User.DHCAntIndications
/// 		  	DAUPBodyPart: User.MRCBodyParts
/// 		  	DAUPOperaYFTimeDR: User.DHCAntOperaTime
/// 		  	统一改成：%Library.String类型
///        DAUPSubmission As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N")
/// 			去除限制条件：1为送检，0为不送检或者空
Class User.DHCAntUsePurpose Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAUP_Rowid, SqlTableName = DHC_AntUsePurpose, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAUP_DTAUP_DR 使用目的
Property DAUPDTAUPDR As %Library.String [ SqlColumnNumber = 21, SqlFieldName = DAUP_DTAUP_DR ];

/// DAUP_No 序号
Property DAUPNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DAUP_No ];

/// DAUP_OEORI_DR 指向医嘱
Property DAUPOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DAUP_OEORI_DR ];

/// DAUP_Reason 原因分析
Property DAUPReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DAUP_Reason ];

/// DAUP_OPerInd 指向手术指征
Property DAUPOPerInd As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DAUP_OPerInd ];

/// DAUP_TreaInd 指向治疗指征
Property DAUPTreaInd As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DAUP_TreaInd ];

/// DAUP_Submission 是否送检
Property DAUPSubmission As %Library.String [ SqlColumnNumber = 7, SqlFieldName = DAUP_Submission ];

/// DAUP_BodyPart 身体部位
Property DAUPBodyPart As %Library.String [ SqlColumnNumber = 8, SqlFieldName = DAUP_BodyPart ];

/// DAUP_Operation_DR 手术记录
Property DAUPOperationDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DAUP_Operation_DR ];

/// DAUP_Suscept_DR 药敏结果
Property DAUPSusceptDR As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DAUP_Suscept_DR ];

/// DAUP_OtherReason 其它理由
Property DAUPOtherReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DAUP_OtherReason ];

/// DAUP_Conscommt 专家会诊意见
Property DAUPConscommt As %Library.String [ SqlColumnNumber = 12, SqlFieldName = DAUP_Conscommt ];

/// DAUP_Date 创建日期
Property DAUPDate As %Date [ SqlColumnNumber = 13, SqlFieldName = DAUP_Date ];

/// DAUP_Time 创建时间
Property DAUPTime As %Time [ SqlColumnNumber = 14, SqlFieldName = DAUP_Time ];

/// DAUP_User 创建人
Property DAUPUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = DAUP_User ];

/// DAUP_Adm_dr 病人就诊记录id
Property DAUPAdmdr As User.PAAdm [ SqlColumnNumber = 16, SqlFieldName = DAUP_Adm_dr ];

/// DAUP_LastUpdateUser 最后修改人
Property DAUPLastUpdateUser As SSUser [ SqlColumnNumber = 17, SqlFieldName = DAUP_LastUpdateUser ];

/// DAUP_LastUpdateDate 最后修改日期
Property DAUPLastUpdateDate As %Date [ SqlColumnNumber = 18, SqlFieldName = DAUP_LastUpdateDate ];

/// DAUP_LastUpdateTime 最后修改时间
Property DAUPLastUpdateTime As %Time [ SqlColumnNumber = 19, SqlFieldName = DAUP_LastUpdateTime ];

/// DAUP_Pat_DR 病人id
Property DAUPPatDR As User.PAPerson [ SqlColumnNumber = 20, SqlFieldName = DAUP_Pat_DR ];

/// DAUP_ItmMast_DR
Property DAUPItmMastDR As User.ARCItmMast [ SqlColumnNumber = 22, SqlFieldName = DAUP_ItmMast_DR ];

/// DAUP_OperaYFTime_DR  2013-2-1
Property DAUPOperaYFTimeDR As %Library.String [ SqlColumnNumber = 23, SqlFieldName = DAUP_OperaYFTime_DR ];

/// DAUP_KSS3Indication  特抗药指征
Property DAUPKSS3Indication As %Library.String [ SqlColumnNumber = 24, SqlFieldName = DAUP_KSS3Indication ];

/// DAUP_PreUseDrugTime  预计用药天数
Property DAUPPreUseDrugTime As %Library.String [ SqlColumnNumber = 25, SqlFieldName = DAUP_PreUseDrugTime ];

/// DAUP_ExtendUseReason  延长用药原因
Property DAUPExtendUseReason As %Library.String [ SqlColumnNumber = 26, SqlFieldName = DAUP_ExtendUseReason ];

/// DAUP_Copy  复制标志
Property DAUPCopy As %Library.String [ SqlColumnNumber = 27, SqlFieldName = DAUP_Copy ];

/// DAUP_ZBJ  致病菌
Property DAUPZBJ As %Library.String [ SqlColumnNumber = 28, SqlFieldName = DAUP_ZBJ ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DAUP("DAUP"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DAUP_Adm_dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAUP_BodyPart">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DAUP_Conscommt">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DAUP_Copy">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DAUP_DTAUP_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DAUP_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAUP_ExtendUseReason">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DAUP_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DAUP_KSS3Indication">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DAUP_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DAUP_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DAUP_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DAUP_No">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DAUP_OEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAUP_OPerInd">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DAUP_OperaYFTime_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DAUP_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DAUP_OtherReason">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DAUP_Pat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAUP_PreUseDrugTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DAUP_Reason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DAUP_Submission">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DAUP_Suscept_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DAUP_Time">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DAUP_TreaInd">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DAUP_User">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DAUP_ZBJ">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^DAUP</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DAUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAUP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DateIndex">
<Global>^DAUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAUP_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNewAdm">
<Global>^DAUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"NEWADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAUP_Adm_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAUP_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="OEORIIndex">
<Global>^DAUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAUP_OEORI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="PatIndex">
<Global>^DAUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAUP_Pat_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAUP_Adm_dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DAUP_OEORI_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DAUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="admIndex">
<Global>^DAUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAUP_Adm_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAUP_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DAUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAntUsePurposeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

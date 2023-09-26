/// CTOR: QP
/// DATE: 2019-05-13
/// DESC: 抗菌药物碳青霉烯类及替加环素项目本地化的扩展表-北京版
Class User.DHCAntCQMXModeBJ Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlTableName = DHCAnt_CQMXModeBJ, StorageStrategy = SQLStorage ]
{

/// CQMX_Admid
Property Admid As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = CQMX_Admid ];

/// CQMX_Locid
Property Locid As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CQMX_Locid ];

/// CQMX_ArcimDr
Property ArcimDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = CQMX_ArcimDr ];

/// CQMX_AntFillUser 抗菌界面填写人
Property AntFillUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = CQMX_AntFillUser ];

/// CQMX_AntFillDate	抗菌药物界面填写日期
Property AntFillDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CQMX_AntFillDate ];

/// CQMX_AntFillTime 抗菌药物界面填写时间
Property AntFillTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CQMX_AntFillTime ];

/// CQMX_StopFillUser 停医嘱填写人
Property StopFillUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = CQMX_StopFillUser ];

/// CQMX_StopFillDate 停医嘱时填写日期
Property StopFillDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CQMX_StopFillDate ];

/// CQMX_StopFillTime 停医嘱时候填写时间
Property StopFillTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CQMX_StopFillTime ];

/// CQMX_UnifyFillUser 统一填写人
Property UnifyFillUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CQMX_UnifyFillUser ];

/// CQMX_UnifyFillDate 统一填写日期
Property UnifyFillDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CQMX_UnifyFillDate ];

/// CQMX_UnifyFillTime 统一填写时间
Property UnifyFillTime As %Time [ SqlColumnNumber = 13, SqlFieldName = CQMX_UnifyFillTime ];

/// CQMX_LastUser 最后更新人
Property LastUser As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = CQMX_LastUser ];

/// CQMX_LastDate 最后更新日期
Property LastDate As %Date [ SqlColumnNumber = 15, SqlFieldName = CQMX_LastDate ];

/// CQMX_LastTime 最后更新时间
Property LastTime As %Time [ SqlColumnNumber = 16, SqlFieldName = CQMX_LastTime ];

/// CQMX_AimDr 使用目的
Property AimDr As User.DHCAntUsePurpose [ SqlColumnNumber = 17, SqlFieldName = CQMX_AimDr ];

/// CQMX_ApplyDr 申请表
Property ApplyDr As User.DHCDocAntibioticApply [ SqlColumnNumber = 18, SqlFieldName = CQMX_ApplyDr ];

/// CQMX_FirstDiagnosisDr 入院第一诊断
Property FirstDiagnosisDr As User.MRCICDDx [ SqlColumnNumber = 19, SqlFieldName = CQMX_FirstDiagnosisDr ];

/// CQMX_ApacheII APACHEII评分
Property ApacheII As %Library.String [ SqlColumnNumber = 20, SqlFieldName = CQMX_ApacheII ];

/// CQMX_InfectionSite 感染部位
Property InfectionSite As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 21, SqlFieldName = CQMX_InfectionSite ];

/// CQMX_SenseHospital 是否院感
Property SenseHospital As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = CQMX_SenseHospital ];

/// CQMX_InfectionDiagnosisDr 感染诊断
Property InfectionDiagnosisDr As User.MRCICDDx [ SqlColumnNumber = 23, SqlFieldName = CQMX_InfectionDiagnosisDr ];

/// CQMX_Indication 适应症
Property Indication As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 24, SqlFieldName = CQMX_Indication ];

/// CQMX_PrescAuth 处方权限
Property PrescAuth As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 25, SqlFieldName = CQMX_PrescAuth ];

/// CQMX_MedicationDate 用药日期
Property MedicationDate As %Date [ SqlColumnNumber = 26, SqlFieldName = CQMX_MedicationDate ];

/// CQMX_StopMedicationDate 停药日期
Property StopMedicationDate As %Date [ SqlColumnNumber = 27, SqlFieldName = CQMX_StopMedicationDate ];

/// CQMX_MedicationNum 用药次数
Property MedicationNum As %Library.String [ SqlColumnNumber = 28, SqlFieldName = CQMX_MedicationNum ];

/// CQMX_MedicationEffect 用药效果
Property MedicationEffect As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 29, SqlFieldName = CQMX_MedicationEffect ];

/// CQMX_AdjustPlan 调整方案
Property AdjustPlan As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 30, SqlFieldName = CQMX_AdjustPlan ];

/// CQMX_Instruction 用法（次/日）
Property Instruction As %Library.String [ SqlColumnNumber = 31, SqlFieldName = CQMX_Instruction ];

/// CQMX_Dose 剂量（0~10g）
Property Dose As %Library.String [ SqlColumnNumber = 32, SqlFieldName = CQMX_Dose ];

/// CQMX_EtiologyEvidence 病原学证据(有/无)
Property EtiologyEvidence As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 33, SqlFieldName = CQMX_EtiologyEvidence ];

/// CQMX_LabDate 送检日期
Property LabDate As %Date [ SqlColumnNumber = 34, SqlFieldName = CQMX_LabDate ];

/// CQMX_ReportDate 报告日期
Property ReportDate As %Date [ SqlColumnNumber = 35, SqlFieldName = CQMX_ReportDate ];

/// CQMX_SpecimenType 标本类型
Property SpecimenType As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 36, SqlFieldName = CQMX_SpecimenType ];

/// CQMX_LabResult 送检结果(1阴性/2阳性)
Property LabResult As %Library.String [ SqlColumnNumber = 37, SqlFieldName = CQMX_LabResult ];

/// CQMX_BacteriaName 细菌名称
Property BacteriaName As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 38, SqlFieldName = CQMX_BacteriaName ];

/// CQMX_CQMXResist 是否耐碳氢霉烯
Property CQMXResist As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = CQMX_CQMXResist ];

/// CQMX_CQMXResistName CQMX药敏名称
Property CQMXResistName As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 40, SqlFieldName = CQMX_CQMXResistName ];

/// CQMX_CQMXMic CQMX MIC值
Property CQMXMic As %Library.String [ SqlColumnNumber = 41, SqlFieldName = CQMX_CQMXMic ];

/// CQMX_TGCResist 是否耐替加环素
Property TGCResist As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 42, SqlFieldName = CQMX_TGCResist ];

/// CQMX_TGCResistName TGC药敏名称
Property TGCResistName As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 43, SqlFieldName = CQMX_TGCResistName ];

/// CQMX_TGCMic TGC MIC值
Property TGCMic As %Library.String [ SqlColumnNumber = 44, SqlFieldName = CQMX_TGCMic ];

/// CQMX_LabRelateInfectDiag 送检标本是否与感染诊断相关
Property LabRelateInfectDiag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 45, SqlFieldName = CQMX_LabRelateInfectDiag ];

/// CQMX_SideEffect 使用碳青霉烯/替加环素类抗菌药物后的不良反应
Property SideEffect As %Library.String [ SqlColumnNumber = 46, SqlFieldName = CQMX_SideEffect ];

/// CQMX_TLJSpecimen 碳氢霉烯耐药铜绿假单胞菌-送检标本
Property TLJSpecimen As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 47, SqlFieldName = CQMX_TLJSpecimen ];

/// CQMX_TLJLabDate 碳氢霉烯耐药铜绿假单胞菌-送检时间
Property TLJLabDate As %Date [ SqlColumnNumber = 48, SqlFieldName = CQMX_TLJLabDate ];

/// CQMX_TLJReportDate 碳氢霉烯耐药铜绿假单胞菌-报告时间
Property TLJReportDate As %Date [ SqlColumnNumber = 49, SqlFieldName = CQMX_TLJReportDate ];

/// CQMX_BDGJSpecimen 碳氢霉烯耐药不动杆菌-送检标本
Property BDGJSpecimen As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 50, SqlFieldName = CQMX_BDGJSpecimen ];

/// CQMX_BDGJLabDate 碳氢霉烯耐药不动杆菌-送检时间
Property BDGJLabDate As %Date [ SqlColumnNumber = 51, SqlFieldName = CQMX_BDGJLabDate ];

/// CQMX_BDGJReportDate 碳氢霉烯耐药不动杆菌-报告时间
Property BDGJReportDate As %Date [ SqlColumnNumber = 52, SqlFieldName = CQMX_BDGJReportDate ];

/// CQMX_CGJSpecimen 碳氢霉烯耐药肠杆菌-送检标本
Property CGJSpecimen As DHCAnt.Base.PurposeDataConfig [ SqlColumnNumber = 53, SqlFieldName = CQMX_CGJSpecimen ];

/// CQMX_CGJLabDate 碳氢霉烯耐药肠杆菌-送检时间
Property CGJLabDate As %Date [ SqlColumnNumber = 54, SqlFieldName = CQMX_CGJLabDate ];

/// CQMX_CGJReportDate 碳氢霉烯耐药肠杆菌-报告时间
Property CGJReportDate As %Date [ SqlColumnNumber = 55, SqlFieldName = CQMX_CGJReportDate ];

Storage SQLStorage
{
<SqlIdExpression>$i(^BS.ANT.DHCAntCQMXModeBJD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CQMX_AdjustPlan">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="CQMX_Admid">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CQMX_AimDr">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CQMX_AntFillDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CQMX_AntFillTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CQMX_AntFillUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CQMX_ApacheII">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>2</Piece>
</Data>
<Data name="CQMX_ApplyDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CQMX_ArcimDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CQMX_BDGJLabDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="CQMX_BDGJReportDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="CQMX_BDGJSpecimen">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="CQMX_BacteriaName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="CQMX_CGJLabDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Data name="CQMX_CGJReportDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="CQMX_CGJSpecimen">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="CQMX_CQMXMic">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="CQMX_CQMXResist">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="CQMX_CQMXResistName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="CQMX_Dose">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="CQMX_EtiologyEvidence">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="CQMX_FirstDiagnosisDr">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>1</Piece>
</Data>
<Data name="CQMX_Indication">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>6</Piece>
</Data>
<Data name="CQMX_InfectionDiagnosisDr">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>5</Piece>
</Data>
<Data name="CQMX_InfectionSite">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>3</Piece>
</Data>
<Data name="CQMX_Instruction">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="CQMX_LabDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="CQMX_LabRelateInfectDiag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="CQMX_LabResult">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="CQMX_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CQMX_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CQMX_LastUser">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CQMX_Locid">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CQMX_MedicationDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="CQMX_MedicationEffect">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="CQMX_MedicationNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="CQMX_PrescAuth">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>7</Piece>
</Data>
<Data name="CQMX_ReportDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="CQMX_SenseHospital">
<Delimiter>"^"</Delimiter>
<Node>"KSS"</Node>
<Piece>4</Piece>
</Data>
<Data name="CQMX_SideEffect">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="CQMX_SpecimenType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="CQMX_StopFillDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CQMX_StopFillTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CQMX_StopFillUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CQMX_StopMedicationDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="CQMX_TGCMic">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="CQMX_TGCResist">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="CQMX_TGCResistName">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="CQMX_TLJLabDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="CQMX_TLJReportDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="CQMX_TLJSpecimen">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="CQMX_UnifyFillDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CQMX_UnifyFillTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CQMX_UnifyFillUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^BS.ANT.DHCAntCQMXModeBJD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmid">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Admid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_Admid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAimDr">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AimDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_AimDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAntFillDate">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AntFillDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_AntFillDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexApplyDr">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ApplyDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_ApplyDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArcimDr">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ArcimDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_ArcimDr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocid">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Locid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_Locid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStopFillDate">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"StopFillDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_StopFillDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUnifyFillDate">
<Global>^BS.ANT.DHCAntCQMXModeBJI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>CQMX_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"UnifyFillDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CQMX_UnifyFillDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CQMX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CQMX_RowId</SqlRowIdName>
<StreamLocation>^User.DHCAntCQMXModeBJS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

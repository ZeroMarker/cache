Class User.DHCMedSafetyReport Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDSR_RowID, SqlTableName = DHC_MedSafetyReport, StorageStrategy = NewStorage1 ]
{

/// MEDSR_RepLoc_Dr	填报科室
Property MEDSRRepLocDr As %String [ SqlColumnNumber = 2, SqlFieldName = MEDSR_RepLoc_Dr ];

/// MEDSR_CreateDate	报告日期
Property MEDSRCreateDate As %Date [ SqlColumnNumber = 3, SqlFieldName = MEDSR_CreateDate ];

/// MEDSR_CreateTime	报告时间
Property MEDSRCreateTime As %Time [ SqlColumnNumber = 4, SqlFieldName = MEDSR_CreateTime ];

/// MEDSR_OccDate	发生日期
Property MEDSROccDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MEDSR_OccDate ];

/// MEDSR_OccTime	发生时间
Property MEDSROccTime As %Time [ SqlColumnNumber = 6, SqlFieldName = MEDSR_OccTime ];

/// MEDSR_OccBatNo	班次
Property MEDSROccBatNo As %String [ SqlColumnNumber = 7, SqlFieldName = MEDSR_OccBatNo ];

/// MEDSR_PatNo	病案号
Property MEDSRPatNo As %String [ SqlColumnNumber = 8, SqlFieldName = MEDSR_PatNo ];

/// MEDSR_PatID	病人ID/登记号
Property MEDSRPatID As %String [ SqlColumnNumber = 9, SqlFieldName = MEDSR_PatID ];

/// MEDSR_PatName	病人姓名
Property MEDSRPatName As %String [ SqlColumnNumber = 10, SqlFieldName = MEDSR_PatName ];

/// MEDSR_PatSex	病人性别
Property MEDSRPatSex As User.CTSex [ SqlColumnNumber = 11, SqlFieldName = MEDSR_PatSex ];

/// MEDSR_PatAge	病人年龄
Property MEDSRPatAge As %String [ SqlColumnNumber = 12, SqlFieldName = MEDSR_PatAge ];

/// MEDSR_DrugName	应给药物
Property MEDSRDrugName As %String [ SqlColumnNumber = 13, SqlFieldName = MEDSR_DrugName ];

/// MEDSR_Dosage	应给剂量
Property MEDSRDosage As %String [ SqlColumnNumber = 14, SqlFieldName = MEDSR_Dosage ];

/// MEDSR_NurAction	及时行动
Property MEDSRNurAction As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = MEDSR_NurAction ];

/// MEDSR_Creator	创建人工号
Property MEDSRCreator As %String [ SqlColumnNumber = 16, SqlFieldName = MEDSR_Creator ];

/// MEDSR_CreatorCareProv	创建职称
Property MEDSRCreatorCareProv As %String [ SqlColumnNumber = 17, SqlFieldName = MEDSR_CreatorCareProv ];

/// MEDSR_ErrNum	错误次数
Property MEDSRErrNum As %String [ SqlColumnNumber = 18, SqlFieldName = MEDSR_ErrNum ];

/// MATADR_CurStatus_DR	当前状态
Property MEDSRCurStatusDR As User.DHCAdrEvtWorkFlowItm [ SqlColumnNumber = 19, SqlFieldName = MEDSR_CurStatus_DR ];

/// MEDSR_ReportNo	报告单号
Property MEDSRReportNo As %String [ SqlColumnNumber = 20, SqlFieldName = MEDSR_ReportNo ];

/// MEDSR_ReportType	报告类型
Property MEDSRReportType As %String [ SqlColumnNumber = 21, SqlFieldName = MEDSR_ReportType ];

/// MEDSR_AdmNo	就诊ID
Property MEDSRAdmNo As %String [ SqlColumnNumber = 22, SqlFieldName = MEDSR_AdmNo ];

/// MEDSR_OrdItm	医嘱ID
Property MEDSROrdItm As %String [ SqlColumnNumber = 23, SqlFieldName = MEDSR_OrdItm ];

/// MEDSR_RepImpFlag 重点标记  Y N
Property MEDSRRepImpFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = MEDSR_RepImpFlag ];

/// MEDSR_AuditDate	审核日期
Property MEDSRAuditDate As %Date [ SqlColumnNumber = 25, SqlFieldName = MEDSR_AuditDate ];

/// MEDSR_Telephone  报告人联系电话
Property MEDSRTelephone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MEDSR_Telephone ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVMEDSAR)</SqlIdExpression>
<SQLMap name="IndexAuditDate">
<Global>^DHCADVMEDSAR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCreateDate">
<Global>^DHCADVMEDSAR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_CreateDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepNo">
<Global>^DHCADVMEDSAR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RepNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MEDSR_ReportNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="MEDSR_AdmNo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MEDSR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MEDSR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEDSR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEDSR_Creator">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MEDSR_CreatorCareProv">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MEDSR_CurStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MEDSR_Dosage">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEDSR_DrugName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEDSR_ErrNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MEDSR_NurAction">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEDSR_OccBatNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEDSR_OccDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEDSR_OccTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEDSR_OrdItm">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MEDSR_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEDSR_PatID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEDSR_PatName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEDSR_PatNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEDSR_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEDSR_RepImpFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MEDSR_RepLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEDSR_ReportNo">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MEDSR_ReportType">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MEDSR_Telephone">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Global>^DHCADVMEDSAR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEDSR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MEDSR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCMedSafetyReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

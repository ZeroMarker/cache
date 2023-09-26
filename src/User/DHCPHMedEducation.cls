Class User.DHCPHMedEducation Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHME_RowID, SqlTableName = DHC_PHMedEducation, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHMEDRGITM As User.DHCPHMEDrgItm [ Cardinality = children, Inverse = PHMEDIPHMEParref ];

Relationship ChildDHCPHMEGUICONTENT As User.DHCPHMEGuiContent [ Cardinality = children, Inverse = PHMEGCPHMEParref ];

/// 20180809
Relationship ChildDHCPHMReview As User.DHCPHMedReview [ Cardinality = children, Inverse = PHMRPHMEParref ];

Relationship ChildDHCPHMLifeTips As User.DHCPHMedLifeTips [ Cardinality = children, Inverse = PHMLTPHMEParref ];

/// 20180809
/// PHME_Adm_Dr 病人就诊指针
Property PHMEAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHME_Adm_Dr ];

/// PHME_CurStatus 当前状态
Property PHMECurStatus As %Library.String(DISPLAYLIST = ",New,In,Out", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,I,O") [ SqlColumnNumber = 3, SqlFieldName = PHME_CurStatus ];

/// PHME_User_Dr 记录人
Property PHMEUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PHME_User_Dr ];

/// PHME_Date 记录日期
Property PHMEDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = PHME_Date ];

/// PHME_Time 记录时间
Property PHMETime As %Time [ SqlColumnNumber = 6, SqlFieldName = PHME_Time ];

/// PHME_BadHabits 不良嗜好
Property PHMEBadHabits As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHME_BadHabits ];

/// PHME_ConDisAndTre 伴发疾病与用药情况
Property PHMEConDisAndTre As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHME_ConDisAndTre ];

/// PHME_GrantFlag 发放临床药师联系卡
Property PHMEGrantFlag As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PHME_GrantFlag ];

/// PHME_GuidObject 指导对象
Property PHMEGuidObject As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 10, SqlFieldName = PHME_GuidObject ];

/// PHME_GuidContent 指导意见/内容
Property PHMEGuidContent As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PHME_GuidContent ];

/// PHME_Icd 诊断
Property PHMEIcd As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PHME_Icd ];

/// PHME_MobPhone 电话
Property PHMEMobPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PHME_MobPhone ];

/// PHME_Address 家庭住址
Property PHMEAddress As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PHME_Address ];

/// PHME_PharSignPath 药师签名路径
Property PHMEPharSignPath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PHME_PharSignPath ];

/// PHME_PatSignPath 患者签名路径
Property PHMEPatSignPath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PHME_PatSignPath ];

// PHME_DrugTreatment

Property PHMEDrugTreatment As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHME_DrugTreatment ];

// PHME_Clinical

Property PHMEClinical As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHME_Clinical ];

// PHME_Pharmaceutical

Property PHMEPharmaceutical As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PHME_Pharmaceutical ];

// PHME_Drugefficacy 药物疗效与监测

Property PHMEDrugefficacy As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PHME_Drugefficacy ];

// PHME_Drugsafe  药物安全性检测

Property PHMEDrugsafe As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PHME_Drugsafe ];

// PHME_Druginteract  药物相互作用

Property PHMEDruginteract As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PHME_Druginteract ];

// PHME_Foodtaboo  食物宜忌事项

Property PHMEFoodtaboo As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PHME_Foodtaboo ];

Property PHMEEducation As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PHME_Education ];

/// PHME_OtherObjectRemark 指导对象（其他）
Property PHMEOtherObject As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PHME_OtherObject ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHME)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHME_Address">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHME_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHME_BadHabits">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHME_Clinical">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHME_ConDisAndTre">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHME_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHME_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHME_DrugTreatment">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHME_Drugefficacy">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHME_Druginteract">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHME_Drugsafe">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHME_Education">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHME_Foodtaboo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHME_GrantFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHME_GuidContent">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHME_GuidObject">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHME_Icd">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHME_MobPhone">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHME_OtherObject">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHME_PatSignPath">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHME_PharSignPath">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHME_Pharmaceutical">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHME_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHME_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHME_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHME_Adm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHME_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCurStatusAdmDr">
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CurStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHME_CurStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHME_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHME_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHME</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHME_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHME_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHME_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAdm">
<Global>^DHCPHME</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>{PHME_RowID}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHME_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHME_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHME_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHMedEducationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHME)
	s oldI = +$g(^mdata("DHCPHMEDEDUCATION"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHME = maxI
	s ^mdata("DHCPHMEDEDUCATION") = maxI
}

}

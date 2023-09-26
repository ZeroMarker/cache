Class User.DHCPHCliPathography Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHCP_RowID, SqlTableName = DHC_PHCliPathography, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCPHCLIPATPRECOM As User.DHCPHCliPatPreCom [ Cardinality = children, Inverse = PHCPCPHCPParref ];

Relationship ChildDHCPHCLIPATDRGITM As User.DHCPHCliPatDrgItm [ Cardinality = children, Inverse = PHCPDIPHCPParref ];

/// PHCP_Adm_Dr 病人就诊指针
Property PHCPAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHCP_Adm_Dr ];

/// PHCP_Temper 体温
Property PHCPTemper As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PHCP_Temper ];

/// PHCP_Pulse 脉搏
Property PHCPPulse As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHCP_Pulse ];

/// PHCP_Breathe 呼吸
Property PHCPBreathe As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PHCP_Breathe ];

/// PHCP_HeartRate 心率
Property PHCPHeartRate As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHCP_HeartRate ];

/// PHCP_BloodPre 血压
Property PHCPBloodPre As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHCP_BloodPre ];

/// PHCP_UPD 尿量
Property PHCPUPD As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PHCP_UPD ];

/// PHCP_DouLunBrePho 双肺呼吸音
Property PHCPDouLunBrePho As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 9, SqlFieldName = PHCP_DouLunBrePho ];

/// PHCP_Rale 啰音
Property PHCPRale As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 10, SqlFieldName = PHCP_Rale ];

/// PHCP_Arrhythmia 心律
Property PHCPArrhythmia As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 11, SqlFieldName = PHCP_Arrhythmia ];

/// PHCP_PathMurmur 各瓣膜听诊区、病理性杂音
Property PHCPPathMurmur As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 12, SqlFieldName = PHCP_PathMurmur ];

/// PHCP_Belly 腹部
Property PHCPBelly As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 13, SqlFieldName = PHCP_Belly ];

/// PHCP_LivLieCos 肝脾肋下
Property PHCPLivLieCos As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 14, SqlFieldName = PHCP_LivLieCos ];

/// PHCP_PerPain 双肾区叩击痛
Property PHCPPerPain As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 15, SqlFieldName = PHCP_PerPain ];

/// PHCP_Oedema 双下肢水肿
Property PHCPOedema As %Library.Float(SELECTIVITY = "50.0000%") [ SqlColumnNumber = 16, SqlFieldName = PHCP_Oedema ];

/// PHCP_ChaOfDisDesc 每日病情变化描述
Property PHCPChaOfDisDesc As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PHCP_ChaOfDisDesc ];

/// PHCP_Guidance 指导意见
Property PHCPGuidance As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PHCP_Guidance ];

/// PHCP_User_Dr 记录人
Property PHCPUserDr As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = PHCP_User_Dr ];

/// PHCP_Date 记录日期
Property PHCPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = PHCP_Date ];

/// PHCP_Time 记录时间
Property PHCPTime As %Time [ SqlColumnNumber = 21, SqlFieldName = PHCP_Time ];

/// PHCP_Icd 诊断
Property PHCPIcd As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PHCP_Icd ];

/// PHCP_PharSignPath 药师签名路径
Property PHCPPharSignPath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PHCP_PharSignPath ];

/// PHCP_PatSignPath 患者签名路径
Property PHCPPatSignPath As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PHCP_PatSignPath ];

Property PHCPCurStatus As %Library.String(DISPLAYLIST = ",New,In", MAXLEN = 7, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,I") [ SqlColumnNumber = 25, SqlFieldName = PHCP_CurStatus ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPHCP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHCP_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCP_Arrhythmia">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHCP_Belly">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHCP_BloodPre">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCP_Breathe">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCP_ChaOfDisDesc">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHCP_CurStatus">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHCP_Date">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHCP_DouLunBrePho">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCP_Guidance">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHCP_HeartRate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCP_Icd">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHCP_LivLieCos">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHCP_Oedema">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHCP_PatSignPath">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHCP_PathMurmur">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHCP_PerPain">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHCP_PharSignPath">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHCP_Pulse">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCP_Rale">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHCP_Temper">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCP_Time">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHCP_UPD">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHCP_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCPHCP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHCP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHCP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCPHCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Adm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCP_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCurStatusAdmDr">
<Global>^DHCPHCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CurStatus"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCP_CurStatus}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCP_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPHCP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHCP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAdm">
<Global>^DHCPHCP</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHCP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateAdm"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHCP_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHCP_Adm_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHCP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCliPathographyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
	s newI = +$g(^DHCPHCP)
	s oldI = +$g(^mdata("DHCPHCliPATHOGRAPHY"))
	s maxI = $s(newI > oldI : newI, 1 : oldI)
	s ^DHCPHCP = maxI
	s ^mdata("DHCPHCliPATHOGRAPHY") = maxI
}

}

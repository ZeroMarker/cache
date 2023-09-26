Class User.DHCRegConDisCount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RCD_Rowid, SqlTableName = DHC_RegConDisCount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// 代码
Property RCDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RCD_Code ];

/// 描述
Property RCDDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RCD_Desc ];

/// 优先级
Property RCDPriority As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RCD_Priority ];

/// 开始日期
Property RCDStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = RCD_StartDate ];

/// 开始时间
Property RCDStartTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = RCD_StartTime ];

/// 结束日期
Property RCDEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = RCD_EndDate ];

/// 结束时间
Property RCDEndTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = RCD_EndTime ];

/// 其他描述,基本描述以外的需要说明的情况
Property RCDOtherDesc As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RCD_OtherDesc ];

/// 年龄
Property RCDAge As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RCD_Age ];

/// 1代表<,2代表=,3代表>
/// 年龄比较关系
Property RCDAgeCompare As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RCD_AgeCompare ];

/// 性别
Property RCDSexDr As CTSex [ SqlColumnNumber = 12, SqlFieldName = RCD_Sex_Dr ];

/// 科室
Property RCDDeptDr As CTLoc [ SqlColumnNumber = 13, SqlFieldName = RCD_Dept_Dr ];

/// 号别
Property RCDMarkDr As CTCareProv [ SqlColumnNumber = 14, SqlFieldName = RCD_Mark_Dr ];

/// 病人费别
Property RCDFeeCateDr As PACAdmReason [ SqlColumnNumber = 15, SqlFieldName = RCD_FeeCate_Dr ];

/// 病人类型(代码表:社会地位)
Property RCDPatTypeDr As CTSocialStatus [ SqlColumnNumber = 16, SqlFieldName = RCD_PatType_Dr ];

/// 是否需要老年证
Property RCDOldCard As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = RCD_OldCard ];

/// 挂号职称
Property RCDSessionDr As RBCSessionType [ SqlColumnNumber = 18, SqlFieldName = RCD_SessionDr ];

/// 医院
Property RCDHospitalDr As CTHospital [ SqlColumnNumber = 19, SqlFieldName = RCD_Hospital_Dr ];

/// 备用字段,根据实际修改名称后使用
Property RCDText3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = RCD_Text3 ];

/// 备用字段,根据实际修改名称后使用
Property RCDText4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = RCD_Text4 ];

/// 备用字段,根据实际修改名称后使用
Property RCDText5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = RCD_Text5 ];

/// 备用字段,根据实际修改名称后使用
Property RCDText6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = RCD_Text6 ];

/// 备用字段,根据实际修改名称后使用
Property RCDText7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = RCD_Text7 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRCD)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RCD_Age">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RCD_AgeCompare">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RCD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RCD_Dept_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RCD_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RCD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RCD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RCD_FeeCate_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RCD_Hospital_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="RCD_Mark_Dr">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RCD_OldCard">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RCD_OtherDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RCD_PatType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RCD_Priority">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RCD_SessionDr">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="RCD_Sex_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RCD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RCD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RCD_Text3">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="RCD_Text4">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="RCD_Text5">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="RCD_Text6">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="RCD_Text7">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCRCD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RCD_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RCD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHospDr">
<Global>^DHCRCDi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RCD_Hospital_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RCD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRegConDisCountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

/// DHC_ICU_BaseInfoOne
Class User.DHCICUBaseInfoOne Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCICUBaseInfo_RowId, SqlTableName = DHC_ICU_BaseInfoOne, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DHCICUBaseInfo_RuYuanDate	入院日期
Property DHCICUBaseInfoRuYuanDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCICUBaseInfo_RuYuanDate ];

/// DHCICUBaseInfo_RuYuanTime	入院时间
Property DHCICUBaseInfoRuYuanTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = DHCICUBaseInfo_RuYuanTime ];

/// DHCICUBaseInfo_RuKeDate		入科日期
Property DHCICUBaseInfoRuKeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCICUBaseInfo_RuKeDate ];

/// DHCICUBaseInfo_RuKeTime		入科时间
Property DHCICUBaseInfoRuKeTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = DHCICUBaseInfo_RuKeTime ];

/// DHCICUBaseInfo_ChuKeDate	出科日期
Property DHCICUBaseInfoChuKeDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCICUBaseInfo_ChuKeDate ];

/// DHCICUBaseInfo_ChuKeTime	出科时间
Property DHCICUBaseInfoChuKeTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DHCICUBaseInfo_ChuKeTime ];

/// DHCICUBaseInfo_InLoc		转入科室
Property DHCICUBaseInfoInLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DHCICUBaseInfo_InLoc ];

/// DHCICUBaseInfo_OutLoc		转出科室
Property DHCICUBaseInfoOutLoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DHCICUBaseInfo_OutLoc ];

/// DHCICUBaseInfo_Operation	手术名称
Property DHCICUBaseInfoOperation As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DHCICUBaseInfo_Operation ];

/// DHCICUBaseInfo_OperDate		手术日期
Property DHCICUBaseInfoOperDate As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DHCICUBaseInfo_OperDate ];

/// DHCICUBaseInfo_OperTime		手术时间
Property DHCICUBaseInfoOperTime As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DHCICUBaseInfo_OperTime ];

/// DHCICUBaseInfo_Height		身高
Property DHCICUBaseInfoHeight As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHCICUBaseInfo_Height ];

/// DHCICUBaseInfo_weight		体重
Property DHCICUBaseInfoweight As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCICUBaseInfo_weight ];

/// DHCICUBaseInfo_Position		部位
Property DHCICUBaseInfoPosition As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DHCICUBaseInfo_Position ];

/// DHCICUBaseInfo_TouWei		头围
Property DHCICUBaseInfoTouWei As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DHCICUBaseInfo_TouWei ];

/// DHCICUBaseInfo_PiShi		皮试
Property DHCICUBaseInfoPiShi As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DHCICUBaseInfo_PiShi ];

/// DHCICUBaseInfo_PiShiResult	皮试结果
Property DHCICUBaseInfoPiShiResult As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DHCICUBaseInfo_PiShiResult ];

/// DHCICUBaseInfo_PiHao	批号
Property DHCICUBaseInfoPiHao As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = DHCICUBaseInfo_PiHao ];

/// DHCICUBaseInfo_GuoMin	过敏
Property DHCICUBaseInfoGuoMin As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DHCICUBaseInfo_GuoMin ];

/// DHCICUBaseInfo_ZhenDuan	诊断信息
Property DHCICUBaseInfoZhenDuan As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DHCICUBaseInfo_ZhenDuan ];

/// DHCICUBaseInfo_DiBiao	地标
Property DHCICUBaseInfoDiBiao As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = DHCICUBaseInfo_DiBiao ];

/// DHCICUBaseInfo_NuanXiangLittle	暖箱（小床）
Property DHCICUBaseInfoNuanXiangLittle As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = DHCICUBaseInfo_NuanXiangLittle ];

/// DHCICUBaseInfo_HuXiJiNo			呼吸机编号
Property DHCICUBaseInfoHuXiJiNo As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = DHCICUBaseInfo_HuXiJiNo ];

/// DHCICUBaseInfo_ICUAId			重症监护记录号
Property DHCICUBaseInfoICUAId As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = DHCICUBaseInfo_ICUAId ];

/// DHCICUBaseInfo_JLDStartDate		记录单开始日期
Property DHCICUBaseInfoJLDStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = DHCICUBaseInfo_JLDStartDate ];

/// DHCICUBaseInfo_JLDStartTime		记录单开始时间
Property DHCICUBaseInfoJLDStartTime As %Library.Time [ SqlColumnNumber = 27, SqlFieldName = DHCICUBaseInfo_JLDStartTime ];

/// DHCICUBaseInfo_ModifyDate		变更日期
Property DHCICUBaseInfoModifyDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 28, SqlFieldName = DHCICUBaseInfo_ModifyDate ];

/// DHCICUBaseInfo_ModifyTime		变更时间
Property DHCICUBaseInfoModifyTime As %Library.Time [ SqlColumnNumber = 29, SqlFieldName = DHCICUBaseInfo_ModifyTime ];

/// DHCICUBaseInfo_UserDr
Property DHCICUBaseInfoUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = DHCICUBaseInfo_UserDr ];

/// DHCICUBaseInfo_Hidden
Property DHCICUBaseInfoHidden As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = DHCICUBaseInfo_Hidden ];

/// DHCICUBaseInfo_UpdateUserDr
Property DHCICUBaseInfoUpdateUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = DHCICUBaseInfo_UpdateUserDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCICUBaseInfoOne(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCICUBaseInfo_ChuKeDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCICUBaseInfo_ChuKeTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCICUBaseInfo_DiBiao">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCICUBaseInfo_GuoMin">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCICUBaseInfo_Height">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCICUBaseInfo_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHCICUBaseInfo_HuXiJiNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCICUBaseInfo_ICUAId">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCICUBaseInfo_InLoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCICUBaseInfo_JLDStartDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCICUBaseInfo_JLDStartTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCICUBaseInfo_ModifyDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHCICUBaseInfo_ModifyTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHCICUBaseInfo_NuanXiangLittle">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCICUBaseInfo_OperDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCICUBaseInfo_OperTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCICUBaseInfo_Operation">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCICUBaseInfo_OutLoc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCICUBaseInfo_PiHao">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCICUBaseInfo_PiShi">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCICUBaseInfo_PiShiResult">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCICUBaseInfo_Position">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCICUBaseInfo_RuKeDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCICUBaseInfo_RuKeTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCICUBaseInfo_RuYuanDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCICUBaseInfo_RuYuanTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCICUBaseInfo_TouWei">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCICUBaseInfo_UpdateUserDr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHCICUBaseInfo_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHCICUBaseInfo_ZhenDuan">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCICUBaseInfo_weight">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCICUBaseInfoOne</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCICUBaseInfo_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHCICUBaseInfo_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexICUAIdDateTime">
<Global>^DHCICUBaseInfoOne</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DHCICUBaseInfo_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ICUAId"</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Time"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCICUBaseInfo_ICUAId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCICUBaseInfo_ModifyDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCICUBaseInfo_ModifyTime}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DHCICUBaseInfo_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCICUBaseInfoOneS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}

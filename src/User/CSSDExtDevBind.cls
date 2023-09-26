/// 外来器械信息患者绑定
Class User.CSSDExtDevBind Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDExt_Rowid, SqlTableName = CSSD_ExtDevBind ]
{

/// 编码号
Property CSSDExtCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = CSSDExt_Code ];

/// 使用科室
Property CSSDExtLoc As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = CSSDExt_Loc ];

/// 外来器械名称
Property CSSDExtInstruName As User.CSSDPackage [ SqlColumnNumber = 13, SqlFieldName = CSSDExt_InstruName ];

/// 接收日期
Property CSSDExtReciveDate As %Library.Date [ SqlColumnNumber = 14, SqlFieldName = CSSDExt_ReciveDate ];

/// 接收数量
Property CSSDExtRecNum As %Numeric [ SqlColumnNumber = 15, SqlFieldName = CSSDExt_RecNum ];

/// 接收时间
Property CSSDExtReciveTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = CSSDExt_ReciveTime ];

/// 接收人
Property CSSDExtRecMan As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = CSSDExt_RecMan ];

/// 送包人
Property CSSDExtSerMan As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDExt_SerMan ];

/// 收费单号
Property CSSDExtReceipt As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = CSSDExt_Receipt ];

/// 移交日期
Property CSSDExtTransfersDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = CSSDExt_TransfersDate ];

/// 手术医生
Property CSSDExtDocName As %String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = CSSDExt_UseDoctor ];

/// 移交时间
Property CSSDExtTransfersTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = CSSDExt_TransfersTime ];

/// 患者姓名 
Property CSSDExtSickerName As %String(COLLATION = "Exact") [ SqlColumnNumber = 23, SqlFieldName = CSSDExt_SickerName ];

/// 住院号
Property CSSDExtHospitalNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 24, SqlFieldName = CSSDExt_HospitalNo ];

/// 厂商
Property CSSDExtFirm As User.CSSDVen [ SqlColumnNumber = 25, SqlFieldName = CSSDExt_Firm ];

/// 送包人电话
Property CSSDExtTel As %String(COLLATION = "Exact") [ SqlColumnNumber = 26, SqlFieldName = CSSDExt_Tel ];

/// 器械件数
Property CSSDExtInstruNum As %Numeric [ SqlColumnNumber = 27, SqlFieldName = CSSDExt_InstruNum ];

/// 植入物
Property CSSDExtImplants As %Numeric [ SqlColumnNumber = 28, SqlFieldName = CSSDExt_Implants ];

/// 动力器械
Property CSSDExtPowerInstru As %String(COLLATION = "Exact") [ SqlColumnNumber = 29, SqlFieldName = CSSDExt_PowerInstru ];

/// 备注
Property CSSDExtRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 30, SqlFieldName = CSSDExt_Remark ];

/// 接收日期
Property CSSDExtRecDate As %Library.TimeStamp [ SqlColumnNumber = 32, SqlFieldName = CSSDExt_RecDate ];

/// 使用时间
Property CSSDExtUseDate As %String(COLLATION = "Exact") [ SqlColumnNumber = 33, SqlFieldName = CSSDExt_UseDate ];

/// 医院
Property CSSDExtHospital As CTHospital [ SqlColumnNumber = 34, SqlFieldName = CSSDExt_Hospital ];

/// 器械功能检查
Property CSSDExtFunctionalCheck As %String(COLLATION = "Exact") [ SqlColumnNumber = 35, SqlFieldName = CSSDExt_FunctionalCheck ];

/// 性别
Property CSSDExtPatientSex As %String(COLLATION = "Exact") [ SqlColumnNumber = 36, SqlFieldName = CSSDExt_PatientSex ];

/// 年龄
Property CSSDExtPatientAge As %String(COLLATION = "Exact") [ SqlColumnNumber = 37, SqlFieldName = CSSDExt_PatientAge ];

/// 床号
Property CSSDExtBedNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 38, SqlFieldName = CSSDExt_BedNo ];

/// 灭菌参数
Property CSSDExtSterParameter As %String(COLLATION = "Exact") [ SqlColumnNumber = 39, SqlFieldName = CSSDExt_SterParameter ];

/// 高温选项
Property CSSDExtSterTemp As %String(COLLATION = "Exact") [ SqlColumnNumber = 40, SqlFieldName = CSSDExt_SterTemp ];

/// 是否反洗
Property CSSDExtBackwash As %String(COLLATION = "Exact") [ SqlColumnNumber = 41, SqlFieldName = CSSDExt_Backwash ];

/// 手术类型
Property CSSDExtOperatorType As %String(COLLATION = "Exact") [ SqlColumnNumber = 42, SqlFieldName = CSSDExt_OperatorType ];

/// 绑定的唯一标签码
Property CSSDExtLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 43, SqlFieldName = CSSDExt_Label ];

/// 移交人
Property CSSDExtTransfer As User.SSUser [ SqlColumnNumber = 44, SqlFieldName = CSSDExt_Transfer ];

/// 移交接收人
Property CSSDExtTransferRec As %String(COLLATION = "Exact") [ SqlColumnNumber = 45, SqlFieldName = CSSDExt_TransferRec ];

/// 移交日期
Property CSSDExtTransferDate As %Library.TimeStamp [ SqlColumnNumber = 46, SqlFieldName = CSSDExt_TransferDate ];

/// 移交状态
Property CSSDExtIsTransfer As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 47, SqlFieldName = CSSDExt_IsTransfer ];

/// 手术排班表ID
Property CSSDExtOpPlanDr As %String(COLLATION = "Exact") [ SqlColumnNumber = 48, SqlFieldName = CSSDExt_OpPlanDr ];

/// 'C':回收、'W'清洗'D'：发放、'P'：打包、'R'：接收、'S'、灭菌、'U'：过期 、'TC':过期处理、'SW':二次清洗、'SS':二次灭菌、'B':绑定
Property CSSDExtStatus As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 49, SqlFieldName = CSSDExt_Status ];

Index IndexCSSDExtLabel On CSSDExtLabel As Exact;

Index IndexCSSDExtCodeRecDate On (CSSDExtCode As Exact, CSSDExtRecDate As Exact);

Index IndexCSSDExtCodeIsTransfer On (CSSDExtCode As Exact, CSSDExtIsTransfer As Exact);

Index IndexCSSDExtCode On CSSDExtCode As Exact;

Storage Default
{
<Data name="CSSDExtDevBindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3"/>
<Value name="4"/>
<Value name="5"/>
<Value name="6"/>
<Value name="7"/>
<Value name="8"/>
<Value name="9"/>
<Value name="10"/>
<Value name="11">
<Value>CSSDExtCode</Value>
</Value>
<Value name="12">
<Value>CSSDExtLoc</Value>
</Value>
<Value name="13">
<Value>CSSDExtInstruName</Value>
</Value>
<Value name="14">
<Value>CSSDExtReciveDate</Value>
</Value>
<Value name="15">
<Value>CSSDExtRecNum</Value>
</Value>
<Value name="16">
<Value>CSSDExtReciveTime</Value>
</Value>
<Value name="17">
<Value>CSSDExtRecMan</Value>
</Value>
<Value name="18">
<Value>CSSDExtSerMan</Value>
</Value>
<Value name="19">
<Value>CSSDExtReceipt</Value>
</Value>
<Value name="20">
<Value>CSSDExtTransfersDate</Value>
</Value>
<Value name="21">
<Value>CSSDExtDocName</Value>
</Value>
<Value name="22">
<Value>CSSDExtTransfersTime</Value>
</Value>
<Value name="23">
<Value>CSSDExtSickerName</Value>
</Value>
<Value name="24">
<Value>CSSDExtHospitalNo</Value>
</Value>
<Value name="25">
<Value>CSSDExtFirm</Value>
</Value>
<Value name="26">
<Value>CSSDExtTel</Value>
</Value>
<Value name="27">
<Value>CSSDExtInstruNum</Value>
</Value>
<Value name="28">
<Value>CSSDExtImplants</Value>
</Value>
<Value name="29">
<Value>CSSDExtPowerInstru</Value>
</Value>
<Value name="30">
<Value>CSSDExtRemark</Value>
</Value>
<Value name="31"/>
<Value name="32">
<Value>CSSDExtRecDate</Value>
</Value>
<Value name="33">
<Value>CSSDExtUseDate</Value>
</Value>
<Value name="34">
<Value>CSSDExtHospital</Value>
</Value>
<Value name="35">
<Value>CSSDExtFunctionalCheck</Value>
</Value>
<Value name="36">
<Value>CSSDExtPatientSex</Value>
</Value>
<Value name="37">
<Value>CSSDExtPatientAge</Value>
</Value>
<Value name="38">
<Value>CSSDExtBedNo</Value>
</Value>
<Value name="39">
<Value>CSSDExtSterParameter</Value>
</Value>
<Value name="40">
<Value>CSSDExtSterTemp</Value>
</Value>
<Value name="41">
<Value>CSSDExtBackwash</Value>
</Value>
<Value name="42">
<Value>CSSDExtOperatorType</Value>
</Value>
<Value name="43">
<Value>CSSDExtLabel</Value>
</Value>
<Value name="44">
<Value>CSSDExtTransfer</Value>
</Value>
<Value name="45">
<Value>CSSDExtTransferRec</Value>
</Value>
<Value name="46">
<Value>CSSDExtTransferDate</Value>
</Value>
<Value name="47">
<Value>CSSDExtIsTransfer</Value>
</Value>
<Value name="48">
<Value>CSSDExtOpPlanDr</Value>
</Value>
<Value name="49">
<Value>CSSDExtStatus</Value>
</Value>
</Data>
<DataLocation>^User.CSSDExtDevBindD</DataLocation>
<DefaultData>CSSDExtDevBindDefaultData</DefaultData>
<IdLocation>^User.CSSDExtDevBindD</IdLocation>
<IndexLocation>^User.CSSDExtDevBindI</IndexLocation>
<SqlRowIdName>CSSDExt_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDExtDevBindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

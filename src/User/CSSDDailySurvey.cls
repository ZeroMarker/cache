/// /消毒供应中心包装质量日常监测存在的问题记录表
Class User.CSSDDailySurvey Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_DailySurvey ]
{

/// 日期
Property CSSDSDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CSSDS_Date ];

/// 消毒包名称
Property CSSDDSPackage As User.CSSDPackage [ SqlColumnNumber = 3, SqlFieldName = CSSDDS_PackageDR ];

/// 种类
Property CSSDDSType As User.CSSDPackageClass [ SqlColumnNumber = 4, SqlFieldName = CSSDDS_Type ];

/// 规格
Property CSSDDSSpec As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDDS_Spec ];

/// 数量
Property CSSDDSQty As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDDS_Qty ];

/// 性能
Property CSSDDSProperty As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDDS_Property ];

/// 包装材料选择
Property CSSDDSSelectMaterial As User.CSSDMaterial [ SqlColumnNumber = 8, SqlFieldName = CSSDDS_SelectMaterial ];

/// 包装材料检查
Property CSSDDSCheckMaterial As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDDS_CheckMaterial ];

/// 精密锐利器械保护
Property CSSDDSPreciseProtect As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = CSSDDS_PreciseProtect ];

/// 轴节器械保护
Property CSSDDSCardoProtect As %String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = CSSDDS_CardoProtect ];

/// 包内化学指示卡
Property CSSDDSCheCard As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDDS_CheCard ];

/// 封包-密封宽度
Property CSSDDSWidth As %String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = CSSDDS_Width ];

/// 封包-密封距离
Property CSSDDSDistance As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = CSSDDS_Distance ];

/// 封包-闭合-胶带过短
Property CSSDDSTapeTooShort As %String(COLLATION = "Exact") [ SqlColumnNumber = 15, SqlFieldName = CSSDDS_TapeTooShort ];

/// 封包-闭合-闭合不完整
Property CSSDDSIncompleteClose As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CSSDDS_IncompleteClose ];

/// 封包-标识-六项标识
Property CSSDDSSixMarks As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDDS_SixMarks ];

/// 规格-体积<=30*30*50cm
Property CSSDDSVolume As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDDS_Volume ];

/// 规格-重量-器械包<=7kg
Property CSSDDSWeightInstrus As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = CSSDDS_WeightInstrus ];

/// 规格-重量-非循环包<=5kg
Property CSSDDSWeightDress As %String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = CSSDDS_WeightDress ];

/// 包装者
Property CSSDDSPackDr As %String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = CSSDDS_PackDr ];

/// 核对者
Property CSSDDSCheckDr As %String(COLLATION = "Exact") [ SqlColumnNumber = 22, SqlFieldName = CSSDDS_CheckDr ];

/// 包装质量
Property CSSDDSPackCheck As %String(COLLATION = "Exact") [ SqlColumnNumber = 23, SqlFieldName = CSSDDS_PackCheck ];

Index CSSDSDateIndex On CSSDSDate As Exact;

Storage Default
{
<Data name="CSSDDailySurveyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSDate</Value>
</Value>
<Value name="3">
<Value>CSSDDSPackage</Value>
</Value>
<Value name="4">
<Value>CSSDDSType</Value>
</Value>
<Value name="5">
<Value>CSSDDSSpec</Value>
</Value>
<Value name="6">
<Value>CSSDDSQty</Value>
</Value>
<Value name="7">
<Value>CSSDDSProperty</Value>
</Value>
<Value name="8">
<Value>CSSDDSSelectMaterial</Value>
</Value>
<Value name="9">
<Value>CSSDDSCheckMaterial</Value>
</Value>
<Value name="10">
<Value>CSSDDSPreciseProtect</Value>
</Value>
<Value name="11">
<Value>CSSDDSCardoProtect</Value>
</Value>
<Value name="12">
<Value>CSSDDSCheCard</Value>
</Value>
<Value name="13">
<Value>CSSDDSWidth</Value>
</Value>
<Value name="14">
<Value>CSSDDSDistance</Value>
</Value>
<Value name="15">
<Value>CSSDDSTapeTooShort</Value>
</Value>
<Value name="16">
<Value>CSSDDSIncompleteClose</Value>
</Value>
<Value name="17">
<Value>CSSDDSSixMarks</Value>
</Value>
<Value name="18">
<Value>CSSDDSVolume</Value>
</Value>
<Value name="19">
<Value>CSSDDSWeightInstrus</Value>
</Value>
<Value name="20">
<Value>CSSDDSWeightDress</Value>
</Value>
<Value name="21">
<Value>CSSDDSPackDr</Value>
</Value>
<Value name="22">
<Value>CSSDDSCheckDr</Value>
</Value>
<Value name="23">
<Value>CSSDDSPackCheck</Value>
</Value>
</Data>
<DataLocation>^User.CSSDDailySurveyD</DataLocation>
<DefaultData>CSSDDailySurveyDefaultData</DefaultData>
<IdLocation>^User.CSSDDailySurveyD</IdLocation>
<IndexLocation>^User.CSSDDailySurveyI</IndexLocation>
<StreamLocation>^User.CSSDDailySurveyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

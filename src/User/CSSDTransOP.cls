Class User.CSSDTransOP Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDTOP_Rowid, SqlTableName = CSSD_Trans_OP ]
{

/// 手术安排表
Property CSSDTOPANOPID As User.DHCANOPArrange [ SqlColumnNumber = 2, SqlFieldName = CSSDTOP_ANOPID ];

/// 医护人员信息
Property CSSDTOPCountNurseDR As User.CTCareProv [ SqlColumnNumber = 3, SqlFieldName = CSSDTOP_CountNurseDR ];

/// 器械清点时间
Property CSSDTOPCountNurseTime As %Library.TimeStamp [ SqlColumnNumber = 4, SqlFieldName = CSSDTOP_CountNurseTime ];

Property CSSDTOPInfectName As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CSSDTOP_InfectName ];

Property CSSDTOPLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = CSSDTOP_Label ];

/// 医护人员信息
Property CSSDTOPOPDoctor As User.CTCareProv [ SqlColumnNumber = 7, SqlFieldName = CSSDTOP_OPDoctor ];

/// 手术名称,中间用逗号隔开,每个指向 User.ORCOperation
Property CSSDTOPOPName As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CSSDTOP_OPName ];

/// 手术房间号(存储的CF_AN.Location表的id)
Property CSSDTOPOPRoom As %String(COLLATION = "Exact") [ SqlColumnNumber = 9, SqlFieldName = CSSDTOP_OPRoom ];

/// 患者信息
Property CSSDTOPPationtDR As User.PAAdm [ SqlColumnNumber = 10, SqlFieldName = CSSDTOP_PationtDR ];

Property CSSDTOPPationtName As %String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = CSSDTOP_PationtName ];

Property CSSDOPCircNurse As User.CTCareProv [ SqlColumnNumber = 12, SqlFieldName = CSSDTOP_CircNurse ];

/// 住院号新增
Property CSSDTOPHospitalNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = CSSDTOP_HospitalNo ];

/// 患者类型1是住院，2门诊
Property CSSDTOPPationtType As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = CSSDTOP_PationtType ];

/// 患者卡号
Property CSSDTOPCardNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 15, SqlFieldName = CSSDTOP_CardNo ];

/// 患者性别
Property CSSDTOPSex As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CSSDTOP_Sex ];

/// 手术台次
Property CSSDTOPOprTabletime As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDTOP_OprTabletime ];

/// 手术医生名称针对第三方
Property CSSDTOPDoctor As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDTOP_Doctor ];

/// 巡回护士名称针对第三方
Property CSSDTOPCircNurseName As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = CSSDTOP_CircNurseName ];

/// 器械护士名称针对第三方
Property CSSDTOPCountNurseName As %String(COLLATION = "Exact") [ SqlColumnNumber = 20, SqlFieldName = CSSDTOP_CountNurseName ];

/// 是否第三方标志 1 是第三方手麻
Property CSSDTOPIsThird As %String(COLLATION = "Exact") [ SqlColumnNumber = 21, SqlFieldName = CSSDTOP_IsThird ];

/// 手术日期
Property CSSDTOPOprDate As %Date [ SqlColumnNumber = 22, SqlFieldName = CSSDTOP_OprDate ];

/// 登记的时候关联请领明细表
Property CSSDTOPPackageApplyDetailDR As User.CSSDPackageApplyDetail [ SqlColumnNumber = 23, SqlFieldName = CSSDTOP_PackageApplyDetailDR ];

/// 器械清点日期
Property CSSDOPCountDate As %Library.Date [ SqlColumnNumber = 24, SqlFieldName = CSSDOP_CountDate ];

/// 器械清点时间
Property CSSDOPCountTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = CSSDOP_CountTime ];

Index CSSDTOPLabelIndex On CSSDTOPLabel As Exact;

Index CSSDTOPPationtDRIndex On CSSDTOPPationtDR As Exact;

Index UseDateIndex On CSSDOPCountDate As Exact;

Storage Default
{
<Data name="CSSDTransOPDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDTOPANOPID</Value>
</Value>
<Value name="3">
<Value>CSSDTOPCountNurseDR</Value>
</Value>
<Value name="4">
<Value>CSSDTOPCountNurseTime</Value>
</Value>
<Value name="5">
<Value>CSSDTOPInfectName</Value>
</Value>
<Value name="6">
<Value>CSSDTOPLabel</Value>
</Value>
<Value name="7">
<Value>CSSDTOPOPDoctor</Value>
</Value>
<Value name="8">
<Value>CSSDTOPOPName</Value>
</Value>
<Value name="9">
<Value>CSSDTOPOPRoom</Value>
</Value>
<Value name="10">
<Value>CSSDTOPPationtDR</Value>
</Value>
<Value name="11">
<Value>CSSDTOPPationtName</Value>
</Value>
<Value name="12">
<Value>CSSDOPCircNurse</Value>
</Value>
<Value name="13">
<Value>CSSDTOPHospitalNo</Value>
</Value>
<Value name="14">
<Value>CSSDTOPPationtType</Value>
</Value>
<Value name="15">
<Value>CSSDTOPCardNo</Value>
</Value>
<Value name="16">
<Value>CSSDTOPSex</Value>
</Value>
<Value name="17">
<Value>CSSDTOPOprTabletime</Value>
</Value>
<Value name="18">
<Value>CSSDTOPDoctor</Value>
</Value>
<Value name="19">
<Value>CSSDTOPCircNurseName</Value>
</Value>
<Value name="20">
<Value>CSSDTOPCountNurseName</Value>
</Value>
<Value name="21">
<Value>CSSDTOPIsThird</Value>
</Value>
<Value name="22">
<Value>CSSDTOPOprDate</Value>
</Value>
<Value name="23">
<Value>CSSDTOPPackageApplyDetailDR</Value>
</Value>
<Value name="24">
<Value>CSSDOPCountDate</Value>
</Value>
<Value name="25">
<Value>CSSDOPCountTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDTransOPD</DataLocation>
<DefaultData>CSSDTransOPDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDTransOPD</IdLocation>
<IndexLocation>^User.CSSDTransOPI</IndexLocation>
<SqlRowIdName>CSSDTOP_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDTransOPS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

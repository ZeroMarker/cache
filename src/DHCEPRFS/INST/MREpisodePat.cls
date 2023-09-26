Class DHCEPRFS.INST.MREpisodePat Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 02 系统标识号
Property SysCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 03 病人标识号
Property PatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 04 医疗组织机构代码
Property CompanyCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 05 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 06 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 07 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 7 ];

/// 08 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 8 ];

/// 09 就诊总次数
Property AdmCount As %Integer [ SqlColumnNumber = 9 ];

/// 10 入院总次数
Property InCount As %Integer [ SqlColumnNumber = 10 ];

/// 11 病案号
Property MedRecordNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 12 登记号
Property RegNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 13 姓名
Property Name As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 14 性别
Property Gender As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 15 出生日期
Property Birthday As %String(TRUNCATE = 1) [ SqlColumnNumber = 15 ];

/// 16 年龄(年)
Property Age As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

/// 17 婚姻状况
Property Marriage As %String(TRUNCATE = 1) [ SqlColumnNumber = 17 ];

/// 18 民族
Property Nationality As %String(TRUNCATE = 1) [ SqlColumnNumber = 18 ];

/// 19 身份证号
Property IDCard As %String(TRUNCATE = 1) [ SqlColumnNumber = 19 ];

/// 20 证件类别
Property CardType As %String(TRUNCATE = 1) [ SqlColumnNumber = 20 ];

/// 21 证件号
Property GovCardno As %String(TRUNCATE = 1) [ SqlColumnNumber = 21 ];

/// 22 卡类型
Property OPCardType As %String(TRUNCATE = 1) [ SqlColumnNumber = 22 ];

/// 23 卡号
Property OPCardID As %String(TRUNCATE = 1) [ SqlColumnNumber = 23 ];

/// 24 医保类型
Property InsuType As %String(TRUNCATE = 1) [ SqlColumnNumber = 24 ];

/// 25 医保号
Property InsuNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 25 ];

/// 26 手机号
Property PhoneNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 26 ];

/// 27 联系人姓名
Property LinkName As %String(TRUNCATE = 1) [ SqlColumnNumber = 27 ];

/// 28 联系人关系
Property LinkRelation As %String(TRUNCATE = 1) [ SqlColumnNumber = 28 ];

/// 29 联系人电话
Property LinkPhone As %String(TRUNCATE = 1) [ SqlColumnNumber = 29 ];

/// 30 职业
Property Occupation As %String(TRUNCATE = 1) [ SqlColumnNumber = 30 ];

/// 31 工作单位
Property Company As %String(TRUNCATE = 1) [ SqlColumnNumber = 31 ];

/// 32 工作电话
Property Worktel As %String(TRUNCATE = 1) [ SqlColumnNumber = 32 ];

/// 33 户口地址省
Property HouseProvince As %String(TRUNCATE = 1) [ SqlColumnNumber = 33 ];

/// 34 户口地址市
Property HouseCity As %String(TRUNCATE = 1) [ SqlColumnNumber = 34 ];

/// 35 户口地址县区
Property HouseArea As %String(TRUNCATE = 1) [ SqlColumnNumber = 35 ];

/// 36 户口地址
Property HouseAddress As %String(TRUNCATE = 1) [ SqlColumnNumber = 36 ];

/// 37 户口邮编
Property HouseZipCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 37 ];

/// 38 现住址省
Property ResidentProvince As %String(TRUNCATE = 1) [ SqlColumnNumber = 38 ];

/// 39 现住址市
Property ResidentCity As %String(TRUNCATE = 1) [ SqlColumnNumber = 39 ];

/// 40 现住址县区
Property ResidentArea As %String(TRUNCATE = 1) [ SqlColumnNumber = 40 ];

/// 41 现住址地址
Property ResidentAddress As %String(TRUNCATE = 1) [ SqlColumnNumber = 41 ];

/// 42 现住址邮编
Property ResidentZipCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 42 ];

/// 43 婚姻状况ID
Property MarriageID As %String(TRUNCATE = 1) [ SqlColumnNumber = 43 ];

/// 44 民族ID
Property NationalityID As %String(TRUNCATE = 1) [ SqlColumnNumber = 44 ];

/// 45 证件类别ID
Property CardTypeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 45 ];

/// 46 卡类型ID
Property OPCardTypeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 46 ];

/// 47 医保类型ID
Property InsuTypeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 47 ];

/// 48 联系人关系ID
Property LinkRelationID As %String(TRUNCATE = 1) [ SqlColumnNumber = 48 ];

/// 49 户口地址省ID
Property HouseProvinceID As %String(TRUNCATE = 1) [ SqlColumnNumber = 49 ];

/// 50 户口地址市ID
Property HouseCityID As %String(TRUNCATE = 1) [ SqlColumnNumber = 50 ];

/// 51 户口地址县区ID
Property HouseAreaID As %String(TRUNCATE = 1) [ SqlColumnNumber = 51 ];

/// 52 现住址省ID
Property ResidentProvinceID As %String(TRUNCATE = 1) [ SqlColumnNumber = 52 ];

/// 53 现住址市ID
Property ResidentCityID As %String(TRUNCATE = 1) [ SqlColumnNumber = 53 ];

/// 54 现住址县区ID
Property ResidentAreaID As %String(TRUNCATE = 1) [ SqlColumnNumber = 54 ];

/// 55 新生儿母亲的登记RowID
Property MotherPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 55 ];

/// 56 年龄(月)
Property AgeMonth As %String(TRUNCATE = 1) [ SqlColumnNumber = 56 ];

/// 57 年龄(日)
Property AgeDay As %String(TRUNCATE = 1) [ SqlColumnNumber = 57 ];

/// 58
Property EpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 58 ];

/// 59
Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 59 ];

/// 60
Property MRPatientID As %String(TRUNCATE = 1) [ SqlColumnNumber = 60 ];

/// 61 归档病案ID
Property MRMedRecordID As %String(TRUNCATE = 1) [ SqlColumnNumber = 61 ];

/// 62 姓名-拼音
Property AliasName As %String(TRUNCATE = 1) [ SqlColumnNumber = 62 ];

/// 63 姓名-首字母拼音
Property AliasNameInitial As %String(TRUNCATE = 1) [ SqlColumnNumber = 63 ];

/// 64 留观号
Property ObservedNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 64 ];

Index IdxMain On (MREpisodeID, MRMedRecordID) [ Unique ];

Index IdxPatientID On (SysCode, PatientID);

Index IdxMRPatientID On (MRPatientID, MREpisodeID);

Index IdxMREpisodeID On MREpisodeID;

Index IdxEpisodeID On EpisodeID;

Index IdxName On Name;

Index IdxAliasName On AliasName;

Index IdxAliasNameInitial On AliasNameInitial;

Index IdxIDCard On IDCard;

Index IdxMedRecordNo On MedRecordNo;

Index IdxRegNo On RegNo;

Index IdxMotherPatientID On (SysCode, MotherPatientID);

Storage Default
{
<Data name="MREpisodePatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>MRPatientID</Value>
</Value>
<Value name="4">
<Value>CompanyCode</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>LastModifyDate</Value>
</Value>
<Value name="8">
<Value>LastModifyTime</Value>
</Value>
<Value name="9">
<Value>AdmCount</Value>
</Value>
<Value name="10">
<Value>InCount</Value>
</Value>
<Value name="11">
<Value>MedRecordNo</Value>
</Value>
<Value name="12">
<Value>RegNo</Value>
</Value>
<Value name="13">
<Value>Name</Value>
</Value>
<Value name="14">
<Value>Gender</Value>
</Value>
<Value name="15">
<Value>Birthday</Value>
</Value>
<Value name="16">
<Value>Age</Value>
</Value>
<Value name="17">
<Value>Marriage</Value>
</Value>
<Value name="18">
<Value>Nationality</Value>
</Value>
<Value name="19">
<Value>IDCard</Value>
</Value>
<Value name="20">
<Value>CardType</Value>
</Value>
<Value name="21">
<Value>GovCardno</Value>
</Value>
<Value name="22">
<Value>OPCardType</Value>
</Value>
<Value name="23">
<Value>OPCardID</Value>
</Value>
<Value name="24">
<Value>InsuType</Value>
</Value>
<Value name="25">
<Value>InsuNo</Value>
</Value>
<Value name="26">
<Value>PhoneNo</Value>
</Value>
<Value name="27">
<Value>LinkName</Value>
</Value>
<Value name="28">
<Value>LinkRelation</Value>
</Value>
<Value name="29">
<Value>LinkPhone</Value>
</Value>
<Value name="30">
<Value>Occupation</Value>
</Value>
<Value name="31">
<Value>Company</Value>
</Value>
<Value name="32">
<Value>Worktel</Value>
</Value>
<Value name="33">
<Value>HouseProvince</Value>
</Value>
<Value name="34">
<Value>HouseCity</Value>
</Value>
<Value name="35">
<Value>HouseArea</Value>
</Value>
<Value name="36">
<Value>HouseAddress</Value>
</Value>
<Value name="37">
<Value>HouseZipCode</Value>
</Value>
<Value name="38">
<Value>ResidentProvince</Value>
</Value>
<Value name="39">
<Value>ResidentCity</Value>
</Value>
<Value name="40">
<Value>ResidentArea</Value>
</Value>
<Value name="41">
<Value>ResidentAddress</Value>
</Value>
<Value name="42">
<Value>ResidentZipCode</Value>
</Value>
<Value name="43">
<Value>MarriageID</Value>
</Value>
<Value name="44">
<Value>NationalityID</Value>
</Value>
<Value name="45">
<Value>CardTypeID</Value>
</Value>
<Value name="46">
<Value>OPCardTypeID</Value>
</Value>
<Value name="47">
<Value>InsuTypeID</Value>
</Value>
<Value name="48">
<Value>LinkRelationID</Value>
</Value>
<Value name="49">
<Value>HouseProvinceID</Value>
</Value>
<Value name="50">
<Value>HouseCityID</Value>
</Value>
<Value name="51">
<Value>HouseAreaID</Value>
</Value>
<Value name="52">
<Value>ResidentProvinceID</Value>
</Value>
<Value name="53">
<Value>ResidentCityID</Value>
</Value>
<Value name="54">
<Value>ResidentAreaID</Value>
</Value>
<Value name="55">
<Value>AgeDay</Value>
</Value>
<Value name="56">
<Value>AgeMonth</Value>
</Value>
<Value name="57">
<Value>EpisodeID</Value>
</Value>
<Value name="58">
<Value>MotherPatientID</Value>
</Value>
<Value name="59">
<Value>PatientID</Value>
</Value>
<Value name="60">
<Value>SysCode</Value>
</Value>
<Value name="61">
<Value>MRMedRecordID</Value>
</Value>
<Value name="62">
<Value>AliasName</Value>
</Value>
<Value name="63">
<Value>AliasNameInitial</Value>
</Value>
<Value name="64">
<Value>ObservedNo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MREpisodePatD</DataLocation>
<DefaultData>MREpisodePatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MREpisodePatD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MREpisodePatI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MREpisodePatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

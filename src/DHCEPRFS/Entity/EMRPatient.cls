Class DHCEPRFS.Entity.EMRPatient Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 02 系统标识号
Property SysCode As %String(TRUNCATE = 1);

/// 03 病人标识号
Property PatientID As %String(TRUNCATE = 1);

/// 04 医疗组织机构代码
Property CompanyCode As %String(TRUNCATE = 1);

/// 05 创建日期
Property CreateDate As %Date;

/// 06 创建时间
Property CreateTime As %Time;

/// 07 最后修改日期
Property LastModifyDate As %Date;

/// 08 最后修改时间
Property LastModifyTime As %Time;

/// 09 就诊总次数
Property AdmCount As %Integer;

/// 10 入院总次数
Property InCount As %Integer;

/// 11 病案号
Property MedRecordNo As %String(TRUNCATE = 1);

/// 12 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 13 姓名
Property Name As %String(TRUNCATE = 1);

/// 14 性别
Property Gender As %String(TRUNCATE = 1);

/// 15 出生日期
Property Birthday As %String(TRUNCATE = 1);

/// 16 年龄(年)
Property Age As %String(TRUNCATE = 1);

/// 17 婚姻状况
Property Marriage As %String(TRUNCATE = 1);

/// 18 民族
Property Nationality As %String(TRUNCATE = 1);

/// 19 身份证号
Property IDCard As %String(TRUNCATE = 1);

/// 20 证件类别
Property CardType As %String(TRUNCATE = 1);

/// 21 证件号
Property GovCardno As %String(TRUNCATE = 1);

/// 22 卡类型
Property OPCardType As %String(TRUNCATE = 1);

/// 23 卡号
Property OPCardID As %String(TRUNCATE = 1);

/// 24 医保类型
Property InsuType As %String(TRUNCATE = 1);

/// 25 医保号
Property InsuNo As %String(TRUNCATE = 1);

/// 26 手机号
Property PhoneNo As %String(TRUNCATE = 1);

/// 27 联系人姓名
Property LinkName As %String(TRUNCATE = 1);

/// 28 联系人关系
Property LinkRelation As %String(TRUNCATE = 1);

/// 29 联系人电话
Property LinkPhone As %String(TRUNCATE = 1);

/// 30 职业
Property Occupation As %String(TRUNCATE = 1);

/// 31 工作单位
Property Company As %String(TRUNCATE = 1);

/// 32 工作电话
Property Worktel As %String(TRUNCATE = 1);

/// 33 户口地址省
Property HouseProvince As %String(TRUNCATE = 1);

/// 34 户口地址市
Property HouseCity As %String(TRUNCATE = 1);

/// 35 户口地址县区
Property HouseArea As %String(TRUNCATE = 1);

/// 36 户口地址
Property HouseAddress As %String(TRUNCATE = 1);

/// 37 户口邮编
Property HouseZipCode As %String(TRUNCATE = 1);

/// 38 现住址省
Property ResidentProvince As %String(TRUNCATE = 1);

/// 39 现住址市
Property ResidentCity As %String(TRUNCATE = 1);

/// 40 现住址县区
Property ResidentArea As %String(TRUNCATE = 1);

/// 41 现住址地址
Property ResidentAddress As %String(TRUNCATE = 1);

/// 42 现住址邮编
Property ResidentZipCode As %String(TRUNCATE = 1);

/// 43 婚姻状况ID
Property MarriageID As %String(TRUNCATE = 1);

/// 44 民族ID
Property NationalityID As %String(TRUNCATE = 1);

/// 45 证件类别ID
Property CardTypeID As %String(TRUNCATE = 1);

/// 46 卡类型ID
Property OPCardTypeID As %String(TRUNCATE = 1);

/// 47 医保类型ID
Property InsuTypeID As %String(TRUNCATE = 1);

/// 48 联系人关系ID
Property LinkRelationID As %String(TRUNCATE = 1);

/// 49 户口地址省ID
Property HouseProvinceID As %String(TRUNCATE = 1);

/// 50 户口地址市ID
Property HouseCityID As %String(TRUNCATE = 1);

/// 51 户口地址县区ID
Property HouseAreaID As %String(TRUNCATE = 1);

/// 52 现住址省ID
Property ResidentProvinceID As %String(TRUNCATE = 1);

/// 53 现住址市ID
Property ResidentCityID As %String(TRUNCATE = 1);

/// 54 现住址县区ID
Property ResidentAreaID As %String(TRUNCATE = 1);

/// 55 新生儿母亲的登记RowID
Property MotherPatientID As %String(TRUNCATE = 1);

/// 56 年龄(月)
Property AgeMonth As %String(TRUNCATE = 1);

/// 57 年龄(日)
Property AgeDay As %String(TRUNCATE = 1);

/// 58 姓名-拼音
Property AliasName As %String(TRUNCATE = 1);

/// 59 姓名-首字母拼音
Property AliasNameInitial As %String(TRUNCATE = 1);

/// 60 留观号
Property ObservedNo As %String(TRUNCATE = 1);

}

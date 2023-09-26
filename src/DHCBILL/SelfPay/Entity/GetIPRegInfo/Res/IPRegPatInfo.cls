Class DHCBILL.SelfPay.Entity.GetIPRegInfo.Res.IPRegPatInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 患者ID	
Property PatientID As %String(TRUNCATE = 1);

/// 姓名	
Property PatName As %String(TRUNCATE = 1);

/// 病案号	
Property Medicare As %String(TRUNCATE = 1);

/// 性别	
Property Sex As %String(TRUNCATE = 1);

/// 身份证号	
Property PaperID As %String(TRUNCATE = 1);

/// 出生日期	
Property BirthDate As %String(TRUNCATE = 1);

/// 年龄	
Property Age As %String(TRUNCATE = 1);

/// 婚姻状况	
Property MarDescID As %String(TRUNCATE = 1);

/// 宗教	
Property RLGDescID As %String(TRUNCATE = 1);

/// 住家地址	
Property Address As %String(TRUNCATE = 1);

/// 工作单位	
Property Company As %String(TRUNCATE = 1);

/// 宅电	
Property HomeTel As %String(TRUNCATE = 1);

/// 工作电话	
Property WorkTel As %String(TRUNCATE = 1);

/// 邮政编码	
Property ZipCode As %String(TRUNCATE = 1);

/// 邮箱	
Property Email As %String(TRUNCATE = 1);

/// 手机	
Property MobTel As %String(TRUNCATE = 1);

/// 社会地位	
Property SocSatID As %String(TRUNCATE = 1);

/// 民族	
Property NationID As %String(TRUNCATE = 1);

/// 证件类型	
Property CardTypeID As %String(TRUNCATE = 1);

/// 证件号码	
Property GovCardNo As %String(TRUNCATE = 1);

/// 国籍	
Property CountryID As %String(TRUNCATE = 1);

/// 职业	
Property OccuID As %String(TRUNCATE = 1);

/// 教育	
Property EduID As %String(TRUNCATE = 1);

/// 语言	
Property LanguID As %String(TRUNCATE = 1);

/// 雇佣情况	
Property EmptypeID As %String(TRUNCATE = 1);

/// 省(出生)	
Property BirProv As %String(TRUNCATE = 1);

/// 市(出生)	
Property BirCity As %String(TRUNCATE = 1);

/// 省(现住址)	
Property ProvID As %String(TRUNCATE = 1);

/// 市(现住址)	
Property CityID As %String(TRUNCATE = 1);

/// 区县(现住址)	
Property CityareaID As %String(TRUNCATE = 1);

/// 籍贯省	
Property HomeProv As %String(TRUNCATE = 1);

/// 籍贯市	
Property HomeCity As %String(TRUNCATE = 1);

/// 省(户口)	
Property BorProv As %String(TRUNCATE = 1);

/// 市(户口)	
Property BorCity As %String(TRUNCATE = 1);

/// 区县(户口)	
Property BorTown As %String(TRUNCATE = 1);

/// 与患者关系	
Property CtrltID As %String(TRUNCATE = 1);

/// 联系人	
Property ForeignID As %String(TRUNCATE = 1);

/// 联系人电话	
Property FPhon As %String(TRUNCATE = 1);

/// 联系人地址	
Property FAddress As %String(TRUNCATE = 1);

/// 备注	
Property FNotes As %String(TRUNCATE = 1);

/// 住院次数	
Property AdmTimes As %String(TRUNCATE = 1);

/// 新生儿天	
Property babybir As %String(TRUNCATE = 1);

/// 新生儿小时	
Property agehour As %String(TRUNCATE = 1);

/// 新生儿分钟	
Property ageMinutes As %String(TRUNCATE = 1);

}

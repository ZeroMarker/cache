/// 标本表
Class dbo.RPVisitNumber Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumber, StorageStrategy = Default ]
{

Index IndexLocation On (LocationDR, AddDate) [ SqlName = Index_Location, Type = index ];

Index IndexAddType On (AddType, ReceiveHospitalDR, AddDate) [ SqlName = Index_AddType, Type = index ];

Index IndexAddDate On (ReceiveHospitalDR, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexAdmNo On (AdmNo, RequestDate) [ SqlName = Index_AdmNo, Type = index ];

Index IndexCarryDate On (HospitalDR, CarryDate) [ SqlName = Index_CarryDate, Type = index ];

Index IndexCollectDate On (HospitalDR, CollectDate) [ SqlName = Index_CollectDate, Type = index ];

Index IndexInStorageDate On (ReceiveHospitalDR, InStorageDate) [ SqlName = Index_InStorageDate, Type = index ];

Index IndexMedicalRecordNo On (MedicalRecordNo, HospitalDR) [ SqlName = Index_MedicalRecordNo, Type = index ];

Index IndexName On (SurName, RegNo) [ SqlName = Index_Name, Type = index ];

Index IndexNameDate On (SurName, ReceiveDate) [ SqlName = Index_NameDate, Type = index ];

Index IndexOutStorageDate On (ReceiveHospitalDR, OutStorageDate) [ SqlName = Index_OutStorageDate, Type = index ];

Index IndexPatientRequest On (RegNo, RequestDate) [ SqlName = Index_PatientRequest, Type = index ];

Index IndexPatientAddDate On (RegNo, AddDate) [ SqlName = Index_PatientAddDate, Type = index ];

Index IndexReceiveDate On (ReceiveHospitalDR, ReceiveDate) [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexRequestDate On (HospitalDR, RequestDate) [ SqlName = Index_RequestDate, Type = index ];

Index IndexArriveDate On (ReceiveHospitalDR, ArriveDate) [ SqlName = Index_ArriveDate, Type = index ];

Index IndexRequestNo On RequestNo [ SqlName = Index_RequestNo, Type = index ];

Index IndexVisitNumber On VisitNumber [ SqlName = Index_VisitNumber, Type = index, Unique ];

Index IndexMixLabNo On MixLabNo [ SqlName = Index_MixLabNo, Type = index ];

Index IndexIDNumber On IDNumber [ SqlName = Index_IDNumber, Type = index ];

Index IndexExtLabNo On ExtLabNo [ SqlName = Index_ExtLabNo, Type = index ];

Index IndexAdmCard On (AdmCard, RequestDate) [ SqlName = Index_AdmCard, Type = index ];

Index IndexPatID On PatID [ SqlName = Index_PatID, Type = index ];

Index IndexRegNoHosp On (RegNo, ReceiveDate, ReceiveHospitalDR) [ SqlName = Index_RegNoHosp, Type = index ];

Index IndexRegNoWG On (RegNo, ReceiveDate, ReceiveWorkGroupDR) [ SqlName = Index_RegNoWG, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBER On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBER, Type = index, Unique ];

/// Foreign Key FKFKVisitNumberDoctor created via DDL
ForeignKey FKFKVisitNumberDoctor(DoctorDR) References dbo.BTDoctor(PKBTDOCTOR) [ SqlName = FK_FK_VisitNumberDoctor ];

/// Foreign Key FKFKVisitNumberRH created via DDL
ForeignKey FKFKVisitNumberRH(RhDR) References dbo.BTRHBG(PKBTRHBG) [ SqlName = FK_FK_VisitNumberRH ];

/// Foreign Key FKFKVisitNumberWard created via DDL
ForeignKey FKFKVisitNumberWard(WardDR) References dbo.BTWard(PKBTWARD) [ SqlName = FK_FK_VisitNumberWard ];

/// Foreign Key FKVisitNumberABO created via DDL
ForeignKey FKVisitNumberABO(AboDR) References dbo.BTABOBG(PKBTABOBG) [ SqlName = FK_VisitNumberABO ];

/// Foreign Key FKVisitNumberAddUser created via DDL
ForeignKey FKVisitNumberAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberAddUser ];

/// Foreign Key FKVisitNumberAdmType created via DDL
ForeignKey FKVisitNumberAdmType(AdmissionTypeDR) References dbo.BTAdmissionType(PKBTADMISSIONTYPE) [ SqlName = FK_VisitNumberAdmType ];

/// Foreign Key FKVisitNumberAgeUnit created via DDL
ForeignKey FKVisitNumberAgeUnit(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_VisitNumberAgeUnit ];

/// Foreign Key FKVisitNumberCarryUser created via DDL
ForeignKey FKVisitNumberCarryUser(CarryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberCarryUser ];

/// Foreign Key FKVisitNumberArriveUser created via DDL
ForeignKey FKVisitNumberArriveUser(ArriveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberArriveUser ];

/// Foreign Key FKVisitNumberCertType created via DDL
ForeignKey FKVisitNumberCertType(CertTypeDR) References dbo.BTCertType(PKBTCERTTYPE) [ SqlName = FK_VisitNumberCertType ];

/// Foreign Key FKVisitNumberClinicCond created via DDL
ForeignKey FKVisitNumberClinicCond(ClinicalConditionsDR) References dbo.BTClinicalConditions(PKBTCLINICALCONDITIONS) [ SqlName = FK_VisitNumberClinicCond ];

/// Foreign Key FKVisitNumberCollectUser created via DDL
ForeignKey FKVisitNumberCollectUser(CollectUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberCollectUser ];

/// Foreign Key FKVisitNumberContainer created via DDL
ForeignKey FKVisitNumberContainer(ContainerDR) References dbo.BTContainer(PKBTCONTAINER) [ SqlName = FK_VisitNumberContainer ];

/// Foreign Key FKVisitNumberEthnicity created via DDL
ForeignKey FKVisitNumberEthnicity(EthnicityDR) References dbo.BTEthnicity(PKBTETHNICITY) [ SqlName = FK_VisitNumberEthnicity ];

/// Foreign Key FKVisitNumberHospital created via DDL
ForeignKey FKVisitNumberHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_VisitNumberHospital ];

/// Foreign Key FKVisitNumberInUser created via DDL
ForeignKey FKVisitNumberInUser(InStorageUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberInUser ];

/// Foreign Key FKVisitNumberLocation created via DDL
ForeignKey FKVisitNumberLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_VisitNumberLocation ];

/// Foreign Key FKVisitNumberOutUser created via DDL
ForeignKey FKVisitNumberOutUser(OutStorageUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberOutUser ];

/// Foreign Key FKVisitNumberPaymentType created via DDL
ForeignKey FKVisitNumberPaymentType(PaymentTypeDR) References dbo.BTPaymentType(PKBTPAYMENTTYPE) [ SqlName = FK_VisitNumberPaymentType ];

/// Foreign Key FKVisitNumberRecHosp created via DDL
ForeignKey FKVisitNumberRecHosp(ReceiveHospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_VisitNumberRecHosp ];

/// Foreign Key FKVisitNumberRecUser created via DDL
ForeignKey FKVisitNumberRecUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberRecUser ];

/// Foreign Key FKVisitNumberSite created via DDL
ForeignKey FKVisitNumberSite(AnatomicalSiteDR) References dbo.BTAnatomicalSite(PKBTANATOMICALSITE) [ SqlName = FK_VisitNumberSite ];

/// Foreign Key FKVisitNumberSpecQuality created via DDL
ForeignKey FKVisitNumberSpecQuality(SpecimenQualityDR) References dbo.BTSpecimenQuality(PKBTSPECIMENQUALITY) [ SqlName = FK_VisitNumberSpecQuality ];

/// Foreign Key FKVisitNumberSpecType created via DDL
ForeignKey FKVisitNumberSpecType(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_VisitNumberSpecType ];

/// Foreign Key FKVisitNumberSpecies created via DDL
ForeignKey FKVisitNumberSpecies(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_VisitNumberSpecies ];

/// Foreign Key FKRUDiseaseDR created via DDL
ForeignKey FKRUDiseaseDR(RUDiseaseDR) References dbo.BTRUDisease(PKBTRUDisease) [ SqlName = FK_VisitNumberRUDiseaseDR ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKArriveWorkGroup(ArriveWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_ArriveWorkGroup ];

/// Foreign Key FKReceiveWorkGroup created via DDL
ForeignKey FKReceiveWorkGroup(ReceiveWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_ReceiveWorkGroup ];

ForeignKey FKCountryDR(CountryDR) References dbo.BTCountry(PKBTCOUNTRY) [ SqlName = FK_Country ];

/// Foreign Key FK_VisitNumberExtLaboratory created via DDL
ForeignKey FKVisitNumberExtLaboratory(ExtLaboratoryDR) References dbo.BTExtLaboratory(PKBTEXTLABORATORY) [ SqlName = FK_VisitNumberExtLaboratory ];

/// Foreign Key FK_VisitNumberChargeType created via DDL
ForeignKey FKVisitNumberChargeType(ChargeTypeDR) References dbo.BTChargeType(PKBTCHARGETYPE) [ SqlName = FK_VisitNumberChargeType ];

/// Foreign Key FK_VisitNumberTopic created via DDL
ForeignKey FKVisitNumberTopic(TopicDR) References dbo.BTTopic(PKBTTOPIC) [ SqlName = FK_VisitNumberTopic ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本号  
Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 登记号  
Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 就诊类型  
Property AdmissionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 就诊号  
Property AdmNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 就诊病案号  
Property MedicalRecordNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 就诊日期  
Property AdmDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 就诊时间  
Property AdmTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 证件类型  
Property CertTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 证件号  
Property CertNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// 身份证号  
Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 12 ];

/// 支付类型  
Property PaymentTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 姓名  
Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 14 ];

/// 别名  
Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 15 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 出生日期  
Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 出生日期  
Property BirthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 年龄  
Property Age As %Library.Float [ SqlColumnNumber = 19 ];

/// 年龄单位  
Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 民族  
Property EthnicityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 申请医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 申请科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 申请医生  
Property DoctorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 申请日期  
Property RequestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 申请时间  
Property RequestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

/// 病区  
Property WardDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 27 ];

/// 床号  
Property BedNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 28 ];

/// 临床症状  
Property Symptom As %Library.String(COLLATION = "Exact", MAXLEN = 600) [ SqlColumnNumber = 29 ];

/// 手机号  
Property MobileNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 30 ];

/// 座机号  
Property PhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 31 ];

/// email  
Property EMail As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 32 ];

/// 身高  
Property Height As %Library.Float [ SqlColumnNumber = 33 ];

/// 体重  
Property Weight As %Library.Float [ SqlColumnNumber = 34 ];

/// 血压  
Property BloodPressure As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 35 ];

/// 生理条件  
Property ClinicalConditionsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 末次月经日期  
Property LMPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 37 ];

/// 是否怀孕  {1:true,0:false}
Property Pregnant As %Library.Boolean [ SqlColumnNumber = 38 ];

/// 怀孕周数  
Property PregnantWeeks As %Library.Float [ SqlColumnNumber = 39 ];

/// ABO血型  
Property AboDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 40 ];

/// RH血型  
Property RhDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 41 ];

/// 地址  
Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 42 ];

/// 邮编  
Property PostCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 43 ];

/// 传染标志  {1:true,0:false}
Property InfectFlag As %Library.Boolean [ SqlColumnNumber = 44 ];

/// 院感标志  
Property InfectAlert As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 45 ];

/// 特殊标本标志  {1:true,0:false}
Property SpecialFlag As %Library.Boolean [ SqlColumnNumber = 46 ];

/// 孕次  
Property PregnantNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 47 ];

/// 产次  
Property ChildbirthNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 48 ];

/// 申请备注  
Property ReqNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 49 ];

/// 申请单号  
Property RequestNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 50 ];

/// 枚举数据{0:常规，1：加急，2:绿色通道}
Property Urgent As %TinyInt [ SqlColumnNumber = 51 ];

/// 采集日期  
Property CollectDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 52 ];

/// 采集时间  
Property CollectTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 53 ];

/// 采集者  
Property CollectUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 54 ];

/// 采集部位  
Property AnatomicalSiteDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 55 ];

/// 采集部位描述  
Property CollectPositon As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 56 ];

/// 标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 57 ];

/// 采集容器  
Property ContainerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 58 ];

/// 采集说明  
Property CollectNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 59 ];

/// 24小时尿量  
Property H24UVolume As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 60 ];

/// 24小时尿量时间段  
Property H24UTimePeriod As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 61 ];

/// 采集时体温  
Property BodyTemp As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 62 ];

/// 是否保密  {1:true,0:false}
Property Confidential As %Library.Boolean [ SqlColumnNumber = 63 ];

/// 运送日期  
Property CarryDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 64 ];

/// 运送时间  
Property CarryTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 65 ];

/// 运送者  
Property CarryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 66 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 67 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 68 ];

/// 接收者  
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 69 ];

/// 接收时标本质量  
Property SpecimenQualityDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 70 ];

/// 接收说明  
Property ReceiveNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 71 ];

/// 入库日期  
Property InStorageDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 72 ];

/// 入库时间  
Property InStorageTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 73 ];

/// 入库者  
Property InStorageUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 74 ];

/// 出库日期  
Property OutStorageDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 75 ];

/// 出库时间  
Property OutStorageTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 76 ];

/// 出库者  
Property OutStorageUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 77 ];

/// 出库类型  
Property OutStorageType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 78 ];

/// 接收医院  
Property ReceiveHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 79 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 80 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 81 ];

/// 创建者  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 82 ];

/// 创建者  
Property FeeSum As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 83 ];

/// 创建类型  
Property AddType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 84 ];

/// AgeDesc  
Property AgeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 85 ];

/// 送达日期  
Property ArriveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 86 ];

/// 送达时间  
Property ArriveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 87 ];

/// 送达者  
Property ArriveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 88 ];

/// RUDiseaseDR  
Property RUDiseaseDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 89 ];

///       
Property ArriveWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 90 ];

///       
Property ConcessionFlag As %Library.Boolean [ SqlColumnNumber = 91 ];

///       
Property ICDs As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 92 ];

///       
Property IsPrintBar As %Library.Boolean [ SqlColumnNumber = 93 ];

/// 内部条码
Property LinkLabNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 94 ];

/// 混检码
Property MixLabNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 95 ];

/// 国籍
Property CountryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 96 ];

/// 第三方条码，第三方唯一主键
Property ExtLabNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 97 ];

/// 就诊卡号
Property AdmCard As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 98 ];

/// 就诊次数
Property VisitNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 99 ];

/// 32位唯一号
Property PatID As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 100 ];

/// 接收工作组      
Property ReceiveWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 101 ];

/// 标本质量说明     
Property SPQualityDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 102 ];

/// 第三方机构  
Property ExtLaboratoryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 103 ];

/// 计费类型     
Property ChargeTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 104 ];

/// 研究课题     
Property TopicDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 105 ];

Storage Default
{
<Data name="RPVisitNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>AdmissionTypeDR</Value>
</Value>
<Value name="5">
<Value>AdmNo</Value>
</Value>
<Value name="6">
<Value>MedicalRecordNo</Value>
</Value>
<Value name="7">
<Value>AdmDate</Value>
</Value>
<Value name="8">
<Value>AdmTime</Value>
</Value>
<Value name="9">
<Value>CertTypeDR</Value>
</Value>
<Value name="10">
<Value>CertNo</Value>
</Value>
<Value name="11">
<Value>IDNumber</Value>
</Value>
<Value name="12">
<Value>PaymentTypeDR</Value>
</Value>
<Value name="13">
<Value>SurName</Value>
</Value>
<Value name="14">
<Value>GivenName</Value>
</Value>
<Value name="15">
<Value>SpeciesDR</Value>
</Value>
<Value name="16">
<Value>BirthDate</Value>
</Value>
<Value name="17">
<Value>BirthTime</Value>
</Value>
<Value name="18">
<Value>Age</Value>
</Value>
<Value name="19">
<Value>AgeUnitDR</Value>
</Value>
<Value name="20">
<Value>EthnicityDR</Value>
</Value>
<Value name="21">
<Value>HospitalDR</Value>
</Value>
<Value name="22">
<Value>LocationDR</Value>
</Value>
<Value name="23">
<Value>DoctorDR</Value>
</Value>
<Value name="24">
<Value>RequestDate</Value>
</Value>
<Value name="25">
<Value>RequestTime</Value>
</Value>
<Value name="26">
<Value>WardDR</Value>
</Value>
<Value name="27">
<Value>BedNo</Value>
</Value>
<Value name="28">
<Value>Symptom</Value>
</Value>
<Value name="29">
<Value>MobileNo</Value>
</Value>
<Value name="30">
<Value>PhoneNo</Value>
</Value>
<Value name="31">
<Value>EMail</Value>
</Value>
<Value name="32">
<Value>Height</Value>
</Value>
<Value name="33">
<Value>Weight</Value>
</Value>
<Value name="34">
<Value>BloodPressure</Value>
</Value>
<Value name="35">
<Value>ClinicalConditionsDR</Value>
</Value>
<Value name="36">
<Value>LMPDate</Value>
</Value>
<Value name="37">
<Value>Pregnant</Value>
</Value>
<Value name="38">
<Value>PregnantWeeks</Value>
</Value>
<Value name="39">
<Value>AboDR</Value>
</Value>
<Value name="40">
<Value>RhDR</Value>
</Value>
<Value name="41">
<Value>Address</Value>
</Value>
<Value name="42">
<Value>PostCode</Value>
</Value>
<Value name="43">
<Value>InfectFlag</Value>
</Value>
<Value name="44">
<Value>InfectAlert</Value>
</Value>
<Value name="45">
<Value>SpecialFlag</Value>
</Value>
<Value name="46">
<Value>PregnantNum</Value>
</Value>
<Value name="47">
<Value>ChildbirthNum</Value>
</Value>
<Value name="48">
<Value>ReqNotes</Value>
</Value>
<Value name="49">
<Value>RequestNo</Value>
</Value>
<Value name="50">
<Value>Urgent</Value>
</Value>
<Value name="51">
<Value>CollectDate</Value>
</Value>
<Value name="52">
<Value>CollectTime</Value>
</Value>
<Value name="53">
<Value>CollectUserDR</Value>
</Value>
<Value name="54">
<Value>AnatomicalSiteDR</Value>
</Value>
<Value name="55">
<Value>CollectPositon</Value>
</Value>
<Value name="56">
<Value>SpecimenDR</Value>
</Value>
<Value name="57">
<Value>ContainerDR</Value>
</Value>
<Value name="58">
<Value>CollectNotes</Value>
</Value>
<Value name="59">
<Value>H24UVolume</Value>
</Value>
<Value name="60">
<Value>H24UTimePeriod</Value>
</Value>
<Value name="61">
<Value>BodyTemp</Value>
</Value>
<Value name="62">
<Value>Confidential</Value>
</Value>
<Value name="63">
<Value>CarryDate</Value>
</Value>
<Value name="64">
<Value>CarryTime</Value>
</Value>
<Value name="65">
<Value>CarryUserDR</Value>
</Value>
<Value name="66">
<Value>ReceiveDate</Value>
</Value>
<Value name="67">
<Value>ReceiveTime</Value>
</Value>
<Value name="68">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="69">
<Value>SpecimenQualityDR</Value>
</Value>
<Value name="70">
<Value>ReceiveNotes</Value>
</Value>
<Value name="71">
<Value>InStorageDate</Value>
</Value>
<Value name="72">
<Value>InStorageTime</Value>
</Value>
<Value name="73">
<Value>InStorageUserDR</Value>
</Value>
<Value name="74">
<Value>OutStorageDate</Value>
</Value>
<Value name="75">
<Value>OutStorageTime</Value>
</Value>
<Value name="76">
<Value>OutStorageUserDR</Value>
</Value>
<Value name="77">
<Value>OutStorageType</Value>
</Value>
<Value name="78">
<Value>ReceiveHospitalDR</Value>
</Value>
<Value name="79">
<Value>AddDate</Value>
</Value>
<Value name="80">
<Value>AddTime</Value>
</Value>
<Value name="81">
<Value>AddUserDR</Value>
</Value>
<Value name="82">
<Value>FeeSum</Value>
</Value>
<Value name="83">
<Value>AddType</Value>
</Value>
<Value name="84">
<Value>AgeDesc</Value>
</Value>
<Value name="85">
<Value>ArriveDate</Value>
</Value>
<Value name="86">
<Value>ArriveTime</Value>
</Value>
<Value name="87">
<Value>ArriveUserDR</Value>
</Value>
<Value name="88">
<Value>RUDiseaseDR</Value>
</Value>
<Value name="89">
<Value>ArriveWorkGroupDR</Value>
</Value>
<Value name="90">
<Value>ConcessionFlag</Value>
</Value>
<Value name="91">
<Value>ICDs</Value>
</Value>
<Value name="92">
<Value>IsPrintBar</Value>
</Value>
<Value name="93">
<Value>LinkLabNo</Value>
</Value>
<Value name="94">
<Value>MixLabNo</Value>
</Value>
<Value name="95">
<Value>CountryDR</Value>
</Value>
<Value name="96">
<Value>ExtLabNo</Value>
</Value>
<Value name="97">
<Value>AdmCard</Value>
</Value>
<Value name="98">
<Value>VisitNum</Value>
</Value>
<Value name="99">
<Value>PatID</Value>
</Value>
<Value name="100">
<Value>ReceiveWorkGroupDR</Value>
</Value>
<Value name="101">
<Value>SPQualityDesc</Value>
</Value>
<Value name="102">
<Value>ExtLaboratoryDR</Value>
</Value>
<Value name="103">
<Value>ChargeTypeDR</Value>
</Value>
<Value name="104">
<Value>TopicDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberD</DataLocation>
<DefaultData>RPVisitNumberDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

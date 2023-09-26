/// 患者就诊标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Patient Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 性别 (值:男|女|M|F)
Property sex As %String(TRUNCATE = 1, XMLNAME = "sex");

/// 患者姓名
Property name As %String(TRUNCATE = 1, XMLNAME = "name");

/// 患者证件类型
Property idtype As %String(TRUNCATE = 1, XMLNAME = "id_type");

/// 患者证件号码
Property idno As %String(TRUNCATE = 1, XMLNAME = "id_no");

/// 出生时体重,计量单位为g
Property birthweight As %String(TRUNCATE = 1, XMLNAME = "birth_weight");

/// 出生日期 yyyy-mm-dd
Property birthday As %String(TRUNCATE = 1, XMLNAME = "birthday");

/// 就诊卡号
Property medcardno As %String(TRUNCATE = 1, XMLNAME = "med_card_no");

/// 费用类型 (01:城镇职工基本医疗保险,02:城镇居民基本医疗保险,03:新型农村合作医疗,04:贫困救助,05:商业医疗保险,06:全公费,07:全自费,08:其他社会保险,99:其他)
Property paytype As %String(TRUNCATE = 1, XMLNAME = "pay_type");

/// 是否怀孕 (1:是,0:否	只能填入"1|0")
Property pregnancy As %String(TRUNCATE = 1, XMLNAME = "pregnancy");

/// 孕期,计量单位为周
Property timeofpreg As %String(TRUNCATE = 1, XMLNAME = "time_of_preg");

/// 是否哺乳 (1:是,0:否	只能填入"1|0")
Property breastfeeding As %String(TRUNCATE = 1, XMLNAME = "breast_feeding");

/// 身高,计量单位为cm
Property height As %String(TRUNCATE = 1, XMLNAME = "height");

/// 体重,计量单位为kg
Property weight As %String(TRUNCATE = 1, XMLNAME = "weight");

/// 是否透析 (1:是,0:否	只能填入"1|0")
Property dialysis As %String(TRUNCATE = 1, XMLNAME = "dialysis");

/// 病人地址
Property address As %String(TRUNCATE = 1, XMLNAME = "address");

/// 病人电话
Property phoneno As %String(TRUNCATE = 1, XMLNAME = "phone_no");

/// 患者状态
Property patientcondition As %String(TRUNCATE = 1, XMLNAME = "patient_condition");

/// 科室id --住院
Property indeptid As %String(TRUNCATE = 1, XMLNAME = "in_dept_id");

/// 科室名称  --住院
Property indeptname As %String(TRUNCATE = 1, XMLNAME = "in_dept_name");

/// 入院时间 yyyy-mm-dd hh24:mi:ss  --住院
Property hospitalizedtime As %String(TRUNCATE = 1, XMLNAME = "hospitalized_time");

/// 病区id  --住院
Property inwardid As %String(TRUNCATE = 1, XMLNAME = "in_ward_id");

/// 病区名称  --住院
Property inwardname As %String(TRUNCATE = 1, XMLNAME = "in_ward_name");

/// 病床号  --住院
Property inwardbedno As %String(TRUNCATE = 1, XMLNAME = "in_ward_bed_no");

/// 新生儿入院体重,计量单位为g  --住院
Property weightofbaby As %String(TRUNCATE = 1, XMLNAME = "weight_of_baby");

/// 就诊时间  --门急诊
Property eventtime As %String(TRUNCATE = 1, XMLNAME = "event_time");

/// 挂号科室id  --门急诊
Property deptid As %String(TRUNCATE = 1, XMLNAME = "dept_id");

/// 挂号科室名称  --门急诊
Property deptname As %String(TRUNCATE = 1, XMLNAME = "dept_name");

/// 就诊类别  --门急诊
Property visittype As %String(TRUNCATE = 1, XMLNAME = "visit_type");

/*
/// 民族 (见标版CT_Nation表Code)
Property ethnicgroup As %String(TRUNCATE = 1, XMLNAME = "ethnic_group");

/// 籍贯
Property nativeplace As %String(TRUNCATE = 1, XMLNAME = "native_place");

/// 人种
Property race As %String(TRUNCATE = 1, XMLNAME = "race");

/// 婚姻状况 (10:未婚,20:已婚,21:初婚,22:再婚,23:复婚,30:丧偶,40:离婚,90:未说明的婚姻状况)
Property marital As %String(TRUNCATE = 1, XMLNAME = "marital");

/// 职业 (11:国家公务员,13:专业技术人员,17:职员,21:企业管理人员,24:工人,27:农民,31:学生,37:现役军人,51:自由职业者,54:个体经营者,70:无业人员,80:退（离）休人员,90:其他)
Property occupation As %String(TRUNCATE = 1, XMLNAME = "occupation");

/// 入院病情 (1:有,2:临床未确定,3:情况不明,9:无)
Property incondition As %String(TRUNCATE = 1, XMLNAME = "in_condition");

/// 特殊体质,多个以"|"分隔
Property specialconstitution As %String(TRUNCATE = 1, XMLNAME = "special_constitution");

*/
}

/// 基础标签
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 医院Code
Property hospitalcode As %String(TRUNCATE = 1, XMLNAME = "hospital_code");

/// 就诊流水号,关联门诊或住院就诊信息表
Property eventno As %String(TRUNCATE = 1, XMLNAME = "event_no");

/// 患者号(院内病人唯一ID)
Property patientid As %String(TRUNCATE = 1, XMLNAME = "patient_id");

/// 来源 标识数据的来源，门诊|住院|急诊
Property source As %String(TRUNCATE = 1, XMLNAME = "source");

/// 审核接口	1:医生端,2:审方端,3:发药端,4:静配端
Property posttype As %String(TRUNCATE = 1, XMLNAME = "post_type");

}

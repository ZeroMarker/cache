Class web.DHCENS.STBLL.EMPI.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

/// 患者基本信息新
Property PATPatientInfo As web.DHCENS.STBLL.EMPI.MODEL.PaPatientNew(XMLNAME = "PATPatientInfo", XMLPROJECTION = "ELEMENT");

/// 患者基本信息
Property paPatients As list Of web.DHCENS.STBLL.EMPI.MODEL.PaPatient(XMLNAME = "PatientRegistryRt", XMLPROJECTION = "ELEMENT");

/// 住院就诊信息
Property IpPAAdms As list Of web.DHCENS.STBLL.EMPI.MODEL.IpPAAdm(XMLNAME = "InpatientEncounterStartedRt", XMLPROJECTION = "ELEMENT");

/// 门诊就诊信息
Property OpPAAdms As list Of web.DHCENS.STBLL.EMPI.MODEL.OpPAAdm(XMLNAME = "OutpatientEncounterStartedRt", XMLPROJECTION = "ELEMENT");

/// 取消住院登记信息
Property IpAdmCancel As list Of web.DHCENS.STBLL.EMPI.MODEL.AdmStatus(XMLNAME = "InpatientEncounterCancelRt", XMLPROJECTION = "ELEMENT");

/// 退号信息
Property OpAdmCancel As list Of web.DHCENS.STBLL.EMPI.MODEL.AdmStatus(XMLNAME = "OutpatientEncounterCancelRt", XMLPROJECTION = "ELEMENT");

/// 出院登记信息
Property OutCharge As list Of web.DHCENS.STBLL.EMPI.MODEL.DisCharge(XMLNAME = "InpatientDischargeRt", XMLPROJECTION = "ELEMENT");

/// 取消出院信息
Property OutChargeCancel As list Of web.DHCENS.STBLL.EMPI.MODEL.AdmStatus(XMLNAME = "InpatientDischargeCancelRt", XMLPROJECTION = "ELEMENT");

/// 卡信息
Property CreateCards As list Of web.DHCENS.STBLL.EMPI.MODEL.PaCard(XMLNAME = "CreateCardRt", XMLPROJECTION = "ELEMENT");

/// 转科
Property PatTransAdms As web.DHCENS.STBLL.EMPI.MODEL.PatTransAdm(XMLNAME = "AdmTransactionRt");

/// 诊断信息
Property diagnoseList As web.DHCENS.STBLL.EMPI.MODEL.PADiagnoseList(XMLNAME = "AddDiagnosisRt", XMLPROJECTION = "ELEMENT");

/// 短信信息
Property messInfo As web.DHCENS.STBLL.EMPI.MODEL.SMSMessageInfo(XMLNAME = "MessageInfo");

/// 过敏记录
Property PAAllergys As web.DHCENS.STBLL.EMPI.MODEL.PAAllergy(XMLNAME = "PAAllergyRt");

/// 体征信息
Property VitalSignInfoRt As web.DHCENS.STBLL.EMPI.MODEL.VitalSignInfoRt(XMLNAME = "VitalSignInfoRt");

/// 删除诊断信息
Property DeleteDiagnosisRt As web.DHCENS.STBLL.EMPI.MODEL.DeleteDiagnosList(XMLNAME = "DeleteDiagnosisRt");

}

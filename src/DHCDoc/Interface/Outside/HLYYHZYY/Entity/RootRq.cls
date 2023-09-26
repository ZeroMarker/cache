Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.RootRq Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 基础标签
Property base As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Base(XMLNAME = "base", XMLPROJECTION = "ELEMENT");

/// 就诊信息标签  住院
Property iptpatient As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Patient(XMLNAME = "ipt_patient", XMLPROJECTION = "ELEMENT");

/// 就诊信息标签  门诊
Property optpatient As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Patient(XMLNAME = "opt_patient", XMLPROJECTION = "ELEMENT");

/// 诊断信息标签  住院
Property iptdiagnoses As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Diagnoses(XMLNAME = "ipt_diagnoses", XMLPROJECTION = "ELEMENT");

/// 诊断信息标签  门诊
Property optdiagnoses As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Diagnoses(XMLNAME = "opt_diagnoses", XMLPROJECTION = "ELEMENT");

/// 过敏信息标签  住院
Property iptallergies As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Allergies(XMLNAME = "ipt_allergies", XMLPROJECTION = "ELEMENT");

/// 过敏信息标签  门诊
Property optallergies As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Allergies(XMLNAME = "opt_allergies", XMLPROJECTION = "ELEMENT");

/// 手术信息标签  住院
Property iptoperations As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Operations(XMLNAME = "ipt_operations", XMLPROJECTION = "ELEMENT");

/// 手术信息标签  门诊
Property optoperations As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Operations(XMLNAME = "opt_operations", XMLPROJECTION = "ELEMENT");

/// 医嘱信息标签  住院
Property orders As DHCDoc.Interface.Outside.HLYYHZYY.Entity.Orders(XMLNAME = "orders", XMLPROJECTION = "ELEMENT");

/// 处方及明细信息标签  门诊
Property optprescriptions As DHCDoc.Interface.Outside.HLYYHZYY.Entity.OptPrescriptions(XMLNAME = "opt_prescriptions", XMLPROJECTION = "ELEMENT");

}

Class web.DHCENS.STBLL.DRUG.MODEL.outDrugInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 门诊摆药机
Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "outDrugInfo";

/// his中用于表示患者的唯一编号
Property MzNo As %Library.String(MAXLEN = 20, XMLNAME = "Mz_No");

/// 患者姓名
Property PatientName As %Library.String(MAXLEN = 50, XMLNAME = "Patient_Name");

/// 患者年龄
Property PatientAge As %Library.String(MAXLEN = 10, XMLNAME = "Patient_Age");

/// 患者性别,男(1),女(2),其他(3)
Property PatientSex As %Library.String(MAXLEN = 2, XMLNAME = "Patient_Sex");

/// 处方的唯一编号
Property PrescriptionHISId As %Library.String(MAXLEN = 20, XMLNAME = "Prescription_HIS_Id");

/// 医生名字
Property PrescriptionDoctorName As %Library.String(MAXLEN = 30, XMLNAME = "Prescription_Doctor_Name");

/// 医嘱中的备注信息
Property PrescriptionHint As %Library.String(MAXLEN = 100, XMLNAME = "Prescription_Hint");

/// 科室病区的实际名称
Property DepartmentName As %Library.String(MAXLEN = 50, XMLNAME = "Department_Name");

/// 窗口代码
Property FetchWindow As %Library.String(MAXLEN = 20, XMLNAME = "Fetch_Window");

Property outOrderList As list Of web.DHCENS.STBLL.DRUG.MODEL.outOrder(XMLNAME = "OutOrderList");

}

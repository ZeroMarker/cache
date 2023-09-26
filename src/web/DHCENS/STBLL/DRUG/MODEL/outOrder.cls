Class web.DHCENS.STBLL.DRUG.MODEL.outOrder Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OutOrder";

/// 处方的唯一编号                                                                                                                             
Property PrescriptionHISId As %Library.String(MAXLEN = 20, XMLNAME = "Prescription_HIS_Id");

/// 药品的his编号
Property Medhisid As %Library.String(MAXLEN = 30, XMLNAME = "Med_his_id");

/// 药品规格
Property Medunit As %Library.String(MAXLEN = 50, XMLNAME = "Med_unit");

/// 药品的数量(此仅为整数)
Property MedicineNum As %Library.String(MAXLEN = 20, XMLNAME = "Medicine_Num");

/// 剩余数量
Property MedicineHeteromorphism As %Library.String(MAXLEN = 20, XMLNAME = "Medicine_Heteromorphism");

/// 药品用法及备注
Property MedicineHint As %Library.String(MAXLEN = 100, XMLNAME = "Medicine_Hint");

/// 药品产地名称
Property MEDFACTORY As %Library.String(MAXLEN = 100, XMLNAME = "MED_FACTORY");

}

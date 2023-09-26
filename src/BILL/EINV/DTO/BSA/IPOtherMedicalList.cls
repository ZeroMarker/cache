/// 住院其他医保明细列表信息
Class BILL.EINV.DTO.BSA.IPOtherMedicalList Extends %RegisteredObject
{

/// 序号
Property infoNo As %String(TRUNCATE = 1, XMLNAME = "infoNo");

/// 医保信息名称
Property infoName As %String(TRUNCATE = 1, XMLNAME = "infoName");

/// 医保信息值
Property infoValue As %String(TRUNCATE = 1, XMLNAME = "infoValue");

/// 医保其他信息
Property infoOther As %String(TRUNCATE = 1, XMLNAME = "infoOther");

}

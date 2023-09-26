/// 住院其他信息列表
Class BILL.EINV.DTO.BSA.IPOtherInfo Extends %RegisteredObject
{

/// 序号
Property infoNo As %String(TRUNCATE = 1, XMLNAME = "infoNo");

/// 扩展信息名称
Property infoName As %String(TRUNCATE = 1, XMLNAME = "infoName");

/// 扩展信息值
Property infoValue As %String(TRUNCATE = 1, XMLNAME = "infoValue");

}

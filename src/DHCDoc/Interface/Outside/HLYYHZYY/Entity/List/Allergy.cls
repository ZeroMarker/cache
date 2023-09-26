/// 过敏列表
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Allergy Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 过敏信息id
Property allergyid As %String(TRUNCATE = 1, XMLNAME = "allergy_id");

/// 过敏物名称
Property allergydrug As %String(TRUNCATE = 1, XMLNAME = "allergy_drug");

/// 过敏信息状态 (1:作废,0:正常	只能填入"1|0")
Property allergystatus As %String(TRUNCATE = 1, XMLNAME = "allergy_status");

/// 记录时间 yyyy-mm-dd hh24:mi:ss
Property recordtime As %String(TRUNCATE = 1, XMLNAME = "record_time");

/// 过敏反应
Property anaphylaxis As %String(TRUNCATE = 1, XMLNAME = "anaphylaxis");

}

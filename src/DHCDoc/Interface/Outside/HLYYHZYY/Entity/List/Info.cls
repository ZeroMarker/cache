Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Info Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "info";

/// 一条警示信息的唯一id
Property infoid As %String(TRUNCATE = 1, XMLNAME = "info_id");

/// 0:机审消息,1:人工添加消息
Property infotype As %String(TRUNCATE = 1, XMLNAME = "info_type");

/// 处方明细编号
Property recipeitemid As %String(TRUNCATE = 1, XMLNAME = "recipe_item_id");

/// 医嘱id
Property orderid As %String(TRUNCATE = 1, XMLNAME = "order_id");

/// 医嘱明细id
Property orderitemid As %String(TRUNCATE = 1, XMLNAME = "order_item_id");

/// 药品id
Property drugid As %String(TRUNCATE = 1, XMLNAME = "drug_id");

/// 药品名称
Property drugname As %String(TRUNCATE = 1, XMLNAME = "drug_name");

/// 医嘱类型
Property ordertype As %String(TRUNCATE = 1, XMLNAME = "order_type");

/// pivas标志
Property pivasflag As %String(TRUNCATE = 1, XMLNAME = "pivas_flag");

/// 错误信息
Property errorinfo As %String(TRUNCATE = 1, XMLNAME = "error_info");

/// 建议
Property advice As %String(TRUNCATE = 1, XMLNAME = "advice");

/// 来源id
Property sourceid As %String(TRUNCATE = 1, XMLNAME = "source_id");

/// 来源
Property source As %String(TRUNCATE = 1, XMLNAME = "source");

/// 消息的规则类型
Property rt As %String(TRUNCATE = 1, XMLNAME = "rt");

/// 错误等级
Property severity As %String(TRUNCATE = 1, XMLNAME = "severity");

/// 错误信息id
Property messageid As %String(TRUNCATE = 1, XMLNAME = "message_id");

/// 警示信息类型
Property type As %String(TRUNCATE = 1, XMLNAME = "type");

/// 分析类型
Property analysistype As %String(TRUNCATE = 1, XMLNAME = "analysis_type");

/// 提示类型
Property analysisresulttype As %String(TRUNCATE = 1, XMLNAME = "analysis_result_type");

}

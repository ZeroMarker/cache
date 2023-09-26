/// 处方信息
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 处方ID
Property recipeid As %String(TRUNCATE = 1, XMLNAME = "recipe_id");

/// 处方号
Property recipeno As %String(TRUNCATE = 1, XMLNAME = "recipe_no");

/// 处方来源 (门诊|急诊|其他)
Property recipesource As %String(TRUNCATE = 1, XMLNAME = "recipe_source");

/// 处方类型 (草药方|中成药方|西药方)
Property recipetype As %String(TRUNCATE = 1, XMLNAME = "recipe_type");

/// 开方科室ID
Property deptid As %String(TRUNCATE = 1, XMLNAME = "dept_id");

/// 开方科室名称
Property deptname As %String(TRUNCATE = 1, XMLNAME = "dept_name");

/// 开方医生职称
Property recipedoctitle As %String(TRUNCATE = 1, XMLNAME = "recipe_doc_title");

/// 开方医生工号
Property recipedocid As %String(TRUNCATE = 1, XMLNAME = "recipe_doc_id");

/// 开方医生姓名
Property recipedocname As %String(TRUNCATE = 1, XMLNAME = "recipe_doc_name");

/// 开方时间
Property recipetime As %String(TRUNCATE = 1, XMLNAME = "recipe_time");

/// 饮片单帖价格
Property herbunitprice As %String(TRUNCATE = 1, XMLNAME = "herb_unit_price");

/// 饮片帖数
Property herbpacketcount As %String(TRUNCATE = 1, XMLNAME = "herb_packet_count");

/// 处方金额,计量单位为元
Property recipefeetotal As %String(TRUNCATE = 1, XMLNAME = "recipe_fee_total");

/// 处方状态 (0:正常处方,1:退药处方,2 作废处方 只能填入"2|1|0")
Property recipestatus As %String(TRUNCATE = 1, XMLNAME = "recipe_status");

/// 原始处方号
Property originalrecipeid As %String(TRUNCATE = 1, XMLNAME = "original_recipe_id");

}

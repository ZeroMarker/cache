/// 饮片医嘱汇总信息
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrderInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 医嘱id
Property orderid As %String(TRUNCATE = 1, XMLNAME = "order_id");

/// 医嘱时间
Property ordertime As %String(TRUNCATE = 1, XMLNAME = "order_time");

/// 医嘱科室id
Property orderdeptid As %String(TRUNCATE = 1, XMLNAME = "order_dept_id");

/// 医嘱科室名称
Property orderdeptname As %String(TRUNCATE = 1, XMLNAME = "order_dept_name");

/// 医嘱医疗组名称
Property docgroup As %String(TRUNCATE = 1, XMLNAME = "doc_group");

/// 医嘱医生工号
Property orderdocid As %String(TRUNCATE = 1, XMLNAME = "order_doc_id");

/// 医嘱医生姓名
Property orderdocname As %String(TRUNCATE = 1, XMLNAME = "order_doc_name");

/// 医嘱医生职称  (见标版CT_CarPrvTp表Code)
Property orderdoctitle As %String(TRUNCATE = 1, XMLNAME = "order_doc_title");

/// 医嘱类型 (1:长期医嘱,2:临时医嘱,3:出院带药,9:其他)
Property ordertype As %String(TRUNCATE = 1, XMLNAME = "order_type");

/// 饮片单帖价格
Property herbunitprice As %String(TRUNCATE = 1, XMLNAME = "herb_unit_price");

/// 饮片帖数
Property herbpacketcount As %String(TRUNCATE = 1, XMLNAME = "herb_packet_count");

/// 复核时间
Property checktime As %String(TRUNCATE = 1, XMLNAME = "check_time");

/// 复核护士工号
Property checknurseid As %String(TRUNCATE = 1, XMLNAME = "check_nurse_id");

/// 复核护士姓名
Property checknursename As %String(TRUNCATE = 1, XMLNAME = "check_nurse_name");

/// 医嘱生效时间
Property ordervalidtime As %String(TRUNCATE = 1, XMLNAME = "order_valid_time");

/// 医嘱失效时间
Property orderinvalidtime As %String(TRUNCATE = 1, XMLNAME = "order_invalid_time");

/// 医嘱停止标志
Property stopflag As %String(TRUNCATE = 1, XMLNAME = "stop_flag");

/// 紧急标志 (1:是,0:否	只能填入"1|0")
Property urgentflag As %String(TRUNCATE = 1, XMLNAME = "urgent_flag");

}

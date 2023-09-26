Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.Message Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 处方id
Property recipeid As %String(TRUNCATE = 1, XMLNAME = "recipe_id");

/// 组号
Property groupno As %String(TRUNCATE = 1, XMLNAME = "group_no");

/// 医嘱医生工号
Property orderdocid As %String(TRUNCATE = 1, XMLNAME = "order_doc_id");

/// 医嘱医生姓名
Property orderdocname As %String(TRUNCATE = 1, XMLNAME = "order_doc_name");

/// 是否草药医嘱	1:是,0:否
Property isherb As %String(TRUNCATE = 1, XMLNAME = "is_herb");

/// 成功标识	0:审核不通过,1:审核通过,2:超时通过,3:自动通过,5:失效药嘱通过,6:进行待审
Property issuccess As %String(TRUNCATE = 1, XMLNAME = "is_success");

/// 状态	1:可双签名或修改,0:必须修改,2:审核通过不做处理
Property status As %String(TRUNCATE = 1, XMLNAME = "status");

/// 提示信息
Property infos As list Of DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Info(XMLNAME = "infos");

}

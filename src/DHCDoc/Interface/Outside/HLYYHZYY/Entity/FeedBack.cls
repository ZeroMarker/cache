Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.FeedBack Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 处方id
Property recipeid As %String(TRUNCATE = 1, XMLNAME = "recipe_id");

/// 组号
Property groupno As %String(TRUNCATE = 1, XMLNAME = "group_no");

/// 是否草药医嘱	1:是,0:否
Property isherb As %String(TRUNCATE = 1, XMLNAME = "is_herb");

/// 医生留言
Property message As %String(TRUNCATE = 1, XMLNAME = "message");

/// 状态	1:双签名确认
Property status As %String(TRUNCATE = 1, XMLNAME = "status");

}

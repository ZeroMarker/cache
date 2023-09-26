/// 手术列表
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.Operation Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 手术id
Property operationid As %String(TRUNCATE = 1, XMLNAME = "operation_id");

/// 手术编码
Property operationcode As %String(TRUNCATE = 1, XMLNAME = "operation_code");

/// 手术名称
Property operationname As %String(TRUNCATE = 1, XMLNAME = "operation_name");

/// 手术开始时间	格式：yyyy-mm-dd hh24:mi:ss
Property operationstarttime As %String(TRUNCATE = 1, XMLNAME = "operation_start_time");

/// 手术结束时间	格式：yyyy-mm-dd hh24:mi:ss
Property operationendtime As %String(TRUNCATE = 1, XMLNAME = "operation_end_time");

/// 切口类型
/// 0:0类切口,有手术,但体表无切口或腔镜手术切口;Ⅰ:Ⅰ类切口,无菌切口;Ⅱ:Ⅱ类切口,沾染切口;Ⅲ:Ⅲ类切口,感染切口
Property operationincisiontype As %String(TRUNCATE = 1, XMLNAME = "operation_incision_type");

/// 是否有植入物	1:是;0:否
Property isimplant As %String(TRUNCATE = 1, XMLNAME = "is_implant");

}

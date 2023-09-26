Class web.DHCENS.STBLL.MDMR2.Model.BusinessField Extends (%RegisteredObject, %XML.Adaptor)
{

/// 业务域
Parameter BusinessFieldCode = 00001;

/// IP地址
Parameter IP = "211.101.232.11";

/// 端口
Parameter Port = 9002;

/// 字典推送REST服务地址
Parameter DictUrl = "http://211.101.232.11:9003/api/dict/general";

/// 患者信息推送REST服务地址
Parameter PatUrl = "http://211.101.232.11:9003/api/patient/add";

}

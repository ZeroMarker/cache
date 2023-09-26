Class web.DHCENS.STBLL.EMPI.MODEL.PARelation Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "PATRelation";

/// 患者联系人关系代码
Property PATRelationCode As %Library.String(MAXLEN = 10, XMLNAME = "PATRelationCode");

/// 患者联系人关系描述
Property PATRelationDesc As %Library.String(MAXLEN = 20, XMLNAME = "PATRelationDesc");

/// 患者联系人姓名
Property PATRelationName As %Library.String(MAXLEN = 50, XMLNAME = "PATRelationName");

/// 患者联系人电话
Property PATRelationPhone As %Library.String(MAXLEN = 20, XMLNAME = "PATRelationPhone");

/// 患者联系人地址信息
Property PAAddress As list Of web.DHCENS.STBLL.EMPI.MODEL.RelationAddress(XMLNAME = "PATRelationAddressList");

}

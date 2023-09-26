Class web.DHCEkg.HuoShenShan.Dict.OrdRequest Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "root";

/// 查询医嘱请求
Property query As web.DHCEkg.HuoShenShan.Dict.OrdQuery;

/// 查询结果
Property result As web.DHCEkg.HuoShenShan.Dict.OrdResult;

/// 医嘱列表
Property records As list Of web.DHCEkg.HuoShenShan.Dict.OrdRecord;

}

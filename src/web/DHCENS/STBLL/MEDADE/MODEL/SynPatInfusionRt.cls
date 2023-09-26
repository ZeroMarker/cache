Class web.DHCENS.STBLL.MEDADE.MODEL.SynPatInfusionRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "SynBloodRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 就诊号
Property encounterId As %Library.String(XMLNAME = "encounterId");

/// 输血编号或者条形码
Property bloodTransfusionNumber As %Library.String(XMLNAME = "bloodTransfusionNumber");

/// 血液成分（品名）
Property bloodComponents As %Library.String(XMLNAME = "bloodComponents");

/// 血型（ABO）
Property bloodType As %Library.String(XMLNAME = "bloodType");

/// Rh（D）
Property rhd As %Library.String(XMLNAME = "rhd");

/// 血量（U/治疗量）
Property bloodAmount As %Library.String(XMLNAME = "bloodAmount");

/// 输血开始时间
Property bloodTranStartTime As %Library.String(XMLNAME = "bloodTranStartTime");

/// 输血结束时间
Property bloodTranEndTime As %Library.String(XMLNAME = "bloodTranEndTime");

/// 操作标识
Property flag As %Library.String(XMLNAME = "flag");

}

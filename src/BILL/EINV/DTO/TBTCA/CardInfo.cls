Class BILL.EINV.DTO.TBTCA.CardInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 卡类别拼音首字母(身份证 sfz、医保卡 ybk、健康卡 jkk、就诊卡 jzk)
Property CardType As %String(XMLPROJECTION = "ELEMENT");

/// 卡号
Property CardNum As %String(XMLPROJECTION = "ELEMENT");

/// 备注
Property Remark As %String(XMLPROJECTION = "ELEMENT");

}

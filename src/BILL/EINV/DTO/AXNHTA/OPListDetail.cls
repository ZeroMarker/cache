Class BILL.EINV.DTO.AXNHTA.OPListDetail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

Property prodnr As %String(CAPTION = "商品编号");

Property prodname As %String(CAPTION = "商品名称");

Property spec As %String(CAPTION = "规格型号");

Property unit As %String(CAPTION = "计量单位");

/// 药品分类编码01，有则填写
Property quantity As %String(CAPTION = "数量");

Property pirce As %String(CAPTION = "单价");

Property amount As %String(CAPTION = "金额");

/// 例3%为.03  17%为.17  6%为.06
Property taxrate As %String(CAPTION = "税率");

Property tax As %String(CAPTION = "税额");

/// 0-不含税，1–含税(invkind=41卷票情况，必须为含税1)
Property includetax As %String(CAPTION = "是否含税");

/// 判断是否含税看includetax),红冲单据无折扣金额
Property discountvalue As %String(CAPTION = "折扣金额");

/// （如果为空，系统自行计算）
Property discounttax As %String(CAPTION = "折扣税额，红冲单据无折扣税额");

Property goodsnover As %String(CAPTION = "编码版本号,默认填写12.0");

Property goodstaxno As %String(CAPTION = "在税局相关政策文件规定的税收分类编码表中选取本单位产品所对应的税收分类编码");

Property taxpre As %String(CAPTION = "是否享受优惠政策;0或者空:不享受，1:享受");

Property taxprecon As %String(CAPTION = "享受税收优惠政策内容(按税局相关政策文件规定内容填写)");

Property zerotax As %String(CAPTION = "零税率标识;空：非零税率，0：出口退税，1：免税，2：不征收，3 普通零税率");

}

Class BILL.EINV.DTO.YDA.EInvoiceContentInfoDetailsReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 		<![CDATA[商品名称]]
Property GoodsName As %String(TRUNCATE = 1);

/// 			<![CDATA[规格型号]]>
Property Standard As %String(TRUNCATE = 1);

/// 			<![CDATA[计量单位]]>
Property Unit As %String(TRUNCATE = 1);

/// 			数量
Property Number As %String(TRUNCATE = 1);

/// 			单价
Property Price As %String(TRUNCATE = 1);

/// 			金额
Property Amount As %String(TRUNCATE = 1);

/// 			含税标志:0-不含税,1-含税
Property PriceKind As %String(TRUNCATE = 1);

/// 			税额
Property TaxAmount As %String(TRUNCATE = 1);

/// 			税率，17，13，6
Property TaxRate As %String(TRUNCATE = 1);

/// 			编码版本号
Property GoodsNoVer As %String(TRUNCATE = 1);

/// 			税收分类编码
Property GoodsTaxNo As %String(TRUNCATE = 1);

/// 			是否享受税收优惠政策<!--0：不享受，1：享受-->
Property TaxPre As %String(TRUNCATE = 1);

/// 			<![CDATA[]]>
Property TaxPreCon As %String(TRUNCATE = 1);

/// 			零税率标识空< !-- 零税率标识  空：非零税率，0：出口退税，1：免税，2：不征收，3 普通零税率 -->
Property ZeroTax As %String(TRUNCATE = 1);

/// 			企业自编码
Property CropGoodsNo As %String(TRUNCATE = 1);

/// 			扣除额
Property TaxDeduction As %String(TRUNCATE = 1);

}

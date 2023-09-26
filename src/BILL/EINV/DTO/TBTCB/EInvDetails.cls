/// 明细数据List
Class BILL.EINV.DTO.TBTCB.EInvDetails Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

/// Zid	自 增顺序 号	Number	16	是	自增顺序号，每次自动增 1，入库顺序
Property Zid As %String(XMLPROJECTION = "ELEMENT");

/// Organ	机构代码	Varchar	4	是	财政分配Organ+ SettlementNo
Property Organ As %String(XMLPROJECTION = "ELEMENT");

/// SettlementNo	结算号	Varchar	32	是	建主索引
Property SettlementNo As %String(XMLPROJECTION = "ELEMENT");

/// Sjlx	票据类型	Varchar	2	是	1.门诊，2.住院	
Property Sjlx As %String(XMLPROJECTION = "ELEMENT");

/// ItemCode	收费项目 代码	Varchar	20	是	医疗收费项目信息 T_YLSFXMXX 中对应的 ItemCode 收费大类代码(财政)
Property ItemCode As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtClassName	收费项目 名称	Varchar	200	是	医疗收费项目信息 T_YLSFXMXX 中对应的 Itemname 收费大类名称（如：治疗费）
Property ItemExtClassName As %String(XMLPROJECTION = "ELEMENT");

/// ItemQuantity	数量	Number	16,4	是	
Property ItemQuantity As %String(XMLPROJECTION = "ELEMENT");

/// ItemUnit	计量单位	Varchar	20
Property ItemUnit As %String(XMLPROJECTION = "ELEMENT");

/// ItemStd	标准	Number	16,4	是	
Property ItemStd As %String(XMLPROJECTION = "ELEMENT");

/// ItemAmount	金额	Number	16,2	是	收费明细项目编码需要使用浙江省统一的医保目录编码（药品、诊疗、服务），无论是否进医保或者自费都一样，统一使用医保目录编码
/// ，除医保目录内没有可对应的编码外，不可对应自费通用编码，具体咨询 his 或者医院医保部门。
Property ItemAmount As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtId	收费明细项目编码	Varchar	30	是	
Property ItemExtId As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtClassId	项目类别 ID	Varchar	32	是
Property ItemExtClassId As %String(XMLPROJECTION = "ELEMENT");

/// ItemName	收费明细项目名称	Varchar	100	是	需与医保结算系统编码一致
Property ItemName As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtClassify	类	Varchar	20	是	收费明细项目对应的“类”甲 乙 丙
Property ItemExtClassify As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtSelfPay	自理自费 金额	Number	16,2	是	
Property ItemExtSelfPay As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtSelfProportion	自理自费 比率	Number	16,2	是	
Property ItemExtSelfProportion As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtAccountCode	会计科目代码	Varchar	20	
Property ItemExtAccountCode As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtAccountName	会计科目名称	Varchar	200	
Property ItemExtAccountName As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtDeptName	开单科室名称	Varchar	200	
Property ItemExtDeptName As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtDeptAccountCode	科室核算码	Varchar	20
Property ItemExtDeptAccountCode As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtDeptAccountName	科室核算码名称	Varchar	200	
Property ItemExtDeptAccountName As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtExcuteDeptName	执行科室 名称	Varchar	200	
Property ItemExtExcuteDeptName As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtDrawer	开单人	Varchar	50
Property ItemExtDrawer As %String(XMLPROJECTION = "ELEMENT");

/// ItemExtExecutor	执行人	Varchar	50
Property ItemExtExecutor As %String(XMLPROJECTION = "ELEMENT");

/// Rksj	记录写库 当前时间	Varchar	17	是	yyyyMMddHHmmssSSS年月日时分秒毫秒
Property Rksj As %String(XMLPROJECTION = "ELEMENT");

/// Itemtype	项目类型	Varchar	1	是	1、财政主项目传“0”；2、明细(医保)子项目传“1” 。
Property Itemtype As %String(XMLPROJECTION = "ELEMENT");

/// Remark	项目备注	Varchar	500	
Property Remark As %String(XMLPROJECTION = "ELEMENT");

/// Autotime	默认数据 库服务器 时间	date			Yyyy-mm-dd-hh:mm:ss
Property Autotime As %String(XMLPROJECTION = "ELEMENT");

}

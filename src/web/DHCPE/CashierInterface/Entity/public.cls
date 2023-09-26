Class web.DHCPE.CashierInterface.Entity.public Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

/// 版本号(默认：1.0.0.2)
Parameter version = "1.0.0.2";

/// 系统类型(默认：1)
Parameter Systype = 1;

/// 单位校验KEY(根据票据系统)
Parameter key = "b055e43b0bbe7e82fb2b03babc09d489";

/// 转入票据信息接口方法
Parameter InvoiceBill = "InvoiceBill";

/// 作废已开具的票据接口方法
Parameter InvalidBill = "InvalidBill";

/// 作废一张空白票据号接口方法
Parameter InvalidBillNo = "InvalidBillNo";

/// 	门诊发票票据类型，一般是纸质发票上发票号的前五位
Parameter MZPJLX = 050.01;

/// 	住院发票票据类型，一般是纸质发票上发票号的前五位
Parameter ZYPJLX = 051.01;

/// 票别号(默认为国财)
Parameter PBH = "国财";

/// 医疗机构代码
Parameter HosCode = 400012916;

/// 开票点
Parameter Ivcnode = 001;

}

/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:病人基本信息类
Class web.DHCEntity.PCA.AutoPayPatInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// 登记号
Property PatNO As %String(TRUNCATE = 1);

/// 病人姓名
Property PatName As %String(TRUNCATE = 1);

/// 年龄
Property PatAge As %String(TRUNCATE = 1);

/// 性别
Property PatSex As %String(TRUNCATE = 1);

/// 账户Rowid
Property AccMRowID As %String(TRUNCATE = 1);

/// 开户日期
Property AccMOCDate As %String(TRUNCATE = 1);

/// 开户开户时间
Property AccMOCTime As %String(TRUNCATE = 1);

/// 账户余额
Property AccMBalance As %String(TRUNCATE = 1);

/// 账户透支额度
Property AccMDepPrice As %String(TRUNCATE = 1);

/// 账户状态
Property AccMAccStatus As %String(TRUNCATE = 1);

}

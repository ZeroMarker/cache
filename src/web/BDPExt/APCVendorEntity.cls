/// Creator:陈莹 
/// CreatDate:2017-3-14
/// Description:供应商导入实体类
Class web.BDPExt.APCVendorEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.APCVendorEntity";

/// rowid
Property vrowid As %String;

/// 代码
Property vCode As %String;

/// 描述
Property vName As %String;

/// 简称
Property vShortName As %String;

/// 别名
Property vAlias As %String;

/// 类型(G药品、M物资材料)
Property vType As %String;

/// 电话
Property vTel As %String;

/// 地址
Property vAddress As %String;

/// 通用标志  2017-3-23   2021-01-27不导了
Property vUniversal As %String;

/// 营业执照号 2021-01-27
Property vComLic As %String;

/// 营业执照开始日期
Property vComLicDateFrom As %String;

/// 营业执照截止日期
Property vComLicDateTo As %String;

/// 经营许可证编号
Property vInsBusLic As %String;

/// 经营许可起始日期
Property vInsBusLicDateFrom As %String;

/// 经营许可截止日期
Property vInsBusLicDateTo As %String;

/// 二类经营备案号
Property vSecondBusLic As %String;

/// 二类经营备案起始日期
Property vSecondBusLicDateFrom As %String;

/// 二类经营备案截止日期
Property vSecondBusLicDateTo As %String;

}

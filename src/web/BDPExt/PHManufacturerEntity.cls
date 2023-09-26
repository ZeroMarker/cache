/// Creator:陈莹 
/// CreatDate:2017-3-14
/// Description:厂商导入实体类
Class web.BDPExt.PHManufacturerEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.PHManufacturerEntity";

/// rowid
Property mrowid As %String;

/// 代码
Property mCode As %String;

/// 描述
Property mName As %String;

/// 简称
Property mShortName As %String;

/// 别名
Property mAlias As %String;

/// 类型(G药品、M物资材料)
Property mType As %String;

/// 电话
Property mTel As %String;

/// 地址
Property mAddress As %String;

/// 营业执照号 2021-01-26
Property mComLic As %String;

/// 营业执照开始日期
Property mComLicDateFrom As %String;

/// 营业执照截止日期
Property mComLicDateTo As %String;

/// 器械生产许可号
Property mInsProLic As %String;

/// 器械生产许可起始日期
Property mInsProLicDateFrom As %String;

/// 器械生产许可截止日期
Property mInsProLicDateTo As %String;

/// 一类器械生产备案号
Property mFirstProdLic As %String;

/// 一类器械生产备案起始日期
Property mFirstProdLicDateFrom As %String;

/// 一类器械生产备案截止日期
Property mFirstProdLicDateTo As %String;

}

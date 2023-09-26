Class web.DHCPE.Interface.BaArea.Entity.TempReportInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 体检编号，并且保证唯一性
Property recordno As %String;

/// 体检时间
Property recordtime As %String;

/// 总检状态 1.是 2.否
Property recordstate As %String;

/// 姓名
Property username As %String;

/// 客户编号，没有赋值时使用体检编号作为客户编号使用
Property userno As %String;

/// 性别 1.男 2.女
Property gender As %String;

/// 年龄，不用赋值
Property age As %Integer;

/// 出生日期 格式:yyyy-MM-dd
Property birthday As %String;

/// 身份证号
Property cardno As %String;

/// 手机号码
Property phonenumber As %String;

/// 电话号码
Property telephone As %String;

/// 电子邮件
Property email As %String;

/// 民族 建议为空
Property nationalty As %String;

/// 单位
Property workunit As %String;

/// 血型 建议为空
Property bloodtype As %String;

/// 地址
Property address As %String;

/// 个人空间登录密码，没有赋值时使用体检编号作为登录密码
Property loginname As %String;

/// 个人空间密码，没有赋值时随机6位密码
Property loginpwd As %String;

/// 职业 建议为空
Property profession As %String;

/// 婚姻状态 建议为空
Property matrimony As %String;

/// 学历 建立为空
Property degreeeducation As %String;

/// 总结结论
Property summarize As %String;

/// 建议
Property advice As %String;

/// 是否评估  赋值为1
Property isaccess As %String;

/// 服务验证对象
Property serverLogin As web.DHCPE.Interface.BaArea.Entity.WebServerLogin;

/// 体检异常集合对象
Property reportAbnormalS As list Of web.DHCPE.Interface.BaArea.Entity.TempReportAbnormal;

/// 体检小结集合对象
Property reportConclusionS As list Of web.DHCPE.Interface.BaArea.Entity.TempReportConclusion;

/// 体检项目集合对象
Property reportItemS As list Of web.DHCPE.Interface.BaArea.Entity.TempReportItem;

/// 赋值为2
Property isRepeat As %Integer;

/// 赋值为2
Property isUpdate As %Integer;

/// 赋值为2
Property isUpdateReport As %Integer;

}

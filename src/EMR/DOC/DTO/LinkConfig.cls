Class EMR.DOC.DTO.LinkConfig Extends %RegisteredObject
{

/// 项目标识
Property Product As %String;

/// 链接类型编码
Property Code As %String(TRUNCATE = 1);

/// 类型名称
Property Name As %String(TRUNCATE = 1);

/// 链接数据
Property Src As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 对应页面上保存至病历按钮事件writeBack中的取值方法
Property Method As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 显示及引用格式
Property Scheme As %String(MAXLEN = 3000, TRUNCATE = 1);

/// 是否直接打开链接地址页面，不通过iframe打开(Y 直接打开/N 通过iframe打开)
Property IsDirectOpen As %String(TRUNCATE = 1);

}

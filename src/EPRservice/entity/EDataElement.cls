/// 名称：		EPRservice.entity.EDataElement
/// 描述：		数据元持久化类类
/// 编写者：	yejian
/// 编写时间：	2012-7-10
Class EPRservice.entity.EDataElement Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 建立数据元目录ID
Property CategoryID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 数据元标示符
Property Entifier As %String(MAXLEN = 50, TRUNCATE = 1);

/// 术语名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1);

/// 版本
Property Versions As %String(MAXLEN = 20, TRUNCATE = 1);

/// 注册机构
Property RegOrgan As %String(MAXLEN = 100, TRUNCATE = 1);

/// 相关环境
Property Environment As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定义
Property Definition As %String(MAXLEN = 200, TRUNCATE = 1);

/// 分类模式
Property ClassModle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据元值数据类型
Property DataType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 表示格式
Property Format As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据元允许值
Property DEVID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管机构
Property ResOrgan As %String(MAXLEN = 100, TRUNCATE = 1);

/// 注册状态
Property State As %String(MAXLEN = 100, TRUNCATE = 1);

/// 提交机构
Property PutInOrgan As %String(MAXLEN = 100, TRUNCATE = 1);

}

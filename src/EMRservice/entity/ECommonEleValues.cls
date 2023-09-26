Class EMRservice.entity.ECommonEleValues Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 数据元类型
Property ElemType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据值域标示符
Property Code As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property DisplayName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 绑定类型
Property BindType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 绑定值
Property BindCode As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 是否同步
Property Synch As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否为空
Property AllowNull As %String(MAXLEN = 100, TRUNCATE = 1);

/// 校验信息
Property ValidateMsg As %String(MAXLEN = 100, TRUNCATE = 1);

/// 正则表达式
Property RegExp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最长值
Property MaxLength As %String(MAXLEN = 100, TRUNCATE = 1);

/// 保密级别
Property ConfidentialityCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否只读
Property ReadOnly As %String(MAXLEN = 100, TRUNCATE = 1);

/// tabIndex
Property TabIndex As %String(MAXLEN = 100, TRUNCATE = 1);

/// 固定结构
Property FixedStructs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否可见
Property Visible As %String(MAXLEN = 100, TRUNCATE = 1);

/// 动态字段，主要用于解决页眉中床位号、科室等可能改变的业务需求
Property DynamicField As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否包含日期
Property IncludeDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否包含时间
Property IncludeTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期格式
Property DateFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 时间格式
Property TimeFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最小值
Property MinVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 最大值
Property MaxVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有最小值
Property HasMinVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有最大值
Property HasMaxVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 包含最小值
Property IncludeMin As %String(MAXLEN = 100, TRUNCATE = 1);

/// 包含最大值
Property IncludeMax As %String(MAXLEN = 100, TRUNCATE = 1);

/// 小数点位数
Property DecimalPlace As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备选项强制换行
Property WrapChoice As %String(MAXLEN = 100, TRUNCATE = 1);

/// 选择列表集
Property Choices As %String(MAXLEN = 3000, TRUNCATE = 1);

/// 字典类型
Property DictionaryType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准字典Code
Property CodeSystem As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标准字典Name
Property CodeSystemName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 自定义字典名
Property CustDicClassName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示类型
Property DisplayType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示分格符
Property Separator As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果1列类型
Property FirstColType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果2列类型
Property SecondColType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果3列类型
Property ThirdColType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 允许使用非标准字典代码(I)
Property AllowCodeNull As %String(MAXLEN = 100, TRUNCATE = 1);

/// 允许使用非标准字典描述(I)
Property AllowValueNull As %String(MAXLEN = 100, TRUNCATE = 1);

/// 查询条件单元
Property AssociateItem As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否可编辑
Property AllowEdit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联字典编码
Property LinkCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 关联显示类型
Property LinkDisplayType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 链接方式
Property LinkMethod As %String(MAXLEN = 100, TRUNCATE = 1);

/// 签名级别
Property SignatureLevel As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否显示未选中项
Property ShowUnChecked As %String(MAXLEN = 100, TRUNCATE = 1);

/// 未选中项前缀
Property UncheckedPrefix As %String(MAXLEN = 100, TRUNCATE = 1);

/// 选中项前缀
Property CheckedPrefix As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否逐项加前缀
Property OneByOneLink As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板编码
Property TemplateCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板名称
Property TemplateName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节编码
Property SectionCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 章节维护模板章节名称
Property SectionName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示职称(签名者描述)
Property ShowSignerDescription As %String(MAXLEN = 100, TRUNCATE = 1);

/// 头像关联路径
Property HeaderImageCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 指纹关联路径
Property FingerImageCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否绑定图片
Property IsBindImage As %String(MAXLEN = 200, TRUNCATE = 1);

/// 静默同步
Property SilentSynch As %String(MAXLEN = 200, TRUNCATE = 1);

}

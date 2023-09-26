Class EMRservice.entity.EMedicalConceptValues Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 目录ID
Property CategoryID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 数据值域标示符
Property Code As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值含义
Property DisplayName As %String(MAXLEN = 500, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果1列类型
Property AllowInput As %String(MAXLEN = 100, TRUNCATE = 1);

/// 固定结构
Property FixedStructs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字字体
Property FontName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字大小
Property FontSize As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字粗细
Property FontWeight As %String(MAXLEN = 100, TRUNCATE = 1);

/// 斜体
Property FontStyle As %String(MAXLEN = 100, TRUNCATE = 1);

/// 文字颜色
Property TextColor As %String(MAXLEN = 100, TRUNCATE = 1);

Property SubItems As %GlobalBinaryStream(LOCATION = "^DHCEMRM.MedConceptVS");

}

Class DHCDoc.DHCDocCure.Entity.AssScore Extends (%RegisteredObject, %XML.Adaptor)
{

/// 创建用户ID
Property DCASCreateUserDR As %String(TRUNCATE = 1);

/// 创建用户姓名
Property DCASCreateUserName As %String(TRUNCATE = 1);

/// 创建日期时间
Property DCASCreateDateTime As %String(TRUNCATE = 1);

/// 量表ID
Property DCASScoreID As %String(TRUNCATE = 1);

/// 评分分值
Property DCASScoreVal As %String(TRUNCATE = 1);

/// 评定状态
Property DCASStatus As %String(TRUNCATE = 1);

/// 表单元素内容
Property DCASFormJsonStr As %String(TRUNCATE = 1);

}

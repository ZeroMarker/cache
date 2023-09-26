/// 项目：重庆人民医院，添加专项护理字典维护界面
/// 表名：CTSpecialNursing
/// 描述：专项护理字典表 Entity
/// 编写者：基础数据平台组 李可凡
/// 编写日期: 2019年8月22日
Class web.Entity.CT.CTSpecialNursing Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTSpecialNursing";

/// RowId
Property SpecialNursingRowId As %String;

/// 代码
Property SpecialNursingCode As %String;

/// 描述
Property SpecialNursingDesc As %String;

/// 备注
Property SpecialNursingRemark As %String;

}

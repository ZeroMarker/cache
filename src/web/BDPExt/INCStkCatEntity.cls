Class web.BDPExt.INCStkCatEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.BDPExt.INCStkCatEntity";

/// scrowid
Property scrowid As %String;

/// 库存类组归类(物资材料用)  医用材料/后勤材料/试剂/固定资产
Property scSet As %String;

/// 库存类组代码
Property scSGCode As %String;

/// 库存类组描述
Property scSGDesc As %String;

/// 库存分类代码
Property scSCCode As %String;

/// 库存分类描述)
Property scSCDesc As %String;

/// 库存类组类型（G药物、M材料物资）
Property scStkType As %String;

/// 医嘱模式 2018-11-18 一对多(->Y)、一对一(->N)
Property scSGStruModeFlag As %String;

}
